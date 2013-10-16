//
//  MWThrottleGraphicView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/15/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWThrottleGraphicView.h"

@implementation MWThrottleGraphicView
{
    UIPanGestureRecognizer* _panGesture;
    UIRotationGestureRecognizer* _rotateGesture;
    UIImageView* _middlePointView;
    CGPoint _midPoint;
    BOOL _wasInited;
}

-(void) makeInit
{
    if (!_wasInited)
    {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _panGesture.minimumNumberOfTouches = 1;
        _panGesture.maximumNumberOfTouches = 2;
        _panGesture.delegate = self;
        [self addGestureRecognizer:_panGesture];

        
        _rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
        _rotateGesture.delegate = self;
        [self addGestureRecognizer:_rotateGesture];
        _middlePointView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 11)];
        _middlePointView.image = [UIImage imageNamed:@"point.png"];
        [self addSubview:_middlePointView];
        _middlePointView.hidden = YES;
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

-(CGPoint) normalizePoint:(CGPoint) inputPoint
{
    //    y = -y
    //    map [0..1] to [0 .. width and height]
    return CGPointMake(inputPoint.x * self.width, self.height - (inputPoint.y * self.height));
}

-(UIBezierPath*) bezierLineForSettings
{
    CGPoint x0 = CGPointMake(0, 0);
    CGPoint x2 = CGPointMake(1, 1);
    
    CGPoint midPoint = CGPointMake((x2.x - x0.x) * self.thrMid.value, (x2.y - x0.y) * self.thrMid.value);
    
//    float midpointWidth = MIN(midPoint.x, x2.x - midPoint.x);
//    float dExpo = midpointWidth * self.thrExpo.value;
    
//    CGPoint controlPoint1 = CGPointMake(midPoint.x - dExpo, midPoint.y);
//    CGPoint controlPoint2 = CGPointMake(midPoint.x + dExpo, midPoint.y);
    CGPoint controlPoint1 = CGPointMake(midPoint.x - midPoint.x * self.thrExpo.value, midPoint.y);
    CGPoint controlPoint2 = CGPointMake(midPoint.x + (1-midPoint.x) * self.thrExpo.value, midPoint.y);
    
    UIBezierPath* bezierLine = [[UIBezierPath alloc] init];
    
    [bezierLine moveToPoint:[self normalizePoint:x0]];
    _midPoint = [self normalizePoint:midPoint];
//    [bezierLine addCurveToPoint:[self normalizePoint:x2] controlPoint1:[self normalizePoint:controlPoint1] controlPoint2:[self normalizePoint:controlPoint2]];
    [bezierLine addQuadCurveToPoint:[self normalizePoint:midPoint] controlPoint:[self normalizePoint:controlPoint1]];
    [bezierLine addQuadCurveToPoint:[self normalizePoint:x2] controlPoint:[self normalizePoint:controlPoint2]];
    return bezierLine;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:28./255 green:152./255 blue:253./255 alpha:1].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    UIBezierPath* ratePath = [self bezierLineForSettings];
    [ratePath setLineWidth:3.0];
    [ratePath setLineJoinStyle:kCGLineJoinBevel];
    [ratePath fill];
    [ratePath stroke];
    
    _middlePointView.center = _midPoint;
    _middlePointView.hidden = NO;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsDisplay];
}

-(void)setThrExpo:(MWSettingsEntity *)thrExpo
{
    if (_thrExpo)
    {
        [_thrExpo removeObserver:self forKeyPath:@"value"];
    }
    
    _thrExpo = thrExpo;
    
    if (_thrExpo)
    {
        [_thrExpo addObserver:self forKeyPath:@"value" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) context:nil];
    }
    
}

-(void)setThrMid:(MWSettingsEntity *)thrMid
{
    if (_thrMid)
    {
        [_thrMid removeObserver:self forKeyPath:@"value"];
    }
    
    _thrMid = thrMid;
    
    if (_thrMid)
    {
        [_thrMid addObserver:self forKeyPath:@"value" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) context:nil];
    }
}

-(void)dealloc
{
    if (_thrMid)
    {
        [_thrMid removeObserver:self forKeyPath:@"value"];
    }
    if (_thrExpo)
    {
        [_thrExpo removeObserver:self forKeyPath:@"value"];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleRotate:(UIRotationGestureRecognizer*)recognizer
{
    float rotation = recognizer.rotation;

    float dThrExpo = (rotation / M_PI) * self.thrExpo.maxValue * 3;
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        if ([self.thrExpo willChangeValueToValue:self.thrExpo.value + dThrExpo])
        {
            recognizer.rotation = 0;
            self.thrExpo.value = self.thrExpo.value + dThrExpo;
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    UIView* viewForTranslation = recognizer.view;
    
    CGPoint translation = [recognizer translationInView:viewForTranslation];
//    translation.y = -translation.y;
    
    
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        float dThrMid = (translation.x / self.width) * self.thrMid.maxValue;
//        float dThrExpo = (translation.y / self.height) * self.thrExpo.maxValue;
        
        if ([self.thrMid willChangeValueToValue:self.thrMid.value + dThrMid])
        {
            translation.x = 0;
            [recognizer setTranslation:CGPointMake(0, translation.y) inView:viewForTranslation];
            self.thrMid.value = self.thrMid.value + dThrMid;
        }
        

    }
}

@end
