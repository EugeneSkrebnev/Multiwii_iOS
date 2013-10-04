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

-(void) initBluetoothManager
{
    [[MWBluetoothManager sharedInstance] centralManager]; //init
    [MWBluetoothManager sharedInstance].didAddDeviceToListBlock =
    ^{
        [self.tableView reloadData];
    };
    
    dispatch_block_t statusUpdate = ^{
        BOOL scanModeOn = [MWBluetoothManager sharedInstance].isInScanMode;
        [self.scanButton setHidden:scanModeOn animated:YES];
        [self.activityIndicator setHidden:!scanModeOn animated:YES];
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

-(void) testBoxNames
{
    [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_GET_BOX_NAMES andPayload:nil responseBlock:nil];
    [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_GET_BOXES andPayload:nil responseBlock:nil];
}

-(void) didConnectBluetoothUart
{
    int connectedIndex = [[MWBluetoothManager sharedInstance].deviceList indexOfObject:[MWBluetoothManager sharedInstance].currentConnectedDevice];
    [self setSpinnerHidden:YES forDeviceAtIndex:connectedIndex animated:YES];
    MWDevicePreviewCell* cell = (MWDevicePreviewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:connectedIndex inSection:0]];
    cell.titleLabel.textColor = [UIColor greenColor];
//    [self sendsend]; // test
//    [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_IDENT andPayload:nil responseBlock:nil];
    [self testBoxNames];
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
    
    [self initBluetoothManager];
    
    MWTopbarButton* scanButton = [[MWTopbarButton alloc] init];
    self.scanButton = scanButton;
    [scanButton setTitle:@"SCAN" forState:(UIControlStateNormal)];
    [scanButton addTarget:self action:@selector(scanButtonTapped:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:scanButton];
}

- (IBAction)scanButtonTapped:(id)sender
{
    [[MWBluetoothManager sharedInstance] startScan];
    double delayInSeconds = 10.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[MWBluetoothManager sharedInstance] stopScan];
    });
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
    
    MWDevicePreviewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];;
    if (!cell)
        cell = [MWDevicePreviewCell loadView];
    
    CBPeripheral* device = [MWBluetoothManager sharedInstance].deviceList[indexPath.row];
    NSLog(@"%@", [[MWBluetoothManager sharedInstance] metaDataForDevice:device]);
    NSString* deviceName = device.name;
    if (!deviceName)
        deviceName = [[MWBluetoothManager sharedInstance] metaDataForDevice:device][@"kCBAdvDataLocalName"];
    cell.titleLabel.text = [NSString stringWithFormat:@"name : %@", deviceName];
    cell.titleLabel.textColor = device.isConnected ? [UIColor greenColor] :[UIColor redColor];
    
    
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
