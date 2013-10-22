//
//  MWRadarActivityIndicator.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/22/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWRadarActivityIndicator.h"

@implementation MWRadarActivityIndicator
{
    BOOL _wasInited;
    UIImageView* _radar;
    UIImageView* _backgroundRadar;
}

-(void) makeInit
{
    if (!_wasInited)
    {
        _wasInited = YES;
        _radar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radar.png"]];
        _backgroundRadar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radar_bg.png"]];
        self.width = _backgroundRadar.width;
        self.height = _backgroundRadar.height;
        _backgroundRadar.center = CGPointMake(self.width / 2, self.height / 2);
        _radar.center = _backgroundRadar.center;
        [self addSubview:_backgroundRadar];
        [self addSubview:_radar];

        self.spinSpeed = 2;
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

-(void) startSpin
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotation.duration = self.spinSpeed; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [_radar.layer addAnimation:rotation forKey:@"Spin"];
}

-(void) stopSpin
{
    [_radar.layer removeAnimationForKey:@"Spin"];
}

@end
