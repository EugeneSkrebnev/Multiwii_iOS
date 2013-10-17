#import <UIKit/UIKit.h>

@interface UIView (EugeneAdditions)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

-(void) setHidden:(BOOL)hidden animated:(BOOL) animated;
-(void) setHidden:(BOOL)hidden animated:(BOOL) animated duration:(NSTimeInterval) duration;
-(void) setHidden:(BOOL)hidden animated:(BOOL) animated onCompletion:(void(^)()) completionBlock;
-(void) setHidden:(BOOL)hidden animated:(BOOL) animated duration:(NSTimeInterval) duration onCompletion:(void(^)()) completionBlock;
@end
