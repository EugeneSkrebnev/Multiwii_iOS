//
//  MWGraphicView.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/8/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWRatesGraphicView.h"
#import "MWThrottleGraphicView.h"

#import "MWSettingsEntity.h"

typedef enum {
    MWGraphicViewTypeRates,
    MWGraphicViewTypeThrottle
} MWGraphicViewType;

@interface MWGraphicView : UIView

@property (nonatomic, assign) MWGraphicViewType graphicType;
@property (nonatomic, strong) MWSettingsEntity* entityX;
@property (nonatomic, strong) MWSettingsEntity* entityY;
@end
