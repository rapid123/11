//
//  RBFacebookLoginDialog.h
//  FBFun
//
//  Created by Ray Wenderlich on 7/13/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RBFacebookLoginDialogDelegate
- (void)accessTokenFound:(NSString *)apiKey;
- (void)displayRequired;
- (void)closeTapped;
@end

@interface RBFacebookLoginDialog : UIViewController <UIWebViewDelegate> {
    UIWebView *_webView;
    NSString *_apiKey;
    NSString *_requestedPermissions;
    id <RBFacebookLoginDialogDelegate> _delegate;
    IBOutlet UIActivityIndicatorView *spinner;
}

@property (retain) IBOutlet UIWebView *webView;
@property (copy) NSString *apiKey;
@property (copy) NSString *requestedPermissions;
@property (retain) IBOutlet UIActivityIndicatorView *spinner;
@property (assign) id <RBFacebookLoginDialogDelegate> delegate;


- (id)initWithAppId:(NSString *)apiKey requestedPermissions:(NSString *)requestedPermissions delegate:(id<RBFacebookLoginDialogDelegate>)delegate;
- (IBAction)closeTapped:(id)sender;
- (void)login;
- (void)logout;

-(void)checkForAccessToken:(NSString *)urlString;
-(void)checkLoginRequired:(NSString *)urlString;

@end
