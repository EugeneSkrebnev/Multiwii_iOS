//
//  MWValueSliderContainer.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/17/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWValueSliderContainer.h"
#import "MWValueSliderView.h"

@implementation MWValueSliderContainer
{
    BOOL _wasInit;
    UILabel* _nameLabel;
    UILabel* _valueLabel;
    MWValueSliderView* _valueSlider;
}

-(void) makeInit
{
    if (!_wasInit)
    {
        _wasInit = YES;
        _valueSlider = [[MWValueSliderView alloc] init];
        _nameLabel   = [[UILabel alloc] init];
        _valueLabel  = [[UILabel alloc] init];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    double nameLabelWidthProportion  = 134 / 630;
    double valueLabelWidthProportion = 116 / 630;
    double sliderProportion          = 380 / 630;
    int capBetweenElem = 8;
    double totalWidth = self.width - 2. * capBetweenElem;
    
    int nameLabelWidth  = nameLabelWidthProportion  * totalWidth;
    int valueLabelWidth = valueLabelWidthProportion * totalWidth;
    int sliderWidth     = sliderProportion          * totalWidth;
    
    _nameLabel.left  = 0;
    _nameLabel.width = nameLabelWidth;
    
    _valueSlider.left  = _nameLabel.left + _nameLabel.width + capBetweenElem;
    _valueSlider.width = sliderWidth;
    
    _valueLabel.left  = _valueSlider.left + _valueSlider.width + capBetweenElem;
    _valueLabel.width = valueLabelWidth;
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

@end
