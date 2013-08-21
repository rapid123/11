//
//  RBAlertMessageHandler.m
//  Red Beacon
//
//  Created by Jayahari V on 7/31/10.
//  Copyright 2010 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RBAlertMessageHandler : NSObject {

}

+(void)showAlert:(NSString *)strAlertMessage delegateObject:(id)delegate;
+(void)showAlert:(NSString *)strAlertMessage delegateObject:(id)delegate viewTag:(int)iTag;
+(void)showAlert:(NSString *)strAlertMessage delegateObject:(id)delegate viewTag:(int)iTag showCancel:(BOOL)bShow;
+(void)showAlert:(NSString *)strAlertMessage delegateObject:(id)delegate viewTag:(int)iTag otherButtonTitle:(NSString*)strTitle;
+(void)showDiscardAlertWithTitle:(NSString *)title 
                         message:(NSString*)message
                  delegateObject:(id)delegate 
                         viewTag:(int)iTag;

+(void)showAlertWithTitle:(NSString *)title 
                  message:(NSString*)message
           delegateObject:(id)delegate 
                  viewTag:(int)iTag
         otherButtonTitle:(NSString*)buttonTitle
               showCancel:(BOOL)bShow;

+(void)showAlertWithMultipleButtons:(NSString *)strAlertMessage 
                     delegateObject:(id)delegate 
                            viewTag:(int)iTag
                  otherButtonTitles:(NSArray*)arrTitles;

+(void)showMultipleButtonAlertWithTitle:(NSString *)title 
                                message:(NSString*)message
                         delegateObject:(id)delegate 
                                viewTag:(int)iTag
                       otherButtonTitle:(NSArray*)titles;
@end
