//
//  DateFormatter.h
//  NotiyiiPhoneApplicationProject
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import <Foundation/Foundation.h>


@interface DateFormatter : NSObject {
    
}

+ (NSDate *)getDateFromDateString:(NSString *)dateString forFormat:(NSString *)dateFormat;
+ (NSDate *)getDateInGMTFormat:(NSDate *)todaysDate; 
+ (NSString *)getDateStringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat;
+ (NSDate *)getDateFromDateStringForDatepicker:(NSString *)dateString forFormat:(NSString *)dateFormat;
+ (NSString *)displayConvertedDateAsPerDeviceZone:(NSDate *)date withFormat:(NSString *)dateFormat;
+ (NSDate *)getDateFromDateStringBasedOnDeviceTimeZone:(NSString *)dateString forFormat:(NSString *)dateFormat;
@end
