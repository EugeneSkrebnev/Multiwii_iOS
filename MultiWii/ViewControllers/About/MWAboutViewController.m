//
//  MWAboutViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/10/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWAboutViewController.h"
#import "MWAboutDetailViewController.h"
@interface MWAboutViewController ()

@end

@implementation MWAboutViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" ABOUT ";
}

-(NSArray*) titlesForMenu
{
    return @[@"ABOUT PROGRAM", @"HOW TO CONNECT", @"ASK QUESTION", @"SUBMIT BUG", @"LEAVE FEEDBACK", @"ABOUT AUTHOR", ];
}

-(NSArray*) iconsForMenu
{
    return @[@"about_program", @"how_to_connect", @"ask", @"bug", @"feedback", @"about_author"];
}

-(void)launchMailAppWithSubject:(NSString*)subject
{
    NSString *recipients = [NSString stringWithFormat:@"mailto:multiwii.for.ios@gmail.com?subject=%@", subject];;
    
    NSString *email = [recipients stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 4)
    {
        [[iRate sharedInstance] promptForRating];
        [self.tableViewForMenu deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if (indexPath.row == 2 ||indexPath.row == 3)
    {
        if ([MFMailComposeViewController canSendMail])
        {
            [self.tableViewForMenu deselectRowAtIndexPath:indexPath animated:YES];
            [self launchMailAppWithSubject:indexPath.row == 2 ? @"Got some questions" : @"Submit a bug"];

//            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
//            NSString* subject = indexPath.row == 2 ? @"Got some question" : @"!!!BUG!!!";
//            mailViewController.mailComposeDelegate = self;
//            [mailViewController setSubject:subject];
//            [mailViewController setToRecipients:@[@"multiwii.for.ios@gmail.com"]];
//            [mailViewController setMessageBody:@"" isHTML:NO];
//            mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
//
//            [self presentModalViewController:mailViewController animated:YES];
        }
        else
        {
            [self.tableViewForMenu deselectRowAtIndexPath:indexPath animated:YES];
            [UIAlertView alertResultWithTitle:@"Error" message:@"No mail account setup on device. Go to Settings -> Mail." buttonNames:@[/*@"Go to settings",*/ @"Cancel"] block:^(UIAlertView *alert, NSInteger buttonIndex) {
//                if (buttonIndex == 0)
//                {
////                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=ACCOUNT_SETTINGS"]];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
//                }
//                else
//                {
//                    
//                }
            }];
        }
        return;
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultCancelled)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    if (result == MFMailComposeResultSaved)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    if (result == MFMailComposeResultSent)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    if (result == MFMailComposeResultFailed)
    {
        [UIAlertView alertResultWithTitle:@"Failed" message:@"Something wrong, check your internet connection" buttonNames:@[@"Return to mail", @"Cancel"] block:^(UIAlertView *alert, NSInteger buttonIndex) {
            if (buttonIndex == 0)
            {
                
            }
            else
            {
                [self dismissModalViewControllerAnimated:YES];
            }
        }];
    }
    

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    int segueId = segue.identifier.intValue;
    if ((segueId < 2) || (segueId == 5))
    {
        NSArray* titles = @[@"ABOUT PROGRAM", @"HOW TO CONNECT", @"", @"", @"", @"ABOUT AUTHOR"];
        NSArray* contentTextFilenames = @[
                                          @"about_program",
                                          @"how_to_connect",
                                          @"",
                                          @"",
                                          @"",
                                          @"about_author"
                                          ];
        NSError* err;
        NSString *path = [[NSBundle mainBundle] pathForResource:contentTextFilenames[segueId] ofType:@"html"];
        NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
        MWAboutDetailViewController* destinationVC = (MWAboutDetailViewController*)segue.destinationViewController;
        destinationVC.viewControllerTitle = titles[segueId];
        destinationVC.text = contents;
    }
}
- (IBAction)siteButtonTapped:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.multiwiiForiOS.com"]];
}

@end
