//
//  MWMainViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWMenuViewController.h"
#import "MWMainMenuCell.h"

@implementation MWMenuViewController
{

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

-(NSArray*) titlesForMenu
{
    NSLog(@"abstract");
    return @[];
}

-(NSArray*) iconsForMenu
{
    NSLog(@"abstract");
    return @[];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if (firstTimeShow)
    {
        firstTimeShow = NO;
        
        titlesForCells          = [self titlesForMenu];
        imagesFileNamesForCells = [self iconsForMenu];

    }
    self.tableViewForMenu.dataSource = self;
    self.tableViewForMenu.delegate = self;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableViewForMenu deselectRowAtIndexPath:[self.tableViewForMenu indexPathForSelectedRow] animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titlesForCells.count;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@(indexPath.row).stringValue sender:self];
}

- (void)viewDidUnload {
    [self setTableViewForMenu:nil];
    [super viewDidUnload];
}
@end
