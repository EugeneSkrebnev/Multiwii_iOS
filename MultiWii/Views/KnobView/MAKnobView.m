//
//  MAKnob.m
//  testanimation
//
//  Created by Eugene Skrebnev on 7/4/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MAKnobView.h"
#define HANDLE_OVERLAP 22
@implementation MAKnobView
{
    float _internalValue;
    float _internalMax;
    float _internalMin;
    BOOL wasInited;
}



-(void)setSpinCount:(float)spinCount
{
    _spinCount = spinCount;
    _internalMin = 0;
    _internalMax = spinCount * 360;
}

-(void) makeInit
{
    if (!wasInited)
    {
        wasInited = YES;
        UIImage* knob = [UIImage imageNamed:@"knob.png"];
        UIImage* knobActive = [UIImage imageNamed:@"knob_active.png"];
        UIImage* knobHandle = [UIImage imageNamed:@"knob_handle.png"];
        
        self.width  = 90;
        self.height = 80;
        

        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        _knobView = [[UIImageView alloc] initWithImage:knob];
        _knobViewSelected = [[UIImageView alloc] initWithImage:knobActive];
        _knobHandleView = [[UIImageView alloc] initWithImage:knobHandle];
        
        
        _knobView.center = CGPointMake(_backgroundView.width / 2, _backgroundView.height / 2);
        _knobViewSelected.center = CGPointMake(_backgroundView.width / 2, _backgroundView.height / 2);
        _knobViewSelected.alpha = 0;
        
        _knobHandleView.center = CGPointMake(_backgroundView.width / 2, _backgroundView.height / 2 - _knobView.height / 2 - _knobHandleView.height / 2 + HANDLE_OVERLAP);
        
        
        
        
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGesture.delegate = self;
        UILongPressGestureRecognizer *tapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGesture.numberOfTouchesRequired = 1;
        tapGesture.minimumPressDuration = 0;
        
        [self addSubview:_backgroundView];
        [_backgroundView addSubview:_knobView];
        [_backgroundView addSubview:_knobViewSelected];
        [_backgroundView addSubview:_knobHandleView];
        
        
        [_backgroundView addGestureRecognizer:panGesture];
        [_backgroundView addGestureRecognizer:tapGesture];
        
        self.animateOnActivate = YES;
        
        
        //default settings
        self.step = 0.1;
        self.minValue = 0;
        self.maxValue = 10;
        self.spinCount = 2;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void) setActive:(BOOL)active
{
    _active = active;
    NSTimeInterval animateDuration = 0;
    
    if (self.animateOnActivate)
        animateDuration = 0.3;
    
    [UIView animateWithDuration:animateDuration animations:^{
        if (active)
        {
            _knobViewSelected.alpha = 0.7;
        }
        else
        {
            _knobViewSelected.alpha = 0;
        }
    }];
}

-(float)internalValue
{
    return _internalValue;
}

- (void)handleTap:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.active = YES;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        self.active = NO;
    }
}

-(float) mapValue:(float) value inputMin:(float) inMin inputMax:(float) inMax outputMin:(float) outMin outputMax:(float) outMax
{
    return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

-(void) setTransformForInternalValue
{
    _backgroundView.transform = CGAffineTransformMakeRotation(_internalValue / 180. * M_PI);
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    UIView* viewForTranslation;
    if (self.controlType == MAKnobControlTypePanSpin)
        viewForTranslation = recognizer.view;
    else
        viewForTranslation = self.superview;
    
    CGPoint offset = [recognizer translationInView:viewForTranslation];

    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint currentTranslationNew = _currentTranslation;
        if (self.controlType == MAKnobControlTypePanX || self.controlType == MAKnobControlTypePanXY || self.controlType == MAKnobControlTypePanSpin)
            currentTranslationNew.x += offset.x;
        
        if (self.controlType == MAKnobControlTypePanY || self.controlType == MAKnobControlTypePanXY || self.controlType == MAKnobControlTypePanSpin)
            currentTranslationNew.y += offset.y;
        
        
        float internalValueNew = currentTranslationNew.x + currentTranslationNew.y + _savedTranslation.x + _savedTranslation.y;
        if ((internalValueNew <= _internalMax) && (internalValueNew >= _internalMin))
        {
            [self setInternalValue:internalValueNew];
            _currentTranslation = currentTranslationNew;
        }


        [self setTransformForInternalValue];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        _savedTranslation.x += _currentTranslation.x;
        _savedTranslation.y += _currentTranslation.y;
        _currentTranslation = CGPointMake(0, 0);
        [self setInternalValue:_currentTranslation.x + _currentTranslation.y + _savedTranslation.x + _savedTranslation.y ];
        [self finishValueChanging];
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:viewForTranslation];
}

-(void)setValue:(float)value
{
    [self willChangeValueForKey:@"value"];
    _value = value;
    [self didChangeValueForKey:@"value"];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void) mapValueFromInternal
{
    self.value = [self mapValue:_internalValue
                       inputMin:_internalMin
                       inputMax:_internalMax
                      outputMin:self.minValue
                      outputMax:self.maxValue];
}

-(void) setInternalValue:(float) internalVal
{
    _internalValue = internalVal;
    [self mapValueFromInternal];
    if (self.discreteChanging)
    {
        float newValueStepping = roundf(self.value / self.step) * self.step;
        
        _internalValue = [self mapValue:newValueStepping
                               inputMin:self.minValue
                               inputMax:self.maxValue
                              outputMin:_internalMin
                              outputMax:_internalMax];
    }
    [self mapValueFromInternal];
    
}

-(void) finishValueChanging
{
    float newValueStepping = roundf(self.value / self.step) * self.step;
    
    _internalValue = [self mapValue:newValueStepping
                           inputMin:self.minValue
                           inputMax:self.maxValue
                          outputMin:_internalMin
                          outputMax:_internalMax];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setTransformForInternalValue];
    }];
    [self mapValueFromInternal];

    
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
