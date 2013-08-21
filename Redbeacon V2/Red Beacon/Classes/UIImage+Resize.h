//
//  UIImage+Resize.h
//  Red Beacon
//
//  Created by Jayahari V on 02/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (UIImage_Resize)

- (UIImage*)imageByScalingToSize:(CGSize)targetSize;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
