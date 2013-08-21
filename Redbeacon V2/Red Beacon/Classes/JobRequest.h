//
//  JobRequest.h
//  Red Beacon
//
//  Created by Jayahari V on 17/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBJobSchedule.h"
#import "RBMediaStatusTracker.h"
#import "RBAudio.h"

@interface JobRequest : NSObject<NSCoding> {

    //keys: videoName; 
    /*videoName is just the name of the video, videos are available in the 
     documents/videos folder*/
    RBMediaStatusTracker * pVideo; 
    
    
    
    //keys audioName
    /*audioName is just the name of the audio, audios are available in the 
     documents/audios folder*/
    RBMediaStatusTracker * pAudio; 
    
    //pincode
  //  NSNumber * pincode;
    
    RBJobSchedule * schedule;
    
    //key: zipCode; Value: zipcode
    //Key: type, Value: GPS, Custom
    NSMutableDictionary * location;
    
    //job name
    NSString * jobName;
    
    NSString * jobDescription;
    
    //Array of images, each image is a dictionary with Key: KEY_IMAGE_NAME        
    NSMutableDictionary * pImages; /*imageName is just the name of the image, images are available in the 
                                   documents/images folder*/
    
    //Performance Improval
    NSArray * imageIds;
    int currentimageIndex;
}


//@property (nonatomic, retain) NSNumber * pincode;
@property (nonatomic, retain) RBJobSchedule   * schedule;
@property (nonatomic, retain) NSMutableDictionary   * location;
@property (nonatomic, retain) NSString * jobName;
@property (nonatomic, retain) NSString * jobDescription;
@property (nonatomic, retain) NSArray * imageIds;


- (BOOL)areAllMediaSuccessfullyUploaded;
- (BOOL)isJobRequestDataAvailable;
- (BOOL)doesImageExists;
- (RBMediaStatusTracker*)getFirstImageTracker;
- (RBMediaStatusTracker*)getImageTrackerForImagePath:(NSString*)imagePath;
- (NSString*)getFirstImagePath;
- (NSString*)getLastImagePath;
- (void)removeAllImages;
- (void)addImage:(RBMediaStatusTracker*)imageTracker;
- (void)displayImages;
- (NSArray*)getAllImagePaths;
//get image count
- (int)getImageCount;

- (NSString*)getMediaIds;

- (BOOL)isVideoExists;

- (void)updateVideoStatus:(RBMediaStatus)videoStatus 
              withMediaId:(NSNumber*)mediaId 
             andthumbnail:(NSString*)thumbnailUrl;

- (void)enqueueVideoWithPath:(NSString*)videoPath;

- (void)removeVideo;

- (RBMediaStatusTracker*)getVideoTracker;

- (void)updateImageStatus:(RBMediaStatus)imageStatus 
             forImagePath:(NSString*)imagePath 
              withMediaId:(NSNumber*)mediaId 
             andthumbnail:(NSString*)thumbnailUrl;

- (void)addAudioWithStatus:(RBMediaStatus)status 
              withAudioUrl:(NSString*)audioUrl 
               andDuration:(NSString*)duration;
- (void)changeAudioUsedStatus:(BOOL)used;

-  (BOOL)isAudioExists;
- (NSString*)getAudioDuration;
- (BOOL)isAudioUsed;
- (void)updateAudioWithUsedStatus:(BOOL)used andURL:(NSString*)url;
- (NSString*)getAudioPath;
- (void)removeAudio;
- (void)updateAudioStatus:(RBMediaStatus)audioStatus 
              withMediaId:(NSNumber*)mediaId 
             andthumbnail:(NSString*)thumbnailUrl;
- (void)enqueueAudioWithPath:(NSString*)path;
- (RBMediaStatusTracker*)getAudioTracker;

//Performance Improval
- (void)initializeSearchingImages;
- (NSNumber*)currentSearchingImageID;
- (void)gotOneSearchItem;

@end
