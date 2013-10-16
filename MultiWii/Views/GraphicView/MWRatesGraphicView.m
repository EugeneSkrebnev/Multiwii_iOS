//
//  MWRatesGraphicView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/15/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWRatesGraphicView.h"

@implementation MWRatesGraphicView
{
    UIPanGestureRecognizer *_panGesture;
    BOOL _wasInited;
}

-(void) makeInit
{
    if (!_wasInited)
    {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:_panGesture];
        
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
    CGPoint x2 = CGPointMake(1, self.rcRate.value);
    
    CGPoint vectorStartPoint = CGPointMake(x2.x / 2, x2.y / 2);
    CGPoint vectorFinishPoint = CGPointMake(1, 0);
    CGPoint vector = CGPointMake(vectorFinishPoint.x - vectorStartPoint.x, vectorFinishPoint.y - vectorStartPoint.y);
    
    CGPoint controlPoint = CGPointMake(vectorStartPoint.x + (self.rcExpo.value * vector.x),
                                       vectorStartPoint.y + (self.rcExpo.value * vector.y));
    
    UIBezierPath* bezierLine = [[UIBezierPath alloc] init];
    [bezierLine moveToPoint:[self normalizePoint:x0]];
    [bezierLine addQuadCurveToPoint:[self normalizePoint:x2] controlPoint:[self normalizePoint:controlPoint]];
    return bezierLine;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:29./255 green:217./255 blue:50./255 alpha:1].CGColor);
    
    UIBezierPath* ratePath = [self bezierLineForSettings];
    [ratePath setLineWidth:3.0];
    [ratePath setLineJoinStyle:kCGLineJoinBevel];
    [ratePath fill];
    [ratePath stroke];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsDisplay];
}

-(void)setRcExpo:(MWSettingsEntity *)rcExpo
{
    if (_rcExpo)
    {
        [_rcExpo removeObserver:self forKeyPath:@"value"];
    }

    _rcExpo = rcExpo;
    
    if (_rcExpo)
    {
        [_rcExpo addObserver:self forKeyPath:@"value" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) context:nil];
    }

}

-(void)setRcRate:(MWSettingsEntity *)rcRate
{
    if (_rcRate)
    {
        [_rcRate removeObserver:self forKeyPath:@"value"];
    }

    _rcRate = rcRate;

    if (_rcRate)
    {
        [_rcRate addObserver:self forKeyPath:@"value" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) context:nil];
    }
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    UIView* viewForTranslation = recognizer.view;
    
    CGPoint translation = [recognizer translationInView:viewForTranslation];
    translation.y = -translation.y;
    

    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        float dRcExpo = (translation.x / self.width) * self.rcExpo.maxValue;
        float dRcRate = (translation.y / self.height) * self.rcRate.maxValue / 3;
        
        if ([self.rcExpo willChangeValueToValue:self.rcExpo.value + dRcExpo])
        {
            translation.x = 0;
            [recognizer setTranslation:CGPointMake(0, translation.y) inView:viewForTranslation];
            self.rcExpo.value = self.rcExpo.value + dRcExpo;
        }

        if ([self.rcRate willChangeValueToValue:self.rcRate.value + dRcRate])
        {
            [recognizer setTranslation:CGPointMake(translation.x, 0) inView:viewForTranslation];
            self.rcRate.value = self.rcRate.value + dRcRate;
        }
    }
}

-(void)dealloc
{
    if (_rcRate)
    {
        [_rcRate removeObserver:self forKeyPath:@"value"];
    }
    if (_rcExpo)
    {
        [_rcExpo removeObserver:self forKeyPath:@"value"];
    }
}

@end
