#import "UIViewAdditions.h"

@implementation UIView (EugeneAdditions)

- (CGFloat)left
{
  return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}

- (CGFloat)right
{
  return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
  CGRect frame = self.frame;
  frame.origin.x = right - frame.size.width;
  self.frame = frame;
}

- (CGFloat)top
{
  return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

- (CGFloat)bottom
{
  return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
  CGRect frame = self.frame;
  frame.origin.y = bottom - frame.size.height;
  self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

- (CGFloat)width
{
  return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

- (CGFloat)height
{
  return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

-(void) setHidden:(BOOL)hidden animated:(BOOL) animated
{
    [self setHidden:hidden animated:animated duration:0.3];
}

-(void) setHidden:(BOOL)hidden animated:(BOOL) animated duration:(NSTimeInterval) duration
{
    [self setHidden:hidden animated:animated duration:duration onCompletion:nil];
}

-(void) setHidden:(BOOL)hidden animated:(BOOL) animated onCompletion:(void(^)()) completionBlock
{
    [self setHidden:hidden animated:animated duration:0.3 onCompletion:completionBlock];
}

-(void) setHidden:(BOOL)hidden animated:(BOOL) animated duration:(NSTimeInterval) duration onCompletion:(void(^)()) completionBlock
{
    if (hidden == self.hidden)
        return;
    if (!animated)
    {
        self.hidden = hidden;
    }
    else
    {
        CGFloat savedAlpha = self.alpha;
        if (hidden)
            [UIView animateWithDuration:duration animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                if (self.layer.animationKeys.count == 0)
                    self.hidden = YES;
                self.alpha = savedAlpha;
                if (completionBlock)
                    completionBlock();
            }];
        else
        {
            self.alpha = 0;
            self.hidden = NO;
            [UIView animateWithDuration:duration animations:^{
                self.alpha = savedAlpha;
            } completion:^(BOOL finished) {
                if (completionBlock)
                    completionBlock();
            }];
        }
    }
}
@end
