//
//  MWBaseViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseViewController.h"

@interface MWBaseViewController ()

@end

@implementation MWBaseViewController

@synthesize viewControllerTitle = _viewControllerTitle;

-(void)viewDidLoad
{
    [super viewDidLoad];
    if ([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) {
        [(UIViewController*)self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    if (self.navigationController)
    {
        if (self.navigationController.navigationBar)
        {
            UIImage* barImage = [UIImage imageNamed:@"top_bar.png"];
            [self.navigationController.navigationBar setBackgroundImage:barImage forBarMetrics:(UIBarMetricsDefault)];

//            NSArray* fnt = @[@"Montserrat-Bold",
//                             @"Montserrat-Regular",
//                             @"MontserratAlternates-Bold",
//                             @"MontserratAlternates-Regular",
//                             @"MontserratSubrayada-Bold",
//                             @"MontserratSubrayada-Regular"];
//
//            for (int i = 0; i < 6; i++)
//            {
//                UIFont* f = [UIFont fontWithName:fnt[i] size:12];
//                NSLog(@"%@", f);
//            }
            
            
//            [[UINavigationBar appearance] setTitleTextAttributes:@{
//                                        UITextAttributeTextColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient_title-text.png"]],
//                                  UITextAttributeTextShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
//                                 UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
//                                             UITextAttributeFont: [UIFont fontWithName:fnt[0] size:15],
//             }];
//            [[[self navigationController] navigationBar] setNeedsLayout];
            
            if (self.navigationController.viewControllers.count > 1)
            {
                UIImage *buttonImage = [UIImage imageNamed:@"back_button.png"];
                UIImage *buttonImagePressed = [UIImage imageNamed:@"back_button_press.png"];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                
                [button setImage:buttonImage forState:UIControlStateNormal];
                [button setImage:buttonImagePressed forState:(UIControlStateHighlighted)];
                
                button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
                
                [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
                
                UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
                
                self.navigationItem.leftBarButtonItem = customBarItem;
            }
        }
        
        self.view.backgroundColor = [UIColor blackColor];
        UIView* bgView = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, 2, 0)];
        UIView* blackDim = [[UIView alloc] initWithFrame:bgView.bounds];
        blackDim.backgroundColor = [UIColor blackColor];
        blackDim.alpha = 0.;
        [bgView addSubview:blackDim];
//        bgView.height -= 47;
        bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern_100.png"]];
        [self.view insertSubview:bgView atIndex:0];

        
    }
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setViewControllerTitle:(NSString *)viewControllerTitle
{
    _viewControllerTitle = viewControllerTitle;
    UIView* containerTitleView = [[UIView alloc] init];
    UIImageView* leftDash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_element.png"]];
    UIImageView* rightDash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_element.png"]];
    leftDash.width = 13;
    rightDash.width = 13;
    UILabel* lbl = [[UILabel alloc] init];
    lbl.text = viewControllerTitle;
    lbl.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient_title-text.png"]];
    lbl.font = [UIFont fontWithName:@"Montserrat-Bold" size:16];
    [lbl sizeToFit];
    lbl.backgroundColor = [UIColor clearColor];
    containerTitleView.width = lbl.width + leftDash.width + rightDash.width;
    containerTitleView.height = lbl.height;
    
    leftDash.left = 0;
    rightDash.left = containerTitleView.width - rightDash.width;
    leftDash.top = (lbl.height - leftDash.height) / 2;
    rightDash.top = leftDash.top;
    lbl.left = leftDash.width;
    
    [containerTitleView addSubview:leftDash];
    [containerTitleView addSubview:rightDash];
    [containerTitleView addSubview:lbl];
    self.navigationItem.titleView = containerTitleView;
}

@end
