

#import "BottomToolbar.h"

#import "ClassFinder.h"


#pragma mark -

@implementation BottomToolbar

- (void)drawRect:(CGRect)rect {
    
    NSString *imageName;
    imageName = @"cell_profile_witout_line";
    
    UIImage *image = [UIImage 
					  imageWithContentsOfFile:[[NSBundle mainBundle] 
											   pathForResource:imageName
											   ofType:@"png"]];
    imageName = nil;
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
 
#pragma mark -

/*
-(void)customizeToolbarForIPad	{
    
	//icon image
    
    int ajmc_tv_icon_width=225;
    int frame_x=0;
    
    UIButton *icon = [[UIButton alloc] init];
    icon.frame=CGRectMake(frame_x,5,ajmc_tv_icon_width,39);
    icon.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin);
    [icon setBackgroundImage:[UIImage imageWithContentsOfFile:
                              [[NSBundle mainBundle] pathForResource:@"ajmc_tv_icon" 
                                                              ofType:@"png"]] 
                    forState:UIControlStateNormal];
    [icon addTarget:self action:@selector(logoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnAJMCtvLink=[[UIBarButtonItem alloc] initWithCustomView:icon];
	barBtnAJMCtvLink.customView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	barBtnAJMCtvLink.style = UIBarButtonItemStylePlain;
	[icon release];
	icon = nil;
   
    UIBarButtonItem *fixedSpaceAfterLink=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace	
                                                                                    target:nil
                                                                                    action:nil];
    
	fixedSpaceAfterLink.width=60;
	
    //bar button flexible space
	UIBarButtonItem *fixedMiddleSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace	
                                                                                    target:nil
                                                                                    action:nil];
	fixedMiddleSpace.width=0;
	
    // button for rss feed
    UIButton *btnSwitchController = [[UIButton alloc] initWithFrame:CGRectMake(0,0,165, 44)];
	[btnSwitchController setTag:3];
	btnSwitchController.showsTouchWhenHighlighted = YES;
    [btnSwitchController setBackgroundColor:[UIColor clearColor]];
    UIImage *switchImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"focus2" 
                                                                                            ofType:@"png"]];
	[btnSwitchController setImage:switchImage
                        forState:UIControlStateNormal];
	[btnSwitchController addTarget:self action:@selector(onToolbarClick:) forControlEvents:UIControlEventTouchUpInside];	
	
    //bar button MRSS space	
	UIBarButtonItem *barBtnSW=[[UIBarButtonItem alloc] initWithCustomView:btnSwitchController];
	barBtnSW.customView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	barBtnSW.style = UIBarButtonItemStylePlain;
	[btnSwitchController release];
	btnSwitchController = nil;
    
    
    // button for rss feed
    UIButton *btnSwitchController2 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,134, 44)];
	[btnSwitchController2 setTag:1];
	btnSwitchController2.showsTouchWhenHighlighted = YES;
    [btnSwitchController2 setBackgroundColor:[UIColor clearColor]];
    UIImage *switchImage2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ajmc_1" 
                                                                                            ofType:@"png"]];
	[btnSwitchController2 setImage:switchImage2
                         forState:UIControlStateNormal];
	[btnSwitchController2 addTarget:self action:@selector(onToolbarClick:) forControlEvents:UIControlEventTouchUpInside];	
	
    //bar button MRSS space	
	UIBarButtonItem *barBtnSW2=[[UIBarButtonItem alloc] initWithCustomView:btnSwitchController2];
	barBtnSW2.customView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	barBtnSW2.style = UIBarButtonItemStylePlain;
	[btnSwitchController2 release];
	btnSwitchController2 = nil;

    
    // button for fav
    UIButton *btnFavourites = [[UIButton alloc] initWithFrame:CGRectMake(0,0,63, 44)];
	btnFavourites.showsTouchWhenHighlighted = YES;
    [btnFavourites setBackgroundColor:[UIColor clearColor]];
    UIImage *switchImagefav = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"add_to_favorite"                                                                             ofType:@"png"]];
	
    [btnFavourites setImage:switchImagefav
                         forState:UIControlStateNormal];
	[btnFavourites addTarget:self action:@selector(onFavoritesButtonClick:) forControlEvents:UIControlEventTouchUpInside];	
	
    //bar button fav space	
	UIBarButtonItem *barBtnFav=[[UIBarButtonItem alloc] initWithCustomView:btnFavourites];
	barBtnFav.customView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	barBtnFav.style = UIBarButtonItemStylePlain;
	[btnFavourites release];
	btnFavourites = nil;

    //for share
    UIButton *btnShareController = [[UIButton alloc] initWithFrame:CGRectMake(0,0,63, 44)];
	[btnShareController setTag:2];
	btnShareController.showsTouchWhenHighlighted = YES;
    [btnShareController setBackgroundColor:[UIColor clearColor]];
    UIImage *shareImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icn_share"	
                                                                                         ofType:@"png"]];
    [btnShareController setImage:shareImage
    				forState:UIControlStateNormal];
	[btnShareController addTarget:self action:@selector(onToolbarClick:) forControlEvents:UIControlEventTouchUpInside];	
	
    //bar button MRSS space	
	UIBarButtonItem *barBtnShare=[[UIBarButtonItem alloc] initWithCustomView:btnShareController];
	barBtnShare.customView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	barBtnShare.style = UIBarButtonItemStylePlain;
	[btnShareController release];
	btnShareController = nil;
	
	[self setItems:[NSArray arrayWithObjects:barBtnAJMCtvLink,
                          fixedSpaceAfterLink,
                          //fixedMiddleSpace,
						  barBtnSW,
						  fixedMiddleSpace,
                          barBtnSW2,
                          fixedMiddleSpace,  
                          barBtnFav,
                          fixedMiddleSpace,
                          barBtnShare,
						  nil]];
	
	[fixedMiddleSpace release];
	fixedMiddleSpace = nil;
    
    [fixedSpaceAfterLink release];
    fixedSpaceAfterLink=nil;
    
    [barBtnFav release];
    barBtnFav=nil;
	
	[barBtnSW release];
	barBtnSW = nil;
}

- (void)logoButtonClick:(id)sender{
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ajmc.com"]];
    if(!webLinkViewController)
        webLinkViewController=[[WebLinkViewController alloc] initWithNibName:@"WebLinkViewController" bundle:nil];
    
    UITabBarController *tabController=(UITabBarController *)delegateObject;
    UISplitViewController *splitview=[[tabController viewControllers] objectAtIndex:0];
    webLinkViewController.delegate=splitview;
    webLinkViewController.modalPresentationStyle=UIModalPresentationFullScreen;
    [splitview presentModalViewController:webLinkViewController animated:YES];
    
}

#pragma mark -


-(void)showShareList:(id)sender   {
    
    ShareViewController *shareViewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    shareViewController.delegate = self;
    
    if (popovercontroller) {
        [popovercontroller dismissPopoverAnimated:NO];
        [popovercontroller release];
        popovercontroller = nil;
    }
        
    popovercontroller  = [[UIPopoverController alloc] initWithContentViewController:shareViewController];
    [shareViewController release];
    shareViewController = nil;
   
    
    UITabBarController *controller = ((UITabBarController *)delegateObject);
    
    UIViewController *viewController = [[controller viewControllers] objectAtIndex:0];
    
   [popovercontroller presentPopoverFromRect:CGRectMake((viewController.view.frame.size.width-73), (viewController.view.frame.size.height), 63, 44) inView:viewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

-(void)dismissPop:(NSNotification *)note {
    
    if (popovercontroller) {
               [popovercontroller dismissPopoverAnimated:NO];
    }
}

-(void)clickButtonAtIndex:(int)index    {
    
   if (popovercontroller) {
       [popovercontroller dismissPopoverAnimated:NO];
      //  [popovercontroller release];
       // popovercontroller = nil;
   }
}


#pragma mark -

-(void)onToolbarClick:(UIButton *)sender	{
    
    if (delegateObject) {
        UITabBarController *controller = ((UITabBarController *)delegateObject);
        switch (sender.tag) {
            case 1 :{
                DetailsViewController *objDetailsViewController = LOCATE(DetailsViewController);
                [objDetailsViewController setRssFeedBLOG:NO];
                showingRSSFeed = !showingRSSFeed;
                //if (controller.selectedIndex == 0) {
                    [controller setSelectedIndex:1];
                //}
//                else if (controller.selectedIndex == 1) {
//                    [controller setSelectedIndex:0];
//                }
                break;}
            case 2 :    {
               //share
                if(showingRSSFeed)
                    return;
                [self showShareList:sender];
                break;
            }
            case 3 : {
                DetailsViewController *objDetailsViewController = LOCATE(DetailsViewController);
                [objDetailsViewController setRssFeedBLOG:YES];
                //if (controller.selectedIndex == 0) {
                    [controller setSelectedIndex:2];
               // }
//                else if (controller.selectedIndex == 1) {
//                    [controller setSelectedIndex:0];
//                }
                break;
            }
            default:
                break;
        } 
    }
}

- (void)onTouchUpiPhoneToolBar:(UIButton*)sender {
    /*
    DLog(@"ToolbarClick : %d",sender.tag);
    
    [[Datastore sharedInstance] setSettingsInstance:nil];
	
	if (sender.tag == 1) { // means goto Bookmarks
 
        [(UINavigationController *)delegateObject.navigationController popToRootViewControllerAnimated:NO];
        [[Datastore sharedInstance] setContentsInstance:nil];
        [[Datastore sharedInstance] setBookMarkInstance:nil];

        
	}
	else if (sender.tag == 2) { // means goto Contents
        
        if (![[Datastore sharedInstance] contentsInstance]) {
            
            ContentsView_iPhone * contents = [[ContentsView_iPhone alloc] initWithNibName:[MessageHandler CONTENTVIEWIPHONENIB] 
                                                                                   bundle:[NSBundle mainBundle]];            
            contents.m_objIssue = [[Datastore sharedInstance] currentIssue];
            [(UINavigationController*)delegateObject.navigationController pushViewController:contents 
                                                                                    animated:NO];            
            [[Datastore sharedInstance] setContentsInstance:contents];
            [contents release];
            contents = nil;

            
        }
        else {
            
            ContentsView_iPhone *contents = (ContentsView_iPhone*)[[Datastore sharedInstance] contentsInstance];
            contents.m_objIssue = [[Datastore sharedInstance] currentIssue];
            [(UINavigationController *)delegateObject.navigationController popToViewController:contents 
                                                                                      animated:NO];
            
            
            [[Datastore sharedInstance] setBookMarkInstance:nil];
            
        }
        
        
	}
	else if (sender.tag == 3) { // means goto Book-mark
            
        if (![[Datastore sharedInstance] bookMarkInstance]) {
            
            bookMark = [[BookMarkView alloc] initWithNibName:@"BookMarkView"
                                                      bundle:[NSBundle mainBundle]];
            [[Datastore sharedInstance] setBookMarkInstance:bookMark];
            
            [(UINavigationController *)delegateObject.navigationController pushViewController:bookMark 
                                                                                     animated:NO];         
            
            [bookMark release];
            
            bookMark = nil;

            
        }
        else
        {
            bookMark = (BookMarkView*)[[Datastore sharedInstance] bookMarkInstance];
                    
            [(UINavigationController *)delegateObject.navigationController popToViewController:bookMark 
                                                                                      animated:NO];
            
            
        }
        
        
	}
    else if (sender.tag == 4) {
        
        SettingsViewController * settings = [[SettingsViewController alloc] initWithNibName:[SettingsViewController getNibName] 
                                                                                     bundle:[NSBundle mainBundle]];        
        [(UINavigationController*)delegateObject.navigationController pushViewController:settings 
                                                                                animated:NO];        
        [[Datastore sharedInstance] setSettingsInstance:settings];
        [settings release];
        settings = nil;
        
    }
    */
//}

#pragma mark -

-(void)dealloc	{


	[super dealloc];
}

@end
