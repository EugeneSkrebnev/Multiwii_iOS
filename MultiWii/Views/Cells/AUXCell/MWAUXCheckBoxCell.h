//
//  MWAUXCheckBoxCell.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseTableViewCell.h"
#import "MACheckBox.h"
#import "MWBoxAuxSettingEntity.h"

@interface MWAUXCheckBoxCell : MWBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MACheckBox *checkBox1;
@property (weak, nonatomic) IBOutlet MACheckBox *checkBox2;
@property (weak, nonatomic) IBOutlet MACheckBox *checkBox3;

@property (nonatomic, strong) MWBoxAuxSettingEntity* data;
@property (nonatomic, assign) int selectedAuxChannel;

@property (strong, nonatomic) IBOutletCollection(MACheckBox) NSArray *checkBoxes;
@end
