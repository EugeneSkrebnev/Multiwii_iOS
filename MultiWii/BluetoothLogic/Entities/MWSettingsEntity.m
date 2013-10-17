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


-(BOOL) willChangeValueToValue:(float) newValue
{
    float step = self.step;
    if (step < 0.000001)
        step = 0.000001;
    return !((fabsf(newValue - self.value) < (step / 5)));
}

-(void)setValue:(float)value
{
    if (value > self.maxValue)
        value = self.maxValue;
    if (value < self.minValue)
        value = self.minValue;
    

    if ([self willChangeValueToValue:value])
    {
        [self willChangeValueForKey:@"value"];
        [self willChangeValueForKey:@"saved"];
        _value = value;
        [self didChangeValueForKey:@"saved"];
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
    if (stepping)
    {
        float newStep = roundf((value) / self.step);
        value = newStep * self.step;
    }

    if ([self willChangeValueToValue:value])
    {
        [self willChangeValueForKey:@"value"];
        [self willChangeValueForKey:@"saved"];
        _value = value;
        [self didChangeValueForKey:@"saved"];
        [self didChangeValueForKey:@"value"];
    }
}

-(BOOL)saved
{
    return ![self willChangeValueToValue:self.savedValue];
}

-(void)setSaved:(BOOL)saved
{
    self.savedValue = self.value;
}

-(void)setSavedValue:(float)savedValue
{
    BOOL willChangeSavedParam = [self willChangeValueToValue:_savedValue];
    if (willChangeSavedParam)
        [self willChangeValueForKey:@"saved"];
    _savedValue = savedValue;
    if (willChangeSavedParam)
        [self didChangeValueForKey:@"saved"];

}
@end
