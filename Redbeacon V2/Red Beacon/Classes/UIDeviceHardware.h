//
//  UIDeviceHardware.h
//  Red Beacon
//
//  Created by Ian Langworth on 9/26/11.
//  Copyright 2011 Red Beacon, Inc. All rights reserved.
//
//  From http://stackoverflow.com/questions/448162/determine-device-iphone-ipod-touch-with-iphone-sdk

#import <Foundation/Foundation.h>


@interface UIDeviceHardware : NSObject {
    
}

- (NSString *) platform;
- (NSString *) platformString;

@end
