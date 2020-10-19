//
//  XLTIncomeHeaderView.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/27.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTIncomeHeaderView.h"
#import "XLTAlertViewController.h"

@interface XLTIncomeHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *actionView;

@end

@implementation XLTIncomeHeaderView

- (instancetype)initWithNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTIncomeHeaderView" owner:nil options:nil] lastObject];
    if (self) {
        self.contentView.layer.cornerRadius = 6;
        self.contentView.layer.masksToBounds = YES;
        self.actionView.userInteractionEnabled = YES;
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(explanAction:)];
        [self.actionView addGestureRecognizer:tap];
    }
    return self;
}

- (IBAction)explanAction:(id)sender {
    XLTAlertViewController *alertViewController = [[XLTAlertViewController alloc] init];
           alertViewController.displayNotShowButton = NO;
    alertViewController.titleFont = [UIFont fontWithName:kSDPFMediumFont size:16];
    alertViewController.leftAndRightWith = 25;
    [alertViewController letaoPresentWithSourceVC:[UIApplication sharedApplication].keyWindow.rootViewController title:@"预估收入说明" message:@"本月结算预估：\n本月内已到账的订单预估收益。\n上月结算预估：\n上个月内已到账的订单预估收益。 \n本月付款预估：\n本月内已付款的订单预估收益。\n上月付款预估：\n上个月内已付款的订单预估收益\n本月奖励金额：\n本月获得的所有奖励金额总额\n本月奖励金额：\n上个月获得的所有奖励金额总额" sureButtonText:@"知道了" cancelButtonText:nil];
}

@end
