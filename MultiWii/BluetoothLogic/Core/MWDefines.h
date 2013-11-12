//
//  MWDefines.h
//  TestCoreBl
//
//  Created by Eugene Skrebnev on 6/16/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IOS7 !([[[UIDevice currentDevice] systemVersion] floatValue] < 7)
#define IOS_VER ([[[UIDevice currentDevice] systemVersion] floatValue])
#define __delegate ((MWAppDelegate*)[[UIApplication sharedApplication] delegate])

#define SPASH_ENABLED_ON NO
//#define SPASH_ENABLED_ON YES
#define WRITE_UART_MESSAGES YES

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

static NSString *const kDidDisconnectWithErrorNotification = @"__didDisconnectWithErrorNotification__";
#define PROTOCOL_MANAGER [MWGlobalManager sharedInstance].protocolManager
#define BLUETOOTH_MANAGER [MWGlobalManager sharedInstance].bluetoothManager
#define PID_MANAGER [MWGlobalManager sharedInstance].pidManager
