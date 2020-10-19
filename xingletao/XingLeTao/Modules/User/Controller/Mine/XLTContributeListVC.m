//
//  XLTMyMemberRankVC.m
//  XingLeTao
//
//  Created by SNQU on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//




#import "XLTContributeListVC.h"
#import "LetaoEmptyCoverView.h"
#import "XLTContributeCell.h"
#import "XLTMemberSortView.h"
#import "XLTUserInfoLogic.h"
#import "MJRefreshAutoNormalFooter.h"
//#import "SPButton.h"



@interface XLTContributeListVC ()<XLTMemberSortViewDelegate>
@property (nonatomic ,strong) UIView *navView;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UIButton *backBtn;
@property (nonatomic ,strong) LetaoEmptyCoverView *balanceEmptyView;
@property (nonatomic ,assign) NSInteger selectIndex;
@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic ,strong) UILabel *bottomLable;

@property (nonatomic ,strong) UIView *sortView;
@property (nonatomic ,strong) UILabel *sort1Label;
@property (nonatomic ,strong) UILabel *sort2Label;
@property (nonatomic ,strong) UILabel *sort3Label;
@property (nonatomic ,strong) UILabel *sort4Label;
@property (nonatomic ,strong) UIImageView *sort3ImageView;
@property (nonatomic ,strong) UIImageView *sort4ImageView;

@property (nonatomic ,strong) NSString *sortNewtypeStr;
@property (nonatomic ,assign) XLTContributeType type;
@property (nonatomic ,strong) NSString *relationStr;
@property (nonatomic ,assign) NSInteger sortNewtype;

@property (nonatomic ,strong) XLTMemberSortView *sortAlterView;
@end

@implementation XLTContributeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor
    [self reloadView];
    
    
}
- (void)reloadView{
    [self.view insertSubview:self.navView atIndex:0];
    [self.contentTableView setFrame:CGRectMake(0, kTopHeight + 40, self.view.bounds.size.width, self.view.height - kTopHeight -40)];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.contentTableView.separatorColor = [UIColor colorWithHex:0xEBEBED];
    self.contentTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.navView addSubview:self.nameLabel];
    [self.navView addSubview:self.backBtn];
    self.contentTableView.backgroundView = nil;
    self.contentTableView.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLable];
    
    [self.view addSubview:self.sortView];
    self.sortView.frame = CGRectMake(0, kTopHeight, kScreenWidth, 40);
    self.sortNewtype = -1;
    self.type = XLTContributeTypeTotal;
    
    MJRefreshAutoNormalFooter *letaoRefreshAutoFooter = ( MJRefreshAutoNormalFooter *)self.contentTableView.mj_footer;
    if ([letaoRefreshAutoFooter isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        [letaoRefreshAutoFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
    }
}
- (void)registerTableViewCells{
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTContributeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTContributeCell"];
}
- (XLTMemberSortView *)sortAlterView{
    if (!_sortAlterView) {
        _sortAlterView = [[XLTMemberSortView alloc] initWithSortArray:@[@"全部",@"专属粉丝",@"其他粉丝"]];
        [_sortAlterView.confirmButton setTitleColor:[UIColor colorWithHex:0xD22C2F] forState:UIControlStateNormal];
        _sortAlterView.titleLabel.text = @"筛选";
        _sortAlterView.delegate = self;
    }
    return _sortAlterView;
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
- (void)configDateLabel{
    NSDate *date = [NSDate new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: date];
    self.bottomLable.text = [NSString stringWithFormat:@"本数据更新时间为：%@",currentDateStr];
}
- (UIView *)sortView{
    if (!_sortView) {
        _sortView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _sortView.backgroundColor = [UIColor whiteColor];
        CGFloat itemWith = kScreenWidth / 4.0;
        for (int i = 0; i <4; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(itemWith * i, 0, itemWith, 40);
            switch (i) {
                case 0:
                {
                    self.sort1Label = [[UILabel alloc] init];
                    self.sort1Label.font = [UIFont fontWithName:kSDPFLightFont size:14];
                    self.sort1Label.textColor = [UIColor colorWithHex:0xFF8202];
                    self.sort1Label.text = @"总预估佣金";
                    [self.sort1Label sizeToFit];
                    self.sort1Label.frame = CGRectMake((button.width - self.sort1Label.width) /2.0, (button.height - self.sort1Label.height) /2.0, self.sort1Label.width, self.sort1Label.height);
                    [button addSubview:self.sort1Label];
                }
                    break;
                case 1:
                {
                    self.sort2Label = [[UILabel alloc] init];
                    self.sort2Label.font = [UIFont fontWithName:kSDPFLightFont size:14];
                    self.sort2Label.textColor = [UIColor colorWithHex:0x25282D];
                    self.sort2Label.text = @"本月预估佣金";
                    [self.sort2Label sizeToFit];
                    self.sort2Label.frame = CGRectMake((button.width - self.sort2Label.width) /2.0, (button.height - self.sort2Label.height) /2.0, self.sort2Label.width, self.sort2Label.height);
                    [button addSubview:self.sort2Label];
                }
                    break;
                case 2:
                {
                    self.sort3Label = [[UILabel alloc] init];
                    self.sort3Label.font = [UIFont fontWithName:kSDPFLightFont size:14];
                    self.sort3Label.textColor = [UIColor colorWithHex:0x25282D];
                    self.sort3Label.text = @"七日拉新";
                    [self.sort3Label sizeToFit];
                    self.sort3Label.frame = CGRectMake((button.width - self.sort3Label.width) /2.0, (button.height - self.sort3Label.height) /2.0, self.sort3Label.width, self.sort3Label.height);;
                    [button addSubview:self.sort3Label];
                    self.sort3ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.sort3Label.x + self.sort3Label.width + 5,(button.height - 10) / 2.0, 7, 10)];
                    self.sort3ImageView.image = [UIImage imageNamed:@"xingletao_mine_team_sort"];
                    [button addSubview:self.sort3ImageView];
                    
                }
                    break;
                case 3:
                {
                    self.sort4Label = [[UILabel alloc] init];
                    self.sort4Label.font = [UIFont fontWithName:kSDPFLightFont size:14];
                    self.sort4Label.textColor = [UIColor colorWithHex:0x25282D];
                    self.sort4Label.text = @"筛选";
                    [self.sort4Label sizeToFit];
                    self.sort4Label.frame = CGRectMake((button.width - self.sort4Label.width) /2.0, (button.height - self.sort4Label.height) /2.0, self.sort4Label.width, self.sort4Label.height);;
                    [button addSubview:self.sort4Label];
                    self.sort4ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.sort4Label.x + self.sort4Label.width + 5,(button.height - 10) / 2.0, 7, 10)];
                    self.sort4ImageView.image = [UIImage imageNamed:@"xingletao_mine_team_filter"];
                    [button addSubview:self.sort4ImageView];
                }
                    break;
                default:
                    break;
            }
            button.tag = 1200 + i;
            [button addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
            [_sortView addSubview:button];
        }
    }
    return _sortView;
}
- (void)sortAction:(UIButton *)btn{
    NSInteger i = btn.tag - 1200;
    
    if (i != 3) {
        self.sort1Label.textColor = [UIColor colorWithHex:0x25282D];
        self.sort2Label.textColor = [UIColor colorWithHex:0x25282D];
        self.sort3Label.textColor = [UIColor colorWithHex:0x25282D];
        self.sort4Label.textColor = [UIColor colorWithHex:0x25282D];
        self.sort3ImageView.image = [UIImage imageNamed:@"xingletao_mine_team_sort"];
    }
    
    
    switch (i) {
        case 0:
        {
            self.type = XLTContributeTypeTotal;
            self.sort1Label.textColor = [UIColor colorWithHex:0xFF8202];
        }
        break;
        case 1:
        {
            self.type = XLTContributeTypeMonth;
            self.sort2Label.textColor = [UIColor colorWithHex:0xFF8202];
        }
        break;
        case 2:
        {
            self.type = XLTContributeTypeNew;
            self.sort3Label.textColor = [UIColor colorWithHex:0xFF8202];
            if (self.sortNewtype == -1) {
                self.sortNewtype = 0;
                self.sortNewtypeStr = @"-fans_all";
                self.sort3ImageView.image = [UIImage imageNamed:@"xingletao_mine_member_sort_down"];
            }else if (self.sortNewtype == 0) {
                self.sortNewtype = 1;
                self.sortNewtypeStr = @"fans_all";
                self.sort3ImageView.image = [UIImage imageNamed:@"xingletao_mine_member_sort_up"];
            } else if (self.sortNewtype == 1) {
                self.sortNewtype = 0;
                self.sortNewtypeStr = @"-fans_all";
                self.sort3ImageView.image = [UIImage imageNamed:@"xingletao_mine_member_sort_down"];
            }
        }
        break;
        case 3:
        {
//            self.sort4Label.textColor = [UIColor colorWithHex:0xFF8202];
            [self.sortAlterView show];
        }
        break;
        default:
            break;
    }
    if (i != 3) {
        [self requestFristPageData];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
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
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _nameLabel.text = @"粉丝贡献榜单";
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
- (void)letaoShowLoading{
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
    
}
// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                         failed:(XLTBaseListRequestFailed)failed{
    XLT_WeakSelf;
    NSString *page = [NSString stringWithFormat:@"%ld",index];
    NSString *row = [NSString stringWithFormat:@"%ld",pageSize];
    switch (self.type) {
        case XLTContributeTypeTotal:
        {
            [XLTUserInfoLogic getCommissionContributListWithPage:page row:row sort:@"-total_amount" relation:self.relationStr success:^(id  _Nonnull object) {
                XLT_StrongSelf;
                [self configDateLabel];
                success(object);
            } failure:^(NSString * _Nonnull errorMsg) {
                failed(nil,errorMsg);
            }];
        }
            break;
        case XLTContributeTypeMonth:
        {
            [XLTUserInfoLogic getMonthContributListWithPage:page row:row sort:@"-total_amount" relation:self.relationStr success:^(id  _Nonnull object) {
                XLT_StrongSelf;
                [self configDateLabel];
                success(object);
            } failure:^(NSString * _Nonnull errorMsg) {
                failed(nil,errorMsg);
            }];
        }
            break;
        case XLTContributeTypeNew:
        {
            [XLTUserInfoLogic getNewContributListWithPage:page row:row sort:self.sortNewtypeStr relation:self.relationStr success:^(id  _Nonnull object) {
                XLT_StrongSelf;
                [self configDateLabel];
                success(object);
            } failure:^(NSString * _Nonnull errorMsg) {
                failed(nil,errorMsg);
            }];
        }
            break;
        default:
            break;
    }
}
- (void)letaoShowEmptyView{
    if (self.balanceEmptyView == nil) {
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

- (void)letaoShowErrorView {
    [super letaoShowErrorView];
    [self.view bringSubviewToFront:self.navView];
}

- (void)pickerDateView:(XLTBasePickView *)pickerDateView selectIndex:(NSInteger )index{
    switch (index) {
        case 0:
            self.relationStr = @"";
            self.sort4Label.font = [UIFont fontWithName:kSDPFLightFont size:13];
            break;
        case 1:
            self.relationStr = @"1";
            self.sort4Label.font = [UIFont fontWithName:kSDPFBoldFont size:13];
            break;
        case 2:
            self.relationStr = @"2";
            self.sort4Label.font = [UIFont fontWithName:kSDPFBoldFont size:13];
            break;
        default:
            break;
    }
    [self requestFristPageData];
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    XLTUserTeamItemListModel *model = [self.letaoPageDataArray objectAtIndex:indexPath.row];
//    [self showDetailView:model];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTContributeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTContributeCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellType = self.type;
    cell.model = [self.letaoPageDataArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 10;
    return self.letaoPageDataArray.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
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
