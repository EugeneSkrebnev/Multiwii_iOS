//
//  MWRadioAndMotorViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/12/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWRadioAndMotorViewController.h"
#import "MWTelemetryRadioValuesCell.h"

@interface MWRadioAndMotorViewController ()

@property (nonatomic, strong) MWTelemetryRadioValuesCell* controlRadioValues; // pitch/thr/roll/yaw
@property (nonatomic, strong) MWTelemetryRadioValuesCell* auxRadioValues;     // aux1-4
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MWRadioAndMotorViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" RADIO/MOTOR VALUES ";
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
}

#pragma mark - table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2; //3
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWTelemetryRadioValuesCell* cell;
    if (indexPath.row == 0)
    {
        cell = [MWTelemetryRadioValuesCell loadView];
        self.controlRadioValues = cell;
    }
    if (indexPath.row == 1)
    {
        cell = [MWTelemetryRadioValuesCell loadView];
        self.controlRadioValues = cell;
    }

    return cell;
}

@end
