//
//  MyApplication.m
//  NotiyiiPhoneApplicationProject


#import "MyApplication.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "GeneralClass.h"

//private methods
@interface MyApplication()

- (void)resetTimers;
- (void)autoDimTimerExceeded;
- (void)autoLockTimerExceeded;

@end

@implementation MyApplication

/*******************************************************************************
 *  Function Name: sendEvent.
 *  Purpose: It is a delegate which will fire when user tap.
 *  Parametrs: event Object.
 *  Return Values:nil.
 ********************************************************************************/
- (void)sendEvent:(UIEvent *)event
{
    NSLog(@"send Event");

    [super sendEvent:event];
			// Only want to reset the timer on a Began touch or an Ended touch, to reduce the number of timer resets.
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0)
    {
			// allTouches count only ever seems to be 1, so anyObject works here.
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if ((phase == UITouchPhaseBegan || phase == UITouchPhaseEnded) && ![[NSUserDefaults standardUserDefaults] boolForKey:@"SessionExpired"])
        {
            [self resetTimers];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SessionExpired"];

        }
    }
}
/*******************************************************************************
 *  Function Name: resetTimers.
 *  Purpose: Method is used for resetting the timer.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
- (void)resetTimers
{
    if (autoDimTimer)
    {
        [autoDimTimer invalidate];
    }
    if(autoLockTimer)
    {
        [autoLockTimer invalidate];
    }
	double autoDimTime = 1200;
    double autoLockTime = 1200;
    
    autoDimTimer = [NSTimer scheduledTimerWithTimeInterval:autoDimTime
												    target:self 
												  selector:@selector(autoDimTimerExceeded)
												  userInfo:nil 
												   repeats:NO];
    
    autoLockTimer = [NSTimer scheduledTimerWithTimeInterval:autoLockTime
												     target:self
												   selector:@selector(autoLockTimerExceeded)
												   userInfo:nil
												    repeats:NO];
}

/*******************************************************************************
 *  Function Name: autoDimTimerExceeded.
 *  Purpose: To Check whether autoDimTimerExceeded.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
- (void)autoDimTimerExceeded
{
    autoDimTimer=nil;
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"logged_in"])
    {
        NSString *alertMessage = NSLocalizedString(@"SESSION EXPIRY", nil);

        [GeneralClass showAlertView:self
                                 msg:alertMessage
                               title:nil
                         cancelTitle:@"OK"
                          otherTitle:nil
                                 tag:sessionExpiryTag];
    }
    else
    {
        NSLog(@"Not Logged in");
    }
}

/*******************************************************************************
 *  Function Name: autoLockTimerExceeded.
 *  Purpose: To Check whether autoLockTimer Exceeded.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
- (void)autoLockTimerExceeded
{
    autoLockTimer=nil;
}

#pragma mark- Alertview delegates
/*******************************************************************************
 *  UIAlertview delegates
 ********************************************************************************/
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
    if(alertView.tag == sessionExpiryTag)
    {
        if (buttonIndex == 0)
        {
            alertView =nil;
            AppDelegate *app= (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app logOutButtonTouched];
        }

    }
}

#pragma mark- Memory
- (void)dealloc {
    [autoDimTimer invalidate];
    [autoLockTimer invalidate];
}


@end
