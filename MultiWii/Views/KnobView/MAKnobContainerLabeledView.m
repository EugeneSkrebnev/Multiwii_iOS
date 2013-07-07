//
//  MAKnobContainerLabeledView.m
//  testanimation
//
//  Created by Eugene Skrebnev on 7/4/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MAKnobContainerLabeledView.h"

@implementation MAKnobContainerLabeledView

static BOOL wasInited = NO;

-(void) makeInit
{
    if (!wasInited)
    {
        wasInited = YES;
        self.height = 130;
        self.width = 100;
        self.knobView = [[MAKnob alloc] init];
        self.knobView.center = CGPointMake(self.width / 2, self.height - 50);
        [self addSubview:self.knobView];
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - self.knobView.height)];
        self.valueLabel.backgroundColor = [UIColor grayColor];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.valueLabel];
        
        [self.knobView addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
        
    }
}

-(void) valueChanged:(id) sender
{
    int digitStep = 0;
    self.knobView.step = 0.005;
    float fraq = self.knobView.step - (int)self.knobView.step;
    while (fraq > 0.00000001)
    {
        fraq *= 10;
        fraq = fraq - roundf(fraq);
        digitStep++;
        NSLog(@"%f", fraq);
    }
    
    NSString* format = [NSString stringWithFormat:@"%@.%df", @"%", digitStep];
    self.valueLabel.text = [NSString stringWithFormat:format, self.knobView.value];
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
