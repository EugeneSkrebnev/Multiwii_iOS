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
    
    [BLUETOOTH_MANAGER centralManager]; //init
    BLUETOOTH_MANAGER.didDisconnectBlock = ^(CBPeripheral* device)
    {
        [self.tableView reloadData];
    };
    
    BLUETOOTH_MANAGER.didAddDeviceToListBlock =
    ^{
        double delayInSeconds = .7;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:0.5 animations:^{
                self.radar.transform = CGAffineTransformMakeScale(0.5, 0.5);
                self.radar.center = CGPointMake(self.view.width / 2, self.view.height - 60);
            } completion:^(BOOL finished) {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationLeft)];
            }];


            //move it down and make smaller
            
        });
    };
    
    dispatch_block_t statusUpdate = ^{
        BOOL scanModeOn = BLUETOOTH_MANAGER.isInScanMode;
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
            if (BLUETOOTH_MANAGER.deviceList.count == 0)
            {
                [UIAlertView alertWithTitle:@"" message:@"No devices found. Go to \"About\" - \"How to connect\" section for instructions."];
            }
        }
//        [self.activityIndicator setHidden:!scanModeOn animated:YES];
    };
    
    BLUETOOTH_MANAGER.didStartScan = statusUpdate;
    BLUETOOTH_MANAGER.didStopScan = statusUpdate;
    
    BLUETOOTH_MANAGER.didConnectBlock = ^(CBPeripheral* connectedDevice)
    {
        NSLog(@"connected device: %@", [[CBUUID UUIDWithCFUUID:connectedDevice.UUID] stringValue]);
//        int connectedIndex = [BLUETOOTH_MANAGER.deviceList indexOfObject:BLUETOOTH_MANAGER.currentConnectedDevice];
//        MWDevicePreviewCell* cell = (MWDevicePreviewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:connectedIndex inSection:0]];
//        
    };
    
    BLUETOOTH_MANAGER.didFailToConnectBlock = ^(NSError* err, CBPeripheral* per)
    {
        NSLog(@"%@", err);
        if (err.code == 1002)
        {
            int connectedIndex = [BLUETOOTH_MANAGER.deviceList indexOfObject:BLUETOOTH_MANAGER.currentConnectedDevice];
            [self setSpinnerHidden:YES forDeviceAtIndex:connectedIndex animated:YES];

        }
    };
    
    BLUETOOTH_MANAGER.didDiscoverCharacteristics = ^(CBPeripheral* connectedDevice)
    {
        for (CBService* id_ in connectedDevice.services)
            NSLog(@"Service ID: %@", id_.UUID.stringValue);
    };
    

    
    BLUETOOTH_MANAGER.readyForReadWriteBlock = ^
    {
        [self didConnectBluetoothUart];
    };
}



-(void) didConnectBluetoothUart
{
    int connectedIndex = [BLUETOOTH_MANAGER.deviceList indexOfObject:BLUETOOTH_MANAGER.currentConnectedDevice];
    [self setSpinnerHidden:YES forDeviceAtIndex:connectedIndex animated:YES];
    MWDevicePreviewCell* cell = (MWDevicePreviewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:connectedIndex inSection:0]];
    cell.titleLabel.textColor = [UIColor greenColor];

    [MWGlobalManager sharedInstance].multiwiiSuccesConnect = NO;
    [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_IDENT andPayload:nil responseBlock:^(NSData *recieveData) {
        
        cell.titleLabel.text = [MWGlobalManager sharedInstance].copterTypeString;

        if (![__delegate isFullVersionUnlocked])
            [Flurry logEvent:[NSString stringWithFormat:@"Connect Succes on limited version to copterType : %@", [MWGlobalManager sharedInstance].copterTypeString]];
        else
            [Flurry logEvent:[NSString stringWithFormat:@"Connect Succes to copterType : %@", [MWGlobalManager sharedInstance].copterTypeString]];
        
    }];
    
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (![MWGlobalManager sharedInstance].multiwiiSuccesConnect)
        {
            [UIAlertView alertWithTitle:@"Error" message:@"Can't detect multiwii board, please check your rx-tx connections, and serial speed."];
            [Flurry logEvent:[NSString stringWithFormat:@"Connect Succes but multiwii fail : %@", cell.titleLabel.text]];
        }
    });

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
    BLUETOOTH_MANAGER.didDisconnectBlock = nil;
    
    BLUETOOTH_MANAGER.didAddDeviceToListBlock = nil;
    
    BLUETOOTH_MANAGER.didStartScan = nil;
    BLUETOOTH_MANAGER.didStopScan = nil;
    
    BLUETOOTH_MANAGER.didConnectBlock = nil;
    BLUETOOTH_MANAGER.didFailToConnectBlock = nil;
    BLUETOOTH_MANAGER.didDiscoverCharacteristics =  nil;
    BLUETOOTH_MANAGER.readyForReadWriteBlock = nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" CONNECT ";
    
    self.infoLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:14];
    self.infoLabel.textColor = [UIColor grayColor];
    self.infoLabel.text = @"*Tap the item to connect";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;


    
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
    if (!BLUETOOTH_MANAGER.isReadyToUse)
    {
        [UIAlertView alertErrorWithMessage:@"Please be sure your bluetooth is on. You can check it in device settings"];
    }
    [BLUETOOTH_MANAGER startScan];
    double delayInSeconds = 6.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [BLUETOOTH_MANAGER stopScan];
    });
    [self.tableView reloadData];    
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setScanButton:nil];
    [self setActivityIndicator:nil];

    [super viewDidUnload];
}

#pragma mark - tableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [BLUETOOTH_MANAGER stopScan];
    CBPeripheral* device = BLUETOOTH_MANAGER.deviceList[indexPath.row];
    
    if (!device.isConnected)
    {
        NSString* deviceName = device.name;
        if (!deviceName)
            deviceName = [BLUETOOTH_MANAGER metaDataForDevice:device][@"kCBAdvDataLocalName"];
        [Flurry logEvent:[NSString stringWithFormat:@"Connect to device : %@", deviceName]];
        [self setSpinnerHidden:NO forDeviceAtIndex:indexPath.row animated:YES];
        [BLUETOOTH_MANAGER connectToDevice:device];
    }
    else
    {
        [BLUETOOTH_MANAGER disconnectFromDevice:device];
    }


    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return BLUETOOTH_MANAGER.deviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"MWDevicePreviewCell_ID";
    //молодец думал головой, можно и в других местах тоже так сделать.
    MWDevicePreviewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];;
    if (!cell)
        cell = [MWDevicePreviewCell loadView];
    
    CBPeripheral* device = BLUETOOTH_MANAGER.deviceList[indexPath.row];
    NSLog(@"%@", [BLUETOOTH_MANAGER metaDataForDevice:device]);
    NSString* deviceName = device.name;
    if (!deviceName)
        deviceName = [BLUETOOTH_MANAGER metaDataForDevice:device][@"kCBAdvDataLocalName"];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", deviceName];
    cell.titleLabel.textColor = device.isConnected ? [UIColor greenColor] :[UIColor whiteColor];
    
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initBluetoothManager];
    double delayInSeconds = 0.1; //hack? or
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self scanButtonTapped:nil];
    });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectError) name:kDidDisconnectWithErrorNotification object:nil];
}

-(void) connectError
{
    [BLUETOOTH_MANAGER clearSearchList];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeCallbackBlocksFromBluetoothManager];    
    [BLUETOOTH_MANAGER stopScan];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
