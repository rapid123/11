//
//  RBAlertMessageHandler.m
//  Red Beacon
//
//  Created by Jayahari V on 7/31/10.
//  Copyright 2010 Rapid Value Solutions. All rights reserved.
//

#import "RBAlertMessageHandler.h"

@implementation RBAlertMessageHandler

NSString * const alertTitle = @"Red Beacon";

static UIAlertView *rbAlert;

/*******************************************************************************
 *  Function Name:showAlert
 *  Purpose:To an alert message 
 *  Parametrs:Alert message,delegate pointer
 *  Return Values:nil
 ********************************************************************************/

+(void)showAlert:(NSString *)strAlertMessage 
  delegateObject:(id)delegate 
{
	
	[RBAlertMessageHandler showAlert:strAlertMessage 
				  delegateObject:delegate 
						 viewTag:0];
}

/*******************************************************************************
 *  Function Name:showAlert
 *  Purpose:To an alert message 
 *  Parametrs:Alert message,delegate pointer
 *  Return Values:nil
 ********************************************************************************/

+(void)showAlert:(NSString *)strAlertMessage 
  delegateObject:(id)delegate 
         viewTag:(int)iTag 
{
	
	[RBAlertMessageHandler showAlert:strAlertMessage 
				  delegateObject:delegate 
						 viewTag:iTag 
					  showCancel:NO];
}

/*******************************************************************************
 *  Function Name:showAlert
 *  Purpose:To show an alert message 
 *  Parametrs:Alert message,delegate pointer,view tag,Cancel button status as BOOL
 *  Return Values:nil
 ********************************************************************************/

+(void)showAlert:(NSString *)strAlertMessage 
  delegateObject:(id)delegate 
         viewTag:(int)iTag 
      showCancel:(BOOL)bShow
{
	
	@try {
		
		if (bShow) {
			rbAlert=[[UIAlertView alloc] initWithTitle:alertTitle 
												message:strAlertMessage 
											   delegate:delegate 
									  cancelButtonTitle:nil
									  otherButtonTitles:@"OK",@"Cancel",nil];
		}
		else {
			
			rbAlert=[[UIAlertView alloc] initWithTitle:alertTitle 
												message:strAlertMessage 
											   delegate:delegate 
									  cancelButtonTitle:@"OK" 
									  otherButtonTitles:nil];
			
		}
		
		rbAlert.tag=iTag;
		
		[rbAlert show];
		[rbAlert release];
		rbAlert=nil;
	}
	@catch (NSException * e) {
		
	}
	@finally {
		
	}
}

/*******************************************************************************
 *  Function Name:showAlert
 *  Purpose:To show an alert message 
 *  Parametrs:Alert message,delegate pointer,alert view tag,other button title
 *  Return Values:nil
 ********************************************************************************/

+(void)showAlert:(NSString *)strAlertMessage 
  delegateObject:(id)delegate 
         viewTag:(int)iTag 
otherButtonTitle:(NSString*)strTitle 
{
	
	@try {
		
		rbAlert=[[UIAlertView alloc] initWithTitle:alertTitle 
											message:strAlertMessage 
										   delegate:delegate 
								  cancelButtonTitle:nil
								  otherButtonTitles:strTitle,@"Cancel",nil];
		rbAlert.tag=iTag;
		
		[rbAlert show];
		[rbAlert release];
		rbAlert=nil;
	}
	@catch (NSException * e) {
		
	}
	@finally {
		
	}
}

+(void)showDiscardAlertWithTitle:(NSString *)title 
                         message:(NSString*)message
                  delegateObject:(id)delegate 
                         viewTag:(int)iTag 
{
    
    @try {
        
        rbAlert=[[UIAlertView alloc] initWithTitle:title 
                                           message:message 
                                          delegate:delegate 
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"OK",@"Cancel",nil];
        rbAlert.tag=iTag;
        
        [rbAlert show];
        [rbAlert release];
        rbAlert=nil;
    }
    @catch (NSException * e) {
        
    }
    @finally {
        
    }
}

+(void)showAlertWithTitle:(NSString *)title 
                  message:(NSString*)message
           delegateObject:(id)delegate 
                  viewTag:(int)iTag
         otherButtonTitle:(NSString*)buttonTitle
               showCancel:(BOOL)bShow
{
    
    @try {
        if (bShow) {
            rbAlert=[[UIAlertView alloc] initWithTitle:title 
                                               message:message 
                                              delegate:delegate 
                                     cancelButtonTitle:nil
                                     otherButtonTitles:buttonTitle,@"Cancel",nil];
            rbAlert.tag=iTag;
            
            [rbAlert show];
            [rbAlert release];
            rbAlert=nil;
        }
        else {
            rbAlert=[[UIAlertView alloc] initWithTitle:title 
                                               message:message 
                                              delegate:delegate 
                                     cancelButtonTitle:nil
                                     otherButtonTitles:buttonTitle,nil];
            rbAlert.tag=iTag;
            
            [rbAlert show];
            [rbAlert release];
            rbAlert=nil;

        }
    }
    @catch (NSException * e) {
        
    }
    @finally {
        
    }
}


/*******************************************************************************
 *  Function Name:showAlertWithMultipleButtons
 *  Purpose:To show an alert message with multiple buttons
 *  Parametrs:Alert message,delegate pointer,alert view tag,Button titles array
 *  Return Values:nil
 ********************************************************************************/

+(void)showAlertWithMultipleButtons:(NSString *)strAlertMessage 
                     delegateObject:(id)delegate 
                            viewTag:(int)iTag 
                  otherButtonTitles:(NSArray*)arrTitles
{
	
	@try {
			
		rbAlert=[[UIAlertView alloc] initWithTitle:alertTitle 
											message:strAlertMessage 
										   delegate:delegate 
								  cancelButtonTitle:nil
								  otherButtonTitles:nil];
		//[[UIAlertView alloc] i]
		for (int i = 0; i < [arrTitles count]; i++) {
			
			[rbAlert addButtonWithTitle:[arrTitles objectAtIndex:i]];
			
		}
		
		rbAlert.tag=iTag;
		
		[rbAlert show];
		[rbAlert release];
		rbAlert=nil;
	}
	@catch (NSException * e) {
		
	}
	@finally {
		
	}
}

+(void)showMultipleButtonAlertWithTitle:(NSString *)title 
                  message:(NSString*)message
           delegateObject:(id)delegate 
                  viewTag:(int)iTag
         otherButtonTitle:(NSArray*)titles
{
    
    @try {
        rbAlert=[[UIAlertView alloc] initWithTitle:title 
                                           message:message 
                                          delegate:delegate 
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];

        for (int i = 0; i < [titles count]; i++) {            
            [rbAlert addButtonWithTitle:[titles objectAtIndex:i]];
            
        }
        
        rbAlert.tag=iTag;
        [rbAlert show];
        [rbAlert release];
        rbAlert=nil;    }
    @catch (NSException * e) {
        
    }
    @finally {
        
    }
}


@end
