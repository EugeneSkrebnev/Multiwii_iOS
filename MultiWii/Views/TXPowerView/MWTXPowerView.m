//
//  MWTXPowerView.m
//  MultiWii
//
//  Created by Evgeniy Skrebnev on 7/11/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWTXPowerView.h"

@implementation MWTXPowerView {
    BOOL _wasInited;
    UIImageView *_txMask;
    UIView *_backView;
}

-(void) makeInit
{
    if (!_wasInited)
    {
        _wasInited = YES;
        self.slider = [[UISlider alloc] init];
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = RGB(233, 61, 8);
        
        _txMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"transmitter_power"]];
        [self addSubview:_backView];
        [self addSubview:_txMask];
        [self addSubview:self.slider];
        
        self.slider.minimumValue = 0;
        self.slider.maximumValue = 4;
        self.slider.value = 1;
        [self.slider setThumbImage:[UIImage imageNamed:@"slider_tab.png"] forState:UIControlStateNormal];

        [self.slider setThumbImage:[UIImage imageNamed:@"slider_tab.png"] forState:UIControlStateHighlighted];
        [self.slider setMinimumTrackImage:[[UIImage imageNamed:@"slider_minimum.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0] forState:UIControlStateNormal];
        [self.slider setMaximumTrackImage:[[UIImage imageNamed:@"slider_maximum.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0] forState:UIControlStateNormal];
        [[self.slider rac_signalForControlEvents:(UIControlEventValueChanged)] subscribeNext:^(UISlider* sli) {
            CGFloat steps = 4;
            sli.value = MAX((roundf(sli.value/sli.maximumValue*steps)*sli.maximumValue/steps), 1);
            _backView.right = MIN(sli.value * 54, 214);
        }];

        @weakify(self);
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.width.equalTo(self).offset(9);
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(-9);
        }];
        
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.width.equalTo(@215);
            make.height.equalTo(@45);
            make.top.equalTo(_txMask);
        }];

        [_txMask mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.width.equalTo(@215);
            make.top.equalTo(self);
            make.left.equalTo(self);
        }];
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
