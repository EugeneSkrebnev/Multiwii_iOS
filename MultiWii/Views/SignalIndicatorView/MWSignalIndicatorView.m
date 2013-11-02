//
//  MWSignalIndicatorView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/31/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWSignalIndicatorView.h"

@implementation MWSignalIndicatorView
{
    BOOL _wasInited;
    UIImageView* _backgroundImageView;
    UIImageView* _redsectorImageView;
    UIView* _dimView;
    UIView* _redView;
    UIImageView* _arrow;
    UIImageView* _arrowCircle;
    UILabel* _percentLabels[5];
}

-(void) makeInit
{
    UIImage* backgroud = [UIImage imageNamed:@"finder_mask.png"];
    self.width = backgroud.size.width-4;
    self.height = backgroud.size.height;

    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    _backgroundImageView = [[UIImageView alloc] initWithImage:backgroud];
    _backgroundImageView.frame = CGRectInset(self.bounds, -2, 0);

    int redSectorYoffset = 25;
    _redView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - redSectorYoffset, self.width, redSectorYoffset)];
    _redView.backgroundColor = RGB(255, 53, 0);
    
    _redsectorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finder_sector.png"]];
    _redsectorImageView.frame = CGRectMake((self.width - _redsectorImageView.width) / 2, self.height - (_redsectorImageView.height / 2) - redSectorYoffset, _redsectorImageView.width, _redsectorImageView.height);

    _dimView = [[UIView alloc] initWithFrame:self.bounds];
    _dimView.alpha = 0.2;
    _dimView.backgroundColor = [UIColor blackColor];
    
    _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finder_arrow.png"]];
    _arrowCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finder_circle.png"]];
    
    _arrowCircle.center = _redsectorImageView.center;
    _arrow.center = _redsectorImageView.center;
    
    [self addSubview:_dimView];
    [self addSubview:_redsectorImageView];
    [self addSubview:_redView];
    [self addSubview:_backgroundImageView];
    [self addSubview:_arrowCircle];
    [self addSubview:_arrow];
    
    CGPoint labelsCenter[5];
    labelsCenter[0].x = 40;
    labelsCenter[0].y = 120;
    
    labelsCenter[1].x = 70;
    labelsCenter[1].y = 40;

    labelsCenter[2].x = 160;
    labelsCenter[2].y = 8;

    labelsCenter[3].x = 320 - 70;
    labelsCenter[3].y = 40;

    labelsCenter[4].x = 320 - 40 + 5;
    labelsCenter[4].y = 120;
    
    
    
    for (int i = 0; i < 5; i++)
    {
        _percentLabels[i] = [[UILabel alloc] init];
        _percentLabels[i].width = 40;
        _percentLabels[i].height = 30;
        _percentLabels[i].text = @(i * 25).stringValue;
        _percentLabels[i].center = labelsCenter[i];
        _percentLabels[i].backgroundColor = [UIColor clearColor];
        _percentLabels[i].textAlignment = UITextAlignmentCenter;
        _percentLabels[i].font = [UIFont fontWithName:@"Montserrat-Regular" size:18];
        _percentLabels[i].textColor = RGB(165, 165, 165);
        [self addSubview:_percentLabels[i]];
        
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

-(void)setValue:(float)value
{
    if (value < 0)
        value = 0;
    if (value > 1)
        value = 1;
    
    _value = value;
    _redsectorImageView.transform = CGAffineTransformMakeRotation(M_PI * self.value - M_PI);
    _arrow.transform = CGAffineTransformMakeRotation(M_PI * self.value);
}

-(void)setValue:(float)value animated:(BOOL)animated
{
    [self setValue:value animated:animated duration:0.3];
}

-(void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval) duration
{
    if (animated)
    {
        [UIView animateWithDuration:duration animations:^{
            [self setValue:value];
        }];
    }
    else
        [self setValue:value];
   
}
@end
