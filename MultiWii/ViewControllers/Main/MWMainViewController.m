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

}

-(NSArray*) titlesForMenu
{
    return @[@"CONNECT", @"TELEMETRY", @"SETTINGS", @"FIND MY MULTIWII"/*, @"CONTROL"*/, @"ABOUT"];
}

-(NSArray*) iconsForMenu
{
    return @[@"connect", @"telemetry_gray", @"settings", @"finder"/*, @"control"*/, @"about"];
}

-(void) checkFullVersion
{
    self.buyButton.hidden = __delegate.isFullVersionUnlocked;
}
-(void) doubleCheckFullVersion
{
    [self checkFullVersion];
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
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
//        TODO: remove on release
//        if (!YES) // uncomment for enable splash
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 1)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MWMainMenuCell* menuCell = (MWMainMenuCell*)cell;
        menuCell.circleImageView.hidden = YES;
        menuCell.arrowImageView.hidden = YES;
        menuCell.labelForTitle.textColor = [UIColor colorWithRed:106./255 green:106./255 blue:106./255 alpha:1];
        UIImageView* ribbonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ribbon_green.png"]];
        ribbonView.left = menuCell.width - ribbonView.width;
        ribbonView.top = 0;
        UIView* blackView = [[UIView alloc] initWithFrame:cell.bounds];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.3;
        [cell addSubview:blackView];
        [menuCell addSubview:ribbonView];
    }
    return cell;
}
@end
