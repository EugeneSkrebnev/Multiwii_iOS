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
    self.webView.delegate = self;
    [self hideGradientBackground:self.webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (!request.URL.path)
        return YES;

    if ([request.URL.path isEqualToString:@"/pub/eugene-skrebnev/49/b03/598"])
    {
        [Flurry logEvent:@"Open LinkedIn Eugene Skrebnev"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.linkedin.com/pub/eugene-skrebnev/49/b03/598"]];
    }
    
    if ([request.URL.path isEqualToString:@"/profile/view"])
    {
        [Flurry logEvent:@"Open LinkedIn Olga Ladnova"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://goo.gl/pTDiVU"]];
    }
    
    if ([request.URL.path isEqualToString:@"/forum/viewtopic.php"])
    {
        [Flurry logEvent:@"Open Multiwii forum page"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.multiwii.com/forum/viewtopic.php?f=8&t=3584"]];
    }
    if ([request.URL.path isEqualToString:@"/www.multiwiiforios.com/main"])
    {
        [Flurry logEvent:@"Open Multiwiiforios site"];                
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.multiwiiforios.com"]];
    }
    
    return NO;
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
