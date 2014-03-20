//
//  MWOrientationViewContainer.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/20/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWArtificialHorizonView.h"
#import "MWCircleIconValueView.h"

@interface MWOrientationViewContainer : UIView

@property (weak, nonatomic) IBOutlet MWArtificialHorizonView* horizonView;
@property (weak, nonatomic) IBOutlet UILabel* rollLabel;
@property (weak, nonatomic) IBOutlet UILabel* pitchLabel;
@property (weak, nonatomic) IBOutlet UILabel* rollValueLabel;
@property (weak, nonatomic) IBOutlet UILabel* pitchValueLabel;

@property (weak, nonatomic) IBOutlet MWCircleIconValueView* pitchIconView;
@property (weak, nonatomic) IBOutlet MWCircleIconValueView* rollIconView;

@end
