//
//  MWAuxSelectViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWAuxSelectViewController.h"
#import "MWHeader3LabelView.h"
#import "MWAUXCheckBoxCell.h"
#import "MWTopbarButton.h"

@interface MWAuxSelectViewController ()

@end

@implementation MWAuxSelectViewController
{
    int _savedSelectedSegmentIndex;
}
-(void) customizeSegmentControl
{
    self.segmentControlForAuxChannel.height = 45;
    [self.segmentControlForAuxChannel setBackgroundImage:[[UIImage imageNamed:@"center_normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentControlForAuxChannel setBackgroundImage:[[UIImage imageNamed:@"center_pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    if (IOS_VER > 5)
        [self.segmentControlForAuxChannel setBackgroundImage:[[UIImage imageNamed:@"center_pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [self.segmentControlForAuxChannel setDividerImage:[UIImage imageNamed:@"separator_normal_normal.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentControlForAuxChannel setDividerImage:[UIImage imageNamed:@"separator_left_pressed.png"] forLeftSegmentState:UIControlStateHighlighted rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentControlForAuxChannel setDividerImage:[UIImage imageNamed:@"separator_right_pressed.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    
    [self.segmentControlForAuxChannel setDividerImage:[UIImage imageNamed:@"separator_left_pressed.png"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentControlForAuxChannel setDividerImage:[UIImage imageNamed:@"separator_right_pressed.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [self.segmentControlForAuxChannel setDividerImage:[UIImage imageNamed:@"separator_two_pressed.png"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [self.segmentControlForAuxChannel setDividerImage:[UIImage imageNamed:@"separator_two_pressed.png"] forLeftSegmentState:UIControlStateHighlighted rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    

    
    
    [self.segmentControlForAuxChannel setContentPositionAdjustment:UIOffsetMake(0, -2) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
    
    [self.segmentControlForAuxChannel setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor lightGrayColor],
                            UITextAttributeFont: [UIFont fontWithName:@"Montserrat-Bold" size:14],
                UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)]} forState:UIControlStateNormal];
    
    [self.segmentControlForAuxChannel setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor]/*[UIColor colorWithRed:250./255 green:33./255 blue:8./255 alpha:1]*/,
                            UITextAttributeFont: [UIFont fontWithName:@"Montserrat-Bold" size:14],
                UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)]} forState:UIControlStateHighlighted];
    [self.segmentControlForAuxChannel setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor colorWithRed:250./255 green:33./255 blue:8./255 alpha:1],
                                                               UITextAttributeFont: [UIFont fontWithName:@"Montserrat-Bold" size:14],
                                                               UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)]} forState:UIControlStateSelected];
    
//
}

-(void) initSwipeGR
{
    UISwipeGestureRecognizer* swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer* swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    
}

-(void) didSwipe:(UISwipeGestureRecognizer*) swipeGR
{
    if (swipeGR.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (self.segmentControlForAuxChannel.selectedSegmentIndex != 0)
            [self.segmentControlForAuxChannel setSelectedSegmentIndex:self.segmentControlForAuxChannel.selectedSegmentIndex - 1];
    }
    if (swipeGR.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (self.segmentControlForAuxChannel.selectedSegmentIndex != self.segmentControlForAuxChannel.numberOfSegments - 1)
            [self.segmentControlForAuxChannel setSelectedSegmentIndex:self.segmentControlForAuxChannel.selectedSegmentIndex + 1];
    }
    [self auxChannelChanged];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" AUX ";
    
    for (int i = 1; i <= 4; i++)
    {
        [self.segmentControlForAuxChannel setTitle:[NSString stringWithFormat:@"AUX %d", i] forSegmentAtIndex:i - 1];
    }
    [self.segmentControlForAuxChannel addTarget:self action:@selector(auxChannelChanged) forControlEvents:(UIControlEventValueChanged)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    [self customizeSegmentControl];
    [self createReadWriteBtns];
    [self initSwipeGR];
}


-(void) auxChannelChanged
{
//    [self.tableView reloadData];
    UITableViewRowAnimation  rowAnimation = UITableViewRowAnimationNone;

    if (_savedSelectedSegmentIndex < self.segmentControlForAuxChannel.selectedSegmentIndex)
        rowAnimation = UITableViewRowAnimationLeft;
    if (_savedSelectedSegmentIndex > self.segmentControlForAuxChannel.selectedSegmentIndex)
        rowAnimation = UITableViewRowAnimationRight;
    if (rowAnimation != UITableViewRowAnimationNone)
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:rowAnimation];
    
}

-(void) createReadWriteBtns
{
    MWTopbarButton* readTopButton = [[MWTopbarButton alloc] init];
    MWTopbarButton* writeTopButton = [[MWTopbarButton alloc] init];
    int spaceBetweenbtns = 2;
    [readTopButton addTarget:self action:@selector(readBoxesButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    [writeTopButton addTarget:self action:@selector(writeBoxesButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    [readTopButton setTitle:@"READ" forState:(UIControlStateNormal)];
    [writeTopButton setTitle:@"WRITE" forState:(UIControlStateNormal)];
    
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, readTopButton.width + writeTopButton.width + spaceBetweenbtns, readTopButton.height)];
    [container addSubview:readTopButton];
    writeTopButton.left = readTopButton.width + spaceBetweenbtns;
    [container addSubview:writeTopButton];
    UIBarButtonItem* rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:container];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BLUETOOTH_MANAGER.didFailToFindService = ^(NSError* err, CBPeripheral* device)
    {
        if (!device)
        {
            [UIAlertView alertErrorWithMessage:@"No connected device. Please connect first."];
        }
    };
    [self readBoxesButtonTapped];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    BLUETOOTH_MANAGER.didFailToFindService = nil;
}


-(void) readBoxesButtonTapped
{
    [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_GET_BOX_NAMES andPayload:nil responseBlock:^(NSData *recieveData) {
        NSLog(@"boxes names read success");
        [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_GET_BOXES andPayload:nil responseBlock:^(NSData *recieveData) {
            NSLog(@"boxes values read success");
            [self.tableView reloadData];
        }];
        
    }];
}

-(void) writeBoxesButtonTapped
{
    
    if (__delegate.isFullVersionUnlocked)
    {
        [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_SET_BOXES
                                 andPayload:[[MWGlobalManager sharedInstance].boxManager payloadFromBoxes]
                              responseBlock:^(NSData *recieveData) {
                                  NSLog(@"write success");
                              }];
    }
    else
    {
        [__delegate showBuyDialogFromVC:self];
    }

}


- (void)viewDidUnload {
    [self setSegmentControlForAuxChannel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MWHeader3LabelView* headerView = [[MWHeader3LabelView alloc] init];
    headerView.leftCap = 20;
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _savedSelectedSegmentIndex = self.segmentControlForAuxChannel.selectedSegmentIndex;
    return [[MWGlobalManager sharedInstance].boxManager boxesCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWAUXCheckBoxCell* cell = (MWAUXCheckBoxCell*)[MWAUXCheckBoxCell loadView];
    MWBoxAuxSettingEntity* box = [[MWGlobalManager sharedInstance].boxManager boxEntityForIndex:indexPath.row];
    cell.data = box;
    cell.selectedAuxChannel = self.segmentControlForAuxChannel.selectedSegmentIndex;

    return cell;
}


@end
