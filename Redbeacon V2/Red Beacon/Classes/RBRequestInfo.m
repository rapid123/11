//
//  RBRequestInfo.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBRequestInfo.h"


@implementation RBRequestInfo

@synthesize mediaType;
@synthesize mediaFilename;
@synthesize requestType;


- (void)dealloc
{
    [mediaFilename release];


    
    [super dealloc];
}
@end
