//
//  MWCompassViewContainer.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/20/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWCompassView.h"
#import "MWCircleValueLabel.h"
@interface MWCompassViewContainer : UIView
@property (weak, nonatomic) IBOutlet MWCompassView *compassView;
@property (weak, nonatomic) IBOutlet MWCircleValueLabel* valueCircle;
@end
