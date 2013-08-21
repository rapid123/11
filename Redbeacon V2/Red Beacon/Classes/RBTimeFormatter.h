//
//  RBTimeFormatter.h
//  Red Beacon
//
//  Created by Jayahari V on 26/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RBTimeFormatter : NSObject
{
    NSString* timeValueString;
}

@property (nonatomic, retain) NSString* timeValueString;

- (int)timeValueForDate:(NSDate*)date;

@end
