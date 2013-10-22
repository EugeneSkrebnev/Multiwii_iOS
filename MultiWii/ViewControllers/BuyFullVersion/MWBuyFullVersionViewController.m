//
//  MWBuyFullVersionViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/20/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBuyFullVersionViewController.h"
#import "MWTopbarButton.h"

@interface MWBuyFullVersionViewController ()

@end

@implementation MWBuyFullVersionViewController

-(void) createBackBtn
{
    MWTopbarButton* backButton = [[MWTopbarButton alloc] init];


    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:(UIControlEventTouchUpInside)];
    [backButton setTitle:@"BACK" forState:(UIControlStateNormal)];
    
//    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, readTopButton.width + writeTopButton.width + spaceBetweenbtns, readTopButton.height)];
//    [container addSubview:readTopButton];
//    writeTopButton.left = readTopButton.width + spaceBetweenbtns;
//    [container addSubview:writeTopButton];
    UIBarButtonItem* rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationBar.topItem.rightBarButtonItem = rightBarBtnItem;
}

-(void) setControllerView
{
    self.view.backgroundColor = [UIColor blackColor];
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, 2, 0)];
    UIView* blackDim = [[UIView alloc] initWithFrame:bgView.bounds];
    blackDim.backgroundColor = [UIColor blackColor];
    blackDim.alpha = 0.;
    [bgView addSubview:blackDim];
    //        bgView.height -= 47;
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern_100.png"]];
    [self.view insertSubview:bgView atIndex:0];
    UIImage* barImage = [UIImage imageNamed:@"top_bar.png"];
    [self.navigationBar setBackgroundImage:barImage forBarMetrics:(UIBarMetricsDefault)];
}

-(void) setBuyBtns
{
    self.buy5.costInBucks = 5;
    self.buy7.costInBucks = 7;
    self.buy10.costInBucks = 10;
    [self.restoreBtn setTitle:@"RESTORE PURCHASE" forState:(UIControlStateNormal)];
    UIImage* imgH = [self.restoreBtn backgroundImageForState:(UIControlStateHighlighted)];
    [self.restoreBtn setBackgroundImage:[self.restoreBtn backgroundImageForState:(UIControlStateNormal)] forState:(UIControlStateHighlighted)];
    [self.restoreBtn setBackgroundImage:imgH forState:(UIControlStateNormal)];
    UIImage* restoreIcon = [UIImage imageNamed:@"buy.png"];
    [self.restoreBtn setImage:restoreIcon forState:(UIControlStateNormal)];
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setControllerView];
    [self createBackBtn];
    [self setBuyBtns];
    
    self.navigationBar.topItem.titleView = [self viewForTitle: @"BUY FULL VERSION"];
    self.aboutTextView.font = [UIFont fontWithName:@"Montserrat-Regular" size:14];
    self.aboutTextView.scrollEnabled = NO;
//    UIImage* patternColorForUnselectedMenuItem = [UIImage imageNamed:@"gradient_menu-text.png"]; // stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//    self.aboutTextView.textColor = [UIColor colorWithPatternImage:patternColorForUnselectedMenuItem];
    self.aboutTextView.textColor = [UIColor grayColor];
    self.aboutTextView.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.aboutTextView.layer.shadowOffset = CGSizeMake(1.f, 1.0f);
    self.aboutTextView.layer.shadowOpacity = .0f;
    self.aboutTextView.layer.shadowRadius = .0f;
    
    if (!IS_IOS7)
    {
        self.navigationBar.top -= 20;
        self.aboutTextView.top -= 20;
    }
    
}

-(void) backButtonTapped:(id) sender
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
