//
//  MACheckBox.m
//  testanimation
//
//  Created by Eugene Skrebnev on 7/4/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MACheckBox.h"

@implementation MACheckBox

static BOOL wasInited = NO;

-(void) makeInit
{
    if (!wasInited)
    {
        wasInited = YES;
        
        UIImage* selectedImage = [UIImage imageNamed:@"aux_check.png"];
        UIImage* unSelectedImage = [UIImage imageNamed:@"aux_check.png"];
        
        self.width = selectedImage.size.width;
        self.height = selectedImage.size.height;
        
        [self setImage:selectedImage forState:(UIControlStateSelected)];
        [self setImage:unSelectedImage forState:(UIControlStateNormal)];
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
