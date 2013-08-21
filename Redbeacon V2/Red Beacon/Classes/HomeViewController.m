
//  HomeViewController.m
//  Red Beacon
//
//  Created by sudeep on 30/09/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "HomeViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "InfoPage.h"
#import "LoginViewController.h"
#import "JobResponseListCell.h"
#import "JobRequestViewController.h"
#import "QuotesViewController.h"
#import "NotificationsViewController.h"
#import "ClassFinder.h"
#import "RBCurrentJobResponse.h"
#import "RBAlertMessageHandler.h"
#import "FlurryAnalytics.h"
#import "ASIHTTPRequest.h"
#import "HowItWorksSlideShow.h"

//Sections
#define FIRST_SECTION 0
#define SECOND_SECTION 1
#define THIRD_SECTION 2

#define TAB_TO_SELECT 1
#define APPOINTMENT_TAB 0

//Section Header
#define FRIST_SECTION_HEADER @"Upcoming Appointments"
#define SECOND_SECTION_HEADER @"Current Home Service Request"
#define THIRD_SECTION_HEADER @"Previous"

#define HEADER_NAME @"headerName"
#define RESPONSE_COUNT_NAME @"JobCount"
#define RESPONSE_TYPE_NAME @"jobResponseType"
#define AS_FAILED_LOADING_JOB_REQ_ALERT_MESSAGE @"Server error. please try again"

#define TIMEOUT_ALERT_TAG 200
#define TIMEOUT_MESSAGE @"Request timed-out. Do you want to try again ?"

//************************* PRIVATE METHODS ****************************
@interface HomeViewController (Private)
- (void)createCustomNavigationRightButton;
- (void)checkLoginStatus;
- (void)handleAPIJobResponse;
- (void)parseBidProfileDetails:(NSDictionary *)result;
- (void)parseBidRBScore:(NSDictionary *)result;

- (NSMutableArray *)pareseBidDetails:(NSArray *)jobDetails;

- (NSMutableDictionary *)parsingTheResultentArray:(NSArray *)result:(NSString *)keyIdentifier;
- (JobResponseDetails *)readListViewItems:(NSIndexPath *)indexPath;
-(void)getJobServiceProfileDetail:(NSString *)bidId andJobID:(NSString *)jobID;

@end

//************************* HomeViewController Implementation ****************************
@implementation HomeViewController


@synthesize barLoginButton, spacebuttonItem;
@synthesize jobResponseTable;
@synthesize defaultImage;
@synthesize overlay;
@synthesize lastSelectedIndexpath;

int kBarLoginButtonTag = 100;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - navigation view

- (void)setupNavigationBar {
    
    [self.navigationItem setRBIconImage];
    
    //right bar button item
    UIButton * settingsButton = [[UIButton alloc] init];
    settingsButton.frame = CGRectMake(8, 3, 35, 25);
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,70, 30)];
    NSString * imagePath = [[NSBundle mainBundle] pathForResource:kRBInfoImage ofType:kRBImageType];
    UIImage * image  = [UIImage imageWithContentsOfFile:imagePath]; 
    [settingsButton setImage:image forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(showInfoView:) forControlEvents:UIControlEventTouchUpInside];
    
    [infoView addSubview:settingsButton];
    UIBarButtonItem * settingsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoView];
    [self.navigationItem setLeftBarButtonItem:settingsBarButtonItem];
    [settingsButton release];
    settingsButton = nil;
    [settingsBarButtonItem release];
    settingsBarButtonItem = nil;
    
    [infoView release];
    infoView=nil;
    
    //to adjust the title position
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    spacebuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:spacebuttonItem];
    [button release];
    button = nil;
    
    [self createCustomNavigationRightButton];
}

- (void)createCustomNavigationRightButton {
    
    //navigation back button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 70, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [button setTitle:@"Login" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"login_btn_selected.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(showLoginView:) forControlEvents:UIControlEventTouchUpInside];
    barLoginButton= [[UIBarButtonItem alloc] initWithCustomView:button];
    barLoginButton.tag=kBarLoginButtonTag;
    self.navigationItem.rightBarButtonItem = barLoginButton;

}

#pragma mark - navigation button click

- (void)showInfoView:(id)sender
{
    settingsViewed = YES;
    
    InfoPage *infoController = [[InfoPage alloc] initWithNibName:@"InfoPage" bundle:nil];
    
    RBNavigationController *infoPageNavigationController = [[RBNavigationController alloc]
                                                            initWithRootViewController:infoController];
    [self.navigationController presentModalViewController:infoPageNavigationController animated:YES];
    
    [infoPageNavigationController release];
    infoPageNavigationController = nil;
    
    [infoController release];
    infoController = nil;
}

- (void)showLoginView:(id)sender
{
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    RBNavigationController *loginPageNavigationController = [[RBNavigationController alloc]
                                                             initWithRootViewController:loginViewController];
    [self.navigationController presentModalViewController:loginPageNavigationController animated:YES];
    
    [loginViewController hideLoginLabel:YES];    
    
    [loginPageNavigationController release];
    loginPageNavigationController = nil;
    
    [loginViewController release];
    loginViewController = nil;
}

#pragma mark - memory management

- (void)dealloc
{
    [super dealloc];
    
    [barLoginButton release];
    barLoginButton=nil;
    
    [spacebuttonItem release];
    spacebuttonItem = nil;
    
    [jobRequestResponse release];
    
    [tableData release];
    
    [lastSelectedIndexpath release];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(BOOL)didUserSwitch {

    BOOL switced = NO;
    if ([RBBaseHttpHandler isSessionInfoAvailable])
    {
        NSString * username = @"";
        if([[RBDefaultsWrapper standardWrapper] FBUserName]) {
            
            username = [[RBDefaultsWrapper standardWrapper] FBUserName];
        }
        else
            username = [[RBDefaultsWrapper standardWrapper] currentUserName];
        
        NSString *lastUser = [[RBDefaultsWrapper standardWrapper] lastuser];
        if(lastUser){
            if(![lastUser isEqualToString:username])
                switced = YES;
        }
        else {
            [[RBDefaultsWrapper standardWrapper] lastuserLoggedIn:username];
            switced = YES;
        }
    }
    else
        switced = YES;
    
    return switced;
}

#pragma mark - slide show

-(void)showTheStartUpSlideShow {
    
    HowItWorksSlideShow *browser = [[HowItWorksSlideShow alloc] init];
    [browser setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:browser animated:NO];
    
    [browser release];  
    browser = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Shown" forKey:@"ShowStartUpSlide"];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    settingsViewed = NO;
    [self setupNavigationBar];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"ShowStartUpSlide"])
        [self showTheStartUpSlideShow];
    
    // Do any additional setup after loading the view from its nib.
    
}


-(void)viewWillAppear:(BOOL)animated {
    [FlurryAnalytics logEvent:@"View - Home"];
   
    [ClassFinder releaseInstances];
    if ([RBBaseHttpHandler isSessionInfoAvailable]) 
        self.navigationItem.rightBarButtonItem = spacebuttonItem;
    else
        self.navigationItem.rightBarButtonItem = barLoginButton;
    
    if([self didUserSwitch])
        [self checkLoginStatus];    //For cheching whether the user is login or logout
    
    else if (!settingsViewed)
        [self checkLoginStatus];
        
    settingsViewed = NO;
    
}

#pragma mark - Overlay Method
- (void)hideOverlay {
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
}


#pragma mark - API handling
- (void)checkLoginStatus
{
    [self.jobResponseTable setHidden:YES];
    BOOL isLoggedIn = [RBBaseHttpHandler isSessionInfoAvailable];
    
    [self.defaultImage setHidden:isLoggedIn];
    
    if(isLoggedIn){
        
        Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
        
        if(self.overlay)
            [self hideOverlay];
        self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                          withMessage:@"Loading jobs..." 
                                             animated:YES];
        [NSThread detachNewThreadSelector:@selector(handleAPIJobResponse) 
                                 toTarget:self 
                               withObject:nil];
    }
}

//it will remove if any overlay already exists on top. and adds the new overlay.
- (void)setOverlay:(RBLoadingOverlay *)_overlay
{
    if (overlay) {
        [overlay removeFromSuperview:YES];
        [overlay release];
        overlay = nil;
    }
    overlay = [_overlay retain];
}

- (void)handleAPIJobResponse
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    if (!jobRequestResponse)
    {
        jobRequestResponse = [[RBJobBidAndProviderDetailHandler alloc] init];
    }
    
    [FlurryAnalytics logEvent:@"all_jobs" timed:YES];    
    jobRequestResponse.delegate = self;
    [jobRequestResponse sendAllJobsAndStatusRequest];       
    
    if (pool) 
        [pool drain];
}

#pragma mark - RBBaseHTTPHandler Delegate
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request
{
    [FlurryAnalytics endTimedEvent:@"all_jobs" withParameters:nil];
    
    //reload the table after the response complete
    do
    {
        RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
        if (requestType == kAllJobsAndStatus) 
        {
            // Use when fetching text data
            NSString *responseString = [request responseString];
//            NSLog(@"kAllJobsAndStatusRequestFinished:Response %d : %@", 
//                  request.responseStatusCode, 
//                  [request responseStatusMessage]);
            NSDictionary * responseDictionary = [responseString JSONValue];
            if ([responseDictionary count] == 0) {
                [self.defaultImage setHidden:NO];
            }
            else {
                
                NSArray *scheduledDetails =[responseDictionary objectForKey:SCHEDULE];
                NSArray *newDetails =[responseDictionary objectForKey:NEW];
                NSArray *doneDetails =[responseDictionary objectForKey:DONE];
                
                
                tableData = [[NSMutableArray alloc]init];
                
                if ([scheduledDetails count]>0)
                {
                    reviewsJobsArray = [[NSMutableArray alloc] init];
                    NSDictionary *object = [self parsingTheResultentArray:scheduledDetails:SCHEDULE];
                    [object setValue:FRIST_SECTION_HEADER forKey:HEADER_NAME];                                                                     
                    [tableData addObject:object];
                }
                if([newDetails count]>0)
                {
                    NSDictionary *object = [self parsingTheResultentArray:newDetails:NEW];
                    [object setValue:SECOND_SECTION_HEADER forKey:HEADER_NAME];
                    [tableData addObject:object];
                }
                if ([doneDetails count]>0)
                {
                    NSDictionary *object = [self parsingTheResultentArray:doneDetails:DONE];
                    [object setValue:THIRD_SECTION_HEADER forKey:HEADER_NAME];
                    [tableData addObject:object];
                }
                if ([tableData count]>0) {
                    
                    [self.defaultImage setHidden:YES];
                    [self.jobResponseTable setHidden:NO];
                    [self.jobResponseTable reloadData];
                }
                else
                {
                    NSString * title = @"Redbeacon";
                    [RBAlertMessageHandler showAlertWithTitle:title
                                                      message:AS_FAILED_LOADING_JOB_REQ_ALERT_MESSAGE 
                                               delegateObject:nil
                                                      viewTag:kAllJobsAndStatus 
                                             otherButtonTitle:@"OK" 
                                                   showCancel:NO];
                    
                    [self.defaultImage setHidden:NO];  
                }

            }
        }
        
        else if (requestType == kJobDetails) 
        {
            // Use when fetching text data
            
            NSString *responseString = [request responseString];
            NSDictionary * responseDictionary = [responseString JSONValue];
            
            NSArray *bidDetails =[responseDictionary objectForKey:@"bids"];
            
            selectedJobDetails = [self readListViewItems:self.lastSelectedIndexpath];
            
            //tabbar to select is quotes by default,previously they wanted it to be details.
            //change tabbarToSelect = 0 to bring it back.
            
            int tabbarToSelect = TAB_TO_SELECT;
            if ([bidDetails count]>0) {
                if(self.lastSelectedIndexpath.section == 1)
                    tabbarToSelect = TAB_TO_SELECT;
                NSArray *bidsInfo = [self pareseBidDetails:bidDetails];
                selectedJobDetails.jobBids = bidsInfo;
            }
            
                       
            RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
            [rBCurrentJobResponse setJobResponse:selectedJobDetails];
            
            BOOL fromAppointmentSection = NO;
            if ([selectedJobDetails.jobType isEqualToString:SCHEDULE]) {// if (self.lastSelectedIndexpath.section == 0) {
                fromAppointmentSection = YES;
                tabbarToSelect = APPOINTMENT_TAB;
            }
            Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate changeTabbarViewControllersWithAppointment:fromAppointmentSection];
            [appDelegate selectTabbarIndex:tabbarToSelect];
        }
        
    } while (0);  
    
    [self hideOverlay];
    
}

- (void)requestCompletedWithErrors:(ASIHTTPRequest*)request 
{
    
    //error in response
    NSError *error = [request error];
    int code = [error code];
    if (code  == ASIRequestTimedOutErrorType) {
        // Actions specific to timeout
        NSLog(@"Error timeout");
        NSString * title = @"Redbeacon";
        [RBAlertMessageHandler showAlertWithTitle:title
                                          message:TIMEOUT_MESSAGE
                                   delegateObject:self
                                          viewTag:TIMEOUT_ALERT_TAG 
                                 otherButtonTitle:@"OK" 
                                       showCancel:YES];
    }
    [self.defaultImage setHidden:NO];
    [self hideOverlay];
}


#pragma mark - Parsing the response

-(void)retrievePrivateMessages:(NSDictionary *)privateMessageDict {
    
    JobPrivateMessage *privateMessage = [[JobPrivateMessage alloc] init];
    privateMessage.message = [privateMessageDict  valueForKey:@"message"];
    privateMessage.is_provider = [[privateMessageDict  valueForKey:@"is_provider"] boolValue];
    privateMessage.messageId = [[privateMessageDict  valueForKey:@"id"] intValue];
    privateMessage.sender = [privateMessageDict  valueForKey:@"sender"];
    if ([privateMessageDict  valueForKey:@"time_created"] != [NSNull null]) {
        
        int timeCreated = [[privateMessageDict  valueForKey:@"time_created"] intValue];
        privateMessage.timeCreated = [NSDate dateWithTimeIntervalSince1970:timeCreated];
    }
    
    [jobBids.privateMessages addObject:privateMessage];
    [privateMessage release];
    privateMessage=nil;
}

-(JOBQAS *)getJobQas:(NSDictionary *)qasMessageDict {
    
    JOBQAS *qas = [[JOBQAS alloc] init];
    qas.question = [qasMessageDict  valueForKey:@"question"];
    qas.has_been_read_by_consumer = [[qasMessageDict  valueForKey:@"has_been_read_by_consumer"] boolValue];
    qas.question_id = [[qasMessageDict  valueForKey:@"question_id"] intValue];
    qas.answer = [qasMessageDict  valueForKey:@"answer"];
    
    if ([qasMessageDict valueForKey:@"time_created"] != [NSNull null]) {
        
        int timeCreated = [[qasMessageDict valueForKey:@"time_created"] intValue];
        qas.time_created = [NSDate dateWithTimeIntervalSince1970:timeCreated];
    }
    if ([qasMessageDict valueForKey:@"time_answered"] != [NSNull null]) {
        
        int timeAnswered = [[qasMessageDict valueForKey:@"time_answered"] intValue];
        qas.time_answered = [NSDate dateWithTimeIntervalSince1970:timeAnswered];
    }
    
    return [qas autorelease];
}

-(void)retrieveJobQAS:(NSDictionary *)qasMessageDict {
    
    JOBQAS *qas = [[JOBQAS alloc] init];
    qas.question = [qasMessageDict  valueForKey:@"question"];
    qas.has_been_read_by_consumer = [[qasMessageDict  valueForKey:@"has_been_read_by_consumer"] boolValue];
    qas.question_id = [[qasMessageDict  valueForKey:@"question_id"] intValue];
    qas.answer = [qasMessageDict  valueForKey:@"answer"];
    
    if ([qasMessageDict valueForKey:@"time_created"] != [NSNull null]) {
   
        int timeCreated = [[qasMessageDict valueForKey:@"time_created"] intValue];
        qas.time_created = [NSDate dateWithTimeIntervalSince1970:timeCreated];
    }
    if ([qasMessageDict valueForKey:@"time_answered"] != [NSNull null]) {

        int timeAnswered = [[qasMessageDict valueForKey:@"time_answered"] intValue];
        qas.time_answered = [NSDate dateWithTimeIntervalSince1970:timeAnswered];
    }
    //qas = [self getJobQas:qasMessageDict];
    

    [jobResponse.jobQAS addObject:qas];
    [qas release];
    qas=nil;
}

-(void)retrieveJobUpdates:(NSDictionary *)updates {
    
    JobUpdates *jobUpdates = [[JobUpdates alloc] init];
    jobUpdates.update_id = [[updates  valueForKey:@"update_id"] intValue];
    jobUpdates.details = [updates valueForKey:@"details"];
    int timeUpdated = [[updates valueForKey:@"time_updated"] intValue];
    jobUpdates.time_updated  = [NSDate dateWithTimeIntervalSince1970:timeUpdated];
    [jobResponse.updates addObject:jobUpdates];
    [jobUpdates release];
    jobUpdates=nil;
}

- (NSMutableArray *)pareseBidDetails:(NSArray *)jobDetails
{
    NSMutableArray *resultArray = [[[NSMutableArray alloc]init] autorelease];
    
    for (int i = 0; i< [jobDetails count]; i++) {
        
        if (!jobBids) {
            
            jobBids = [[JobBids alloc]init];
        }
                
        jobBids.total_price         = [[[jobDetails objectAtIndex:i] valueForKey:@"total_price"] intValue];
        jobBids.bidID               = [[[jobDetails objectAtIndex:i] valueForKey:@"bid_id"] intValue];
        jobBids.number_of_minutes   = [[[jobDetails objectAtIndex:i] valueForKey:@"number_of_minutes"] intValue];
        jobBids.number_of_hours     = [[[jobDetails objectAtIndex:i] valueForKey:@"number_of_hours"] intValue];
        
        @try {
            jobBids.estimate_high       = [[[jobDetails objectAtIndex:i] valueForKey:@"estimate_high"] floatValue];
        }
        @catch (NSException* e) {
            jobBids.estimate_high = 0;
        }
        
        @try {
            jobBids.flat_rate           = [[[jobDetails objectAtIndex:i] valueForKey:@"flat_rate"] floatValue];
        }
        @catch (NSException* e) {
            jobBids.flat_rate = 0;
        }
        
        @try {
            jobBids.hourly_rate         = [[[jobDetails objectAtIndex:i] valueForKey:@"hourly_rate"] floatValue];
        }
        @catch (NSException* e) {
            jobBids.hourly_rate = 0;
        }
        
        @try {
            jobBids.estimate_low        = [[[jobDetails objectAtIndex:i] valueForKey:@"estimate_low"] floatValue];
        }
        @catch (NSException* e) {
            jobBids.estimate_low = 0;
        }
        
        jobBids.require_onsite      = [[[jobDetails objectAtIndex:i] valueForKey:@"require_onsite"] boolValue];
        jobBids.is_parts_excluded   = [[[jobDetails objectAtIndex:i] valueForKey:@"is_parts_excluded"] boolValue];
        
        jobBids.description         = [[jobDetails objectAtIndex:i]  valueForKey:@"description"];
        jobBids.time_created_fuzzy  = [[jobDetails objectAtIndex:i]  valueForKey:@"time_created_fuzzy"];
        jobBids.eta                 = [[jobDetails objectAtIndex:i]  valueForKey:@"eta"];
        jobBids.winning             = [[jobDetails objectAtIndex:i]  valueForKey:@"winning"];
        jobBids.rejected_by_consumer= [[[jobDetails objectAtIndex:i]  valueForKey:@"rejected_by_consumer"] boolValue];
         
        
        id privateMessages = [[jobDetails objectAtIndex:i]  objectForKey:@"private_messages"];
        if(privateMessages){
            
            NSMutableArray *privateMessagesArray = [[NSMutableArray alloc] init];
            jobBids.privateMessages=privateMessagesArray;
            [privateMessagesArray release];
            privateMessagesArray=nil;
            
            if([privateMessages isKindOfClass:[NSArray class]]){
                for (int i=0; i<[privateMessages count]; i++) {
                    [self retrievePrivateMessages:[privateMessages objectAtIndex:i]];
                }
            }
            else{
                [self retrievePrivateMessages:privateMessages];
            }
        }
        
        NSDictionary * bidProfile   = [[jobDetails objectAtIndex:i]  objectForKey:@"profile"];
        
        [self parseBidProfileDetails:bidProfile];
        
        [resultArray addObject:jobBids];
        [jobBids release];
        jobBids = nil;
    }
    
    return resultArray;
}

- (void)parseBidProfileDetails:(NSDictionary *)result
{
    JobBidProfile *jobBidProfile =  [[JobBidProfile alloc]init];
    //do the parsing
    jobBidProfile.phone            = [result objectForKey:@"phone"];
    jobBidProfile.website            = [result objectForKey:@"website"];
    jobBidProfile.best_name          = [result objectForKey:@"best_name"];
    jobBidProfile.profile_id         = [result objectForKey:@"profile_id"];
    jobBidProfile.review_count       = [result objectForKey:@"review_count"];
    jobBidProfile.license_number     = [result objectForKey:@"license_number"];
    jobBidProfile.location           = [result objectForKey:@"location"];
    jobBidProfile.average_rating     = [result objectForKey:@"average_rating"];
    jobBidProfile.insured_amt        = [result objectForKey:@"insured_amt"];
    jobBidProfile.avatar_url         = [result objectForKey:@"avatar_url"];
    
    jobBidProfile.text_rating        = [result objectForKey:@"text_rating"];
    jobBidProfile.integer_rating     = [result objectForKey:@"integer_rating"];
    jobBidProfile.occupation         = [result objectForKey:@"occupation"];
    jobBidProfile.bonded_amt         = [result objectForKey:@"bonded_amt"];
    
    jobBidProfile.is_insured         = [[result objectForKey:@"is_insured"] boolValue];
    jobBidProfile.is_bonded          = [[result objectForKey:@"is_bonded"] boolValue];
    jobBidProfile.is_licensed        = [[result objectForKey:@"is_licensed"] boolValue];
    jobBidProfile.is_active          = [[result objectForKey:@"is_active"] boolValue];
    
    //checking whether the bid name is same as the winning Name
    if ([jobBidProfile.best_name isEqualToString:[selectedJobDetails.winningBidNames objectAtIndex:0]]) {
   
        //given winning name is present
        NSMutableArray * bidIDs = [[NSMutableArray alloc]init];
        NSString *bidID = [NSString stringWithFormat:@"%d",jobBids.bidID];
        [bidIDs addObject:bidID];
        selectedJobDetails.winningBidIDs = bidIDs;
       // NSLog(@"WinningIDs:-%@",selectedJobDetails.winningBidIDs);
        [bidIDs release];
        bidIDs = nil;
    }
    
    jobBids.jobProfile = jobBidProfile;
    
    NSDictionary *bidRBScore    = [result  objectForKey:@"rb_score"]; 
    [self parseBidRBScore:bidRBScore];
    
    [jobBidProfile release];
    jobBidProfile      = nil;
}

- (void)parseBidRBScore:(NSDictionary *)result
{
    JobRBScore *jobRBScore =  [[JobRBScore alloc]init];
    
    jobRBScore.information   = [[result objectForKey:@"information"] intValue];
    jobRBScore.reputation    = [[result objectForKey:@"reputation"]intValue];
    jobRBScore.total         = [[result objectForKey:@"total"]intValue];
    
    jobBids.jobProfile.rbScore = jobRBScore;
    
    [jobRBScore release];
    jobRBScore = nil;
    
}
-(void)retrieveDetailsOfJobDescription:(NSDictionary *)result {
    
    JobDocuments *jobDoc = [[JobDocuments alloc] init];
    jobResponse.jobDocument = jobDoc;
    [jobDoc release];
    jobDoc = nil;
    
    jobResponse.jobDocument.urlOfImage = [result objectForKey:@"url"];
    jobResponse.jobDocument.thumbnailUrl = [result objectForKey:@"thumbnail_url"];
    id fileType = [result objectForKey:@"file_type"];
    if(!(fileType == [NSNull null])) 
        jobResponse.jobDocument.file_type = [result objectForKey:@"file_type"];
    else
        NSLog(@"FILE TYPE IS NULL");
    jobResponse.jobDocument.mp3_file =[result objectForKey:@"mp3_file"];
    jobResponse.jobDocument.ogg_file =[result objectForKey:@"ogg_file"];
    jobResponse.jobDocument.mp4_file =[result objectForKey:@"mp4_file"];
    jobResponse.jobDocument.ogv_file =[result objectForKey:@"ogv_file"];
    id fileLength = [result objectForKey:@"duration_in_ms"];
    if(!(fileLength == [NSNull null])) {
        jobResponse.jobDocument.duration_in_ms = [fileLength intValue]/1000;
    }        
}

-(void)retrieveDetailsOfJobImageDescription:(NSDictionary *)result {
    
    JobImages *jobImage = [[JobImages alloc] init];
    jobResponse.jobImage=jobImage;
    [jobImage release];
    jobImage = nil;

    jobResponse.jobImage.urlOfImage = [result objectForKey:@"url"];
    jobResponse.jobImage.thumbnailUrl = [result objectForKey:@"thumbnail_url"];
    jobResponse.jobImage.file_type = [result objectForKey:@"file_type"];
    
}

//all job details parsing
- (NSMutableDictionary *)parsingTheResultentArray:(NSArray *)result:(NSString *)keyIdentifier
{
    NSMutableDictionary *resultDic = [[[NSMutableDictionary alloc]init] autorelease];
    NSMutableArray *resultArray = [[[NSMutableArray alloc]init] autorelease];
    
    for (int i = 0; i< [result count]; i++) {
        
        if (!jobResponse) {
            jobResponse = [[JobResponseDetails alloc]init];
        }
        
        int WinningCount = [[[result objectAtIndex:i] objectForKey:@"winning_bid_count"] intValue];
        if (WinningCount>0) {

            if ([[[result objectAtIndex:i] objectForKey:@"winning_bid_provider_names"] count]>0)
            {
                jobResponse.winningBidNames = [[result objectAtIndex:i] objectForKey:@"winning_bid_provider_names"];
            }
        }
  
        //checking whether bid appointment is accepted or not
        NSArray *winningBids = [[result objectAtIndex:i] objectForKey:@"winning_bids"];
        if ([winningBids count]>0) {
            
            NSMutableDictionary * winningBidsDict = [winningBids objectAtIndex:0];  // taking the 1st service
            jobResponse.appointmentAccepted = [[winningBidsDict valueForKey:@"appointment_accepted"] boolValue];
            jobResponse.rejected_by_consumer = [[winningBidsDict valueForKey:@"rejected_by_consumer"] boolValue];
            if ([winningBidsDict valueForKey:@"scheduled_time"] != [NSNull null]) {
                
                int appointmentedDate = [[winningBidsDict valueForKey:@"scheduled_time"] intValue];
                jobResponse.appointmentedDate   = [NSDate dateWithTimeIntervalSince1970:appointmentedDate]; 
            }
        }

        if ([[result objectAtIndex:i]objectForKey:@"time_booked"] != [NSNull null]) {

            int appointmentedDate = [[[result objectAtIndex:i]objectForKey:@"time_booked"] intValue];
            jobResponse.timeBooked   = [NSDate dateWithTimeIntervalSince1970:appointmentedDate]; 
        }
        
        jobResponse.jobType        = keyIdentifier;
        jobResponse.status         = [[result objectAtIndex:i] objectForKey:@"status"];
        jobResponse.status_mobile  = [[result objectAtIndex:i] objectForKey:@"status_mobile"];
        jobResponse.auctionType    = [[result objectAtIndex:i] objectForKey:@"auction_type"];
        jobResponse.jobRequestName = [[result objectAtIndex:i] objectForKey:@"occupation_name"];
        jobResponse.jodDetails     = [[result objectAtIndex:i] objectForKey:@"details"];
        if([NSNull null]!= [[result objectAtIndex:i] objectForKey:@"location_in_launched_zips"] )
        {
           jobResponse.location_in_launched_zips = [[[result objectAtIndex:i] objectForKey:@"location_in_launched_zips"] boolValue];
          
        }
        else
        {
           jobResponse.location_in_launched_zips = NO;
        }
            
        if ([jobResponse.jodDetails isEqualToString:NO_DESCRIPTION_TEXT])
            jobResponse.jodDetails =@"";
                  
        jobResponse.bid_count      = [[[result objectAtIndex:i] objectForKey:@"bid_count"] intValue];
        jobResponse.time_begin_fuzzy = [[result objectAtIndex:i] objectForKey:@"time_begin_fuzzy"];
        
        jobResponse.jobID          = [ NSString stringWithFormat:@"%d",[[[result objectAtIndex:i] objectForKey:@"job_id"] intValue]];
        
        if ([[result objectAtIndex:i] objectForKey:@"time_begin"] != [NSNull null] ||
            [[result objectAtIndex:i] objectForKey:@"time_end"] != [NSNull null]) {
            int startDate = [[[result objectAtIndex:i] objectForKey:@"time_begin"] integerValue];
            int endDate = [[[result objectAtIndex:i] objectForKey:@"time_end"] integerValue];
            jobResponse.startDate           = [NSDate dateWithTimeIntervalSince1970:startDate];
            jobResponse.endDate             = [NSDate dateWithTimeIntervalSince1970:endDate];
        } else {
            jobResponse.startDate = nil;
            jobResponse.endDate = nil;
        }
      
        NSArray *locationID = [[[result objectAtIndex:i] objectForKey:@"location"] componentsSeparatedByString:@" "];
        jobResponse.jobLocationID  = [locationID lastObject];
        
        //***************************** GET JOB DOCUMENTS *****************************
        
        id document = [[result objectAtIndex:i] objectForKey:@"job_documents"];
        if(document){
            NSMutableArray *jobDocuments = [[NSMutableArray alloc] init];
            jobResponse.jobDocuments = jobDocuments;
            [jobDocuments release];
            jobDocuments = nil;
            if([document isKindOfClass:[NSArray class]]){
                for (int i=0; i<[document count]; i++) {
                    [self retrieveDetailsOfJobDescription:[document objectAtIndex:i] ];
                    [jobResponse.jobDocuments addObject:jobResponse.jobDocument];
                }
            }
            else{
                [self retrieveDetailsOfJobDescription:document];
                [jobResponse.jobDocuments addObject:jobResponse.jobDocument];
            }
        }
        
        //***************************** GET JOB IMAGES *****************************
        
        id jobImages = [[result objectAtIndex:i] objectForKey:@"job_images"];
        if(jobImages){
            NSMutableArray *jobImagesArray = [[NSMutableArray alloc] init];
            jobResponse.jobImages = jobImagesArray;
            [jobImagesArray release];
            jobImagesArray = nil;
            
            if([jobImages isKindOfClass:[NSArray class]]){
                for (int i=0; i<[jobImages count]; i++) {
                    [self retrieveDetailsOfJobImageDescription:[jobImages objectAtIndex:i] ];
                    [jobResponse.jobImages addObject:jobResponse.jobImage];
                }
            }
            else{
                [self retrieveDetailsOfJobImageDescription:jobImages];
                [jobResponse.jobImages addObject:jobResponse.jobImage];
            }
        }
        
        //***************************** GET JOB UPDATES *****************************
                
        id updates = [[result objectAtIndex:i] objectForKey:@"updates"];
        if(updates){
            NSMutableArray *updatesArray = [[NSMutableArray alloc] init];
            jobResponse.updates = updatesArray;
            [updatesArray release];
            updatesArray = nil;
            
            if([updates isKindOfClass:[NSArray class]]){
                for (int i=0; i<[updates count]; i++) {
                    [self retrieveJobUpdates:[updates objectAtIndex:i]];
                }
            }
            else
                [self retrieveJobUpdates:updates];
        }
        
        if([jobResponse.updates count]>0){
            JobUpdates *jobUpdate = [jobResponse.updates lastObject];
            jobResponse.jodDetails = [jobUpdate details];
        }
        
        [resultArray addObject:jobResponse];

        [jobResponse release];
        jobResponse  = nil;
    }
    
    NSInteger jobResponseCount = [resultArray count]; 
    [resultDic setObject:resultArray forKey:keyIdentifier];
    [resultDic setObject:keyIdentifier forKey:RESPONSE_TYPE_NAME];
    [resultDic setObject:[NSNumber numberWithInteger:jobResponseCount] forKey:RESPONSE_COUNT_NAME];
    return resultDic;
}   

//#pragma mark - checkers
//
//-(BOOL)isJobCancelledOrKilled:(NSIndexPath *)indexPath {
//    
//    JobResponseDetails *jobDetails = [self readListViewItems:indexPath];
//    BOOL isCancelled = YES;
//    
//    NSString *status = [jobDetails status];
//    if([status  :JOB_STATUS_CANCELLED] || [status isEqualToString:JOB_STATUS_KILLED])
//        isCancelled = NO;
//         
//    
//    return isCancelled;
//}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath	{
    return 110;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableDictionary *result = [tableData objectAtIndex:section];
    int jobCount = [[result valueForKey:RESPONSE_COUNT_NAME] intValue];
    return jobCount;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueStrip.png"]];
    headerImage.alpha = .9;
    
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 20)];
    headerTitle.textColor =	[UIColor whiteColor];
    headerTitle.font=[UIFont boldSystemFontOfSize:14];
    
    NSMutableDictionary *result = [tableData objectAtIndex:section];
    NSString *headerName =[result objectForKey:HEADER_NAME];
    
    headerTitle.text=headerName;
    headerTitle.backgroundColor= [UIColor clearColor];
    headerTitle.textAlignment=UITextAlignmentLeft;
    [headerImage addSubview:headerTitle];
    [headerTitle release];
    headerTitle=nil;
    
    return [headerImage autorelease];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    JobResponseListCell *cell = (JobResponseListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[JobResponseListCell alloc] init] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    JobResponseDetails *jobDetails = [self readListViewItems:indexPath];
    BOOL isCancelled = [jobDetails isJobCancelledOrKilled];
    if(!isCancelled)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    [cell displayJobResponses:jobDetails];   
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JobResponseDetails *jobDetails = [self readListViewItems:indexPath];
    BOOL isCancelled = [jobDetails isJobCancelledOrKilled];
    if(isCancelled)
        return;
    
    self.lastSelectedIndexpath = indexPath;
    Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                      withMessage:@"Loading..." 
                                         animated:YES];
    
    [NSThread detachNewThreadSelector:@selector(getJobDetailsOfJobWithId:) 
                             toTarget:jobRequestResponse 
                           withObject:[self readListViewItems:indexPath].jobID];
    
}

#pragma mark -List Section Items

- (JobResponseDetails *)readListViewItems:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *jobResponseDic = [tableData objectAtIndex:indexPath.section];
    NSString *jobResponseTypeName =[jobResponseDic objectForKey:RESPONSE_TYPE_NAME];
    NSArray *jobResponseArray = [jobResponseDic objectForKey:jobResponseTypeName];
    
    return [jobResponseArray objectAtIndex:indexPath.row];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.jobResponseTable = nil;
    self.defaultImage     = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - alertView delegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TIMEOUT_ALERT_TAG) 
    {
        //DISCARD MEDIAS OR NOT
        if (buttonIndex == 0)
        {
            [self hideOverlay];
            [self checkLoginStatus];
        }
        else {
            if(self.overlay)
                [self hideOverlay];
        }
    }
}

@end