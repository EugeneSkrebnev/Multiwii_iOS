//
//  MWConnectViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/22/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWConnectViewController.h"
#import "MWDevicePreviewCell.h"

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

        if (scanModeOn)
        {
        }
        else
        {
            
        }
        
    };
    
    [MWBluetoothManager sharedInstance].didStartScan = statusUpdate;
    [MWBluetoothManager sharedInstance].didStopScan = statusUpdate;
    
    [MWBluetoothManager sharedInstance].didConnectBlock = ^(CBPeripheral* connectedDevice)
    {
        NSLog(@"connected device: %@", [[CBUUID UUIDWithCFUUID:connectedDevice.UUID] stringValue]);
    };
    
    [MWBluetoothManager sharedInstance].didDiscoverCharacteristics = ^(CBPeripheral* connectedDevice)
    {
        for (CBService* id_ in connectedDevice.services)
            NSLog(@"Service ID: %@", id_.UUID.stringValue);
    };
    
    [MWBluetoothManager sharedInstance].didRecieveData = ^(CBPeripheral* connectedDevice, NSData* incomingData)
    {
        NSLog(@"receive data with length : %d", incomingData.length);
        for (int i = 0; i < incomingData.length; i++)
        {
            unsigned char *x = (unsigned char*)incomingData.bytes;
            NSLog(@"%d", x[i]);
        }
        NSLog(@"receive data end batch");
        
    };
}

-(void) removeCallbackBlocksFromBluetoothManager
{
    [MWBluetoothManager sharedInstance].didAddDeviceToListBlock = nil;
    
    [MWBluetoothManager sharedInstance].didStartScan = nil;
    [MWBluetoothManager sharedInstance].didStopScan = nil;

    [MWBluetoothManager sharedInstance].didConnectBlock = nil;
    [MWBluetoothManager sharedInstance].didDiscoverCharacteristics = nil;
    [MWBluetoothManager sharedInstance].didRecieveData = nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @"- PID FLY -";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self initBluetoothManager];
    
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
    cell.textLabel.text = [NSString stringWithFormat:@"name : %@", device.name];
    cell.textLabel.textColor = device.isConnected ? [UIColor greenColor] :[UIColor redColor];
    
    
    return cell;
}

@end
