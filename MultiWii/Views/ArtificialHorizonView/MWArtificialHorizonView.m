//
//  MWArtificialHorizonView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/13/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWArtificialHorizonView.h"
#import "MWHorizonScaleView.h"

@implementation MWArtificialHorizonView
{
    BOOL _wasInit;
    UIImageView* _background;
    UIView* _scaleViewContainer;
    MWHorizonScaleView* _scaleView;
    UIView* _horizonView; //just orange square
}

-(void) makeInit
{
    if (!_wasInit)
    {
        _wasInit = YES;
        self.autoresizesSubviews = NO;
        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orientation_control_bg.png"]];
        
        self.width = _background.image.size.width;
        self.height = _background.image.size.height;

        _horizonView = [[UIView alloc] initWithFrame:self.bounds];
        _horizonView.center = CGPointMake(self.width / 2, self.height / 2);
        
        [_horizonView addSubview:({
            UIView* orangeSquare = [[UIView alloc] initWithFrame:self.bounds];
            orangeSquare.backgroundColor = RGB(255, 64, 0);
            orangeSquare.transform = CGAffineTransformMakeTranslation(0, self.height / 2);
            orangeSquare;
        })];
        
        UIView* horizonViewBack = [[UIView alloc] initWithFrame:self.bounds];
        horizonViewBack.backgroundColor = RGB(26, 26, 26);

        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        _scaleView = [[MWHorizonScaleView alloc] init];
        _scaleView.center = CGPointMake(self.width / 2, self.height / 2);
        _scaleViewContainer = [[UIView alloc] initWithFrame:self.bounds];
        [_scaleViewContainer addSubview:_horizonView];
        [_scaleViewContainer addSubview:_scaleView];
        
        
        [self addSubview:horizonViewBack];
//        [self addSubview:_horizonView];
        [self addSubview:_scaleViewContainer];
        [self addSubview:_background];
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

-(void)setPitch:(int)pitch
{
    _pitch = pitch;
    _scaleView.value = pitch;
//    self.roll = M_PI_4;
    _scaleView.transform = [_scaleView transformForPitch:pitch / 10.];
    _horizonView.transform = _scaleView.transform;
}

-(void)setRoll:(int)roll
{
    _roll = roll;
    _scaleViewContainer.transform = CGAffineTransformMakeRotation(roll / 10. * (M_PI / 180));
}
@end
