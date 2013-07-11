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
    UIImage* buyFullVersionIcon = [UIImage imageNamed:@""];
    [self setImage:buyFullVersionIcon forState:UIControlStateNormal];
}

@end
