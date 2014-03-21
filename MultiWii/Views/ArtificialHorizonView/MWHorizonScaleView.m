//
//  MWHorizonScaleView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/13/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWHorizonScaleView.h"

@interface MWHorizonScaleView()

@property (nonatomic, assign) int topCap;
@property (nonatomic, assign) int bottomCap;
@property (nonatomic, assign) int leftCap;
@property (nonatomic, assign) int rightCap;


@end

@implementation MWHorizonScaleView
{
    BOOL _wasInit;
    NSArray* _leftLabels; //UIlabels on left side
    NSArray* _rightLabels;//UIlabels on right side
    NSArray* _lines;      //UIView for lines
    NSMutableDictionary* _viewIndexForValue;
    UIImageView* _background;
}

-(void) makeInit
{
    if (!_wasInit)
    {
        _wasInit = YES;

        self.width = 120;
        self.height = 280;
        
        self.minValue = -90;
        self.maxValue = 90;
        
        self.scaleStep = 10;
        self.leftCap = self.rightCap = 35;
        self.topCap = self.bottomCap = 10;
        _viewIndexForValue = [[NSMutableDictionary alloc] init];
        [self generateScaleViews];
        self.backgroundColor = [UIColor clearColor];
        self.value = 0;
    }
}

-(void) setColorsForValue
{
    
    for (NSNumber* key in _viewIndexForValue)
    {
        int intKey = [_viewIndexForValue[key] intValue];
        UILabel* leftLabel = _leftLabels[intKey];
        UILabel* rightLabel = _rightLabels[intKey];
        UIView* line = _lines[intKey];
        if (self.value / 10. < key.intValue)
        {
            UIColor* color = RGB(115, 155, 155);
            leftLabel.textColor = color;
            rightLabel.textColor = color;
            line.backgroundColor = color;
        }
        else
        {
            UIColor* color = [UIColor whiteColor];
            leftLabel.textColor = color;
            rightLabel.textColor = color;
            line.backgroundColor = color;
        }
    }
}

-(void) generateScaleViews
{
    //remove all subviews
    if (_lines.count > 0)
    {
        NSMutableArray* allviews = [NSMutableArray arrayWithArray:_lines];
        [allviews addObjectsFromArray:_leftLabels];
        [allviews addObjectsFromArray:_rightLabels];
        for (UIView* view in allviews)
        {
            [view removeFromSuperview];
        }
        [_viewIndexForValue removeAllObjects];
        _leftLabels = nil;
        _rightLabels = nil;
    }
    
    int scaleStepInPexels = ( (self.height - self.topCap - self.bottomCap) / ((self.maxValue - self.minValue) / self.scaleStep) );
    int yVal = (self.height - self.topCap - self.bottomCap) / 2 - ((self.maxValue - self.minValue) / self.scaleStep / 2) * scaleStepInPexels;
    //create lines views
    // create left and right labels
    int labelWidth = 40;
    int capFromLine = 4;
    int labelHeigth = 40;

    NSMutableArray* lines = [NSMutableArray array];
    NSMutableArray* leftLabels = [NSMutableArray array];
    NSMutableArray* rightLabels = [NSMutableArray array];
    
    UIFont* labelFont = [UIFont fontWithName:@"Montserrat-Regular" size:9];

    
    for (int i = self.maxValue; i >= self.minValue; i-=self.scaleStep)
    {
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(self.leftCap,
                                                                self.topCap + yVal,
                                                                self.width - self.leftCap - self.rightCap,
                                                                1)];
        if (i > 0)
            line.backgroundColor = RGB(122, 122, 122);
        else
            line.backgroundColor = [UIColor whiteColor];
        
        yVal += scaleStepInPexels;
        _viewIndexForValue[@(i)] = @(lines.count);
        [lines addObject:line];

        [leftLabels addObject:({
            UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(line.left - capFromLine - labelWidth,
                                                                     line.top - (labelHeigth / 2),
                                                                     labelWidth,
                                                                     labelHeigth)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.font = labelFont;
            lbl.text = [NSString stringWithFormat:@"%@%d", i > 0 ? @"+" : (i != 0 ? @"-" : @""), abs(i)];//macros for sign?
            lbl.textAlignment = NSTextAlignmentRight;
            lbl;
         })];

        
        [rightLabels addObject:({
            UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(line.left + line.width + capFromLine,
                                                                     line.top - (labelHeigth / 2),
                                                                     labelWidth,
                                                                     labelHeigth)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.font = labelFont;
            lbl.text = [NSString stringWithFormat:@"%@%d", i > 0 ? @"+" : (i != 0 ? @"-" : @""), abs(i)];
            lbl;
        })];
        
        
    }
    _lines = [lines copy];
    _leftLabels = [leftLabels copy];
    _rightLabels = [rightLabels copy];

    
    NSMutableArray* allviews = [NSMutableArray arrayWithArray:_lines];
    [allviews addObjectsFromArray:_leftLabels];
    [allviews addObjectsFromArray:_rightLabels];
    for (UIView* view in allviews)
    {
        [self addSubview:view];
    }
        
    //adjust 0 line
    int zeroLineIndex = [_viewIndexForValue[@0] intValue];
    UIView* zeroLine = _lines[zeroLineIndex];
    zeroLine.width += 46;
    zeroLine.left -= 23;
    
    UILabel* rightZeroLabel = _rightLabels[zeroLineIndex];
    rightZeroLabel.left += 19;
    rightZeroLabel.top -= 4;
    
    UILabel* leftZeroLabel  = _leftLabels[zeroLineIndex];
    leftZeroLabel.left -= 19;
    leftZeroLabel.top -= 4;
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

-(CGAffineTransform) transformForPitch:(int) value
{
    double scale = (self.height - self.topCap - self.bottomCap) / (self.maxValue - self.minValue);
    return CGAffineTransformMakeTranslation(0, value * scale);
}

-(CGAffineTransform) transformForPitchInverted:(int) value
{
    double scale = (self.height - self.topCap - self.bottomCap) / (self.maxValue - self.minValue);
    return CGAffineTransformMakeTranslation(0, -value * scale / 2);
}

-(void)setValue:(int)value
{
    _value = value;
    [self setColorsForValue];
}

@end
