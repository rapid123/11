//
//  ScheduleDateAndTimeController.m
//  Red Beacon
//
//  Created by sudeep on 12/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "ScheduleDateAndTimeController.h"
#import "UINavigationItem + RedBeacon.h"
#import "RBAlertMessageHandler.h"
#import "RBCurrentJobResponse.h"
#import "RBTimeFormatter.h"

@interface ScheduleDateAndTimeController (Private)

- (void)handleSetAnAppointmentTime;
- (void)hideOverlay;

@end

#define FAILED_INVALID_DATE_ALERT_MESSAGE @"Please choose a scheduled date in the future."
#define AS_SUCCESS_APPOINTMENT_TIME_SUCCESS_ALERT_MESSAGE @"Your appointment time has been set."  
#define AS_FAILED_APPOINTMENT_TIME_FAILED_ALERT_MESSAGE @"Please choose an appointment time more than 4 hours from now." 
#define CONFIRM_FAILED_ALERT_MESSAGE @"Confirm Appointment failed. Do you want to continue?" 
@implementation ScheduleDateAndTimeController

@synthesize userFlow;
@synthesize descriptionLabel;
@synthesize datePickr;
@synthesize overlay;
@synthesize occupationName;

NSString *descriptionStart = @"What day and time did you set with ";

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
    [super dealloc];
    self.descriptionLabel = nil;
    self.datePickr = nil;
    self.overlay = nil;
    self.occupationName = nil;
    
    if (jobSetAppointmentTimeResponse) {
        [jobSetAppointmentTimeResponse release];
        jobSetAppointmentTimeResponse = nil; 
    }

    jobDetail = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark navigation button actions 

-(void)cancelButtonClicked:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)doneButtonClicked:(id)sender {
    
    //NSLog(@"PICKER DATE:- %@",datePickr.date);
    if ([[NSDate dateWithTimeIntervalSinceNow:[datePickr.date timeIntervalSinceNow]] compare:[NSDate date]] == NSOrderedAscending) // If the picked date is less than today
        
    {
        NSString * title = @"Redbeacon";
        [RBAlertMessageHandler showAlertWithTitle:title
                                          message:FAILED_INVALID_DATE_ALERT_MESSAGE 
                                   delegateObject:self
                                          viewTag:0
                                 otherButtonTitle:@"OK" 
                                       showCancel:NO];
        datePickr.date = [NSDate date];
        
    }
    else{
        
       [self handleSetAnAppointmentTime]; 
    }
    
    
}

#pragma mark -
#pragma mark view initialization

- (void)setupNavigationBar
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0,60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    item = nil;
    
    [self.navigationItem hidesBackButton];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    button=nil;
    [item release];
    item = nil;
}

-(void)initializeView {//[jobDetail.winningBidNames objectAtIndex:0]
    
    [self.navigationItem setRBTitle:@"Date and Time"];
    NSString *descriptiontext = [NSString stringWithFormat:@"%@ %@", descriptionStart,self.occupationName];
    [descriptionLabel setText:descriptiontext];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBar];
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
    
    [self initializeView];
    
    //for showing the appointed date
    if (jobDetail.appointmentedDate) {
        
        [datePickr setDate:jobDetail.appointmentedDate animated:NO]; 
    }
    else if(jobDetail.timeBooked)
        [datePickr setDate:jobDetail.timeBooked animated:NO];
    
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


#pragma mark -
#pragma mark - PICKER

- (IBAction)didPickerValueChanged:(id)sender 
{
 
}

#pragma mark-
- (void)handleSetAnAppointmentTime
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    if (!jobSetAppointmentTimeResponse)
    {
        jobSetAppointmentTimeResponse = [[RBJobBidAndProviderDetailHandler alloc] init];
    }
    
    jobSetAppointmentTimeResponse.delegate = self;
    
    Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                      withMessage:@"Setting Appointment Time..." 
                                         animated:YES];
    
    //selecting the time format according to the redbeacon format, we are comprg. with the plist data
    RBTimeFormatter * formatter = [[RBTimeFormatter alloc] init];
    int appontmentTime = [formatter timeValueForDate:datePickr.date];
    [formatter release];
    NSString *selectedTime = [NSString stringWithFormat:@"%d",appontmentTime];
    
    [jobSetAppointmentTimeResponse sendSetAnAppointmentTime:[jobDetail.winningBidIDs objectAtIndex:0]:[RBConstants getStringFromDate:[datePickr date]] :selectedTime];    
    if (pool) 
        [pool drain];
}

#pragma mark-
- (void)handleConfirmAppointmentAPI2
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    if (!jobSetAppointmentTimeResponse)
    {
        jobSetAppointmentTimeResponse = [[RBJobBidAndProviderDetailHandler alloc] init];
    }
    
    jobSetAppointmentTimeResponse.delegate = self;
    
    Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                      withMessage:@"Confirming Appointment..." 
                                         animated:YES];

    //NSLog(@"JobID %@",[jobDetail.winningBidIDs objectAtIndex:0]);
    [jobSetAppointmentTimeResponse sendKConfirmAppointmentWithBidId:jobDetail.jobID];  //[jobDetail.winningBidIDs objectAtIndex:0]
    
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
        if (requestType == KSetAnAppointmentTime) 
        {
            // Use when fetching text data
            NSString *responseString = [request responseString];
            
            NSDictionary * responseDictionary = [responseString JSONValue];
            
            BOOL response =[[responseDictionary objectForKey:@"success"] boolValue];
            if (response) {
                //API for confirming the appointment
                NSString * title = @"Redbeacon";
                [RBAlertMessageHandler showAlertWithTitle:title
                                                  message:AS_SUCCESS_APPOINTMENT_TIME_SUCCESS_ALERT_MESSAGE 
                                           delegateObject:self
                                                  viewTag:kCancelORAcceptAppointment 
                                         otherButtonTitle:@"OK" 
                                               showCancel:NO];
                                   
            }
            else
            {
                // Some error occurred
                [self hideOverlay];
                NSString * title = @"Redbeacon";
                [RBAlertMessageHandler showAlertWithTitle:title
                                                  message:AS_FAILED_APPOINTMENT_TIME_FAILED_ALERT_MESSAGE 
                                           delegateObject:self
                                                  viewTag:KSetAnAppointmentTime 
                                         otherButtonTitle:@"OK" 
                                               showCancel:YES];
            }
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

#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == KSetAnAppointmentTime) 
    {
        //DISCARD MEDIAS OR NOT
        if (buttonIndex == 0)
        {
            [self handleSetAnAppointmentTime];
        }
        else
        {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag ==  kCancelORAcceptAppointment) 
    {
        if (buttonIndex == 0)
        {
            //saving the new date from the picker
            jobDetail.appointmentedDate = [datePickr date];
            jobDetail.appointmentAccepted = YES;
            RBCurrentJobResponse *rBCurrentJobResponses = LOCATE(RBCurrentJobResponse);
            [rBCurrentJobResponses setJobResponse:jobDetail];

            
            if (!userFlow)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                
                [[self parentViewController] dismissModalViewControllerAnimated:NO];
                
            }
        }
    }
}

@end
