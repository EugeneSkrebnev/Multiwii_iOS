//
//  MAQuadrocopterFrame.m
//  testanimation
//
//  Created by Eugene Skrebnev on 6/30/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MAQuadrocopterFrame.h"

@implementation MAQuadrocopterFrame
{
    BOOL wasInited;
}

-(void) makeInit
{
    if (!wasInited)
    {
        wasInited = YES;
        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame.png"]];
        
        self.width = _background.frame.size.width;
        self.height = _background.frame.size.height;
        [self addSubview:_background];
        
        _centerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"center.png"]];
        _centerView.frame = CGRectMake((self.width - _centerView.width) / 2,
                                       (self.height - _centerView.height) / 2,
                                       _centerView.image.size.width,
                                       _centerView.image.size.height);
        [self addSubview:_centerView];
        
        CGPoint propOffset[4] ={
            CGPointMake( 1.0,   1.0),
            CGPointMake( 1.0,  -1.0),
            CGPointMake(-1.0, -1.0),
            CGPointMake(-1.0,   1.0)};
        
        UIImage* prop = [UIImage imageNamed:@"propeller.png"];
        UIImage* propRing = [UIImage imageNamed:@"ring.png"];
        
//        int propCapFromBorder = 14;
        int propSize = prop.size.width;
        
        int propRingCapFromBorder = 7;
        int propRingSize = propRing.size.width;
        
        for (int i = 0; i < 4; i++)
        {
            _propellers[i] = [[UIImageView alloc] initWithImage:prop];
            _propellersRings[i] = [[UIImageView alloc] initWithImage:propRing];
            
            _propellersRings[i].frame = CGRectMake(((self.width - propRingSize) / 2) + propOffset[i].x * ((self.width - propRingSize) / 2 - propRingCapFromBorder),
                                                   ((self.height - propRingSize) / 2) + propOffset[i].y * ((self.height - propRingSize) / 2 - propRingCapFromBorder),
                                                   propRingSize,
                                                   propRingSize);

            _propellers[i].frame = CGRectMake((propRingSize - propSize) / 2,
                                              (propRingSize - propSize) / 2,
                                              propSize,
                                              propSize);
            

            [_background addSubview:_propellersRings[i]];
            
            [_propellersRings[i] addSubview:_propellers[i]];
        }

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




- (void) spinWithOptions: (UIViewAnimationOptions) options {
    NSTimeInterval spinTime = 3;
    [UIView animateWithDuration: spinTime / 4
                          delay: 0.0f
                        options: options
                     animations: ^{
                         _background.transform = CGAffineTransformRotate(_background.transform, -M_PI / 2);
                         for (int i = 0; i < 4; i++)
                         {
                             _propellersRings[i].transform = CGAffineTransformRotate(_propellersRings[i].transform, M_PI / 2);                             
                         }
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else{ //if (options != UIViewAnimationOptionCurveEaseOut) {
//                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
    
}

- (void) spinWithOptionsProps: (UIViewAnimationOptions) options {
    NSTimeInterval spinTime = 0.5;
    [UIView animateWithDuration: spinTime / 4
                          delay: 0.0f
                        options: options
                     animations: ^{
                         for (int i = 0; i < 4; i++)
                         {
                             _propellers[i].transform = CGAffineTransformRotate(_propellers[i].transform,(i % 2 ? -1 : 1) * M_PI / 2);
                         }
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animatingProps) {
                                 [self spinWithOptionsProps: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 [self spinWithOptionsProps: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
    
}

- (void) startSpin
{
    if (!animating)
    {
        animating = YES;
        animatingProps = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
        [self spinWithOptionsProps: UIViewAnimationOptionCurveEaseIn];
    }
}

- (void) stopSpin
{
    animating = NO;
}

- (void) stopPropSpin
{
    animatingProps = NO;
}



@end
