//
//  MWFlyPidViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWFlyPidViewController.h"
#import "MWHeader3LabelView.h"
#import "MWFlyPidSettings.h"
#import "MWPidAdjustCell.h"

@interface MWFlyPidViewController ()

@end

@implementation MWFlyPidViewController
{
    NSArray* _titles;
    NSArray* _pids;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @"- PID FLY -";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 98;
    
    _titles = @[@"ROLL", @"PITCH", @"YAW", @"LEVEL"];
    MWFlyPidSettings* flyPid = [MWPidSettingsManager sharedInstance].flyPid;
    _pids = @[flyPid.roll, flyPid.pitch, flyPid.yaw, flyPid.level];
    
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
    [super viewDidUnload];
}
@end
