//
//  RBJobSchedule.m
//  Red Beacon
//
//  Created by Jayahari V on 24/08/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "RBJobSchedule.h"
#import "RBTimeFormatter.h"

@interface RBJobSchedule (Private)
- (NSString*)scheduleNameForType:(NSString*)sType;
- (NSDate*)scheduleDateForType:(NSString*)sType;
@end

@implementation RBJobSchedule

@synthesize type;
@synthesize name;
@synthesize date;

NSString * const scheduleNameFlexible       = @"Flexible";
NSString * const scheduleNameSpecificDate   = @"Start at Date and Time";
NSString * const scheduleNameUrgent         = @"Urgent";

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.type forKey:@"type"];
	[aCoder encodeObject:self.name forKey:@"name"];
	[aCoder encodeObject:self.date forKey:@"date"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	
	self.type = [aDecoder decodeObjectForKey:@"type"];
	self.name = [aDecoder decodeObjectForKey:@"name"];
	self.date = [aDecoder decodeObjectForKey:@"date"];

    return self;
}

- (id)initWithSchedule:(RBJobSchedule*)schedule {
    self = [super init];
    if (self) {
        self.type = schedule.type;
        self.date = schedule.date;
    }
    return self;
}

- (void)dealloc {
    
    self.type = nil;
    self.name = nil;
    self.date = nil;
    [super dealloc];
}

/*Schedule Type Values Are the following
 ○ F-for“Iamflexible”flexible-timejobs(default) 
 ○ N-forspecificdateandtimejobs 
 ○ R-forurgentjobswithinthehour */
- (void)setType:(NSString *)sType {
    type = [sType retain];
    self.name = [self scheduleNameForType:sType];
    self.date = [self scheduleDateForType:sType];
}

//returns the value for the schedule name w.r.t type
/*Schedule Name Values Are the following
 ○ type = F -> name = Flexible 
 ○ type = N -> name = Start at Date and Time 
 ○ type = R -> name = Urgent */
- (NSString*)scheduleNameForType:(NSString*)sType {
    NSString * sName = nil;
    if ([sType isEqualToString:SCHEDULE_TYPE_FLEXIBLE]) {
        sName = scheduleNameFlexible;
    }
    else if ([sType isEqualToString:SCHEDULE_TYPE_URGENT]) {
        sName = scheduleNameUrgent;
    }
    else if ([sType isEqualToString:SCHEDULE_TYPE_DATE]) {
        sName = scheduleNameSpecificDate;
    }
    return sName;
}

- (NSDate*)scheduleDateForType:(NSString*)sType {
    NSDate * sDate = nil;
    if ([sType isEqualToString:SCHEDULE_TYPE_FLEXIBLE]||
        [sType isEqualToString:SCHEDULE_TYPE_URGENT]) {
        int seconds = 2*24*60*60; //2days * 24hours * 60 minutes * 60 seconds
        NSDate * dayAfterTomorrow = [NSDate dateWithTimeIntervalSinceNow:seconds];
        sDate = dayAfterTomorrow;
    }
    return sDate;
}

//checks for flexible type
- (BOOL)isFlexible {
    BOOL isFlexible = NO;
    if ([type isEqualToString:SCHEDULE_TYPE_FLEXIBLE]) {
        isFlexible = YES;
    }
    return isFlexible;
}

//checks for urgent type
- (BOOL)isUrgent {
    BOOL isUrgent = NO;
    if ([type isEqualToString:SCHEDULE_TYPE_URGENT]) {
        isUrgent = YES;
    }
    return isUrgent;
}

//returns the string value for the saved NSDate(self.date) type
- (NSString*)dateString {
    NSString * dateString = nil;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateFormat];
    dateString = [formatter stringFromDate:self.date];
    [formatter release];
    formatter = nil;
    return dateString;
}

@end
