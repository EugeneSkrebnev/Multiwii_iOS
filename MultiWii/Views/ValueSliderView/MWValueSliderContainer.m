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
        _valueSlider = [[MWValueSliderView alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
        _nameLabel   = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
        _valueLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
        [self addSubview:_nameLabel];
        [self addSubview:_valueSlider];
        [self addSubview:_valueLabel];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    double nameLabelWidthProportion  = 134. / 630;
    double valueLabelWidthProportion = 116. / 630;
    double sliderProportion          = 380. / 630;
    int capBetweenElem = 2;
    double totalWidth = self.width - 2. * capBetweenElem;
    
    int nameLabelWidth  = nameLabelWidthProportion  * totalWidth;
    int valueLabelWidth = valueLabelWidthProportion * totalWidth;
    int sliderWidth     = sliderProportion          * totalWidth;
    
    _nameLabel.left  = 0;
    _nameLabel.width = nameLabelWidth;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:12];
//    _nameLabel.text = [@[@"roll", @"pithc", @"yaw", @"throt"][rand() % 4] uppercaseString];
    
    _valueSlider.left  = _nameLabel.left + _nameLabel.width + capBetweenElem;
    _valueSlider.width = sliderWidth;

    _valueLabel.left  = _valueSlider.left + _valueSlider.width + capBetweenElem;
    _valueLabel.width = valueLabelWidth;
//    _valueLabel.text = @(rand() % 1000 + 1000).stringValue;
    _valueLabel.textAlignment = NSTextAlignmentRight;
    _valueLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:12];
    _valueLabel.textColor = RGB(164, 164, 164);
    
    self.backgroundColor = [UIColor clearColor];
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
    _valueLabel.text = @(_settingEntity.value).stringValue;
    _nameLabel.text = _settingEntity.name;
}

-(void)setSettingEntity:(MWRadioValueEntity *)settingEntity
{
    if (_settingEntity)
    {
        [_settingEntity removeObserver:self forKeyPath:@"value"];
        [_settingEntity removeObserver:self forKeyPath:@"name"];
    }

    _settingEntity = settingEntity;
    _valueSlider.settingEntity = settingEntity;
    
    if (_settingEntity)
    {
        [_settingEntity addObserver:self forKeyPath:@"value" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
        [_settingEntity addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
    }
}

-(void)dealloc
{
    if (_settingEntity)
    {
        [_settingEntity removeObserver:self forKeyPath:@"value"];
        [_settingEntity removeObserver:self forKeyPath:@"name"];
    }
}

@end
