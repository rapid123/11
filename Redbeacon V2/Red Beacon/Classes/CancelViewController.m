//
//  CancelViewController.m
//  Red Beacon
//
//  Created by Nithin George on 17/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CancelViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "RBCurrentJobResponse.h"
#import "RBAlertMessageHandler.h"
#import "JobBids.h"

#define KCancelSuceessResponseTag 1

#define BID_CANCEL_APPOINTMENT_RESON @"reject" 
#define AS_FAILED_LOADING_JOB_CACELLATION_SUCCESS_ALERT_MESSAGE @"Job cancellation is  successful"     
#define NavigationButtonBackgroundImage @"navigationButton_background.png"
#define BACK_BUTTON_TITTLE @"Back"
#define DONE_BUTTON_TITTLE @"Done"
#define DONE_BUTTON_IMAGE @"DoneButton.png"

#define AS_FAILED_CANCEL_JOB_REQ_ALERT_MESSAGE @"Job cancellation is failed. Do you want to continue?"
#define CANCELJOB_NAVIGATION_TITLE @"Help us improve"
#define TABLE_SECTION0_HEADER @"Tell us why you canceled"
#define TABLE_SECTION0_ROW0_TEXT @"Already booked a Redbeacon Pro"
#define TABLE_SECTION0_ROW1_TEXT @"Found someone outside Redbeacon"
#define TABLE_SECTION0_ROW2_TEXT @"Prices were too high"
#define TABLE_SECTION0_ROW3_TEXT @"Pros profiles wheren't good enough "
#define TABLE_SECTION0_ROW4_TEXT @"Do not need this service anymore"
#define TABLE_SECTION0_ROW5_TEXT @"Other..."

#define AS_FAILED_CANCEL_APPOINTMENT_REQ_ALERT_MESSAGE @"Appointment cancellation is failed Do you want to continue?"
#define AS_FAILED_LOADING_JOB_APPOINTMENT_SUCCESS_ALERT_MESSAGE @"Cancel Appointment successful"  
#define ALERT_CANCELJOB_SUCCESS_TAG 0
#define ALERT_CANCELJOB_FAIL_TAG 1

@interface CancelViewController (Private)

- (void)setupNavigationBar;
- (void)createCustomNavigationRightButton;
- (void)populateContentData;
- (void)hideOverlay;
- (void)showJobViewController;
- (void)handleCancelJobRequestAPI;

- (IBAction)closeButtonClicked:(id)sender;
- (IBAction)cancelJobButtonClick:(id)sender;

@end

@implementation CancelViewController

@synthesize contentTable;
@synthesize jobDetail;
@synthesize overlay;
@synthesize flowStatus;
@synthesize lastIndex;
@synthesize parentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - memory management

- (void)dealloc
{
    
    [jobCancelRequestResponse release];
    [contentData release];
    
    self.contentTable = nil;
    self.parentView = nil;
    self.jobDetail = nil;
    self.lastIndex = nil;
    self.overlay = nil;
    
    [super dealloc];

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - initialize navigation bar

- (void)setupNavigationBar
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0,60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:BACK_BUTTON_TITTLE forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:NavigationButtonBackgroundImage] forState:UIControlStateNormal];
    //[button setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    item = nil;

    [self createCustomNavigationRightButton];
    
}

- (void)createCustomNavigationRightButton {
    
    //navigation back button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [button setTitle:DONE_BUTTON_TITTLE forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:DONE_BUTTON_IMAGE] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelJobButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    barCancelButton= [[UIBarButtonItem alloc] initWithCustomView:button];
    barCancelButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = barCancelButton;
    
}

-(void)initializeVariables {
    
    self.contentTable.backgroundColor = [UIColor clearColor]; 
    [self.navigationItem setRBTitle:CANCELJOB_NAVIGATION_TITLE];
    contentData = [[NSMutableArray alloc]init];
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeVariables];
    [self setupNavigationBar];
    [self populateContentData];
}

- (void)populateContentData
{
    [contentData addObject:TABLE_SECTION0_ROW0_TEXT];
    [contentData addObject:TABLE_SECTION0_ROW1_TEXT];
    [contentData addObject:TABLE_SECTION0_ROW2_TEXT];
    [contentData addObject:TABLE_SECTION0_ROW3_TEXT];
    [contentData addObject:TABLE_SECTION0_ROW4_TEXT];
    [contentData addObject:TABLE_SECTION0_ROW5_TEXT];
}

#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [contentData count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    //make the tick position
    NSString * imagePath = [[NSBundle mainBundle] pathForResource:locationModeSelectedTickImageName 
                                                           ofType:kRBImageType];
    UIImage * tick = [[UIImage alloc] initWithContentsOfFile:imagePath];
    cell.imageView.image = tick;
    cell.imageView.hidden = YES;
    [tick release];
    
    cell.textLabel.text = @"";
    CGRect frame = CGRectMake(30 ,12 , 282, 25);
    UITextField *txtField = [[UITextField alloc]initWithFrame:frame];
    txtField.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    txtField.userInteractionEnabled = NO;
    [txtField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [txtField setReturnKeyType:UIReturnKeyNext];
    txtField.text = [contentData objectAtIndex:indexPath.row];
    
    [cell.contentView addSubview:txtField];
    [txtField release];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    
	int presentRow=[indexPath row];
	int oldRow= (self.lastIndex != nil) ? [self.lastIndex row] : -1; //[self.lastIndex row];
	
	if(presentRow!=oldRow)
	{
		UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndex]; 
        oldCell.imageView.hidden = YES;
        newCell.imageView.hidden = NO;
		
		self.lastIndex = indexPath;		
	}
	
    barCancelButton .enabled = YES;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}


#pragma mark - button click actions

- (IBAction)closeButtonClicked:(id)sender
{
    if(parentView)
        [[parentView navigationController] popViewControllerAnimated:YES];
    else
        [[self navigationController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelJobButtonClick:(id)sender
{

    [self handleCancelJobRequestAPI];
    
}

- (void)handleCancelJobRequestAPI
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];

    NSString *jobCancelReson = [contentData objectAtIndex:self.lastIndex.row];
    
    if (!jobCancelRequestResponse)
    {
        jobCancelRequestResponse = [[RBJobBidAndProviderDetailHandler alloc] init];
    }
    
    jobCancelRequestResponse.delegate = self;
    
    Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (flowStatus) {
       
        self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                          withMessage:@"Canceling job..." 
                                             animated:YES];
        [jobCancelRequestResponse cancelJobRequestWithJobId:self.jobDetail.jobID reasonOfRejection:jobCancelReson andOther:@"test"];
    }
    else
    {
        //NSLog(@"BidID %@",[jobDetail.winningBidIDs objectAtIndex:0]);
        self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                          withMessage:@"Canceling Appointment..." 
                                             animated:YES];
        [jobCancelRequestResponse sendKAcceptORCancelAppointmentWithBidId:[jobDetail.winningBidIDs objectAtIndex:0] jobID:self.jobDetail.jobID actionType:BID_CANCEL_APPOINTMENT_RESON rejectReason:jobCancelReson];
    
    }
    if (pool) 
        [pool drain];
    
}


#pragma mark - RBBaseHTTPHandler Delegate
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request
{

    //reload the table after the response complete
    do
    {
        NSString * title = @"Redbeacon";
        NSString *message = @" ";
        int alertTag = -1;
        BOOL IsCancelButton = YES;
        
        RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
        if (requestType == kCancelJob) 
        {
            // Use when fetching text data
            NSString *responseString = [request responseString];
            
            if ([responseString isEqualToString:@"ok"]) {
                
                NSString * title = @"Redbeacon";
                [RBAlertMessageHandler showAlertWithTitle:title
                                                  message:AS_FAILED_LOADING_JOB_CACELLATION_SUCCESS_ALERT_MESSAGE 
                                           delegateObject:self
                                                  viewTag:KCancelSuceessResponseTag 
                                         otherButtonTitle:@"OK" 
                                               showCancel:NO];
            }
            else
            {
                // Some error occurred
                [self hideOverlay];
                NSString * title = @"Redbeacon";
                [RBAlertMessageHandler showAlertWithTitle:title
                                                  message:AS_FAILED_CANCEL_JOB_REQ_ALERT_MESSAGE 
                                           delegateObject:self
                                                  viewTag:kCancelJob 
                                         otherButtonTitle:@"OK" 
                                               showCancel:YES];
            }
        }  
        
        if (requestType == kCancelORAcceptAppointment) 
        {
            // Use when fetching text data
            NSString *responseString = [request responseString];
            
            NSDictionary * responseDictionary = [responseString JSONValue];
            
            BOOL response =[[responseDictionary objectForKey:@"success"] boolValue];
            if (response) {
                
                message = AS_FAILED_LOADING_JOB_APPOINTMENT_SUCCESS_ALERT_MESSAGE;
                alertTag = ALERT_CANCELJOB_SUCCESS_TAG;
                IsCancelButton = NO;
                
            }
            else
            {
                // Some error occurred
                [self hideOverlay];
                message = AS_FAILED_CANCEL_APPOINTMENT_REQ_ALERT_MESSAGE;
                alertTag = ALERT_CANCELJOB_FAIL_TAG;
                IsCancelButton = YES;
            }
        } 
        if(-1!=alertTag)
        {
        [RBAlertMessageHandler showAlertWithTitle:title
                                          message:message 
                                   delegateObject:self
                                          viewTag:alertTag 
                                 otherButtonTitle:@"OK" 
                                       showCancel:IsCancelButton];
        }
        
    } while (0);  
    
    [self hideOverlay];
    
}

- (void)requestCompletedWithErrors:(ASIHTTPRequest*)request 
{
    [self hideOverlay];
}


#pragma mark - Overlay Method
- (void)hideOverlay {
    
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
    
}

#pragma mark -

- (void)showJobViewController
{
    if(parentView)
        [[parentView navigationController] dismissModalViewControllerAnimated:YES];
    else
        [[self navigationController] dismissModalViewControllerAnimated:YES];
    Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate setTabbarViewControllers:nil];
    [appDelegate selectTabbarIndex:0];
    
}


#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 if (alertView.tag == kCancelJob) 
    {
        //DISCARD MEDIAS OR NOT
        if (buttonIndex == 0)
        {
            [self handleCancelJobRequestAPI];
        }
        else
        {
            [self showJobViewController];
        }
    }
    
    else if (alertView.tag ==  KCancelSuceessResponseTag) 
    {
        if (buttonIndex == 0)
        {
            [self showJobViewController];
        }
    }
    
    else if (alertView.tag == ALERT_CANCELJOB_SUCCESS_TAG) 
    {
        if (buttonIndex == 0)
        {
            [self showJobViewController];
        }
        
    }
    else if(alertView.tag == ALERT_CANCELJOB_FAIL_TAG)
    {
        if (buttonIndex == 0)
        {
            [self handleCancelJobRequestAPI];
        }
        else
            [self showJobViewController];
    }


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
