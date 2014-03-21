//
//  MWCircleIconValueView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/20/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWCircleIconValueView.h"

@implementation MWCircleIconValueView
{
    BOOL _wasInited;
    UIImageView* _backgroundCircle;
    UIImageView* _iconView;
}
#define ICON_IMAGE_SCALE 0.7
-(void) makeInit
{
    if (!_wasInited)
    {
        _backgroundCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circleOrientation.png"]];
        
        self.width = _backgroundCircle.width;
        self.height = _backgroundCircle.height;
        
        if (self.tag == 0) //nobody care
            _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_roll.png"]];
        else
            _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_pitch.png"]];
        _iconView.center = CGPointMake(self.width / 2, self.height / 2);

        _iconView.transform = CGAffineTransformMakeScale(ICON_IMAGE_SCALE, ICON_IMAGE_SCALE);


        [self addSubview:_backgroundCircle];
        [self addSubview:_iconView];
        self.backgroundColor = [UIColor clearColor];
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

-(void)setValue:(int)value
{
    _value = value;
    _iconView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(value / 10. * (M_PI / 180)), ICON_IMAGE_SCALE, ICON_IMAGE_SCALE);
}

@end
