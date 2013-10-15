//
//  MWSettingValueContainer.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/8/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSettingsEntity.h"

@interface MWSettingValueContainer : UIView

@property (nonatomic, strong) MWSettingsEntity* settingEntity;
@property (nonatomic, strong) UILabel* valueLabel;
@property (nonatomic, strong) UIImageView* backgroundImage;
@property (nonatomic, strong) UIImageView* backgroundActiveImage;
@end
