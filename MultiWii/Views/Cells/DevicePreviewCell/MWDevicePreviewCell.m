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
    self.bluetoothIconPressed.hidden = NO;// YES;
    [self animateBluetoothIcon];
    self.connected = YES;
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
    NSLog(@"%@", @(BLUETOOTH_MANAGER.boardType));
    self.BLESettingArrow.hidden = !(connected && BLUETOOTH_MANAGER.boardType == MWBluetoothManagerTypeBiscuit);
}

@end
