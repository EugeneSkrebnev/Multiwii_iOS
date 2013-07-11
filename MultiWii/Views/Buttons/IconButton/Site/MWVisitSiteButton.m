//
//  MWVisitSiteButton.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWVisitSiteButton.h"

@implementation MWVisitSiteButton

-(void) makeInit
{
    [super makeInit];
    UIImage* visitSiteIcon = [UIImage imageNamed:@""];
    [self setImage:visitSiteIcon forState:UIControlStateNormal];
}

@end
