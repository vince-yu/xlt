//
//  XLTUserInvateVC.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserInvateVC.h"
#import "LetaoEmptyCoverView.h"
#import "XLTUserInvatHeaderView.h"
#import "XLTHomeCustomHeadView.h"
#import "XLTInvatePictureCell.h"
#import "SPButton.h"
#import "XLTUserInfoLogic.h"
#import "XLTUserInvateModel.h"
#import "XLTUserManager.h"
#import "XLTInvatePictureView.h"
#import "XLTUserTaskManager.h"

@interface XLTUserInvateVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) XLTUserInvatHeaderView* headerView;
@property (nonatomic ,strong) NSString *currentMonth;
//@property (nonatomic ,strong) NSArray *letaoPageDataArray;
@property (nonatomic ,strong) LetaoEmptyCoverView *balanceEmptyView;
@property (nonatomic ,strong) UIView *navView;

@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UIButton *backBtn;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSArray *picArray;

@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic ,strong) SPButton *shareBtn;
@property (nonatomic ,strong) SPButton *linkBtn;

@property (nonatomic ,strong) XLTUserInvateModel *selectModel;

@property (nonatomic ,strong) NSDictionary *needRepoTaskInfo;
@end

@implementation XLTUserInvateVC


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if ([self.needRepoTaskInfo isKindOfClass:[NSDictionary class]] && self.needRepoTaskInfo.count > 0) {
        [[XLTUserTaskManager shareManager] letaoRepoShareTaskInfo:self.needRepoTaskInfo];
        self.needRepoTaskInfo = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reloadView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}
- (void)letaoSetupRefreshHeader {
    
}
- (void)reloadView{
    [self.view insertSubview:self.navView atIndex:0];
    [self.contentTableView setFrame:CGRectMake(0, kTopHeight, self.view.bounds.size.width, self.view.height - kTopHeight - kBottomSafeHeight - 100)];
    self.contentTableView.bounces = NO;
    [self.navView addSubview:self.nameLabel];
    [self.navView addSubview:self.backBtn];
    self.contentTableView.backgroundView = nil;
    self.contentTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.shareBtn];
    [self.bottomView addSubview:self.linkBtn];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(100 + kBottomSafeHeight);
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.equalTo(self.bottomView.mas_centerX).multipliedBy(2.0/3);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(75);
    }];
    [self.linkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.equalTo(self.bottomView.mas_centerX).multipliedBy(4.0/3);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(75);
    }];
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _bottomView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:247/255.0 alpha:1.0];
    }
    return _bottomView;
}
- (SPButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [[SPButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [_shareBtn setImage:[UIImage imageNamed:@"xingletao_mine_invate_share"] forState:UIControlStateNormal];
        [_shareBtn setTitle:@"分享海报" forState:UIControlStateNormal];
        _shareBtn.imagePosition = SPButtonImagePositionTop;
        _shareBtn.imageTitleSpace = 10;
        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.titleLabel.font = [UIFont letaoRegularFontWithSize:13];
        [_shareBtn setTitleColor:[UIColor colorWithHex:0x25282D] forState:UIControlStateNormal];
    }
    return _shareBtn;
}
- (SPButton *)linkBtn{
    if (!_linkBtn) {
        _linkBtn = [[SPButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [_linkBtn setImage:[UIImage imageNamed:@"xingletao_mine_invate_link"] forState:UIControlStateNormal];
        [_linkBtn setTitle:@"邀请链接" forState:UIControlStateNormal];
        _linkBtn.imagePosition = SPButtonImagePositionTop;
        _linkBtn.imageTitleSpace = 10;
        [_linkBtn addTarget:self action:@selector(linkAction) forControlEvents:UIControlEventTouchUpInside];
        _linkBtn.titleLabel.font = [UIFont letaoRegularFontWithSize:13];
        [_linkBtn setTitleColor:[UIColor colorWithHex:0x25282D] forState:UIControlStateNormal];
    }
    return _linkBtn;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 300) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundView = nil;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"XLTInvatePictureCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTInvatePictureCell"];
    }
    return _collectionView;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"xinletao_nav_left_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(letaoPopAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.contentMode = UIViewContentModeLeft;
        [_backBtn setFrame:CGRectMake(15, kStatusBarHeight + 12, 50, 18)];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 32);
    }
    return _backBtn;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _nameLabel.text = @"邀请分享";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:19];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.center = CGPointMake(self.navView.center.x, self.backBtn.center.y);
    }
    return _nameLabel;
}
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kTopHeight)];
        UIImageView *_letaobgImageView = [[UIImageView alloc] initWithFrame:_navView.bounds];
        UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFF8A28],[UIColor colorWithHex:0xFF5221]] gradientType:1 imgSize:_letaobgImageView.bounds.size];
        _letaobgImageView.image = bgImage;
        [_navView addSubview:_letaobgImageView];
        
    }
    return _navView;
}
- (XLTUserInvatHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[XLTUserInvatHeaderView alloc] initWithNib];
        
    }
    return _headerView;
}

- (void)letaoPopAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)currentMonth{
    if (!_currentMonth) {
        
        _currentMonth = [self getDateMonthWith:[NSDate date]];
    }
    return _currentMonth;
}

- (void)shareAction {
    
    // 汇报事件
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_APP_POSTER_SHARE properties:nil];
    
    
    if (self.selectModel == nil) {
        [MBProgressHUD letaoshowTipMessageInWindow:@"请选择海报"];
        return;
    }
    NSString *pid = self.selectModel.picId;
    NSString *code = [XLTUserManager shareManager].curUserInfo.invite_link_code;
    NSString *userId = [XLTUserManager shareManager].curUserInfo._id;
    NSString *url = [NSString stringWithFormat:@"%@%@?code=%@&id=%@&pre=0&set_user_nick=1&user_id=%@",[XLTAppPlatformManager shareManager].baseApiSeverUrl,kinvitImageUrl,code,pid,userId];
//    NSString *imageUrl = self.selectModel.gen_image;
    NSString *imageUrl = url;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.label.text = @"海报生成中...";
    hud.label.textColor = [UIColor colorWithHex:0xFF333333];
    hud.label.font = [UIFont letaoLightFontWithSize:12.0];
    
    XLTInvatePictureView *invatePictureView = [[NSBundle mainBundle] loadNibNamed:@"XLTInvatePictureView" owner:self options:nil].lastObject;
    __weak typeof(self)weakSelf = self;
    NSString *qrcodeCode = [XLTUserManager shareManager].curUserInfo.invite_link_code;
    UIImage *qrcodeImage =  [UIImage imageNamed:@"invite_code_bg"];
    [invatePictureView generateWithImageUrl:imageUrl qrcodeImage:qrcodeImage qrcodeCode:qrcodeCode complete:^(BOOL success, UIImage * _Nullable image) {
         [hud hideAnimated:NO];
        if (success && image) {
            [weakSelf showActivityViewController:image];
        } else {
            [weakSelf showTipMessage:Data_Error];
        }
    }];
    [invatePictureView setNeedsLayout];
    [invatePictureView layoutIfNeeded];
}

- (void)showActivityViewController:(UIImage *)activityItem {
      if (activityItem) {
          UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:[XLTGoodsDisplayHelp processSizeForShareActivityItems:@[activityItem] goodsImage:activityItem] applicationActivities:nil];
          
          NSDictionary *taskInfo = self.taskInfo;
          __weak typeof(self)weakSelf = self;
          activityVC.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError) {
              // 微信分享汇报
              BOOL isWeiboType = [@"com.sina.weibo.ShareExtension" isEqualToString:activityType];
              if ([activityType isKindOfClass:[NSString class]] && ([@"com.tencent.xin.sharetimeline" isEqualToString:activityType] || [@"com.tencent.mqq.ShareExtension" isEqualToString:activityType] || isWeiboType)) {
                  if ([taskInfo isKindOfClass:[NSDictionary class]] && taskInfo.count > 0) {
                      if (completed || isWeiboType) {
                          UIApplicationState state = [UIApplication sharedApplication].applicationState;
                          if (state == UIApplicationStateActive) {
                              [[XLTUserTaskManager shareManager] letaoRepoShareTaskInfo:taskInfo];
                          } else {
                              weakSelf.needRepoTaskInfo = taskInfo;
                          }
                      }
                  }
              }
          };
          [self.navigationController presentViewController:activityVC animated:YES completion:nil];
      } else {
          [self showTipMessage:@"没有分享素材"];
      }
}

- (void)linkAction{
    NSString *str = [NSString stringWithFormat:@"这里免费下载【星乐桃】APP\n领大额内部优惠券\n同时享最高90%%自购分享返佣\n\n免费下载链接:\n%@\n官方登录邀请码：%@",@"https://www.xinletao.vip/starDown.html",[XLTUserManager shareManager].curUserInfo.invite_link_code];
    [UIPasteboard generalPasteboard].string = str;
    [MBProgressHUD letaoshowTipMessageInWindow:@"复制成功！"];
   // 汇报事件
   [SDRepoManager xltrepo_trackEvent:XLT_EVENT_APP_lINk_COPY properties:nil];
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
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTUserBalaneCellTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
}

- (void)letaoShowLoading{
    
}
// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                         failed:(XLTBaseListRequestFailed)failed{
    XLT_WeakSelf;
    NSString *inviteCode =  [XLTUserManager shareManager].curUserInfo.invite_link_code;
    [XLTUserInfoLogic xingletaonetwork_requestInvatePicListWithInviteCode:inviteCode success:^(id  _Nonnull object) {
        XLT_StrongSelf;
        self.picArray = object;
        // 默认选中第一张
        if ([self.picArray isKindOfClass:[NSArray class]] && [self.picArray.firstObject isKindOfClass:[XLTUserInvateModel class]]) {
            self.selectModel = self.picArray.firstObject;
            self.selectModel.seleted = YES;
        }
        [self.collectionView reloadData];
        success(@[]);
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self showToastMessage:errorMsg];
    }];
}
- (void)letaoShowEmptyView{
//    if (self.balanceEmptyView == nil) {
//        XLTEmptyView *letaoEmptyCoverView = [XLTEmptyView emptyActionViewWithImageStr:@"page_empty"
//                                                                   titleStr:@"您还没有提现记录哦~"
//                                                                  detailStr:@""
//                                                                btnTitleStr:@""
//                                                              btnClickBlock:^(){
//                                                                  // do nothings
//                                                              }];
//        letaoEmptyCoverView.contentViewOffset =  100;
//        letaoEmptyCoverView.subViewMargin = 14.f;
//        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:15.f];
//        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(172, 172, 172);
//        letaoEmptyCoverView.userInteractionEnabled = NO;
//        self.balanceEmptyView = letaoEmptyCoverView;
//    }
//    [self.contentTableView addSubview:self.balanceEmptyView];
}

- (void)letaoRemoveEmptyView {
    [self.balanceEmptyView removeFromSuperview];
}

#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        default:
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.model = [self.letaoPageDataArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.letaoPageDataArray.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 280;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 305;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.collectionView;
}
#pragma makr CollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XLTUserInvateModel *model = [self.picArray objectAtIndex:indexPath.row];
    self.selectModel = model;
    self.selectModel.seleted = YES;
    for (XLTUserInvateModel *m in self.picArray) {
        if (![m isEqual:self.selectModel]) {
            m.seleted = NO;
        }
    }
    [self.collectionView reloadData];;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XLTInvatePictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTInvatePictureCell" forIndexPath:indexPath];
    cell.model = [self.picArray objectAtIndex:indexPath.row];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.picArray.count;
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160, 285);
}
@end
