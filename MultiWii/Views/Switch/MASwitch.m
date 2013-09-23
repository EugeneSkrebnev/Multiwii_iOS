//
//  MASwitch.m
//  testanimation
//
//  Created by Eugene Skrebnev on 7/2/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MASwitch.h"

#define SLIDER_CAP_TOP 32
#define SLIDER_CAP_BOTTOM 30

@implementation MASwitch
{
    UIImageView* _backgroundLocked;
    UIImageView* _backgroundUnlocked;
    UIImageView* _slider;
    UIImageView* _lockIcon;
    float _sliderPosition;
    float _sliderTransitionalPosition;
    float _distanceBetweenStartFinish;
    CGPoint _startPoint;
    CGPoint _finishPoint;
    BOOL wasInited;
}



-(CGPoint) sliderPointForPosition:(float) position //[0..1]
{
    CGPoint startPoint = CGPointMake(self.width / 2, SLIDER_CAP_TOP);
    CGPoint finishPoint = CGPointMake(self.width / 2, self.height - SLIDER_CAP_BOTTOM);
    
    CGPoint result = CGPointMake(startPoint.x, startPoint.y + (position * (finishPoint.y - startPoint.y)));
    
    return result;
}

-(void) setBackgroundForPosition:(float) position //[0..1]
{
    _backgroundUnlocked.alpha = position;
    _backgroundLocked.alpha = 1 - position;
}

-(void) setLockIconForPosition:(float) position //[0..1]
{
    if (position < 0.5)
        _lockIcon.image = [UIImage imageNamed:@"unlocked_icon.png"];
    else
        _lockIcon.image = [UIImage imageNamed:@"locked_icon.png"];
}

-(void) setSliderPosition:(float) sliderPosition
{
    _sliderPosition = sliderPosition;
    _slider.center = [self sliderPointForPosition:sliderPosition];
    [self setBackgroundForPosition:sliderPosition];
    [self setLockIconForPosition:sliderPosition];
}

//-(void)setNeedsLayout
//{
//    [super setNeedsLayout];
//    _startPoint = [self sliderPointForPosition:0];
//    _finishPoint = [self sliderPointForPosition:1];
//
//    
//}

-(void)setScale:(float)scale
{
    _scale = scale;
    self.transform = CGAffineTransformMakeScale(scale, scale);
}

-(void) makeInit
{
    if (!wasInited)
    {
        wasInited = YES;
        self.scale = 0.8;
        self.backgroundColor = [UIColor clearColor];
        
        UIImage* backUnlock = [UIImage imageNamed:@"switch_unlocked.png"];
        UIImage* backLock = [UIImage imageNamed:@"switch_locked.png"];
        UIImage* slider = [UIImage imageNamed:@"slider.png"];
        
        self.width = backUnlock.size.width;
        self.height = backUnlock.size.height;
        
        _backgroundUnlocked = [[UIImageView alloc] initWithImage:backUnlock];
        [self addSubview:_backgroundUnlocked];
        
        _backgroundLocked = [[UIImageView alloc] initWithImage:backLock];
        [self addSubview:_backgroundLocked];
        
        _slider = [[UIImageView alloc] initWithImage:slider];
        _lockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48 / 2, 44 / 2)];
        
        [self setSliderPosition:0];
        [self addSubview:_slider];
        
        _lockIcon.center = CGPointMake(_slider.width / 2, _slider.height / 2);
        [_slider addSubview:_lockIcon];
        _startPoint = [self sliderPointForPosition:0];
        _finishPoint = [self sliderPointForPosition:1];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGesture.delegate = self;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGesture.numberOfTapsRequired = 1;
        [_slider addGestureRecognizer:tapGesture];
//        self.userInteractionEnabled = YES;
//        _backgroundLocked.userInteractionEnabled = YES;
//        _backgroundUnlocked.userInteractionEnabled = YES;
//        _slider.userInteractionEnabled = YES;
        _distanceBetweenStartFinish = [self distanceFromPoint:[self sliderPointForPosition:0] toPoint:[self sliderPointForPosition:1]];
        
        [_slider addGestureRecognizer:panGesture];
        _slider.userInteractionEnabled = YES;

    }
}

-(float) distanceFromPoint:(CGPoint) p1 toPoint:(CGPoint) p2
{
    float xDist = (p2.x - p1.x);
    float yDist = (p2.y - p1.y);
    float distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    if (_sliderPosition > 0.5)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self setSliderPosition:0];
        }]; 
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self setSliderPosition:1];
        }];
    }
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:_slider];
        CGPoint newPoint = CGPointMake(_slider.center.x, _slider.center.y + translation.y);
        if (newPoint.y > _finishPoint.y)
            newPoint.y = _finishPoint.y;
        if (newPoint.y < _startPoint.y)
            newPoint.y = _startPoint.y;
        
        float sliderState = [self distanceFromPoint:newPoint toPoint:_startPoint] / _distanceBetweenStartFinish;
        [self setSliderPosition:sliderState];

        [recognizer setTranslation:CGPointMake(0, 0) inView:_slider];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self fixSliderState];
    }
}

-(void) fixSliderState
{
    if (_sliderPosition < 0.5)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self setSliderPosition:0];
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self setSliderPosition:1];
        }];
    }
}

-(BOOL)locked
{
    return _sliderPosition > 0.5;
}
-(void)setLocked:(BOOL)locked
{
    if (locked)
        [self setSliderPosition:1];
    else
        [self setSliderPosition:0];
        
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
