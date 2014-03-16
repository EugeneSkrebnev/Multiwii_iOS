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

        [self addSubview:({
            _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compass_bg.png"]];
            _background.center = CGPointMake(self.width / 2, self.height / 2);
            _background;
        })];
        
        self.width = _background.width;
        self.height = _background.height;

        [self addSubview:({
            _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compass_arrow.png"]];
            _arrow.center = _background.center;
            _arrow;
        })];
        
        [self addSubview:({
            _angleLabel = [[UILabel alloc] init];
            _angleLabel.width = self.width;
            _angleLabel.height = 50;
            _angleLabel.textAlignment = NSTextAlignmentCenter;
            _angleLabel.backgroundColor = [UIColor clearColor];
            _angleLabel.text = @"155";
            _angleLabel.shadowOffset = CGSizeMake(0, 1);
            _angleLabel.shadowColor = [UIColor whiteColor];
            _angleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:11];
            _angleLabel.center = CGPointMake(self.width / 2, self.height / 2);
            _angleLabel;
        })];
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

-(void)setDirection:(double)direction
{
    _direction = direction;
    _arrow.transform = CGAffineTransformMakeRotation(direction * (M_PI / 180));
    _angleLabel.text = [NSString stringWithFormat:@"%.1f", direction];
}
@end
