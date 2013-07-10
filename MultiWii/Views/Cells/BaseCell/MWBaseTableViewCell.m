//
//  MWBaseTableViewCell.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/8/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseTableViewCell.h"

@implementation MWBaseTableViewCell

-(void) makeInit
{
    
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self makeInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self makeInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self makeInit];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self makeInit];
    }
    return self;
}

+(NSString*) cellId
{
    NSLog(@"abstract. check logic");
    return @"BASE";
}

+(NSString*) xibName
{
    return NSStringFromClass(self);
}

+(MWBaseTableViewCell*) loadView
{
    MWBaseTableViewCell* res = [[[NSBundle mainBundle] loadNibNamed:[self xibName] owner:nil options:nil] lastObject];
    [res makeInit];
    return res;
}

@end
