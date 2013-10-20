//
//  UIAlertView+Alert.h
//  Gapide
//
//  Created by Vsevolod Sauta on 8/23/11.
//  Copyright 2011 Gapide Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UIAlertClickedBlock)(UIAlertView* alert, NSInteger buttonIndex);

@interface UIAlertView (Alert)

+ (void) alertWithTitle:(NSString*)title message:(NSString*)message;
+ (void) alertErrorWithMessage: (NSString*) message;

+ (void) alertYesNoResultWithTitle:(NSString *)title message:(NSString *)message block:(UIAlertClickedBlock) finishBlock;
+ (void) alertWithTitle:(NSString*)title message:(NSString*)message block:(UIAlertClickedBlock) finishBlock;
+ (void) alertResultWithTitle:(NSString *)title message:(NSString *)message buttonNames:(NSArray *)buttonNames 
                        block:(UIAlertClickedBlock) finishBlock;
@end
