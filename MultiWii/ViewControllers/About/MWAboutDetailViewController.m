//
//  MWAboutDetailViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/28/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWAboutDetailViewController.h"

@interface MWAboutDetailViewController ()

@end

@implementation MWAboutDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.


    [self.webView loadHTMLString:self.text baseURL:nil];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    [self hideGradientBackground:self.webView];
}

- (void) hideGradientBackground:(UIView*)theView
{
    for (UIView * subview in theView.subviews)
    {
        if ([subview isKindOfClass:[UIImageView class]])
            subview.hidden = YES;
        
        [self hideGradientBackground:subview];
    }
}

@end
