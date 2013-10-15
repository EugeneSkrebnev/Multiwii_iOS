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
}

-(void) makeInit
{
    if (!_wasInited)
    {
        _wasInited = YES;
        [self addSubview:[[MWRatesGraphicView alloc] initWithFrame:self.bounds]];
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
