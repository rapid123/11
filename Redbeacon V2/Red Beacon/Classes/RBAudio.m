//
//  RBAudio.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBAudio.h"


@implementation RBAudio

@synthesize audioDuration;
@synthesize used;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.audioDuration forKey:@"audioDuration"];
    [aCoder encodeBool:self.used forKey:@"used"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	
	self.audioDuration = [aDecoder decodeObjectForKey:@"audioDuration"];
	self.used = [aDecoder decodeBoolForKey:@"used"];
    
    return self;
}

- (void)dealloc {
    self.audioDuration = nil;
    [super dealloc];
}


@end
