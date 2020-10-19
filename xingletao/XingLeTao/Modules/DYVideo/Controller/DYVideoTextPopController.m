//
//  DYVideoTextPopController.m
//  XingLeTao
//
//  Created by chenhg on 2020/4/27.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "DYVideoTextPopController.h"

@interface DYVideoTextPopController ()
@property (nonatomic, weak) IBOutlet UILabel *letaoShareLabel;

@end

@implementation DYVideoTextPopController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.shareText isKindOfClass:[NSString class]]) {
        self.letaoShareLabel.text = self.shareText;
    } else {
        self.letaoShareLabel.text = nil;
        
    }
}

- (IBAction)cancelButtonAction:(id)sender {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.view.transform = CGAffineTransformMakeTranslation(0, kScreenWidth);
          self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}


- (IBAction)shareButtonAction:(id)sender {
    [UIPasteboard generalPasteboard].string = self.shareText;
    [self showTipMessage:@"复制成功!"];
    [self cancelButtonAction:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
