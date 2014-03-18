//
//  MWSliderView.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWValueSettingsEntity.h"
@interface MWSliderView : UISlider

@property (nonatomic, strong) MWValueSettingsEntity* settingsEntity;

@end
