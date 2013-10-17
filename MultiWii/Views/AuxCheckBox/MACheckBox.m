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
    UIImageView* _savedFrameImageView;
}

-(void) makeInit
{
    if (!wasInited)
    {
        wasInited = YES;
        _savedFrameImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _savedFrameImageView.image = [UIImage imageNamed:@"aux_border.png"];
        _savedFrameImageView.hidden = YES;
        [self addSubview:_savedFrameImageView];
        
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

-(void)setSaved:(BOOL)saved
{
    _saved = saved;
    [_savedFrameImageView setHidden:_saved animated:YES duration:0.5];
}
@end
