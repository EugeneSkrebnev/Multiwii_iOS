//
//  MWAUXCheckBoxCell.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseTableViewCell.h"
#import "MWValueSliderContainer.h"
@interface MWTelemetryRadioValuesCell : MWBaseTableViewCell

-(void) setSettingsEntity:(MWRadioValueEntity*) settingEntity forIndex:(int) indx;
-(MWRadioValueEntity*) settingEntityForIndex:(int) ind;
@property (strong, nonatomic) IBOutletCollection(MWValueSliderContainer) NSArray *valueSliderContainers;

@end
