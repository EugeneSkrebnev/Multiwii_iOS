//
//  UIAlertView+Alert.m
//  Gapide
//
//  Created by Vsevolod Sauta on 8/23/11.
//  Copyright 2011 Gapide Ltd. All rights reserved.
//

#import "UIAlertView+Alert.h"



@interface AlertResultHelper : NSObject <UIAlertViewDelegate> {
	int alertButtonIndex;
}
@property (nonatomic, copy) UIAlertClickedBlock finishBlock;
@end

@implementation AlertResultHelper
@synthesize  finishBlock = _finishBlock;

- (id) init
{
	self = [super init];
	alertButtonIndex = -1;
	return self;
}

- (void)dealloc {
    [_finishBlock release];
    [super dealloc];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	alertButtonIndex = buttonIndex;
    
    
    if (_finishBlock){
        _finishBlock(alertView, buttonIndex);
    }
    
    alertView.delegate = nil;
    [alertView release];
    [self release];
}

@end



@implementation UIAlertView (Alert)

+ (void) alertWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertView* alert = [[self alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

+ (void) alertErrorWithMessage:(NSString *)message
{
	[self alertWithTitle:@"Error" message:message];
}

+ (void) alertResultWithTitle:(NSString *)title message:(NSString *)message buttonNames:(NSArray *)buttonNames 
                       block:(UIAlertClickedBlock) finishBlock
{
    @synchronized(self){        
        UIAlertView* alert = [[UIAlertView alloc] init];
        alert.title = title;
        alert.message = message;
        for(NSString* buttonTitle in buttonNames)
        {
            [alert addButtonWithTitle:buttonTitle];
        }
        AlertResultHelper* helper = [[AlertResultHelper alloc] init];
        helper.finishBlock = finishBlock;
        alert.delegate = helper;
        
        [alert show];
        
        //[alert.delegate release];
        return;
    }

}

+ (void) alertWithTitle:(NSString*)title message:(NSString*)message block:(UIAlertClickedBlock) finishBlock
{
	[self alertResultWithTitle:title message:message buttonNames:@[@"OK"] block:finishBlock];
}

+ (void) alertYesNoResultWithTitle:(NSString *)title message:(NSString *)message block:(UIAlertClickedBlock) finishBlock
{
    return [UIAlertView alertResultWithTitle:title 
                                     message:message 
                                 buttonNames:@[@"NO", @"YES"] block:finishBlock];
}


@end
