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

-(void)viewDidLoad
{
    [super viewDidLoad];
    if (self.navigationController)
    {
        if (self.navigationController.navigationBar)
        {
            UIImage* barImage = [UIImage imageNamed:@"top_bar.png"];
            [self.navigationController.navigationBar setBackgroundImage:barImage forBarMetrics:(UIBarMetricsDefault)];

            NSArray* fnt = @[@"Montserrat-Bold",
                             @"Montserrat-Regular",
                             @"MontserratAlternates-Bold",
                             @"MontserratAlternates-Regular",
                             @"MontserratSubrayada-Bold",
                             @"MontserratSubrayada-Regular"];
//
//            for (int i = 0; i < 6; i++)
//            {
//                UIFont* f = [UIFont fontWithName:fnt[i] size:12];
//                NSLog(@"%@", f);
//            }
            
            
            [[UINavigationBar appearance] setTitleTextAttributes:@{
                                        UITextAttributeTextColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient_title-text.png"]],
                                  UITextAttributeTextShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
                                 UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                             UITextAttributeFont: [UIFont fontWithName:fnt[0] size:17],
             }];
//            [[[self navigationController] navigationBar] setNeedsLayout];
        }
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern.png"]];
        
    }
}

@end
