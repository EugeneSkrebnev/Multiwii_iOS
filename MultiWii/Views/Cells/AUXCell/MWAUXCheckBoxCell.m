//
//  MWAUXCheckBoxCell.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWAUXCheckBoxCell.h"

@implementation MWAUXCheckBoxCell

-(void)makeInit
{
    [super makeInit];
    self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:13];
    self.titleLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient_title-text@2x"]];
}

@end
