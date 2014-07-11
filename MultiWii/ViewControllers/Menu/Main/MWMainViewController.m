//
//  MWMainViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/10/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWMainViewController.h"
#import "MWSplashView.h"
@implementation MWMainViewController
{
    MWSplashView* _splash;
}
static BOOL firstTimeShow = YES;

-(void)viewWillAppear:(BOOL)animated
{
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (_splash)
    {
        self.navigationController.navigationBar.hidden = YES;
        [_splash makeFlyInAnimation];
        double delayInSeconds = _splash.animateInTime + 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.navigationController.navigationBar.hidden = NO;
            if (systemVersion < 7)
            {
                self.tableViewForMenu.top = 44; //bad dirty fix for top bar
            }
            else
            {
                self.tableViewForMenu.top = 64; //bad dirty fix for top bar
                self.tableViewForMenu.height =  self.tableViewForMenu.rowHeight * ([self titlesForMenu].count+2);//bad dirty fix for top bar
            }
  
            [UIView animateWithDuration:0.2 animations:^{
                _splash.alpha = 0;
                self.navigationController.navigationBar.alpha = 1;

            } completion:^(BOOL finished) {
                [_splash removeFromSuperview];
                _splash = nil;
                [UIView animateWithDuration:0.2 animations:^{


                }];

            }];
            
        });
    }
    else
    {
        self.tableViewForMenu.height =  self.tableViewForMenu.rowHeight * ([self titlesForMenu].count+3);//bad dirty fix for top bar
        self.tableViewForMenu.top = 0; //bad dirty fix

    }
    
    [self.buyButton setHidden:__delegate.isFullVersionUnlocked animated:YES];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.buyButton setHidden:__delegate.isFullVersionUnlocked animated:YES];
        double delayInSeconds = 4.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.buyButton setHidden:__delegate.isFullVersionUnlocked animated:YES];
        });

    });
    if (!IS_IPHONE_5)
    {
        if (self.buyButton.tag != 1)
        {
            self.buyButton.tag = 1;
            self.buyButton.top += 20;
        }
    }
}

-(NSArray*) titlesForMenu
{
    return @[@"CONNECT", @"TELEMETRY", @"SETTINGS", @"FIND MY MULTIWII"/*, @"CONTROL"*/, @"ABOUT"];//, @"YOUR BEST MULTIWII GADGETS"]; //need to update bluetooth engine for control
}

-(NSArray*) iconsForMenu
{
    return @[@"connect", @"telemetry", @"settings", @"finder"/*, @"control"*/, @"about", @"basket"];
}

-(NSArray*) subtitlesForMenu
{
    return @[@"", @"", @"", @"", @"", @"witespyquad.gostorego.com"];
}

-(void) checkFullVersion
{
    self.buyButton.hidden = __delegate.isFullVersionUnlocked;
}

-(void) doubleCheckFullVersion
{
    [self checkFullVersion];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkFullVersion];
    });
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" MAIN MENU ";

    [self doubleCheckFullVersion];
    
    if (firstTimeShow)
    {

        firstTimeShow = NO;

        if (SPASH_ENABLED_ON) // uncomment for enable splash
        {
//            self.navigationController.navigationBarHidden = YES;
            _splash = [[MWSplashView alloc] init];
            [self.view addSubview:_splash];
//            self.navigationController.navigationBar.alpha = 0;
//            [self.navigationController setNavigationBarHidden:NO animated:NO]; //Animated must be NO!
            [UINavigationBar setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UINavigationBar setAnimationDuration:1.5]; //1.5
            self.navigationController.navigationBar.alpha = 0;
            [UINavigationBar commitAnimations];
        }
    }
}

-(void) cantSelectRowAtIndexPath:(NSIndexPath*) indexPath
{
    [self.tableViewForMenu deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (indexPath.row == 5)
    {
        if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://witespyquad.gostorego.com/"]])
            [Flurry logEvent:@"Open ReadyToFly Site"];
        else
            [Flurry logEvent:@"Fail to open ReadyToFly Site"];
    }
    
}

@end
