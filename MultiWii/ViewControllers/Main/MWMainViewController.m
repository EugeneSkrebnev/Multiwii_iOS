//
//  MWMainViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWMainViewController.h"
#import "MWSplashView.h"

@implementation MWMainViewController
{
    MWSplashView* _splash;
}
static BOOL firstTimeShow = YES;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if (firstTimeShow)
    {
        firstTimeShow = NO;
//        _splash = [[MWSplashView alloc] init];
//        [self.view addSubview:_splash];
        self.navigationController.navigationBarHidden = YES;
        if (!_splash)
            self.navigationController.navigationBarHidden = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if (_splash)
    {
        [_splash makeFlyInAnimation];
        double delayInSeconds = _splash.animateInTime + 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:0.2 animations:^{
                _splash.alpha = 0;
            } completion:^(BOOL finished) {
                [_splash removeFromSuperview];
                _splash = nil;
                self.navigationController.navigationBarHidden = NO;
            }];

            
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return cell;
}



@end
