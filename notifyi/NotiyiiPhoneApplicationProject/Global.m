
//
//  GeneralClass.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 20/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Global.h"

@implementation Global
@synthesize messageType;

static Global *g;

+(Global*)getInstance{
	
    @synchronized([Global class]){
        if(g == nil){
            g = [[Global alloc] init];
        }
    }
    return g;   
}
@end
