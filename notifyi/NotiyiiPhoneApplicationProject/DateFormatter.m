//
//  DateFormatter.m
//
//  NotiyiiPhoneApplicationProject
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "DateFormatter.h"

@implementation DateFormatter


//For Sending to Server And To Storing to CoreData
+ (NSDate *)getDateFromDateString:(NSString *)dateString forFormat:(NSString *)dateFormat
{
    NSLog(@"INBOXXXXXXX DATE  ##################    \n%@",dateString);
    NSDate * date = nil;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:dateFormat];
    date = [dateFormatter dateFromString:dateString];
    NSLog(@"Date In GMT Time Zone===== \n%@",date);
    dateFormatter = nil;
    return date;    
}
+(NSDate *)getDateFromDateStringInUTC:(NSString *)dateString forFormat:(NSString *)dateFormat
{
    NSDate *date = nil;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//    [dateFormatter setDateFormat:@"yyyy.MM.dd G 'at' HH:mm:ss zzz"];
      [dateFormatter setDateFormat:dateFormat];
    date = [dateFormatter dateFromString:dateString];
    NSLog(@"Date In UTC Time Zone===== \n%@",date);

    return date;
}

+ (NSDate *)getDateInGMTFormat:(NSDate *)todaysDate 
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    

    NSString *dateStr = [dateFormatter stringFromDate:todaysDate];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];

    NSDate *date = [dateFormat dateFromString:dateStr];  
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    dateStr = [dateFormat stringFromDate:date];  
    
    NSLog(@"Date GMT %@",date);
    NSLog(@"Date in string  %@",dateStr);

//    dateFormatter = nil;
    
    return date;
}


+ (NSDate *)getDateFromDateStringBasedOnDeviceTimeZone:(NSString *)dateString forFormat:(NSString *)dateFormat
{
    NSString *deviceTimeZone = [[NSTimeZone localTimeZone] abbreviation];
    NSDate * date = nil;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:deviceTimeZone]];
    [dateFormatter setDateFormat:dateFormat];
    date = [dateFormatter dateFromString:dateString];
    NSLog(@"System Time Zone %@",date);
    dateFormatter = nil;
    return date;
}


//For displaying the Date as per Device Time Zone
+ (NSString *)getDateStringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat
{
    NSString *deviceTimeZone = [[NSTimeZone localTimeZone] abbreviation];
    NSLog(@"Local Time Zone %@",deviceTimeZone);
    NSLog(@"System Time Zone %@",[[NSTimeZone systemTimeZone] abbreviation]);
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:deviceTimeZone]];
    [dateFormatter setDateFormat:dateFormat];
    NSString *dateString =[dateFormatter stringFromDate:date];
    
    dateFormatter = nil;
    return dateString;    
}

+ (NSString *)displayConvertedDateAsPerDeviceZone:(NSDate *)date withFormat:(NSString *)dateFormat
{
    NSString *result;
    NSString *deviceDate = [self getDateStringFromDate:date withFormat:@"MM/dd/yyyy"];
    
    NSString *todaysdate = [self getDateStringFromDate:[NSDate date] withFormat:@"MM/dd/yyyy"];
    
    if ([deviceDate isEqualToString:todaysdate])
    {
        result = [self getDateStringFromDate:date withFormat:@"h:mm a"];//HH:mm:ss // HH:mm a 24 hrs format h:mm:ss a for 12 hrs format
    }
    else
    {
        result = [self getDateStringFromDate:date withFormat:@"MM/dd/yyyy"];;
    }
    
    return result;
    
}
//DateFromString:WithFormat:
+ (NSDate *)getDateFromDateStringForDatepicker:(NSString *)dateString forFormat:(NSString *)dateFormat
{
    NSString *deviceTimeZone = [[NSTimeZone localTimeZone] abbreviation];
    NSLog(@"Local Time Zone %@",deviceTimeZone);
    NSLog(@"System Time Zone %@",[[NSTimeZone systemTimeZone] abbreviation]);
    
    NSDate * date = nil;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:deviceTimeZone]];
    [dateFormatter setDateFormat:dateFormat];
    date = [dateFormatter dateFromString:dateString];
    NSLog(@"System Time Zone %@",date);
    return date;
}

@end
