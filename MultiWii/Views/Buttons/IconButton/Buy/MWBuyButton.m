//
//  MWBuyButton.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBuyButton.h"

@implementation MWBuyButton


-(void) makeInit
{
    [super makeInit];
    UIImage* buyFullVersionIcon = [UIImage imageNamed:@"buy.png"];
    [self setImage:buyFullVersionIcon forState:UIControlStateNormal];
    [self setTitle:@"GET FULL VERSION" forState:UIControlStateNormal];
    UIImage* hg = [self backgroundImageForState:UIControlStateHighlighted];
    UIImage* norm = [self backgroundImageForState:UIControlStateNormal];
    
    [self setBackgroundImage:hg forState:(UIControlStateNormal)];
    [self setBackgroundImage:norm forState:(UIControlStateHighlighted)];
    [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

}

@end
