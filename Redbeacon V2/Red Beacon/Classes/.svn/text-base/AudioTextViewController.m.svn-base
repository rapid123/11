//
//  AudioTextViewController.m
//  Red Beacon
//
//  Created by Joe on 13/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AudioTextViewController.h"
#import "JobRequest.h"
#import "AudioPage.h"
#import "TextPage.h"
#import "RBAudioProcessor.h"
#import "RBSavedStateController.h"
#import "RBAlertMessageHandler.h"
#import "RBCurrentJobResponse.h"

@interface AudioTextViewController (Private)

//navigation bar
- (void)setupNavigationBar;
- (void)createCustomNavigationRightButton ;
- (void)createCustomNavigationLeftButton;

- (void)addSegmentedControl;
- (void)showAudioPage;
- (void)showTextPage;
- (void)refreshView;

- (BOOL)isAudioPresent;
- (BOOL)isValidJobDescription;

-(void)textViewOriginalContent;

//IBAction Methods
-(IBAction)doneButtonClicked:(id)sender;
-(IBAction)cancelButtonClicked:(id)sender;

@end

@implementation AudioTextViewController
@synthesize viewStatus;
@synthesize delegate;
@synthesize temporaryTextDescription;
@synthesize segmentedControl;

//IBVariables
@synthesize audioPage, textPage;

NSString * const AS_CONFIRM_DISCARD_AUDIO = 
@"Are you sure you want to discard the audio?";
NSString * const AS_CONFIRM_DISCARD_TEXT_MESSAGE = 
@"Are you sure you want to discard the text?";
NSString * const AS_CONFIRM_DISCARD_TEXT_TITLE = 
@"Discard Text?";
NSString * const AS_JOB_EMPTY = @"Job description field is empty.";

NSString * segmentRightSelected = @"RBSegmentRightBlue";
NSString * segmentRightUnSelected = @"RBSegmentRightBlack";
NSString * segmentLeftSelected = @"RBSegmentLeftBlue";
NSString * segmentLeftUnSelected = @"RBSegmentLeftBlack";

int kConfirmAudioAlertTag   = 101;
int kConfirmTextAlertTag    = 102;
int kSaveTextAlertTag       = 103;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//checks the status of the audio/text. If any of those items presenty then, 
//we will enable the add button.
- (void)refreshView {
    if ([self isValidJobDescription]) {       
        
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

- (void)enableTextMode {
    
    NSString * path;
    UIImage * image;
    
    path = [[NSBundle mainBundle] pathForResource:segmentRightSelected 
                                           ofType:kRBImageType];
    image = [[UIImage alloc] initWithContentsOfFile:path];      
    [segmentedControl setImage:image forSegmentAtIndex:1];
    [image release];
    
    path = [[NSBundle mainBundle] pathForResource:segmentLeftUnSelected
                                           ofType:kRBImageType];
    image = [[UIImage alloc] initWithContentsOfFile:path];
    [segmentedControl setImage:image forSegmentAtIndex:0];
    [image release];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = CGRectMake(0, 0, 310, 44);
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:25];
    label.text = @"Schedule";
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    self.navigationItem.titleView = label;
    [self addSegmentedControl];
    if (viewStatus) {
        segmentedControl.selectedSegmentIndex = 0;
        [self showAudioPage];
    }
    else
    {
        segmentedControl.selectedSegmentIndex = 1;
        [self showTextPage];
        [self enableTextMode];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBar];
    [self refreshView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	UIApplication *application = [UIApplication sharedApplication];
	if([application respondsToSelector:@selector(beginReceivingRemoteControlEvents)])
		[application beginReceivingRemoteControlEvents];
	[self becomeFirstResponder]; // this enables listening for events
	// update the UI in case we were in the background
	NSNotification *notification =
	[NSNotification
	 notificationWithName:ASStatusChangedNotification
	 object:self];
	[[NSNotificationCenter defaultCenter]
	 postNotification:notification];
}

- (void)setupNavigationBar {  
    if (viewStatus) {
        [self createCustomNavigationLeftButton];
    }
    else {
        [self createCustomNavigationLeftButton];
        [self createCustomNavigationRightButton];
    } 
}

- (void)createCustomNavigationRightButton 
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Use" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    button=nil;
    [item release];
    item = nil;
}

- (void)createCustomNavigationLeftButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
     JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    NSString * title = @"Cancel";
    UIImage * btnImage = [UIImage imageNamed:@"DoneButton.png"];
    
    //isValidJobDescription cannot be used as it will return false after text decription is saved.
    //isValidJobDecription have to be checked only after the text feild is populated, it cannot be used initially.
    if ([self isAudioPresent]||
        [[jRequest jobDescription] length] > 0) {
        title = @"Back";       
        btnImage = [UIImage imageNamed:@"navigationButton_background.png"];
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:btnImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    button=nil;
    [item release];
    item = nil;
}

- (void)addSegmentedControl {
    NSArray * segmentItems = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"RBSegmentLeftBlue.png"],
                              [UIImage imageNamed:@"RBSegmentRightBlack.png"],
                              nil];
    segmentedControl = [[[UISegmentedControl alloc] initWithItems: segmentItems] retain];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = 1;
    //[segmentedControl setFrame:CGRectMake(0, 0, 152, 27)];
    [segmentedControl setFrame:CGRectMake(0, 0, 141, 25)];
    [segmentedControl addTarget: self action: @selector(onSegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
}


-(NSString *)textViewContent {
    
    return textPage.jobDescriptionTextField.text;
}

- (void)onSegmentedControlChanged:(UISegmentedControl *) sender {

    self.temporaryTextDescription = textPage.jobDescriptionTextField.text;
    if (segmentedControl.selectedSegmentIndex == 0) 
    { 
        [self showAudioPage];
        
        NSString * path;
        UIImage * image;
        
        path = [[NSBundle mainBundle] pathForResource:segmentRightUnSelected 
                                               ofType:kRBImageType];
        image = [[UIImage alloc] initWithContentsOfFile:path];      
        [segmentedControl setImage:image forSegmentAtIndex:1];
        [image release];
        
        path = [[NSBundle mainBundle] pathForResource:segmentLeftSelected
                                               ofType:kRBImageType];
        image = [[UIImage alloc] initWithContentsOfFile:path];
        [segmentedControl setImage:image forSegmentAtIndex:0];
        [image release];
        
        [self.navigationItem setRightBarButtonItem:nil];
                
    } else if (segmentedControl.selectedSegmentIndex == 1)
    {
        [self showTextPage];
        
        NSString * path;
        UIImage * image;

        path = [[NSBundle mainBundle] pathForResource:segmentRightSelected 
                                               ofType:kRBImageType];
        image = [[UIImage alloc] initWithContentsOfFile:path];      
        [segmentedControl setImage:image forSegmentAtIndex:1];
        [image release];
        
        path = [[NSBundle mainBundle] pathForResource:segmentLeftUnSelected
                                               ofType:kRBImageType];
        image = [[UIImage alloc] initWithContentsOfFile:path];
        [segmentedControl setImage:image forSegmentAtIndex:0];
        [image release];

        [self createCustomNavigationRightButton];
    }  
    
    [self refreshView];
}

//will remove the audio/text view from the self.
- (void)removeAudioAndTextViewsFromSelf {    
    [textPage removeFromSuperview];
    [audioPage removeFromSuperview];
}

//displays the audio page after removing any existing views.
- (void)showAudioPage {    
    [self removeAudioAndTextViewsFromSelf];    
    [self.view addSubview:audioPage];
    [audioPage setParent:self];
}

//displays the text page after removing any existing views.
- (void)showTextPage {
    
    [self removeAudioAndTextViewsFromSelf];
    [self.view addSubview:textPage];
    [textPage layoutSubviews];
    textPage.jobDescriptionTextField.text = self.temporaryTextDescription;
    [textPage setParent:self];
    
    //v2.0 - for displaying the changed text 
    if([self.temporaryTextDescription length]==0)
        [self textViewOriginalContent];
}

#pragma mark - Validation Helpers
//only A-Z, 0-9, a-z, 1-15 characters are acceptable, without spaces.
- (BOOL)isValidJobDescription {    
    BOOL isValid = NO;
    NSString * jDescription = textPage.jobDescriptionTextField.text;
    jDescription = [jDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([jDescription length]>0){	        
        isValid = YES;
    }
    return isValid;    
}

- (BOOL)isAudioPresent {
    BOOL isValid = NO;
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    if ([jRequest isAudioExists]) {
        isValid = YES;
    }
    return isValid;
}

- (BOOL)isValidInputDatas {
    
    BOOL isValid = NO;
    do {
        if ([self isValidJobDescription]) {
            isValid = YES;
            break;
        }
        //add for more checking below
        //...
        //...
        
    } while (FALSE);
    return isValid;    
}

#pragma mark - Save and Upload
//save job descriptions
- (void)saveText {
    
    JobRequest * jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
    jobRequest.jobDescription = textPage.jobDescriptionTextField.text;
    
   
}

- (void)saveAudio {
    JobRequest * jobRequest = [[RBSavedStateController sharedInstance] jobRequest]; 
    [jobRequest changeAudioUsedStatus:YES];

    NSString * audioPath = [jobRequest getAudioPath];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:audioPath];
    if (fileExists)
    {
        [delegate audioViewDoneButtonFired: audioPath];
    }
}

- (NSString *)saveEditText
{
    //v2.0
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
    jobDetail.jodDetails = textPage.jobDescriptionTextField.text;
    return jobDetail.jodDetails;
}

- (void)dismissKeyBoard
{
    [textPage.jobDescriptionTextField resignFirstResponder];
}
#pragma mark- button action
-(IBAction)cancelButtonClicked:(id)sender {
        
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    BOOL audioUsed = [jRequest isAudioUsed];
    NSString * audioPath = [jRequest getAudioPath];
    NSString * enteredText = [textPage.jobDescriptionTextField text];
    
    //this is done just for avoid comparison between to nil objects, else jobRequest.jobDescription may be (null)
    if ([jRequest.jobDescription length]<=0) {
        jRequest.jobDescription = @"";
    }
    
    if (!audioUsed && audioPath) {

        [RBAlertMessageHandler showAlert:AS_CONFIRM_DISCARD_AUDIO
                          delegateObject:self 
                                 viewTag:kConfirmAudioAlertTag 
                        otherButtonTitle:@"Discard"];
        
    }
    else if (![enteredText isEqualToString:jRequest.jobDescription]&&
             segmentedControl.selectedSegmentIndex == 1) 
    {
        //only check if the existing value is different from current value && segment is in textDescription
        if([jRequest.jobDescription length]>0)
        {
            //while existing jobDescription nonEmpty
            [RBAlertMessageHandler showMultipleButtonAlertWithTitle:@"Save Changes?"
                                                            message:@""
                                                     delegateObject:self 
                                                            viewTag:kSaveTextAlertTag 
                                                   otherButtonTitle:[NSArray arrayWithObjects:@"OK",@"Cancel", nil]];
        }
        else if ([enteredText length]>0)
        {
            //while existing jobDescription was empty and currently we have jobDescription
            [RBAlertMessageHandler showMultipleButtonAlertWithTitle:AS_CONFIRM_DISCARD_TEXT_TITLE
                                                            message:AS_CONFIRM_DISCARD_TEXT_MESSAGE
                                                     delegateObject:self 
                                                            viewTag:kConfirmTextAlertTag 
                                                   otherButtonTitle:[NSArray arrayWithObjects:@"OK",@"Cancel", nil]];                       
        }
        
    }
    else 
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)doneButtonClicked:(id)sender {
    
    if ([self isValidInputDatas]) { 
        [self saveAudio];
        [self saveText];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [RBAlertMessageHandler showAlert:AS_JOB_EMPTY
                          delegateObject:nil];
    }
}

- (void)audioDidUse {
    [self saveAudio];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - memory relese

- (void)viewDidUnload
{
    [super viewDidUnload];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)destroyTheStreamer {
    
    [self.audioPage destroyStreamer];

}

- (void)dealloc
{
//    if(audioPage)
//        [audioPage release];
    
    self.textPage = nil;
    self.audioPage = nil;
    self.segmentedControl = nil;
    self.segmentedControl = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Discard audio
- (void)discardAudio {
    
    //delete physical file
    RBAudioProcessor * processor = [[RBAudioProcessor alloc] init];
    [processor deleteAllAudios];
    [processor release];
    processor = nil;
    
    //removes the reference from dataStore savedObject
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    [jRequest removeAudio];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - delegate methods
- (void)audioDidFinishRecording {
    [self refreshView];
}

- (void)textFieldChangedCharacter {
    [self refreshView];
}

- (void)toggleButtonState:(BOOL)state {
    [self.navigationItem.rightBarButtonItem setEnabled:state];
    [self.navigationItem.leftBarButtonItem setEnabled:state];
    [segmentedControl setEnabled:state];
}

#pragma mark AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{    
    if (alertView.tag == kConfirmAudioAlertTag) 
    {
        if (buttonIndex==0) 
        {
            //onDiscard
            [self discardAudio];
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == kConfirmTextAlertTag) 
    {
        if (buttonIndex==0) 
        {
            //discard all changess
            JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
            jRequest.jobDescription = nil;
            [[self navigationController] popViewControllerAnimated:YES];            
        }
        else if (buttonIndex ==1) 
        {
            //discard new changes
            //do nothing just (popToHome)
        }

    }
    else if (alertView.tag == kSaveTextAlertTag)
    {
        if (buttonIndex==0) 
        {
            if([textPage.jobDescriptionTextField.text length]==0)
            {
                //removing added text
                JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
                jRequest.jobDescription = nil;
            }
            else
            {
               //save changes
               if ([self isValidInputDatas]) {        
                   [self saveText];
               }
            }
        }
        else if (buttonIndex ==1) 
        {
            //discard new changes
            //do nothing just (popToHome)
        }
        [[self navigationController] popViewControllerAnimated:YES];        
    }
}

// version v2.0 changes
#pragma mark - setting methods

-(void)textViewOriginalContent {
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
    
    textPage.jobDescriptionTextField.text = jobDetail.jodDetails;
}

-(NSString *)jobResponse {
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    jobDetail=[rBCurrentJobResponse jobResponse];
    return jobDetail.jobID;
}


@end
