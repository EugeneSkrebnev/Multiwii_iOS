//
//  MWAboutDetailViewController.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/28/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseViewController.h"

@interface MWAboutDetailViewController : MWBaseViewController


@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSString* text;
@end
