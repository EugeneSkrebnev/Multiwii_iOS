//
//  MWSensorsPidViewController.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseViewController.h"
#import "MWBasePidSettingsViewController.h"
@interface MWSensorsPidViewController : MWBasePidSettingsViewController

@property (weak, nonatomic) IBOutlet UIButton *calibrateAccButton;
@property (weak, nonatomic) IBOutlet UIButton *calibrateMagButton;

@end
