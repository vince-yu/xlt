//
//  XLTQRCodeScanViewController.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/6.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTQRCodeScanViewController.h"
#import "SGQRCode.h"
#import "XLTWKWebViewController.h"
#import "SPButton.h"
#import "XLTQRCodeScanLogic.h"
#import "XLTGoodsDetailVC.h"
#import "XLTQRCodeTipMessageVC.h"
#import "XLTAlertViewController.h"
#import "XLTHomePageLogic.h"
#import "AppDelegate.h"
#import "XLTGoodsSearchReultVC.h"
#import "XLTSearchViewController.h"
#import "XLTGoodsSearchPopVC.h"
#import "XLTPopTaskViewManager.h"

@interface XLTQRCodeScanViewController () {
    SGQRCodeObtain *obtain;
}

@property (nonatomic, strong) SGQRCodeScanView *scanView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) SPButton *albumBotton;
@property (nonatomic, strong) SPButton *flashlightBotton;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) XLTQRCodeScanLogic *letaoQRCodeLogic;

@end

@implementation XLTQRCodeScanViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoconfigTranslucentNavigation];
    /// 二维码开启方法
    [obtain startRunningWithBefore:nil completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanView removeTimer];
    [obtain stopRunning];
}

- (void)dealloc {
    NSLog(@"WCQRCodeVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    obtain = [SGQRCodeObtain QRCodeObtain];
    
    [self setupQRCodeScan];
    [self setupNavigationBar];
    [self.view addSubview:self.scanView];
    [self.view addSubview:self.promptLabel];
    /// 为了 UI 效果
    [self.view addSubview:self.bottomView];
    
    [self.view addSubview:self.flashlightBotton];
    [self.view addSubview:self.albumBotton];
}

- (void)setupQRCodeScan {
    __weak typeof(self) weakSelf = self;
    
    SGQRCodeObtainConfigure *configure = [SGQRCodeObtainConfigure QRCodeObtainConfigure];
    configure.sampleBufferDelegate = YES;
    [obtain establishQRCodeObtainScanWithController:self configure:configure];
    [obtain setBlockWithQRCodeObtainScanResult:^(SGQRCodeObtain *obtain, NSString *result) {
        if (result) {
            [weakSelf letaoShowLoading];
            [obtain stopRunning];
            [obtain playSoundName:@"SGQRCode.bundle/sound.caf"];
            [weakSelf didScanResult:result];
        }
    }];
}

- (void)didScanResult:(NSString *)result {
    if ([result isKindOfClass:[NSString class]]) {
        if (self.letaoQRCodeLogic == nil) {
            self.letaoQRCodeLogic = [[XLTQRCodeScanLogic alloc] init];
        }
        __weak typeof(self) weakSelf = self;
        // 调用接口解析
        [self.letaoQRCodeLogic decodeResultForCodeText:result success:^(XLTBaseModel * _Nonnull model) {
            [weakSelf letaoDidDecodedGoods:model scanText:result];
        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf letaoDidDecodedGoodsFailure:errorMsg scanText:result];
        }];
    }
}

- (void)letaoDidDecodedGoods:(XLTBaseModel *)model scanText:(NSString *)scanText {
    [self letaoRemoveLoading];
    if ([model.xlt_rcode isKindOfClass:[NSString class]]
           || [model.xlt_rcode isKindOfClass:[NSNumber class]]) {
        NSDictionary *result = model.data;
        NSString *need_search = result[@"need_search"];
        BOOL needSearch = ([need_search isKindOfClass:[NSNumber class]] && [need_search boolValue]);
        if ([model.xlt_rcode integerValue] == 0) {
            NSString *goodsId = result[@"goods_id"];
            NSString *real_url = result[@"real_url"];
            NSString *item_source = result[@"item_source"];
            NSString *item_id = result[@"item_id"];
            if ([goodsId isKindOfClass:[NSString class]] && goodsId.length > 0) {
                XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
                goodDetailViewController.letaoPassDetailInfo = result;
                goodDetailViewController.letaoGoodsSource = item_source;
                goodDetailViewController.letaoGoodsId = goodsId;
                goodDetailViewController.letaoGoodsItemId = item_id;
                [self.navigationController pushViewController:goodDetailViewController animated:YES];
                
            } else if ([real_url isKindOfClass:[NSString class]]
                          && [real_url hasPrefix:@"http"]) {
                if ([[XLTAppPlatformManager shareManager] isXinletaoSafeWebDomain:real_url]) {
                    XLTWKWebViewController *jumpVC = [[XLTWKWebViewController alloc] init];
                    jumpVC.jump_URL  = [real_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    [self.navigationController pushViewController:jumpVC animated:YES];
                  } else {
                          // 外部链接
                    NSString *messageString = [NSString stringWithFormat:@"可能存在风险，是否打开此链接？\n%@", real_url];
                    XLTQRCodeTipMessageVC *viewController = [[XLTQRCodeTipMessageVC alloc] initWithNibName:@"XKDQRCodeTipViewController" bundle:[NSBundle mainBundle]];
                    viewController.flage = @"openURL";
                    viewController.parameters = real_url;
                    viewController.delegate = (id)self;
                    [viewController letaoPresentWithSourceVC:self title:@"提示" message:messageString sureButtonText:@"浏览器中打开" cancelButtonText:@"取消"];
                  }
               }
        } else if ([model.xlt_rcode integerValue] == 502) {
            if ([scanText isKindOfClass:[NSString class]]
                      && [scanText hasPrefix:@"http"]) {
                if ([[XLTAppPlatformManager shareManager] isXinletaoSafeWebDomain:scanText]) {
                    XLTWKWebViewController *jumpVC = [[XLTWKWebViewController alloc] init];
                    NSString *jumpUrl = [scanText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    jumpVC.jump_URL  = jumpUrl;
                    [self.navigationController pushViewController:jumpVC animated:YES];
                    return;
                }
            }
            NSString *messageString = nil;
            if ([model.message isKindOfClass:[NSString class]] && model.message.length > 0) {
                messageString = model.message;
            } else {
                messageString = @"暂无该商品";
            }
            XLTAlertViewController *alertViewController = [[XLTAlertViewController alloc] init];
            [alertViewController letaoPresentWithSourceVC:[UIApplication sharedApplication].keyWindow.rootViewController title:@"提示" message:messageString messageTextAlignment:NSTextAlignmentCenter sureButtonText:@"知道了" cancelButtonText:nil];
            [alertViewController setLetaoalertViewAction:^(NSInteger clickIndex, BOOL noneShow) {
                [self->obtain startRunningWithBefore:nil completion:nil];
            }];
            
        } else if (needSearch) {
            // 搜索弹窗
            [self letaoNeedPopSearchViewControllerWithScanText:scanText];
        } else {
             [self letaoDidDecodedGoodsFailure:nil scanText:scanText];
        }
    } else {
       [self letaoDidDecodedGoodsFailure:nil scanText:scanText];
    }
}

- (void)startSearchWithScanText:(NSString *)scanText {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        UINavigationController *navigationController = (UINavigationController *)appDelegate.window.rootViewController;
        if ([navigationController isKindOfClass:[UINavigationController class]]) {
            
            NSMutableArray *viewControllers = navigationController.viewControllers.mutableCopy;
            XLTSearchViewController *searchViewController = [[XLTSearchViewController alloc] init];
            searchViewController.letaoPasteboardSearchText = scanText;
            [viewControllers addObject:searchViewController];
            
            XLTGoodsSearchReultVC *reultViewController = [[XLTGoodsSearchReultVC alloc] init];
            reultViewController.pasteboardSearchText = scanText;
            reultViewController.letaoSearchText = scanText;
            [viewControllers addObject:reultViewController];
                        
            [navigationController setViewControllers:viewControllers animated:YES];
            [[XLTRepoDataManager shareManager] repoSearchActionWithKeyword:scanText];
        }
    }

}


- (void)letaoPopSearchViewControllerWithScanText:(NSString *)scanText  {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        if ([appDelegate.window.rootViewController isKindOfClass:[UIViewController class]]) {
            XLTGoodsSearchPopVC *popViewController = [[XLTGoodsSearchPopVC alloc] init];
            __weak typeof(self)weakSelf = self;
            popViewController.popViewControllerSearchAction = ^(NSString *searchText) {
                 [weakSelf startSearchWithScanText:searchText];
             };
            [popViewController presentWithSourceViewController:appDelegate.window.rootViewController searchText:scanText];
            [[XLTPopTaskViewManager shareManager] clearPopedViews];
            [[XLTPopTaskViewManager shareManager] addPopedView:popViewController];
        }
    }
}

- (void)letaoNeedPopSearchViewControllerWithScanText:(NSString *)scanText  {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        if ([appDelegate.window.rootViewController isKindOfClass:[UIViewController class]]) {
            if (appDelegate.window.rootViewController.presentedViewController != nil) {
                [appDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:^{
                    [self letaoPopSearchViewControllerWithScanText:scanText];
                }];
            } else {
                [self letaoPopSearchViewControllerWithScanText:scanText];
            }
        }
    }
}


- (void)qrCodeTipViewController:(XLTQRCodeTipMessageVC *)viewController dismissWithIndex:(NSInteger)index {
    if (index == 0 && [viewController.flage isEqualToString:@"openURL"]) {
        NSString *scanText = viewController.parameters;
        if ([scanText isKindOfClass:[NSString class]]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scanText]];
            });
        }
    }
    [obtain startRunningWithBefore:nil completion:nil];
}


- (void)letaoDidDecodedGoodsFailure:(NSString * _Nullable)errorMsg scanText:(NSString *)scanText {
    [self letaoRemoveLoading];
    ///普通文本
    if ([scanText hasPrefix:@"http"]) {
        if ([[XLTAppPlatformManager shareManager] isXinletaoSafeWebDomain:scanText]) {
            XLTWKWebViewController *jumpVC = [[XLTWKWebViewController alloc] init];
            jumpVC.jump_URL = scanText;
            [self.navigationController pushViewController:jumpVC animated:YES];
        } else {
            // 外部链接
            NSString *messageString = [NSString stringWithFormat:@"可能存在风险，是否打开此链接？\n%@", scanText];
            XLTQRCodeTipMessageVC *viewController = [[XLTQRCodeTipMessageVC alloc] initWithNibName:@"XLTQRCodeTipMessageVC" bundle:[NSBundle mainBundle]];
            viewController.flage = @"openURL";
            viewController.parameters = scanText;
            viewController.delegate = (id)self;
            [viewController letaoPresentWithSourceVC:self title:@"提示" message:messageString sureButtonText:@"浏览器中打开" cancelButtonText:@"取消"];
        }

    } else {
        // 普通文本
        NSString *messageString = [NSString stringWithFormat:@"二维码内容：\n%@", scanText];
        XLTQRCodeTipMessageVC *viewController = [[XLTQRCodeTipMessageVC alloc] initWithNibName:@"XLTQRCodeTipMessageVC" bundle:[NSBundle mainBundle]];
        viewController.flage = @"openURL";
        viewController.parameters = scanText;
        viewController.delegate = (id)self;
        [viewController letaoPresentWithSourceVC:self title:nil message:messageString sureButtonText:nil cancelButtonText:@"确定"];

    }
}


- (void)setupNavigationBar {
    self.navigationItem.title = @"扫一扫";
}

- (void)albumBottonAction {
    __weak typeof(self) weakSelf = self;
    
    [obtain establishAuthorizationQRCodeObtainAlbumWithController:nil];
    if (obtain.isPHAuthorization == YES) {
        [self.scanView removeTimer];
    }
    [obtain setBlockWithQRCodeObtainAlbumDidCancelImagePickerController:^(SGQRCodeObtain *obtain) {
        [weakSelf.view addSubview:weakSelf.scanView];
        [weakSelf.view bringSubviewToFront:weakSelf.flashlightBotton];
        [weakSelf.view bringSubviewToFront:weakSelf.albumBotton];
        [weakSelf.view bringSubviewToFront:weakSelf.promptLabel];
    }];
    [obtain setBlockWithQRCodeObtainAlbumResult:^(SGQRCodeObtain *obtain, NSString *result) {
        [weakSelf letaoShowLoading];
        if (result == nil) {
            NSLog(@"暂未识别出二维码");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf letaoRemoveLoading];
                [weakSelf showTipMessage:@"未发现二维码/条形码"];
            });
        } else {
            [weakSelf didScanResult:result];
        }
    }];
}

- (SGQRCodeScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGQRCodeScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.9 * self.view.frame.size.height)];
        _scanView.cornerColor = [UIColor letaomainColorSkinColor];
    }
    return _scanView;
}
- (void)removeScanningView {
    [self.scanView removeTimer];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = ceilf(0.5 * (self.view.frame.size.height*0.9 - 0.7 * self.view.frame.size.width) - 25- 20);
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}


- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.scanView.frame))];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}

- (SPButton *)flashlightBotton {
    if (!_flashlightBotton) {
        _flashlightBotton = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionTop];
        _flashlightBotton.imageTitleSpace = 5.0;
        [_flashlightBotton setImage:[UIImage imageNamed:@"xinletao_qrcode_flashlight_off"] forState:UIControlStateNormal];
        [_flashlightBotton setImage:[UIImage imageNamed:@"xinletao_qrcode_flashlight_on"] forState:UIControlStateSelected];
        [_flashlightBotton setTitle:@"打开闪光灯" forState:UIControlStateNormal];
        _flashlightBotton.titleLabel.font = [UIFont letaoRegularFontWithSize:13];
        [_flashlightBotton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_flashlightBotton addTarget:self action:@selector(flashlightBtn_action:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat width = 100.0;
        CGFloat x = ceilf((self.view.bounds.size.width - 200.0)/3);
        _flashlightBotton.frame = CGRectMake(x, self.view.bounds.size.height - 75 - 45, width, 75);
    }
    return _flashlightBotton;
}


- (SPButton *)albumBotton {
    if (!_albumBotton) {
        _albumBotton = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionTop];
        _albumBotton.imageTitleSpace = 5.0;
        [_albumBotton setImage:[UIImage imageNamed:@"xinletao_qrCode_album"] forState:UIControlStateNormal];
        [_albumBotton setTitle:@"打开相册" forState:UIControlStateNormal];
        _albumBotton.titleLabel.font = [UIFont letaoRegularFontWithSize:13];
        [_albumBotton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_albumBotton addTarget:self action:@selector(albumBottonAction) forControlEvents:UIControlEventTouchUpInside];

        CGFloat width = 100.0;
        CGFloat right = ceilf((self.view.bounds.size.width - 200.0)/3);
        _albumBotton.frame = CGRectMake(self.view.bounds.size.width - right - width, self.view.bounds.size.height - 75 - 45, width, 75);
    }
    return _albumBotton;
}


#pragma mark - - - 闪光灯按钮

- (void)flashlightBtn_action:(UIButton *)button {
    self.isSelectedFlashlightBtn  = !self.isSelectedFlashlightBtn;
    if (self.isSelectedFlashlightBtn) {
        [obtain openFlashlight];
    } else {
        [obtain closeFlashlight];
    }
    self.flashlightBotton.selected = self.isSelectedFlashlightBtn;
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
