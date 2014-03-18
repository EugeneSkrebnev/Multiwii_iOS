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

#import "MWValueSettingsEntity.h"

typedef enum {
    MWGraphicViewTypeRates,
    MWGraphicViewTypeThrottle
} MWGraphicViewType;

@interface MWGraphicView : UIView

@property (nonatomic, assign) MWGraphicViewType graphicType;
@property (nonatomic, strong) MWValueSettingsEntity* entityX;
@property (nonatomic, strong) MWValueSettingsEntity* entityY;
@end
