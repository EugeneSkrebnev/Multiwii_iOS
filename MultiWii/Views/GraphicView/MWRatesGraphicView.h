//
//  MWRatesGraphicView.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/15/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWSettingsEntity.h"

@interface MWRatesGraphicView : UIView
@property (nonatomic, strong) MWSettingsEntity* rcExpo;
@property (nonatomic, strong) MWSettingsEntity* rcRate;
@end
