//
//  RBDirectoryPath.m
//  Red Beacon
//
//  Created by Jayahari V on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBDirectoryPath.h"


@implementation RBDirectoryPath

//returns the application documents directory
+ (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

//returns the videos directory where we save all the video files in the application
+ (NSString*)redBeaconVideosDirectory {    
    NSString * videosDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    videosDirectory = [videosDirectory stringByAppendingString:@"/Videos"];
    return videosDirectory;
}

//returns the Audios directory where we save all the audio files in the application
+ (NSString*)redBeaconAudiosDirectory {    
    NSString * audiosDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    audiosDirectory = [audiosDirectory stringByAppendingString:@"/Audios"];
    return audiosDirectory;
}

//returns the Images directory where we save all the Image files in the application
+ (NSString*)redBeaconImagesDirectory {
    NSString * imagesDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    imagesDirectory = [imagesDirectory stringByAppendingString:@"/Images"];
    return imagesDirectory;    
}

@end
