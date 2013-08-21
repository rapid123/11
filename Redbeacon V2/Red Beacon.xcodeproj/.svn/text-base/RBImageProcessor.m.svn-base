//
//  RBImageProcessor.m
//  Red Beacon
//
//  Created by Jayahari V on 17/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBImageProcessor.h"
#import "RBDirectoryPath.h"

@interface RBImageProcessor (Private)
- (NSString*)imagePath;
@end

@implementation RBImageProcessor

//this will compress the parameter image and return the shrinked image
- (UIImage*)compressImage:(UIImage*)imageToCompress{	
    CGSize size = {320, 415};
    UIGraphicsBeginImageContext(size);
    
    CGRect rect;
    rect.origin = CGPointZero;
    rect.size = size;
    [imageToCompress drawInRect:rect];
    
    UIImage *shrinked;
    shrinked = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return shrinked;
}

//will save the image as Documents/Images/[date].png, return the savedImagePath,
//so that we can use while fetching the image
- (NSString*)saveImage:(UIImage*)imageToCompress withName:(NSString*)imageName
{
    NSString *imagePath = nil;   
    @try 
    {
        

        CGSize imageSize = imageToCompress.size;
        CGSize newSize; 
        if (imageSize.width>imageSize.height) 
        {
            newSize = CGSizeMake(imageSize.height, imageSize.width);
        //    newSize = CGSizeMake(410, 320);
        }
        else
        {
            newSize = CGSizeMake(imageSize.width, imageSize.height);
          //  newSize = CGSizeMake(320, 410);
        }
        //newSize = CGSizeMake(320, 410);
        newSize = imageSize;
        if (imageSize.width > 320)
        {
            newSize.width = 320;
        }
        if (imageSize.height > 410)
        {
            newSize.height = 410;
        }
        NSDate* startDate = [NSDate date];
        imageToCompress = [imageToCompress imageByScalingToSize:newSize];
        NSDate* endDate = [NSDate date];
        NSLog(@"Scaling Image Time Duration: %f", [endDate timeIntervalSinceDate:startDate]);


        NSString *imagesDirectory = [RBDirectoryPath redBeaconImagesDirectory];
        if (![[NSFileManager defaultManager] fileExistsAtPath:imagesDirectory isDirectory:NULL]) 
        {
            NSError * error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:imagesDirectory 
                                      withIntermediateDirectories:NO 
                                                       attributes:nil 
                                                            error:&error];
            if (error)
            {
                NSLog(@"Error occured while creating the directory Images");
            }
        }
        
        startDate = [NSDate date];
        imagePath = [self imagePath];
        if (imageName) 
        {
            imagePath = [imagePath stringByAppendingString:imageName];
        }       
        imagePath = [imagePath stringByAppendingString:@".jpeg"];
       // NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(imageToCompress)];
        NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(imageToCompress, 1.0f)];
        endDate = [NSDate date];
        NSLog(@"Compress to JPEG Time Duration: %f", [endDate timeIntervalSinceDate:startDate]);
        startDate = [NSDate date];
        [imageData writeToFile:imagePath atomically:YES];   
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception caught while file management process! while saving images");
    }
    
    return imagePath;
}

//delates the Images-folder in the documents folder. 
//returns TRUE if no error occurs while deletoin, else FALSE
- (BOOL)deleteAllImages {    
    BOOL success = YES;
    NSError * error = nil;
    NSString *imagesDirectory = [RBDirectoryPath redBeaconImagesDirectory];
    [[NSFileManager defaultManager] removeItemAtPath:imagesDirectory error:&error];
    if (error) {
        success = NO;
        NSLog(@"Error occured while deleting the folder Images");
    }
    return success;
}

- (NSString*)imagePath {
    NSString * udid = [[UIDevice currentDevice] uniqueIdentifier];
    return [[RBDirectoryPath redBeaconImagesDirectory] stringByAppendingFormat:@"/%@", udid];
}

@end
