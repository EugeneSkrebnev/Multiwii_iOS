//
//  MWAppDelegate.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 5/26/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWAppDelegate.h"
#import "MKStoreManager.h"
#import "MKSKProduct.h"
#import "MWBuyFullVersionViewController.h"
#import "MWMainViewController.h"


@implementation MWAppDelegate
{
    int _paidAmount;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MWGlobalManager sharedInstance]; //init all systems
    [MWGlobalManager initBluetoothLink]; //connect protocol manager to bluetooth
    [Flurry startSession:@"R8W8QZ9G3B6PN8JVTHPX"];
    [iRate sharedInstance].applicationName = @"Multiwii Configurator";
    [iRate sharedInstance].appStoreID = 735311586;
    [iRate sharedInstance].daysUntilPrompt = 10;
    [iRate sharedInstance].usesUntilPrompt = 12;
    
    BLUETOOTH_MANAGER.didDisconnectWithErrorBlock =
    ^(NSError* err, CBPeripheral* device){
        [UIAlertView alertErrorWithMessage:[NSString stringWithFormat:@"%@ Please reconnect.", err.localizedDescription]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidDisconnectWithErrorNotification object:nil];
    };
    
//    BLUETOOTH_MANAGER.didUpdateStateBlock = ^{ //leak? looks like leak
//        if (!BLUETOOTH_MANAGER.isReadyToUse)
//        {
////            [UIAlertView alertErrorWithMessage:@"Please turn bluetooth on"];
//        }
//    };
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"FULL_VERSION_UNLOCKED"] boolValue])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"FULL_VERSION_UNLOCKED"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    double delayInSeconds = 30.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ((self.paidAmount == 0) && [[[NSUserDefaults standardUserDefaults] objectForKey:@"FULL_VERSION_UNLOCKED"] boolValue])
        {
            [UIAlertView alertWithTitle:@"Error use restore purchase please" message:@"Vodka, Lukashenko, Belarus, Potatoes"];
            [Flurry logEvent:@"Hacker detected"];
        }
    });
    
//    [[MKStoreManager sharedManager] removeAllKeychainData]; // TODO: remove on release //for in app testing

    return YES;

}

-(int)paidAmount
{
    return 100;
    _paidAmount = 0;
    for (int i = 5; i <= 20; i++)
    {
        NSString* featureID = [NSString stringWithFormat:kFeatureId, i]; // refactor to macros with param
        if ([MKStoreManager isFeaturePurchased:featureID])
        {
            _paidAmount += i;
        }
    }

    return _paidAmount;
}

-(void) showBuyDialogFromVC:(UIViewController*) vc
{
    [Flurry logEvent:@"Show buy dialog"];    
    NSString* message = @"This function is availiable only in full version. Buy it now?";
    [UIAlertView alertResultWithTitle:@"Multiwii Configurator" message:message buttonNames:@[@"NO", @"YES"] block:^(UIAlertView *alert, NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            [Flurry logEvent:@"Buy dialog 'Yes' tapped"];
            NSString* buyVcId = @"MWBuyFullVersionViewControllerID";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"StoryboardiPhone" bundle:nil];
            MWBuyFullVersionViewController *buyVC = (MWBuyFullVersionViewController*)[storyboard instantiateViewControllerWithIdentifier:buyVcId];
//            [vc presentModalViewController:buyVC animated:YES];
            [vc presentViewController:buyVC animated:YES completion:nil];
        } else
        {
            [Flurry logEvent:@"Buy dialog 'No' tapped"];
        }
    }];

}

-(BOOL) isFullVersionUnlocked
{
    return self.paidAmount >= 5;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]])
        
    {
        UINavigationController* nvc = (UINavigationController*)self.window.rootViewController;
        NSLog(@"%@", self.window.rootViewController.navigationController.topViewController);
        if ([nvc.viewControllers.lastObject isKindOfClass:[MWMainViewController class]])
            [nvc.viewControllers.lastObject viewWillAppear:NO];
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
