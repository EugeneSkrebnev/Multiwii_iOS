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
@interface MWSensorsPidViewController ()

@end

@implementation MWSensorsPidViewController
{
    NSArray* _iconFiles;
    NSArray* _titles;
    NSArray* _pids;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" SENSORS ";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 98;
    
    _titles = @[@"BARO", @"MAG"];
    MWSensorsPidSettings* sensorsPid = [MWPidSettingsManager sharedInstance].sensorsPid;
    _pids = @[sensorsPid.baro, sensorsPid.mag];

    self.calibrateAccButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:14];
    self.calibrateMagButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:14];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MWHeader3LabelView* headerView = [[MWHeader3LabelView alloc] init];
    headerView.label1.text = @"P";
    headerView.label2.text = @"I";
    headerView.label3.text = @"D";
    headerView.leftCap = 45;
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWPidAdjustCell* cell = (MWPidAdjustCell*)[MWPidAdjustCell loadView];
    cell.titleLabel.text = _titles[indexPath.row];
    cell.pid = _pids[indexPath.row];
    return cell;
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setCalibrateAccButton:nil];
    [self setCalibrateMagButton:nil];
    [super viewDidUnload];
}
@end
