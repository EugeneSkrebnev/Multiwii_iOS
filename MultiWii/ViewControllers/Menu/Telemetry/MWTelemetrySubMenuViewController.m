//
//  MWTelemetrySubMenuViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 11/12/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWTelemetrySubMenuViewController.h"

@interface MWTelemetrySubMenuViewController ()

@end

@implementation MWTelemetrySubMenuViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" TELEMETRY ";
}

-(NSArray*) titlesForMenu
{
    return @[@"RADIO & MOTOR", @"ORIENTATION", @"GPS", @"RAW DATA FROM SENSORS", @"BATTERY", @"COMMAND CENTER PANEL"];
}

-(NSArray*) iconsForMenu
{
    return @[@"", @"",  @"pid_gps", @"pid_sensors", @"", @""];
}

-(NSArray*) subtitlesForMenu
{
    return @[@"", @"", @"", @"", @"", @""];
}

@end
