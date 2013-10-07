//
//  MWRateAdjustCell.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseTableViewCell.h"
#import "MAKnobContainerLabeledView.h"

@interface MWRateAdjustCell : MWBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *knobTitlesLabels;
@property (strong, nonatomic) IBOutletCollection(MAKnobContainerLabeledView) NSArray *knobContainers;
@property (nonatomic, strong) NSArray* knobEntities;
@end
