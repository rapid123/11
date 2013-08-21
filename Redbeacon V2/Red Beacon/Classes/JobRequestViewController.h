//
//  JobRequestViewController.h
//  Red Beacon
//
//  Created by Nithin George on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RBJobRequestHandler.h"
#import "RBFileUploader.h"
#import "RBLoginHandler.h"
#import "AudioTextViewController.h"
#import "LoginViewController.h"
#import "ManagedObjectContextHandler.h"
#import "RBLoadingOverlay.h"
#import "JobViewController.h"
#import "PDColoredProgressView.h"
#import "Red_BeaconAppDelegate.h"

@interface JobRequestViewController : UIViewController <UIImagePickerControllerDelegate, 
                                                        UINavigationControllerDelegate,
                                                        RBAudioTextViewDelegate,
                                                        RBLoginDelegate,
                                                        JobViewControllerDelegate, RBLocationDelegate>
{
    
    UIView * tellUsWYDContainer;
    UIView * showUsWYDCOntainer;
    UIView * videoPreviewContainer;
    UIView * imagePreviewContainer;
    UIView * imagePreviewContainerFromLibrary;
    UIView * audioPreviewContainer;
    UIView * audioAndTextPreviewContainer;
    UIView * textPreviewContainer;
    
    UIButton * previewFromCameraButton;
    UIButton * previewFromLibraryButton;
    UIButton * previewFromAudioButton;
    UIButton * textAudioPreviousButton;
    UIButton * textDescriptionButton;
    UIImageView * multipleImageBackgroundView;
    UILabel * scheduleLabel;
    UILabel * locationLabel;
    UILabel * audioDurationLabelInAudioAndTextContainer;
    UILabel * audioDurationLabelInAudioContainer;
    UILabel * jobDescriptionInTDContainer;
    UILabel * jobDescriptioninATDCOntainer;
    UILabel * photoAddedLabelFromLibrary;
    
    UIImageView * videoThumbnail;
    
    NSString *jobTitle;

    RBBaseHttpHandler * fileUploaderHandler;
    RBBaseHttpHandler * jobRequestHandler;
    RBBaseHttpHandler * loginHandler;
    BOOL sendButtonTouched;
    
    RBLoadingOverlay * overlay;
    BOOL cancelledUploads;
    
    //progress while adding media
    PDColoredProgressView * progressView;
    float progressValue;
    float progressIncrement; /*this will be the incrememt value for the progress bar we will show. 
                              currently hardcording, 
                              if image = 0.01(takes too long to save)
                              video = 0.1(no too long)
                              making less will complete the progress faster.
                              */
    NSTimer * timer;
    BOOL sessionVerified;
    BOOL showUploadFailedAlert;
    

}

@property (nonatomic, retain) NSString *jobTitle;
@property (nonatomic, retain) IBOutlet UIView * tellUsWYDContainer;
@property (nonatomic, retain) IBOutlet UIView * showUsWYDCOntainer;
@property (nonatomic, retain) IBOutlet UIView * videoPreviewContainer;
@property (nonatomic, retain) IBOutlet UIView * imagePreviewContainer;
@property (nonatomic, retain) IBOutlet UIView * imagePreviewContainerFromLibrary;
@property (nonatomic, retain) IBOutlet UIView * audioPreviewContainer;
@property (nonatomic, retain) IBOutlet UIView * audioAndTextPreviewContainer;
@property (nonatomic, retain) IBOutlet UIView * textPreviewContainer;
@property (nonatomic, retain) IBOutlet UILabel * audioDurationLabelInAudioAndTextContainer;
@property (nonatomic, retain) IBOutlet UILabel * audioDurationLabelInAudioContainer;
@property (nonatomic, retain) IBOutlet UILabel * jobDescriptionInTDContainer;
@property (nonatomic, retain) IBOutlet UILabel * jobDescriptioninATDCOntainer;
@property (nonatomic, retain) IBOutlet UIButton * previewFromCameraButton;
@property (nonatomic, retain) IBOutlet UIButton * previewFromLibraryButton;
@property (nonatomic, retain) IBOutlet UIButton * previewFromAudioButton;
@property (nonatomic, retain) IBOutlet UIButton * textAudioPreviousButton;
@property (nonatomic, retain) IBOutlet UIButton * textDescriptionButton;
@property (nonatomic, retain) IBOutlet UILabel * locationLabel;
@property (nonatomic, retain) IBOutlet UILabel * scheduleLabel;
@property (nonatomic, retain) IBOutlet UILabel * photoAddedLabelFromLibrary;
@property (nonatomic, retain) IBOutlet UIImageView * videoThumbnail;
@property (nonatomic, retain) IBOutlet UIImageView * multipleImageBackgroundView;
@property (nonatomic, retain) RBLoadingOverlay * overlay;

- (void)setLocation;
- (void)showLocation;
- (void)showSchedule;
- (void)goToRequestViewcontroller:(BOOL)status;
- (void)sendJobRequest;
- (void)videoDidRetake;
- (void)ImageDidRetake;
- (void)initialise;
- (void)showJobViewController;
- (void)restoreView;
- (void)checkAndResumePendingMediaUploads;
//- (NSString*)getFailedMediaUploadAlertMsg:(ASIHTTPRequest*)request;
//- (NSString*)getFailedPrepareJobRequestAlertMsg:(ASIHTTPRequest*)request;
//- (NSString*)getFailedConfirmJobRequestAlertMsg:(ASIHTTPRequest*)request;
- (void)continueSending;
-(void)showOldSession:(NSString*)jobName;


@end
 