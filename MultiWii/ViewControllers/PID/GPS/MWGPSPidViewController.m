//
//  MWFlyPidViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWGPSPidViewController.h"
#import "MWHeader3LabelView.h"
#import "MWGPSPidSettings.h"
#import "MWPidAdjustCell.h"
#import "MWTopbarButton.h"

@interface MWGPSPidViewController ()

@end

@implementation MWGPSPidViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" GPS PID ";
    
    _titles = @[@"POS HOLD", @"POS HOLD RATE", @"NAVIGATION RATE"];
    _iconsTitles = @[@"roll.png", @"roll.png", @"roll.png"];
    
    MWGPSPidSettings* gpsPid = [MWPidSettingsManager sharedInstance].gpsPid;
    _pids = @[gpsPid.posHold, gpsPid.posHoldRate, gpsPid.navigationRate];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWPidAdjustCell* cell = (MWPidAdjustCell*)[super tableView:self.tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:11];
    cell.titleLabel.numberOfLines = 2;
    cell.iconImageView.hidden = YES;
    return cell;

}

@end
