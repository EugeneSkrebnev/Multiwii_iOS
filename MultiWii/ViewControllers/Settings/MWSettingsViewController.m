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
//    self.saveButton.hidden = !__delegate.isFullVersionUnlocked;
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.saveButton setHidden:!__delegate.isFullVersionUnlocked animated:YES];
//}

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

- (IBAction)saveButtonTapped:(id)sender
{
 
    if (__delegate.isFullVersionUnlocked)
    {
        [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_SET_SAVE_EPROM
                                 andPayload:nil
                              responseBlock:^(NSData *recieveData)
        {
            [self.saveButton setTitle:@"SAVED" forState:(UIControlStateNormal)];
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
            {
                [self.saveButton setTitle:@"SAVE TO EPROM" forState:(UIControlStateNormal)];
            });
        }];
    }
    else
        [__delegate showBuyDialogFromVC:self];
}

@end
