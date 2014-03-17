//
//  MWBaseTableViewCell.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/8/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWBaseTableViewCell : UITableViewCell

-(void) makeInit;
+(NSString*) cellId;
+(instancetype) loadView;

@end
