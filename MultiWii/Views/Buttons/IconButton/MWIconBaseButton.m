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
    UIImage* buttonImageHighlighted = [UIImage imageNamed:@"icon_button_pressed.png"];
    UIImage* buttonImage = [UIImage imageNamed:@"icon_button.png"];
    self.width  =  buttonImage.size.width;
    self.height =  buttonImage.size.height;
    [self setBackgroundImage:buttonImageHighlighted forState:UIControlStateHighlighted];
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
    self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:16];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
