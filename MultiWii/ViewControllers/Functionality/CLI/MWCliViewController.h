//
//  MWCliViewController.h
//  
//
//  Created by Evgeniy Skrebnev on 3/30/15.
//
//

#import "MWBaseViewController.h"

@interface MWCliViewController : MWBaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
