//
//  MWOrientationViewContainer.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/20/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWOrientationViewContainer.h"

@implementation MWOrientationViewContainer

-(void) makeInit
{
    self.backgroundColor = [UIColor clearColor];
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

-(void)layoutSubviews
{
    self.horizonView.center = CGPointMake(self.width / 2, self.height / 2);
    
    
    self.rollIconView.left = 10;
    self.rollIconView.top = 10;
    self.rollLabel.center = CGPointMake(self.rollIconView.center.x, self.rollIconView.center.y + self.rollIconView.height / 2 + 15);
    self.rollLabel.textColor = [UIColor whiteColor];
    self.rollLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:12];
    self.rollLabel.textAlignment = NSTextAlignmentCenter;
    self.rollValueLabel.textAlignment = NSTextAlignmentLeft;
    self.rollValueLabel.center = CGPointMake(self.rollIconView.center.x + 50, self.rollIconView.center.y - 20);
    self.rollValueLabel.textColor = [UIColor whiteColor];
    self.rollValueLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:12];
    
    self.pitchIconView.left = self.width - self.pitchIconView.width - 10;
    self.pitchIconView.top = 10;
    self.pitchLabel.center = CGPointMake(self.pitchIconView.center.x, self.pitchIconView.center.y + self.pitchIconView.height / 2 + 15);
    self.pitchLabel.textColor = [UIColor whiteColor];
    self.pitchLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:12];
    self.pitchLabel.textAlignment = NSTextAlignmentCenter;
    self.pitchValueLabel.textAlignment = NSTextAlignmentRight;
    self.pitchValueLabel.center = CGPointMake(self.pitchIconView.center.x - 50, self.pitchIconView.center.y - 20);
    self.pitchValueLabel.textColor = [UIColor whiteColor];
    self.pitchValueLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:12];
}

-(void) setRoll  : (int) roll
{
    [self.horizonView setRoll:roll];
    self.rollValueLabel.text = @(roll / 10.).stringValue;
}

-(void) setPitch : (int) pitch
{
    [self.horizonView setPitch:pitch];
    self.pitchValueLabel.text = @(pitch / 10.).stringValue;
}

@end
