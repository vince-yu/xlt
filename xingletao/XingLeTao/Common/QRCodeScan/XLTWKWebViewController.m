
#import "XLTWKWebViewController.h"
#import "XLTNetCommonParametersModel.h"
#import "XLTUserManager.h"
#import "XLTGoodsDetailVC.h"
#import "XLTAdManager.h"
#import "XLTUserBindAliPayVC.h"
#import "NSString+XLTMD5.h"
#import "FCUUID.h"
#import "XLTShareManager.h"
#import "AppDelegate.h"
#import "XLTVipVC.h"
#import "XLTUserInvateVC.h"
#import "XLTIncomeVC.h"
#import "XLTMyTeamVC.h"
#import "XLTUserBalanceDrawVC.h"
#import "XLTUserWithDrawVC.h"
#import "XLTOrderFindVC.h"
#import "XLTShareFeedContainerVC.h"
#import "XLTCollectVC.h"
#import "XLTQRCodeScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XLTSearchViewController.h"
#import "XLTAliManager.h"
#import "XLTALiTradeWebViewController.h"
#import "XLTJingDongManager.h"
#import "XLTPDDManager.h"
#import "XLTHomeRecommendVC.h"
#import "XLTRootOrderVC.h"
#import <UserNotifications/UserNotifications.h>
#import "XLTUserTaskManager.h"
#import "XLTBindWXVC.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/ALAsset.h>
#import "XLTWKWebViewController+GoodsActivity.h"
#import "XLTGoodsSearchReultVC.h"
#import "DYVideoContainerViewController.h"
#import "XLTFullScreenVideoVC.h"
#import "XLTActivityVC.h"
#import "UIImage+WebP.h"
#import "XLTUpdateMyInviterVC.h"
#import "XLTMyRecommendVC.h"
#import "XLTShareFeedMediaDownloadVC.h"
#import "XLTNineYuanNineContainerVC.h"
#import "XLTStreetTabBarController.h"
#import "CZBWebViewController.h"
#import <UTDID/UTDevice.h>
#import "DadaCharge.h"
#import "XLTAlipayManager.h"

@interface XLTWKWebViewController () <XLTWebViewDelegate>
@property (nonatomic,assign) BOOL isbindAlipay;
@property (nonatomic, strong) NSMutableArray *allSessionTask;
@property (nonatomic, strong) UIButton *letaoLeftButton;
@property (nonatomic, assign) BOOL isSystemPushSwitchEnabled;

@property (nonatomic, assign) NSUInteger viewWillAppearCount;
@property (nonatomic ,strong) NSDictionary *needRepoTaskInfo;
@property (nonatomic ,strong) UIButton *overShareButton;
@property (nonatomic, copy) NSString *jump_original_URL;

@end

@implementation XLTWKWebViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _allSessionTask = [NSMutableArray array];
        _shouldDecideGoodsActivity = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessAction) name:kXLTNotifiLoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedAuthTaoBaoCompleteNotification) name:kXLTAuthTaoBaoCompleteNotificationName object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.isbindAlipay = [[XLTUserManager shareManager].curUserInfo.bind_alipay boolValue];
    self.jump_original_URL = self.jump_URL;
    [self setupWebView];
    
    if (self.fullScreen) {
        [self configFullScreenLeftButton];
    }
    self.isLightBarStyle = self.fullScreen;
}
- (void)configFullScreenLeftButton{
    if (_letaoLeftButton == nil) {
        _letaoLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _letaoLeftButton.frame = CGRectMake(5, kStatusBarHeight, 44, 44);
        [_letaoLeftButton setImage:[UIImage imageNamed:@"xinletao_gooddetail_graybackground_back"] forState:UIControlStateNormal];
        [_letaoLeftButton addTarget:self action:@selector(letaoLeftButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_letaoLeftButton];
    }
}
- (void)letaoLeftButtonAction {
    [[self xltNavigationController] popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.fullScreen) {
        [self letaohiddenNavigationBar:YES];
    } else {
        [self setupNavigationItem];
    }
    [self changeStatusLightBarStyle:self.isLightBarStyle];

    if ([[XLTUserManager shareManager].curUserInfo.bind_alipay boolValue] != self.isbindAlipay ) {
        self.isbindAlipay = [[XLTUserManager shareManager].curUserInfo.bind_alipay boolValue];
           if (self.isbindAlipay) {
               NSString *inputValueJS = @"bindedAlipay()";
               [self.webView.wkWebView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                           NSLog(@"value: %@ error: %@", response, error);
               }];
           }
       }
    
    // 通知viewWillAppear事件,第一次不发送
    self.viewWillAppearCount ++ ;
    if ( self.viewWillAppearCount > 1) {
        NSString *viewWillAppearEvent = @"viewWillAppearEvent()";
        [self.webView.wkWebView evaluateJavaScript:viewWillAppearEvent completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"value: %@ error: %@", response, error);
        }];
    }
}

- (void)changeStatusLightBarStyle:(BOOL)isLight {
    if (isLight) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            // Fallback on earlier versions
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
}

- (void)setupNavigationItem {
    [self letaoSetupNavigationWhiteBar];
    // 设置刷新和分享按钮
    if (self.showActivityShareButton) {
        UIImage *refreshImage = [[UIImage imageNamed:@"nav_refresh_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithImage:refreshImage style:UIBarButtonItemStylePlain target:self action:@selector(refreshWebAction)];
        
        UIImage *shareImage = [[UIImage imageNamed:@"nav_share2_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithImage:shareImage style:UIBarButtonItemStylePlain target:self action:@selector(shareWebAction)];
        
        self.navigationItem.rightBarButtonItems = @[shareButtonItem,refreshButtonItem];
    } else {
        [self letaoconfigRightBarItemWithImage:[UIImage imageNamed:@"nav_refresh_icon"] target:self action:@selector(refreshWebAction)];
    }
}
- (void)setShowCloseBtn:(BOOL)showCloseBtn{
    if (showCloseBtn && self.navigationItem.leftBarButtonItem) {
        UIImage *shareImage = [[UIImage imageNamed:@"close_icon_black_27"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithImage:shareImage style:UIBarButtonItemStylePlain target:self action:@selector(closeWebAction)];
        NSArray *array = @[self.navigationItem.leftBarButtonItem,shareButtonItem];
        self.navigationItem.leftBarButtonItems = array;
        shareButtonItem.accessibilityElementsHidden = YES;
    }else{
        if (self.navigationItem.leftBarButtonItems.count) {
            self.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItems.firstObject;
        }
    }
}
- (void)closeWebAction{
    [[self xltNavigationController] popViewControllerAnimated:YES];
}
- (void)refreshWebAction {
    [self.webView reloadData];
}

- (void)shareWebAction {
    if ([self.jump_original_URL isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL URLWithString:self.jump_original_URL];
        if (url) {
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
            [self.navigationController presentViewController:activityVC animated:YES completion:nil];
        }
    }
}

- (void)letaopopViewController {
    if (self.webView.wkWebView.canGoBack) {
        [self.webView.wkWebView goBack];
    } else {
        if (self.popBackType == XLTPopBackTopType) {
            [[self xltNavigationController] popViewControllerAnimated:YES];
        } else {
            [[self xltNavigationController] popToRootViewControllerAnimated:YES];
        }
    }
    [self.view endEditing:YES];
}



- (void)right_BarButtonItemAction {
    [self.webView reloadData];
}


// 添加webView，加载扫描过来的内容
- (void)setupWebView {
    self.webView = [XLTWebView webViewWithFrame:self.view.bounds];

    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _webView.progressViewColor = [UIColor letaomainColorSkinColor];
    _webView.webViewDelegate = self;
    [self.view addSubview:_webView];
    [self  webViewloadRequest];
}

- (void)addPublicParametersForJumpUrlIfNeed {
    if ([self.jump_URL isKindOfClass:[NSString class]] && [[XLTAppPlatformManager shareManager] isXinletaoSafeWebDomain:self.jump_URL]) {
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:self.jump_URL];
        NSString *query = urlComponents.query;
        NSString *appID =  [[XLTNetCommonParametersModel defaultModel] appID];
        NSString *appVersion = [XLTAppPlatformManager shareManager].appVersion;
        NSString *appSource = [XLTNetCommonParametersModel defaultModel].appSource;
        
        // 获取存在的参数
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.name) {
                parameters[obj.name] = obj.value;
            }
        }];
        
        // 设置fullScreen
        NSNumber *hideTitlebar =  parameters[@"hideTitlebar"];
        if ([hideTitlebar isKindOfClass:[NSNumber class]]
            || [hideTitlebar isKindOfClass:[NSString class]]) {
            if ([hideTitlebar boolValue]) {
                self.fullScreen = YES;
            }
        }

        // 判断重复的参数,已经存在了不在添加
        NSMutableArray *addQueryArray = [NSMutableArray array];
        if (!parameters[@"appId"]) {
            [addQueryArray addObject:[NSString stringWithFormat:@"appId=%@",appID]];
        }
        if (!parameters[@"appVersion"]) {
            [addQueryArray addObject:[NSString stringWithFormat:@"appVersion=%@",appVersion]];
        }
        
        if (!parameters[@"x-app-source"]) {
            [addQueryArray addObject:[NSString stringWithFormat:@"x-app-source=%@",appSource]];
        }
        
        if (!parameters[@"isApp"]) {
            [addQueryArray addObject:@"isApp=1"];
        }
        
        if (!parameters[@"statusBarH"]) {
            [addQueryArray addObject:[NSString stringWithFormat:@"statusBarH=%ld",(long)kStatusBarHeight]];
        }
        
        if (!parameters[@"bottomSafeH"]) {
            [addQueryArray addObject:[NSString stringWithFormat:@"bottomSafeH=%ld",(long)kBottomSafeHeight]];
        }
       
       if (!parameters[@"x-sid"]) {
           NSString *token = [XLTUserManager shareManager].curUserInfo.token;
           if ([XLTUserManager shareManager].isLogined
               && [token isKindOfClass:[NSString class]]) {
               // 设置token
               [addQueryArray addObject:[NSString stringWithFormat:@"x-sid=%@",token]];
           } else {
               // 空的token
               [addQueryArray addObject:[NSString stringWithFormat:@"x-sid=%@",@""]];
           }
           
       }
       
       if (!parameters[@"x-m"]) {
           NSString *udid =  [FCUUID uuidForDevice];
           if (udid) {
               // 设置udid
               [addQueryArray addObject:[NSString stringWithFormat:@"x-m=%@",udid]];
           } else {
               // 空的udid
               [addQueryArray addObject:[NSString stringWithFormat:@"x-m=%@",@""]];
           }
       }
        
        // 重新设置query
        if (addQueryArray.count) {
            NSString *addQuery = [addQueryArray componentsJoinedByString:@"&"];
            NSString *resulQuery = (query && ![query isEqualToString:@""]) ? [query stringByAppendingString:[NSString stringWithFormat:@"&%@",addQuery]] : addQuery;
            urlComponents.query = resulQuery;

        }
        NSString *resultUrl = urlComponents.URL.absoluteString;
        self.jump_URL = [resultUrl copy];
    }
}

- (void)webViewloadRequest {
    //  添加公共参数
    [self addPublicParametersForJumpUrlIfNeed];
     
    NSString *jump_URLString = [NSString stringWithFormat:@"%@",self.jump_URL];
    NSURL *url = [NSURL URLWithString:jump_URLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];

    NSInteger dev_type = [[XLTNetCommonParametersModel defaultModel] dev_type];
    NSInteger client_type = [[XLTNetCommonParametersModel defaultModel] client_type];
    [request setValue:[[NSNumber numberWithInteger:dev_type] stringValue] forHTTPHeaderField:@"dev-type"];
    [request setValue:[[NSNumber numberWithInteger:client_type] stringValue] forHTTPHeaderField:@"client-type"];
    
    if ([[XLTAppPlatformManager shareManager] isXinletaoSafeWebDomain:self.jump_URL]) {
        NSString *token = [XLTUserManager shareManager].curUserInfo.token;
        if (token) {
            // 设置token
            [request setValue:token forHTTPHeaderField:@"Authorization"];
        }
    }
    NSString *version =  [XLTNetCommonParametersModel defaultModel].version;
    [request setValue:version forHTTPHeaderField:@"client-v"];
    [request setValue:@"1" forHTTPHeaderField:@"check-enable"];
    [_webView loadRequest:request];
}

- (void)webView:(XLTWebView *)webView didFinishLoadWithURL:(NSURL *)url {
    if (self.fullScreen) {
        self.letaoLeftButton.hidden = YES;
    }
}

- (void)webView:(XLTWebView *)webView diChangeNavigationItemTitle:(NSString *)navigationItemTitle {
    self.title = webView.navigationItemTitle;
}

- (void)webView:(XLTWebView *)webView didFailLoadWithError:(NSError *)error {
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 处理协议
    NSString *reqUrl = navigationAction.request.URL.absoluteString;
    if ([reqUrl hasPrefix:@"xkd://"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        if ([reqUrl hasPrefix:@"xkd://user/login"]) {
            [self webViewAskLogin];
        } else if ([reqUrl hasPrefix:@"xkd://user/getToken"]) {
            [self webViewAskToken];
        } else if ([reqUrl hasPrefix:@"xkd://user/info"]) {
            [self webViewAskUserInfo];
        } else if ([reqUrl hasPrefix:@"xkd://app/appPage"]) {
            [self webViewAskOpenPage:reqUrl showActivityShareButton:NO];
        } else if ([reqUrl hasPrefix:@"xkd://app/sign"]) {
            [self webViewAskRequestSignForUrl:reqUrl];
        } else if ([reqUrl hasPrefix:@"xkd://app/bind/taobaoAuth"]) {
            [self webViewOpenBindTaobaoAuthPage];
        } else if ([reqUrl hasPrefix:@"xkd://app/bind/pddAuth"]) {
            [self webViewOpenBindPDDAuthPage:reqUrl];
        }else if ([reqUrl hasPrefix:@"xkd://app/bind/alipay"]) {
            [self webViewOpenBindAliPage];
        } else if ([reqUrl hasPrefix:@"xkd://app/closepage"]) {
            [[self xltNavigationController] popViewControllerAnimated:YES];
        } else if ([reqUrl hasPrefix:@"xkd://app/storage/imgs"]) {
            [self webViewNeedSaveAlbum:reqUrl];
        } else if ([reqUrl hasPrefix:@"xkd://app/alipay"]) {
            [self goAlipay:reqUrl];
        } else if ([reqUrl hasPrefix:@"xkd://app/openTaobao"]
                   || [reqUrl hasPrefix:@"xkd://app/openJd"]
                   || [reqUrl hasPrefix:@"xkd://app/openPdd"]) {
            NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:reqUrl];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.name) {
                    parameters[obj.name] = obj.value;
                }
            }];
            NSString *openURLString = parameters[@"param"];
            if (openURLString.length) {
                if ([reqUrl hasPrefix:@"xkd://app/openTaobao"]) {
                    [[XLTAliManager shareManager] openAliTrandPageWithURLString:openURLString sourceController:self authorized:YES];
                } else if ([reqUrl hasPrefix:@"xkd://app/openJd"]) {
                    [[XLTJingDongManager shareManager] openKeplerPageWithURL:openURLString sourceController:self];
                } else if ([reqUrl hasPrefix:@"xkd://app/openPdd"]) {
                    [[XLTPDDManager shareManager] openPDDPageWithURLString:openURLString sourceController:self close:NO];
                }
            }
        }  else if ([reqUrl hasPrefix:@"xkd://app/openURL"]) {
            NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:reqUrl];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.name) {
                    parameters[obj.name] = obj.value;
                }
            }];
            NSString *openURLString = parameters[@"param"];
            if (openURLString.length) {
                [self webViewAskOpenURL:openURLString];
            }
        } else if ([reqUrl hasPrefix:@"xkd://app/share"]) {
            [self webViewAskSharePage:reqUrl];
        } else if ([reqUrl hasPrefix:@"xkd://savedPhotosAlbum"]) {
            [self webViewAskSavedPhotosAlbum:reqUrl];
        } else if ([reqUrl hasPrefix:@"xkd://showBackButton"]) {
            NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:reqUrl];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.name) {
                    parameters[obj.name] = obj.value;
                }
            }];
            NSString *show = parameters[@"show"];
            self.letaoLeftButton.hidden = (show == nil);
        }  else if ([reqUrl hasPrefix:@"xkd://app/clipboard"]) {
            NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:reqUrl];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.name) {
                    parameters[obj.name] = obj.value;
                }
            }];
            NSString *paramString = parameters[@"param"];
            if ([paramString isKindOfClass:[NSString class]] &&  paramString.length) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = paramString;
                [self showTipMessage:@"复制成功"];
            } else {
                [self showTipMessage:@"复制失败，请长按文字复制"];
            }
        } else if ([reqUrl hasPrefix:@"xkd://app/readclipboard"]) {
            NSString *pasteboardText = [UIPasteboard generalPasteboard].string;
            if ([pasteboardText isKindOfClass:[NSString class]]) {
                pasteboardText = [pasteboardText stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
                pasteboardText = [pasteboardText stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
                pasteboardText = [pasteboardText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            }
            NSString *inputValueJS = [NSString stringWithFormat:@"readClipboard('%@')",pasteboardText ? pasteboardText : @""];
            [self.webView.wkWebView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                NSLog(@"value: %@ error: %@", response, error);
                if (error == nil) {
                    [UIPasteboard generalPasteboard].string = @"";
                }
            }];
        } else if ([reqUrl hasPrefix:@"xkd://app/notification/status"]) {
            __weak typeof(self)weakSelf = self;
            [self checkSystemPushSwitchEnabled:^(BOOL status) {
                weakSelf.isSystemPushSwitchEnabled = status;
                // 回调结果
                [weakSelf callBackToWebSystemPushSwitchEnabled:status];
            }];
        } else if ([reqUrl hasPrefix:@"xkd://app/notification/setting"]) {
            [self opentApplicationOpenSettings];
        } else if ([reqUrl hasPrefix:@"xkd://app/statusbar"]) {
            // 修改状态栏颜色
            [self webViewAskChangeStatusBarStyleForReqUrl:reqUrl];
        } else if ([reqUrl hasPrefix:@"xkd://app/nativeAdJump"]) {
            // 广告跳转
            [self webViewAdJumpForReqUrl:reqUrl];
        }
    } else if ([reqUrl hasPrefix:@"weixin://"] // 微信
               || [reqUrl hasPrefix:@"alipay://"] // 支付宝
               || [reqUrl hasPrefix:@"bdnetdisk://"] //百度网盘
               || [reqUrl hasPrefix:@"imeituan://"] // 美团
               || [reqUrl hasPrefix:@"didapinche://"] //滴嗒出行
               || [reqUrl hasPrefix:@"tel:"]) { //打电话
        decisionHandler(WKNavigationActionPolicyCancel);
        [self webViewAskOpenURL:reqUrl];
    } else if ([reqUrl hasPrefix:@"taobao://"] //淘宝
               || [reqUrl hasPrefix:@"tbopen://"] //淘宝
               || [reqUrl hasPrefix:@"vipshop://"] //唯品会
               || [reqUrl hasPrefix:@"pinduoduo://"] //拼多多
               || [reqUrl hasPrefix:@"suning://"]) {//苏宁
        decisionHandler(WKNavigationActionPolicyCancel);
        if (!self.disableTbPddVphScheme) {
           [self webViewAskOpenURL:reqUrl];
        }
    } else if (self.shouldDecideGoodsActivity && [self decideGoodsActivityPolicyForNavigationAction:navigationAction]) {
        /**
         *  处理商品活动NavigationUrl
         */
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}



- (void)webViewAskOpenURL:(NSString *)url {
    if ([url isKindOfClass:[NSString class]] && url.length > 0) {
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *openURL = [NSURL URLWithString:url];
        if (@available(iOS 10.0, *)) {
            [application openURL:openURL options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    // do nothing
                }
            }];
        } else {
            // Fallback on earlier versions
            if ([application canOpenURL:openURL]) {
                [application openURL:openURL];
             } else {
                // do nothing
            };
        }
    }
}

- (void)webViewAskRequestSignForUrl:(NSString *)url {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name) {
            parameters[obj.name] = obj.value;
        }
    }];
    NSString *pageInfoString = parameters[@"param"];
    if (pageInfoString.length) {
        NSData *jsonData = [pageInfoString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *pageInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if(!err && [pageInfo isKindOfClass:[NSDictionary class]]) {
            NSString *urlPath = pageInfo[@"url"];
            NSDictionary *paramsData = pageInfo[@"params"];
            if (![paramsData isKindOfClass:[NSDictionary class]]) {
                paramsData = @{};
            }
            if ([urlPath isKindOfClass:[NSString class]]) {
                NSDictionary *secrtetDictionary = [self generateSecrtetWithParameters:paramsData path:urlPath];
                NSString *jsonString = [secrtetDictionary modelToJSONString];
                if ([jsonString isKindOfClass:[NSString class]]) {
                    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
                }
                NSString *jsonParamsDataString = [paramsData modelToJSONString];
                if ([jsonParamsDataString isKindOfClass:[NSString class]]) {
                    jsonParamsDataString = [jsonParamsDataString stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
                }
                NSString *inputValueJS = [NSString stringWithFormat:@"signResult('%@','%@','%@')",urlPath,jsonParamsDataString,jsonString ? jsonString : @""];
                [self.webView.wkWebView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                     NSLog(@"value: %@ error: %@", response, error);
                 }];
            }
        }
    }
}

- (void)webViewOpenBindTaobaoAuthPage {
    if (![XLTUserManager shareManager].isLogined) {
          [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        if (![[XLTUserManager shareManager].curUserInfo.has_bind_tb boolValue]) {
            [self cancelAllRequest];
            NSURLSessionTask *sessionTask = [[XLTAliManager shareManager] xingletaonetwork_requestTaoBaoAuthUrlSuccess:^(NSString * _Nonnull authUrl, NSURLSessionDataTask * _Nonnull task) {
                if ([self.allSessionTask containsObject:task]) {
                    [self.allSessionTask removeObject:task];
                    [[XLTAliManager shareManager] openAliTrandPageWithURLString:authUrl sourceController:self authorized:NO];
                }
            } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
                if ([self.allSessionTask containsObject:task]) {
                    [self.allSessionTask removeObject:task];
                    [self showTipMessage:errorMsg];
                }
            }];
            sessionTask ? [self.allSessionTask  addObject:sessionTask] : nil ;
        } else {
            [self taoBaoAuthComplete];
        }
    }

}
- (void)webViewOpenBindPDDAuthPage:(NSString *)url {
    if (![XLTUserManager shareManager].isLogined) {
          [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.name) {
                parameters[obj.name] = obj.value;
            }
        }];
        NSString *pageInfoString = parameters[@"param"];
        if (pageInfoString.length) {
            NSData *jsonData = [pageInfoString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *pageInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
            [[XLTPDDManager shareManager] openPDDPageWithURLString:pageInfoString sourceController:self close:NO];
        
        
        }
    }

}

- (void)cancelAllRequest {
    @synchronized (self) {
        [self.allSessionTask enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [self.allSessionTask removeAllObjects];
    }
}

- (void)receivedAuthTaoBaoCompleteNotification {
    [self taoBaoAuthComplete];
}

- (void)taoBaoAuthComplete {
    NSString *inputValueJS = @"taoBaoAuthComplete()";
    [self.webView.wkWebView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"value: %@ error: %@", response, error);
    }];
}



- (void)webViewOpenBindAliPage {
    self.isbindAlipay = [[XLTUserManager shareManager].curUserInfo.bind_alipay boolValue];
    if (self.isbindAlipay) {
        NSString *inputValueJS = @"bindedAlipay()";
        [self.webView.wkWebView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
             NSLog(@"value: %@ error: %@", response, error);
         }];
    } else {
        XLTUserBindAliPayVC *bindAliPayVC = [[XLTUserBindAliPayVC alloc] init];
        [[self xltNavigationController] pushViewController:bindAliPayVC animated:YES];
    }
}


- (void)webViewAskLogin {
    [[XLTUserManager shareManager] displayLoginViewController];
}

- (void)webViewAskToken {
    NSString *token = [XLTUserManager shareManager].curUserInfo.token;
    if ([token isKindOfClass:[NSString class]]) {
        token = [token stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    }
    NSString *inputValueJS = [NSString stringWithFormat:@"userLoginStatus('%@')",token ? token : @""];
    [self.webView.wkWebView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"value: %@ error: %@", response, error);
    }];
}

// 获取用户信息
- (void)webViewAskUserInfo {
    NSString *jsonString = nil;
    if ([XLTUserManager shareManager].isLogined) {
        XLTUserInfoModel *curUserInfo = [XLTUserManager shareManager].curUserInfo;
        NSDictionary *info =  [curUserInfo modelToJSONObject];
        if ([info isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *userInfo = info.mutableCopy;
           
            userInfo[@"is_new_user"] = nil;
            if (curUserInfo.userNameInfo != nil) {
                userInfo[@"username"] = curUserInfo.userNameInfo;
            }
            NSString *new_code = userInfo[@"xlt_new_code"];
            userInfo[@"xlt_new_code"] = nil;
            userInfo[@"new_code"] = new_code;
            jsonString = [userInfo modelToJSONString];
            if ([jsonString isKindOfClass:[NSString class]]) {
                jsonString = [jsonString stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
            }
        }
    }
    NSString *inputValueJS = [NSString stringWithFormat:@"userInfoCallback('%@')",jsonString ? jsonString : @""];
    [self.webView.wkWebView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"value: %@ error: %@", response, error);
    }];
}

- (void)webViewAskChangeStatusBarStyleForReqUrl:(NSString *)url {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name) {
            parameters[obj.name] = obj.value;
        }
    }];
    NSNumber *isLightBar = parameters[@"param"];
    if ([isLightBar isKindOfClass:[NSNumber class]] || [isLightBar isKindOfClass:[NSString class]]) {
        self.isLightBarStyle = ([isLightBar integerValue] == 0);
        [self changeStatusLightBarStyle:self.isLightBarStyle];
    }
}

- (void)webViewAdJumpForReqUrl:(NSString *)url {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name) {
            parameters[obj.name] = obj.value;
        }
    }];
    NSString *adInfoJson = parameters[@"param"];
    NSData *jsonData = [adInfoJson dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *adInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
    if(!err) {
        [[XLTAdManager shareManager] adJumpWithInfo:adInfo sourceController:self];
    }
}

- (void)webViewAskOpenPage:(NSString *)url showActivityShareButton:(BOOL)show {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name) {
            parameters[obj.name] = obj.value;
        }
    }];
    NSString *pageInfoString = parameters[@"param"];
    if (pageInfoString.length) {
        NSData *jsonData = [pageInfoString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *pageInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if(!err && [pageInfo isKindOfClass:[NSDictionary class]]) {
            NSString *page = pageInfo[@"page"];
            NSDictionary *data = pageInfo[@"data"];
            NSNumber *closepage = pageInfo[@"closepage"];
            if ([page isKindOfClass:[NSString class]]) {
                if ([page isEqualToString:@"GoodsDetailPage"]) {
                    // 1．商品详情页面：
                    [self webViewOpenGoodsPage:data closepage:closepage];
                } else if ([page isEqualToString:@"WebViewPage"]) {
                    //2.WebView页面
                    [self webViewOpenWebPage:data closepage:closepage showActivityShareButton:show];
                } else if ([page isEqualToString:@"VipPage"]) {
                    //3、会员页面
                    [self webViewOpenVipPage:data closepage:closepage];
                } else if ([page isEqualToString:@"InvitatePage"]) {
                    //4、邀请页面
                    [self webViewOpenInvitePage:data closepage:closepage];
                } else if ([page isEqualToString:@"activity"]) {
                    //5、平台活动
                    [self webViewOpenActivityPage:data closepage:closepage];
                } else if ([page isEqualToString:@"me"]) {
                    //6、个人中心
                    [self webViewOpenMinePage:data closepage:closepage];
                } else if ([page isEqualToString:@"HomePage"]) {
                    //6、首页
                    [self webViewOpenHomeIndexPage:data closepage:closepage];
                }
                else if ([page isEqualToString:@"earning"]) {
                    //7、收益报表
                    [self webViewOpenMyEarningsReportPage:data closepage:closepage];
                } else if ([page isEqualToString:@"teamOrder"]) {
                    //8、粉丝订单
                    [self webViewOpenMyTeamOrderPage:data closepage:closepage];
                } else if ([page isEqualToString:@"selfOrder"]) {
                    //9、我的订单
                    [self webViewOpenMyOrderPage:data closepage:closepage];
                } else if ([page isEqualToString:@"myteam"]) {
                    //10、我的粉丝
                    [self webViewOpenMyTeamPage:data closepage:closepage];
                } else if ([page isEqualToString:@"balance"]) {
                    //11、我的余额
                    [self webViewOpenMyBalancePage:data closepage:closepage];
                } else if ([page isEqualToString:@"withdraw"]) {
                    //12、提现
                    [self webViewOpenDrawPage:data closepage:closepage];
                } else if ([page isEqualToString:@"findOrder"]) {
                    //13、找回订单
                    [self webViewOpenOrderFindPage:data closepage:closepage];
                } else if ([page isEqualToString:@"sendCircle"]) {
                    //14、发圈
                    [self webViewOpenShareFeedPage:data closepage:closepage];
                } else if ([page isEqualToString:@"searchPage"]) {
                    //15、搜索页面
                    [self webViewOpenGoodsSearchPage:data closepage:closepage];
                } else if ([page isEqualToString:@"scan"]) {
                    //16、扫一扫
                    [self webViewOpenQRCodeScanPage:data closepage:closepage];
                } else if ([page isEqualToString:@"collection"]) {
                    //17、收藏页面
                    [self webViewOpenCollectPage:data closepage:closepage];
                } else if ([page isEqualToString:@"platePage"]) {
                    //18、 跳转到板块页面
                    [self webViewOpenPlatePage:data closepage:closepage];
                } else if ([page isEqualToString:@"wechatPage"]) {
                    //19、 跳转到填写微信页面
                    [self webViewInputWXinInfoPage:data closepage:closepage];
                } else if ([page isEqualToString:@"dyPage"]) {
                    //20、 抖音券
                    [self webViewOpenDYVideoInfoPage:data closepage:closepage];
                } else if ([page isEqualToString:@"videoPlayerPage"]) {
                    //21、 新手视频
                    [self webViewOpenVideoInfoPage:data closepage:closepage];
                } else if ([page isEqualToString:@"actDetail"]) {
                    // 22、 自定义活动页面
                    [self webViewOpenCustomActivityInfoPage:data closepage:closepage];
                } else if ([page isEqualToString:@"openApplication"]) {
                    // 23、 打开第三方app
                    [self webViewOpenApplicationInfoPage:data closepage:closepage];
                } else if ([page isEqualToString:@"CommunityGoodsRecm"]) {
                    // 24、 我的推荐
                    [self webViewOpenCommunityGoodsRecmPage:data closepage:closepage];
                } else if ([page isEqualToString:@"kuaidian"]) {
                    // 25、 快电
                    [DadaCharge openDadaCharge:self configParams:@{@"platformCode":[XLTUserManager shareManager].curUserInfo.phone}];
                }else if ([page isEqualToString:@"privilegePage"]) {
                    // 26、 特权
                    [self webViewOpenPrivilegeIndexPage:data closepage:closepage];
                }else if ([page isEqualToString:@"mallPage"]) {
                    // 27、 直营
                    [self webViewOpenMallPageIndexPage:data closepage:closepage];
                }else if ([page isEqualToString:@"mallGoodDetailPage"]) {
                    // 27、 直营详情
                    [self webViewOpenMallmallGoodDetailPageIndexPage:data closepage:closepage];
                }
            }
        }
    }

}

- (void)webViewOpenActivityPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *itemInfo = [data mutableCopy];
        NSString *platform = data[@"platform"];
        BOOL isPlatformValid = [platform isKindOfClass:[NSString class]] && platform.length > 0;
        if (isPlatformValid) {
            itemInfo[@"platform"] = platform.uppercaseString;
        }
        NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
        if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
            [viewControllers removeObject:self];
            [[self xltNavigationController] setViewControllers:viewControllers animated:NO];
        }
        [[XLTAdManager shareManager] webActivityJumpWithInfo:itemInfo sourceController:viewControllers.lastObject];
    }
}

- (void)webViewOpenGoodsPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSString *letaoGoodsId = data[@"goods_id"];
        NSString *item_source = data[@"item_source"];
        if ([letaoGoodsId isKindOfClass:[NSString class]] && letaoGoodsId.length > 0) {
            
            // 任务处理
            NSDictionary *taskInfo = nil;
            if ([data[@"taskInfo"] isKindOfClass:[NSDictionary class]]) {
                taskInfo = data[@"taskInfo"];
            }
            
            XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
            goodDetailViewController.letaoGoodsId = letaoGoodsId;
            goodDetailViewController.letaoIsCustomPlate = NO;
            goodDetailViewController.letaoGoodsSource = item_source;
            NSString *letaoGoodsItemId = data[@"item_id"];
            goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;
            goodDetailViewController.taskInfo = taskInfo;
            NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
            if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
                [viewControllers removeObject:self];
            }
            [viewControllers addObject:goodDetailViewController];
            [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
        }
    }
}

- (UINavigationController *)xltNavigationController {
    if (self.xlt_navigationController) {
        return self.xlt_navigationController;
    } else {
        return self.navigationController;
    }
}


// 打开首页VIP
- (void)webViewOpenVipPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        [[self xltNavigationController] popToRootViewControllerAnimated:YES];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        XLTTabBarController *tab = delegate.tabBar;
        if (tab.viewControllers.count > 2) {
            if ([tab.viewControllers[2] isKindOfClass:[XLTVipVC class]]) {
                tab.selectedIndex = 2;
            }
        }
    }
}

// 打开我的邀请
- (void)webViewOpenInvitePage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
         [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        if (![XLTUserManager shareManager].isInvited) {
            if ([XLTAppPlatformManager shareManager].checkEnable) {
                // 邀请页面
                [MBProgressHUD letaoshowTipMessageInWindow:@"请先设置上级邀请码"];
                XLTUpdateMyInviterVC *updateMyInviterVC = [[XLTUpdateMyInviterVC alloc] init];
                [[self xltNavigationController] pushViewController:updateMyInviterVC animated:YES];
                return;
            }
        }
        
        // 任务处理
        NSDictionary *taskInfo = nil;
        if ([data[@"taskInfo"] isKindOfClass:[NSDictionary class]]) {
            taskInfo = data[@"taskInfo"];
        }
        XLTUserInvateVC *vc = [[XLTUserInvateVC alloc] init];
        vc.taskInfo = taskInfo;
        NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
        if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
            [viewControllers removeObject:self];
        }
        [viewControllers addObject:vc];
        [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
    }

}

- (void)webViewOpenWebPage:(NSDictionary *)data closepage:(NSNumber *)closepage showActivityShareButton:(BOOL)show {
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSString *url = data[@"url"];
        if ([url isKindOfClass:[NSString class]] && url.length > 0) {
            
            // 任务处理
            NSDictionary *taskInfo = nil;
            if ([data[@"taskInfo"] isKindOfClass:[NSDictionary class]]) {
                taskInfo = data[@"taskInfo"];
            }
            XLTWKWebViewController *web = nil;
            NSString *path = [NSURL URLWithString:url].path;
            // path包含ac202003jiayou任务是团油类页面
            if([path isKindOfClass:[NSString class]] && [path containsString:@"ac202003jiayou"]) { // 团油使用特殊网页
                web = [[CZBWebViewController alloc] init];
                web.jump_URL = url;
            } else {
                // 普通页面加载
                web =  [[XLTWKWebViewController alloc] init];
                web.showActivityShareButton = show;
                web.taskInfo = taskInfo;
                web.jump_URL = url;
                web.title = @"星乐桃";
            }
            NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
            if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
                [viewControllers removeObject:self];
            }
            [viewControllers addObject:web];
            [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
        }
    }
}

//个人中心
- (void)webViewOpenMinePage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        [[self xltNavigationController] popToRootViewControllerAnimated:YES];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        XLTTabBarController *tab = delegate.tabBar;
        if (tab.viewControllers.count > 1) {
            tab.selectedIndex = tab.viewControllers.count -1;

            // 任务汇报处理
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *taskInfo = data[@"taskInfo"];
                if ([taskInfo isKindOfClass:[NSDictionary class]] && taskInfo.count > 0) {
                    [[XLTUserTaskManager shareManager] letaoRepoCheckCommissionTaskInfo];
                }
            }
        }
    }
}


//首页
- (void)webViewOpenHomeIndexPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        [[self xltNavigationController] popToRootViewControllerAnimated:YES];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        XLTTabBarController *tab = delegate.tabBar;
        if (tab.viewControllers.count > 0) {
            tab.selectedIndex = 0;
        }
    }
}
//特权页
- (void)webViewOpenPrivilegeIndexPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        [[self xltNavigationController] popToRootViewControllerAnimated:YES];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        XLTTabBarController *tab = delegate.tabBar;
        if (tab.viewControllers.count > 0) {
            tab.selectedIndex = 1;
        }
    }
}
//直营页
- (void)webViewOpenMallPageIndexPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        [[self xltNavigationController] popToRootViewControllerAnimated:YES];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        XLTTabBarController *tab = delegate.tabBar;
        if (tab.viewControllers.count > 0) {
            tab.selectedIndex = 2;
        }
    }
}
//直营商品详情页
- (void)webViewOpenMallmallGoodDetailPageIndexPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    XLTUserBalanceDrawVC *vc = [[XLTUserBalanceDrawVC alloc] init];
    NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
    if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
        [viewControllers removeObject:self];
    }
    [viewControllers addObject:vc];
    [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
}
 // 收益报表
- (void)webViewOpenMyEarningsReportPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
         [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        XLTIncomeVC *vc = [[XLTIncomeVC alloc] init];
        NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
        if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
            [viewControllers removeObject:self];
        }
        [viewControllers addObject:vc];
        [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
    }

}

 // 粉丝订单
- (void)webViewOpenMyTeamOrderPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
         [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        XLTRootOrderVC *vc = [[XLTRootOrderVC alloc] init];
        NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
        if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
            [viewControllers removeObject:self];
        }
        [viewControllers addObject:vc];
        [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
    }

}

 // 我的订单
- (void)webViewOpenMyOrderPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
         [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        XLTRootOrderVC *vc = [[XLTRootOrderVC alloc] init];
        NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
        if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
            [viewControllers removeObject:self];
        }
        [viewControllers addObject:vc];
        [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
    }

}

 // 我的粉丝
- (void)webViewOpenMyTeamPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
         [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        if (![XLTUserManager shareManager].isInvited) {
            if ([XLTAppPlatformManager shareManager].checkEnable) {
                // 邀请页面
                [MBProgressHUD letaoshowTipMessageInWindow:@"请先设置上级邀请码"];
                XLTUpdateMyInviterVC *updateMyInviterVC = [[XLTUpdateMyInviterVC alloc] init];
                [[self xltNavigationController] pushViewController:updateMyInviterVC animated:YES];
                return;
            }
        }
        XLTMyTeamVC *vc = [[XLTMyTeamVC alloc] init];
        NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
        if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
            [viewControllers removeObject:self];
        }
        [viewControllers addObject:vc];
        [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
    }

}

 // 我的余额
- (void)webViewOpenMyBalancePage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
         [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        XLTUserBalanceDrawVC *vc = [[XLTUserBalanceDrawVC alloc] init];
        NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
        if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
            [viewControllers removeObject:self];
        }
        [viewControllers addObject:vc];
        [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
    }

}

 // 提现
- (void)webViewOpenDrawPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
         [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        XLTUserWithDrawVC *vc = [[XLTUserWithDrawVC alloc] init];
        NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
        if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
            [viewControllers removeObject:self];
        }
        [viewControllers addObject:vc];
        [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
    }

}

 // 找回订单
- (void)webViewOpenOrderFindPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
         [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        XLTOrderFindVC *vc = [[XLTOrderFindVC alloc] initWithNibName:@"XLTOrderFindVC" bundle:[NSBundle mainBundle]];
        NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
        if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
            [viewControllers removeObject:self];
        }
        [viewControllers addObject:vc];
        [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
    }

}

// 打开首页发圈
- (void)webViewOpenShareFeedPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        [[self xltNavigationController] popToRootViewControllerAnimated:YES];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        XLTTabBarController *tab = delegate.tabBar;
        if (tab.viewControllers.count > 3) {
            if ([tab.viewControllers[3] isKindOfClass:[XLTShareFeedContainerVC class]]) {
                tab.selectedIndex = 3;
            }
        }
    }
}


 // 搜索
- (void)webViewOpenGoodsSearchPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    NSString *search = data[@"search"];
    NSString *item_source = data[@"item_source"];
    NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;

    if ([search isKindOfClass:[NSString class]] && search.length > 0) {
        XLTSearchViewController *searchViewController = [[XLTSearchViewController alloc] init];
        searchViewController.letaoSearchText = search;
        searchViewController.item_source = item_source;
        [viewControllers addObject:searchViewController];
        
        XLTGoodsSearchReultVC *reultViewController = [[XLTGoodsSearchReultVC alloc] init];
        reultViewController.letaoSearchText = search;
        reultViewController.item_source = item_source;
        [viewControllers addObject:reultViewController];
                    
        [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
    } else {
        XLTSearchViewController *vc = [[XLTSearchViewController alloc] init];
        vc.item_source = item_source;
        if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
            [viewControllers removeObject:self];
        }
        [viewControllers addObject:vc];
        [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
    }
}
// 调起支付宝
- (void)goAlipay:(NSString *)reqUrl {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:reqUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name) {
            parameters[obj.name] = obj.value;
        }
    }];
    NSString *url = parameters[@"param"];
    [XLTAlipayManager alipayPayWithOrderStr:url];
    
}
// 保存相册
- (void)webViewNeedSaveAlbum:(NSString *)reqUrl {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:reqUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name) {
            parameters[obj.name] = obj.value;
        }
    }];
    NSString *pic_url = parameters[@"param"];
    __weak typeof(self)weakSelf = self;
    if ([pic_url isKindOfClass:[NSString class]] && pic_url.length) {
        [self letaoShowLoading];
        [self downloadImage:pic_url complete:^(UIImage * _Nullable image) {
            [weakSelf letaoRemoveLoading];
            if (image) {
                [weakSelf saveAlbumWithVideoArray:nil imageArray:@[image]];
            } else {
                [self showTipMessage:Data_Error];
            }
        }];
    }
}


// 保存相册
- (void)webViewAskSavedPhotosAlbum:(NSString *)reqUrl {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:reqUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name) {
            parameters[obj.name] = obj.value;
        }
    }];
    NSString *paramString = parameters[@"param"];
    if (paramString.length) {
        NSData *jsonData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *pageInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if(!err && [pageInfo isKindOfClass:[NSDictionary class]]) {
            __weak typeof(self)weakSelf = self;
            [self downLoadResource:pageInfo complete:^(NSArray *videoArray, NSArray *imageArray) {
                if (videoArray.count + imageArray.count > 0) {
                    [weakSelf saveAlbumWithVideoArray:videoArray imageArray:imageArray];
                } else {
                    [weakSelf showTipMessage:@"下载失败"];
                }
            }];
        }
    }
}

- (void)downLoadResource:(NSDictionary *)info complete:(void(^)(NSArray *videoArray, NSArray *imageArray))complete {
    NSArray *images = nil;
    NSArray *videos = nil;
    NSString *content = nil;
    NSString *itemId = nil;
    if ([info isKindOfClass:[NSDictionary class]]) {
        if ([info[@"images"] isKindOfClass:[NSArray class]]) {
            images = info[@"images"];
        }
        if ([info[@"videos"] isKindOfClass:[NSArray class]]) {
            videos = info[@"videos"];
        }
        if ([info[@"content"] isKindOfClass:[NSString class]]) {
            content = info[@"content"];
        }
        itemId = info[@"_id"];
        
    }
    NSMutableArray *mediaArray = [NSMutableArray array];
    if (videos.count) {
        [mediaArray addObjectsFromArray:videos];
    }
    if (images.count) {
        [mediaArray addObjectsFromArray:images];
    }
    if (mediaArray.count > 0) {
        XLTShareFeedMediaDownloadVC *mediaDownloadVC = [[XLTShareFeedMediaDownloadVC alloc] init];
        [mediaDownloadVC letaoPresentWithSourceVC:self.navigationController downloadMediaWithItemInfo:info complete:^(NSArray * _Nonnull videoArray, NSArray * _Nonnull imageArray) {
            complete(videoArray,imageArray);
        }];
    } else {
        complete(@[],@[]);
    }
}

// 分享
- (void)webViewAskSharePage:(NSString *)reqUrl {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:reqUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name) {
            parameters[obj.name] = obj.value;
        }
    }];
    NSString *paramString = parameters[@"param"];
    if (paramString.length) {
        NSData *jsonData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *pageInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if(!err && [pageInfo isKindOfClass:[NSDictionary class]]) {
            NSString *title = pageInfo[@"title"];
            NSString *content = pageInfo[@"content"];
            NSString *url = pageInfo[@"url"];
            NSString *pic_url = pageInfo[@"pic_url"];
            
            // 任务处理
            NSDictionary *taskInfo = nil;
            if ([pageInfo[@"taskInfo"] isKindOfClass:[NSDictionary class]]) {
                taskInfo = pageInfo[@"taskInfo"];
            }
            
            __weak typeof(self)weakSelf = self;
            if ([pic_url isKindOfClass:[NSString class]] && pic_url.length) {
                [self letaoShowLoading];
                [self downloadImage:pic_url complete:^(UIImage * _Nullable image) {
                    [weakSelf letaoRemoveLoading];
                    [weakSelf startShareWithTitle:title content:content image:image url:url taskInfo:taskInfo];
                }];
            } else {
                 [self startShareWithTitle:title content:content image:nil url:url taskInfo:taskInfo];
            }
            
        }
    }
}

- (void)startShareWithTitle:(NSString *)title content:(NSString *)content image:(UIImage *)image url:(NSString *)url taskInfo:(NSDictionary * _Nullable)taskInfo {
    if (title || content || url || image) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        NSMutableArray *textArray = [NSMutableArray array];
        if (title) {
            [textArray addObject:title];
        }
        if (content) {
            [textArray addObject:content];
        }
        if ([textArray count] > 0) {
            [items addObject:[NSString stringWithFormat:@"%@",[textArray componentsJoinedByString:@""]]];
        }
        if (url) {
            NSURL *shareUrl = [NSURL URLWithString:url];
            if (shareUrl) {
                [items addObject:shareUrl];
            }
        }
        if (image) {
            [items addObject:image];
        }
        if (items) {
            __weak typeof(self)weakSelf = self;
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:[XLTGoodsDisplayHelp processSizeForShareActivityItems:items goodsImage:nil] applicationActivities:nil];
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
            [[self xltNavigationController] presentViewController:activityVC animated:TRUE completion:nil];
        }
    }
}


- (void)downloadImage:(NSString *)imageUrl complete:(void(^)(UIImage * _Nullable image))complete {
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image && !error) {
                complete(image);;
            } else {
               complete(nil);
            }
        });
    }];
}

 // 扫一扫
- (void)webViewOpenQRCodeScanPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
                case AVAuthorizationStatusNotDetermined: {
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        if (granted) {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                XLTQRCodeScanViewController *vc = [[XLTQRCodeScanViewController alloc] init];
                                NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
                                if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
                                    [viewControllers removeObject:self];
                                }
                                [viewControllers addObject:vc];
                                [[self xltNavigationController] setViewControllers:viewControllers animated:YES];                                });
                            NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                        } else {
                            NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                        }
                    }];
                    break;
                }
                case AVAuthorizationStatusAuthorized: {
                    XLTQRCodeScanViewController *vc = [[XLTQRCodeScanViewController alloc] init];
                    NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
                    if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
                        [viewControllers removeObject:self];
                    }
                    [viewControllers addObject:vc];
                    [[self xltNavigationController] setViewControllers:viewControllers animated:YES];;
                    break;
                }
                case AVAuthorizationStatusDenied: {
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - 星乐桃] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    [alertC addAction:alertA];
                    [self presentViewController:alertC animated:YES completion:nil];
                    break;
                }
                case AVAuthorizationStatusRestricted: {
                    NSLog(@"因为系统原因, 无法访问相册");
                    break;
                }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

 // 收藏
- (void)webViewOpenCollectPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
         [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        XLTCollectVC *vc = [[XLTCollectVC alloc] init];
        NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
        if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
            [viewControllers removeObject:self];
        }
        [viewControllers addObject:vc];
        [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
    }

}
 
// 跳转到板块页面
#pragma mark -  模块跳转处理


//实时爆款
#define kPlateHotCode @"500300"
//大额券
#define kPlateCouponCode @"500100"
//9.9
#define kPlateP_99Code @"500200"

//新9.9板块
#define kPlate_NineYuanNine_Code @"500203"
- (void)webViewOpenPlatePage:(NSDictionary *)itemInfo closepage:(NSNumber *)closepage {
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSString *dev_code = itemInfo[@"dev_code"];
        NSString *letaoCurrentPlateId = itemInfo[@"plate_id"];
        NSString *plateName = [itemInfo[@"name"] isKindOfClass:[NSString class]] ? itemInfo[@"name"] : nil;
        NSNumber *is_dev = [itemInfo[@"is_dev"] isKindOfClass:[NSNumber class]] ? itemInfo[@"is_dev"] : @0;
        NSNumber *ch_set_icon = [itemInfo[@"ch_set_icon"] isKindOfClass:[NSNumber class]] ? itemInfo[@"ch_set_icon"] : @0;
        // 汇报事件
//        [SDRepoManager xltrepo_trackPlatleClickEvent:nil xlt_item_id:letaoCurrentPlateId xlt_item_title:plateName];

        // 任务处理
        NSDictionary *taskInfo = nil;
        if ([itemInfo[@"taskInfo"] isKindOfClass:[NSDictionary class]]) {
            taskInfo = itemInfo[@"taskInfo"];
        }
        
        // 新9.9板块
        if ([dev_code isKindOfClass:[NSString class]] && [dev_code isEqualToString:kPlate_NineYuanNine_Code]) {
            XLTNineYuanNineContainerVC *nineYuanNineContainerVC = [[XLTNineYuanNineContainerVC alloc] init];
            [[self xltNavigationController] pushViewController:nineYuanNineContainerVC animated:YES];
            nineYuanNineContainerVC.taskInfo = taskInfo;
            return;
        }
        
        // 红人街
        if ([dev_code isKindOfClass:[NSString class]] && [dev_code isEqualToString:kPlateRedCode]) {
            [[XLTRepoDataManager shareManager] repoRedStreetWithPlate:letaoCurrentPlateId childPlate:nil];
            XLTStreetTabBarController *streetTabBarController = [[XLTStreetTabBarController alloc] init];
            [[self xltNavigationController] pushViewController:streetTabBarController animated:YES];
            XLTBaseViewController *firstViewControlle = streetTabBarController.viewControllers.firstObject;
            if ([firstViewControlle isKindOfClass:[XLTBaseViewController class]]) {
                firstViewControlle.taskInfo = taskInfo;
            }
            return;
        }
         
        XLTPlateType type = XLTPlateCommonType;
        if ([dev_code isKindOfClass:[NSString class]] && [dev_code isEqualToString:kPlateHotCode]) {
             type = XLTPlateHotType;
        } else if ([dev_code isKindOfClass:[NSString class]] && [dev_code isEqualToString:kPlateCouponCode]) {
             type = XLTPlateCouponType;
        } else if ([dev_code isKindOfClass:[NSString class]] && [dev_code isEqualToString:kPlateP_99Code]) {
            type = XLTPlate_99Type;
        }
        

        if (type == XLTPlateHotType
            || type == XLTPlateCouponType
            || type == XLTPlate_99Type
            || ([is_dev intValue] == 0 && [ch_set_icon intValue] != 1)) {

            XLTHomePlateContainerVC *plateViewController = [[XLTHomePlateContainerVC alloc] init];
            plateViewController.letaoCurrentPlateId = letaoCurrentPlateId;
            plateViewController.plateName = plateName;
            plateViewController.plateType = type;
            plateViewController.taskInfo = taskInfo;
            [[self xltNavigationController] pushViewController:plateViewController animated:YES];
            [[XLTRepoDataManager shareManager] repoPlateViewPage:letaoCurrentPlateId childPlate:nil];
        } else {
            if ([is_dev intValue] == 0 && [ch_set_icon intValue] == 1) {
                XLTHomePlateFilterListVC *plateFilterListViewController = [[XLTHomePlateFilterListVC alloc] init];
                plateFilterListViewController.letaoCurrentPlateId = letaoCurrentPlateId;
                plateFilterListViewController.plateName = plateName;
                plateFilterListViewController.letaoParentPlateId = letaoCurrentPlateId;
                plateFilterListViewController.taskInfo = taskInfo;
                [[self xltNavigationController] pushViewController:plateFilterListViewController animated:YES];
                [[XLTRepoDataManager shareManager] repoPlateViewPage:letaoCurrentPlateId childPlate:nil];
            }
            
        }
    }

}

//19、 跳转到填写微信页面
- (void)webViewInputWXinInfoPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
         [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        NSNumber *levelNumber = [XLTUserManager shareManager].curUserInfo.level;
        if ([levelNumber isKindOfClass:[NSString class]]
            || [levelNumber isKindOfClass:[NSNumber class]]) {
            NSInteger level = levelNumber.integerValue;
            if (level == 3 || level == 4) {
                XLTBindWXVC *vc = [[XLTBindWXVC alloc] init];
                NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
                if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
                    [viewControllers removeObject:self];
                }
                [viewControllers addObject:vc];
                [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
            }
        }
    }
}

// 20、 抖音券
- (void)webViewOpenDYVideoInfoPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    DYVideoContainerViewController *vc = [[DYVideoContainerViewController alloc] init];
    NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
    if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
        [viewControllers removeObject:self];
    }
    [viewControllers addObject:vc];
    [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
}

// 21、 新手视频
- (void)webViewOpenVideoInfoPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    NSString *letaoVideoUrl = data[@"url"];
    if ([letaoVideoUrl isKindOfClass:[NSString class]] && letaoVideoUrl.length > 0) {
        XLTFullScreenVideoVC *vc = [[XLTFullScreenVideoVC alloc] initWithNibName:@"XLTFullScreenVideoVC" bundle:[NSBundle mainBundle]];
        vc.letaoVideoUrl = letaoVideoUrl;
        NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
        if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
            [viewControllers removeObject:self];
        }
        [viewControllers addObject:vc];
        [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
    }

}

// 22、 自定义活动页面
- (void)webViewOpenCustomActivityInfoPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    NSString *acCode = data[@"code"];
    if ([acCode isKindOfClass:[NSString class]] && acCode.length > 0) {
        XLTActivityVC *vc = [[XLTActivityVC alloc] init];
        vc.acCode = acCode;
        NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
        if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
            [viewControllers removeObject:self];
        }
        [viewControllers addObject:vc];
        [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
    }

}
 // 23、 打开第三方app
- (void)webViewOpenApplicationInfoPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    NSString *nativeUrl = data[@"nativeUrl"];
    NSString *webUrl = data[@"H5Url"];
    if ([nativeUrl isKindOfClass:[NSString class]] && nativeUrl.length > 0) {
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *openURL = [NSURL URLWithString:nativeUrl];
        if (@available(iOS 10.0, *)) {
            [application openURL:openURL options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    [self webViewAskOpenURL:webUrl];
                }
            }];
        } else {
            // Fallback on earlier versions
            if ([application canOpenURL:openURL]) {
                [application openURL:openURL];
             } else {
                 [self webViewAskOpenURL:webUrl];
            };
        }
    }
}

// 24、 我的推荐
- (void)webViewOpenCommunityGoodsRecmPage:(NSDictionary *)data closepage:(NSNumber *)closepage {
    if (![XLTUserManager shareManager].isLogined) {
            [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        XLTMyRecommendVC *myRecommendVC = [[XLTMyRecommendVC alloc] init];
        NSMutableArray *viewControllers = [self xltNavigationController].viewControllers.mutableCopy;
        if (([closepage isKindOfClass:[NSNumber class]] || [closepage isKindOfClass:[NSString class]]) && [closepage boolValue]) {
            [viewControllers removeObject:self];
        }
        [viewControllers addObject:myRecommendVC];
        [[self xltNavigationController] setViewControllers:viewControllers animated:YES];
    }
}

- (void)loginSuccessAction {
    [self webViewAskToken];
}

- (NSDictionary *)generateSecrtetWithParameters:(NSDictionary *)parameters
                                      path:(NSString *)path {
    NSMutableString *resultStr  = [[NSMutableString alloc] initWithString:@""];
    NSArray *keys = [parameters allKeys];
    //排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *key in sortedArray) {
        id object = [parameters objectForKey:key];
        if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) {
            if(((NSArray *)object).count > 0) {
                NSString *json = [object modelToJSONString];
                NSString *modelToJSONString =  [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                [resultStr appendFormat:@"%@=%@",key, modelToJSONString];
            }
        } else {
            [resultStr appendFormat:@"%@=%@",key, object];
        }
        
    }
    // 删除特殊字符
    resultStr = [resultStr letaomd5].mutableCopy;
    
    NSString *prefix = nil;
    if (resultStr.length > 5) {
        prefix = [NSString letaoSafeSubstring:resultStr toIndex:5];
    } else {
        prefix = [NSString stringWithFormat:@"%@",resultStr];
    }
    
    NSString *suffix = nil;
    if (resultStr.length > 5) {
        suffix = [NSString letaoSafeSubstring:resultStr fromReverseIndex:5];
    } else {
        suffix = [NSString stringWithFormat:@"%@",resultStr];
        
    }
    
    NSMutableString *signString = [NSMutableString string];
    [signString appendString:prefix];
    
    NSString *appID =  [[XLTNetCommonParametersModel defaultModel] appID];
    if (appID) {
        [signString appendString:appID];
    }
    if (path) {
        [signString appendString:path];
    }
    
    
    [signString appendString:resultStr];
    NSString *timestamp = [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]];
    [signString appendString:timestamp];
    [signString appendString:suffix];
    
    NSString *appKey =  [[XLTNetCommonParametersModel defaultModel] appKey];
    if (appKey) {
        [signString appendString:appKey];
    }
    
    NSLog(@"signString is :%@",signString);
    //得到MD5 sign签名
    NSString *md5Sign = [signString letaomd5];

    NSMutableDictionary *secrtetDictionary = [NSMutableDictionary dictionary];
    if (timestamp) {
        secrtetDictionary[@"x-timestamp"] = timestamp;
    }
    if (md5Sign) {
        secrtetDictionary[@"x-sign"] = md5Sign;
    }
    
    // 其他参数
    NSInteger dev_type = [[XLTNetCommonParametersModel defaultModel] dev_type];
    NSInteger client_type = [[XLTNetCommonParametersModel defaultModel] client_type];
    [secrtetDictionary setValue:[[NSNumber numberWithInteger:dev_type] stringValue] forKey:@"dev-type"];
    [secrtetDictionary setValue:[[NSNumber numberWithInteger:client_type] stringValue] forKey:@"client-type"];
    NSString *version =  [XLTNetCommonParametersModel defaultModel].version;
    [secrtetDictionary setValue:version forKey:@"client-v"];
    NSString *token = [XLTUserManager shareManager].curUserInfo.token;
    if (token) {
        // 设置token
        [secrtetDictionary setValue:token forKey:@"Authorization"];
    }
    [secrtetDictionary setValue:@"1" forKey:@"check-enable"];
    
    // udid
    
    NSString *udid =  [FCUUID uuidForDevice];
    if (udid) {
        [secrtetDictionary setValue:udid forKey:@"x-m"];
    }

    if (appID) {
        [secrtetDictionary setValue:appID forKey:@"x-appid"];
    }
    
    NSString *appSource =  [[XLTNetCommonParametersModel defaultModel] appSource];
    if (appSource) {
        [secrtetDictionary setValue:appSource forKey:@"x-app-source"];
    }
    
    NSString *utdid = [UTDevice utdid];
    if (utdid) {
        [secrtetDictionary setValue:utdid forKey:@"x-utdid"];
    }
    return secrtetDictionary;
}


- (void)applicationDidBecomeActive:(NSNotification*)notification {
    __weak typeof(self)weakSelf = self;
    [self checkSystemPushSwitchEnabled:^(BOOL status) {
        if (status !=  self.isSystemPushSwitchEnabled) {
            weakSelf.isSystemPushSwitchEnabled = status;
            [weakSelf callBackToWebSystemPushSwitchEnabled:status];
        }
    }];
    
    if ([self.needRepoTaskInfo isKindOfClass:[NSDictionary class]] && self.needRepoTaskInfo.count > 0) {
        [[XLTUserTaskManager shareManager] letaoRepoShareTaskInfo:self.needRepoTaskInfo];
        self.needRepoTaskInfo = nil;
    }
    
    NSString *viewWillAppearEvent = @"viewWillAppearEvent()";
    [self.webView.wkWebView evaluateJavaScript:viewWillAppearEvent completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"value: %@ error: %@", response, error);
    }];
}


- (void)checkSystemPushSwitchEnabled:(void (^)(BOOL status))completionHandler {
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL isSystemPushSwitchEnabled =  (settings.authorizationStatus == UNAuthorizationStatusAuthorized);
                if (completionHandler) {
                    completionHandler(isSystemPushSwitchEnabled);
                }
            });
        }];
    } else {
        // Fallback on earlier versions
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        BOOL isSystemPushSwitchEnabled = (setting.types != UIUserNotificationTypeNone);
        if (completionHandler) {
            completionHandler(isSystemPushSwitchEnabled);
        }
    }
}


- (void)callBackToWebSystemPushSwitchEnabled:(BOOL)isSystemPushSwitchEnabled {
    // 回调notificationEnabled 方法
    NSString *notificationState = (isSystemPushSwitchEnabled ? @"1" : @"0");
    NSString *inputValueJS = [NSString stringWithFormat:@"notificationEnabled(%@)",notificationState];
    [self.webView.wkWebView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"value: %@ error: %@", response, error);
    }];
}

- (void)opentApplicationOpenSettings {
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    } else {
        // Fallback on earlier versions
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


- (void)saveAlbumWithVideoArray:(NSArray *)videoArray imageArray:(NSArray *)imageArray {
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户第一次同意了访问相册权限
                 [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     UIImage *photo = obj;
                     if ([photo isKindOfClass:[UIImage class]]) {
                         UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
                     }

                 }];
                
                [videoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *videoPath = obj;
                    if ([videoPath isKindOfClass:[NSString class]]) {
                        NSURL *url = [NSURL URLWithString:videoPath];
                        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
                        if (compatible) {
                            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                        }
                    }

                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                     [self showTipMessage:@"已保存到本地相册"];
                });
                
            } else { // 用户第一次拒绝了访问相机权限
    // do thing
            }
        }];
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册

        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage *photo = obj;
            if ([photo isKindOfClass:[UIImage class]]) {
                UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
            }

        }];
        [videoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *videoPath = obj;
            if ([videoPath isKindOfClass:[NSString class]]) {
                NSURL *url = [NSURL URLWithString:videoPath];
                BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
                if (compatible) {
                    UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                }
            }

        }];
        dispatch_async(dispatch_get_main_queue(), ^{
             [self showTipMessage:@"已保存到本地相册"];
        });
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Name = [infoDict objectForKey:@"CFBundleDisplayName"];
        if (app_Name == nil) {
            app_Name = [infoDict objectForKey:@"CFBundleName"];
        }
        
        NSString *messageString = [NSString stringWithFormat:@"[前往：设置 - 隐私 - 照片 - %@] 允许应用访问", app_Name];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:messageString preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    } else if (status == PHAuthorizationStatusRestricted) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"由于系统原因, 无法访问相册" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

@end
