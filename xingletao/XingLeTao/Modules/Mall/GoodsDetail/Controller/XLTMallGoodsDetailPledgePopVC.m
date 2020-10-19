//
//  XLTGoodsDetailSukPopVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/10.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTMallGoodsDetailPledgePopVC.h"
#import "XLTMallPledgeTextCell.h"

@interface XLTMallGoodsDetailPledgePopVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *letaoPageDataArray;
@end

@implementation XLTMallGoodsDetailPledgePopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.letaoCloseBtn.layer.masksToBounds = YES;
    self.letaoCloseBtn.layer.cornerRadius = 23.0;
    self.contentTableView.tableFooterView = [UIView new];
    self.contentTableView.estimatedRowHeight = 44;
    self.contentTableView.estimatedSectionHeaderHeight = 0;
    self.contentTableView.estimatedSectionFooterHeight = 0;
    self.contentTableView.rowHeight = UITableViewAutomaticDimension;
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTMallPledgeTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTMallPledgeTextCell"];
    self.letaoTitleTextLabel.text = self.letaoTitleText;
 
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTMallPledgeTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTMallPledgeTextCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.letaoTextLabel.text = [self letaoTextForRowAtIndexPath:indexPath];
    cell.letaoDetailLabel.text = [self letaoDetailTextForRowAtIndexPath:indexPath];
    return cell;
}

- (NSString *)letaoTextForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return @"正品保障";
    } else if (indexPath.row == 1) {
       return @"售后无忧";
    } else if (indexPath.row == 2) {
        return @"包邮";
    } else if (indexPath.row == 3) {
        return @"购买注意事项";
    } else {
        return @"物流时效规则：";
    }
}

- (NSString *)letaoDetailTextForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return @"正品保障，购物无忧";
    } else if (indexPath.row == 1) {
       return @"为您提供售后无忧保障";
    } else if (indexPath.row == 2) {
        return @"产品包邮";
    } else if (indexPath.row == 3) {
        return @"此类商品不支持开具发票";
    } else {
        return @"1）跨境商品实际付款后72小时发出，148小时内有第一条链路信息。仓库发出的时间，不包括清关、快速配送时间。仓库发出的时间以快递公司揽件的时间为准。\n\n2）预售及特殊商品除外，如有相关发货、物流时效以公告为准。国家法定节假日，保税仓和海外仓周六周日不包含在内。\n\n3）因个人信息填写错误或因自然灾害等不可抗力因素所造成的延迟发货我司不予承担责任。\n\n4）非跨境商品实际付款后72小时内发出，以快递公司揽件的时间为准，不包括配送以及到货时间。\n\n5）72小时发货时效不包含预售、特殊商品，如有相关发货、物流时效以公告为准。\n\n";
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)letaoCloseBtnClicked:(id)sender {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.letaoBgView.transform = CGAffineTransformMakeTranslation(0, kScreenWidth);
          self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
            }];
}

@end
