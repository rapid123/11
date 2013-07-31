//
//  Utilities.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 01/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Utilities : NSObject

+ (Utilities *)sharedInstance;

//-(void)saveTouchBases:(NSMutableArray *)touchBases;
-(NSString *)formattedDateWithDate:(NSDate *)date Formate:(NSString *)format;
- (NSString*)formattedDateWithFormatString:(NSString*)dateFormatterString ;
- (NSString*)currentDate;
-(NSString *)currentDateWithFormate:(NSString *)formate;
//- (void) cacheImage: (NSString *) ImageURLString;
- (void) cacheImage: (NSString *) ImageURLString imgName:(NSString *)imageName;
- (NSString *)isToday:(NSDate *)currentDate;

@end
