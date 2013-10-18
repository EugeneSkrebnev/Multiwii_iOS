//
//  MWSensorsPidViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWSensorsPidViewController.h"
#import "MWPidAdjustCell.h"
#import "MWHeader3LabelView.h"
#import "MWSensorsPidSettings.h"
#import "MWTopbarButton.h"

@interface MWSensorsPidViewController ()

@end

@implementation MWSensorsPidViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" SENSORS ";
    
    _titles = @[@"BARO", @"MAG"];
    _iconsTitles = @[@"baro", @"mag.png"];
    MWSensorsPidSettings* sensorsPid = [MWPidSettingsManager sharedInstance].sensorsPid;
    _pids = @[sensorsPid.baro, sensorsPid.mag];

    self.calibrateAccButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:14];
    self.calibrateMagButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:14];
    
    [self.calibrateAccButton addTarget:self action:@selector(calibrateAccButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    [self.calibrateMagButton addTarget:self action:@selector(calibrateMagButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.tableView reloadData];
    
    if (IS_IPHONE_5)
    {
        for (UIView* btn in @[self.calibrateAccButton, self.calibrateMagButton])
        {
            btn.top += 35;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self readPidButtonTapped];
}

-(void) calibrateAccButtonTapped
{
    [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_ACC_CALIBRATION andPayload:nil responseBlock:^(NSData *recieveData)
    {
        NSLog(@"read success");
    }];
}

-(void) calibrateMagButtonTapped
{
    [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_MAG_CALIBRATION andPayload:nil responseBlock:^(NSData *recieveData)
     {
         NSLog(@"read success");
     }];
}

- (void)viewDidUnload {
    [self setCalibrateAccButton:nil];
    [self setCalibrateMagButton:nil];
    [super viewDidUnload];
}
@end
