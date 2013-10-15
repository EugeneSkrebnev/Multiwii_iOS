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
    self.rcRate = [MWGlobalManager sharedInstance].pidManager.RCRates.rcRate;
    self.rcExpo = [MWGlobalManager sharedInstance].pidManager.RCRates.rcExpo;
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
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    UIBezierPath* ratePath = [self bezierLineForSettings];
    [ratePath setLineWidth:3.0];
    [ratePath setLineJoinStyle:kCGLineJoinBevel];
    [ratePath fill];
    [ratePath stroke];
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsDisplay];
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
    
}

@end
