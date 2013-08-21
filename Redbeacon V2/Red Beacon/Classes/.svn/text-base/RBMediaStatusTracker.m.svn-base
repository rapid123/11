//
//  RBMediaStatusTracker.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBMediaStatusTracker.h"

@implementation RBMediaStatusTracker

@synthesize mediaUrl;
@synthesize mediaType;
@synthesize mediaStatus;
@synthesize mediaId;
@synthesize thumbnailUrl;
@synthesize isMediaFromLibrary;
@synthesize audioDuration;
@synthesize used;
@synthesize uniqueUrl;


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.mediaUrl forKey:@"mediaUrl"];
	[aCoder encodeInt:self.mediaType forKey:@"mediaType"];
	[aCoder encodeInt:self.mediaStatus forKey:@"mediaStatus"];
    [aCoder encodeObject:self.mediaId forKey:@"mediaId"];
    [aCoder encodeObject:self.thumbnailUrl forKey:@"thumbnailUrl"];
    [aCoder encodeBool:self.isMediaFromLibrary forKey:@"isMediaFromLibrary"];
    [aCoder encodeObject:self.audioDuration forKey:@"audioDuration"];
    [aCoder encodeBool:self.used forKey:@"used"];
    [aCoder encodeObject:self.uniqueUrl forKey:@"uniqueUrl"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	
	self.mediaUrl = [aDecoder decodeObjectForKey:@"mediaUrl"];
	self.mediaType = [aDecoder decodeIntForKey:@"mediaType"];
	self.mediaStatus = [aDecoder decodeIntForKey:@"mediaStatus"];
    self.mediaId = [aDecoder decodeObjectForKey:@"mediaId"];
    self.thumbnailUrl = [aDecoder decodeObjectForKey:@"thumbnailUrl"];
    self.isMediaFromLibrary = [aDecoder decodeBoolForKey:@"isMediaFromLibrary"];
    self.audioDuration = [aDecoder decodeObjectForKey:@"audioDuration"];
	self.used = [aDecoder decodeBoolForKey:@"used"];
    self.uniqueUrl = [aDecoder decodeObjectForKey:@"uniqueUrl"];
    
    return self;
}



- (void)dealloc
{
    [mediaUrl release];
    [mediaId release];
    [thumbnailUrl release];
    self.uniqueUrl = nil;
    [super dealloc];
}

- (BOOL)isMediaExists
{
    BOOL isExists = NO;
    if ([self.mediaUrl length]>0)
    {
        isExists = YES;
    }
    return isExists;
}

- (void)updateTrackerWithStatus:(RBMediaStatus)status 
                    withMediaId:(NSNumber*)theMediaId 
                andThumbnailUrl:(NSString*)theThumbnailUrl
{
    self.mediaId = theMediaId;
    self.thumbnailUrl = theThumbnailUrl;
    self.mediaStatus = status;
}

@end
