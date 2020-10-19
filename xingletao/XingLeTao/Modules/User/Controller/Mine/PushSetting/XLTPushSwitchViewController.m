//
//  XLTPushSwitchViewController.m
//  XingLeTao
//
//  Created by chenhg on 2020/2/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTPushSwitchViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "XLTUserInfoLogic.h"
#import "XLTPushSwitchCell.h"
#import "XLTPushSwitchTipFooterView.h"
#import "XLTUserManager.h"

@interface XLTPushSwitchViewController () <XLTPushSwitchCellDelegate>
@property (nonatomic, assign) BOOL isSystemPushSwitchEnabled;
@property (nonatomic, strong) XLTPushSwitchTipFooterView *tipFooterView;

@end

@implementation XLTPushSwitchViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)applicationDidBecomeActive:(NSNotification*)notification {
    [self checkSystemPushSwitchEnabled];
}

- (void)letaoSetupRefreshAutoFooter {
}


- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}

- (void)checkSystemPushSwitchEnabled {
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isSystemPushSwitchEnabled =  (settings.authorizationStatus == UNAuthorizationStatusAuthorized);
            });
        }];
    } else {
        // Fallback on earlier versions
         UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        self.isSystemPushSwitchEnabled = (setting.types != UIUserNotificationTypeNone);
    }
}

- (void)setIsSystemPushSwitchEnabled:(BOOL)isSystemPushSwitchEnabled {
    if (_isSystemPushSwitchEnabled != isSystemPushSwitchEnabled) {
        _isSystemPushSwitchEnabled = isSystemPushSwitchEnabled;
        if (self.letaoPageDataArray.count) {
            [self.contentTableView reloadData];
        }
    }
    [self updateTipFooterView];
}


- (void)updateTipFooterView {
    if (self.tipFooterView == nil) {
        self.tipFooterView = [[[NSBundle mainBundle] loadNibNamed:@"XLTPushSwitchTipFooterView" owner:nil options:nil] lastObject];
        self.tipFooterView.frame = CGRectMake(0, 0, kScreenWidth, 125);
        self.tipFooterView.backgroundColor = [UIColor letaolightgreyBgSkinColor];
    }
    self.contentTableView.tableFooterView = self.tipFooterView;
    self.tipFooterView.tipLabel.hidden = _isSystemPushSwitchEnabled;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"推送设置";
    self.contentTableView.separatorColor = [UIColor colorWithHex:0xededed];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self checkSystemPushSwitchEnabled];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
}


// registerTableViewCells should overwrite by sub class
- (void)registerTableViewCells {
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTPushSwitchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTPushSwitchCell"];

}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.letaoPageDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTPushSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTPushSwitchCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.letaoPageDataArray.count) {
        NSDictionary *info = self.letaoPageDataArray[indexPath.row];
        if ([info isKindOfClass:[NSDictionary class]]) {
            NSNumber *enable = info[@"enable"];
            NSString *title = [info[@"title"] isKindOfClass:[NSString class]]  ? info[@"title"] : @"未知";
            BOOL on = ([enable isKindOfClass:[NSNumber class]] && [enable boolValue]);
            cell.pushTitleLabel.text = title;
            cell.pushSwitch.on = on;
            cell.switchInfo = info;
        }
    }
    cell.pushSwitch.enabled = self.isSystemPushSwitchEnabled;
    cell.delegate = self;
    return cell;
}


// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                            failed:(XLTBaseListRequestFailed)failed {
    NSString *userId = [XLTUserManager shareManager].curUserInfo._id;
    [XLTUserInfoLogic requestPushSwitchsWithUserId:userId success:^(NSArray  * _Nonnull switchList) {
        success(switchList);
    } failure:^(NSString * _Nonnull errorMsg) {
        failed(nil,errorMsg);
    }];
}


- (void)cell:(XLTPushSwitchCell *)cell pushSwitchOn:(BOOL)on {
    NSDictionary *switchInfo = cell.switchInfo;
    if ([switchInfo isKindOfClass:[NSDictionary class]]) {
        NSString *userId = [XLTUserManager shareManager].curUserInfo._id;
        NSString *switchId = switchInfo[@"_id"];
        [self letaoShowLoading];
        __weak typeof(self)weakSelf = self;
        [XLTUserInfoLogic updatePushSwitchsWithUserId:userId switchId:switchId switchOn:on success:^(NSDictionary * _Nonnull info) {
            // 更新数据
            NSInteger index = [weakSelf.letaoPageDataArray indexOfObject:switchInfo];
            if (index != NSNotFound && index < weakSelf.letaoPageDataArray.count) {
                NSMutableDictionary *changedSwitchInfo = switchInfo.mutableCopy;
                changedSwitchInfo[@"enable"] = [NSNumber numberWithBool:on];
                [weakSelf.letaoPageDataArray replaceObjectAtIndex:index withObject:changedSwitchInfo];
                [weakSelf.contentTableView reloadData];
            }
            [weakSelf letaoRemoveLoading];

        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf.contentTableView reloadData];
            [weakSelf showTipMessage:errorMsg];
            [weakSelf letaoRemoveLoading];
        }];
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

@end
