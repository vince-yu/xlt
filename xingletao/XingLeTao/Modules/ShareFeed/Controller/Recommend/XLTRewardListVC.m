//
//  XLTRewardListVC.m
//  XingLeTao
//
//  Created by SNQU on 2020/6/18.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTRewardListVC.h"
#import "XLTRewardListCell.h"
#import "XLTRecommedFeedLogic.h"
#import "XLTUserManager.h"
#import "XLTWKWebViewController.h"

@interface XLTRewardListVC ()
@property (nonatomic ,strong) UIView *navView;
@property (nonatomic ,strong) UIButton *rightBtn;

@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UIButton *backBtn;
@end

@implementation XLTRewardListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"奖励记录";
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.nameLabel];
    [self.navView addSubview:self.backBtn];
    [self.navView addSubview:self.rightBtn];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(kTopHeight);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(50);
        make.left.mas_equalTo(15);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navView);
        make.centerY.equalTo(self.backBtn);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn);
        make.right.mas_equalTo(-15);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}
- (void)letaoListRegisterCells{
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTRewardListCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTRewardListCell"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
}
- (void)letaoShowLoading{
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];

}
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                         failed:(XLTBaseListRequestFailed)failed{
    [self letaoShowLoading];
    XLT_WeakSelf;
    [XLTRecommedFeedLogic getMyRewardListPage:[NSString stringWithFormat:@"%ld",index] row:[NSString stringWithFormat:@"%ld",pageSize] success:^(NSArray * _Nonnull stateInfo) {
       
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        success(stateInfo);
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        failed(nil,errorMsg);
    }];
}
#pragma mark Lazy
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"奖励规则" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        [_rightBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
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
        _nameLabel.text = @"奖励记录";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:19];
        _nameLabel.textColor = [UIColor blackColor];
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
- (void)letaoPopAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightAction{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.jump_URL = kXLTRewardRule5Url;
    UINavigationController *nav = self.navigationController;
    [nav pushViewController:web animated:YES];
}
#pragma mark CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XLTRewardListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTRewardListCell" forIndexPath:indexPath];
    XLTMyRewardListModel *model = [self.letaoPageDataArray objectAtIndex:indexPath.section];
    [cell letaoUpdateCellDataWithInfo:model];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.letaoPageDataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 10);
}
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kScreenWidth, 180);
}
@end
