//
//  JobDetailViewController.h
//  Red Beacon
//
//  Created by sudeep on 07/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
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
#import "JobResponseDetails.h"




@interface JobDetailViewController : UIViewController<UIActionSheetDelegate> {
   
    JobResponseDetails *jobDetail;
    
    RBBaseHttpHandler * fileUploaderHandler;
    RBBaseHttpHandler * jobRequestHandler;
    RBBaseHttpHandler * loginHandler;
    
    RBLoadingOverlay * overlay;
    
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
    
    UIImageView * videoThumbnail;
    
    UIImageView * multipleImageBackgroundView;
    UILabel * scheduleLabel;
    UILabel * locationLabel;
    UILabel * audioDurationLabelInAudioAndTextContainer;
    UILabel * audioDurationLabelInAudioContainer;
    UILabel * jobDescriptionInTDContainer;
    UILabel * jobDescriptioninATDCOntainer;
    UILabel * photoAddedLabelFromLibrary;
    
    BOOL sendButtonTouched;
    BOOL cancelledUploads;
    BOOL sessionVerified;
    BOOL showUploadFailedAlert;
    BOOL isAppointmentPresent;
    
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
    
    NSURLConnection* connection;
    NSMutableData* data;
    UILabel *updatedDateAndTimeImage;
    UILabel *updatedDateAndTimeVideo;
    UILabel *updatedDateAndTimeNoImageVideo;
    
    UIImageView *blackBannerVideo;
    UIImageView *blackBannerImage;
    
}

@property(nonatomic) BOOL isAppointmentPresent;
@property(nonatomic, retain) JobResponseDetails *jobDetail;

@property(nonatomic, retain) IBOutlet UIImageView *backgroundImage;

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
@property (nonatomic, retain) IBOutlet UILabel *updatedDateAndTimeImage;
@property (nonatomic, retain) IBOutlet UILabel *updatedDateAndTimeVideo;
@property (nonatomic, retain) IBOutlet UILabel *updatedDateAndTimeNoImageVideo;
@property (nonatomic, retain) IBOutlet UIImageView *blackBannerVideo;
@property (nonatomic, retain) IBOutlet UIImageView *blackBannerImage;

- (IBAction)onTouchUpPlayVideo:(id)sender;
- (IBAction)onTouchUpShowImage:(id)sender;


@end
