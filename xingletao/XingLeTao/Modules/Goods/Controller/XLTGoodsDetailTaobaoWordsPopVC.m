//
//  XLTGoodsDetailTaobaoWordsPopVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/13.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsDetailTaobaoWordsPopVC.h"

@interface XLTGoodsDetailTaobaoWordsPopVC ()

@end

@implementation XLTGoodsDetailTaobaoWordsPopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.letaoSureBtn.layer.masksToBounds = YES;
    self.letaoSureBtn.layer.cornerRadius = 18.0;
    
    
    self.letaoBgView.layer.masksToBounds = YES;
    self.letaoBgView.layer.cornerRadius = 10.0;
}

- (IBAction)sureBtnClicked:(id)sender {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.letaoBgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
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
