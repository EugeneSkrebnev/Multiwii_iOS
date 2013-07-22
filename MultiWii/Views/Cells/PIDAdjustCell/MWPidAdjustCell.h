//
//  MWPidAdjustCell.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseTableViewCell.h"
#import "MAKnobContainerLabeledView.h"
#import "MWPIDSettingsEntity.h"
@interface MWPidAdjustCell : MWBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet MAKnobContainerLabeledView *leftKnobContainerView;
@property (weak, nonatomic) IBOutlet MAKnobContainerLabeledView *middleKnobContainerView;
@property (weak, nonatomic) IBOutlet MAKnobContainerLabeledView *rightKnobContainerView;

@property (nonatomic, strong) MWPIDSettingsEntity* pid;
@end
