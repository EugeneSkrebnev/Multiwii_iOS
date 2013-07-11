//
//  MWIconBaseButton.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWIconBaseButton.h"

@implementation MWIconBaseButton

-(void) makeInit
{
    [super makeInit];
    UIImage* buttonImageHighlighted = [UIImage imageNamed:@"icon_button.png"];
    UIImage* buttonImage = [UIImage imageNamed:@"icon_button.png"];
    self.width  =  buttonImage.size.width;
    self.height =  buttonImage.size.height;
    [self setBackgroundImage:buttonImageHighlighted forState:UIControlStateHighlighted];
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
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
