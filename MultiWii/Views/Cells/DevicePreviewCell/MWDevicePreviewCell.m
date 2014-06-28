//
//  MWDevicePreviewCell.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/22/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWDevicePreviewCell.h"

@interface MWDevicePreviewCell()
@property (weak, nonatomic) IBOutlet UIImageView *bluetoothIcon;
@property (weak, nonatomic) IBOutlet UIImageView *bluetoothIconPressed;
@end

@implementation MWDevicePreviewCell

+(NSString*) cellId
{
    return @"MWDevicePreviewCell_ID";
}


-(void)makeInit
{
    [super makeInit];
    self.nameLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:14];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:14];
    self.infoLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:10];
    self.infoLabel.textColor = [UIColor grayColor];
    self.bluetoothIconPressed.hidden = YES;
    self.BLESettingArrow.hidden = YES;
    self.connected = NO;
}

-(void) animateBluetoothIcon
{
    if (!self.connected) {
        self.bluetoothIconPressed.hidden = YES;
        return;
    } else {
        self.bluetoothIconPressed.hidden = NO;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.bluetoothIconPressed.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.bluetoothIconPressed.alpha = 0;
        } completion:^(BOOL finished) {
            [self animateBluetoothIcon];
        }];
    }];
}

-(void)setConnected:(BOOL)connected {
    _connected = connected;
    BOOL newFirmware = BLUETOOTH_MANAGER.boardType == MWBluetoothManagerTypeBiscuit;
    self.BLESettingArrow.hidden = !(connected && newFirmware);
    
    self.infoLabel.text = connected ? @"Connected." :  @"* Tap to connect";
    if (connected && newFirmware) {
        self.infoLabel.text = @"Connected. Tap on arrow to see more options";
    }
    [self animateBluetoothIcon];
}

@end
