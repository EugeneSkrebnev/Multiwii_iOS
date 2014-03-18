//
//  MAKnobContainerLabeledView.m
//  testanimation
//
//  Created by Eugene Skrebnev on 7/4/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MAKnobContainerLabeledView.h"
@interface MAKnobContainerLabeledView(private)
@property (nonatomic, strong) UILabel* valueLabel;

@end

@implementation MAKnobContainerLabeledView
{
    BOOL wasInited;
    UILabel* _valueLabel;
    UILabel* _valueLabelSelected;
}

-(void)setValueLabel:(UILabel *)valueLabel
{
    _valueLabel = valueLabel;
}

-(UILabel *)valueLabel
{
    return _valueLabel;
}

-(UILabel*) newLabel
{
    UILabel* newLabel;
    newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - self.knobView.height)];
    newLabel.backgroundColor = [UIColor clearColor];
    newLabel.textAlignment = NSTextAlignmentCenter;
    newLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:14];
    return newLabel;
}

-(void) makeInit
{
    if (!wasInited)
    {
        wasInited = YES;
        self.height = 96;
        self.width = 90;
        self.knobView = [[MAKnobView alloc] init];
        self.knobView.center = CGPointMake(self.width / 2, self.height - self.knobView.height / 2);
        [self addSubview:self.knobView];

        self.valueLabel = [self newLabel];
        UIImage* patternColorForUnselectedMenuItem = [UIImage imageNamed:@"gradient_menu-text.png"]; // stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        self.valueLabel.textColor = [UIColor colorWithPatternImage:patternColorForUnselectedMenuItem];
        [self addSubview:self.valueLabel];

        _valueLabelSelected = [self newLabel];
        _valueLabelSelected.textColor = [UIColor colorWithRed:255./255 green:71./255 blue:0./255 alpha:1];
        _valueLabelSelected.hidden = YES;
        [self addSubview:_valueLabelSelected];
        
        [self.knobView addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
        self.backgroundColor = [UIColor clearColor];
//        self.knobView.backgroundColor = [UIColor redColor];
        [self valueChanged:nil];
    }
}

-(void) valueChanged:(id) sender
{
    int digitStep = 0;
    float fraq = self.knobView.step - (int)self.knobView.step;
    while (fraq > 0.000001)
    {
        fraq *= 10;
        fraq = fraq - roundf(fraq);
        digitStep++;
    }
    
    NSString* format = [NSString stringWithFormat:@"%@.%df", @"%", digitStep];
    self.valueLabel.text = [NSString stringWithFormat:format, self.knobView.value];
    _valueLabelSelected.text = self.valueLabel.text;

    [self updateSavedState];
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

-(void) updateSavedState
{
    MAKnobContainerLabeledView* weakSelf = self;
    if (_settingEntity)
    {
        if (_settingEntity.saved)
        {
            [self bringSubviewToFront:_valueLabelSelected];
            weakSelf.valueLabel.alpha = 1;
            [_valueLabelSelected setHidden:YES animated:YES duration:0.4];

//            UIImage* patternColorForUnselectedMenuItem = [UIImage imageNamed:@"gradient_menu-text.png"]; // stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//            self.valueLabel.textColor = [UIColor colorWithPatternImage:patternColorForUnselectedMenuItem];
        }
        else
        {

                [self bringSubviewToFront:_valueLabel];
                _valueLabelSelected.hidden = NO;

                [UIView animateWithDuration:0.4 animations:^{
                    weakSelf.valueLabel.alpha = 0;
                }];




//            self.valueLabel.textColor =  [UIColor colorWithRed:255./255 green:71./255 blue:0./255 alpha:1];
        }
        
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self updateSavedState];
}

-(void)setSettingEntity:(MWValueSettingsEntity *)settingEntity
{
    if (_settingEntity)
    {
        [_settingEntity removeObserver:self forKeyPath:@"saved"];
    }
    _settingEntity = settingEntity;
    self.knobView.settingEntity = settingEntity;
    if (_settingEntity)
    {
        [_settingEntity addObserver:self forKeyPath:@"saved" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
    }
}

-(void)dealloc
{
    if (_settingEntity)
    {
        [_settingEntity removeObserver:self forKeyPath:@"saved"];
    }
}
@end
