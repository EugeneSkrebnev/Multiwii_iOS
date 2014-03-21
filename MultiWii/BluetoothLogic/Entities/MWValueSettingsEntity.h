//
//  MWSettingsEntity.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWSaveableSettingEntity.h"
@interface MWValueSettingsEntity : MWSaveableSettingEntity
@property (nonatomic, assign)  BOOL   enabled;
@property (nonatomic, assign)  float  minValue;
@property (nonatomic, assign)  float  maxValue;
@property (nonatomic, assign)  float  step;
@property (nonatomic, assign)  float  value;

@property (nonatomic, assign)  float  savedValue;


-(void) setValueWithoutNotification:(float)value;
-(void)setValueWithoutKVO:(float)value;
-(void)setValueWithoutKVO:(float)value withStepping:(BOOL) stepping;
-(BOOL) willChangeValueToValue:(float) newValue;

-(BOOL)isEqual:(MWValueSettingsEntity*)object;

@end