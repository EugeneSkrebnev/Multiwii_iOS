//
//  MWSplashView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/1/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWSplashView.h"

@implementation MWSplashView

static BOOL wasInited = NO;
-(void) makeInit
{
    if (!wasInited)
    {
        
        wasInited = YES;
        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
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


@end
