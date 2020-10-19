//
//  XLTHomePageVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/9/29.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomePageVC.h"
#import "XLTScrolledPageView.h"
#import "HMSegmentedControl.h"
#import "XLTHomeRecommendVC.h"
#import "XLTHomePageLogic.h"
#import "LetaoEmptyCoverView.h"
#import "XLTHomeCategoryListVC.h"
#import <AVFoundation/AVFoundation.h>
#import "XLTQRCodeScanViewController.h"
#import "XLTSearchViewController.h"
#import "XLTAdManager.h"
#import "XLTWKWebViewController.h"
#import "XLTUserManager.h"
#import "XLTHomePageTopHeadView.h"
#import "XLTHomeGuessYouLikeVC.h"

@interface XLTHomePageVC () <XLTScrolledPageViewViewDelegate, XLTScrolledPageViewDataSource, XLTHomeRecommendVCDelegate, XLTHomePageTopHeadViewDelegate>

@property (nonatomic, strong) XLTHomePageTopHeadView *letaoTopHeadView;
@property (nonatomic, strong) XLTScrolledPageView *letaoScrolledPageView;
@property (nonatomic,assign) NSInteger letaoCurrentPageIndex;

@property (nonatomic, strong) XLTHomePageLogic *letaoHomeLogic;
@property (nonatomic, strong) XLTHomePageModel *pageModel;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoEmptyCoverView;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;

@property (nonatomic, assign) CGFloat infiniteLoop_scrollViewOffset;

@end

@implementation XLTHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithHex:0xFFFAFAFA];
    [self letaoSetupTopHeadView];
    
    // 加载缓存
    [self makeLocalHomePageCacheData];
    
    [self requestHomePagesLayoutData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self letaohiddenNavigationBar:YES];
    [[XLTAppPlatformManager shareManager] xingletaonetwork_requestLimitModelStatus:nil];
    [[XLTAppPlatformManager shareManager] requestSupportGoodsPlatform];
}

// 加载本地数据
- (void)makeLocalHomePageCacheData {
    if ([XLTAppPlatformManager shareManager].checkEnable) {
        if (self.pageModel == nil) {
            XLTHomePageModel *pageModel = [XLTHomePageLogic localHomePageCacheData];
            if (pageModel) {
                self.pageModel = pageModel;
                [self reloadHomePageModel];
            }
        }
    }
}

- (XLTHomePageModel *)makeLocalCheckEnableHomePageData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"kingkong" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary *pageInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
    XLTHomePageModel *pageModel = [[XLTHomePageModel alloc] initWithPageInfo:pageInfo];
    return pageModel;
}

- (void)requestHomePagesLayoutData {
    if (self.pageModel == nil) {
        [self letaoShowLoading];
    }
    __weak typeof(self)weakSelf = self;
    [XLTHomePageLogic requestHomePageDataSuccess:^(XLTHomePageModel * _Nonnull model) {
        if ([XLTAppPlatformManager shareManager].checkEnable) {
             weakSelf.pageModel = model;
        } else {
            weakSelf.pageModel = [self makeLocalCheckEnableHomePageData];
        }
       
        [weakSelf reloadHomePageModel];
        [weakSelf letaoRemoveLoading];
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf letaoRemoveLoading];
        if (weakSelf.pageModel == nil) {
            [weakSelf letaoShowErrorView];
            [weakSelf showTipMessage:errorMsg];
        } else {
            [weakSelf letaoRecommendVCEndRefreshState];
        }
    }];
    [[XLTAppPlatformManager shareManager] xingletaonetwork_requestLimitModelStatus:nil];
}

- (void)reloadHomePageModel {
    [self letaoSetupSegmentedControl];
    [self letaoBulidPages];
    
    if (self.pageModel.modulesArray.count > 0) {
        XLTHomeModuleModel *moduleModel = self.pageModel.modulesArray[0];
        
        // 存在顶部banner
        if([moduleModel.moduleType isKindOfClass:[NSString class]] && [moduleModel.moduleType isEqualToString:XLTHomeTopCycleBannerModuleType]) {
            // do noting
        } else {
            [self.letaoTopHeadView clearAdBg];
        }
    }
}

- (void)letaoRecommendVCEndRefreshState {
    for (XLTHomeRecommendVC *vc in self.childViewControllers) {
         if([vc isKindOfClass:[XLTHomeRecommendVC class]]) {
             [vc letaoEndRefreshState];
         }
     }
}


- (void)letaoSetupTopHeadView {
    XLTHomePageTopHeadView *letaoTopHeadView = [[XLTHomePageTopHeadView alloc] init];
    letaoTopHeadView.delegate = self;
    [self.view addSubview:letaoTopHeadView];
    self.letaoTopHeadView = letaoTopHeadView;
    self.letaoTopHeadView.letaoSegmentedControl.sectionTitles = @[@"推荐"];
    self.letaoTopHeadView.letaoSegmentedControl.hidden = YES;
    [self.letaoTopHeadView.letaoSegmentedControl addTarget:self action:@selector(letaoSegmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (NSArray *)letaoSegmentTitlesArray {
    if (self.pageModel.categoryArray.count > 0 ) {
        NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
        [self.pageModel.categoryArray enumerateObjectsUsingBlock:^(XLTHomeCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.name) {
                [categoryArray addObject:obj.name];
            } else {
                [categoryArray addObject:@"未知"];
            }
        }];
        return categoryArray;
    } else {
        XLTHomeCategoryModel *defualtCategory = [XLTHomePageLogic letaoDefualtCategory];
        return @[defualtCategory.name];
    }
}

- (void)letaoSetupSegmentedControl {
    self.letaoTopHeadView.letaoSegmentedControl.sectionTitles = [self letaoSegmentTitlesArray];
    self.letaoTopHeadView.letaoSegmentedControl.selectedSegmentIndex = 0;
    self.letaoCurrentPageIndex = 0;
    self.letaoTopHeadView.letaoSegmentedControl.hidden = NO;
}

- (void)letaoClearPageViews {
    for (XLTHomeRecommendVC *vc in self.childViewControllers) {
        // 推荐保留
        if(![vc isKindOfClass:[XLTHomeRecommendVC class]]) {
            [vc willMoveToParentViewController:nil];
            [vc removeFromParentViewController];
        }
    }
    
    if (_letaoScrolledPageView != nil)  {
        _letaoScrolledPageView.delegate = nil;
        _letaoScrolledPageView.dataSource = nil;
        [_letaoScrolledPageView removeFromSuperview];
        _letaoScrolledPageView = nil;
    }
}

- (void)letaoBulidPages {
    [self letaoClearPageViews];
    CGFloat isLimitModelOffset = 0;
    if ([XLTAppPlatformManager shareManager].isLimitModel) {
        isLimitModelOffset = self.letaoTopHeadView.letaoSegmentedControl.bounds.size.height;
    }
    CGRect pageRect = CGRectMake(0, CGRectGetMaxY(self.letaoTopHeadView.letaoSegmentedControl.frame) -isLimitModelOffset, self.view.bounds.size.width, CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.letaoTopHeadView.letaoSegmentedControl.frame) + isLimitModelOffset);
    _letaoScrolledPageView = [[XLTCustomScrolledPageView alloc] initWithFrame:pageRect];
    _letaoScrolledPageView.backgroundColor = [UIColor clearColor];
    _letaoScrolledPageView.shouldPreLoadSiblings = YES;
    _letaoScrolledPageView.delegate = (id)self;
    _letaoScrolledPageView.dataSource = (id)self;
    _letaoScrolledPageView.scrollView.scrollEnabled = YES;
    [self.view addSubview:_letaoScrolledPageView];
}


- (void)letaoSegmentedValueChanged:(HMSegmentedControl *)segmentedControl {
    [_letaoScrolledPageView goToPageAtIndex:segmentedControl.selectedSegmentIndex animated:YES];
    self.letaoCurrentPageIndex = segmentedControl.selectedSegmentIndex;
    //汇报
    NSMutableDictionary *properties = @{}.mutableCopy;
    NSString *name = [segmentedControl.sectionTitles objectAtIndex:segmentedControl.selectedSegmentIndex];
    properties[@"classify_name"] = [SDRepoManager repoResultValue:name];
    properties[@"xlt_item_level"] = [NSString stringWithFormat:@"%@",[SDRepoManager repoResultValue:@1]];
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_CATEGORY properties:properties];
}

- (void)pagerViewScrolToTop {
    NSUInteger pageIndex =  self.letaoTopHeadView.letaoSegmentedControl.selectedSegmentIndex;
    if (pageIndex < self.pageModel.categoryArray.count) {
        XLTHomeCategoryModel *category = [self.pageModel.categoryArray objectAtIndex:pageIndex];
        NSString *letaoChannelId = category._id;
        UIViewController *viewController = [self pageViewControllerForChannelCode:letaoChannelId];
        if ([viewController isKindOfClass:[XLTHomeRecommendVC class]]) {
            XLTHomeRecommendVC *recommendViewController = (XLTHomeRecommendVC *)viewController;
            [recommendViewController pagerViewScrolToTop];
        } else  if ([viewController isKindOfClass:[XLTHomeCategoryListVC class]]) {
            XLTHomeCategoryListVC *listViewController = (XLTHomeCategoryListVC *)viewController;
            [listViewController pagerViewScrolToTop];
        }
    }
}





#pragma mark - ScrolledPageViewViewDelegate & ScrolledPageViewDataSource

- (NSUInteger)numberOfPages {
    if ([XLTAppPlatformManager shareManager].isLimitModel) {
        return 1;
    } else {
        return self.pageModel.categoryArray.count;
    }
}

- (UIViewController *)viewControllerForPageIndex:(NSUInteger)pageIndex {
    XLTHomeCategoryModel *category = [self.pageModel.categoryArray objectAtIndex:pageIndex];
    NSString *letaoChannelId = category._id;
    UIViewController *viewController = [self pageViewControllerForChannelCode:letaoChannelId];
    
    if (viewController == nil) {
        viewController = [self letaoCreatePageVcForChannelCode:letaoChannelId];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
    
    XLTHomeCategoryModel *defualtCategory = [XLTHomePageLogic letaoDefualtCategory];
    if ([letaoChannelId isEqualToString:defualtCategory._id]
        && [viewController isKindOfClass:[XLTHomeRecommendVC class]]) {
        XLTHomeRecommendVC *recommendViewController = (XLTHomeRecommendVC *)viewController;
        recommendViewController.pageModel = self.pageModel;
    }
    if ([viewController isKindOfClass:[XLTHomeCategoryListVC class]]) {
        XLTHomeCategoryListVC *listViewController = (XLTHomeCategoryListVC *)viewController;
        listViewController.letaoChannelLevel = category.level;
        listViewController.channelName = category.name;
    }
    
    // 分类展示汇报
    NSMutableDictionary *properties = @{}.mutableCopy;
    properties[@"xlt_item_id"] = letaoChannelId;
    properties[@"xlt_item_title"] = category.name;
    properties[@"xlt_item_level"] = [NSString stringWithFormat:@"%@",[SDRepoManager repoResultValue:category.level]];

    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_HOME_CATEGORY properties:properties];
    
    return viewController;
}

- (UIViewController *)pageViewControllerForChannelCode:(NSString *)letaoChannelId {
    __block XLTHomeRecommendVC *viewController = nil;
    [self.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[XLTHomeRecommendVC class]]
            || [obj isKindOfClass:[XLTHomeCategoryListVC class]]
            || [obj isKindOfClass:[XLTHomeGuessYouLikeVC class]]){
            viewController = obj;
            if ([viewController.letaoChannelId isEqualToString:letaoChannelId]) {
                *stop = YES;
            } else {
                viewController = nil;
            }
        }
    }];
    return viewController;
}

- (UIViewController *)letaoCreatePageVcForChannelCode:(NSString *)letaoChannelId {
    XLTHomeCategoryModel *defualtCategory = [XLTHomePageLogic letaoDefualtCategory];
    if ([letaoChannelId isEqualToString:defualtCategory._id]) {
        return [self letaoCreateRecommendVCForChannelCode:letaoChannelId];
    } if ([letaoChannelId isEqualToString:[XLTHomePageLogic letaoLocalGuessYouLikeCategoryId]]) {
           return [self letaoCreateGuessYouLikeVCForChannelCode:letaoChannelId];
    } else {
        return [self letaoCreateCategoryPageviewControllerForChannelCode:letaoChannelId];
    }
}

- (XLTHomeGuessYouLikeVC *)letaoCreateGuessYouLikeVCForChannelCode:(NSString *)letaoChannelId {
    XLTHomeGuessYouLikeVC *listViewController = [[XLTHomeGuessYouLikeVC alloc] init];
    listViewController.letaoChannelId = letaoChannelId;
    return listViewController;
}

- (XLTHomeRecommendVC *)letaoCreateRecommendVCForChannelCode:(NSString *)letaoChannelId {
    XLTHomeRecommendVC *listViewController = [[XLTHomeRecommendVC alloc] init];
    listViewController.delegate = self;
    listViewController.letaoChannelId = letaoChannelId;
    return listViewController;
}

- (XLTHomeCategoryListVC *)letaoCreateCategoryPageviewControllerForChannelCode:(NSString *)letaoChannelId {
    XLTHomeCategoryListVC *listViewController = [[XLTHomeCategoryListVC alloc] init];
    listViewController.letaoChannelId = letaoChannelId;
    listViewController.letaoIsHaveCategoryList = YES;
    return listViewController;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_letaoScrolledPageView.currentPageIndex < self.letaoTopHeadView.letaoSegmentedControl.sectionTitles.count) {
        [self.letaoTopHeadView.letaoSegmentedControl setSelectedSegmentIndex:_letaoScrolledPageView.currentPageIndex animated:YES];
        self.letaoCurrentPageIndex = _letaoScrolledPageView.currentPageIndex;
    }
}



- (void)letaoShowEmptyView {
    if (self.letaoEmptyCoverView == nil) {
        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"page_empty"
                                                                   titleStr:@"暂无数据"
                                                                  detailStr:@""
                                                                btnTitleStr:@""
                                                              btnClickBlock:^(){
                                                                  // do nothings
                                                              }];
        letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = YES;
        letaoEmptyCoverView.subViewMargin = 14.f;
        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:15.f];
        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(172, 172, 172);
        self.letaoEmptyCoverView = letaoEmptyCoverView;
    }
    [self.view addSubview:self.letaoEmptyCoverView];
}

- (void)letaoRemoveEmptyView {
    [self.letaoEmptyCoverView removeFromSuperview];
}

- (void)letaoShowErrorView {
    if (self.letaoErrorView == nil) {
        __weak typeof(self)weakSelf = self;
        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"xinletao_page_error"
                                                                   titleStr:Data_Error_Retry
                                                                  detailStr:@""
                                                                btnTitleStr:@"重新加载"
                                                              btnClickBlock:^(){
                                                                  [weakSelf letaoRemoveErrorView];
                                                                  [weakSelf requestHomePagesLayoutData];
                                                              }];
        letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = YES;
        letaoEmptyCoverView.subViewMargin = 28.f;
        letaoEmptyCoverView.contentViewOffset = - 50;
        
        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:14.f];
        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(199, 199, 199);
        
        letaoEmptyCoverView.actionBtnFont = [UIFont boldSystemFontOfSize:16.f];
        letaoEmptyCoverView.actionBtnTitleColor = [UIColor letaomainColorSkinColor];
        letaoEmptyCoverView.actionBtnHeight = 40.f;
        letaoEmptyCoverView.actionBtnHorizontalMargin = 62.f;
        letaoEmptyCoverView.actionBtnCornerRadius = 20.f;
        //        letaoEmptyCoverView.actionBtnBorderColor = UIColorMakeRGB(204, 204, 204);
        letaoEmptyCoverView.actionBtnBorderColor = [UIColor letaomainColorSkinColor];
        letaoEmptyCoverView.actionBtnBorderWidth = 0.5;
        letaoEmptyCoverView.actionBtnBackGroundColor = self.view.backgroundColor;
        self.letaoErrorView = letaoEmptyCoverView;
    }
    [self.view addSubview:self.letaoErrorView];
}

- (void)letaoRemoveErrorView {
    [self.letaoErrorView removeFromSuperview];
}

- (void)letaoHomeTriggerRefreshAction {
    [self requestHomePagesLayoutData];
}



#pragma mark - 顶部按钮事件

- (void)letaoTopHeadView:(XLTHomePageTopHeadView *)letaoTopHeadView letaoSearchText:(NSString * _Nullable )text {
    XLTSearchViewController *searchViewController = [[XLTSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:NO];
    
    
    // 搜索
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_HOME_SEARCH properties:nil];
}

- (void)letaoTopHeadView:(XLTHomePageTopHeadView *)letaoTopHeadView qrcodeScanAction:(id)sender {
    XLTQRCodeScanViewController *loginViewController = [[XLTQRCodeScanViewController alloc] init];
    [self letaoPushToScanVC:loginViewController];
    // 扫一扫
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_HOME_SCAN properties:nil];
}


- (void)letaoTopHeadView:(XLTHomePageTopHeadView *)letaoTopHeadView taskButtonAction:(id)sender {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.jump_URL = kXLTUserTaskH5Url;
    web.fullScreen = YES;
    web.title = @"任务中心";
    [self.navigationController pushViewController:web animated:YES];
}


#pragma mark - banner背景


- (void)setLetaoCurrentPageIndex:(NSInteger)letaoCurrentPageIndex {
    if (_letaoCurrentPageIndex != letaoCurrentPageIndex) {
        _letaoCurrentPageIndex = letaoCurrentPageIndex;
        [self homePageVCIndexChanged:letaoCurrentPageIndex];
    }
}
- (void)homePageVCIndexChanged:(NSInteger)pageIndex {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XLTHomePageVCIndexChangedNotification" object:[NSNumber numberWithInteger:pageIndex]];
}


- (void)scrollBanner:(NSDictionary *)startBanner toBanner:(NSDictionary * _Nullable)endBanner rate:(CGFloat)rate {
    [self.letaoTopHeadView scrollBanner:startBanner toBanner:endBanner rate:rate];
}


- (void)homeRecommendVCScrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark - QRCodeScan

- (void)letaoPushToScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
                case AVAuthorizationStatusNotDetermined: {
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        if (granted) {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [self.navigationController pushViewController:scanVC animated:YES];
                            });
                            NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                        } else {
                            NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                        }
                    }];
                    break;
                }
                case AVAuthorizationStatusAuthorized: {
                    [self.navigationController pushViewController:scanVC animated:YES];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
