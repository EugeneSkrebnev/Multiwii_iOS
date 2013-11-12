//
//  MWSettingsViewController.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/10/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWMenuViewController.h"
#import "MWSaveEpromButton.h"
@interface MWSettingsViewController : MWMenuViewController
@property (weak, nonatomic) IBOutlet MWSaveEpromButton *saveButton;

@end
