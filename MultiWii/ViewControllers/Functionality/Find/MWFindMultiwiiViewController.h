//
//  MWFindMultiwiiViewController.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/27/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseViewController.h"
#import "MWSignalIndicatorView.h"

@interface MWFindMultiwiiViewController : MWBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (nonatomic, strong) UILabel* percentLabel;
@property (weak, nonatomic) IBOutlet MWSignalIndicatorView *signalIndicator;
@property (weak, nonatomic) IBOutlet UILabel *mLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel1;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel2;
@property (weak, nonatomic) IBOutlet UIButton *metrPoundsButton;
@end
