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
    UIImage* buyFullVersionIcon = [UIImage imageNamed:@"buck.png"];
    [self setImage:buyFullVersionIcon forState:UIControlStateNormal];
    self.orangeButton = YES;
}

-(void)setCostInBucks:(int)costInBucks
{
    _costInBucks = costInBucks;
    [self setTitle:[NSString stringWithFormat:@"BUY FOR $%d", _costInBucks] forState:(UIControlStateNormal)];
}

@end
