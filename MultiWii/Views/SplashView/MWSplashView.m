//
//  MWSplashView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/1/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWSplashView.h"
#import "MAQuadrocopterFrame.h"

#define startFlyPoint CGPointMake(self.width, 0)
#define finishFlyPoint CGPointMake(self.width / 2, self.height - 150)

#define flyInAnimationDuration 1.4
#define flyOutAnimationDuration 2

#define propSpinDuration 1.5

@implementation MWSplashView
{
    MAQuadrocopterFrame* frame;
}

static BOOL wasInited = NO;

-(void) makeInit
{
    if (!wasInited)
    {
        
        wasInited = YES;
        
        NSString* spashImageName;
        
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                spashImageName = @"Splash5.png";
            }
            else
            {
                spashImageName = @"Splash.png";                
                //iphone 3.5 inch screen
            }
        }
        else
        {
            spashImageName = @"Splash@2x.png";
        }
        self.frame = [UIScreen mainScreen].bounds;
        UIImage* spashImage = [UIImage imageNamed:spashImageName];
        _background = [[UIImageView alloc] initWithImage:spashImage];
        [self addSubview:_background];
        frame = [[MAQuadrocopterFrame alloc] init];
        [self addSubview:frame];
    }
}

-(void) makeFlyOutAnimation{NSLog(@"NOT IMPL");}

-(void) makeFlyInAnimation
{
    frame.transform = CGAffineTransformMakeScale(0.01, 0.01);
    frame.center = startFlyPoint;;

    [frame startSpin];
    
    [UIView animateWithDuration:flyInAnimationDuration animations:^{
        frame.center = finishFlyPoint;
        frame.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [frame stopSpin];
        double delayInSeconds = propSpinDuration;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [frame stopPropSpin];
        });
    }];

}

-(NSTimeInterval)animateInTime
{
    return flyInAnimationDuration + propSpinDuration;
}

-(NSTimeInterval)animateOutTime
{
    return flyOutAnimationDuration + propSpinDuration;
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

- (id)initWithFrame:(CGRect)aframe
{
    self = [super initWithFrame:aframe];
    if (self)
    {
        [self makeInit];
    }
    return self;
}


@end
