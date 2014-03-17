//
//  MWValueSliderView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/17/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWValueSliderView.h"

@implementation MWValueSliderView
{
    BOOL _wasInit;
}

-(void) makeInit
{
    if (!_wasInit)
    {
        _wasInit = YES;
        [self setMinimumTrackImage:[[UIImage imageNamed:@"values_horizontal_orange.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0] forState:UIControlStateNormal];
        [self setMaximumTrackImage:[[UIImage imageNamed:@"values_horizontal_gray.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0] forState:UIControlStateNormal];
        [self setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
        [self setThumbImage:[[UIImage alloc] init] forState:UIControlStateHighlighted];
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
