//
//  RBNavigationController.m
//  Red Beacon
//
//  Created by Jayahari V on 17/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UINavigationItem + RedBeacon.h"



@implementation UINavigationBar (CustomImage)

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage 
                      imageWithContentsOfFile:[[NSBundle mainBundle] 
                                               pathForResource:@"navigationBar"
                                               ofType:@"png"]];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   

}
@end


@implementation RBNavigationController 

- (void)customizeNavigationBarForBothiOS5andiOS4:(UINavigationController *)navContr{
    
    UINavigationBar *navBar = [navContr navigationBar];
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
}

- (id) initWithRootViewController:(UIViewController *)rootViewController {
    
    if((self = [super initWithRootViewController:rootViewController])) {
        
        [self customizeNavigationBarForBothiOS5andiOS4:self];
    }
    
    return self;
}



@end


@implementation UINavigationItem (RedBeacon)


#pragma mark setter methods
- (void)setRBTitle:(NSString *)title {
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:RBNAVIGATIONITEM_TITLEVIEW_RECT];

    //set different properties
    [titleLabel setText:title];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:kRBNavigationTitle_Font_Size]];
    
    [self setTitleView:titleLabel];
    [titleLabel release];
    titleLabel = nil;
}

- (void)setRBTitle:(NSString *)title withSubTitle:(NSString*)subTitle {
    
    UIView * titleView = [[UIView alloc] initWithFrame:RBNAVIGATIONITEM_TITLEVIEW_RECT];
    float bottomPading = 5;
    CGRect titleLabelRect = RBNAVIGATIONITEM_TITLEVIEW_RECT;
    titleLabelRect.size.height = titleLabelRect.size.height/2;
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:titleLabelRect];
    
    
    CGRect subTitleLabelRect = RBNAVIGATIONITEM_TITLEVIEW_RECT;
    subTitleLabelRect.origin.y = (titleLabelRect.size.height)+ titleLabelRect.origin.y;
    subTitleLabelRect.size.height = (subTitleLabelRect.size.height/2)-bottomPading;
    UILabel * subTitleLabel = [[UILabel alloc] initWithFrame:subTitleLabelRect];
    
    [titleLabel setText:title];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:kRBNavigationTitle_Font_Size]];
    
    [subTitleLabel setText:subTitle];
    [subTitleLabel setTextColor:[UIColor blackColor]];
    [subTitleLabel setBackgroundColor:[UIColor clearColor]];
    [subTitleLabel setTextAlignment:UITextAlignmentCenter]; 
    [subTitleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [subTitleLabel setFont:[UIFont systemFontOfSize:kRBNavigationSubTitle_Font_Size]];
    
    
    [titleView addSubview:titleLabel];
    [titleLabel release];
    [titleView addSubview:subTitleLabel];    
    [subTitleLabel release];    
    [self setTitleView:titleView];    
    [titleView release];
    
}

- (void)setRBIconImage {
    
    UIImageView * iconView = [[UIImageView alloc] initWithFrame:RBNAVIGATIONITEM_TITLEVIEW_RECT];
    CGRect iconRect = iconView.frame;
    iconRect.size.height = 38;
    iconView.frame = iconRect;
    NSString * iconPath = [[NSBundle mainBundle] pathForResource:kRBLogoImage 
                                                          ofType:kRBImageType];
    UIImage * icon = [[UIImage alloc] initWithContentsOfFile:iconPath];
    iconPath = nil;
    iconView.image = icon;
    [icon release];
    icon = nil;
    [iconView setContentMode:UIViewContentModeScaleAspectFit];
    [self setTitleView:iconView];
    [iconView release];
    iconView = nil;
    
}

@end
