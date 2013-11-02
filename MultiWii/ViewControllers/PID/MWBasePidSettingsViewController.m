//
//  MWBasePidSettingsViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/5/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBasePidSettingsViewController.h"
#import "MWTopbarButton.h"
#import "MWHeader3LabelView.h"
#import "MWPidAdjustCell.h"


@interface MWBasePidSettingsViewController ()

@end

@implementation MWBasePidSettingsViewController

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
    if (__delegate.isFullVersionUnlocked)
    {
        [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_SET_PID
                                                           andPayload:[[MWGlobalManager sharedInstance].pidManager payloadFromPids]
                                                        responseBlock:^(NSData *recieveData) {
                                                            NSLog(@"write success");
                                                        }];
    }
    else
    {
        [__delegate showBuyDialogFromVC:self];
    }
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self createReadWriteBtns];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (IS_IPHONE_5)
        self.tableView.rowHeight = 98 + 22;
    else
        self.tableView.rowHeight = 98;

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
    cell.iconImageView.image = [UIImage imageNamed:_iconsTitles[indexPath.row]];
    cell.pid = _pids[indexPath.row];
    return cell;
    
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MWBluetoothManager sharedInstance].didFailToFindService = ^(NSError* err, CBPeripheral* device)
    {
        if (!device)
        {
            [UIAlertView alertErrorWithMessage:@"No connected device. Please connect first."];
        }
    };
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MWBluetoothManager sharedInstance].didFailToFindService = nil;
}
@end
