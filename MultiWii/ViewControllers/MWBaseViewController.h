//
//  MWBaseViewController.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWBaseViewController : UIViewController
-(UIView*) viewForTitle:(NSString*) title;
@property (nonatomic, strong) NSString* viewControllerTitle;
@end
