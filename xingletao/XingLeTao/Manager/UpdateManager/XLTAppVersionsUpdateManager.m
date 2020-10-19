//
//  XLTAppVersionsUpdateManager.m
//  XingLeTao
//
//  Created by chenhg on 2020/2/3.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTAppVersionsUpdateManager.h"
#import "XLTNetworkHelper.h"
#import "XLTBaseModel.h"
#import "XLTTipConstant.h"
#import "XLTVersionsUpdateView.h"

@interface XLTAppVersionsUpdateManager () <XLTVersionsUpdateViewDelegate>
{
    UIWindow    *_versionWindow;
    UIView      *_masksView;   
}
@property (nonatomic, strong) XLTVersionsUpdateView *versionsUpdateView;
@property (nonatomic, assign) BOOL didVersionsUpdateShowed;

@end

@implementation XLTAppVersionsUpdateManager


+ (instancetype)shareManager {
    static XLTAppVersionsUpdateManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)applicationDidBecomeActive:(NSNotification*)notification {
    [self requestVersionSuccess:^(NSDictionary * _Nonnull versionInfo) {
        NSString *version = versionInfo[@"version"];
        if ([self hasNewVersion:version]) {
            NSNumber *forced_update = versionInfo[@"forced_update"];
            NSString *update_log = versionInfo[@"update_log"];
            BOOL isForceUpdate = [forced_update isKindOfClass:[NSNumber class]] && [forced_update boolValue];
            if (isForceUpdate || !self.didVersionsUpdateShowed) {
                [self showVersionViewWithVersion:version updateText:update_log isForcedUpdate:isForceUpdate];
            }
        }
        
    } failure:^(NSString *errorMsg) {
        
    }];
 
}



- (NSString *)appVersion {
    static NSString *appVersion = nil;
    if (appVersion == nil) {
        appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
    return [appVersion copy];
}

- (BOOL)hasNewVersion:(NSString *)targetVersion {
    BOOL canshow = [XLTAppPlatformManager shareManager].checkEnable;
    if (canshow) {
        if ([targetVersion isKindOfClass:[NSString class]]) {
            NSString *appVersion = [self appVersion];
            BOOL hasNewVersion = ([targetVersion compare:appVersion options:NSNumericSearch] == NSOrderedDescending);
            return hasNewVersion;
        }
    }
    return  NO;
}

// 获取淘宝京东活动链接
- (void)requestVersionSuccess:(void(^)(NSDictionary  * _Nonnull versionInfo))success
               failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"Apple" forKey:@"channel"];
    [XLTNetworkHelper GET:kVersionCheckUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                success(model.data);
            }
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
    }];
}


- (void)showVersionViewWithVersion:(NSString *)version
                        updateText:(NSString *)updateText
                    isForcedUpdate:(BOOL)isForcedUpdate{
    if(_versionWindow == nil) {
        _versionWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _versionWindow.backgroundColor = [UIColor clearColor];
        _versionWindow.hidden = YES;
        _versionWindow.windowLevel = (UIWindowLevelStatusBar + 1.0);

        
        // 底层黑背景
        _masksView = [[UIView alloc] initWithFrame:_versionWindow.bounds];
        _masksView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _masksView.userInteractionEnabled = NO;
        [_versionWindow addSubview:_masksView];
        
        if (self.versionsUpdateView == nil) {
            self.versionsUpdateView = [[[NSBundle mainBundle] loadNibNamed:@"XLTVersionsUpdateView" owner:nil options:nil] lastObject];
            self.versionsUpdateView.delegate = self;
        }
        [_versionWindow addSubview:self.versionsUpdateView];
        self.versionsUpdateView.isForceUpdate = isForcedUpdate;
        self.versionsUpdateView.versionLabel.text = [NSString stringWithFormat:@"发现新版本\nV%@",version];
        self.versionsUpdateView.updateTextLabel.text = [NSString stringWithFormat:@"%@",updateText];
        self.versionsUpdateView.cancelButton.hidden = isForcedUpdate;

        [self.versionsUpdateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_versionWindow.mas_width).offset(-40);
            make.centerY.mas_equalTo(_versionWindow.mas_centerY);
            make.centerX.mas_equalTo(_versionWindow.mas_centerX);
        }];
        [self showVersionView];
    } else {
        // 已经显示了  donothing
    }
}

- (void)cancelButtonAction:(id)sender {
    [self hiddenVersionView];
    self.didVersionsUpdateShowed = YES;
}

- (void)updateButtonAction:(id)sender {
    if (!self.versionsUpdateView.isForceUpdate) {
        [self hiddenVersionView];
    }
    self.didVersionsUpdateShowed = YES;
    
    NSString *urlStr = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id/%@?mt=8",@"1488064629"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

#define kAnimateWithDuration  0.3
- (void)showVersionView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenVersionView) object:nil];
    
    // 如果已经显示，不再作重复动作
    if(_versionWindow.hidden != NO) {
        _versionWindow.hidden = NO;
        _masksView.alpha = 0.0;
        self.versionsUpdateView.alpha = 0.0;
        [UIView animateWithDuration:kAnimateWithDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self->_masksView.alpha = 1.0;

        } completion:^(BOOL finished) {
            self.versionsUpdateView.alpha = 1.0;
        }];
    }
}

- (void)hiddenVersionView {
    if(_versionWindow.hidden == NO) {
        [UIView animateWithDuration:kAnimateWithDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.versionsUpdateView.alpha = 0.5;
        } completion:^(BOOL finished) {
            self.versionsUpdateView.alpha = 0;
             [UIView animateWithDuration:0.2 animations:^{
                 self->_masksView.alpha = 0;
             } completion:^(BOOL finished) {
                 self->_versionWindow.hidden = YES;
                 [self clearViews];
             }];
         }];
    }
}

- (void)clearViews {
    _versionWindow = nil;
    _masksView = nil;
    _versionsUpdateView.delegate = nil;
    _versionsUpdateView = nil;
}



@end
