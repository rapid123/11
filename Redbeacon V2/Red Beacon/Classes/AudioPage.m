//
//  AudioPage.m
//  Red Beacon
//
//  Created by Jayahari V on 17/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AudioPage.h"
#import "RBDirectoryPath.h"
#import "JobRequest.h"
#import "AudioTextViewController.h"
#import "RBAudioProcessor.h"
#import "RBAlertMessageHandler.h"

//v2.0
#import "RBCurrentJobResponse.h"
#import "Red_BeaconAppDelegate.h"

@class Red_BeaconAppDelegate;

@interface AudioPage (Private)

- (IBAction)onTouchUpRecord:(id)sender;
- (IBAction)onTouchUpPlay:(id)sender;
- (IBAction)onTouchUpRetake:(id)sender;
- (IBAction)onTouchUpUse:(id)sender;
- (IBAction)onTouchUpDelete:(id)sender;
- (IBAction)onTouchUpStream:(id)sender;

- (BOOL)isAudioPresent;

//timer methods
- (void)startTimer;
- (void)refreshView;
- (void)updateTime;
- (void)updateStatus;
- (void)updateProgressBar;
- (void)blinkRecordButton;
- (void)removeAllTimers;

//modes
- (void)enablePlaymode;
- (void)enableRecordMode;

- (void)toggleButtonState:(BOOL)state;
- (void)redBeaconAppDidEnterForground;
- (void)redBeaconAppDidEnterBackground;

//v2.0
- (BOOL)isAudioPresentInResponse;
- (void)showStreamingView;
- (void)updateStatusOfAudioToStream;
- (void)updateTimeOfAudioToStream ;
- (void)setViewForStreaming;

- (void)destroyStreamer;
- (void)createTimers:(BOOL)create;
- (void)hideOverlay;

@end

@implementation AudioPage

@synthesize player, recorder;
@synthesize previewBar, recordingBar, audioStreamBar;
@synthesize playButton, recordButton, retakeButton;
@synthesize timeLabel, audioStatus, progressBar;
@synthesize audioDuration;
@synthesize parent;
@synthesize useButton, deleteButton, totalTimelabel, defaultTimeLabel;

@synthesize overlay;
@synthesize startStreamButton;

NSString * kAudioRecordingStatus = @"Recording...";
//NSString * kAudioPlayingStatus = @"Playing...";
NSString * kAudioRecordInitialStatus = @"Record Voice Description";
NSString * kAudioRecordedStatus = @"Voice Description Recorded";
NSString * kAudioRecordLimitMessage = @"1 minute limit";

NSString * const AS_CONFIRM_AUDIO_DELETE_TITLE = @"Discard Audio?";
NSString * const AS_CONFIRM_AUDIO_DELETE_MESSAGE = @"Are you sure you want to delete this audio?";

//v2.0
NSString * kAudioStreamStatus = @"Voice Description";

#pragma mark - Initialization methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kRedBeaconDidEnterBackground
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kRedBeaconDidEnterForground
                                                  object:nil];
    self.audioStreamBar     = nil;
    self.previewBar         = nil;
    self.recordingBar       = nil;
    self.playButton         = nil;
    self.recordButton       = nil;
    self.retakeButton       = nil;
    self.timeLabel          = nil;
    self.audioStatus        = nil;
    self.progressBar        = nil;
    self.audioDuration      = nil;
    self.totalTimelabel     = nil;
    
    self.overlay            = nil;
    self.startStreamButton  = nil;
   
    [self destroyStreamer];
	[self createTimers:NO];
    
    [super dealloc];
}

- (void)layoutSubviews {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redBeaconAppDidEnterBackground)
                                                 name:kRedBeaconDidEnterBackground
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redBeaconAppDidEnterForground)
                                                 name:kRedBeaconDidEnterForground
                                               object:nil];
    
    [progressBar setTintColor:[UIColor redColor]];
    
    if ([self isAudioPresent]) {        
        [self enablePlaymode];
    }
    else {
        [self enableRecordMode];
    }
    
    //v2.0
    [audioStreamBar setHidden:YES];
    if([self isAudioPresentInResponse]) {
        [self showStreamingView];
        [self setViewForStreaming];   
        return;
    }
    
    [self refreshView];
}

#pragma mark - Updation Methods
- (void)startTimer {
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 
                                             target:self
                                           selector:@selector(refreshView) 
                                           userInfo:nil 
                                            repeats:YES];
    
    recordBlinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 
                                                        target:self 
                                                      selector:@selector(blinkRecordButton) 
                                                      userInfo:nil 
                                                       repeats:YES];
}

- (void)removeAllTimers
{
    [timer invalidate];
    timer = nil;
    
    [recordBlinkTimer invalidate];
    recordBlinkTimer = nil;
}

//refreshes the vew values, such as time and Audio status
- (void)refreshView {    
    [self updateTime];
    [self updateStatus];  
    [self updateProgressBar];
}

- (void)updateTime {
    if ([self.recorder isRecording]) {
        //recorder is recording
        NSString *recordTime = [NSString stringWithFormat:@"%d:%02d", 
                                (int)self.recorder.currentTime/60, 
                                (int)self.recorder.currentTime % 60];
        
        //update the time peridically into the audioDictionary in datastore
        JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
        RBAudioProcessor * processor = [[RBAudioProcessor alloc] init];
        [jRequest addAudioWithStatus:kReadyForQueue 
                        withAudioUrl:[processor audioFullPath] 
                         andDuration:recordTime];
        [processor release];
        self.defaultTimeLabel.text = @"";
        timeLabel.text = recordTime;
        totalTimelabel.text = @" / 1:00";
        [self.timeLabel setTextColor:[UIColor redColor]];
    }
    else if ([self.player isPlaying]) {
        //while player is playing
        NSString *recordTime = [NSString stringWithFormat:@"%d:%02d", 
                                (int)self.player.currentTime / 60, 
                                (int)self.player.currentTime % 60];
        NSLog(@"Record time: %@", recordTime);
        JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
        timeLabel.text = recordTime;
        NSString * duration  = @" / ";
        if ([jRequest isAudioExists]) {
            duration = [duration stringByAppendingString:[jRequest getAudioDuration]];
        }
        else {            
            duration = [duration stringByAppendingString:@"0:00"];
        }        
        self.defaultTimeLabel.text = @"";
        totalTimelabel.text = duration;
        [self.timeLabel setTextColor:[UIColor redColor]];
    }
    else if(nil == self.recorder && [self isAudioPresent]) {
        //Recording stopped
        NSString *recordTime = @"0:00";
        JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
        timeLabel.text = recordTime;
        NSString * duration  = @" / ";
        if ([jRequest isAudioExists]) {
            duration = [duration stringByAppendingString:[jRequest getAudioDuration]];
        }
        else {            
            duration = [duration stringByAppendingString:@"0:00"];
        }
        self.defaultTimeLabel.text = @"";
        totalTimelabel.text = duration;
        [self removeAllTimers];
        [self.timeLabel setTextColor:[UIColor whiteColor]];
    }     
    
}

- (void)updateStatus {
  
    if ([self.recorder isRecording]) {
        //recording started
        audioStatus.text = kAudioRecordingStatus;
    }
    else if ([self.player isPlaying]) {
        
    }
    else if (nil == self.recorder && [self isAudioPresent]) {
        //recording stopped
       audioStatus.text = kAudioRecordedStatus; 
    }
}

- (void)updateProgressBar {     
    
    float progressPercentage = 0.0;
    if ([self.recorder isRecording]) {
        progressPercentage = self.recorder.currentTime/60;
    }
    else if ([self.player isPlaying]){
        
        JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
        //RBAudio * audio = [jRequest audio];
        double totalDuration;
        if ([jRequest isAudioExists]) {
            NSString * totalDurationString = [jRequest getAudioDuration];
            NSArray * array = [totalDurationString componentsSeparatedByString:@":"];
            NSString * firstObject = [array objectAtIndex:0];
            if ([firstObject intValue] == 0) {
                NSString * lastObject = [array lastObject];
                totalDuration = [lastObject doubleValue];
            }
            else {
                totalDuration = 60.0;
            }
        }
        else {
            totalDuration = 0;
        }         
        progressPercentage = self.player.currentTime/totalDuration;
    }

    [self.progressBar setProgress:progressPercentage];    
}

- (void)blinkRecordButton
{
    if (self.recordButton.selected) 
    {
        [self.recordButton setSelected:NO];
    }
    else 
    {
        [self.recordButton setSelected:YES];
    }
    
}

#pragma mark - Modes
- (void)enablePlaymode 
{    
    [previewBar setHidden:NO];
    [recordingBar setHidden:YES];
    
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    if ([jRequest isAudioUsed]) {
        //after saving and uploading
        [useButton setHidden:YES];
        [deleteButton setHidden:NO];
    }
    else {
        //first time
        [useButton setHidden:NO];
        [deleteButton setHidden:YES];
    }
    
}

- (void)enableRecordMode {   
    
    [previewBar setHidden:YES];
    [recordingBar setHidden:NO];
    [self.recordButton setSelected:NO];
    [self.audioStatus setText:kAudioRecordInitialStatus];
    [self.timeLabel setText:@""];
    [self.totalTimelabel setText:@""];
    [self.defaultTimeLabel setText:kAudioRecordLimitMessage];
    [self.progressBar setProgress:0.0 animated:NO];
}


#pragma mark - helper

- (BOOL)isAudioPresent {    
    BOOL present = NO;
    RBAudioProcessor * processor = [[RBAudioProcessor alloc] init];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[processor audioFullPath]]) {
        present = YES;
    }
    [processor release];
    return present;
}

- (void)toggleButtonState:(BOOL)state 
{
    [parent toggleButtonState:state];
    [retakeButton setEnabled:state];
    [useButton setEnabled:state];
    [deleteButton setEnabled:state];
}

- (void)animateArrival 
{
    CATransition *tr=[CATransition animation]; 
    tr.duration=0.65; 
    tr.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    tr.type=kCATransitionPush; 
    tr.subtype=kCATransitionFromRight; 
    tr.delegate=self; 
    [recordingBar setHidden:YES];
    [self.recordingBar.layer addAnimation:tr forKey:nil];
    
    tr=[CATransition animation]; 
    tr.duration=0.65; 
    tr.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    tr.type=kCATransitionPush; 
    tr.subtype=kCATransitionFromRight; 
    tr.delegate=self; 
    [previewBar setHidden:NO];
    [self.previewBar.layer addAnimation:tr forKey:nil];
    
}

#pragma mark -
#pragma mark - PLAY
- (AVAudioPlayer *)getAudioPlayerForFilePath:(NSString *)filePath{
    AVAudioPlayer * localPlayer = nil;    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        localPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:NULL]; 
        if (!localPlayer) {            
            [localPlayer release];
            localPlayer = nil;
        }
    }    
    return [localPlayer autorelease];
}

- (void)playAudio
{
    if (self.player) 
    {        
        if (self.player.playing) 
        { 
            [self toggleButtonState:YES];
            [self.player pause];
            [self.playButton setSelected:NO];
            [timer invalidate];
            timer = nil;
        }
        else
        {
            [self toggleButtonState:NO];
            [self.player play];		
            [self.playButton setSelected:YES];
            timer = [NSTimer scheduledTimerWithTimeInterval:.10 
                                                     target:self
                                                   selector:@selector(refreshView) 
                                                   userInfo:nil 
                                                    repeats:YES];
        }
    }
    else 
    {        
        [self toggleButtonState:NO];
        RBAudioProcessor * processor = [[RBAudioProcessor alloc] init];
        self.player = [self getAudioPlayerForFilePath:[processor audioFullPath]];
        [processor release];
        self.player.delegate=self;
        self.player.volume=1.0;
        [self.player play];
        
        [self.playButton setSelected:YES];
        timer = [NSTimer scheduledTimerWithTimeInterval:.10 
                                                 target:self
                                               selector:@selector(refreshView) 
                                               userInfo:nil 
                                                repeats:YES];
    }
}

#pragma mark - player delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {    
    [self.playButton setSelected:NO];
    self.player = nil;
    [self toggleButtonState:YES];
}

#pragma mark -
#pragma mark - RECORD
//removes audios folder so that all audios gets removed.
- (void)deleteOlderRecordings {    
    @try {
        
        NSError *err = nil;
        NSString * audiosFolder = [RBDirectoryPath redBeaconAudiosDirectory];
        if ([[NSFileManager defaultManager] fileExistsAtPath:audiosFolder 
                                                 isDirectory:NULL]) {            
            [[NSFileManager defaultManager] removeItemAtPath:audiosFolder 
                                                       error:&err];
            if(err)
                NSLog(@"Error while deleting the folder: %@ %d %@", 
                      [err domain], 
                      [err code], 
                      [[err userInfo] description]);
        }        
        
    }
    @catch (NSException * e) {
    
        NSLog(@"Caught exception while deleting the folder Audios: %@",
              [e description]);
    }
    
}
//start audio recording
- (void)startRecording:(UIButton *)recordBtn 
{    
    UIButton *button = (UIButton *)recordBtn;
    button.enabled = YES;
    
    NSError *error = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];  
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&error];
    
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty (
                             kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                             sizeof (doChangeDefaultRoute),
                             &doChangeDefaultRoute
                             );
    if(error){
        NSLog(@"Error whil setting category for audioSession");
        return;
    }
    [audioSession setActive:YES error:&error];
    if(error){
        NSLog(@"Error whil setting active flag audioSession:");
        return;
    }    
    NSMutableDictionary *recordSetting = [[[NSMutableDictionary alloc] init] 
                                          autorelease];
    //kAudioFormatAppleIMA4
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] 
                      forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] 
                     forKey:AVSampleRateKey]; 
    [recordSetting setValue:[NSNumber numberWithInt: 2] 
                     forKey:AVNumberOfChannelsKey];
    [recordSetting setValue :[NSNumber numberWithInt:16] 
                      forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] 
                      forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] 
                      forKey:AVLinearPCMIsFloatKey];
        
    //Delete older recordings
    [self deleteOlderRecordings];
    
    NSString * audioFolder = [RBDirectoryPath redBeaconAudiosDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:audioFolder 
                                              isDirectory:NULL]) 
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:audioFolder 
                                  withIntermediateDirectories:NO 
                                                   attributes:nil 
                                                        error:nil];
        
    }    
    RBAudioProcessor * processor = [[RBAudioProcessor alloc] init];
    NSURL *audioUrl = [NSURL fileURLWithPath:[processor audioFullPath]];
    [processor release];
    error = nil;
    AVAudioRecorder * avRecorder;
    avRecorder = [[ AVAudioRecorder alloc] initWithURL:audioUrl 
                                              settings:recordSetting 
                                                 error:&error];
    self.recorder = avRecorder;
    [avRecorder release];
    avRecorder = nil;    
    if(!self.recorder){
        NSLog(@"No Object exists, error while creating Recorder object");
        return;
    }    
    self.recorder.delegate = self;    
    self.recorder.meteringEnabled = YES;
    BOOL audioHWAvailable = audioSession.inputIsAvailable;
    if (! audioHWAvailable) {
        
        NSLog(@"No Audio hardware is present");
        return;
    }
    [self.recordButton setSelected:YES];
    [self.recorder recordForDuration:AUDIO_DURATION];			
    [self startTimer];
}

- (void)stopRecording {
    
    @try {
       // AudioServicesPlaySystemSound(1118);
        [self.recorder stop]; 
        self.recorder = nil;
        [parent audioDidFinishRecording];
    }
    @catch (NSException * e) {
        
        NSLog(@"Exception occured while stopping the recorder");
    }
    [self toggleButtonState:YES];
}

#pragma mark recoder delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)sender successfully:(BOOL)flag{
    AudioServicesPlaySystemSound(1118);
    self.recorder = nil;
    [parent audioDidFinishRecording];
    [self toggleButtonState:YES];
    [self.recordButton setSelected:NO];
    
    [self animateArrival];
    [self enablePlaymode];
    
}

#pragma mark -
#pragma mark - Button Action methods
- (IBAction)onTouchUpRecord:(id)sender 
{
    UIButton *button = (UIButton *)sender;
    if (button.enabled) {
        if ([self.recorder isRecording]) {
            [self stopRecording];
        }
        else {      
            button.enabled = NO;
             [self toggleButtonState:NO];
            AudioServicesPlaySystemSound(1117);
            [self performSelector:@selector(startRecording:) withObject:sender afterDelay:0.55];
        }
    }
}
- (IBAction)onTouchUpPlay:(id)sender {    
    [self playAudio];
}

- (IBAction)onTouchUpRetake:(id)sender 
{
    //Delete older recordings physical file
    RBAudioProcessor * audioProcessor = [[RBAudioProcessor alloc] init];
    [audioProcessor deleteAllAudios];
    [audioProcessor release];
    
    //remove the datastore object
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    [jRequest removeAudio];
    
    [self enableRecordMode];
}

- (IBAction)onTouchUpUse:(id)sender {
    [parent audioDidUse];
}

- (IBAction)onTouchUpDelete:(id)sender
{
    [RBAlertMessageHandler showDiscardAlertWithTitle:AS_CONFIRM_AUDIO_DELETE_TITLE
                                             message:AS_CONFIRM_AUDIO_DELETE_MESSAGE
                                      delegateObject:self 
                                             viewTag:1];
    
    
}
#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) 
    {
        [parent discardAudio];
    }
}

#pragma mark - Application Notification methods 
- (void)redBeaconAppDidEnterForground 
{
    //app is entering forground
    if ([self isAudioPresent]) {        
        [self enablePlaymode];
    }
    else {
        [self enableRecordMode];
    }
    [self refreshView];
    
}

- (void)redBeaconAppDidEnterBackground 
{
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    //app is entering background
    if ([self.player isPlaying]) {
        [self.playButton setSelected:NO];
        self.player = nil;
        [self toggleButtonState:YES];
    }
    else if ([self.recorder isRecording]) {
        [self stopRecording];
    }
    if (![jRequest isAudioUsed]) {
        [parent saveAudio];
    }
}

//v2.0
#pragma mark - audio

-(BOOL)isAudioPresentInResponse {
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    JobResponseDetails *jobDetail=[rBCurrentJobResponse jobResponse];
    
    BOOL isAudioPresent = NO;
    isAudioPresent = [jobDetail isAudioDescriptionPresent];
    
    return isAudioPresent;
}

-(void)showStreamingView {
    
    [audioStreamBar setHidden:NO];
    [previewBar setHidden:YES];
    [recordingBar setHidden:YES];
    
}

- (IBAction)onTouchUpStream:(id)sender {
    
    NSLog(@"Playing");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [sender setSelected:![sender isSelected]];
    
    if([streamer isIdle]){
        [streamer stop];
        [streamer start];
        return;
    }
        
    if(streamer) {
        [streamer pause];
        return;
    }
    
    if ([sender isSelected])
	{
        Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
        
        self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                          withMessage:@"Preparing to stream..." 
                                             animated:YES];
        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(createStreamer) userInfo:nil repeats:NO];
	}
	else
	{
		[streamer stop];
	}
}

-(void)updateStatusOfAudioToStream {
    
    if([self isAudioPresentInResponse]) {
        //streaming view
        audioStatus.text = kAudioStreamStatus; 
    }
}

-(void)updateTimeOfAudioToStream {
    
    if([self isAudioPresentInResponse]) {
        //Recording stopped
        NSString *recordTime = @"0:00";
        RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
        JobResponseDetails *jobDetail=[rBCurrentJobResponse jobResponse];
        timeLabel.text = recordTime;
        NSString * duration  = @" /0";
        if ([jobDetail isAudioDescriptionPresent]) {
            duration = [duration stringByAppendingString:[jobDetail getFileDuration]];
        }
        else {            
            duration = [duration stringByAppendingString:@"0:00"];
        }
        self.defaultTimeLabel.text = @"";
        totalTimelabel.text = duration;
        [self removeAllTimers];
        [self.timeLabel setTextColor:[UIColor whiteColor]];
    } 
}

-(void)setViewForStreaming {
    
    [self updateTimeOfAudioToStream];
    [self updateStatusOfAudioToStream];  
    [self.progressBar setProgress:0.0 animated:NO];
}

#pragma mark - streamer methods

//
// createTimers
//
// Creates or destoys the timers
//
-(void)createTimers:(BOOL)create {
	if (create) {
		if (streamer) {
            [self createTimers:NO];
            progressUpdateTimer =
            [NSTimer
             scheduledTimerWithTimeInterval:0.1
             target:self
             selector:@selector(updateProgress:)
             userInfo:nil
             repeats:YES];
		}
	}
	else {
		if (progressUpdateTimer)
		{
			[progressUpdateTimer invalidate];
			progressUpdateTimer = nil;
		}
	}
}


- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		[self createTimers:NO];
		
		[streamer stop];
		[streamer release];
		streamer = nil;
        
	}
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer
{
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    JobResponseDetails *jobDetail=[rBCurrentJobResponse jobResponse];
    NSString *urlPath = [jobDetail audioUrl];
    
	if (streamer)
	{
		return;
	}
    
	[self destroyStreamer];
	
	NSString *escapedValue =
    [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                         nil,
                                                         (CFStringRef)urlPath,
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8)
     autorelease];
    
	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
	
	[self createTimers:YES];
    
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];

    [streamer start];
}


//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
    //Red_BeaconAppDelegate *appDelegate = (Red_BeaconAppDelegate *)[UIApplication sharedApplication].delegate;
    
	if ([streamer isWaiting])
	{
        NSLog(@"Streamer is waiting....");
        

	}
	else if ([streamer isPlaying])
	{
        NSLog(@"Streamer is playing....");
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        //progress = 0.0;
        [self hideOverlay];

	}
	else if ([streamer isPaused]) {
        NSLog(@"Streamer is paused....");

	}
	else if ([streamer isIdle])
	{
        NSLog(@"Streamer is idle....");
        [self destroyStreamer];
        [self hideOverlay];
        progress = 0.0;
        [startStreamButton setSelected:NO];
	}
}


#pragma mark Remote Control Events
/* The iPod controls will send these events when the app is in the background */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
			[streamer pause];
			break;
		case UIEventSubtypeRemoteControlPlay:
			[streamer start];
			break;
		case UIEventSubtypeRemoteControlPause:
			[streamer pause];
			break;
		case UIEventSubtypeRemoteControlStop:
			[streamer stop];
			break;
		default:
			break;
	}
}

//
// updateProgress:
//
// Invoked when the AudioStreamer
// reports that its playback progress has changed.
//
- (void)updateProgress:(NSTimer *)updatedTimer
{
	if (streamer.bitRate != 0.0)
	{
//		double progress = streamer.progress;
        if(![streamer isPaused])
            progress = progress + 0.001;
		double duration = streamer.duration;
		duration = duration/100;
		if (duration > 0 && progress < duration)
		{
			[timeLabel setText:
             [NSString stringWithFormat:@"%.2f",
              progress]];
			[self.progressBar setProgress: progress / duration];
		}
		else
		{
            [self.progressBar setProgress: 1];
            NSLog(@"Duration is less than 0");
		}
	}
	else
	{
		timeLabel.text = @"0.00";
	}
}

#pragma mark - Overlay Method
- (void)hideOverlay {
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
}


@end