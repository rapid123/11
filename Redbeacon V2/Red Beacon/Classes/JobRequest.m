//
//  JobRequest.m
//  Red Beacon
//
//  Created by Jayahari V on 17/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JobRequest.h"

@interface JobRequest ()

@property (nonatomic, retain) NSMutableDictionary * images;
@property (nonatomic, retain) RBMediaStatusTracker * video;
@property (nonatomic, retain) RBMediaStatusTracker * audio;

@end

@implementation JobRequest

@synthesize schedule, jobName, jobDescription;
@synthesize location;
@synthesize images = pImages;
@synthesize video = pVideo;
@synthesize audio = pAudio;
@synthesize imageIds;

#pragma mark Initialisation
- (id)init
{
    self = [super init];
    if (self)
    {
        //self exists, so we allocates the objects 
        NSMutableDictionary * imgDic = [[NSMutableDictionary alloc] init];
        self.images = imgDic;
        [imgDic release];
        
        RBMediaStatusTracker * videoTracker = [[RBMediaStatusTracker alloc] init];
        self.video = videoTracker;

        [videoTracker release];

        RBMediaStatusTracker * audioTracker = [[RBMediaStatusTracker alloc] init];
        self.audio = audioTracker;
        [audioTracker release];
        
        RBJobSchedule * jSchedule = [[RBJobSchedule alloc] init];
        self.schedule = jSchedule;
        [jSchedule release];
        jSchedule = nil;
        
        NSMutableDictionary * locDictionary = [[NSMutableDictionary alloc] init];
        self.location = locDictionary;
        [locDictionary release];
        locDictionary = nil;
        
        self.jobName = @"";
        self.jobDescription = @"";
        
    }
    return self;
}
#pragma mark -

#pragma mark NSCoding methods

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.video forKey:@"video"];
	[aCoder encodeObject:self.images forKey:@"images"];
	[aCoder encodeObject:self.audio forKey:@"audio"];
    [aCoder encodeObject:self.schedule forKey:@"schedule"];
	[aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.jobName forKey:@"jobName"];
	[aCoder encodeObject:self.jobDescription forKey:@"jobDescription"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	
	self.video = [aDecoder decodeObjectForKey:@"video"];
	self.images = [aDecoder decodeObjectForKey:@"images"];
	self.audio = [aDecoder decodeObjectForKey:@"audio"];
    self.schedule = [aDecoder decodeObjectForKey:@"schedule"];
	self.location = [aDecoder decodeObjectForKey:@"location"];
    self.jobName = [aDecoder decodeObjectForKey:@"jobName"];
	self.jobDescription = [aDecoder decodeObjectForKey:@"jobDescription"];

    return self;
}
#pragma mark -

#pragma mark JobRequest Methods
- (BOOL)areAllMediaSuccessfullyUploaded
{
    BOOL allMediaUploaded = YES;
    do 
    {
        
        if (self.video.mediaUrl != nil && self.video.mediaStatus != kUploadSuccess)
        {
            allMediaUploaded = NO;
            break;
        }
        
        if (self.audio.mediaUrl != nil && self.audio.mediaStatus != kUploadSuccess) 
        {
            allMediaUploaded = NO;
            break;
        }
        
        NSArray * allKeys = [self.images allKeys];
        int count = [allKeys count];
        for (int i = 0; i < count; i++)
        {
            RBMediaStatusTracker * imageTracker = [self.images objectForKey:[allKeys objectAtIndex:i]];
            if (imageTracker.mediaUrl != nil && imageTracker.mediaStatus != kUploadSuccess)
            {
                allMediaUploaded = NO;
                break;
            }
        }
        
        
    } while (0);
    
    return allMediaUploaded;
    
}

- (BOOL)isJobRequestDataAvailable
{
    BOOL dataAvailable = NO;

    do 
    {
        NSString * trimmedJDescription = [jobDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimmedJDescription length]>0)
        {
            dataAvailable = YES;
            break;
        }
        
        if (self.video.mediaUrl != nil)
        {
            dataAvailable = YES;
            break;
        }
        
        if (self.audio.mediaUrl != nil)
        {
            dataAvailable = YES;
            break;
        }
        
        NSArray * allKeys = [self.images allKeys];
        int count = [allKeys count];
        for (int i = 0; i < count; i++)
        {
            RBMediaStatusTracker * imageTracker = [self.images objectForKey:[allKeys objectAtIndex:i]];
            if (imageTracker.mediaUrl != nil)
            {
                dataAvailable = YES;
                break;
            }
        }
        
    } while (0);
    
    return dataAvailable;
}
#pragma mark -

#pragma mark Image Related Methods

- (void)addImage:(RBMediaStatusTracker*)imageTracker
{
    if (imageTracker)
    {
        [self.images setObject:imageTracker forKey:imageTracker.mediaUrl];
    }
}

- (RBMediaStatusTracker*)getFirstImageTracker
{
    RBMediaStatusTracker * imageTracker = nil;
    NSArray * allKeys = [self.images allKeys];
    
    if ([allKeys count] > 0)
    {
        imageTracker = [self.images objectForKey:[allKeys objectAtIndex:0]];
    }
    
    
    return imageTracker;
}

- (NSString*)getFirstImagePath
{
    NSString * imagePath = nil;
    
    NSArray * allKeys = [self.images allKeys];
    
    NSArray * sortedArray = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    if ([sortedArray count] > 0)
    {
        imagePath = [sortedArray objectAtIndex:0];
    }
  
    return imagePath;
}

- (NSString*)getLastImagePath
{
    NSString * imagePath = nil;
    
    NSArray * allKeys = [self.images allKeys];    
    
    NSArray * sortedArray = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    if ([sortedArray count] > 0)
    {
        imagePath = [sortedArray lastObject];
    }
    
    return imagePath;
}

- (NSArray*)getAllImagePaths
{
    NSArray* imageUrls = nil;
    imageUrls = [self.images allKeys];
    return imageUrls;
}

- (void)removeAllImages
{
    [self.images removeAllObjects];
}

- (RBMediaStatusTracker*)getImageTrackerForImagePath:(NSString*)imagePath
{
    RBMediaStatusTracker* imageTracker = nil;
    
    imageTracker = [self.images objectForKey:imagePath];
    
    return imageTracker;
}

- (BOOL)doesImageExists
{
    BOOL imageExists = NO;
    
    if ([self.images count] > 0)
    {
        imageExists = YES;
    }
    
    return imageExists;
}

- (void)displayImages
{
    NSLog(@"******** DISPLAYING ALL IMAGES ********");
    NSArray * allKeys = [self.images allKeys];
    if ([allKeys count] > 0)
    {
        for (int i = 0; i < [allKeys count]; i++)
        {
            NSLog(@"%@", [self.images objectForKey:[allKeys objectAtIndex:i]]);
        }
        
    }
}

//get image count
- (int)getImageCount 
{
    int count = [self.images count];
    return count;
}

- (void)updateImageStatus:(RBMediaStatus)imageStatus 
             forImagePath:(NSString*)imagePath 
              withMediaId:(NSNumber*)mediaId 
             andthumbnail:(NSString*)thumbnailUrl
{
    RBMediaStatusTracker *tracker = [self getImageTrackerForImagePath:imagePath];
    [tracker updateTrackerWithStatus:imageStatus withMediaId:mediaId andThumbnailUrl:thumbnailUrl];
}

#pragma mark Image Performance
- (void)initializeSearchingImages {
    currentimageIndex = 0;
    NSArray * imagePaths = [self getAllImagePaths];
    NSMutableArray * ids = [[NSMutableArray alloc] init];
    for (NSString * imagePath in imagePaths) {
        RBMediaStatusTracker * image = [self getImageTrackerForImagePath:imagePath];
        [ids addObject:image.uniqueUrl];
    }
    self.imageIds = [ids sortedArrayUsingSelector:@selector(compare:)];
    [ids release];
}
- (NSNumber*)currentSearchingImageID {
    NSNumber * searchingId=  nil;
    @try {
        searchingId = [self.imageIds objectAtIndex:currentimageIndex];
    }
    @catch (NSException *exception) {
        searchingId = nil;
    }
    return searchingId;
}

- (void)gotOneSearchItem {
    ++currentimageIndex;
}

#pragma mark - Video Related Methods

- (void)enqueueVideoWithPath:(NSString*)videoPath
{
    self.video.mediaStatus = kWaitingForUpload;
    self.video.mediaType = kVideo;
    self.video.mediaUrl = videoPath;
    
}

- (RBMediaStatusTracker*)getVideoTracker
{
    RBMediaStatusTracker* videoTracker = nil;
    videoTracker = self.video;
    return  videoTracker;
}

- (void)removeVideo
{
    RBMediaStatusTracker *tracker = [[RBMediaStatusTracker alloc] init];
    self.video = tracker;
    [tracker release];
    tracker = nil;
}

- (BOOL)isVideoExists 
{
    BOOL isExists = NO;
    
    isExists = [self.video isMediaExists];
    
    return isExists;
}

- (void)updateVideoStatus:(RBMediaStatus)videoStatus 
              withMediaId:(NSNumber*)mediaId 
             andthumbnail:(NSString*)thumbnailUrl
{
    [self.video updateTrackerWithStatus:videoStatus 
                            withMediaId:mediaId 
                        andThumbnailUrl:thumbnailUrl];
    
}
#pragma mark -

#pragma mark Audio Related Methods

- (void)addAudioWithStatus:(RBMediaStatus)status 
              withAudioUrl:(NSString*)audioUrl 
               andDuration:(NSString*)duration
{
    self.audio.mediaStatus = status;
    self.audio.mediaUrl = audioUrl;
    self.audio.audioDuration = duration;
    self.audio.mediaType = kAudio;
    
    [self changeAudioUsedStatus: NO];
}

- (void)changeAudioUsedStatus:(BOOL)used
{
    self.audio.used = used;
}

-  (BOOL)isAudioExists
{
    BOOL isExists = NO;
    
    isExists = [self.audio isMediaExists];
    
    return isExists;
}

- (NSString*)getAudioDuration
{
    NSString *duration = nil;
    
    duration = self.audio.audioDuration;
    
    return duration;
}

- (BOOL)isAudioUsed
{
    return self.audio.used;
}

- (void)updateAudioWithUsedStatus:(BOOL)used andURL:(NSString*)url
{
    [self changeAudioUsedStatus:used];
    self.audio.mediaUrl = url;
}

- (NSString*)getAudioPath
{
    NSString *audioPath = nil;
    audioPath = self.audio.mediaUrl;
    
    return audioPath;
}

- (void)updateAudioStatus:(RBMediaStatus)audioStatus 
              withMediaId:(NSNumber*)mediaId 
             andthumbnail:(NSString*)thumbnailUrl
{
    [self.audio updateTrackerWithStatus:audioStatus 
                            withMediaId:mediaId 
                        andThumbnailUrl:thumbnailUrl];
}

- (RBMediaStatusTracker*)getAudioTracker
{
    RBMediaStatusTracker* audioTracker = nil;
    audioTracker = self.audio;
    return  audioTracker;
}

- (void)removeAudio
{
    RBMediaStatusTracker *audioTracker = [[RBMediaStatusTracker alloc] init];
    self.audio = audioTracker;
    [audioTracker release];
    audioTracker = nil;
}

- (void)enqueueAudioWithPath:(NSString*)path
{
    self.audio.mediaUrl = path;
    self.audio.mediaStatus = kWaitingForUpload;
    self.audio.mediaType = kAudio;
}
#pragma mark -

#pragma mark MediaId Related Methods

- (NSString*)getMediaIds
{
    NSString* mediaId;
    NSMutableArray* mediaIdsArray = [[NSMutableArray alloc] init];
    
    if ([self isAudioExists])
    {
        mediaId = [NSString stringWithFormat:@"%@", self.audio.mediaId];
        [mediaIdsArray addObject:mediaId];
    }
    
    if ([self isVideoExists])
    {
        mediaId = [NSString stringWithFormat:@"%@", self.video.mediaId];
        [mediaIdsArray addObject:mediaId];
    }
    
    if ([self doesImageExists])
    {
        NSArray *allKeys = [self.images allKeys];
        
        for (int i = 0; i < [allKeys count]; i++)
        {
            RBMediaStatusTracker *imgTracker = [self.images objectForKey:[allKeys objectAtIndex:i]];
            mediaId = [NSString stringWithFormat:@"%@", imgTracker.mediaId];
            [mediaIdsArray addObject:mediaId];
        }
    }
    
    mediaId = [mediaIdsArray componentsJoinedByString:@","];
    
    [mediaIdsArray release];
    
    return mediaId;
}
#pragma mark -

- (void)dealloc 
{
    self.video = nil;
    self.audio = nil;
    self.images = nil; 
    self.images = nil;
    self.schedule = nil;
    self.jobName = nil;
    self.jobDescription =  nil;
    self.location = nil;
    self.imageIds = nil;

    [super dealloc];
}
@end
