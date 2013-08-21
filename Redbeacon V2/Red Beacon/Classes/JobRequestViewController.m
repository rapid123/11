//
//  JobRequestViewController.m
//  Red Beacon
//
//  Created by Nithin George on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JobRequestViewController.h"
#import "LocationViewController.h"
#import "ScheduleViewController.h"
#import "RBSavedStateController.h"
#import "RBImageProcessor.h"
#import "RBVideoProcessor.h"
#import "RBVideoPreviewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "RBLoginHandler.h"
#import "ELCImagePickerController.h"
#import "RBImagePreviewController.h"
#import "RBTimeFormatter.h"
#import "RBAlertMessageHandler.h"
#import "Reachability.h"
#import "RBAssetsTablePicker.h"
#import "FlurryAnalytics.h"

@interface JobRequestViewController (Private)

- (UILabel *)setTitleLabes:(int)lblSize;

//ButtonActions
- (IBAction)onTouchUpAddVideo:(id)sender;
- (IBAction)onTouchUpAddImage:(id)sender;
- (IBAction)onTouchUpAddFromLibrary:(id)sender;
- (IBAction)onTouchUpAddAudio:(id)sender;
- (IBAction)onTouchUpAddTextDescription:(id)sender;
- (IBAction)onTouchUpSelectLocation:(id)sender;
- (IBAction)onTouchUpSelectSchedule:(id)sender;

- (void)backButtonClicked:(id)sender;
- (void)sendButtonClicked:(id)sender;
- (void)showAudioPreviewContainer;
- (void)showTextPreviewContainer;
- (void)showAudioAndTextPreviewContainer;
- (void)showDefaultAudioTextContainer;
- (void)showDefaultVideoImageContainer;
- (void)showImagePreviewFromCamera;
- (void)showImagePreviewFromLibrary;
- (void)showVideoPreviewContainer;
- (void)checkAudioTextStatus;
- (void)setButtonBoarderColor;

- (void)removeTellUsWYDContainers;
- (void)removeShowUSWYDContainers;
- (void)saveMediaObject:(RBMediaStatusTracker*)mediaTracker;
- (BOOL)isValidInputsAvailable;

- (BOOL)isValidTellUsWYDDataExists;
- (BOOL)isValidShowUsWYDDataExists;
- (BOOL)isValidLocationDetected;
- (BOOL)isValidVideoExists;

- (void)removeAudio;
- (void)removeVideo;
- (void)removeImages;
- (void)discardAllContents;
- (void)pushToLoginView;
- (void)checkAndSendJobRequest;
- (void)hideOverlay;

- (void)removeProgress;
- (void)showProgress;
- (BOOL)isInsideLoginController;

@end

@implementation JobRequestViewController

@synthesize jobTitle;
@synthesize tellUsWYDContainer, showUsWYDCOntainer, videoPreviewContainer;
@synthesize imagePreviewContainer, previewFromCameraButton, previewFromLibraryButton,previewFromAudioButton,     textAudioPreviousButton,textDescriptionButton;
@synthesize locationLabel, scheduleLabel, imagePreviewContainerFromLibrary;
@synthesize audioPreviewContainer, audioAndTextPreviewContainer, textPreviewContainer;
@synthesize audioDurationLabelInAudioContainer, audioDurationLabelInAudioAndTextContainer;
@synthesize jobDescriptionInTDContainer, jobDescriptioninATDCOntainer;
@synthesize photoAddedLabelFromLibrary;
@synthesize overlay;
@synthesize videoThumbnail, multipleImageBackgroundView;

#pragma mark  - JobRequestViewController UIAlertView tags
int kJobReqSuccessTag = 100;
int kJobReqFailureTag = 101;
int kCancelClickedTag = 102;
int kSessionExpiredTag = 103;
 

#pragma mark -

#pragma mark initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupNavigationBar
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0,60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:HOME_NAVIGATION_TITLE forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    item = nil;
    
    [self.navigationItem hidesBackButton];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Send" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"sendButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    button=nil;
    [item release];
    item = nil;
}

#pragma mark - Populate methods
//check for any existing value, if no value exsists insert default value as Flexible
- (void)populateSchedule 
{
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    NSString * type = jRequest.schedule.type;
    NSString * name = nil;
    if (type)
    {
        if ([type isEqualToString:SCHEDULE_TYPE_DATE]) 
        {
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            NSDate * date = jRequest.schedule.date;
            [formatter setDateFormat:@"h:mm aa, MMMM dd, yyyy"];
            name = [formatter stringFromDate:date];
            [formatter release];
            formatter = nil;
        }
        else {
            name = jRequest.schedule.name;
        }
    }   
    else {
        
        jRequest.schedule.type = SCHEDULE_TYPE_FLEXIBLE;
        name = jRequest.schedule.name;
    }
    scheduleLabel.text = name;
}

//chcek for the value loction, if no value exists then default value GPS, So Current Location from XIB will be displayed.
- (void)populateLocation 
{
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    NSString * zipCode = [jRequest.location valueForKey:KEY_LOCATION_ZIP];
    NSString * city = [jRequest.location valueForKey:KEY_LOCATION_CITYNAME];
    //seperating city and state names with ','
    NSArray * placeName = [city componentsSeparatedByString:@", "];
    NSString * locationString = nil;
    NSString *cityName = [NSString stringWithFormat:@"%@",[placeName objectAtIndex:0]];
    if (zipCode) 
    {
        if ([cityName isEqualToString:EMPTY_CITY_NAME]) {
            
         locationString = [NSString stringWithFormat:@"%@", zipCode];  
        }
        else
            //placeName has city @ 0 and state @ 1
            locationString = [NSString stringWithFormat:@"%@, %@", cityName, zipCode];
    }
    else 
    {
        locationString = @"Current Location";
    }
    locationLabel.text = locationString;
}

//check if any audio present, if presnet adds the preview screen.
//else show the default screen.
- (void)checkAudioTextStatus
{
    BOOL isTextDescriptionPresent = NO;
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    NSString * jobDescription = jRequest.jobDescription;
    jobDescription = [jobDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([jobDescription length]>0) {
        isTextDescriptionPresent = YES;
    }
    if ([jRequest isAudioExists] && isTextDescriptionPresent) {
        //show Both
        [self showAudioAndTextPreviewContainer];
    }
    else if ([jRequest isAudioExists]){
        //show audio only
        [self showAudioPreviewContainer];
    }
    else if (isTextDescriptionPresent) {
        //show text description only
        [self showTextPreviewContainer];
    }
    else {
        //nothing is added
        [self showDefaultAudioTextContainer];
    }
}

- (void)checkImageOrVideoStatus {
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    if ([jRequest isVideoExists]) 
    {
        //video exists
        [self showVideoPreviewContainer];
    }
    else if (![jRequest doesImageExists]) {
        //no images & no video
        [self showDefaultVideoImageContainer];
    }
    else {
        
        //images are present
        //NSString * key = [[jRequest.images allKeys] objectAtIndex:0];
        RBMediaStatusTracker * image = [jRequest getFirstImageTracker];
        if (image.isMediaFromLibrary)
        {
            //from Library
            [self showImagePreviewFromLibrary];
        }
        else {
            //from camera
            [self showImagePreviewFromCamera];
        }
    }
    
}

//refreshes all job requests values
//check for availablity of uploading
- (void)refreshView {
    [self populateSchedule];    
    [self populateLocation];
    [self checkAudioTextStatus];
    [self checkImageOrVideoStatus];
    //check for all data, if datas are ready, then make it available to send
    if ([self isValidInputsAvailable]&& !sendButtonTouched)  {

        //datas are available; ready to upload
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else {
        //datas are not available.
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

- (BOOL)isValidInputsAvailable
{
    BOOL available = NO;
    
    //check for all data, if datas are ready, then make it available to send
    if (([self isValidShowUsWYDDataExists] &&
        [self isValidTellUsWYDDataExists] &&
        [self isValidLocationDetected])||
        ([self isValidVideoExists] &&
         [self isValidLocationDetected])||
        ([self isValidTellUsWYDDataExists] &&
        [self isValidLocationDetected]))
    {
        available = YES;
    }
    
    return available;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self setButtonBoarderColor];

    [self initialise]; 
    [self setupNavigationBar];
    
    JobRequest *jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
//    if (!jobRequest)
//    {
//        //[self showJobViewController];
//    }
//    else
    if(jobRequest){
        
        [self restoreView];
    }
}

- (void)setButtonBoarderColor
{
    [previewFromCameraButton.layer setBorderWidth:2.0];
    [previewFromCameraButton.layer setCornerRadius:1.0];
    [previewFromCameraButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [previewFromLibraryButton.layer setBorderWidth:2.0];
    [previewFromLibraryButton.layer setCornerRadius:1.0];
    [previewFromLibraryButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [videoThumbnail.layer setBorderWidth:2.0];
    [videoThumbnail.layer setCornerRadius:1.0];
    [videoThumbnail.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [previewFromAudioButton.layer setBorderWidth:2.0];
    [previewFromAudioButton.layer setCornerRadius:1.0];
    [previewFromAudioButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [textAudioPreviousButton.layer setBorderWidth:2.0];
    [textAudioPreviousButton.layer setCornerRadius:1.0];
    [textAudioPreviousButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [textDescriptionButton.layer setBorderWidth:2.0];
    [textDescriptionButton.layer setCornerRadius:1.0];
    [textDescriptionButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
}
- (void)showJobViewController
{

    [self.navigationController popViewControllerAnimated:YES];
    Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate selectTabbarIndex:1];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [FlurryAnalytics logEvent:@"View - Request"];
    
    [self refreshView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.tellUsWYDContainer = nil;
    self.showUsWYDCOntainer = nil;
    self.videoPreviewContainer = nil;
    self.videoThumbnail = nil;
    self.imagePreviewContainer = nil;
    self.imagePreviewContainerFromLibrary = nil;
    self.audioPreviewContainer = nil;
    self.audioAndTextPreviewContainer = nil;
    self.textPreviewContainer = nil;
    self.audioDurationLabelInAudioAndTextContainer = nil;
    self.audioDurationLabelInAudioContainer = nil;
    self.jobDescriptionInTDContainer = nil;
    self.jobDescriptioninATDCOntainer = nil;
    self.previewFromCameraButton  = nil;
    self.previewFromLibraryButton = nil;
    self.previewFromAudioButton   = nil;
    self.textAudioPreviousButton  = nil;
    self.textDescriptionButton    = nil;
    self.locationLabel = nil;
    self.scheduleLabel = nil;
    self.photoAddedLabelFromLibrary = nil;
    self.multipleImageBackgroundView = nil;
}

- (void)dealloc
{
    self.overlay = nil;
    [jobTitle release];
    
    [fileUploaderHandler release];
    fileUploaderHandler = nil;
    
    videoThumbnail.image = nil;
    
    [videoThumbnail release];
    videoThumbnail = nil;
    
    
    [tellUsWYDContainer release];
    tellUsWYDContainer = nil;
    
    [showUsWYDCOntainer release];
    showUsWYDCOntainer = nil;
    
    [videoPreviewContainer release];
    videoPreviewContainer = nil;
    
    [imagePreviewContainer release];
    imagePreviewContainer = nil;
    
    [imagePreviewContainerFromLibrary release];
    imagePreviewContainerFromLibrary = nil;
    
    [audioPreviewContainer release];
    audioPreviewContainer = nil;
    
    [audioAndTextPreviewContainer release];
    audioAndTextPreviewContainer = nil;
    
    [textPreviewContainer release];
    textPreviewContainer = nil;
    
    [previewFromLibraryButton release];
    previewFromLibraryButton = nil;
    
    [jobDescriptioninATDCOntainer release];
    jobDescriptioninATDCOntainer = nil;
    
    [audioDurationLabelInAudioAndTextContainer release];
    audioDurationLabelInAudioAndTextContainer = nil;
    
    [audioDurationLabelInAudioContainer release];
    audioDurationLabelInAudioContainer = nil;
    
    [jobDescriptionInTDContainer release];
    jobDescriptionInTDContainer = nil;
    
    [previewFromCameraButton release];
    previewFromCameraButton = nil;
    
    [locationLabel release];
    locationLabel = nil;
    
    [scheduleLabel release];
    scheduleLabel = nil;
    
    [photoAddedLabelFromLibrary release];
    photoAddedLabelFromLibrary = nil;
    
    [multipleImageBackgroundView release];
    multipleImageBackgroundView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


#pragma mark -
- (void)initialise
{
    fileUploaderHandler = [[RBFileUploader alloc] init];
    fileUploaderHandler.delegate = self;
    cancelledUploads = NO;
    sendButtonTouched = NO;
    sessionVerified = NO;
    showUploadFailedAlert = YES;
}



#pragma mark - Validation (ShowUS/TellUs)
//returns TRUE:- if audio or jobDescription are selected 
//return FALSE:- if no audio and no job decription are added 
- (BOOL)isValidTellUsWYDDataExists {
    BOOL isDataExists = NO;
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    NSString * jDescription = [jRequest.jobDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     
    //description or audio exists
    if ([jDescription length]>0 || [jRequest isAudioExists]) {
        isDataExists = YES;
    }
    return isDataExists;
}

//returns TRUE:- if any images or video are selected 
//return FALSE:- if no video and no images
- (BOOL)isValidShowUsWYDDataExists 
{
    BOOL isDataExists = NO;
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
   // int imageCount = [jRequest.images count];    
    
    //imageCount or Video exists
    if ([jRequest doesImageExists] || [jRequest isVideoExists]) {
        isDataExists = YES;
    }    
    return isDataExists;
}

- (BOOL)isValidVideoExists
{
    BOOL isDataExists = NO;
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    
    //Video exists
    if ([jRequest isVideoExists]) {
        isDataExists = YES;
    }    
    return isDataExists;
}

/*zipcode string length is checked, we consider zipCode with length 
 greater than 4 is valid, to avoid null value in it.*/
- (BOOL)isValidLocationDetected {
    BOOL isValid = NO;
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    NSString * zipCode = [jRequest.location valueForKey:KEY_LOCATION_ZIP];
    if ([zipCode length]>4) {
        isValid = YES;
    }
    return isValid;
}

#pragma mark -
- (void)setLocation {
    
    //List Heading
    UILabel *listHeading=[[UILabel alloc]initWithFrame:CGRectMake(30, 5, 200, 20)];
    listHeading.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    listHeading.textAlignment=UITextAlignmentLeft;

    listHeading.text= @"Location";
    [self.view addSubview:listHeading];
    [listHeading release];
    listHeading=nil;
}

- (void)goToRequestViewcontroller:(BOOL)status
{
    AudioTextViewController *audioTextViewController = [[AudioTextViewController alloc] 
                                                        initWithNibName:@"AudioTextViewController" 
                                                        bundle:nil];
    audioTextViewController.viewStatus = status;
    audioTextViewController.delegate = self;
    [self.navigationController pushViewController:audioTextViewController animated:YES];
    [audioTextViewController release];
    audioTextViewController = nil;
    
}

#pragma mark - Camera Handler methods
- (BOOL)isDeviceHasCamera
{
    BOOL isAvailable = NO;
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] ||
        [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
    {
        isAvailable = YES;
    }
    
    return isAvailable;
}

- (void)sendJobRequest 
{    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];

    RBJobRequest * jobReq = [[RBJobRequest alloc] init];    
    
    NSString * occupationName = [[ManagedObjectContextHandler sharedInstance] 
                                 getInternalNameForDisplayName:jRequest.jobName];
    
    jobReq.occupationName = occupationName;
    jobReq.jobTimeSelector = jRequest.schedule.type;
    jobReq.approxLocation = [jRequest.location valueForKey:KEY_LOCATION_ZIP];
    if([jRequest.jobDescription length] ==0)
    {
        jobReq.details = NO_DESCRIPTION_TEXT;  
    }
    else
    {
        jobReq.details = jRequest.jobDescription;
    }
    jobReq.jobImageIDs = [jRequest getMediaIds];
    jobReq.flexibleOption = @"D";
    jobReq.date = [jRequest.schedule dateString];
    RBTimeFormatter * formatter = [[RBTimeFormatter alloc] init];
    int jobBegin = [formatter timeValueForDate:jRequest.schedule.date];
    [formatter release];
    NSNumber * number = [NSNumber numberWithInt:jobBegin];
    jobReq.hrMinTimeBegin = number;
    jobReq.hrMinTimeEnd = number;
    jobReq.altDate = @"";
    number = [NSNumber numberWithInt:19];
    jobReq.altHrMinTimeBegin = number;
    number = [NSNumber numberWithInt:21];
    jobReq.altHrMinTimeEnd = number;
    
    if (jobRequestHandler)
    {
        [jobRequestHandler release];
        jobRequestHandler = nil;
    }
    
    jobRequestHandler = [[RBJobRequestHandler alloc] init];
    jobRequestHandler.delegate = self;
    [jobRequestHandler prepareJobRequestPart1:jobReq];
    [jobReq release];
    
    [pool drain];
}

- (void)checkAndSendJobRequest
{
    do
    {
        if (![Reachability connected]) 
        {
            sendButtonTouched = NO;
            [self hideOverlay];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.navigationItem.leftBarButtonItem.enabled = YES;
            
            break;
        }
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
        
        [NSThread detachNewThreadSelector:@selector(sendJobRequest) 
                                 toTarget:self 
                               withObject:nil];
        break;
        
    } while (0); 
}


-(void)queueFinished:(ASIHTTPRequest *)request
{
    showUploadFailedAlert = YES;
    
    if (sendButtonTouched)
    {
       // [self hideOverlay];
        [self sendButtonClicked:self];
    }
    
  
}

#pragma mark - Overlay Method
- (void)hideOverlay 
{
    if (self.overlay)
    {
        [self.overlay removeFromSuperview:YES];
        self.overlay = nil;
    }
    
}

#pragma mark - Clear Methods
- (void)discardAllContents {

    //physical folders are removed
    [self removeAudio];
    [self removeImages];
    [self removeVideo];
    
    //removes the old data in the sharedObject 
    [[RBSavedStateController sharedInstance] clearJobRequest];

}

//removes the audio from its path
- (void)removeAudio {
    NSError * error = nil;
    NSString *imagesDirectory = [RBDirectoryPath redBeaconAudiosDirectory];
    [[NSFileManager defaultManager] removeItemAtPath:imagesDirectory error:&error];
    if (error) {
        NSLog(@"Error occured while deleting the folder Audios");
    }
}

//removes the videos from its path
- (void)removeVideo {
    RBVideoProcessor * processor = [[RBVideoProcessor alloc] init];
    [processor deleteAllVideos];
    [processor release];
    processor = nil;
}

//remove the mimages path
- (void)removeImages {
    RBImageProcessor * processor = [[RBImageProcessor alloc] init];
    [processor deleteAllImages];
    [processor release];
    processor = nil;
}

#pragma mark -
#pragma mark - BUTTON ACTIONS
- (void)backButtonClicked:(id)sender  // cancel button
{    
    
    JobRequest * jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
    if ([jobRequest isJobRequestDataAvailable])
    {
        [RBAlertMessageHandler showAlertWithTitle:@"Discard Content(s)" 
                                          message:@"This will discard all your current data.\
                                                    Do you want to continue?" 
                                   delegateObject:self 
                                          viewTag:kCancelClickedTag 
                                 otherButtonTitle:@"OK" showCancel:YES];
        
    }
    else
    {
        [self discardAllContents];
        [self showJobViewController];
    }
}

- (void)sendButtonClicked:(id)sender
{    
    [FlurryAnalytics logEvent:@"Send Button"];

    Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    sendButtonTouched = YES;

    if ([self isInsideLoginController]) 
    {
        return;
    }
    else if (![RBBaseHttpHandler isSessionInfoAvailable])
    {
        [self pushToLoginView];
    }
    else if (!sessionVerified && [RBBaseHttpHandler isSessionInfoAvailable])
    {
        self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                          withMessage:@"Verifying current session..." 
                                             animated:YES];
            
        loginHandler = [[RBLoginHandler alloc] init];
        loginHandler.delegate = self;
        [loginHandler sendSessionExpiryRequest];
    }
    else
    {
        // Do the other activities related to sending job requests
        [self continueSending];
    }
}

// This function does the other activities related to sending job requests
- (void)continueSending
{
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (![jRequest areAllMediaSuccessfullyUploaded])
    {
        if (self.overlay)
        {
            NSLog(@"areAllMediaSuccessfullyUploaded: overlay exists");
            overlay.message.text = @"Sending job request...";
        }
        else
        {
            NSLog(@"areAllMediaSuccessfullyUploaded: create new overlay");
            self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                              withMessage:@"Sending job request..." 
                                                 animated:YES];
        }
        
        // Some media are still not successfully uploaded
        [self checkAndResumePendingMediaUploads];
        
    }
    else 
    {
        if (self.overlay)
        {
            overlay.message.text = @"Sending job request...";
        }
        else
        {
            self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                          withMessage:@"Sending job request..." 
                                             animated:YES];
        }
        
        [self checkAndSendJobRequest];
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

- (BOOL)isInsideLoginController 
{
    BOOL isTryingToLogin = NO;
    
    if ([self.navigationController.topViewController isKindOfClass:[LoginViewController class]]) {
        isTryingToLogin = YES;
    }
    return isTryingToLogin;
}

-(void)sessionValid:(BOOL)status
{
    if(status)
    {
        NSLog(@"SESSIONEXPIRY: session valid");
        sessionVerified = YES;
        [self continueSending];
    }
    else
    {
        [self hideOverlay];
        NSLog(@"SESSIONEXPIRY: session expired");
        [RBAlertMessageHandler showAlert:@"Your session has expired. Please log in." 
                                   delegateObject:self 
                                          viewTag:kSessionExpiredTag];
    }
}

- (void)pushToLoginView 
{    
  
    LoginViewController *loginViewController = [[LoginViewController alloc]
                                                initWithNibName:@"LoginViewController" 
                                                bundle:nil];
    loginViewController.delegate = self;
    loginViewController.isDefaultSignUp = YES;
    [self.navigationController pushViewController:loginViewController animated:YES];
    [loginViewController release];
    loginViewController = nil;
}


#pragma mark - ADD
- (IBAction)onTouchUpAddVideo:(id)sender
{
    [FlurryAnalytics logEvent:@"Add Video Button"];
    
    if ([self isDeviceHasCamera]) 
    {        
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeMovie];
        picker.delegate = self;
        picker.videoMaximumDuration = 60.0;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    
    }
    else 
    { 
        [RBAlertMessageHandler showAlert:@"Sorry, video recording is not available on your device."
                          delegateObject:nil];
    }
}

- (IBAction)onTouchUpAddImage:(id)sender 
{
    [FlurryAnalytics logEvent:@"Add Image Button"];
    
    if ([self isDeviceHasCamera])
    {        
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.delegate = self;
        [picker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
        picker.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil] autorelease];
        [self presentModalViewController:picker animated:YES];
        [picker release];
        
    }
    else 
    { 
        [RBAlertMessageHandler showAlert:@"Sorry, your device does not have a camera." 
                          delegateObject:nil];
    }    
}

- (IBAction)onTouchUpAddFromLibrary:(id)sender 
{    
    [FlurryAnalytics logEvent:@"Add From Library Button"];
    
    RBAssetsTablePicker *assetsPicker = [[RBAssetsTablePicker alloc] initWithNibName:@"RBAssetsTablePicker" 
                                                                              bundle:[NSBundle mainBundle]];    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:assetsPicker];
    [assetsPicker setParent:elcPicker];
    [elcPicker setDelegate:self];    
    [self presentModalViewController:elcPicker animated:YES];
    [elcPicker release];
    [assetsPicker release];
}

- (IBAction)onTouchUpAddAudio:(id)sender
{    
    [FlurryAnalytics logEvent:@"Add Audio Button"];
    
    [self goToRequestViewcontroller:YES];
    
}

- (IBAction)onTouchUpAddTextDescription:(id)sender {
    [FlurryAnalytics logEvent:@"Add Text Button"];
    
    [self goToRequestViewcontroller:NO];
}

- (IBAction)onTouchUpSelectSchedule:(id)sender {
    [FlurryAnalytics logEvent:@"Select Schedule Button"];
    
    [self showSchedule];
}

- (IBAction)onTouchUpSelectLocation:(id)sender {
    [FlurryAnalytics logEvent:@"Select Location Button"];
    
    [self showLocation];
}

#pragma mark - PLAY
- (IBAction)onTouchUpPlayVideo:(id)sender {    
    [FlurryAnalytics logEvent:@"Play Video Button"];
    
    RBVideoPreviewController * previewController;
    previewController = [[RBVideoPreviewController alloc] 
                         initWithNibName:[RBVideoPreviewController getnibName] 
                         bundle:nil];
    [self.navigationController pushViewController:previewController animated:NO];
    [previewController setParent:self];
    [previewController release];
    previewController = nil;
}

- (IBAction)onTouchUpShowImage:(id)sender {
    [FlurryAnalytics logEvent:@"Show Image Button"];
    
    RBImagePreviewController * previewController;
    previewController = [[RBImagePreviewController alloc] 
                         initWithNibName:[RBImagePreviewController getnibName] 
                         bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:previewController animated:NO];
    [previewController setParent:self];
    [previewController release];
    previewController = nil;
}

- (IBAction)onTouchUpShowLibrary:(id)sender {
    [FlurryAnalytics logEvent:@"Show Library Button"];
    
    [self onTouchUpAddFromLibrary:nil];
}

#pragma mark -

#pragma mark - Show Containers
- (void)showLocation {
    LocationViewController *locationViewController=[[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil];
    
	[self.navigationController pushViewController:locationViewController animated:YES];
    [locationViewController release];
    locationViewController = nil;
    
}

- (void)showSchedule {
    ScheduleViewController *scheduleViewController=[[ScheduleViewController alloc]initWithNibName:@"ScheduleViewController" bundle:nil];
    
  	[self.navigationController pushViewController:scheduleViewController animated:YES];
    [scheduleViewController release];
    scheduleViewController=nil;
    
}

- (void)showDefaultVideoImageContainer {
    [self removeShowUSWYDContainers];
    CGRect suwydContainerFrame = showUsWYDCOntainer.frame;
    [self.view addSubview:showUsWYDCOntainer];
    [showUsWYDCOntainer setFrame:suwydContainerFrame];
}

- (void)showVideoPreviewContainer {    
    CGRect suwydContainerFrame = showUsWYDCOntainer.frame;
    [self removeShowUSWYDContainers];
    [self.view addSubview:videoPreviewContainer];
    [videoPreviewContainer setFrame:suwydContainerFrame];
    
    RBVideoProcessor * processor = [[RBVideoProcessor alloc] init];
    UIImage * image = [[UIImage alloc] initWithContentsOfFile:[processor thumbnailPath]];
    [processor release];
    self.videoThumbnail.image = [image imageByScalingAndCroppingForSize:CGSizeMake(273, 76)];
    [image release];
    
}

- (void)showImagePreviewFromCamera {    
    CGRect suwydContainerFrame = showUsWYDCOntainer.frame;
    [self removeShowUSWYDContainers];
    [self.view addSubview:imagePreviewContainer];
    [imagePreviewContainer setFrame:suwydContainerFrame];
    JobRequest * jobRequest = [[RBSavedStateController sharedInstance] jobRequest];

    NSString * imagePath = [jobRequest getFirstImagePath];
    UIImage * previewImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [previewFromCameraButton setImage:[previewImage imageByScalingAndCroppingForSize:CGSizeMake(273, 76)] forState:UIControlStateNormal];
    [previewFromLibraryButton setImage:[previewImage imageByScalingAndCroppingForSize:CGSizeMake(273, 76)] forState:UIControlStateNormal];
    [previewImage release];
    previewImage = nil;
    
}

- (void)showImagePreviewFromLibrary {
    CGRect suwydContainerFrame = showUsWYDCOntainer.frame;
    [self removeShowUSWYDContainers];
    [self.view addSubview:imagePreviewContainerFromLibrary];
    [imagePreviewContainerFromLibrary setFrame:suwydContainerFrame];
    JobRequest * jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
    
    NSString * imagePath = [jobRequest getLastImagePath];
    UIImage * previewImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    [previewFromCameraButton setImage:[previewImage imageByScalingAndCroppingForSize:CGSizeMake(273, 76)] forState:UIControlStateNormal];
    [previewFromLibraryButton setImage:[previewImage imageByScalingAndCroppingForSize:CGSizeMake(273, 76)] forState:UIControlStateNormal];
    [previewImage release];
    previewImage = nil;
    
    photoAddedLabelFromLibrary.text = [NSString stringWithFormat:@"%d Photo(s) Added", 
                                       [jobRequest getImageCount]];
    
    if ([jobRequest getImageCount]>1)
    {
         [multipleImageBackgroundView setHidden:NO];
    }
    else
    {
         [multipleImageBackgroundView setHidden:YES];
    }
}

- (void)showAudioPreviewContainer {
    CGRect tuwydContainerFrame = tellUsWYDContainer.frame;
    [self removeTellUsWYDContainers];
    [self.view addSubview:audioPreviewContainer];
    [audioPreviewContainer setFrame:tuwydContainerFrame]; 
    JobRequest * jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
    audioDurationLabelInAudioContainer.text = [jobRequest getAudioDuration];
}

- (void)showAudioAndTextPreviewContainer {
    CGRect tuwydContainerFrame = tellUsWYDContainer.frame;
    [self removeTellUsWYDContainers];
    [self.view addSubview:audioAndTextPreviewContainer];
    [audioAndTextPreviewContainer setFrame:tuwydContainerFrame];     
    JobRequest * jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
    audioDurationLabelInAudioAndTextContainer.text = [jobRequest getAudioDuration];
    jobDescriptioninATDCOntainer.text = jobRequest.jobDescription;
}

- (void)showTextPreviewContainer {
    CGRect tuwydContainerFrame = tellUsWYDContainer.frame;
    [self removeTellUsWYDContainers];
    [self.view addSubview:textPreviewContainer];
     JobRequest * jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
    [textPreviewContainer setFrame:tuwydContainerFrame];  
    jobDescriptionInTDContainer.text = jobRequest.jobDescription;
}

- (void)showDefaultAudioTextContainer {
    CGRect tuwydContainerFrame = tellUsWYDContainer.frame;
    [self removeTellUsWYDContainers];
    [self.view addSubview:tellUsWYDContainer];
    [tellUsWYDContainer setFrame:tuwydContainerFrame];      
}

- (void)removeTellUsWYDContainers {
    [audioPreviewContainer removeFromSuperview];
    [textPreviewContainer removeFromSuperview];
    [audioAndTextPreviewContainer removeFromSuperview];
    [tellUsWYDContainer removeFromSuperview];
}

- (void)removeShowUSWYDContainers {
    [imagePreviewContainer removeFromSuperview];
    [imagePreviewContainerFromLibrary removeFromSuperview];
    [videoPreviewContainer removeFromSuperview];
    [showUsWYDCOntainer removeFromSuperview];
    [multipleImageBackgroundView setHidden:YES];
    
}

#pragma mark - Progress
- (void)progress {
    [progressView setProgress:progressValue];
    progressValue = progressValue + progressIncrement;
    
}

- (void)removeProgress {
    NSLog(@"Removing Progress...");
    [timer invalidate];
    [progressView removeFromSuperview];
    
    UIView * view = [self.view viewWithTag:300];
    [view removeFromSuperview];
    
    [self refreshView];
}

- (void)showProgress:(NSString*)text {
    
    NSLog(@"Showing Progress...");
    [self removeShowUSWYDContainers];
    
    progressView = (PDColoredProgressView *)[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [progressView setFrame:CGRectMake(85, 55, 150, 10)];
    [self.view addSubview:progressView];
    [self.view bringSubviewToFront:progressView];
    [progressView release];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(85, 70, 150, 30)];
    [label setText:text];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:14.0]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTag:300];
    [self.view addSubview:label];
    [label release];
        
    progressValue = 0.0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self 
                                           selector:@selector(progress) 
                                           userInfo:nil 
                                            repeats:YES];
    
    [self performSelector:@selector(removeProgress) 
               withObject:nil 
               afterDelay:1.5];
}
#pragma mark - Saving Medias

- (void)saveMediaFromCamera:(NSDictionary*)info 
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    BOOL queuedRequest;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
        [jRequest removeAllImages];

        NSDate* startDate = [NSDate date];
        RBImageProcessor * imageProcessor = [[RBImageProcessor alloc] init];
        [imageProcessor deleteAllImages];
        NSString * imagePath = [imageProcessor saveImage:[info objectForKey:UIImagePickerControllerOriginalImage] withName:nil];
        [imageProcessor release];
        imageProcessor = nil;
        NSDate* endDate = [NSDate date];
        NSLog(@"Save Image Total Time Duration: %f", [endDate timeIntervalSinceDate:startDate]);
        [FlurryAnalytics logEvent:@"Save Image"];
               
        queuedRequest = [fileUploaderHandler queueUploadRequests:imagePath ofMediaType:kImage];

        if (queuedRequest)
        {
            //save image into array
            RBMediaStatusTracker * imageTracker = [[RBMediaStatusTracker alloc] init];    
            imageTracker.mediaUrl = imagePath;
            imageTracker.mediaType = kImage;
            imageTracker.mediaStatus = kWaitingForUpload;
            imageTracker.isMediaFromLibrary = NO;
            [jRequest addImage:imageTracker];
            [imageTracker release];
            imageTracker = nil;
        }
        else
        {            
            [RBAlertMessageHandler showAlert:@"Unable to identify mime type of image"
                              delegateObject:nil];
        }
    }
    else if ([mediaType isEqualToString:@"public.movie"])
    {		
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        RBVideoProcessor * videoProcessor = [[RBVideoProcessor alloc] init];
        NSString * videoPath = [videoProcessor saveVideo:videoURL];
        [videoProcessor release];
        videoProcessor = nil;
        [FlurryAnalytics logEvent:@"Save Video"];
       
        queuedRequest = [fileUploaderHandler queueUploadRequests:videoPath ofMediaType:kVideo];
        if (queuedRequest)
        {
            JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
            [jRequest enqueueVideoWithPath:videoPath];
        }
        else
        {
            [RBAlertMessageHandler showAlert:@"Unable to identify mime type of video" 
                              delegateObject:nil];
        }
    }   
    [pool drain];
}

- (void)saveMediaFromLibrary:(NSArray*)infos
{   
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

   BOOL queuedRequest;
    int index = 0;
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    [jRequest removeAllImages];
    RBImageProcessor * imageProcessor = [[RBImageProcessor alloc] init];
    [imageProcessor deleteAllImages];
    
    for(NSDictionary *dict in infos) 
    {
        NSString * stringIndex = [NSString stringWithFormat:@"%d", index];
        
        NSString * imagePath = [imageProcessor saveImage:[dict objectForKey:UIImagePickerControllerOriginalImage] withName:stringIndex];
        
        queuedRequest = [fileUploaderHandler queueUploadRequests:imagePath ofMediaType:kImage];
        NSLog(@"---Queued request for %@", imagePath);
        if (queuedRequest)
        {
            //save image into array
            RBMediaStatusTracker * image = [[RBMediaStatusTracker alloc] init];
            image.mediaUrl = imagePath;
            image.mediaType = kImage;
            image.mediaStatus = kWaitingForUpload;
            image.isMediaFromLibrary = YES;
            image.uniqueUrl = [dict valueForKey:@"UIImagePickerControllerReferenceID"];
            [jRequest addImage:image];
            [image release];
            
        }
        else
        {
            [RBAlertMessageHandler showAlert:@"Unable to identify mime type of image"
                              delegateObject:nil];
        }        
        
        
        ++index;
    }
    
    
    [imageProcessor release];
    imageProcessor = nil;
    
    if ([infos count] == [jRequest getImageCount])
    {
        [self refreshView];
    }

    [pool drain];

}
#pragma mark - DELEGATE METHODS
#pragma mark PickerView delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSDate *startDate = [NSDate date];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSString * message;
    if ([mediaType isEqualToString:@"public.image"])
    {
        message = @"Adding Image...";
        progressIncrement = 0.1;
    }
    else 
    {
        progressIncrement = 0.1;
        message = @"Adding Video...";
    }
    [picker dismissModalViewControllerAnimated:YES];
//    [self showProgress:message];
//    [NSThread detachNewThreadSelector:@selector(saveMediaFromCamera:) 
//                             toTarget:self 
//                           withObject:info];
    
    [self performSelector:@selector(showProgress:) withObject:message afterDelay:0.1];
    [self saveMediaFromCamera:info];
  
       
    NSDate *endDate = [NSDate date];
    
    NSLog(@"Photo Capture Time elapsed: %f", [endDate timeIntervalSinceDate:startDate]);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)infos
{
    NSDate *startDate = [NSDate date];
    NSString * message = nil;
    JobRequest* jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    
    if ([jRequest getImageCount]<=0&&[infos count]<=0){
        //do nothing, since nothing is selected, nothing exists already. 
        [jRequest removeAllImages];
        RBImageProcessor * imageProcessor = [[RBImageProcessor alloc] init];
        [imageProcessor deleteAllImages];
        [imageProcessor release];
    }
    else {
       
        if ([infos count]>0) 
        {
            message = @"Adding Image(s)...";            
        }
        else if([jRequest getImageCount]>0 && [infos count]<=0)
        {
            message = @"Removing Image(s)...";            
        }
        
        progressIncrement = 0.1;
        
        [self performSelector:@selector(showProgress:) withObject:message afterDelay:0.1];
        [self saveMediaFromLibrary:infos];
//        [self showProgress:message];
//        [NSThread detachNewThreadSelector:@selector(saveMediaFromLibrary:) 
//                                 toTarget:self 
//                               withObject:infos];
       
        NSDate *endDate = [NSDate date];
        
        NSLog(@"Image Library Selection Time elapsed: %f", [endDate timeIntervalSinceDate:startDate]);

    }

    [picker dismissModalViewControllerAnimated:YES];  
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark RBBaseHTTPHandler Delegate
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request
{   
    RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
    do 
    {
         
        if (requestType == kUploadMediaRequest)
        {
            NSLog(@"JobRequestViewController:requestCompletedSuccessfully fired for kUploadMediaRequest");
            break;
        }
        
        if (requestType == kJobRequestP1)
        {
            NSString* errorData = [[request responseHeaders] objectForKey:@"X-Rb-Error"];
            
            if (errorData == nil)
            {
                requestType = kJobRequestP2;
                
                NSLog(@"request Type: %d", requestType);
                [jobRequestHandler prepareJobRequestPart2];
            }
            else
            {
                // Some error occurred
                [self hideOverlay];
                sendButtonTouched = NO;
                self.navigationItem.rightBarButtonItem.enabled = YES;
                self.navigationItem.leftBarButtonItem.enabled = YES;
                [RBAlertMessageHandler showAlert:AS_FAILED_PREPARE_JOB_REQ_ALERT_MESSAGE
                                  delegateObject:nil];
            }
            
            break;
        }
        
        if (requestType == kJobRequestP2)
        {
            // If we reach here, requestType is kJobRequestP2;
            [self hideOverlay];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.navigationItem.leftBarButtonItem.enabled = YES;
            sendButtonTouched = NO;
            
            NSString* errorData = [[request responseHeaders] objectForKey:@"X-Rb-Error"];
            
            if (errorData == nil)
            {
                JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
                NSString * title = [NSString stringWithFormat:@"%@ \nRequest Received!", jRequest.jobName];
                
                [self showJobViewController];
                Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[[UIApplication sharedApplication] delegate];
                [appDelegate selectTabbarIndex:0];
                [RBAlertMessageHandler showAlertWithTitle:title
                                                  message:kJobRequestSendSuccesfullAlertMessage 
                                           delegateObject:nil
                                                  viewTag:kJobReqSuccessTag 
                                         otherButtonTitle:@"OK" 
                                               showCancel:NO];
                [self discardAllContents];
            }
            else
            {
                [RBAlertMessageHandler showAlert:AS_FAILED_CONFIRM_JOB_REQ_ALERT_MESSAGE
                                  delegateObject:nil];
            }
            
            break;
        }
        
    } while (0);
    
}

- (void)requestCompletedWithErrors:(ASIHTTPRequest*)request
{
    do 
    {
        [self hideOverlay];
        
        sendButtonTouched = NO;
        
        [self refreshView];
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        
        if (cancelledUploads)
        {
            break;
        }
        
        NSString* alertMsg = @"";
        
        RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
        
        if (request == nil)
        {
            // You will reach here only if no internet connection exists
            break;
        }
        
        if (requestType == kUploadMediaRequest) 
        {
            if (showUploadFailedAlert) 
            {
                [RBAlertMessageHandler showAlert:AS_FAILED_MEDIA_UPLOAD_REQ_ALERT_MESSAGE
                                  delegateObject:nil];
                
                showUploadFailedAlert = NO;
            }
            
            break;
        }
        else if (requestType == kSessionExpiry)
        {
            alertMsg = AS_FAILED_SESSION_EXPIRY_REQ_ALERT_MESSAGE;
        }
        else if (requestType == kJobRequestP1)
        {
            alertMsg = AS_FAILED_PREPARE_JOB_REQ_ALERT_MESSAGE;
        }
        else // requestType == kJobRequestP2
        {
            alertMsg = AS_FAILED_CONFIRM_JOB_REQ_ALERT_MESSAGE;
        }
        
        [RBAlertMessageHandler showAlert:alertMsg
                          delegateObject:nil];

    } while (0);
}

#pragma mark RBAudioViewDelegate
- (void)audioViewDoneButtonFired:(NSString*)audioPath
{
    BOOL queuedRequest = [fileUploaderHandler queueUploadRequests:audioPath ofMediaType:kAudio];

    if (queuedRequest)
    {
        JobRequest * jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
        [jobRequest enqueueAudioWithPath:audioPath];
    }
    else
    {
        [RBAlertMessageHandler showAlert:@"Unable to identify mime type of audio"
                          delegateObject:nil];
    }  
}
#pragma mark -

#pragma mark RBLoginDelegate
// Once login is successful continue with the send process
- (void)loginSuccessful
{
    if (sendButtonTouched)
    {
        [self continueSending];
    }
    
}

- (void)loginCancelled 
{
    sendButtonTouched = NO;
}

#pragma mark -

#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kJobReqSuccessTag)
    {
        [self showJobViewController];
        
    }
    else if (alertView.tag == kCancelClickedTag) 
    {
        //DISCARD MEDIAS OR NOT
        if (buttonIndex == 0)
        {
            //onContinue
            cancelledUploads = YES;
            [self discardAllContents];
            [RBFileUploader cancelAllUploadRequests];
            [self showJobViewController];
        } 
    }
    else if (alertView.tag == kSessionExpiredTag)
    {
        // Session expired, so show login view
        [self pushToLoginView];
    }
    
}

#pragma mark Preview Page Delegates
- (void)videoDidRetake
{
    [self onTouchUpAddVideo:nil];
}
- (void)ImageDidRetake
{
    [self onTouchUpAddImage:nil];
}


-(void)showOldSession:(NSString*)jobName {
   
    self.jobTitle = jobName;
    [self.navigationItem setRBTitle:jobTitle withSubTitle:kJRCSubTitle];
    
    Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate startGPSScan];
    [appDelegate setDelegate:self];
}

#pragma mark - 

#pragma mark JobViewControllerDelegate

- (void)jobViewDidUnload:(NSString*)jobName
{
    RBSavedStateController *stateSaver = [RBSavedStateController sharedInstance];
    self.jobTitle = jobName;
    JobRequest *jobRequest = [[JobRequest alloc] init];
    jobRequest.jobName = jobTitle;
    [stateSaver saveJobRequest:jobRequest];
    [jobRequest release];
    
//    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    //[self.navigationController popViewControllerAnimated:NO];    
    
    [self.navigationItem setRBTitle:jobTitle withSubTitle:kJRCSubTitle];
    
    Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate startGPSScan];
    [appDelegate setDelegate:self];

}
#pragma mark -
- (void)restoreView
{
    JobRequest * jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
    
    if (jobRequest)
    {
        // Set job name
        self.jobTitle = jobRequest.jobName;
        [self.navigationItem setRBTitle:jobTitle withSubTitle:kJRCSubTitle];
        [self checkAndResumePendingMediaUploads];
    }
    else
    {
        // Waaaah, no state???
    }
}
#pragma mark -

// This function checks if there are any media uploads pending due to any abrupt
// exit of the app and resumes it
- (void)checkAndResumePendingMediaUploads
{
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    if (![jRequest areAllMediaSuccessfullyUploaded])
    {
        // Check if video exists for upload
        if ([jRequest isVideoExists])
        {
            RBMediaStatusTracker *videoTracker = [jRequest getVideoTracker];
            if (videoTracker.mediaStatus == kWaitingForUpload)
            {
                // video is not uploaded yet.
                [fileUploaderHandler queueUploadRequests:videoTracker.mediaUrl ofMediaType:kVideo];
            }
        }
        
        // Check if audio exists for upload
        if ([jRequest isAudioExists])
        {
            RBMediaStatusTracker *audioTracker = [jRequest getAudioTracker];
            if (audioTracker.mediaStatus == kWaitingForUpload)
            {
                // audio is not uploaded yet
                [fileUploaderHandler queueUploadRequests:audioTracker.mediaUrl ofMediaType:kAudio];
            }
        }
             
        // Check if image(s) exists for upload
        if ([jRequest doesImageExists])
        {
            NSArray* imagePaths = [jRequest getAllImagePaths];
            for (int i = 0; i < [imagePaths count]; i++)
            {
                NSString* imagePath = [imagePaths objectAtIndex:i];
                RBMediaStatusTracker *imageTracker = [jRequest getImageTrackerForImagePath:imagePath];
                if (imageTracker.mediaStatus == kWaitingForUpload)
                {
                    // audio is not uploaded yet
                    [fileUploaderHandler queueUploadRequests:imageTracker.mediaUrl ofMediaType:kImage];
                }
            }
        }
    }
}

#pragma mark- GPRS Location response delegate
- (void)newLocationDidSaved {
    [self populateLocation];
}

@end
