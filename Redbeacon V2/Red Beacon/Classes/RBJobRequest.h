//
//  RBJobRequest.h
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RBJobRequest : NSObject
{
    NSString * occupationName;
    NSString * jobTimeSelector;
    NSString * approxLocation;
    NSString * details;
    NSString * jobImageIDs;
    NSString * flexibleOption;
    NSString * date;
    NSNumber * hrMinTimeBegin;
    NSNumber * hrMinTimeEnd;
    NSString * altDate; 
    NSNumber * altHrMinTimeBegin;
    NSNumber * altHrMinTimeEnd;
}

@property (nonatomic, retain) NSString * occupationName;
@property (nonatomic, retain) NSString * jobTimeSelector;
@property (nonatomic, retain) NSString * approxLocation;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * jobImageIDs;
@property (nonatomic, retain) NSString * flexibleOption;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSNumber * hrMinTimeBegin;
@property (nonatomic, retain) NSNumber * hrMinTimeEnd;
@property (nonatomic, retain) NSString * altDate;
@property (nonatomic, retain) NSNumber * altHrMinTimeBegin;
@property (nonatomic, retain) NSNumber * altHrMinTimeEnd;

- (void)doURLEncode;

@end
