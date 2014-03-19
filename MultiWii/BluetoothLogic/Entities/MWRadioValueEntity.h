//
//  MWRadioValueEntity.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/19/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWAbstractSettingEntity.h"

@interface MWRadioValueEntity : MWAbstractSettingEntity

@property (nonatomic, assign) int value;
-(void) setValueLowBits:(int) lo andHigh:(int) hi;

@end
