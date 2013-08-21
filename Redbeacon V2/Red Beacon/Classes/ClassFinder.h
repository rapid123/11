//
//  ClassFinder.h
//
//  Created by sudeep on 07/02/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOCATE(__classname__) (__classname__ *)[ClassFinder locate:@#__classname__]
#define UNLOAD(__classname__) (__classname__ *)[ClassFinder unload:@#__classname__]
 
@interface ClassFinder : NSObject {

}

+(id)locate:(NSString *)className;
+(void)unload:(NSString *)className;

+(void)releaseInstances;

@end
