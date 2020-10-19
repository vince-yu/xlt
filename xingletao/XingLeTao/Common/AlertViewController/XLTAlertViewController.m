//
//  XLTQRCodeTipMessageVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTAlertViewController.h"

@interface XLTAlertViewController ()

@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UILabel *titleTextLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageTextLabel;
@property (nonatomic, weak) IBOutlet UIButton *sureButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@property (nonatomic, weak) IBOutlet UIButton *notShowButton;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonTOPConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;

@end

@implementation XLTAlertViewController

- (void)dealloc {
    self.letaoalertViewAction = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10.0;
    
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = 18.0;
    
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.cornerRadius = 18.0;
    self.cancelButton.layer.borderColor = [UIColor letaolightgreySeparatorLineSkinColor].CGColor;
    self.cancelButton.layer.borderWidth = 0.5;
    
    self.notShowButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)sureBtnClicked:(id)sender {
    [self dismissWithIndex:0];
}

- (IBAction)cancelBtnClicked:(id)sender {
    [self dismissWithIndex:1];
}

- (IBAction)notShowButtonBtnClicked:(id)sender {
    self.notShowButton.selected = !self.notShowButton.selected;
}

- (void)dismissWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
            if (self.letaoalertViewAction) {
                self.letaoalertViewAction(index,self.notShowButton.selected);
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
        self.notShowButton.hidden = !self.displayNotShowButton;
        if (self.displayNotShowButton) {
            self.buttonTOPConstraint.constant = 55.0;
            
        } else {
            self.buttonTOPConstraint.constant = 21.0;
        }
        if (self.messageFont) {
            self.messageTextLabel.font = self.messageFont;
        }
    }];
}

- (void)letaoPresentWithSourceVC:(UIViewController *)sourceViewController
           title:(NSString * _Nullable)title
         message:(NSString * _Nullable)message
messageTextAlignment:(NSTextAlignment)messageTextAlignment
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
        self.messageTextLabel.textAlignment = messageTextAlignment;
        self.notShowButton.hidden = !self.displayNotShowButton;
        if (self.displayNotShowButton) {
            self.buttonTOPConstraint.constant = 55.0;
            
        } else {
            self.buttonTOPConstraint.constant = 21.0;
        }
        if (self.messageFont) {
            self.messageTextLabel.font = self.messageFont;
        }
    }];
}

#pragma mark Font....
- (void)setTitleFont:(UIFont *)font{
    self.titleTextLabel.font = font;
}
- (void)setLeftAndRightWith:(CGFloat)leftAndRightWith{
    self.contentWidth.constant = kScreenWidth * 280 / 375.0 - 2 * leftAndRightWith;
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
