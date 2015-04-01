//
//  MWCliViewController.m
//  
//
//  Created by Evgeniy Skrebnev on 3/30/15.
//
//

#import "MWCliViewController.h"

@interface MWCliViewController ()

@end

@implementation MWCliViewController {
    MWBluetoothManagerRecieveDataBlock saved;
}

- (void)sendInitCli {
    NSMutableData* messageToSend = [[NSMutableData alloc] init];
    unsigned char bytes[3];
    bytes[0] = (char)'#'; //begin cli
    bytes[1] = (char)'#'; //begin cli
    bytes[2] = (char)'#'; //begin cli
    [messageToSend appendData:[NSData dataWithBytes:bytes length:sizeof(bytes)]];
    [BLUETOOTH_MANAGER sendData:messageToSend];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sendInitCli];
    self.textView.text = @"";
    self.textField.delegate = self;
    saved = BLUETOOTH_MANAGER.didRecieveData;
    BLUETOOTH_MANAGER.didRecieveData = ^(CBPeripheral* connectedDevice, NSData* message)
    {
        unsigned char *x = (unsigned char*)message.bytes;
        NSMutableString *messageStr = [NSMutableString string];
        for (int i = 0; i < message.length; i++) {
            [messageStr appendFormat:@"%c", (char)x[i]];
        }
        self.textView.text = [NSString stringWithFormat:@"%@%@", self.textView.text, messageStr];
    };
    [self.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    BLUETOOTH_MANAGER.didRecieveData = saved;
}

- (void)send1:(NSString *) stringToSend {
    NSMutableData* messageToSend = [[NSMutableData alloc] init];
    unsigned char bytes[stringToSend.length];
    for (int i = 0; i < stringToSend.length; i++) {
        bytes[i] = (char)[stringToSend characterAtIndex:0];
    }
    [messageToSend appendData:[NSData dataWithBytes:bytes length:sizeof(bytes)]];
    [BLUETOOTH_MANAGER sendData:messageToSend];
    
}

- (void)send2:(NSString *) text {
    
}

- (void)send3:(NSString *) text {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *stringToSend = textField.text;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"check me" delegate:nil cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
    [self send1:stringToSend];
    
    textField.text = @"";
    return YES;
}



@end
