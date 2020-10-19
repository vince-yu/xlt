//
//  XLTUserAliPayInfoVC.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserAliPayInfoVC.h"
#import "XLTUserAliPayListTableViewCell.h"
#import "XLTUserInfoLogic.h"
#import "XLTUserBindAliPayVC.h"

@interface XLTUserAliPayInfoVC ()
//@property (nonatomic ,strong) NSArray *letaoPageDataArray;
@end

@implementation XLTUserAliPayInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定支付宝";
}
- (NSString *)getDateMonthWith:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
    [self letaoTriggerRefresh];
    
}
- (void)letaoSetupRefreshAutoFooter {

}
// registerTableViewCells should overwrite by sub class
- (void)registerTableViewCells{
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTUserAliPayListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTUserAliPayListTableViewCell"];
}

- (void)letaoShowLoading{
    
}
// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                         failed:(XLTBaseListRequestFailed)failed{
    
    [XLTUserInfoLogic xingletaonetwork_requestAlipayInfoWithSuccess:^(id balance) {
        if (!balance) {
            return ;
        }
//        self.letaoPageDataArray = @[balance];
        success(@[balance]);
    } failure:^(NSString *errorMsg) {
        
    }];
}
- (void)pushToBindAlipayVC{
    XLTUserBindAliPayVC *aboutvc = [[XLTUserBindAliPayVC alloc] init];
    aboutvc.infoDic = [self.letaoPageDataArray objectAtIndex:0];
    [self.navigationController pushViewController:aboutvc animated:YES];
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTUserAliPayListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTUserAliPayListTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.model = [self.dataDic objectAtIndex:indexPath.row];
    XLT_WeakSelf;
    cell.model = [self.letaoPageDataArray objectAtIndex:indexPath.row];
    cell.editBlock = ^{
        XLT_StrongSelf;
        [self pushToBindAlipayVC];
    };
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.letaoPageDataArray.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
@end
