//
//  MWSettingsEntity.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWSettingsEntity.h"

@implementation MWSettingsEntity
@synthesize value = _value;

-(void)setValue:(float)value
{
    float step = self.step;
    if (step < 0.000001)
        step = 0.000001;
    if (!(fabsf(value - self.value) < (step / 5)))
    {
        [self willChangeValueForKey:@"value"];
        _value = value;
        [self didChangeValueForKey:@"value"];
    }
}

-(void) setValueWithoutNotification:(float)value
{
    _value = value;
}


-(void)setValueWithoutKVO:(float)value
{
    [self setValueWithoutKVO:value withStepping:NO];
}

-(void)setValueWithoutKVO:(float)value withStepping:(BOOL) stepping
{
    float step = self.step;
    if (step < 0.000001)
        step = 0.000001;
    if (stepping)
    {
        float newStep = roundf((value) / self.step);
        value = newStep * self.step;
    }

    if ((!(fabsf(value - self.value) < (step / 5)))/*||(stepping)*/)
    {
        [self willChangeValueForKey:@"value"];
        _value = value;
        [self didChangeValueForKey:@"value"];
    }
}
@end
