//
//  XLTIncomeListVC.m
//  XingLeTao
//
//  Created by SNQU on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTIncomeListVC.h"
#import "HMSegmentedControl.h"
#import "LetaoEmptyCoverView.h"
#import "XLTIncomListFirstCell.h"
#import "XLTIncomeListCell.h"
#import "XLTUserInfoLogic.h"

@interface XLTIncomeListVC ()
@property (nonatomic ,strong) UIView *navView;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UIButton *backBtn;
@property (nonatomic ,strong) LetaoEmptyCoverView *balanceEmptyView;
@property (nonatomic ,assign) NSInteger selectIndex;
@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic ,strong) UILabel *bottomLable;

@property (nonatomic ,strong) HMSegmentedControl *segmentView;
@end

@implementation XLTIncomeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor
    [self reloadView];
    
    
}
- (void)reloadView{
    [self.view addSubview:self.navView];
    [self.contentTableView setFrame:CGRectMake(0, kTopHeight + 40, self.view.bounds.size.width, self.view.height - kTopHeight - 40 )];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.contentTableView.separatorColor = [UIColor colorWithHex:0xEBEBED];
    self.contentTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.navView addSubview:self.nameLabel];
    [self.navView addSubview:self.backBtn];
    self.contentTableView.backgroundView = nil;
    self.contentTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.segmentView];
    self.segmentView.frame = CGRectMake(0,kTopHeight, kScreenWidth, 40);
    
//    [self.view addSubview:self.bottomView];
//    [self.bottomView addSubview:self.bottomLable];
    
}
- (void)registerTableViewCells{
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTIncomListFirstCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTIncomListFirstCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTIncomeListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTIncomeListCell"];
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kBottomSafeHeight - 40, kScreenWidth, 40 + kBottomSafeHeight)];
        _bottomView.backgroundColor = [UIColor colorWithHex:0xF5F5F7];
    }
    return _bottomView;
}
- (UILabel *)bottomLable{
    if (!_bottomLable) {
        _bottomLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _bottomLable.font = [UIFont fontWithName:kSDPFRegularFont size:11];
        _bottomLable.textColor = [UIColor colorWithHex:0xA6A6A6];
        _bottomLable.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLable;
}
- (void)letaoSetupRefreshAutoFooter {

}
- (HMSegmentedControl *)segmentView{
    if (!_segmentView) {
        _segmentView = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"今日收益",@"本月收益",@"上月收益"]];
        _segmentView.frame = CGRectMake(0, 0, kScreenWidth, 40);
        _segmentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _segmentView.backgroundColor = [UIColor whiteColor];
        _segmentView.selectionIndicatorHeight = 2.0;
        _segmentView.segmentEdgeInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _segmentView.type = HMSegmentedControlTypeText;
    //    _segmentView.selectionStyle = HMSegmentedControlSelectionStyleBox;
        _segmentView.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _segmentView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentView.selectionIndicatorColor = [UIColor letaomainColorSkinColor];
        _segmentView.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]};
        _segmentView.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF8202]};
        [_segmentView addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl{
    self.selectIndex = segmentedControl.selectedSegmentIndex;
    [self letaoTriggerRefresh];
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"xinletao_nav_left_back_gray"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(letaoPopAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.contentMode = UIViewContentModeLeft;
        [_backBtn setFrame:CGRectMake(15, kStatusBarHeight, 50, 44)];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 32);
    }
    return _backBtn;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _nameLabel.text = @"乐桃收入榜";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:18];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.center = CGPointMake(self.navView.center.x, self.backBtn.center.y);
    }
    return _nameLabel;
}
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kTopHeight)];
        _navView.backgroundColor = [UIColor whiteColor];
//        UIImage *bottomCircleImage = [UIImage imageNamed:@"home_header_bg"];
//        CGFloat bottomCircleHeight = ceilf(_navView.bounds.size.width/375*35);
//        UIImageView * _bottomCircleImageView = [[UIImageView alloc] initWithImage:bottomCircleImage];
//        _bottomCircleImageView.frame = CGRectMake(0, _navView.bounds.size.height - bottomCircleHeight, _navView.bounds.size.width, bottomCircleHeight);
//        [self.navView addSubview:_bottomCircleImageView];
    }
    return _navView;
}
- (void)letaoPopAction{
    [self.navigationController popViewControllerAnimated:YES];
}
// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                         failed:(XLTBaseListRequestFailed)failed{
    XLT_WeakSelf;
    NSString *type = nil;
    switch (self.segmentView.selectedSegmentIndex) {
        case 0:
            type = @"today";
            break;
        case 1:
        type = @"cmonth";
        break;
        case 2:
        type = @"pmonth";
        break;
        default:
            break;
    }
    [XLTUserInfoLogic getIncomeListWithType:type success:^(id  _Nonnull object) {
        success(object);
    } failure:^(NSString * _Nonnull errorMsg) {
        failed(nil,errorMsg);
    }];
//    [XLTUserInfoLogic xingletaonetwork_requestTeamWithSuccess:^(id object) {
//        XLT_StrongSelf;
//        [self.headerView setModel:object];
//    } failure:^(NSString *errorMsg) {
//
//    }];
//    [self letaoShowLoading];
//    [XLTUserInfoLogic xingletaonetwork_requestTeamListWithPage:[NSString stringWithFormat:@"%ld",(long)index] row:[NSString stringWithFormat:@"%ld",(long)pageSize] sort:self.letaoSortValueType fans:self.fans search:self.searchStr success:^(id object) {
//        XLT_StrongSelf;
//        success(object);
//        [self letaoRemoveLoading];
//    } failure:^(NSString *errorMsg) {
//        XLT_StrongSelf;
//        [self showToastMessage:errorMsg];
//        [self letaoRemoveLoading];
//    }];
}
- (void)letaoShowEmptyView{
    if (self.balanceEmptyView == nil) {
        XLT_WeakSelf;
        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"xingletao_order_empty"
                                                                   titleStr:@"您还没有记录哦~"
                                                                  detailStr:@""
                                                                btnTitleStr:@""
                                                              btnClickBlock:^(){
//                                                                    XLT_StrongSelf;
                                                                   
                                                              }];
        letaoEmptyCoverView.actionBtnFont = [UIFont fontWithName:kSDPFRegularFont size:15];
        letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = YES;
        letaoEmptyCoverView.actionBtnHeight = 35;
        letaoEmptyCoverView.actionBtnTitleColor = [UIColor whiteColor];
        letaoEmptyCoverView.actionBtnCornerRadius = 17.5;
        letaoEmptyCoverView.actionBtnBackGroundColor = [UIColor colorWithHex:0xFF8202];
        letaoEmptyCoverView.contentViewOffset =  0;
        letaoEmptyCoverView.subViewMargin = 14.f;
        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:15.f];
        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(172, 172, 172);
        letaoEmptyCoverView.userInteractionEnabled = YES;
        self.balanceEmptyView = letaoEmptyCoverView;
    }
    [self.contentTableView insertSubview:self.balanceEmptyView atIndex:0];
}

- (void)letaoRemoveEmptyView {
    [self.balanceEmptyView removeFromSuperview];
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    XLTUserTeamItemListModel *model = [self.letaoPageDataArray objectAtIndex:indexPath.row];
//    [self showDetailView:model];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        XLTIncomListFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTIncomListFirstCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        XLTUserIncomListModel *model = [self.letaoPageDataArray objectAtIndex:indexPath.row];
        model.index = indexPath.row;
        cell.model = model;
        
        return cell;
    }else{
        XLTIncomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTIncomeListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        XLTUserIncomListModel *model = [self.letaoPageDataArray objectAtIndex:indexPath.row];
        model.index = indexPath.row;
        cell.model = model;
        
        return cell;
    }
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 10;
    return self.letaoPageDataArray.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 150;
    }
    return 90;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
@end
