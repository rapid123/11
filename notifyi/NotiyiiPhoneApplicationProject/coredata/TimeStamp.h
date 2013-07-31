//
//  TimeStamp.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Rapidvalue on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimeStamp : NSManagedObject

@property (nonatomic, retain) NSDate * lastUpdatedDate;
@property (nonatomic, retain) NSNumber * operationType;

@end
