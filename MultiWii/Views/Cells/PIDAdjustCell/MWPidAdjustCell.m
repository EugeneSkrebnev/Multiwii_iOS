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


-(void)setPid:(MWPIDSettingsEntity *)pid
{
    _pid = pid;
    
    if (pid.p)
        self.leftKnobContainerView.settingEntity = pid.p;
    else
        self.leftKnobContainerView.hidden = YES;
    
    if (pid.i)
        self.middleKnobContainerView.settingEntity = pid.i;
    else
        self.middleKnobContainerView.hidden = YES;
    
    if (pid.d)
        self.rightKnobContainerView.settingEntity = pid.d;
    else
        self.rightKnobContainerView.hidden = YES;
    
}

@end
