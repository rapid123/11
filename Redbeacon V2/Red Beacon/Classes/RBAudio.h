//
//  RBAudio.h
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBMediaStatusTracker.h"

@interface RBAudio : NSObject<NSCoding> 
{
    
    NSString * audioDuration;
    BOOL used;
}
@property (nonatomic, retain) NSString * audioDuration;
@property (nonatomic, assign) BOOL used;

@end
