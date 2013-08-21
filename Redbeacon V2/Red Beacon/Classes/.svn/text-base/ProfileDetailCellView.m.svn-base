//
//  ProfileDetailCellView.m
//  Red Beacon
//
//  Created by sudeep on 13/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "ProfileDetailCellView.h"
#import "RVSlider.h"
#import "MWPhotoBrowser.h"
#import "ProfileDetailViewController.h"

@class ProfileDetailViewController;

#define RB_SCORE_RECT CGRectMake(10, 25, 45, 30);

@implementation ProfileDetailCellView

@synthesize content;
@synthesize key;

#define FEATURE_LABEL_RECT CGRectMake(20, 30, 45, 30);
#define INFORMATION_LABEL_RECT CGRectMake(100, 30, 55, 30);
#define REPUTATION_LABEL_RECT CGRectMake(200, 30, 55, 30);

#define SCORE_RECT_DETAIL CGRectMake(32, 10, 45,30); 
#define SCORE_RECT_INFORMATION CGRectMake(95, 11, 65,30)
#define SCORE_RECT_REPUTATION CGRectMake(195, 11, 65,30)

#define FEATURES_IMAGE_RECT CGRectMake(32, 12, 20, 15);
#define RBSCORE_RECT CGRectMake(30, 12, 30, 15);
#define AMOUNT_RECT CGRectMake(100, 15, 100, 15)
#define WEBSITE_RECT CGRectMake(100, 20, 100, 15)



NSString * dpbondedImageEnabled = @"bonded_enabled";
NSString * dpbondedImageDisabled = @"bonded_disabled";

NSString * dplicensedImageEnabled = @"licence_enabled";
NSString * dplicensedImageDisabled = @"licence_disabled";

NSString * dpinsuredImageEnabled = @"insured_enabled";
NSString * dpinsuredImageDisabled = @"insured_disabled";


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

#pragma mark -webCLick 

-(void)websiteClicked:(id)sender {
    
    NSString *website = [content objectForKey:key];
    if([website isKindOfClass:[NSString class]])
        [[UIApplication sharedApplication] 
         openURL:[NSURL URLWithString:website]];
}

#pragma mark - cell view creation

-(void)createRBScoreCell {
    
    UIFont * scoreFont = [UIFont boldSystemFontOfSize:16];
    UIFont * labelFont = [UIFont boldSystemFontOfSize:9];
    UIFont * normalFont = [UIFont systemFontOfSize:16];
    
    JobRBScore *rbScore = [content objectForKey:key];
    
    //************************DISPLAY SCORE*********************************
    [[UIColor blackColor] set];
    NSString * score = [NSString stringWithFormat:@"%d",rbScore.total];
    CGRect rect = RBSCORE_RECT;
    [score drawInRect:rect withFont:scoreFont lineBreakMode: UILineBreakModeClip 
            alignment: UITextAlignmentCenter];
    
    //************************DISPLAY Detailed score*********************************
    [[UIColor grayColor] set];
    rect = CGRectMake(170, 20, 10, 10);
    [@"+" drawInRect:rect withFont:scoreFont lineBreakMode: UILineBreakModeClip 
            alignment: UITextAlignmentCenter];
    
    rect = INFORMATION_LABEL_RECT;
    [@"Information" drawInRect:rect withFont:labelFont lineBreakMode: UILineBreakModeClip 
            alignment: UITextAlignmentCenter];
    
    rect = REPUTATION_LABEL_RECT;
    [@"Reputation" drawInRect:rect withFont:labelFont lineBreakMode: UILineBreakModeClip 
                     alignment: UITextAlignmentCenter];
    
    NSString *information = [NSString stringWithFormat:@"%d of 50",rbScore.information];
    rect = SCORE_RECT_INFORMATION;
    [information drawInRect:rect withFont:normalFont lineBreakMode: UILineBreakModeClip 
                    alignment: UITextAlignmentCenter];

    NSString *reputation = [NSString stringWithFormat:@"%d of 50",rbScore.reputation];
    rect = SCORE_RECT_REPUTATION;
    [reputation drawInRect:rect withFont:normalFont lineBreakMode: UILineBreakModeClip 
                    alignment: UITextAlignmentCenter];
    
}

-(void)createInsuredCell {
    
    UIFont * normalFont = [UIFont systemFontOfSize:18];
    NSString *insuredAmount = [NSString stringWithFormat:@"$%@",[content objectForKey:key]];
    CGRect rect = AMOUNT_RECT;
    [insuredAmount drawInRect:rect withFont:normalFont lineBreakMode: UILineBreakModeClip 
                  alignment: UITextAlignmentLeft];
    
}

-(void)createLicensedCell {
    
    UIFont * normalFont = [UIFont systemFontOfSize:18];
    NSString *licensedAmount = [NSString stringWithFormat:@"#%@",[content objectForKey:key]];
    CGRect rect = AMOUNT_RECT;
    [licensedAmount drawInRect:rect withFont:normalFont lineBreakMode: UILineBreakModeClip 
                    alignment: UITextAlignmentLeft];
}

-(void)createBondedCell {
    
    UIFont * normalFont = [UIFont systemFontOfSize:18];
    NSString *bondedAmount = [NSString stringWithFormat:@"$%@",[content objectForKey:key]];
    CGRect rect = AMOUNT_RECT;
    [bondedAmount drawInRect:rect withFont:normalFont lineBreakMode: UILineBreakModeClip 
                    alignment: UITextAlignmentLeft];
}

-(void)createImagesCell {
    
    NSArray *workImages = [content objectForKey:key];

    UIView* slider_container = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 55)];
    
    NSMutableArray* playables = [[NSMutableArray alloc] initWithCapacity: [workImages count]];
   	
	for (WorkImage* image in workImages) {
        [playables addObject: image];
	}
	
    // Set up featured list slider
    RVSlider *imageSlider = [[RVSlider alloc] initWithFrame: CGRectMake (0,0, 520, 55) playables: playables tag: 0];
    if ([playables count] > 1) {
        [imageSlider scrollToIndex: 1 animated: NO];
    }
    [playables release];
    imageSlider.sliderDelegate = self;
    [slider_container addSubview: imageSlider];
	[self addSubview:slider_container];
	
    [slider_container release];
    //[imageSlider performSelectorOnMainThread: @selector (startAutoScroll) withObject: nil waitUntilDone: NO];
    [imageSlider release];
    
}

- (void) slider: (RVSlider*) slider thumbnailClicked: (int) index {
    
    NSLog(@"index selected= %d",index);
    NSArray *workImages = [content objectForKey:key];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for(int i = 0; i < [workImages count]; i++){
        WorkImage *workImage = [workImages objectAtIndex:i];
        NSURL *url = [[NSURL alloc] initWithString:workImage.image_url];
        [photos addObject:url];
        [url release];
        url = nil;
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
    [browser setHidesBottomBarWhenPushed:YES];

    ProfileDetailViewController *profileController = LOCATE(ProfileDetailViewController);
    [profileController.navigationController pushViewController:browser animated:YES];
    [photos release];
    [browser release];
}

-(void)createAboutCell {
    
    UIFont * normalFont = [UIFont systemFontOfSize:11];
    NSArray *details = [content objectForKey:key];
    NSString *about = [NSString stringWithFormat:@"%@",[details objectAtIndex:0]];
    CGRect rect = AMOUNT_RECT;
    rect.size.width = 200;
    rect.size.height = self.frame.size.height;
    [about drawInRect:rect withFont:normalFont lineBreakMode: UILineBreakModeClip 
                   alignment: UITextAlignmentLeft];
}

-(void)createWebsiteCell {
    
    [[UIColor blueColor] set];
    UIFont * normalFont = [UIFont systemFontOfSize:11];
    NSString *website = [content objectForKey:key];
    CGRect rect = WEBSITE_RECT;
    rect.origin.y = self.center.y - 5;
    rect.size.width = 200;
    rect.size.height = self.frame.size.height;
    [website drawInRect:rect withFont:normalFont lineBreakMode: UILineBreakModeClip 
            alignment: UITextAlignmentLeft];
    
    UIButton *websiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rect = self.frame;
    rect.origin.x = 60;
    [websiteButton setFrame:rect];
    [websiteButton addTarget:self action:@selector(websiteClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:websiteButton];
    websiteButton=nil;
    
    [[UIColor grayColor] set];
}


#pragma mark - draw rect


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    UIColor * labelColor = [UIColor grayColor];
    
    UIFont * labelFont = [UIFont boldSystemFontOfSize:9];
    
    NSString *imageName = nil;
    NSString *featureTitle = nil; 
    NSString *backGroundImage = nil;
    
    //**********************CREATING THE LABELS**********************
    [labelColor set];
    
    backGroundImage = CELL_BACKGROUND_IMAGE;
    if(backGroundImage) {
        rect = self.frame;
        NSString * pathToImage;
        pathToImage = [[NSBundle mainBundle] pathForResource:backGroundImage 
                                                      ofType:@"png"];
        UIImage *bkImage = [[UIImage alloc] initWithContentsOfFile:pathToImage];
        [bkImage drawInRect:rect];
        [bkImage release];
        bkImage=nil;
    }

       
    if ([key isEqualToString:RBSCORE_KEY]) {
        
        featureTitle = RBSCORE_LABEL;
//        backGroundImage = CELL_BACKGROUND_IMAGE;
        [self createRBScoreCell];
        
        
    }
    else if ([key isEqualToString:BONDED_KEY]) {
        
        imageName = dpbondedImageEnabled;
        featureTitle = BONDED_LABEL;
//        backGroundImage = CELL_BACKGROUND_IMAGE;
        [self createBondedCell];
    }
    else if ([key isEqualToString:INSURED_KEY]) {
        
        imageName = dpinsuredImageEnabled;
        featureTitle = INSURED_LABEL;
//        backGroundImage = CELL_BACKGROUND_IMAGE;
        [self createInsuredCell];
        
    }
    else if ([key isEqualToString:LICENSED_KEY]) {
        
        imageName = dplicensedImageEnabled;
        featureTitle = LICENCED_LABEL;
//        backGroundImage = CELL_BACKGROUND_IMAGE;
        [self createLicensedCell];
        
    }
    else if ([key isEqualToString:WORK_IMAGES_KEY]) {
        
        [self createImagesCell];
//        backGroundImage = CELL_BACKGROUND_IMAGE_WITHOUT_LINE;
    }
    else if ([key isEqualToString:DETAILS_KEY]) {
        
        featureTitle = @"About";
//        backGroundImage = CELL_BACKGROUND_IMAGE_WITHOUT_LINE;
        [self createAboutCell];
        
    }
    else if ([key isEqualToString:WEBSITE_KEY]) {
        
        featureTitle = @"Website";
//        backGroundImage = CELL_BACKGROUND_IMAGE_WITHOUT_LINE;
        [self createWebsiteCell];
    }
    
    
    //***************************TITLE SECTION*************************
    
    if(imageName){
        rect = FEATURES_IMAGE_RECT;
        NSString * pathToImage;
        pathToImage = [[NSBundle mainBundle] pathForResource:imageName 
                                                      ofType:@"png"];
        UIImage *featureImage = [[UIImage alloc] initWithContentsOfFile:pathToImage];
        [featureImage drawInRect:rect];
        [featureImage release];
        featureImage=nil;
    }
    
    if(featureTitle){
        rect = FEATURE_LABEL_RECT;
        [featureTitle drawInRect:rect withFont:labelFont lineBreakMode: UILineBreakModeClip 
                     alignment: UITextAlignmentCenter];
    }

    //*******************************************************************
    
}


- (void)dealloc
{
    self.content = nil;
    self.key = nil;
    [super dealloc];
}


- (void)displayCellItems:(id)item withKey:(NSString *)keyValue{
    
    [content release];
    content = [item retain];
    
    [key release];
    key = [keyValue retain];
        
    [self setNeedsDisplay];
}

@end
