//
//  XLTUserInviteSucceedVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/7.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserInviteSucceedVC.h"

@interface XLTUserInviteSucceedVC ()
@property (nonatomic, weak) IBOutlet UIButton *sureButton;
@property (nonatomic, weak) IBOutlet UIView *bgView;

@end

@implementation XLTUserInviteSucceedVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = 17.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)bgTap:(UITapGestureRecognizer *)tap {
    if (!CGRectContainsPoint(self.bgView.frame, [tap locationInView:self.view])
        || CGRectContainsPoint(self.sureButton.frame, [tap locationInView:self.view])) {
        [self sureBtnClicked:nil];
    }
}


- (IBAction)sureBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];;
}


- (void)letaoPresentWithSourceVC:(UIViewController *)sourceViewController {
    self.view.hidden = YES;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sourceViewController.definesPresentationContext = YES;
    [sourceViewController presentViewController:self animated:NO completion:^{
        self.view.hidden = NO;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        } completion:^(BOOL finished) {
        }];
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
