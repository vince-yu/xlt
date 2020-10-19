//
//  XLTCancelAccountResultVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTCancelAccountResultVC.h"
#import "XLTCancelAccountLogic.h"

@interface XLTCancelAccountResultVC ()
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation XLTCancelAccountResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.timeLabel.text = self.time ? [NSString stringWithFormat:@"提交时间：%@",[[NSString stringWithFormat:@"%@",_time] convertDateStringWithSecondTimeStr:@"yyyy-MM-dd"]] : @"";
}

- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self letaoShowLoading];
    XLT_WeakSelf;
    [XLTCancelAccountLogic requestRevocationCancelAccountSuccess:^(NSDictionary * _Nonnull info) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showTipMessage:@"撤销成功！"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showTipMessage:errorMsg];
    }];
}
- (void)setTime:(NSNumber *)time{
    _time = time;
    
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
