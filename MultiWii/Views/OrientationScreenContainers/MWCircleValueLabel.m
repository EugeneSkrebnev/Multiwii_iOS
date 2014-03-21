//
//  MWCircleValueLabel.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/20/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWCircleValueLabel.h"

@implementation MWCircleValueLabel
{
    BOOL _wasInited;
    UIImageView* _backgroundCircle;
    UILabel* _valueLabel;
}

-(void) makeInit
{
    if (!_wasInited)
    {
        _backgroundCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circleOrientation.png"]];
        self.backgroundColor = [UIColor clearColor];
        self.width = _backgroundCircle.width;
        self.height = _backgroundCircle.height;
        

        [self addSubview:_backgroundCircle];
        [self addSubview:({
            int valueLabelH = 30;
            _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.height - valueLabelH) / 2, self.width, valueLabelH)];
            _valueLabel.backgroundColor = [UIColor clearColor];
            _valueLabel.textColor = RGB(132, 132, 132);
            _valueLabel.text = @"155.0";
            _valueLabel.textAlignment = NSTextAlignmentCenter;
            _valueLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:16];
            _valueLabel;
        })];

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

-(UILabel *)valueLabel
{
    return _valueLabel;
}

@end
