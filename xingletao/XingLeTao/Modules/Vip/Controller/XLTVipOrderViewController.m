//
//  XLTVipOrderViewController.m
//  XingLeTao
//
//  Created by SNQU on 2019/12/2.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTVipOrderViewController.h"

#import "XLTVipOrderCell.h"
#import "XLTUserBalanceHeadView.h"
#import "XLTVipLogic.h"
#import "LetaoEmptyCoverView.h"
#import "XLTCustomPickDateView.h"
#import "MJRefresh.h"
#import "XLTHomeCustomHeadView.h"
#import "UIView+Extension.h"
#import "XLTVipOrderListModel.h"
#import "XLTLogisticsView.h"
#import "XLTMallGoodsDetailVC.h"

@interface XLTVipOrderViewController ()
//@property (nonatomic ,strong) NSArray *letaoPageDataArray;
@property (nonatomic ,strong) LetaoEmptyCoverView *balanceEmptyView;
@property (nonatomic ,strong) UIView *navView;

@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UIButton *backBtn;
@end

@implementation XLTVipOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reloadView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
}

- (void)reloadView{
    [self.view insertSubview:self.navView atIndex:0];
    [self.contentTableView setFrame:CGRectMake(10, kTopHeight, self.view.bounds.size.width -  20, self.view.height - kTopHeight)];
    [self.navView addSubview:self.nameLabel];
    [self.navView addSubview:self.backBtn];
    self.contentTableView.backgroundView = nil;
    self.contentTableView.backgroundColor = [UIColor clearColor];
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"xinletao_nav_left_back_gray"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(letaoPopAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.contentMode = UIViewContentModeLeft;
        [_backBtn setFrame:CGRectMake(15, kStatusBarHeight + 12, 50, 18)];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 32);
    }
    return _backBtn;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _nameLabel.text = @"会员升级订单";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:19];
        _nameLabel.textColor = [UIColor colorWithHex:0x131413];
        _nameLabel.center = CGPointMake(self.navView.center.x, self.backBtn.center.y);
    }
    return _nameLabel;
}
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kTopHeight)];
        _navView.backgroundColor = [UIColor whiteColor];
    }
    return _navView;
}
- (void)pushAddressView:(NSIndexPath *)index{
    XLTLogisticsView *view = [[XLTLogisticsView alloc] initWithNib];
    view.model = [self.letaoPageDataArray objectAtIndex:index.section];
    [view show];
}
- (void)letaoPopAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSString *)getDateMonthWith:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}
// registerTableViewCells should overwrite by sub class
- (void)registerTableViewCells{
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTVipOrderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTVipOrderCell"];
}

- (void)letaoShowLoading{
    
}
// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                         failed:(XLTBaseListRequestFailed)failed{
    [XLTVipLogic getVipOderListWithPage:[NSString stringWithFormat:@"%ld",(long)index] row:[NSString stringWithFormat:@"%ld",(long)pageSize] success:^(id  _Nonnull object) {
        XLTVipOrderListModel *model = [[XLTVipOrderListModel alloc] init];
//        model.user_addr = [[XLTVipOrderAddress alloc] init];
//        model.user_addr.full_addr = @"四川省成都市武侯区天府新谷10号楼 802室 ";
//        model.express_com = @"中通快递";
//        model.express_no = @"221156688446874";
//        object = @[model,model];
        success(object);
    } failure:^(NSString * _Nonnull errorMsg) {
        failed(nil,errorMsg);
    }];
}
- (void)letaoShowEmptyView{
    if (self.balanceEmptyView == nil) {
        LetaoEmptyCoverView *emptyView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"page_empty"
                                                                   titleStr:@"您还没有订单记录哦~"
                                                                  detailStr:@""
                                                                btnTitleStr:@""
                                                              btnClickBlock:^(){
                                                                  // do nothings
                                                              }];
//        emptyView.contentViewOffset =  100;
        emptyView.subViewMargin = 14.f;
        emptyView.titleLabFont = [UIFont systemFontOfSize:15.f];
        emptyView.titleLabTextColor = UIColorMakeRGB(172, 172, 172);
        emptyView.userInteractionEnabled = NO;
        self.balanceEmptyView = emptyView;
    }
    [self.contentTableView addSubview:self.balanceEmptyView];
}

- (void)letaoRemoveEmptyView {
    [self.balanceEmptyView removeFromSuperview];
}

#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTVipOrderListModel *model = [self.letaoPageDataArray objectAtIndex:indexPath.section];
    XLTMallGoodsDetailVC *mallGoodsDetailVC = [[XLTMallGoodsDetailVC alloc] init];
    mallGoodsDetailVC.mallGoodsId = model.goods_id;
    [self.navigationController pushViewController:mallGoodsDetailVC animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTVipOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTVipOrderCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    XLTVipOrderListModel *model = [self.letaoPageDataArray objectAtIndex:indexPath.section];

    cell.model = model;
    
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return self.letaoPageDataArray.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 162;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.letaoPageDataArray.count - 1) {
        return 10;
    }
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
@end
