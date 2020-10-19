//
//  XLTQRCodeTipMessageVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTQRCodeTipMessageVC.h"

@interface XLTQRCodeTipMessageVC ()

@end

@implementation XLTQRCodeTipMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10.0;
}

- (IBAction)sureBtnClicked:(id)sender {
    [self dismissWithIndex:0];
}

- (IBAction)cancelBtnClicked:(id)sender {
    [self dismissWithIndex:1];
}

- (void)dismissWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
        if ([self.delegate respondsToSelector:@selector(qrCodeTipViewController:dismissWithIndex:)]) {
            [self.delegate qrCodeTipViewController:self dismissWithIndex:index];
        }
    }];
    
}

- (void)letaoPresentWithSourceVC:(UIViewController *)sourceViewController
                                  title:(NSString * _Nullable)title
                                message:(NSString * _Nullable)message
                         sureButtonText:(NSString * _Nullable)sureButtonText
                       cancelButtonText:(NSString * _Nullable)cancelButtonText {
    

    self.view.hidden = YES;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sourceViewController.definesPresentationContext = YES;
    [sourceViewController presentViewController:self animated:NO completion:^{
        self.view.hidden = NO;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

        self.bgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
             self.bgView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
        
        self.titleTextLabel.text = title;
        self.messageTextLabel.text = message;
        [self.sureButton setTitle:sureButtonText forState:UIControlStateNormal];
        [self.cancelButton setTitle:cancelButtonText forState:UIControlStateNormal];
        self.sureButton.hidden = sureButtonText == nil;
        self.cancelButton.hidden = cancelButtonText == nil;
        self.titleTextLabel.hidden = title == nil;
        self.messageTextLabel.hidden = message == nil;
        self.buttonSeparatorLine.hidden = (sureButtonText == nil ||cancelButtonText == nil);
    }];
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
