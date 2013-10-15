//
//  MWSettingsEntity.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWSettingsEntity : NSObject
@property (nonatomic, assign)  BOOL   enabled;
@property (nonatomic, assign)  float  minValue;
@property (nonatomic, assign)  float  maxValue;
@property (nonatomic, assign)  float  step;
@property (nonatomic, assign)  float  value;
@property (nonatomic, assign)  BOOL  saved;

-(void) setValueWithoutNotification:(float)value;
-(void)setValueWithoutKVO:(float)value;
-(void)setValueWithoutKVO:(float)value withStepping:(BOOL) stepping;
-(BOOL) willChangeValueToValue:(float) newValue;
@end
