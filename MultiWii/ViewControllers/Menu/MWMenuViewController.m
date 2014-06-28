//
//  MWMainViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWMenuViewController.h"
#import "MWMainMenuCell.h"
#import "MWMenuSubtitleCell.h"

@implementation MWMenuViewController
{

    NSArray* _titlesForCells;
    NSArray* _subtitlesForCells;
    NSArray* _imagesFileNamesForCells;
}


//static NSString* cell_ID;

-(UIImage*) imageForMenuItemAtIndex:(int) index andSelected:(BOOL) selected
{
    NSString* filename;
    if (selected)
        filename = [NSString stringWithFormat:@"%@_pressed.png", _imagesFileNamesForCells[index]];
    else
        filename = [NSString stringWithFormat:@"%@.png", _imagesFileNamesForCells[index]];
    return [UIImage imageNamed:filename];
}

-(NSArray*) titlesForMenu
{
    NSLog(@"abstract");
    return @[];
}

-(NSArray*) subtitlesForMenu
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
    

    _titlesForCells          = [self titlesForMenu];
    _imagesFileNamesForCells = [self iconsForMenu];
    _subtitlesForCells       = [self subtitlesForMenu];
    
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
    if (tableView.rowHeight * _titlesForCells.count < 320 - tableView.top)
        tableView.height = tableView.rowHeight * _titlesForCells.count;
    
    return _titlesForCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWMainMenuCell* cell;
    
    if ((_subtitlesForCells.count > indexPath.row) && ([_subtitlesForCells[indexPath.row] length] > 0))
    {
        cell = [MWMenuSubtitleCell loadView];
        [cell makeInit];
        [(MWMenuSubtitleCell*)cell setSubtitle:_subtitlesForCells[indexPath.row]];
    }
    else
    {
        cell = [MWMainMenuCell loadView];
        [cell makeInit];
    }
    
    cell.title = _titlesForCells[indexPath.row];
    cell.imageViewForIcon.image = [self imageForMenuItemAtIndex:(int)indexPath.row andSelected:NO];
    cell.selectedImageViewForIcon.image = [self imageForMenuItemAtIndex:(int)indexPath.row andSelected:YES];


    return cell;

}

-(void) cantSelectRowAtIndexPath:(NSIndexPath*) indexPath
{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        [self performSegueWithIdentifier:@(indexPath.row).stringValue sender:self];
    }
    @catch (NSException *exception)
    {
        NSLog(@"NSException !!! : %@", exception);
        
        [self.tableViewForMenu deselectRowAtIndexPath:indexPath animated:YES];
        [self cantSelectRowAtIndexPath:indexPath];
    }
}

- (void)viewDidUnload {
    [self setTableViewForMenu:nil];
    [super viewDidUnload];
}
@end
