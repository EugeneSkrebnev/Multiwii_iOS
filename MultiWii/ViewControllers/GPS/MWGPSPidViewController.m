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
{
    NSArray* _titles;
    NSArray* _iconsTitles;
    NSArray* _pids;
}

-(void) createReadWriteBtns
{
    MWTopbarButton* readTopButton = [[MWTopbarButton alloc] init];
    MWTopbarButton* writeTopButton = [[MWTopbarButton alloc] init];
    int spaceBetweenbtns = 2;
    [readTopButton addTarget:self action:@selector(readPidButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    [writeTopButton addTarget:self action:@selector(writePidButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    [readTopButton setTitle:@"READ" forState:(UIControlStateNormal)];
    [writeTopButton setTitle:@"WRITE" forState:(UIControlStateNormal)];
    
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, readTopButton.width + writeTopButton.width + spaceBetweenbtns, readTopButton.height)];
    [container addSubview:readTopButton];
    writeTopButton.left = readTopButton.width + spaceBetweenbtns;
    [container addSubview:writeTopButton];
    UIBarButtonItem* rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:container];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}
-(void) readPidButtonTapped
{
    [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_GET_PID andPayload:nil responseBlock:^(NSData *recieveData) {
        NSLog(@"read success");
    }];
    
}

-(void) writePidButtonTapped
{
    [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_SET_PID
                                                       andPayload:[[MWGlobalManager sharedInstance].pidManager payloadFromPids]
                                                    responseBlock:^(NSData *recieveData) {
                                                        NSLog(@"write success");
                                                    }];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" GPS PID ";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 98;
    
    _titles = @[@"POS HOLD", @"POS HOLD RATE", @"NAVIGATION RATE"];
    _iconsTitles = @[@"roll.png", @"roll.png", @"roll.png"];
    
    MWGPSPidSettings* gpsPid = [MWPidSettingsManager sharedInstance].gpsPid;
    _pids = @[gpsPid.posHold, gpsPid.posHoldRate, gpsPid.navigationRate];
    [self createReadWriteBtns];
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
    cell.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:11];
    cell.titleLabel.numberOfLines = 2;
    cell.iconImageView.hidden = YES;
    cell.titleLabel.text = _titles[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:_iconsTitles[indexPath.row]];
    cell.pid = _pids[indexPath.row];
    return cell;

}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
