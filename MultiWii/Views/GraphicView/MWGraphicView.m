//
//  MWGraphicView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/8/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWGraphicView.h"

@implementation MWGraphicView
{
    BOOL _wasInited;
    MWRatesGraphicView* _ratesView;
    MWThrottleGraphicView* _throttleView;
}

-(void) makeInit
{
    if (!_wasInited)
    {
        _wasInited = YES;
        self.graphicType = MWGraphicViewTypeRates;
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

-(void)setGraphicType:(MWGraphicViewType)graphicType
{
    if (graphicType == MWGraphicViewTypeRates)
    {
        [_throttleView removeFromSuperview];
        _throttleView = nil;
        if (!_ratesView)
            _ratesView = [[MWRatesGraphicView alloc] initWithFrame:self.bounds];
        [self addSubview:_ratesView];
        _ratesView.rcExpo = self.entityX;
        _ratesView.rcRate = self.entityY;
    }
    else
    {
        [_ratesView removeFromSuperview];            
        _ratesView = nil;
        if (!_throttleView)
            _throttleView = [[MWThrottleGraphicView alloc] initWithFrame:self.bounds];
        [self addSubview:_throttleView];
        _throttleView.thrMid = self.entityX;
        _throttleView.thrExpo = self.entityY;
    }
}

-(void)setEntityX:(MWSettingsEntity *)entityX
{
    _entityX = entityX;
    if (self.graphicType == MWGraphicViewTypeThrottle)
    {
        _throttleView.thrMid = entityX;
    }
    else
    {
        _ratesView.rcExpo = entityX;
    }
}

-(void)setEntityY:(MWSettingsEntity *)entityY
{
    _entityY = entityY;
    if (self.graphicType == MWGraphicViewTypeThrottle)
    {
        _throttleView.thrExpo = entityY;
    }
    else
    {
        _ratesView.rcRate = entityY;
    }
}
@end
