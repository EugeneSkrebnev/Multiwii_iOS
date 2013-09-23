//
//  MWTopbarButton.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 9/22/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWTopbarButton.h"

@implementation MWTopbarButton


-(void) makeInit
{
    [super makeInit];
    UIImage* buttonImageHighlighted = [UIImage imageNamed:@"top_bar_button_pressed.png"];
    UIImage* buttonImage = [UIImage imageNamed:@"top_bar_button.png"];
    self.width  =  buttonImage.size.width;
    self.height =  buttonImage.size.height;
    [self setBackgroundImage:buttonImageHighlighted forState:UIControlStateHighlighted];
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];

    self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:9];
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
