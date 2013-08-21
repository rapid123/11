//
//  ConformAppointmentViewController.m
//  Red Beacon
//
//  Created by Nithin George on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConformAppointmentViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "RBAlertMessageHandler.h"
#import "Red_BeaconAppDelegate.h"
#import "ManagedObjectContextHandler.h"
#import "RBCurrentJobResponse.h"
#import "UserInformation.h"

@class Red_BeaconAppDelegate;

@interface ConformAppointmentViewController (Private)

- (void)setupNavigationBar;
- (void)cancelButtonClicked:(id)sender;
- (void)doneButtonClicked:(id)sender;
- (void)setDisplayContent;
- (void)handleUserInformationAPI;
- (void)handleBookAppointmentAPI;

- (NSMutableDictionary *)setScheduleAppointmentParameters;
-(void)parseUserInformation:(NSDictionary *)responseDictionary;

- (void)startAnimateScrollview:(int)iVal;
- (void)RestoreScrollview;
- (void)adjustScrollView;

- (BOOL)isNonEmptyString:(NSString*)string;
- (BOOL)isValidScheduleAppointmentUpDatas;

-(NSString *)getUserInformation:(id)value;

@end

NSString * const AS_FIRST_NAME_EMPTY        = @"Firstname is empty";
NSString * const AS_LAST_NAME_EMPTY         = @"Lastname is empty";
NSString * const AS_PHONE_NUMBER_EMPTY      = @"PhoneNumber is empty";
NSString * const AS_STREET_ADDRESS_EMPTY    = @"StreetAddress is empty";

//Accept a quote for a job
#define kJob_ID  @"job_id"
#define kBid_ID  @"bid_id"
#define kFirst_name  @"first_name"
#define kLast_name  @"last_name"
#define kPhone  @"phone"
#define kAddress  @"address"
#define kCity  @"city"
#define kzipcode  @"zipcode"
#define kFlexible_date  @"flexible_date"
#define kFlexible_time  @"flexible_time"

@implementation ConformAppointmentViewController

@synthesize jobRequestResponse;
@synthesize jobBid;
@synthesize jobID;
@synthesize zipCode;
@synthesize conformAppointmentScrollView;
@synthesize txtFirstname;
@synthesize txtLastname;
@synthesize txtPhoneNumber;
@synthesize txtStreetAddress;
@synthesize scheduleQuoteLabel;
@synthesize scheduleRateLabel;
@synthesize scheduleTimeLabel;
@synthesize txtZipAddress;
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
    self.conformAppointmentScrollView = nil;
    self.jobRequestResponse = nil;
    self. txtFirstname = nil;
    self. txtLastname = nil;
    self. txtPhoneNumber = nil;
    self. txtStreetAddress = nil;
    self. scheduleQuoteLabel = nil;
    self. scheduleRateLabel = nil;
    scheduleTimeLabel = nil;
    self.txtZipAddress = nil;
    
    self.zipCode = nil;
    self.jobBid = nil;
    self.jobID  = nil;
    
    [loginHandler release];
    loginHandler = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

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


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self.navigationItem setRBTitle:@"Last Step" withSubTitle:@"Confirm Information"];
    [self setDisplayContent];
    [self handleUserInformationAPI];
    self.conformAppointmentScrollView.contentSize = CGSizeMake(0, 460);
    
    // register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
											   object:self.view.window];
	// register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification 
											   object:self.view.window];
}

- (void)handleUserInformationAPI
{    
    
    Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!loginHandler) {
        
        loginHandler = [[RBLoginHandler alloc] init];
    }
    loginHandler.delegate = self;
    
    self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                          withMessage:@"Fetching user information..." 
                                             animated:YES];
        
        
    [loginHandler sendSessionExpiryRequest];

}

- (void)setDisplayContent
{
    
    [self.txtLastname setReturnKeyType:UIReturnKeyNext];
    [self.txtFirstname setReturnKeyType:UIReturnKeyNext];
    [self.txtPhoneNumber setReturnKeyType:UIReturnKeyNext];
    [self.txtStreetAddress setReturnKeyType:UIReturnKeyGo];

    scheduleQuoteLabel.text = self.jobBid.jobProfile.best_name;
    //finding the flat rate
    int rate = self.jobBid.flat_rate;
    if (self.jobBid.require_onsite) 
        scheduleRateLabel.text = @"Onsite Required";
    else if(0!=rate)
        scheduleRateLabel.text = [NSString stringWithFormat:@"$%d Flat Rate",rate];
    else
    {
        rate=self.jobBid.total_price;
        scheduleRateLabel.text = [NSString stringWithFormat:@"$%d Hourly Rate",rate];        
    }
    
    //NSLog(@"zipcode %@",zipCode);
    NSString * cityName = [[ManagedObjectContextHandler sharedInstance] getCityNameForZipcode:zipCode];
    NSArray *cityID = [cityName componentsSeparatedByString:@", "];
    self.txtZipAddress.text = [NSString stringWithFormat:@"%@ %@",[cityID lastObject],zipCode];
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    JobResponseDetails *jobDetail=[rBCurrentJobResponse jobResponse];
    
    //for showing the appointed date
    //NSLog(@"Time Booked:===%@",jobDetail.startDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EE. MMM dd"];  
    self.scheduleTimeLabel.text = [formatter stringFromDate:jobDetail.startDate];
    self.scheduleTimeLabel.text = [self.scheduleTimeLabel.text stringByAppendingString:@" at "];
    [formatter setDateFormat:@"h:mmaa"];
    self.scheduleTimeLabel.text = [self.scheduleTimeLabel.text stringByAppendingString:[formatter stringFromDate:jobDetail.startDate]];
     [formatter release];   
    //scheduleRateLabel.text  = self.jobBid.total_price;
}

- (void)keyboardWillHide:(NSNotification *)obj_notification{
	if(bcontentflag)
	{
		icontentsize=460;
		self.conformAppointmentScrollView.contentSize= CGSizeMake(0, icontentsize);
		bcontentflag=NO;
	}
	[self RestoreScrollview];
}

- (void)keyboardWillShow:(NSNotification *)obj_notification{
	[self adjustScrollView];
}


-(void)RestoreScrollview{
    CGPoint pt;
    pt.x = 0 ;
    pt.y = 0 ;
    [self.conformAppointmentScrollView setContentOffset:pt animated:YES];
}

-(void)adjustScrollView{		
	if(!bcontentflag)
	{
		icontentsize=670;
		self.conformAppointmentScrollView.contentSize= CGSizeMake(0, icontentsize);
		bcontentflag=YES;
	}
	
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
	
    [self adjustScrollView];
    
	float fval;
	
	if(textField == self. txtFirstname ) {
		
		CGRect m_objtextrect=[self.view frame];		
		fval=m_objtextrect.origin.y;
		m_objtextrect=[textField frame];
		fval=fval+m_objtextrect.origin.y;
		if(fval>55){
            [self startAnimateScrollview:(int)((fval-100))];

		}
	}
	
	if(textField == self. txtLastname){		
		CGRect m_objtextrect=[self.view frame];		
		fval=m_objtextrect.origin.y;
		m_objtextrect=[textField frame];
		fval=fval+m_objtextrect.origin.y;
		if(fval>55){
                [self startAnimateScrollview:(int)((fval-100))];
		}		
	}
    
    if(textField == self. txtPhoneNumber){		
		CGRect m_objtextrect=[self.view frame];		
		fval=m_objtextrect.origin.y;
		m_objtextrect=[textField frame];
		fval=fval+m_objtextrect.origin.y;
		if(fval>55){
            [self startAnimateScrollview:(int)((fval-100))];
		}		
	}	
    
    if(textField == self. txtStreetAddress){		
		CGRect m_objtextrect=[self.view frame];		
		fval=m_objtextrect.origin.y;
		m_objtextrect=[textField frame];
		fval=fval+m_objtextrect.origin.y;
		if(fval>55){
            [self startAnimateScrollview:(int)((fval-100))];
		}		
	}	
	
}


-(void)startAnimateScrollview:(int)iVal{
    CGRect rc = [self.conformAppointmentScrollView bounds];
    rc = [self.conformAppointmentScrollView convertRect:rc toView:self.view];
    CGPoint pt = rc.origin ;
    pt.x = 0 ;
    pt.y -= iVal*(-1) ;
    [self.conformAppointmentScrollView setContentOffset:pt animated:YES];
}

#pragma mark - Overlay Method
- (void)hideOverlay {
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
}

#pragma mark - Button Actions

- (void)cancelButtonClicked:(id)sender
{
     [[self navigationController] dismissModalViewControllerAnimated:YES];
}



- (void)doneButtonClicked:(id)sender
{
    [self.txtLastname resignFirstResponder];
    [self.txtFirstname resignFirstResponder];
    [self.txtPhoneNumber resignFirstResponder];
    [self.txtStreetAddress resignFirstResponder];
    [self handleBookAppointmentAPI];
}

- (void)handleBookAppointmentAPI
{
    if ([self isValidScheduleAppointmentUpDatas]) {
        
        //call API
        if (!self.jobRequestResponse)
        {
            RBJobBidAndProviderDetailHandler *tempRBJobBidAndProviderDetailHandler =[[RBJobBidAndProviderDetailHandler alloc] init];
            self.jobRequestResponse = tempRBJobBidAndProviderDetailHandler;
            [tempRBJobBidAndProviderDetailHandler release];
            tempRBJobBidAndProviderDetailHandler = nil;
        }
        
        self.jobRequestResponse.delegate = self;
        
        Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
        
        self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                          withMessage:@"Accepting the quote..." 
                                             animated:YES];
        [NSThread detachNewThreadSelector:@selector(AcceptQuoteForJob:) 
                                 toTarget:self.jobRequestResponse 
                               withObject:[self setScheduleAppointmentParameters]];
    }
}
- (BOOL)isValidScheduleAppointmentUpDatas 

{
    BOOL isValid = YES;
    NSString * alertMessage;
    do {
        if (![self isNonEmptyString:self.txtFirstname.text]) {
            alertMessage = AS_FIRST_NAME_EMPTY;
            isValid = NO;
            break;
        }        
        
        if (![self isNonEmptyString:self.txtLastname.text]) {
            alertMessage = AS_LAST_NAME_EMPTY;
            isValid = NO;
            break;
        }
        
        if (![self isNonEmptyString:self.txtPhoneNumber.text]) {
            alertMessage = AS_PHONE_NUMBER_EMPTY;
            isValid = NO;
            break;
        }  
        
        if (![self isNonEmptyString:self.txtStreetAddress.text]) {
            alertMessage = AS_STREET_ADDRESS_EMPTY;
            isValid = NO;
            break;
        }  
        //add for more checking here
        //...
        //...
        
    } while (FALSE);
    
    if (!isValid) {
        [RBAlertMessageHandler showAlert:alertMessage 
                          delegateObject:nil];
    }

    return isValid;
}

#pragma mark - Validation Methods
#pragma mark - LOGIN

- (BOOL)isNonEmptyString:(NSString*)string {
    BOOL isValid = NO;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string length]>0) {
        isValid = YES;
    }
    return isValid;    
}


- (NSMutableDictionary *)setScheduleAppointmentParameters
{
    NSMutableDictionary *result = [[[NSMutableDictionary alloc]init ] autorelease];
    
    NSArray *zip = [self.zipCode componentsSeparatedByString:@" "];
    NSString *zipid = [NSString stringWithFormat:@"%d",jobBid.bidID];
    NSLog(@"value = %@",zipid);
    [result setValue:zipid forKey:kBid_ID];
    [result setValue:self.jobID forKey:kJob_ID];
    
    [result setValue:self.txtFirstname.text forKey:kFirst_name];
    [result setValue:self.txtLastname.text forKey:kLast_name];
    [result setValue:self.txtPhoneNumber.text forKey:kPhone];
    [result setValue:self.txtStreetAddress.text forKey:kAddress];
    
    [result setValue:[zip objectAtIndex:0] forKey:kCity];
    [result setValue:[zip lastObject] forKey:kzipcode];
    [result setValue:@"" forKey:kFlexible_date];
    [result setValue:@"" forKey:kFlexible_time];
    
    return result;
}

#define FAIL_MESSAGE @"Failed to confirm Appointment. Do you want to continue?"
#define FAIL_UER_INFO_MESSAGE @"Failed to fetch user information. Do you want to continue?"
#define KFetchUserInformation 111

#pragma mark - RBBaseHTTPHandler Delegate
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request
{
    //reload the table after the response complete
    do
    {
       
        RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
        
        if (requestType == KScheduleAppointment) 
        {
            
            NSString *response =[[request responseHeaders] objectForKey:@"X-Rb-Success"];
            if ([response isEqualToString:@"true" ]) {
                
                [self cancelButtonClicked:nil];
                Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[[UIApplication sharedApplication] delegate];
                [appDelegate setTabbarViewControllers:nil];
                [appDelegate selectTabbarIndex:0];  // select home tabbar as default when going back
                
            }
            else
            {
                // Some error occurred
                [self hideOverlay];
                NSString * title = @"Redbeacon";
                [RBAlertMessageHandler showAlertWithTitle:title
                                                  message:FAIL_MESSAGE 
                                           delegateObject:self
                                                  viewTag:KFetchUserInformation 
                                         otherButtonTitle:@"OK" 
                                               showCancel:YES];
            }

        } 
        
        else if (requestType == kSessionExpiry)
            {
                NSString *responseString = [request responseString];
                NSDictionary * responseDictionary = [responseString JSONValue]; 
                
                [self parseUserInformation:responseDictionary];
                
            }
            else
            {
                // Some error occurred
                [self hideOverlay];
                NSString * title = @"Redbeacon";
                [RBAlertMessageHandler showAlertWithTitle:title
                                                  message:FAIL_UER_INFO_MESSAGE 
                                           delegateObject:self
                                                  viewTag:KFetchUserInformation 
                                         otherButtonTitle:@"OK" 
                                               showCancel:YES];
            }
 
    } while (0);  
    
    [self hideOverlay];
    
}

- (void)requestCompletedWithErrors:(ASIHTTPRequest*)request 
{
    [self hideOverlay];
    
}

-(void)sessionValid:(BOOL)status
{
    
}

-(void)parseUserInformation:(NSDictionary *)responseDictionary
{
   
    UserInformation *objUserInformation = LOCATE(UserInformation);

    objUserInformation.first_name = [self getUserInformation:[responseDictionary objectForKey:@"first_name"]];
    objUserInformation.last_name  = [self getUserInformation:[responseDictionary objectForKey:@"last_name"]];
    objUserInformation.phone      = [self getUserInformation:[responseDictionary objectForKey:@"phone"]];
    objUserInformation.address    = [self getUserInformation:[responseDictionary objectForKey:@"address"]];

    
    self.txtFirstname.text     =  objUserInformation.first_name;
    self.txtLastname.text      = objUserInformation.last_name;
    self.txtPhoneNumber.text   = objUserInformation.phone;
    self.txtStreetAddress.text = objUserInformation.address;
}

-(NSString *)getUserInformation:(id)value
{
    NSString *result;
    
    if ([value isEqual:[NSNull null]]||value==nil) {
        
        result = @"";
    }
    else
        result = value;
    
    return result;
    
}

#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == KScheduleAppointment) 
    {
        //DISCARD MEDIAS OR NOT
        if (buttonIndex == 0)
        {
            [self handleBookAppointmentAPI];
        }
        else
        {
            [self cancelButtonClicked:nil];
        }
    }  
    else if(alertView.tag == KFetchUserInformation)
    {
        if (buttonIndex == 0)
        {
            [self handleUserInformationAPI];
        }
        else
        {
            [self hideOverlay];
        }
    }
}


#pragma mark - TextField Delegate methods
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField 
{
    // [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    if (textField==txtFirstname)
    {
        [txtLastname becomeFirstResponder];
    }
    else if (textField == txtLastname)
    {
        [txtPhoneNumber becomeFirstResponder];
    }
    else if (textField == txtPhoneNumber)
    {
        [txtStreetAddress becomeFirstResponder];
    }
    else 
    {
        [textField resignFirstResponder]; 
        [self handleBookAppointmentAPI];
    }
    return YES; 
}


- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
