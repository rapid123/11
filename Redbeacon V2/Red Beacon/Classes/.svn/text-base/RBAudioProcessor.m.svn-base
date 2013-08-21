//
//  RBAudioProcessor.m
//  Red Beacon
//
//  Created by Jayahari V on 25/08/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "RBAudioProcessor.h"
#import "RBDirectoryPath.h"

@implementation RBAudioProcessor

//deletes all audios present
- (BOOL)deleteAllAudios {
    BOOL success = YES;
    NSError * error = nil;
    NSString *imagesDirectory = [RBDirectoryPath redBeaconAudiosDirectory];
    [[NSFileManager defaultManager] removeItemAtPath:imagesDirectory error:&error];
    if (error) {
        success = NO;
        NSLog(@"Error occured while deleting the folder Audios");
    }
    return success;
}

- (NSString*)audioFullPath {
    NSString * udid = [[UIDevice currentDevice] uniqueIdentifier];
    return [[RBDirectoryPath redBeaconAudiosDirectory] stringByAppendingFormat:@"/%@.ima4", udid];
}

@end
