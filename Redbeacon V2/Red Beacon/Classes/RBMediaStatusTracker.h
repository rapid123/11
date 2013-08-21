//
//  RBMediaStatusTracker.h
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RBMediaStatusTracker : NSObject<NSCoding>
{
    NSString * mediaUrl;
    RBMediaType mediaType;
    RBMediaStatus mediaStatus;
    NSNumber * mediaId;
    NSString * thumbnailUrl;
    BOOL isMediaFromLibrary;
    NSString * audioDuration;
    NSNumber * uniquieUrl;
    BOOL used;
    
}

@property (nonatomic, retain) NSString * mediaUrl;
@property (nonatomic, retain) NSNumber * mediaId;
@property (nonatomic, retain) NSString * thumbnailUrl;
@property (nonatomic, assign) RBMediaType mediaType;
@property (nonatomic, assign) RBMediaStatus mediaStatus;
@property (nonatomic) BOOL isMediaFromLibrary;
@property (nonatomic, retain) NSString * audioDuration;
@property (nonatomic, assign) BOOL used;
@property (nonatomic, retain) NSNumber * uniqueUrl;

- (BOOL)isMediaExists;
- (void)updateTrackerWithStatus:(RBMediaStatus)status 
                    withMediaId:(NSNumber*)theMediaId 
                andThumbnailUrl:(NSString*)theThumbnailUrl;

@end
