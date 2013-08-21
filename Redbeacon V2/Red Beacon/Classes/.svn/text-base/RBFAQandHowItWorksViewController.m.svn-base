//
//  RBFAQandHowItWorksViewController.m
//  Red Beacon
//
//  Created by Jai Raj on 01/11/11.
//  Copyright (c) 2011 Rapid Value Solutions. All rights reserved.
//

#import "RBFAQandHowItWorksViewController.h"

#define ACTIVITY_FRAME CGRectMake(20, 20, 10, 10)
#define ACTIVITYINDICATOR_TAG 999

#ifdef PROD_CONFIG
#define FAQ_LINK @"http://www.redbeacon.com/about/iphone/faq"
#else
#define FAQ_LINK @"http://redbeacon-inc.com/about/iphone/faq"
#endif

@implementation RBFAQandHowItWorksViewController

@synthesize FAQwebview;
@synthesize FAQView;
@synthesize howItWorksView;
@synthesize isFAQ;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - navigation button click 

-(void)onTouchUpBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - navigation bar

//will setup the navigation bar, format the navigation items
- (void)setupNavigationBar 
{
    
    [self.navigationItem setRBIconImage];
    
    //adds the Close button
    UIButton *closeButton = [[UIButton alloc] init];
    closeButton.frame = CGRectMake(0, 0, 60, 30);
    closeButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [closeButton setTitle:@"Back" forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:NavigationButtonBackgroundImage] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(onTouchUpBack:) 
          forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    [closeButton release];
    closeButton = nil;
    self.navigationItem.leftBarButtonItem = closeButtonItem;
    [closeButtonItem release];
    closeButtonItem = nil;
    
    //to adjust the title position
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,60, 30)];
    UIBarButtonItem * barbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:barbuttonItem];
    [button release];
    button = nil;
    [barbuttonItem release];
    barbuttonItem = nil;   
}


-(void)showWebviewContent {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:FAQ_LINK]];
    [FAQwebview loadRequest:request];
    [FAQwebview.layer setCornerRadius:5];
    FAQwebview.clipsToBounds = YES;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame=ACTIVITY_FRAME;
    activityIndicator.center=self.view.center;
    activityIndicator.tag = ACTIVITYINDICATOR_TAG;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [activityIndicator release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    //[FAQwebview.scrollView.layer setCornerRadius:5];
   
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    
    if(isFAQ) {
        [self.navigationItem setRBTitle:@"FAQ"];
        [self.view addSubview:FAQView];
        [self showWebviewContent];
    }
    else {
        [self.navigationItem setRBTitle:@"How it Works"];
        [FAQView removeFromSuperview];
    }
    
}

#pragma webview delegates

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"WebView started loading");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"WEBVIEW ENDED LOADING");
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self.view viewWithTag:ACTIVITYINDICATOR_TAG];
    [activityIndicator removeFromSuperview];
}


#pragma mark - memory management

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc {
    
    self.FAQwebview = nil;
    self.FAQView = nil;
    self.howItWorksView = nil;
}

@end
