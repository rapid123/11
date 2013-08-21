//
//  JobDetailViewController.m
//  Red Beacon
//
//  Created by sudeep on 07/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "JobDetailViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "Red_BeaconAppDelegate.h"
#import "RBSavedStateController.h"
#import "JobRequestViewController.h"
#import "JobResponseDetails.h"
#import "LocationViewController.h"
#import "ScheduleViewController.h"
#import "RBSavedStateController.h"
#import "RBImageProcessor.h"
#import "RBVideoProcessor.h"
#import "RBVideoPreviewController.h"
#import "RBLoginHandler.h"
#import "ELCImagePickerController.h"
#import "RBImagePreviewController.h"
#import "RBTimeFormatter.h"
#import "RBAlertMessageHandler.h"
#import "Reachability.h"
#import "RBAssetsTablePicker.h"
#import "ManagedObjectContextHandler.h"
#import "RBCurrentJobResponse.h"
#import "CancelViewController.h"
#import "ResponseAudioTextViewController.h"
#import "MWPhotoBrowser.h"
#import "FlurryAnalytics.h"

#define ACTIVITY_FRAME CGRectMake(150, 50, 20, 20);
#define ACTIVITYINDICATOR_TAG 444

@class Red_BeaconAppDelegate;

@interface JobDetailViewController (Private)

- (void)initialise;
- (void)setButtonBoarderColor;
- (void)refreshView;
- (void)populateSchedule;
- (void)populateLocation;
- (void)checkAudioTextStatus;
- (void)checkImageOrVideoStatus;

- (void)removeTellUsWYDContainers;
- (void)removeShowUSWYDContainers;

- (void)showAudioAndTextPreviewContainer;
- (void)showTextPreviewContainer ;
- (void)showDefaultAudioTextContainer;
- (void)showAudioPreviewContainer;

- (void)showImageThumbnail:(JobImages *)thumbnailImage;
- (void)showVideoPreviewContainer ;
- (void)showDefaultVideoImageContainer ;

@end

@implementation JobDetailViewController


static NSString* kDetailTitle = @"Details";

@synthesize isAppointmentPresent;
@synthesize jobDetail;
@synthesize backgroundImage;

@synthesize tellUsWYDContainer, showUsWYDCOntainer, videoPreviewContainer;
@synthesize imagePreviewContainer, previewFromCameraButton, previewFromLibraryButton,previewFromAudioButton,     textAudioPreviousButton,textDescriptionButton;
@synthesize locationLabel, scheduleLabel, imagePreviewContainerFromLibrary;
@synthesize audioPreviewContainer, audioAndTextPreviewContainer, textPreviewContainer;
@synthesize audioDurationLabelInAudioContainer, audioDurationLabelInAudioAndTextContainer;
@synthesize jobDescriptionInTDContainer, jobDescriptioninATDCOntainer;
@synthesize photoAddedLabelFromLibrary;
@synthesize overlay;
@synthesize videoThumbnail, multipleImageBackgroundView;
@synthesize updatedDateAndTimeImage,updatedDateAndTimeVideo, updatedDateAndTimeNoImageVideo ;
@synthesize blackBannerVideo, blackBannerImage;


#define ACTIONSHEET_TITILE @"Click cancel job and we will stop looking for quotes and terminate this job"

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
    if(connection) {
        [connection release];
        connection = nil;
    }

    self.jobDetail = nil;
    self.backgroundImage = nil;
    self.updatedDateAndTimeImage =nil;
    self.updatedDateAndTimeNoImageVideo = nil;
    self.updatedDateAndTimeVideo = nil;
    self.blackBannerVideo = nil;
    self.blackBannerImage = nil;
    
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


#pragma mark Navigation Button Click

-(void)backButtonClick:(id)sender {
    
    Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate setTabbarViewControllers:nil];
    [appDelegate selectTabbarIndex:0];  // select home tabbar as default when going back
}

- (void)jobCancelButtonClick:(id)sender
{
    UIActionSheet *actionSheet;    
    actionSheet = [[UIActionSheet alloc] initWithTitle:ACTIONSHEET_TITILE delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:@"Cancel Job" otherButtonTitles:nil,nil];
    [actionSheet showInView:self.tabBarController.view];
   // [actionSheet bringSubviewToFront:self.view];
    [actionSheet release];
        
}


#pragma mark Action sheet delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
 
    if (buttonIndex == 0)
    {
        CancelViewController *cancelViewController = [[CancelViewController alloc] initWithNibName:@"CancelViewController" bundle:nil];
        
        cancelViewController.flowStatus = YES;
        RBNavigationController *cancelJobNavigationController = [[RBNavigationController alloc]
                                                                initWithRootViewController:cancelViewController];
        [self.navigationController presentModalViewController:cancelJobNavigationController animated:YES];
        
        [cancelJobNavigationController release];
        cancelJobNavigationController = nil;
        
        [cancelViewController release];
        cancelViewController = nil;      
                                                      
    }
    else
    {
            
    } 
}

- (void)createCustomNavigationRightButton {
    
    //navigation back button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 65, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [button setTitle:kBackToHomeTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:NavigationButtonBackgroundImage] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    item = nil;
}

- (void)setupNavigationBar {
    
    self.title=kDetailTitle;
    [self.navigationItem setRBTitle:jobDetail.jobRequestName withSubTitle:kDetailTitle];
    
    //to adjust the title position
    UIButton * button = [[UIButton alloc] initWithFrame:rightBarButtonItemFrame];
    UIBarButtonItem * barbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
   
    if(!isAppointmentPresent) {
        
        [button setImage:[UIImage imageNamed:navigationButtonRightbackgroundImage] forState:UIControlStateNormal];
       [button addTarget:self 
                  action:@selector(jobCancelButtonClick:)
        forControlEvents:UIControlEventTouchUpInside];
    }
    [self.navigationItem setRightBarButtonItem:barbuttonItem];
    [button release];
    button = nil;
    [barbuttonItem release];
    barbuttonItem = nil;
    
    [self createCustomNavigationRightButton];
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
   
    [self setButtonBoarderColor];
    
    [self initialise]; 
    [self setupNavigationBar];
    if(jobDetail)
        [self refreshView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [FlurryAnalytics logEvent:@"View - Job Details"];
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
    //jobDetail.jodDetails = [self saveEditText];
    [self checkAudioTextStatus];
//    if(jobDetail)
//        [self refreshView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
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
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

-(NSString *)getTimeToDisplay:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    NSString *dateAndTimeString = [formatter stringFromDate:date];
    dateAndTimeString = [dateAndTimeString stringByAppendingString:@" "];
    [formatter setDateFormat:@"h:mmaa"];
    dateAndTimeString = [dateAndTimeString stringByAppendingString:[formatter stringFromDate:date]];
    [formatter release];
    return dateAndTimeString;
}

-(void)setUpdatedTime {
    
    NSString *date;
    if([jobDetail.updates count] > 0) {
        
        JobUpdates *update = [jobDetail.updates lastObject];
        date = [NSString stringWithFormat:@"Updated on : %@",[self getTimeToDisplay:[update time_updated]]];
    }
    
    else {
        [blackBannerImage setHidden:YES];
        [blackBannerVideo setHidden:YES];
        date = @"";
    }
    
    NSString *updatedDate = date;
    updatedDateAndTimeImage.text = updatedDate;
    updatedDateAndTimeNoImageVideo.text = updatedDate;
    updatedDateAndTimeVideo.text = updatedDate;
}

-(void)refreshView {
    
    [self populateSchedule];    
    [self populateLocation];
    [self checkAudioTextStatus];
    [self checkImageOrVideoStatus];
    [self setUpdatedTime];
    
}


- (void)goToRequestViewcontroller:(BOOL)status
{
    ResponseAudioTextViewController *responseAudioTextViewController = [[ResponseAudioTextViewController alloc] 
                                                        initWithNibName:@"AudioTextViewController" 
                                                        bundle:nil];
    responseAudioTextViewController.viewStatus = status;
    responseAudioTextViewController.delegate = self;
    
    [responseAudioTextViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:responseAudioTextViewController animated:YES];
    [responseAudioTextViewController release];
    responseAudioTextViewController = nil;
    
}


#pragma mark - Attachments

- (IBAction)onTouchUpAddAudio:(id)sender
{    
    [self goToRequestViewcontroller:YES];
    
}

- (IBAction)onTouchUpAddTextDescription:(id)sender {
    [self goToRequestViewcontroller:NO];
}


#pragma mark - Populate methods
//check for any existing value, if no value exsists insert default value as Flexible
- (void)populateSchedule 
{
    NSString *flexible = @"Flexible";
    NSString *urgent = @"Urgent";
    
    JobResponseDetails * jobResponse = jobDetail;
    NSString * type = jobResponse.auctionType;
    NSString * name = nil;
    if (type)
    {
        if ([type isEqualToString:SCHEDULE_TYPE_DATE]) 
        {
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            NSDate * date = jobResponse.endDate;
            [formatter setDateFormat:@"h:mm aa, MMMM dd, yyyy"];
            name = [formatter stringFromDate:date];
            [formatter release];
            formatter = nil;
        }
        else if([type isEqualToString:SCHEDULE_TYPE_FLEXIBLE]){
            name = flexible;
        }
        else
            name= urgent;
    }   
    
    scheduleLabel.text = name;
}

- (void)populateLocation 
{
    JobResponseDetails * jobResponse = jobDetail;
    NSString * zipCode = jobResponse.jobLocationID;
    NSString * cityName = [[ManagedObjectContextHandler sharedInstance] getCityNameForZipcode:zipCode];

    NSArray * placeName = [cityName componentsSeparatedByString:@", "];
    NSString * locationString = nil;
    if (zipCode) 
    {
        //placeName has city @ 0 and state @ 1
        locationString = [NSString stringWithFormat:@"%@, %@", [placeName objectAtIndex:0], zipCode];
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
    BOOL isAudioPresent = NO;
    JobResponseDetails * jobResponse = jobDetail;
    NSString * jobDescription = jobResponse.jodDetails;
    jobDescription = [jobDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([jobDescription length]>0) {
        isTextDescriptionPresent = YES;
    }
    if([jobResponse.jobDocument.file_type isEqualToString:@"audio"]){
        isAudioPresent = YES;
    }
    if (isAudioPresent && isTextDescriptionPresent) {
        //show Both
        [self showAudioAndTextPreviewContainer];
    }
    else if (isAudioPresent){
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
    
    JobResponseDetails * jobResponse = jobDetail;
    
    if ([jobResponse isVideoDescriptionPresent]) 
    {
        //video exists
        [self showVideoPreviewContainer];
    }
    else if (![jobResponse doesImageExists]) {
        //no images & no video
        //[self showDefaultVideoImageContainer];
    }
    else {
        
        //images are present
        JobImages * image = [jobResponse getFirstImage];
        [self showImageThumbnail:image];
    }
    
}


-(void)loadThumbnailWithurl:(NSURL *)url {
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame=ACTIVITY_FRAME;
    activityIndicator.tag = ACTIVITYINDICATOR_TAG;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [activityIndicator release];
    
    if (connection!=nil) { [connection release]; }
    if (data!=nil) { [data release]; }
    NSURLRequest* request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
    connection = [[NSURLConnection alloc]
				  initWithRequest:request delegate:self];
    
    
}


#pragma mark - video/Image Containers

- (void)showImageThumbnail:(JobImages *)thumbnailImage {
    
    CGRect suwydContainerFrame = showUsWYDCOntainer.frame;
    [self removeShowUSWYDContainers];
    [self.view addSubview:imagePreviewContainerFromLibrary];
    [imagePreviewContainerFromLibrary setFrame:suwydContainerFrame];
    
    NSString * imagePath = [thumbnailImage urlOfImage];
    NSURL *url = [[NSURL alloc] initWithString:imagePath];
    [self loadThumbnailWithurl:url];
//    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
//    UIImage * previewImage = [[UIImage alloc] initWithData:data];
    
    [url release];
    url = nil;
//    [data release];
//    data = nil;
    
        
    photoAddedLabelFromLibrary.text = [NSString stringWithFormat:@"%d Photo(s)", 
                                       [jobDetail getImageCount]];
    
    if ([jobDetail getImageCount]>1)
    {
        [multipleImageBackgroundView setHidden:NO];
    }
    else
    {
        [multipleImageBackgroundView setHidden:YES];
    }
}


- (void)connection:(NSURLConnection *)theConnection
	didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
		data =
		[[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
    [connection release];
    connection=nil;
   
    UIImage * previewImage = [[UIImage alloc] initWithData:data];
    
    [previewFromCameraButton setImage:[previewImage imageByScalingAndCroppingForSize:CGSizeMake(273, 76)] forState:UIControlStateNormal];
    [previewFromLibraryButton setImage:[previewImage imageByScalingAndCroppingForSize:CGSizeMake(273, 76)] forState:UIControlStateNormal];
    
    self.videoThumbnail.image = [previewImage imageByScalingAndCroppingForSize:CGSizeMake(273, 76)];
    
    [previewImage release];
    previewImage = nil;
    
    UIActivityIndicatorView *activityindicator = (UIActivityIndicatorView *)[self.view viewWithTag:ACTIVITYINDICATOR_TAG];
    [activityindicator removeFromSuperview];

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
    
    JobDocuments *videoDocument = [jobDetail getVideoDocument];
    NSString * imagePath = [videoDocument thumbnailUrl];
    if(![imagePath isKindOfClass:[NSNull class]]) {
        //imagePath=videoDocument.urlOfImage;
        NSURL *url = [[NSURL alloc] initWithString:imagePath];
        [self loadThumbnailWithurl:url];
        [url release];
        url = nil;
    }
}

#pragma mark - ramove containers 

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

#pragma mark - Audio / Text Containers


- (void)showAudioPreviewContainer {
    CGRect tuwydContainerFrame = tellUsWYDContainer.frame;
    [self removeTellUsWYDContainers];
    [self.view addSubview:audioPreviewContainer];
    [audioPreviewContainer setFrame:tuwydContainerFrame]; 
    NSString *fileDuration =[jobDetail getFileDuration];
    audioDurationLabelInAudioContainer.text = fileDuration;
}

- (void)showAudioAndTextPreviewContainer {
    CGRect tuwydContainerFrame = tellUsWYDContainer.frame;
    [self removeTellUsWYDContainers];
    [self.view addSubview:audioAndTextPreviewContainer];
    [audioAndTextPreviewContainer setFrame:tuwydContainerFrame];  
//    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
//    JobResponseDetails * jobResponse = [rBCurrentJobResponse jobResponse];
     NSString *fileDuration =[jobDetail getFileDuration];
    audioDurationLabelInAudioAndTextContainer.text =fileDuration;
    jobDescriptioninATDCOntainer.text = jobDetail.jodDetails;
}

- (void)showTextPreviewContainer {
    CGRect tuwydContainerFrame = tellUsWYDContainer.frame;
    [self removeTellUsWYDContainers];
    [self.view addSubview:textPreviewContainer];
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    JobResponseDetails * jobResponse = [rBCurrentJobResponse jobResponse];
    [textPreviewContainer setFrame:tuwydContainerFrame];  
    jobDescriptionInTDContainer.text = jobResponse.jodDetails;
}

- (void)showDefaultAudioTextContainer {
    CGRect tuwydContainerFrame = tellUsWYDContainer.frame;
    [self removeTellUsWYDContainers];
    [self.view addSubview:tellUsWYDContainer];
    [tellUsWYDContainer setFrame:tuwydContainerFrame];      
}



#pragma mark - PLAY

- (IBAction)onTouchUpPlayVideo:(id)sender {    
    RBVideoPreviewController * previewController;
    previewController = [[RBVideoPreviewController alloc] 
                         initWithNibName:[RBVideoPreviewController getnibName] bundle:nil];
    [previewController setIsStreamingFromUrl:YES];
    [previewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:previewController animated:NO];
    [previewController release];
    previewController = nil;
}

- (IBAction)onTouchUpShowImage:(id)sender {
    
    NSArray *jobImages = (NSArray*)[jobDetail jobImages];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for(int i = 0; i < [jobImages count]; i++){
        JobImages *jobImage = [jobImages objectAtIndex:i];
        NSURL *url = [[NSURL alloc] initWithString:jobImage.urlOfImage];
        [photos addObject:url];
        [url release];
        url = nil;
    }
   
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
    [photos release];
    photos = nil;
    
    [browser setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:browser animated:YES];
    [browser release]; 
    [photos release];
}

- (IBAction)onTouchUpShowLibrary:(id)sender {
   // [self onTouchUpAddFromLibrary:nil];
}


@end
