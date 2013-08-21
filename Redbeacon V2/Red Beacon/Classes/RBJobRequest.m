//
//  RBJobRequest.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBJobRequest.h"

@implementation RBJobRequest

@synthesize occupationName;
@synthesize jobTimeSelector;
@synthesize approxLocation;
@synthesize details;
@synthesize jobImageIDs;
@synthesize flexibleOption;
@synthesize date;
@synthesize hrMinTimeBegin;
@synthesize hrMinTimeEnd;
@synthesize altDate;
@synthesize altHrMinTimeBegin;
@synthesize altHrMinTimeEnd;

- (void)dealloc
{
    [occupationName release];
    [jobTimeSelector release];
    [approxLocation release];
    [details release];
    [jobImageIDs release];
    [flexibleOption release];
    [date release];
    [hrMinTimeBegin release];
    [hrMinTimeEnd release];
    [altDate release];
    [altHrMinTimeBegin release];
    [altHrMinTimeEnd release];
    
    [super dealloc];
}




// Call this function to url encode the appropriate string values before passing
// it with the URL.
- (void)doURLEncode
{
    NSString * tempValue = [RBConstants urlEncodedParamStringFromString:occupationName];
    self.occupationName = tempValue;
    
    tempValue = [RBConstants urlEncodedParamStringFromString:jobTimeSelector];
    self.jobTimeSelector = tempValue;
    
    tempValue = [RBConstants urlEncodedParamStringFromString:approxLocation];
    self.approxLocation = tempValue;
    
    tempValue = [RBConstants urlEncodedParamStringFromString:details];
    self.details = tempValue;
    
    tempValue = [RBConstants urlEncodedParamStringFromString:jobImageIDs];
    self.jobImageIDs = tempValue;
    
    tempValue = [RBConstants urlEncodedParamStringFromString:flexibleOption];
    self.flexibleOption = tempValue;
    
    tempValue = [RBConstants urlEncodedParamStringFromString:date];
    self.date = tempValue;
    
    tempValue = [RBConstants urlEncodedParamStringFromString:altDate];
    self.altDate = tempValue;
}




@end
