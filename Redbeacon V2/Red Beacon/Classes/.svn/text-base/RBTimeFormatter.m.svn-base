//
//  RBTimeFormatter.m
//  Red Beacon
//
//  Created by Jayahari V on 26/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBTimeFormatter.h"


@implementation RBTimeFormatter

@synthesize timeValueString;

- (int)timeValueForDate:(NSDate*)date 
{
    
    int timeValue;
   // NSString * timeValueString = nil;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy:MM:dd:HH:mm"];
    NSString * timeString = [formatter stringFromDate:date];
    [formatter release];
    formatter = nil;
    
    NSMutableArray * array = (NSMutableArray*)[timeString componentsSeparatedByString:@":"];
    NSString * minute = [array lastObject];
    NSString * hour = [array objectAtIndex:3];
    NSString * hourMinute = [NSString stringWithFormat:@"%@%@", hour, minute];
    
    NSString * tempTime = nil;
    if ([minute intValue]>=30) {
        NSLog(@"Greater than- ");
        tempTime = [NSString stringWithFormat:@"%@30", hour];
    }
    else {
        NSLog(@"Less than-");
        tempTime = [NSString stringWithFormat:@"%@00", hour];
    }
    
    NSString * path = [[NSBundle mainBundle] pathForResource:TimeValuePlist 
                                                      ofType:kPlistType];
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
     
    self.timeValueString = [dictionary valueForKey:tempTime];
    [dictionary release];
    dictionary = nil;
    
    if ([hourMinute isEqualToString:@"2359"]) {
        //special case
        self.timeValueString = @"49";
    }
    timeValue = [timeValueString intValue];
    return timeValue;
}

- (void)dealloc
{
    [timeValueString release];
    timeValueString = nil;
    
    [super dealloc];
}

@end
