//
//  MWCompassViewContainer.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/20/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWCompassViewContainer.h"

@implementation MWCompassViewContainer

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
    //my mega constraints
    self.compassView.center = CGPointMake(self.width / 2, self.height / 2);
    self.valueCircle.center = CGPointMake( self.width - (self.valueCircle.width / 2) - 10,
                                          (self.valueCircle.height / 2) + 10);
}

-(void) setHeading:(int) heading
{
    self.compassView.direction = heading;
    self.valueCircle.valueLabel.text = @(heading / 10.).stringValue;
}

@end
