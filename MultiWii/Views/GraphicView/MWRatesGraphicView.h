//
//  MWRatesGraphicView.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/15/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWValueSettingsEntity.h"

@interface MWRatesGraphicView : UIView
@property (nonatomic, strong) MWValueSettingsEntity* rcExpo; //x
@property (nonatomic, strong) MWValueSettingsEntity* rcRate; //y
@end
