//
//  MWConnectViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/22/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWConnectViewController.h"
#import "MWDevicePreviewCell.h"
#import "MWTopbarButton.h"
#import "MWBluetoothManager.h"

@interface MWConnectViewController ()

@end

@implementation MWConnectViewController
{
    CGPoint _radarCenter;
}
-(void) initBluetoothManager
{
    [[MWBluetoothManager sharedInstance] centralManager]; //init
    [MWBluetoothManager sharedInstance].didAddDeviceToListBlock =
    ^{
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:0.5 animations:^{
                self.radar.transform = CGAffineTransformMakeScale(0.5, 0.5);
                self.radar.center = CGPointMake(self.view.width / 2, self.view.height - 40);
            } completion:^(BOOL finished) {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationLeft)];
            }];


            //move it down and make smaller
            
        });
    };
    
    dispatch_block_t statusUpdate = ^{
        BOOL scanModeOn = [MWBluetoothManager sharedInstance].isInScanMode;
        [self.scanButton setHidden:scanModeOn animated:YES];
        
        if (scanModeOn)
        {
            self.radar.transform = CGAffineTransformIdentity;
            self.radar.center = _radarCenter;
            [self.radar setHidden:NO animated:YES];
        }
        else
        {
            [self.radar setHidden:YES animated:YES];
            if ([MWBluetoothManager sharedInstance].deviceList.count == 0)
            {
                [UIAlertView alertWithTitle:@"" message:@"No devices found. Go to \"About\" - \"How to connect\" section for instructions."];
            }
        }
//        [self.activityIndicator setHidden:!scanModeOn animated:YES];
    };
    
    [MWBluetoothManager sharedInstance].didStartScan = statusUpdate;
    [MWBluetoothManager sharedInstance].didStopScan = statusUpdate;
    
    [MWBluetoothManager sharedInstance].didConnectBlock = ^(CBPeripheral* connectedDevice)
    {
        NSLog(@"connected device: %@", [[CBUUID UUIDWithCFUUID:connectedDevice.UUID] stringValue]);
//        int connectedIndex = [[MWBluetoothManager sharedInstance].deviceList indexOfObject:[MWBluetoothManager sharedInstance].currentConnectedDevice];
//        MWDevicePreviewCell* cell = (MWDevicePreviewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:connectedIndex inSection:0]];
//        
    };
    
    [MWBluetoothManager sharedInstance].didFailToConnectBlock = ^(NSError* err, CBPeripheral* per)
    {
        NSLog(@"%@", err);
        if (err.code == 1002)
        {
            int connectedIndex = [[MWBluetoothManager sharedInstance].deviceList indexOfObject:[MWBluetoothManager sharedInstance].currentConnectedDevice];
            [self setSpinnerHidden:YES forDeviceAtIndex:connectedIndex animated:YES];

        }
    };
    
    [MWBluetoothManager sharedInstance].didDiscoverCharacteristics = ^(CBPeripheral* connectedDevice)
    {
        for (CBService* id_ in connectedDevice.services)
            NSLog(@"Service ID: %@", id_.UUID.stringValue);
    };
    

    
    [MWBluetoothManager sharedInstance].readyForReadWriteBlock = ^
    {
        [self didConnectBluetoothUart];
    };
}

-(void)sendsend
{
    double delayInSeconds = 0.7;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_IDENT andPayload:nil responseBlock:nil];
        [self sendsend];
        NSString* dt = @"aaaaaaaaaaaaaaaaaaa bbbbbbbbbbbbbbbbbbb ccccccccccccccccccc ddddddddddddddddddd ";
        [[MWBluetoothManager sharedInstance] sendData:[dt dataUsingEncoding:(NSUTF8StringEncoding)]];
//        dt = @"bbbbbbbbbbbbbbbbbbb ";
//        [[MWBluetoothManager sharedInstance] sendData:[dt dataUsingEncoding:(NSUTF8StringEncoding)]];
//        dt = @"ccccccccccccccccccc ";
//        [[MWBluetoothManager sharedInstance] sendData:[dt dataUsingEncoding:(NSUTF8StringEncoding)]];
//        dt = @"ddddddddddddddddddd ";
//        [[MWBluetoothManager sharedInstance] sendData:[dt dataUsingEncoding:(NSUTF8StringEncoding)]];
        
    });

}

-(void) testRCTunning
{
    NSLog(@"");
    [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_GET_RC_TUNNING andPayload:nil responseBlock:nil];
    
}

-(void) didConnectBluetoothUart
{
    int connectedIndex = [[MWBluetoothManager sharedInstance].deviceList indexOfObject:[MWBluetoothManager sharedInstance].currentConnectedDevice];
    [self setSpinnerHidden:YES forDeviceAtIndex:connectedIndex animated:YES];
    MWDevicePreviewCell* cell = (MWDevicePreviewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:connectedIndex inSection:0]];
    cell.titleLabel.textColor = [UIColor greenColor];
//    [self sendsend]; // test
    [MWGlobalManager sharedInstance].multiwiiSuccesConnect = NO;
    [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_IDENT andPayload:nil responseBlock:^(NSData *recieveData) {
        
        cell.titleLabel.text = [MWGlobalManager sharedInstance].copterTypeString;
        
    }];
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (![MWGlobalManager sharedInstance].multiwiiSuccesConnect)
        {
            [UIAlertView alertWithTitle:@"Error" message:@"Can't detect multiwii board, please check your rx-tx connections, and serial0 speed. Use 57600 baud rate for correct work"];
        }
    });
//    [self testRCTunning]; test
}

-(void) setSpinnerHidden:(BOOL) hidden forDeviceAtIndex:(int) index animated:(BOOL) animated
{
    MWDevicePreviewCell* cell = (MWDevicePreviewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [cell.activityIndicator setHidden:hidden animated:animated];
//    if (!hidden)
//        [cell.activityIndicator startAnimating];
}

-(void) removeCallbackBlocksFromBluetoothManager
{
    [MWBluetoothManager sharedInstance].didAddDeviceToListBlock = nil;
    
    [MWBluetoothManager sharedInstance].didStartScan = nil;
    [MWBluetoothManager sharedInstance].didStopScan = nil;

    [MWBluetoothManager sharedInstance].didConnectBlock = nil;
    [MWBluetoothManager sharedInstance].didDiscoverCharacteristics = nil;
    [MWBluetoothManager sharedInstance].didRecieveData = nil;
    [MWBluetoothManager sharedInstance].readyForReadWriteBlock = nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" CONNECT ";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;

    [self initBluetoothManager];
    
    MWTopbarButton* scanButton = [[MWTopbarButton alloc] init];
    self.scanButton = scanButton;
    [scanButton setTitle:@"SCAN" forState:(UIControlStateNormal)];
    [scanButton addTarget:self action:@selector(scanButtonTapped:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:scanButton];
    self.radar = [[MWRadarActivityIndicator alloc] init];
    _radarCenter = CGPointMake(self.view.width / 2, self.view.height / 2 - 80);
    self.radar.center = _radarCenter;
    self.radar.hidden = YES;
    [self.view addSubview:self.radar];

}

- (IBAction)scanButtonTapped:(id)sender
{

    [[MWBluetoothManager sharedInstance] startScan];
    double delayInSeconds = 10.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[MWBluetoothManager sharedInstance] stopScan];
    });
    [self.tableView reloadData];    
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setScanButton:nil];
    [self setActivityIndicator:nil];
    [self removeCallbackBlocksFromBluetoothManager];
    [super viewDidUnload];
}

#pragma mark - tableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[MWBluetoothManager sharedInstance] stopScan];
    CBPeripheral* device = [MWBluetoothManager sharedInstance].deviceList[indexPath.row];
    
    
    [self setSpinnerHidden:NO forDeviceAtIndex:indexPath.row animated:YES];
    [[MWBluetoothManager sharedInstance] connectToDevice:device];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MWBluetoothManager sharedInstance].deviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"MWDevicePreviewCell_ID";
    //молодец думал головой, можно и в других местах тоже так сделать.
    MWDevicePreviewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];;
    if (!cell)
        cell = [MWDevicePreviewCell loadView];
    
    CBPeripheral* device = [MWBluetoothManager sharedInstance].deviceList[indexPath.row];
    NSLog(@"%@", [[MWBluetoothManager sharedInstance] metaDataForDevice:device]);
    NSString* deviceName = device.name;
    if (!deviceName)
        deviceName = [[MWBluetoothManager sharedInstance] metaDataForDevice:device][@"kCBAdvDataLocalName"];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", deviceName];
    cell.titleLabel.textColor = device.isConnected ? [UIColor greenColor] :[UIColor whiteColor];
    
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    double delayInSeconds = 0.1; //hack? or
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self scanButtonTapped:nil];
    });


}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[MWBluetoothManager sharedInstance] stopScan];
}
@end
