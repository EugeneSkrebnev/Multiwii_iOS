//
//  MAKnobContainerLabeledView.h
//  testanimation
//
//  Created by Eugene Skrebnev on 7/4/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAKnobView.h"
#import "MWValueSettingsEntity.h"
@interface MAKnobContainerLabeledView : UIView

@property (nonatomic, strong) MAKnobView* knobView;
@property (nonatomic, strong) MWValueSettingsEntity* settingEntity;
@end
