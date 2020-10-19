//
//  XLTIncomeNomalHeaderVIew.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/27.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTIncomeNomalHeaderVIew.h"
#import "XLTAlertViewController.h"

@interface XLTIncomeNomalHeaderVIew ()

@end

@implementation XLTIncomeNomalHeaderVIew
- (instancetype)initWithNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTIncomeNomalHeaderVIew" owner:nil options:nil] lastObject];
    if (self) {
        self.userInteractionEnabled = YES;
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(explanAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)explanAction:(id)sender {
    if (self.explanIndex == 1) {
        XLTAlertViewController *alertViewController = [[XLTAlertViewController alloc] init];
               alertViewController.displayNotShowButton = NO;
        alertViewController.titleFont = [UIFont fontWithName:kSDPFMediumFont size:16];
        alertViewController.leftAndRightWith = 25;
        [alertViewController letaoPresentWithSourceVC:[UIApplication sharedApplication].keyWindow.rootViewController title:@"今日数据说明" message:@"付款笔数：\n今日所有付款的订单数量，只包含有效订单。\n预计收入：\n今日内创建的有效订单预估返利。" sureButtonText:@"知道了" cancelButtonText:nil];
    }else{
        XLTAlertViewController *alertViewController = [[XLTAlertViewController alloc] init];
               alertViewController.displayNotShowButton = NO;
        alertViewController.titleFont = [UIFont fontWithName:kSDPFMediumFont size:16];
        alertViewController.leftAndRightWith = 25;
        [alertViewController letaoPresentWithSourceVC:[UIApplication sharedApplication].keyWindow.rootViewController title:@"昨日数据说明" message:@"付款笔数：\n昨日所有付款的订单数量，只包含有效订单。\n预计收入：\n昨日内创建的有效订单预估返利。 " sureButtonText:@"知道了" cancelButtonText:nil];
    }
}

@end
