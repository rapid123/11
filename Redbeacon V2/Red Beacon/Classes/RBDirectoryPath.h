//
//  RBDirectoryPath.h
//  Red Beacon
//
//  Created by Jayahari V on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RBDirectoryPath : NSObject {
    
}

//returns the application documents directory
+ (NSString *)applicationDocumentsDirectory;
//returns the videos directory where we save all the video files in the application
+ (NSString*)redBeaconVideosDirectory;
//returns the Audios directory where we save all the audio files in the application
+ (NSString*)redBeaconAudiosDirectory;
//returns the Images directory where we save all the Image files in the application
+ (NSString*)redBeaconImagesDirectory;

@end
