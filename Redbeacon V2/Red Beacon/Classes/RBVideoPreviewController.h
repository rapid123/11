//
//  RBVideoPreviewController.h
//  Red Beacon
//
//  Created by Jayahari V on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "JobRequestViewController.h"

@interface RBVideoPreviewController : UIViewController {
    
    UIView * playerContainer;
    NSMutableDictionary * currentVideo;
    JobRequestViewController * parent;
    MPMoviePlayerController* moviePlayer;
    UIImageView * previewThumbnail;
    
    UIButton * playButton;
    UIButton * retakeButton;
    UIButton * deleteButton;
    
    BOOL isPlaying;
    BOOL isStopped;
    
    BOOL isStreamingFromUrl;
}
@property (nonatomic) BOOL isStreamingFromUrl;
@property (nonatomic, retain) IBOutlet UIView * playerContainer;
@property (nonatomic, retain) IBOutlet UIView * playerControlContainer;
@property (nonatomic, retain) NSMutableDictionary * currentVideo;
@property (nonatomic, assign) JobRequestViewController *parent;
@property (nonatomic, retain) IBOutlet UIImageView * previewThumbnail;
@property (nonatomic, retain) IBOutlet UIButton * playButton;
@property (nonatomic, retain) IBOutlet UIButton * retakeButton;
@property (nonatomic, retain) IBOutlet UIButton * deleteButton;
@property (nonatomic, retain) RBLoadingOverlay * overlay;

+ (NSString*)getnibName;

//plays video in the videos folder with the videoName as in parameter.
- (void)playVideo:(RBMediaStatusTracker*)video;

//button actions
- (IBAction)onTouchUpDelete:(id)sender;
- (IBAction)onTouchupRetake:(id)sender;
- (IBAction)onTouchUpPlay:(id)sender;

//deletes the videos and all its related references
- (void)deleteVideos;



@end
