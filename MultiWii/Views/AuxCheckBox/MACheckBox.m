//
//  MACheckBox.m
//  testanimation
//
//  Created by Eugene Skrebnev on 7/4/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MACheckBox.h"

@implementation MACheckBox
{
    BOOL wasInited;
}

-(void) makeInit
{
    if (!wasInited)
    {
        wasInited = YES;
        
        UIImage* selectedImage = [UIImage imageNamed:@"aux_check.png"];
        UIImage* unSelectedImage = [UIImage imageNamed:@"aux_uncheck.png"];
        
        self.width = selectedImage.size.width;
        self.height = selectedImage.size.height;
        
        [self setImage:selectedImage forState:(UIControlStateSelected)];
        [self setImage:unSelectedImage forState:(UIControlStateNormal)];
        [self addTarget:self action:@selector(tapped) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

-(void) tapped
{
    self.selected = !self.selected;
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
