//
//  MWAboutViewController.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/10/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWMenuViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MWVisitSiteButton.h"
@interface MWAboutViewController : MWMenuViewController<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MWVisitSiteButton *siteButton;

@end
