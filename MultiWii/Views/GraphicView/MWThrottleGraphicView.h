//
//  MWThrottleGraphicView.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/15/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSettingsEntity.h"

@interface MWThrottleGraphicView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong) MWSettingsEntity* thrMid; //x
@property (nonatomic, strong) MWSettingsEntity* thrExpo; //y

@end
