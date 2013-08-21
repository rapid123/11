//
//  RBJobSchedule.h
//  Red Beacon
//
//  Created by Jayahari V on 24/08/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBJobSchedule : NSObject<NSCoding> {
    
    /*Schedule Type Values Are the following
     ○ F - for“Iamflexible”flexible-timejobs(default) 
     ○ N - forspecificdateandtimejobs 
     ○ R - forurgentjobswithinthehour */
    NSString * type;
    
    /*Schedule Name Values Are the following
     ○ F - Flexible 
     ○ N - Start at Date and Time 
     ○ R - Urgent*/
    NSString * name;
    
    NSDate * date;
}
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;

//returns the object with same values as in the parameter scheduleObject
- (id)initWithSchedule:(RBJobSchedule*)schedule;

//returns TRUE if schedule is a flexible one
- (BOOL)isFlexible;

//returns TRUE if schedule is a Urgent one
- (BOOL)isUrgent;

//returns the string value for the saved NSDate(self.date) type
- (NSString*)dateString;
@end
