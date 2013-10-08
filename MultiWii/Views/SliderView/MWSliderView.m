//
//  MWSliderView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWSliderView.h"

@implementation MWSliderView


-(void) makeInit
{
    if (self.tag == 0)
    {
        self.tag = 1;
        [self addTarget:self action:@selector(valueChanged) forControlEvents:(UIControlEventValueChanged)];
        
        [self setThumbImage:[UIImage imageNamed:@"slider_tab.png"] forState:UIControlStateNormal];
        [self setThumbImage:[UIImage imageNamed:@"slider_tab.png"] forState:UIControlStateHighlighted];
        [self setMinimumTrackImage:[UIImage imageNamed:@"slider_minimum.png"] forState:UIControlStateNormal];
        [self setMaximumTrackImage:[UIImage imageNamed:@"slider_maximum.png"] forState:UIControlStateNormal];
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self makeInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self makeInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self makeInit];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    if (fabs(self.value - _associatedSettingValue.value) < (_associatedSettingValue.step / 5))
    self.value = _associatedSettingValue.value;
}

-(void)setAssociatedSettingValue:(MWSettingsEntity *)associatedSettingValue
{
    _associatedSettingValue = associatedSettingValue;
    
    self.minimumValue = _associatedSettingValue.minValue;
    self.maximumValue = _associatedSettingValue.maxValue;

    [_associatedSettingValue addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void) valueChanged
{
//    float newStep = roundf((self.value) / _associatedSettingValue.step);
//    // Convert "steps" back to the context of the sliders values.
//    self.questionSlider.value = newStep * _associatedSettingValue.step;
    
    [_associatedSettingValue setValueWithoutKVO:self.value];
}

@end
