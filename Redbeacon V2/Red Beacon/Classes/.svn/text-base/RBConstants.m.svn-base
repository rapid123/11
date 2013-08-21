//
//  RBConstants.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBConstants.h"


@implementation RBConstants

//NSString * const kDateFormat = @"yyyy-MM-dd HH:mm:ss";
NSString * const kDateFormat = @"MM/dd/yyyy";

+ (NSString *)urlEncodedParamStringFromString:(NSString *)original
{
	NSString *param = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                          (CFStringRef)original, 
                                                                          NULL, 
                                                                          (CFStringRef)@";/?:@&=+$-_.~*'()", 
                                                                          kCFStringEncodingUTF8);
	
	NSLog(@"original: %@\nencoded: %@", original, param);
	return [param autorelease];
}

+ (NSString*)getImageMimeTypeFromName:(NSString*)imageName
{
    NSString * imageType = nil;
    NSString * tempString = nil;
    
    do 
    {
        NSArray * imageNameComponents = [imageName componentsSeparatedByString:@"."];
        
        if ([imageNameComponents count] < 2)
        {
            break;
        }
        
        // The second component contains the type
        tempString = [imageNameComponents objectAtIndex:1];

        if ([tempString isEqualToString:@"jpg"]  ||
            [tempString isEqualToString:@"jpeg"] ||
            [tempString isEqualToString:@"jpe"])
        {
            imageType = @"image/jpeg";
        }
        else if ([tempString isEqualToString:@"png"])
        {
            imageType = @"image/png";
        }
        else
        {
            // Invalid image type
            imageType = nil;
        }
 
    } while (0);
    
        
    return imageType;
                                     
}

+ (NSString*)getVideoMimeTypeFromName:(NSString*)videoName
{
    NSString * videoType = nil;
    NSString * tempString = nil;
    
    do 
    {
        NSArray * videoNameComponents = [videoName componentsSeparatedByString:@"."];
        
        if ([videoNameComponents count] < 2)
        {
            break;
        }
        
        // The second component contains the type
        tempString = [videoNameComponents objectAtIndex:1];
        
        if ([tempString isEqualToString:@"mp2"]  ||
            [tempString isEqualToString:@"mpa"]  ||
            [tempString isEqualToString:@"mpe"]  ||
            [tempString isEqualToString:@"mpeg"] ||
            [tempString isEqualToString:@"mpg"]  ||
            [tempString isEqualToString:@"mpv2"])
        {
            videoType = @"video/mpeg";
        }
        else if ([tempString isEqualToString:@"mp4"])
        {
            videoType = @"video/mp4";
        }
        else if ([tempString isEqualToString:@"mov"] ||
                 [tempString isEqualToString:@"qt"])
        {
            videoType = @"video/quicktime";
        }
        else if ([tempString isEqualToString:@"lsf"] ||
                 [tempString isEqualToString:@"lsx"])
        {
            videoType = @"video/x-la-asf";
        }
        else if ([tempString isEqualToString:@"asr"] ||
                 [tempString isEqualToString:@"asf"] ||
                 [tempString isEqualToString:@"asx"])
        {
            
            videoType = @"video/x-ms-asf";
        }
        else if ([tempString isEqualToString:@"avi"])
        {
            videoType = @"video/x-msvideo";
        }
        else if ([tempString isEqualToString:@"movie"])
        {
            videoType = @"video/x-sgi-movie";
        }
        else
        {
            // invalid video type
            videoType = nil;
        }

        
    } while (0);
    
        
    return videoType;
}

+ (NSString*)getAudioMimeTypeFromName:(NSString*)audioName
{
    NSString * audioType = nil;
    NSString * tempString = nil;
    
    do 
    {
        NSArray * audioNameComponents = [audioName componentsSeparatedByString:@"."];
        
        if ([audioNameComponents count] < 2)
        {
            break;
        }
        
        // The second component contains the type
        tempString = [audioNameComponents objectAtIndex:1];
        
        if ([tempString isEqualToString:@"au"]  ||
            [tempString isEqualToString:@"snd"])
        {
            audioType = @"audio/basic";
        }
        else if ([tempString isEqualToString:@"mid"] ||
                 [tempString isEqualToString:@"rmi"])
        {
            audioType = @"audio/mid";
        }
        else if ([tempString isEqualToString:@"mp3"])
        {
            audioType = @"audio/mpeg";
        }
        else if ([tempString isEqualToString:@"aif"] ||
                 [tempString isEqualToString:@"aifc"] ||
                 [tempString isEqualToString:@"aiff"])
        {
            
            audioType = @"audio/x-aiff";
        }
        else if ([tempString isEqualToString:@"m3u"])
        {
            audioType = @"audio/x-mpegurl";
        }
        else if ([tempString isEqualToString:@"ra"] ||
                 [tempString isEqualToString:@"ram"])
        {
            audioType = @"audio/x-pn-realaudio";
        }
        else if ([tempString isEqualToString:@"wav"])
        {
            audioType = @"audio/x-wav";
        }
        else if ([tempString isEqualToString:@"ima4"])
        {
            audioType = @"audio/x-caf";
        }
        else {
            
            // invalid video type
            audioType = nil;
        }
        
        
    } while (0);
    
    
    return audioType;
}

+ (void)deleteMediaFile:(NSString*)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:NULL];
}

//*****************************************************************************
// Returns a date string from the specified NSDate value
//*****************************************************************************
+ (NSString*)getStringFromDate:(NSDate*)date
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:kDateFormat];
    
    NSString * dateString = [dateFormatter stringFromDate:date];
    
    [dateFormatter release];
    dateFormatter = nil;
    
    return dateString;
}

+ (NSString*)mediaTypeToString:(RBMediaType)mediaType
{
    NSString* mediaTypeString = @"";
    
    switch (mediaType)
    {
        case kAudio:
            mediaTypeString = @"Audio";
        break;
            
        case kVideo:
            mediaTypeString = @"Video";
        break;
            
        case kImage:
            mediaTypeString = @"Image";
        break;
    }
    
    return mediaTypeString;
}




@end
