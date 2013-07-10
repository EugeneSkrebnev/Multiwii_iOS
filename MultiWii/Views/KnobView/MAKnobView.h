//
//  MAKnob.h
//  testanimation
//
//  Created by Eugene Skrebnev on 7/4/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MAKnobControlTypePanX,
    MAKnobControlTypePanY,
    MAKnobControlTypePanXY,
    MAKnobControlTypePanSpin,   
} MAKnobControlType;

@interface MAKnobView : UIControl<UIGestureRecognizerDelegate>
{
    UIView* _backgroundView;
    UIImageView* _knobView;
    UIImageView* _knobViewSelected;
    UIImageView* _knobHandleView;
    CGPoint _savedTranslation;
    CGPoint _currentTranslation;
    
}
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL animateOnActivate;
@property (nonatomic, assign) BOOL discreteChanging;

@property (nonatomic, assign) float value;
@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) float maxValue;
@property (nonatomic, assign) float step;
@property (nonatomic, assign) float spinCount;



@property (nonatomic, assign) MAKnobControlType controlType;
@end
