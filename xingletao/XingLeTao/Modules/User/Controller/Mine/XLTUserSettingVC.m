//
//  XLTUserSettingVC.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserSettingVC.h"
#import "XLTSettingTableViewCell.h"
#import "XLTUserBindAliPayVC.h"
#import "XLTUserAboutVC.h"
#import "XLTUserInfoLogic.h"
#import <SDWebImage/SDImageCache.h>
#import "XLTUserAliPayInfoVC.h"
#import "XLTUserManager.h"
#import "XLTUserInputOldPhoneVC.h"
#import "JPVideoPlayerCache.h"
#import "XLTPushSwitchViewController.h"
#import "XLTFeedBackListViewController.h"
#import "XLTBindWXVC.h"
#import "XLTUpdateInvaterVC.h"
#import "XLTUpdateMyInviterVC.h"

@interface XLTSettingCellModel : NSObject
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *moreIconHidden;
@property (nonatomic ,copy) NSString *valueLabelHidden;
@property (nonatomic ,copy) NSString *value;
@property (nonatomic ,copy) NSString *code;
@property (nonatomic ,strong) UIColor *nameColor;
@property (nonatomic ,copy) NSString *selector;
@property (nonatomic ,copy) NSString *showAvater;
@end

@implementation XLTSettingCellModel


@end

@interface XLTUserSettingVC ()<UITableViewDelegate,UITableViewDataSource,XLTBindWXDelegate,XLTUpdateInvaterDelegate>
@property (nonatomic ,strong) UITableView *contentView;
@property (nonatomic ,strong) UIButton *exitBtn;
@property (nonatomic ,strong) NSString *memorySize;
@property (nonatomic ,assign) NSUInteger imageDiskSizeSize;
@property (nonatomic ,assign) NSUInteger videoDiskSizeSize;
@property (nonatomic ,strong) NSArray *dataArray;
@end

@implementation XLTUserSettingVC

- (void)dealloc {
    [[XLTUserManager shareManager] removeObserver:self forKeyPath:@"curUserInfo.inviter"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[XLTUserManager shareManager] addObserver:self forKeyPath:@"curUserInfo.inviter" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"curUserInfo.inviter"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadTableData];
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.memorySize = [self getSize];
    [self xingletaonetwork_requestVideoPlayerCacheSize];
    [self initSubView];
}
- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSArray modelArrayWithClass:[XLTSettingCellModel class] json:[self configDataArray]];
    }
    
    return _dataArray;
}
- (void)reloadTableData{
    self.dataArray = nil;
    [self.contentView reloadData];
}
- (NSArray *)configDataArray{
    NSString *inviter = [XLTUserManager shareManager].curUserInfo.inviter;
    NSString *myWX = [XLTUserManager shareManager].curUserInfo.wechat_show_uid;
    NSInteger level = [XLTUserManager shareManager].curUserInfo.level.intValue;
    NSInteger serverType = [XLTAppPlatformManager shareManager].serverType;
    NSString *time = [XLTUserManager shareManager].curUserInfo.itime;
    
    NSArray *jsonArray = @[@{
                            @"code":@"bindAlipay",
                            @"moreIconHidden":@"0",
                            @"valueLabelHidden":@"1",
                            @"name":@"绑定支付宝",
                            @"value":@"",
                            @"selector":@"bindAplipayAction",
                            },
                           @{
                           @"code":@"changePhone",
                           @"moreIconHidden":@"0",
                           @"valueLabelHidden":@"1",
                           @"name":@"修改手机",
                           @"value":@"",
                           @"selector":@"pusthToChangePhoneVC",
                           },
                           @{
                           @"code":@"clearCache",
                           @"moreIconHidden":@"1",
                           @"valueLabelHidden":@"0",
                           @"name":@"清除缓存",
                           @"value":!self.memorySize ? @"0K":self.memorySize,
                           @"selector":@"clearMemory",
                           },
                           @{
                           @"code":@"pushSetting",
                           @"moreIconHidden":@"0",
                           @"valueLabelHidden":@"1",
                           @"name":@"消息推送",
                           @"value":@"",
                           @"selector":@"pushPushNotificationVC",
                           },
                           @{
                           @"code":@"myInviter",
                           @"moreIconHidden":@"0",
                           @"valueLabelHidden":@"0",
                           @"name":@"我的邀请人",
                           @"value":inviter.length ? inviter : @"未绑定",
                           @"selector":@"pushToBindInviteVC",
                           @"showAvater":@"1",
                           },
                           @{
                           @"code":@"time",
                           @"moreIconHidden":@"1",
                           @"valueLabelHidden":@"0",
                           @"name":@"注册时间",
                           @"value":time.length ? [time convertDateStringWithSecondTimeStr:@"yyyy-MM-dd hh:mm"] : @"",
                           },
                           @{
                           @"code":@"feedBack",
                           @"moreIconHidden":@"0",
                           @"valueLabelHidden":@"1",
                           @"name":@"问题反馈",
                           @"value":@"",
                           @"selector":@"goFeedBack"
                           },
                           @{
                           @"code":@"about",
                           @"moreIconHidden":@"0",
                           @"valueLabelHidden":@"1",
                           @"name":@"关于",
                           @"value":@"",
                           @"selector":@"pushToAboutVC",
                           }
    ];
    NSMutableArray *resutArray = [NSMutableArray arrayWithArray:jsonArray];
    if ([XLTAppPlatformManager shareManager].checkEnable) {
        [resutArray insertObject:@{
            @"code":@"updateInviter",
            @"moreIconHidden":@"0",
            @"valueLabelHidden":@"1",
            @"name":@"更改邀请码",
            @"value":@"",
            @"selector":@"pushToUpdateInviteVC",
        } atIndex:4];

    }
    if (level == 3 || level == 4) {
        [resutArray insertObject:@{
            @"code":@"myWX",
            @"moreIconHidden":@"1",
            @"valueLabelHidden":@"0",
            @"name":@"导师微信",
            @"value":myWX.length ? myWX : @"未绑定",
            @"selector":@"pushToBindWeiXin",
        } atIndex:3];
    }
    if ([XLTAppPlatformManager shareManager].debugModel) {
        [resutArray addObject:@{
            @"code":@"testEnv",
            @"moreIconHidden":@"0",
            @"valueLabelHidden":@"1",
            @"name":@"测试环境",
            @"value":@"",
            @"nameColor":serverType == XLTAppPlatformServerTestType ? [UIColor letaomainColorSkinColor] : [UIColor colorWithHex:0xFF333333],
            @"selector":@"changeTestServer",
        }];
        [resutArray addObject:@{
            @"code":@"nomalEnv",
            @"moreIconHidden":@"0",
            @"valueLabelHidden":@"1",
            @"name":@"正式环境",
            @"value":@"",
            @"nameColor":serverType == XLTAppPlatformServerReleaseType ? [UIColor letaomainColorSkinColor] : [UIColor colorWithHex:0xFF333333],
            @"selector":@"changeReleaseServer",
        }];
        [resutArray addObject:@{
            @"code":@"preEnv",
            @"moreIconHidden":@"0",
            @"valueLabelHidden":@"1",
            @"name":@"Pre环境",
            @"value":@"",
            @"nameColor":serverType == XLTAppPlatformServerBetaType ? [UIColor letaomainColorSkinColor] : [UIColor colorWithHex:0xFF333333],
            @"selector":@"changeBetaServer",
        }];
    }
    return resutArray;
}
- (void)initSubView{
    self.title = @"设置";
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.mas_height).offset(-100);
    }];
    
    [self.view addSubview:self.exitBtn];
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-50);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];

    
}
#pragma mark Lazy
- (UITableView *)contentView{
    if (!_contentView) {
        _contentView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        [_contentView registerNib: [UINib nibWithNibName:@"XLTSettingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTSettingTableViewCell"];
        _contentView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _contentView.separatorColor = [UIColor colorWithHex:0xededed];
        _contentView.backgroundView = nil;
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}
- (UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        _exitBtn.backgroundColor = [UIColor letaomainColorSkinColor];
        _exitBtn.layer.cornerRadius = 22.5;
        _exitBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:15];
        [_exitBtn addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}
// 具体实现 缓存大小
- (NSString *)getSize {
    NSUInteger tmpSize = [[SDImageCache sharedImageCache] totalDiskSize];
    self.imageDiskSizeSize = tmpSize;
    NSString *clearCacheName;
    if (tmpSize >= 1024*1024*1024) {
        clearCacheName = [NSString stringWithFormat:@"%0.2fG",tmpSize /(1024.f*1024.f*1024.f)];
    }else if (tmpSize >= 1024*1024) {
        clearCacheName = [NSString stringWithFormat:@"%0.2fM",tmpSize /(1024.f*1024.f)];
    }else{
        clearCacheName = [NSString stringWithFormat:@"%0.2fK",tmpSize / 1024.f];
    }
    return clearCacheName;
}


- (void)xingletaonetwork_requestVideoPlayerCacheSize {
    __weak typeof(self)weakSelf = self;
    [JPVideoPlayerCache.sharedCache calculateSizeOnCompletion:^(NSUInteger fileCount, NSUInteger totalSize) {
        // do something.
        weakSelf.videoDiskSizeSize = totalSize;
        [weakSelf updateCacheSize];
    }];
}

- (void)updateCacheSize {
    NSString *clearCacheName = nil;
    NSUInteger tmpSize = self.videoDiskSizeSize + self.imageDiskSizeSize;
    if (tmpSize >= 1024*1024*1024) {
        clearCacheName = [NSString stringWithFormat:@"%0.2fG",tmpSize /(1024.f*1024.f*1024.f)];
    }else if (tmpSize >= 1024*1024) {
        clearCacheName = [NSString stringWithFormat:@"%0.2fM",tmpSize /(1024.f*1024.f)];
    }else{
        clearCacheName = [NSString stringWithFormat:@"%0.2fK",tmpSize / 1024.f];
    }
    self.memorySize = clearCacheName;
    [self reloadTableData];
}



#pragma mark Action
- (void)exitAction{
    XLT_WeakSelf;
    [XLTUserInfoLogic xingletaonetwork_requestlogout:^(id balance) {
        XLT_StrongSelf;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errorMsg) {
        XLT_StrongSelf;
        [self showTipMessage:errorMsg];
    }];
}
- (void)clearMemory{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [JPVideoPlayerCache.sharedCache clearDiskOnCompletion:^{
        // do something
    }];
    [[SDImageCache sharedImageCache] clearMemory];//可不写
    [self showToastMessage:@"缓存清除成功！"];
    self.memorySize = @"0k";
    [self reloadTableData];
}
- (void)pushToSettingNotifi{

}


- (void)pushToBindInviteVC{
    XLTUpdateMyInviterVC *updateMyInviterVC = [[XLTUpdateMyInviterVC alloc] init];
    NSString *inviter_code = [XLTUserManager shareManager].curUserInfo.inviter_link_code;
    if ([inviter_code isKindOfClass:[NSString class]] && inviter_code.length > 0) {
        updateMyInviterVC.inviterCode = inviter_code;
    }
    [self.navigationController pushViewController:updateMyInviterVC animated:YES];
}
- (void)pushToUpdateInviteVC{
    XLTUpdateInvaterVC *aboutvc = [[XLTUpdateInvaterVC alloc] init];
    aboutvc.delegate = (id)self;
    [self.navigationController pushViewController:aboutvc animated:YES];
}
- (void)pushToAboutVC{
    XLTUserAboutVC *aboutvc = [[XLTUserAboutVC alloc] init];
    
    [self.navigationController pushViewController:aboutvc animated:YES];
}
- (void)pushToBindAlipayVC{
    XLTUserBindAliPayVC *aboutvc = [[XLTUserBindAliPayVC alloc] init];
    
    [self.navigationController pushViewController:aboutvc animated:YES];
}
- (void)pushPushNotificationVC{
    XLTPushSwitchViewController *pushSwitchViewController = [[XLTPushSwitchViewController alloc] init];
    [self.navigationController pushViewController:pushSwitchViewController animated:YES];
}
- (void)bindAplipayAction{
    if ([XLTUserManager shareManager].curUserInfo.bind_alipay.boolValue) {
        [self pushToAlipayListVC];
    }else{
        [self pushToBindAlipayVC];
    }
}
- (void)pushToBindWeiXin{
    XLTBindWXVC *vc = [[XLTBindWXVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushToAlipayListVC{
    XLTUserAliPayInfoVC *aboutvc = [[XLTUserAliPayInfoVC alloc] init];
    
    [self.navigationController pushViewController:aboutvc animated:YES];
}
- (void)pusthToChangePhoneVC{
    XLTUserInputOldPhoneVC *vc = [[XLTUserInputOldPhoneVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)changeTestServer{
    if ([XLTAppPlatformManager shareManager].serverType == XLTAppPlatformServerTestType) {
        return;
    }
    [[XLTUserManager shareManager] logout];
    [XLTAppPlatformManager shareManager].serverType = XLTAppPlatformServerTestType;
    [self reloadTableData];
}

- (void)goFeedBack {
    XLTFeedBackListViewController *feedBackListViewController = [[XLTFeedBackListViewController alloc] init];
    [self.navigationController pushViewController:feedBackListViewController animated:YES];
}

- (void)changeBetaServer{
    if ([XLTAppPlatformManager shareManager].serverType == XLTAppPlatformServerBetaType) {
        return;
    }
    [[XLTUserManager shareManager] logout];
    [XLTAppPlatformManager shareManager].serverType = XLTAppPlatformServerBetaType;
    [self reloadTableData];
}
- (void)changeReleaseServer{
    if ([XLTAppPlatformManager shareManager].serverType == XLTAppPlatformServerReleaseType) {
        return;
    }
    [[XLTUserManager shareManager] logout];
    [XLTAppPlatformManager shareManager].serverType = XLTAppPlatformServerReleaseType;
    [self reloadTableData];
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTSettingCellModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.selector.length) {
        SEL selector = NSSelectorFromString(model.selector);
        if ([self respondsToSelector:selector]) {
            ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTSettingTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XLTSettingCellModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = model.name;
    cell.moreIcon.hidden = model.moreIconHidden.boolValue;
    cell.valueLabel.text = model.value;
    cell.valueLabel.hidden = model.valueLabelHidden.boolValue;
    cell.avaterImageView.hidden = !model.showAvater.boolValue;
    if (!cell.moreIcon.hidden) {
        cell.valueLabelRight.constant = 15 + 6 +5;
    } else {
        cell.valueLabelRight.constant = 15.0;
    }
    
    if (model.showAvater.boolValue) {
        NSString *avaterStr = [XLTUserManager shareManager].curUserInfo.inviter_avatar;
        [cell.avaterImageView sd_setImageWithURL:[NSURL URLWithString:avaterStr]];
    }else{
        cell.avaterImageView.image = nil;
    }
    
    if (model.nameColor) {
        cell.nameLabel.textColor = model.nameColor;
    }else{
        cell.nameLabel.textColor = [UIColor colorWithHex:0xFF333333];
    }
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
#pragma mark BindWXDelegate
-(void)reloadSettingVC{
    [self reloadTableData];
}
//#pragma mark UpateInviterDelegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
