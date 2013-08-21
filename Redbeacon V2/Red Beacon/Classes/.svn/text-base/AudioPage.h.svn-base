//
//  AudioPage.h
//  Red Beacon
//
//  Created by Jayahari V on 17/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "PDColoredProgressView.h"

//v2.0
#import "AudioStreamer.h"
#import "RBLoadingOverlay.h"

@class AudioTextViewController;
@interface AudioPage : UIView <AVAudioRecorderDelegate, AVAudioPlayerDelegate>{
    
    AVAudioRecorder *recorder;
    AVAudioPlayer * player;
    
    NSTimer * timer; /*used to display the progress, seconds, etc.. for playing 
                      and recording*/
    
    NSString * audioDuration;
    
    //IBOutlets
    UIView * recordingBar;
    UIView * previewBar;
    UIView * recordBar;
    UIButton * playButton;
    UIButton * recordButton;
    UIButton * retakeButton;   
    UILabel * defaultTimeLabel;
    UILabel * timeLabel;
    UILabel * totalTimelabel;
    UILabel * audioStatus;
    PDColoredProgressView * progressBar;
    UIButton * useButton;
    UIButton * deleteButton;
    
    AudioTextViewController * parent;
    
    //blinking audio
    NSTimer * recordBlinkTimer;/* this is used to display the blinking of record 
                                button*/
    
    //v2.0
    UIView *audioStreamBar;
    AudioStreamer *streamer;
    NSTimer *progressUpdateTimer;
    RBLoadingOverlay *overlay;
    UIButton *startStreamButton;
    double progress;
    
}
@property (nonatomic, retain) AVAudioPlayer * player;
@property (nonatomic, retain) AVAudioRecorder *recorder;
@property (nonatomic, retain) NSString * audioDuration;

@property (nonatomic, retain) IBOutlet UIView *audioStreamBar;
@property (nonatomic, retain) IBOutlet UIView * recordingBar;
@property (nonatomic, retain) IBOutlet UIView * previewBar;
@property (nonatomic, retain) IBOutlet UIButton * playButton;
@property (nonatomic, retain) IBOutlet UIButton * recordButton;
@property (nonatomic, retain) IBOutlet UIButton * retakeButton;
@property (nonatomic, retain) IBOutlet UILabel * defaultTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel * timeLabel;
@property (nonatomic, retain) IBOutlet UILabel * audioStatus;
@property (nonatomic, retain) IBOutlet PDColoredProgressView * progressBar;
@property (nonatomic, retain) IBOutlet UIButton * useButton;
@property (nonatomic, retain) IBOutlet UIButton * deleteButton;
@property (nonatomic, retain) IBOutlet UILabel * totalTimelabel;

@property (nonatomic, assign) AudioTextViewController * parent;

@property (nonatomic, retain) RBLoadingOverlay *overlay;
@property (nonatomic, retain) IBOutlet UIButton *startStreamButton;

- (void)enablePlaymode;
- (void)enableRecordMode;
- (void)destroyStreamer;

@end
