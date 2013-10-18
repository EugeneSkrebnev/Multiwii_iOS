//
//  MWSettingsViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/10/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWSettingsViewController.h"

@interface MWSettingsViewController ()

@end

@implementation MWSettingsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" SETTINGS ";
}

-(NSArray*) titlesForMenu
{
    return @[@"PID FLY", @"PID SENSORS", @"PID GPS", @"EXPONENTS/RATE", @"BOXES/AUX"];
}

-(NSArray*) iconsForMenu
{
    return @[@"pid_fly", @"pid_sensors", @"pid_gps", @"exponents", @"aux"];
}

-(NSArray*) subtitlesForMenu
{
    return @[@"Roll / Pitch / Yaw / Level", @"Baro / Mag / Acc+Calibrate", @"", @"", @""];
}

@end
