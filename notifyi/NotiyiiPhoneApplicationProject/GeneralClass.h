//
//  GeneralClass.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 12/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralClass : NSObject
{
    id globalId;
}

+(UIFont *)getFont:(float)size and: (NSString *)fontName;
-(UISearchBar *) searchBarBackGroundColorSetting:(UISearchBar *)searchBar;
+(void)showAlertView:(id)delegateValue msg:(NSString *)message title:(NSString *)titleMessage cancelTitle:(NSString *)cancelMessage otherTitle:(NSString *)otherMessage tag:(int)tagValue;
+(BOOL)emailValidation:(NSString *)email;
+(void)clickableLinkMethod:(NSString*)link;
@end
