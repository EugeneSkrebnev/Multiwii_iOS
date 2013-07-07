//
//  MAQuadrocopterFrame.h
//  testanimation
//
//  Created by Eugene Skrebnev on 6/30/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAQuadrocopterFrame : UIView
{
    UIImageView* _propellers[4];
    UIImageView* _propellersRings[4];
    UIImageView* _background;
    UIImageView* _centerView;
    BOOL animating;
    BOOL animatingProps;
}

- (void) startSpin;
- (void) stopSpin;
- (void) stopPropSpin;
@end
