//
//  MWAppDelegate.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 5/26/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readonly) int paidAmount;
-(BOOL) isFullVersionUnlocked;
-(void) showBuyDialogFromVC:(UIViewController*) vc;
@end
