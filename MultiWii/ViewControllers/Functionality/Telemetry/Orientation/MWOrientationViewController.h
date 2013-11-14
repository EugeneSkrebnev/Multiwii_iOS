//
//  MWOrientationViewController.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 11/12/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWTelemetryBaseViewController.h"
#import "MW3dModelView.h"
@interface MWOrientationViewController : MWTelemetryBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet MW3dModelView *model3dView;

@end
