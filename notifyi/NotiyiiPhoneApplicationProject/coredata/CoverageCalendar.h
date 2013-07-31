//
//  CoverageCalendar.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Rapidvalue on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoverageCalendar : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * title;

@end
