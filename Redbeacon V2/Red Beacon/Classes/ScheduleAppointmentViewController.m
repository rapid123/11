
//
//  ScheduleAppointmentViewController.m
//  Red Beacon
//
//  Created by Nithin George on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleAppointmentViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "ScheduleDateAndTimeController.h"
#import "Red_BeaconAppDelegate.h"
#import "RBCurrentJobResponse.h"
#import "RBAlertMessageHandler.h"
#import "RBTimeFormatter.h"
#import "ConversationViewController.h"
#import <EventKit/EventKit.h>
#import "CancelViewController.h"

@class Red_BeaconAppDelegate;

#define AS_FAILED_SETAPPOINTMENT_TIME_SUCCESS_ALERT_MESSAGE @"Confirmed Appointment"  
#define AS_FAILED_SETAPPOINTMENT_TIME_FAILED_ALERT_MESSAGE @"Confirm Appointment failed. Do you want to continue?" 

#define BUTTONVIEW_SCHEDULE_POINT CGPointMake(160, 300)
#define BUTTONVIEW_RESCHEDULE_POINT CGPointMake(160, 310)

#define ACTIONSHEET_TITLE @""//@"Click cancel appointment and we will terminate this appointment"


#define ALERT_CONFIRM_APPOINTMENT_SUCCESS_TAG 3
#define ALERT_CONFIRM_APPOINTMENT_FAIL_TAG 4
@interface ScheduleAppointmentViewController (Private)

- (void)showConfirmView;
- (void)showConfirmedView;
- (void)dissmissView;
-(void)showConfirmAppointment;
- (void)hideOverlay;
- (void)handleSetAnAppointmentTime;
- (void)showCancelJobViewController:(UIViewController*)currentView;
- (void)showConfirmAppointment:(UIViewController*)currentView;

- (BOOL)checkTheScheduledStatus;
@end

@implementation ScheduleAppointmentViewController

@synthesize jobDetail;
@synthesize delegate;

@synthesize unScheduledContainer;

@synthesize buttonUnSheduledContainer;
@synthesize buttonScheduledContainer;
@synthesize scheduleDetailContainer;
@synthesize unScheduleDetailContainer;
@synthesize callButtonContainer;


@synthesize UnScheduleBackgroundImageview;
@synthesize ScheduleBackgroundImageview;
@synthesize ConfirmAppointmentBackgroundImage;
@synthesize UnConfirmAppointmentBackgroundImage;
@synthesize txtUnScheduleTittle;
@synthesize txtScheduleTittle;

@synthesize txtUnScheduleProviderName;
@synthesize txtUnScheduleFlatRate;
@synthesize txtUnScheduleMainAddress;
@synthesize txtUnScheduleSubAdress;
@synthesize txtUnScheduleZipcode;
@synthesize txtUnScheduleDateAndTime;

@synthesize txtScheduleDate;
@synthesize txtScheduleProviderName;
@synthesize txtScheduleFlatRate;
@synthesize txtScheduleMainAddress;
@synthesize txtScheduleSubAdress;
@synthesize txtScheduleZipcode;
@synthesize UnConformedAppointmentButton;
@synthesize overlay;

@synthesize UnConformedCallButton;
@synthesize ConformedCallButton;

@synthesize eventStore, defaultCalendar, detailViewController;


NSString *topLabelContentScheduled = @"Your appointment is scheduled ";
NSString *topLabelContentUnscheduled = @"You should receive a call soon to schedule an appointment";


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
    [cancelORAcceptAppointmentResponse release];
    cancelORAcceptAppointmentResponse = nil;
    
    if(viewController) {
        [viewController release];
        viewController = nil;
    }
    if(conversationViewController){
        [conversationViewController release];
        conversationViewController = nil;
    }
    
    self.jobDetail              = nil;
    self.delegate               = nil;
    self.unScheduledContainer = nil;
    self.buttonUnSheduledContainer        = nil;
    self.scheduleDetailContainer= nil;
    self.unScheduleDetailContainer=nil;

    self.UnScheduleBackgroundImageview=nil;
    self.ScheduleBackgroundImageview=nil;
    self.ConfirmAppointmentBackgroundImage=nil;
    self.UnConfirmAppointmentBackgroundImage=nil;

    self.txtUnScheduleTittle=nil;
    self.txtScheduleTittle=nil;
    
    self.txtUnScheduleProviderName=nil;
    self.txtUnScheduleFlatRate=nil;
    self.txtUnScheduleMainAddress=nil;
    self.txtUnScheduleSubAdress=nil;
    self.txtUnScheduleZipcode=nil;
    self.txtUnScheduleDateAndTime=nil;
    
    self.txtScheduleDate=nil;
    self.txtScheduleProviderName=nil;
    self.txtScheduleFlatRate=nil;
    self.txtScheduleMainAddress=nil;
    self.txtScheduleSubAdress=nil;
    self.txtScheduleZipcode=nil;
    self.UnConformedCallButton=nil;
    self.ConformedCallButton=nil;
    
    self.UnConformedAppointmentButton=nil;
    
    self.overlay = nil;
    
    viewController = nil;
    
    self.eventStore = nil;
	self.defaultCalendar = nil;
	self.detailViewController = nil;
    
    address = nil;
    flatRate = nil;
    
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark- 
#pragma mark navigation button clicks

-(void)backButtonClick:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
    }
    else if(button.tag == 1) {
        
        [[self navigationController] dismissModalViewControllerAnimated:NO];
    }
    Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate setTabbarViewControllers:nil];
    [appDelegate selectTabbarIndex:0];  // select home tabbar as default when going back  

}

- (void)jobCancelButtonClick:(id)sender
{
 
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        
        UIActionSheet *actionSheet; 
        actionSheet = [[UIActionSheet alloc] initWithTitle:ACTIONSHEET_TITLE delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:@"Cancel Appointment" otherButtonTitles:@"Reschedule Appointment",nil];
        actionSheet.tag =0;
        [actionSheet showInView:self.tabBarController.view];
        [actionSheet release];
    }
    else if(button.tag == 1) {
        
         UIActionSheet *actionSheet;
        actionSheet = [[UIActionSheet alloc] initWithTitle:ACTIONSHEET_TITLE delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:@"Cancel Appointment" otherButtonTitles:nil,nil];
        actionSheet.tag = 1;
        [actionSheet showInView:self.tabBarController.view];
        [actionSheet release];
    }
    
  


    
}

-(NSString*)getDateAndTimeString
{
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
    //for showing the appointed date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EE., MMM dd"];  
    NSString* dateAndTimeString;
    if (jobDetail.appointmentedDate) {
        
       dateAndTimeString = [formatter stringFromDate:jobDetail.appointmentedDate];  
        dateAndTimeString = [dateAndTimeString stringByAppendingString:@" at "];
        [formatter setDateFormat:@"h:mmaa"];
        dateAndTimeString = [dateAndTimeString stringByAppendingString:[formatter stringFromDate:jobDetail.appointmentedDate]];
    }
    else
    {
        dateAndTimeString = [formatter stringFromDate:jobDetail.timeBooked];  
        dateAndTimeString = [dateAndTimeString stringByAppendingString:@" at "];
        [formatter setDateFormat:@"h:mmaa"];
        dateAndTimeString = [dateAndTimeString stringByAppendingString:[formatter stringFromDate:jobDetail.timeBooked]];    
    }
    [formatter release];
    return dateAndTimeString;
}

-(IBAction)conformAppointmentButtonClicked:(id)sender
{

    if (jobDetail.appointmentedDate != nil) {
        if ([jobDetail.appointmentedDate compare:[NSDate date]] == NSOrderedAscending) // If the picked date is earlier than today
            
        {
            //less date so showing the picker for selecting the appointed date
            [self showConfirmAppointment:viewController];
            
        }
        else {
            
            [self handleSetAnAppointmentTime];
        }
    }
    else
    {
      [self showConfirmAppointment:viewController];  
    }

}
-(IBAction)conversationButtonClicked:(id)sender 
{
    
    if(!conversationViewController) {
        conversationViewController = [[ConversationViewController alloc]initWithNibName:@"ConversationViewController" bundle:nil];
        
        [conversationViewController setJobBid:bidDetails];
    }
      
    if ([self checkTheScheduledStatus]) {
        [conversationViewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:conversationViewController animated:YES];
    }
    else{
        conversationViewController.isFromScheduleView = YES;
        [viewController.navigationController pushViewController:conversationViewController animated:YES];
    }
}

-(IBAction)callButtonClicked:(id)sender 
{
    [[UIApplication sharedApplication] 
     openURL:[NSURL URLWithString:@"tel:1-855-723-2266"]];
}
-(IBAction)serviceProviderCallButtonClicked:(id)sender 
{
    NSString *phoneNumber = [NSString stringWithFormat:@"tel:%@",bidDetails.jobProfile.phone];
    [[UIApplication sharedApplication] 
     openURL:[NSURL URLWithString:phoneNumber]];
}

#pragma mark - calender events

-(void)initiallizeCalenderEvent {
    
    self.eventStore = [[EKEventStore alloc] init];
	// Get the default calendar from store.
	self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
	// Fetch today's event on selected calendar and put them into the eventsList array

}

// Fetching events happening in the next 24 hours with a predicate, limiting to the default calendar 
- (NSArray *)fetchEventsForToday {
	
	NSDate *startDate = jobDetail.appointmentedDate;
    
	// endDate is 1 day = 60*60*24 seconds = 86400 seconds from startDate
//	NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:86400];
    NSDate *endDate = [NSDate dateWithTimeInterval:86400 sinceDate:startDate];
	// Create the predicate. Pass it the default calendar.
	NSArray *calendarArray = [NSArray arrayWithObject:defaultCalendar];
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate 
                                                                    calendars:calendarArray]; 
	
	// Fetch all events that match the predicate.
	NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    
	return events;
}

-(EKEvent *)createSpecifiedEvent {
    
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     =   bidDetails.jobProfile.occupation;
    event.location  =   bidDetails.jobProfile.location;
    event.startDate =   jobDetail.appointmentedDate;
    // 60*60 seconds  == for 1 hour delay
    NSDate *endDate = [NSDate dateWithTimeInterval:3600 sinceDate:jobDetail.appointmentedDate];
    event.endDate   =   endDate;
    
    return event;
}

- (void)addEvent:(id)sender {

	EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
   
    //create the specified event
    EKEvent *event   = [self createSpecifiedEvent];
    
    [addController setEvent:event];
	addController.eventStore = self.eventStore;
	
	[self presentModalViewController:addController animated:YES];
	addController.editViewDelegate = self;
	[addController release];
}

-(IBAction)calenderButtonClicked:(id)sender 
{
    if(!eventStore)
        [self initiallizeCalenderEvent];
    
    [self addEvent:sender];
}


#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller 
          didCompleteWithAction:(EKEventEditViewAction)action {
	
	NSError *error = nil;
	EKEvent *thisEvent = controller.event;
	
	switch (action) {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing. 
			break;
			
		case EKEventEditViewActionSaved:
			// When user hit "Done" button, save the newly created event to the event store, 
			// and reload table view.
			// If the new event is being added to the default calendar, then update its 
			// eventsList.
			if (self.defaultCalendar ==  thisEvent.calendar) {
			}
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
            NSString *message = [NSString stringWithFormat:@"Appointment was added to your calender"];
            [RBAlertMessageHandler showAlertWithTitle:@"Redbeacon"
                                               message:message 
                                        delegateObject:self
                                               viewTag:44
                                      otherButtonTitle:@"OK" 
                                            showCancel:NO];
			break;
			
		case EKEventEditViewActionDeleted:
			// When deleting an event, remove the event from the event store, 
			// and reload table view.
			// If deleting an event from the currenly default calendar, then update its 
			// eventsList.
			if (self.defaultCalendar ==  thisEvent.calendar) {
			}
			[controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
			break;
			
		default:
			break;
	}
	// Dismiss the modal view controller
	[controller dismissModalViewControllerAnimated:YES];
	
}


// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
	EKCalendar *calendarForEdit = self.defaultCalendar;
	return calendarForEdit;
}


#pragma mark - Action sheet delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //with 3 buttons(UnConfirmAppointment)
    if (actionSheet.tag == 0) {
        
        if (buttonIndex == 0) {
            
            [self showCancelJobViewController:self];
            
        }
        else if(buttonIndex == 1)
        {
            [self showConfirmAppointment:self];
        }
        
    }
    //with 2 buttons (confirmAppointment)
    else if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0) {
            
            [self showCancelJobViewController:viewController];
        }
    }
}

- (void)showCancelJobViewController:(UIViewController*)currentView;
{
    CancelViewController *cancelViewController = [[CancelViewController alloc] initWithNibName:@"CancelViewController" bundle:nil];

    cancelViewController.flowStatus = NO;
    RBNavigationController *cancelJobNavigationController = [[RBNavigationController alloc]
                                                             initWithRootViewController:cancelViewController];
    if(self==currentView)
        [self.navigationController presentModalViewController:cancelJobNavigationController animated:YES];
    else {
        cancelViewController.parentView = currentView;
        [currentView.navigationController pushViewController:cancelViewController animated:NO];
    }
        
    //[currentView.navigationController presentModalViewController:cancelJobNavigationController animated:YES];
    //[self.navigationController presentModalViewController:cancelJobNavigationController animated:YES];
    [cancelJobNavigationController release];
    cancelJobNavigationController = nil;

    [cancelViewController release];
    cancelViewController = nil;
}
#pragma mark - navigation views

- (void)createCustomNavigationRightButton:(UIViewController*)currentView:(int)tagValue {
    
    //navigation back button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 65, 30);
    button.tag = tagValue;
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [button setTitle:kBackToHomeTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:NavigationButtonBackgroundImage] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    currentView.navigationItem.leftBarButtonItem = item;
    [item release];
    item = nil;
}



- (void)setupNavigationBar:(UIViewController*)currentView :(int)tagValue{

    //to adjust the title position
    UIButton * button = [[UIButton alloc] initWithFrame:rightBarButtonItemFrame];
    button.tag = tagValue;
    UIBarButtonItem * barbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button setImage:[UIImage imageNamed:navigationButtonRightbackgroundImage] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(jobCancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [currentView.navigationItem setRightBarButtonItem:barbuttonItem];
    [button release];
    button = nil;
    [barbuttonItem release];
    barbuttonItem = nil;
    
}

-(void)showConfirmAppointment:(UIViewController*)currentView
{
    ScheduleDateAndTimeController *scheduleDateAndTimeController = [[ScheduleDateAndTimeController alloc] init];
    scheduleDateAndTimeController.occupationName = bidDetails.jobProfile.best_name;
    if (currentView == self) {
        
        scheduleDateAndTimeController.userFlow = NO;
    }
    else if(currentView == viewController)
    {
        scheduleDateAndTimeController.userFlow = YES;
    }
    [currentView.navigationController pushViewController:scheduleDateAndTimeController animated:YES];
    [scheduleDateAndTimeController release];
    scheduleDateAndTimeController = nil;
}


#pragma mark - View lifecycle

-(void)initializeTheJobBid {
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
    
    int bidIDIntValue = [[jobDetail.winningBidIDs objectAtIndex:0] intValue];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bidID == %d",bidIDIntValue]; 
    NSArray *result = [[jobDetail jobBids] filteredArrayUsingPredicate:predicate];
    bidDetails = [result objectAtIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //searching the given bidID
    [self initializeTheJobBid];
    
    address = [bidDetails.jobProfile.location componentsSeparatedByString:@", "];
    
    //finding the flat rate
    int rate = bidDetails.flat_rate;
    if (bidDetails.require_onsite) 
        flatRate = @"Onsite Required";
    else if(0!=rate)
        flatRate = [NSString stringWithFormat:@"$%d Flat Rate",rate];
    else
    {
        rate=bidDetails.total_price;
        flatRate = [NSString stringWithFormat:@"$%d Hourly Rate",rate];
    }
    //Condition for checking the job is Appointed or not
    if ([self checkTheScheduledStatus]) {
        
        //show confrmed view
        [self showConfirmedView]; 
    }
    else
    {
        //show confrm view
        [self showConfirmedView];
        [self showConfirmView]; 
    } 

    NSString *buttonTittle;
    //date is not present so showing the picker for selectng the date
    if (jobDetail.appointmentedDate != nil) {
        if ([jobDetail.appointmentedDate compare:[NSDate date]] == NSOrderedAscending)
        {
            // If the picked date is earlier than today
            //less date so showing the picker for selecting the appointed date
            buttonTittle = @"Set Appointment Time";
            [txtUnScheduleDateAndTime setHidden:YES];
        }
        else
        {
            buttonTittle = @"Confirm Appointment";
            [txtUnScheduleDateAndTime setHidden:NO];
        }
    }
    else
    {
        buttonTittle = @"Set Appointment Time";
        [txtUnScheduleDateAndTime setHidden:YES];
    }
    
    self.UnConformedAppointmentButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    [self.UnConformedAppointmentButton setTitle:kBackToHomeTitle forState:UIControlStateNormal];
    [self.UnConformedAppointmentButton setTitle:buttonTittle forState:UIControlStateNormal];
}

- (BOOL)checkTheScheduledStatus
{

    BOOL Result;
    //Condition for checking the job is Appointed or not
    BOOL IsAppointmentAccepted  = jobDetail.appointmentAccepted;
    BOOL isValidDate = NO;
    //NSLog(@"Date %@",jobDetail.appointmentedDate);
    if(jobDetail.appointmentedDate)
        isValidDate = [jobDetail.appointmentedDate compare:[NSDate date]] == NSOrderedDescending;
    
    //date is YES and apointrd status is YES
    if (isValidDate && IsAppointmentAccepted)
    {
        Result = YES;
    }
    //date IS YES and apointed status is NO
    else 
        Result = NO;
    
    return Result;
}

- (void)viewWillAppear:(BOOL)animated 
{
    if(conversationViewController){
        
        [conversationViewController release];
        conversationViewController = nil;
    }
    [self initializeTheJobBid];
    self.txtScheduleDate.text = [self getDateAndTimeString];
    self.txtUnScheduleDateAndTime.text    = [self getDateAndTimeString];
}


- (void)showConfirmView
{
    if ([bidDetails.jobProfile.phone isEqualToString:(NSString*) [NSNull null]]) {
        
        self.UnConformedCallButton.enabled = NO;
    }
   
    viewController = [[UIViewController alloc] init];
    [viewController.view setBackgroundColor:[UIColor redColor]];
    viewController.view = unScheduledContainer;
    
    [viewController.navigationItem setRBTitle:jobDetail.jobRequestName];
    [self setupNavigationBar:viewController:1];
    [self createCustomNavigationRightButton:viewController:1];
    
    RBNavigationController *cancelJobNavigationController = [[RBNavigationController alloc]
                                                             initWithRootViewController:viewController];
    
    [self.navigationController presentModalViewController:cancelJobNavigationController animated:NO];
    [cancelJobNavigationController release];
    cancelJobNavigationController = nil;
    
    self.txtUnScheduleDateAndTime.text    = [self getDateAndTimeString];
    self.txtUnScheduleProviderName.text   = bidDetails.jobProfile.best_name;
    self.txtUnScheduleFlatRate.text       = flatRate;
    
    self.txtUnScheduleMainAddress.text    = [address objectAtIndex:0];
    self.txtUnScheduleSubAdress.text      = @"";
    self.txtUnScheduleZipcode.text        = @"";
    if (address.count > 1) {
        self.txtUnScheduleSubAdress.text      = [address objectAtIndex:1];
    }
    if (address.count > 2) {
        self.txtUnScheduleZipcode.text        = [address objectAtIndex:2];
    }
    
}    

- (void)showConfirmedView
{
    if ([bidDetails.jobProfile.phone isEqualToString:(NSString*) [NSNull null]]) {
        
        self.ConformedCallButton.enabled = NO;
    }
    
    [self.navigationItem setRBTitle:jobDetail.jobRequestName withSubTitle:@"Appointment"];
    [self setupNavigationBar:self:0];
    [self createCustomNavigationRightButton:self:0];
    
    self.txtScheduleDate.text          = [self getDateAndTimeString];   
    self.txtScheduleProviderName.text  = bidDetails.jobProfile.best_name;
    self.txtScheduleFlatRate.text      = flatRate;
    
    self.txtScheduleMainAddress.text   = [address objectAtIndex:0];
    self.txtScheduleSubAdress.text     = @"";
    self.txtScheduleZipcode.text       = @"";
    if (address.count > 1) {
        self.txtScheduleSubAdress.text     = [address objectAtIndex:1];
    }
    if (address.count > 2) {
        self.txtScheduleZipcode.text       = [address objectAtIndex:2];
    }
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
        BOOL IsCancelButton = NO;
        
        RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
        
        if (requestType == KConfrmAppointment) 
        {
            // Use when fetching text data
            NSString *responseString = [request responseString];
            
            NSDictionary * responseDictionary = [responseString JSONValue];
            
            BOOL response =[[responseDictionary objectForKey:@"success"] boolValue];
            if (response) {

                jobDetail.appointmentAccepted = YES;
                message = AS_FAILED_SETAPPOINTMENT_TIME_SUCCESS_ALERT_MESSAGE;
                alertTag = ALERT_CONFIRM_APPOINTMENT_SUCCESS_TAG;
                IsCancelButton = NO;
                
            }
            else
            {
                // Some error occurred
                [self hideOverlay];
                message = AS_FAILED_SETAPPOINTMENT_TIME_FAILED_ALERT_MESSAGE;
                alertTag = ALERT_CONFIRM_APPOINTMENT_FAIL_TAG;
                IsCancelButton = YES;
            }
        } 
        
    [RBAlertMessageHandler showAlertWithTitle:title
                                          message:message 
                                   delegateObject:self
                                          viewTag:alertTag 
                                 otherButtonTitle:@"OK" 
                                       showCancel:IsCancelButton];  
    } while (0);  

    
    [self hideOverlay];
    
}

- (void)requestCompletedWithErrors:(ASIHTTPRequest*)request 
{
    [self hideOverlay];
    //error in response
    
}

#pragma mark -

#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

 if(alertView.tag == ALERT_CONFIRM_APPOINTMENT_SUCCESS_TAG)
    {
        if (buttonIndex == 0)
        {
            [self dissmissView];
        }
    }
    else if(alertView.tag == ALERT_CONFIRM_APPOINTMENT_FAIL_TAG)
    {
        if (buttonIndex == 0)
        {
            [self handleSetAnAppointmentTime];
        }
        else
            [self dissmissView];
    }
}


#pragma mark - Overlay Method
- (void)hideOverlay {
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
}


- (void)dissmissView
{
    [[self navigationController] dismissModalViewControllerAnimated:YES];
    
}

#pragma mark-
- (void)handleSetAnAppointmentTime
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    if (!cancelORAcceptAppointmentResponse)
    {
        cancelORAcceptAppointmentResponse = [[RBJobBidAndProviderDetailHandler alloc] init];
    }
    
    cancelORAcceptAppointmentResponse.delegate = self;
    
    Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                      withMessage:@"Confirming Appointment..." 
                                         animated:YES];

    [cancelORAcceptAppointmentResponse sendKConfirmAppointmentWithBidId:[jobDetail.winningBidIDs objectAtIndex:0]];
    
    if (pool) 
        [pool drain];
    
    
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
