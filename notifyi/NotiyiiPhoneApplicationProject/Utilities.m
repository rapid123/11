//
//  Utilities.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 01/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"
#import "TouchBase.h"
#import "DataManager.h"

#define TMP NSTemporaryDirectory()

static Utilities * m_objutilities;

@implementation Utilities

+ (Utilities *)sharedInstance{
	
	if (!m_objutilities) {
		
		m_objutilities=[[Utilities alloc] init];
	}
	return m_objutilities;
}



- (void) cacheImage: (NSString *) ImageURLString imgName:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    NSString *dataPath = [cachePath stringByAppendingPathComponent:@"IMAGES"];
    BOOL isDir = NO;
    NSError *error;
    if (! [[NSFileManager defaultManager] fileExistsAtPath:dataPath isDirectory:&isDir] && isDir == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    cachePath =  [dataPath stringByAppendingPathComponent:imageName];
    NSURL *imageURL = [NSURL URLWithString:ImageURLString];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];

    UIImage *image = [[UIImage alloc] initWithData: imageData];
    [UIImageJPEGRepresentation(image, 100) writeToFile: cachePath atomically: YES];
}

-(NSString *)formattedDateWithDate:(NSDate *)date Formate:(NSString *)format
{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

- (NSString*)formattedDateWithFormatString:(NSString*)dateFormatterString 
{
    if(!dateFormatterString) return nil;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:dateFormatterString];
    
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString*)currentDate
{
    
    return [self formattedDateWithFormatString:@"MM/dd/YY"];
}
-(NSString *)currentDateWithFormate:(NSString *)formate 
{
    
    return [self formattedDateWithFormatString:formate];
}


- (NSString *)isToday:(NSDate *)currentDate  {
    
    NSString * dateString;
    NSDate * today = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString * inboxDateString = [dateFormatter stringFromDate:currentDate];
    NSString * todayString = [dateFormatter stringFromDate:today];

    if([inboxDateString isEqualToString:todayString])  {
        [dateFormatter setDateFormat:@"HH:mm"];
        dateString = [dateFormatter stringFromDate:currentDate];
    }
    else    {
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        dateString = [dateFormatter stringFromDate:currentDate];
    }
    dateFormatter = nil;
    return dateString;
}


@end
