//
//  MWHeader3LabelView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWHeader3LabelView.h"

@implementation MWHeader3LabelView
{
    int _labelWidth;
    int _capFromLeft;
}

-(void) calculateSizes
{
    int width = self.width - self.leftCap;
    for (int x = 0; x < 20; x++) //20 too much but nobody care
    {
        int y = (width - (2 * x)) / 3;
        if ((2 * x) + (3 * y) == width)
        {
            _labelWidth = y;
            _capFromLeft = x;
            break;
        }
    }
}

-(void) initLabel:(UILabel*) lbl
{
    lbl.textAlignment = NSTextAlignmentCenter;// UITextAlignmentCenter;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont fontWithName:@"Montserrat-Bold" size:13];
    UIImage* patternColorForUnselectedMenuItem = [UIImage imageNamed:@"gradient_menu-text@2x.png"];// stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    lbl.textColor = [UIColor colorWithPatternImage:patternColorForUnselectedMenuItem];


    [self addSubview:lbl];    
}

-(void) makeInit
{
    [self calculateSizes];
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern_100.png"]];
    
    NSMutableArray* labels = [NSMutableArray arrayWithCapacity:3];
    NSArray* defaultTitles = @[@"LOW", @"MIDDLE", @"HIGH"];
    for (int i = 0; i < 3; i++)
    {
        UILabel* lbl = [[UILabel alloc] init];
        lbl.text = defaultTitles[i];
        
        [labels addObject:lbl];
        lbl.frame = CGRectMake(self.leftCap + _capFromLeft + (i * _labelWidth), 0, _labelWidth, self.height);
        [self initLabel:lbl];
    }
    
    self.labels = [labels copy];
    
    self.label1 = self.labels[0];
    self.label2 = self.labels[1];
    self.label3 = self.labels[2];
}

-(void)layoutSubviews
{
    [self calculateSizes];
    if (self.labels.count > 2)
        for (int i = 0; i < 3; i++)
        {
            UILabel* lbl = self.labels[i];
            lbl.frame = CGRectMake(self.leftCap + _capFromLeft + (i * _labelWidth), 0, _labelWidth, self.height);
        }
    
}

-(void)setLeftCap:(int)leftCap
{
    _leftCap = leftCap;
    [self setNeedsLayout];
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
