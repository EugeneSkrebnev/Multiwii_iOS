//
//  MWMainViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWMainViewController.h"
#import "MWSplashView.h"
#import "MWMainMenuCell.h"

@implementation MWMainViewController
{
    MWSplashView* _splash;
    NSArray* titlesForCells;
    NSArray* imagesFileNamesForCells;
}

static BOOL firstTimeShow = YES;
static NSString* cell_ID;

-(UIImage*) imageForMenuItemAtIndex:(int) index andSelected:(BOOL) selected
{
    NSString* filename;
    if (selected)
        filename = [NSString stringWithFormat:@"%@_pressed.png", imagesFileNamesForCells[index]];
    else
        filename = [NSString stringWithFormat:@"%@.png", imagesFileNamesForCells[index]];
    return [UIImage imageNamed:filename];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if (firstTimeShow)
    {
        firstTimeShow = NO;
//        _splash = [[MWSplashView alloc] init];
//        [self.view addSubview:_splash];  // uncomment for enable splash
        self.navigationController.navigationBarHidden = YES;
        if (!_splash)
            self.navigationController.navigationBarHidden = NO;
        
        titlesForCells          = @[@"CONNECT", @"TELEMETRY", @"SETTINGS", @"CONTROL", @"ABOUT"];
        imagesFileNamesForCells = @[@"connect", @"telemetry", @"settings", @"control", @"about"];

    }
    self.tableViewForMenu.dataSource = self;
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
    if (!cell_ID)
        cell_ID = [MWMainMenuCell cellId];
    
    MWMainMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:cell_ID];
    
    [cell makeInit];
    cell.title = titlesForCells[indexPath.row];
    
    cell.imageViewForIcon.image = [self imageForMenuItemAtIndex:indexPath.row andSelected:NO];
    cell.selectedImageViewForIcon.image = [self imageForMenuItemAtIndex:indexPath.row andSelected:YES];
    
    return cell;
}



- (void)viewDidUnload {
    [self setTableViewForMenu:nil];
    [super viewDidUnload];
}
@end
