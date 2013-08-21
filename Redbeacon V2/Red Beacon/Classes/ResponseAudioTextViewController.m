//
//  ResponseAudioTextViewController.m
//  Red Beacon
//
//  Created by sudeep on 17/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "ResponseAudioTextViewController.h"
#import "RBCurrentJobResponse.h"
#import "RBAlertMessageHandler.h"

#define AS_FAILED_UPDATE_TEXT_JOB_REQ_ALERT_MESSAGE @"Job text updation is failed Do you want to continue?"
#define NO_AUDIO_AVAILABLE @"This Job Request has no audio description"

@interface ResponseAudioTextViewController (Private)

- (void)hideOverlay;
- (void)showJobViewController;
- (void)handleJobTextUpdationAPI;

@end

@implementation ResponseAudioTextViewController
@synthesize overlay;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    //jobEditRequestResponse = nil;
    [super dealloc];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



-(IBAction)cancelButtonClicked:(id)sender {
    
    [super destroyTheStreamer];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneButtonClicked:(id)sender 
{
    [self handleJobTextUpdationAPI];

}

- (void)handleJobTextUpdationAPI
{
    [ super dismissKeyBoard];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    if (!jobEditRequestResponse)
    {
        jobEditRequestResponse = [[RBJobBidAndProviderDetailHandler alloc] init];
    }
    
    jobEditRequestResponse.delegate = self;
    
    Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                      withMessage:@"Updating job details..." 
                                         animated:YES];
    [jobEditRequestResponse sendJobDetailsRequestWithJobId:[super jobResponse] 
                                                andDetails:[super saveEditText]];
    
    if (pool) 
        [pool drain];
}

#pragma mark - RBBaseHTTPHandler Delegate
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request
{
    //reload the table after the response complete
    do
    {
        RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
        if (requestType == kSendJobDetails) 
        {
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSDictionary * responseDictionary = [responseString JSONValue];
            
            BOOL response =[[responseDictionary objectForKey:@"success"] boolValue];
            
            if (response) {
                
                [self showJobViewController];
            }
            else
            {
                // Some error occurred
                [self hideOverlay];
                NSString * title = @"Redbeacon";
                [RBAlertMessageHandler showAlertWithTitle:title
                                                  message:AS_FAILED_UPDATE_TEXT_JOB_REQ_ALERT_MESSAGE 
                                           delegateObject:self
                                                  viewTag:kSendJobDetails 
                                         otherButtonTitle:@"OK" 
                                               showCancel:YES];
            }
        }    
        
    } while (0);  
    
    [self hideOverlay];
    
}

- (void)requestCompletedWithErrors:(ASIHTTPRequest*)request 
{
    
    //error in response
    
}

#pragma mark - Overlay Method
- (void)hideOverlay {
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
}

- (void)showJobViewController
{
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    JobResponseDetails *jobDetails = [rBCurrentJobResponse jobResponse];
    jobDetails.jodDetails = [self saveEditText];
    
    [rBCurrentJobResponse setJobResponse:jobDetails];

    [[self navigationController] popViewControllerAnimated:YES];

    
}

#pragma mark -

#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kSendJobDetails) 
    {
        //DISCARD MEDIAS OR NOT
        if (buttonIndex == 0)
        {
            [self handleJobTextUpdationAPI];
        }
        else
        {
            [self showJobViewController];
        }
    }
}

-(void)showNoAudioAlert {
    
    NSString * title = @"Redbeacon";
    [RBAlertMessageHandler showAlertWithTitle:title
                                      message:NO_AUDIO_AVAILABLE 
                               delegateObject:nil
                                      viewTag:kSendJobDetails 
                             otherButtonTitle:@"OK" 
                                   showCancel:NO];
}


- (void)onSegmentedControlChanged:(UISegmentedControl *) sender {
    
    self.temporaryTextDescription = [super textViewContent];
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    JobResponseDetails *jobDetails = [rBCurrentJobResponse jobResponse];
    if (super.segmentedControl.selectedSegmentIndex == 0) {
        if([jobDetails isAudioDescriptionPresent])
            [super onSegmentedControlChanged:sender];
        else {
            [self showNoAudioAlert];
            [sender setSelectedSegmentIndex:1];
        }
    }
    else {
        [super destroyTheStreamer];
        [super onSegmentedControlChanged:sender];
        
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
