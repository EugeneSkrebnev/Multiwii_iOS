//
//  MWBuyButton.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWInAppButton.h"

@implementation MWInAppButton


-(void) makeInit
{
    [super makeInit];
    UIImage* buyFullVersionIcon = [UIImage imageNamed:@"buy.png"];
    [self setImage:buyFullVersionIcon forState:UIControlStateNormal];
    UIImage* hg = [self backgroundImageForState:UIControlStateHighlighted];
    UIImage* norm = [self backgroundImageForState:UIControlStateNormal];
    
    [self setBackgroundImage:hg forState:(UIControlStateNormal)];
    [self setBackgroundImage:norm forState:(UIControlStateHighlighted)];
    [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
}

-(void)setCostInBucks:(int)costInBucks
{
    _costInBucks = costInBucks;
    [self setTitle:[NSString stringWithFormat:@"BUY FOR $%d", _costInBucks] forState:(UIControlStateNormal)];
}

@end
