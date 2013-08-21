//
//  RBVideoProcessor.m
//  Red Beacon
//
//  Created by Jayahari V on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBVideoProcessor.h"
#import "RBDirectoryPath.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RBVideoProcessor (Private)
- (NSString*)videoPath;

- (void)createThumbnailImage;
- (void)saveThumbnail:(UIImage*)thumb;
@end

@implementation RBVideoProcessor

//save the video friom the URL into Documents/Videos/[Date].mp4, returns the 
// video path
- (NSString*)saveVideo:(NSURL*)url {
    
    @try {
        [self deleteAllVideos];
        NSString *videosDirectory = [RBDirectoryPath redBeaconVideosDirectory];
        if (![[NSFileManager defaultManager] fileExistsAtPath:videosDirectory isDirectory:NULL]) {
            NSError * error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:videosDirectory 
                                      withIntermediateDirectories:NO 
                                                       attributes:nil 
                                   
                                                            error:&error];
            if (error) {
                NSLog(@"Error occured while creating videos folder!");
            }
        }	
        NSData *videoData = [NSData dataWithContentsOfURL:url];
        [videoData writeToFile:[self videoPath] atomically:NO];
        [self performSelectorOnMainThread:@selector(createThumbnailImage) withObject:nil waitUntilDone:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception caught while video saved!");
    }
    return [self videoPath];
}

//delates the Videos-folder in the documents folder. 
//returns TRUE if no error occurs while deletoin, else FALSE
- (BOOL)deleteAllVideos {    
    BOOL success = YES;
    NSError * error = nil;
    NSString * videosDirectory = [RBDirectoryPath redBeaconVideosDirectory];
    [[NSFileManager defaultManager] removeItemAtPath:videosDirectory error:&error];
    if (error) {
        success = NO;
        NSLog(@"Error occured while deleting the folder Images");
    }
    NSLog(@"deleted all videos");
    return success;
}

- (NSURL*)urlFromString:(NSString*)stringUrl{
    NSString* expandedPath = [stringUrl stringByExpandingTildeInPath];
    NSURL* url = [NSURL fileURLWithPath:expandedPath];
    return url;
}

//will create a thumbnail image of the first frame of the video captured
- (void)createThumbnailImage {
    UIImage * thumbnail = nil;
   
    NSURL* contentURL = [self urlFromString:[self videoPath]];
    MPMoviePlayerController *_moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:contentURL];
    [_moviePlayerController setShouldAutoplay:NO];
    [_moviePlayerController setCurrentPlaybackTime:(NSTimeInterval)0];
    [_moviePlayerController setInitialPlaybackTime:(NSTimeInterval)0];
    [_moviePlayerController setControlStyle:MPMovieControlStyleNone];
    thumbnail = [[_moviePlayerController thumbnailImageAtTime:(NSTimeInterval)0 timeOption:MPMovieTimeOptionNearestKeyFrame] retain];
    [self saveThumbnail:thumbnail];
    [_moviePlayerController setCurrentPlaybackTime:(NSTimeInterval)-1];
    [_moviePlayerController stop];
    [_moviePlayerController release];
}

- (void)saveThumbnail:(UIImage*)thumb {
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(thumb)];
    [imageData writeToFile:[self thumbnailPath] atomically:YES];   
}

- (NSString*)thumbnailPath {
    return [[RBDirectoryPath redBeaconVideosDirectory] stringByAppendingString:@"/thumb.png"];
}

//returns the video path
- (NSString*)videoPath {
    NSString * udid = [[UIDevice currentDevice] uniqueIdentifier];
    return [[RBDirectoryPath redBeaconVideosDirectory] stringByAppendingFormat:@"/%@.mp4", udid];
}
@end
