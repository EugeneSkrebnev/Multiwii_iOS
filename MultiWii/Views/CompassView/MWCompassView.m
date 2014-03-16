//
//  MWCompassView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/13/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWCompassView.h"

@implementation MWCompassView
{
    BOOL _wasInited;
    UIImageView* _background;
    UIImageView* _arrow;
    UILabel* _angleLabel;
}

-(void) makeInit
{
    if (!_wasInited)
    {
        _wasInited = YES;
        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compass_bg.png"]];
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compass_arrow.png"]];
        _angleLabel = [[UILabel alloc] init];

        self.width = _background.width;
        self.height = _background.height;
        
        _background.center = CGPointMake(self.width / 2, self.height / 2);
        _arrow.center = _background.center;
        
        _angleLabel.width = self.width;
        _angleLabel.height = 50;
        
        [self addSubview:_background];
        [self addSubview:_arrow];
        [self addSubview:_angleLabel];
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

@end
