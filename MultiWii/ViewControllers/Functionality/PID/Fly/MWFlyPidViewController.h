//
//  MWFlyPidViewController.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseViewController.h"
#import "MASwitch.h"
#import "MWBasePidSettingsViewController.h"

@interface MWFlyPidViewController : MWBasePidSettingsViewController
@property (nonatomic, strong) MASwitch* rollPitchLockSwitch;
@end
