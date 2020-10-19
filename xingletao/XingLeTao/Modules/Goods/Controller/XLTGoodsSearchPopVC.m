//
//  XLTGoodsSearchPopVC.m
//
//
//  Created by chenhg on 2019/12/13.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsSearchPopVC.h"
#import "XLTPopTaskViewManager.h"

@interface XLTGoodsSearchPopVC ()
@property (nonatomic, copy) NSString *searchText;

@end

@implementation XLTGoodsSearchPopVC

- (void)dealloc {
    self.popViewControllerSearchAction = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)searchBtnAction:(id)sender {
    [self dismissWithSearchText:self.searchText];
}

- (IBAction)closeBtnAction:(id)sender {
    [self dismissWithSearchText:nil];
}

- (void)presentWithSourceViewController:(UIViewController *)sourceViewController
                               searchText:(NSString * _Nullable)searchText {
    if (![searchText isKindOfClass:[NSString class]]) {
        searchText = @"";
    }
    self.searchText = searchText;
    self.view.hidden = YES;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sourceViewController.definesPresentationContext = YES;
    [sourceViewController presentViewController:self animated:NO completion:^{
        self.view.hidden = NO;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.goodsLabel.text = searchText;
        self.bgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
             self.bgView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }];
}

- (void)dismissWithSearchText:(NSString * _Nullable)searchText  {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:^{
                if (searchText && self.popViewControllerSearchAction) {
                    self.popViewControllerSearchAction(searchText);
                }
            }];
            [[XLTPopTaskViewManager shareManager] removePopedView:self];
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
