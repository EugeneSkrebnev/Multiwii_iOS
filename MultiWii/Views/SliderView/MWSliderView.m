//
//  MWSliderView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWSliderView.h"

@implementation MWSliderView
{
    BOOL _wasInit;
}

-(void) makeInit
{
    if (!_wasInit)
    {
        _wasInit = YES;
        [self addTarget:self action:@selector(valueChanged) forControlEvents:(UIControlEventValueChanged)];
        [self addTarget:self action:@selector(valueDidChanged) forControlEvents:((UIControlEventTouchUpInside | UIControlEventTouchUpOutside))];
        [self setThumbImage:[UIImage imageNamed:@"slider_tab.png"] forState:UIControlStateNormal];
//        [self setThumbImage:[UIImage imageNamed:@"slider_tab_active.png"] forState:UIControlStateHighlighted];
        [self setThumbImage:[UIImage imageNamed:@"slider_tab.png"] forState:UIControlStateHighlighted];
        [self setMinimumTrackImage:[[UIImage imageNamed:@"slider_minimum.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0] forState:UIControlStateNormal];
        [self setMaximumTrackImage:[[UIImage imageNamed:@"slider_maximum.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0] forState:UIControlStateNormal];

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

    [UIView animateWithDuration:.3 animations:^{
        if ((IOS_VER - 5) < 0.01)
            [self setValue:_settingsEntity.value animated:NO];
        else
            [self setValue:_settingsEntity.value animated:YES];
    }];

}

-(void)setSettingsEntity:(MWValueSettingsEntity *)associatedSettingValue
{
    if (_settingsEntity)
    {
        [_settingsEntity removeObserver:self forKeyPath:@"value"];
    }
    _settingsEntity = associatedSettingValue;
    
    self.minimumValue = _settingsEntity.minValue;
    self.maximumValue = _settingsEntity.maxValue;
    if (_settingsEntity)
    {
        [_settingsEntity addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
    }
    
}

-(void) valueChanged
{
//    float newStep = roundf((self.value) / _associatedSettingValue.step);
//    // Convert "steps" back to the context of the sliders values.
//    self.questionSlider.value = newStep * _associatedSettingValue.step;
    
    [_settingsEntity setValueWithoutKVO:self.value];
}

-(void) valueDidChanged
{
    //    float newStep = roundf((self.value) / _associatedSettingValue.step);
    //    // Convert "steps" back to the context of the sliders values.
    //    self.questionSlider.value = newStep * _associatedSettingValue.step;
    
    [_settingsEntity setValueWithoutKVO:self.value withStepping:YES];
}
//-(void)setValue:(float)value
//{
//    [super setValue:value];
//}

-(void)dealloc
{
    if (_settingsEntity)
    {
        [_settingsEntity removeObserver:self forKeyPath:@"value"];
    }
}

@end
