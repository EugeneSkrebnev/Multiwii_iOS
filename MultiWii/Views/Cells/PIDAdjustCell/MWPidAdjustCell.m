//
//  MWPidAdjustCell.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWPidAdjustCell.h"

@implementation MWPidAdjustCell


-(void) makeInit
{
    self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:12];
    self.titleLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient_title-text@2x"]];
}

@end
