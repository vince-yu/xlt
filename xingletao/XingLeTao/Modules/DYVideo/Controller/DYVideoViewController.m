//
//  DYVideoViewController.m
//  XingLeTao
//
//  Created by chenhg on 2020/4/26.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "DYVideoViewController.h"
#import <KTVHTTPCache/KTVHTTPCache.h>
#import "MJRefresh.h"
#import "DYVideoCell.h"
#import "SJVideoPlayer.h"
#import "DYVideoManager.h"
#import "DYPreLoaderModel.h"
#import "XLTVideoLogic.h"
#import "DYVideoTextPopController.h"
#import "XLTGoodsDetailVC.h"
#import "XLTGoodsDetailLogic.h"
#import "XLTAliManager.h"
#import "MBProgressHUD+TipView.h"
#import "XLTShareFeedMediaDownloadVC.h"
#import "DYGuardViewController.h"
#import "XLTPDDManager.h"

@interface DYVideoViewController () <UITableViewDelegate, UITableViewDataSource, KTVHCDataLoaderDelegate, DYVideoCellDelegate, DYGuardDelegate>

@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) MJRefreshNormalHeader *letaoRefreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *letaoRefreshAutoFooter;
@property (nonatomic, assign) BOOL letaoIsLoadingState;
@property (nonatomic, strong) NSMutableArray *letaoPageDataArray;
@property (nonatomic, strong) NSMutableArray<DYPreLoaderModel *> *preloadArr;
@property (nonatomic, strong) XLTGoodsDetailLogic *letaoGoodsDetailLogic;

@end

@implementation DYVideoViewController

#define kPageSize 10
#define kTheFirstPageIndex 1


- (void)dealloc {
    [self.contentTableView.visibleCells enumerateObjectsUsingBlock:^(__kindof DYVideoCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj stopPlay];
    }];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

/// 初始化
- (void)setup {
    self.letaoPageDataArray = [NSMutableArray array];
    [DYVideoManager shareManager];
    _preLoadNum = 2;
    _nextLoadNum = 2;
    _preloadPrecent = 1.0;
    _preloadSize = 1024*1024*5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadContentTableView];
    
    if (@available(iOS 11.0, *)) {
        self.contentTableView.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self configCurrentPageData:self.pageVideoArray andIndex:self.currentPageIndex];
}

- (void)configCurrentPageData:(NSArray *)dataArray andIndex:(NSInteger)index {
    if ([self.pageVideoArray isKindOfClass:[NSArray class]]
        && self.pageVideoArray.count >0) {
        [self.letaoPageDataArray addObjectsFromArray:self.pageVideoArray];
        
        // 滚动到制定位置
        [self scrollToCurrentpVideoInfo];

    }
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contentTableView.visibleCells enumerateObjectsUsingBlock:^(__kindof DYVideoCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj tryPlayWhenViewWillAppear];
        }];
    });
    
    
    if ([self isFristCome]) {
        [self displayGuardViewController];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.contentTableView.visibleCells enumerateObjectsUsingBlock:^(__kindof DYVideoCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj tryPauseWhenViewWillDisappear];
    }];
}

- (void)scrollToCurrentpVideoInfo {
    NSInteger index = [self.letaoPageDataArray indexOfObject:self.startVideoInfo];
    if (index != NSNotFound && index != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.contentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

- (void)loadContentTableView {
    _contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _contentTableView.pagingEnabled = YES;
    _contentTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _contentTableView.sectionFooterHeight = 0;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.estimatedRowHeight = kScreenHeight;
    _contentTableView.rowHeight = kScreenHeight;
    _contentTableView.estimatedSectionHeaderHeight = 0;
    _contentTableView.estimatedSectionFooterHeight = 0;
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    /// 配置列表自动播放
//    [_contentTableView sj_enableAutoplayWithConfig:[SJPlayerAutoplayConfig configWithPlayerSuperviewTag:7788 autoplayDelegate:self]];

    [self registerTableViewCells];
    [self letaoSetupRefreshHeader];
    _contentTableView.mj_header = _letaoRefreshHeader;
    
    [self letaoSetupRefreshAutoFooter];
    _contentTableView.mj_footer = _letaoRefreshAutoFooter;
    // 首次隐藏
    _contentTableView.mj_footer.hidden = YES;
    
    [self.view addSubview:_contentTableView];
}

- (void)registerTableViewCells {
    [_contentTableView registerNib:[UINib nibWithNibName:@"DYVideoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DYVideoCell"];
}

- (void)letaoSetupRefreshHeader {
//    if (_letaoRefreshHeader == nil) {
//        __weak __typeof(self)weakSelf = self;
//        _letaoRefreshHeader =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf letaoTriggerRefresh];
//        }];
//    }
}

- (void)letaoSetupRefreshAutoFooter {
//    if (_letaoRefreshAutoFooter == nil) {
//        __weak __typeof(self)weakSelf = self;
//        _letaoRefreshAutoFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf letaoTriggerLoadMore];
//        }];
//        _letaoRefreshAutoFooter.triggerAutomaticallyRefreshPercent = - 2*kScreenHeight/44.0;
//        _letaoRefreshAutoFooter.autoTriggerTimes = -1;
//        [_letaoRefreshAutoFooter setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
//        _letaoRefreshAutoFooter.stateLabel.textColor = [UIColor colorWithHex:0xFFa9a9a9];
//        _letaoRefreshAutoFooter.stateLabel.font = [UIFont letaoRegularFontWithSize:12.0];
//    }
}
- (void)letaoTriggerRefresh {
    if (_letaoIsLoadingState) {
        return;
    }
    _letaoIsLoadingState = YES;
    [self requestPreviousPageData];
}

- (void)letaoTriggerLoadMore {
    if(_letaoIsLoadingState) {
        return ;
    }
    _letaoIsLoadingState = YES;
    [self requestNextPageData];
}

- (void)letaoStopRefreshState {
    [_letaoRefreshHeader endRefreshing];
    _letaoIsLoadingState = NO;
}

- (void)letaoStopLoadMoreState {
    [_letaoRefreshAutoFooter endRefreshing];
    _letaoIsLoadingState = NO;
}

- (void)letaoStopLoadMoreStateWithNoMoreData {
    [_letaoRefreshAutoFooter endRefreshingWithNoMoreData];
    _letaoIsLoadingState = NO;
}



- (NSInteger)pageSize {
    return kPageSize;
}


- (void)requestPreviousPageData {
    NSInteger requestIndex = _currentPageIndex -1;
    if (requestIndex < kTheFirstPageIndex) {
        [self letaoStopRefreshState];
    } else {
        [self letaoFetchPageDataForIndex:requestIndex pageSize:kPageSize];
    }
}

- (void)requestCurrentPageData {
    [self letaoFetchPageDataForIndex:_currentPageIndex pageSize:kPageSize];
}

- (void)requestNextPageData {
    NSInteger requestIndex = _currentPageIndex +1;
    [self letaoFetchPageDataForIndex:requestIndex pageSize:kPageSize];
}

- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize {
    __weak __typeof(self)weakSelf = self;
    [self letaoFetchPageDataForIndex:index pageSize:pageSize success:^(NSArray * _Nullable letaoPageDataArray) {
        [weakSelf receivedDataSuccess:letaoPageDataArray andIndex:index];
    } failed:^(NSError * _Nullable error, NSString * _Nullable tipMessage) {
        [weakSelf receivedDataError:error tipMessage:tipMessage];
    }];
}

// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                        failed:(XLTBaseListRequestFailed)failed{
    [XLTVideoLogic requestVideosDataForIndex:index pageSize:pageSize channelId:self.letaoChannelId success:^(NSArray * _Nonnull feedArray, NSURLSessionDataTask * _Nonnull task) {
        success(feedArray);
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
        failed(nil,errorMsg);
    }];
}

- (void)receivedDataError:(NSError * _Nullable)error tipMessage:(NSString * _Nullable)tipMessage {
    [self letaoRemoveMJLoadingsStatus];
    [self letaoRemoveLoading];
    if (self.letaoPageDataArray.count == 0) {
        [self letaoShowErrorView];
    } else {
        [self letaoRemoveErrorView];
    }
    if ([tipMessage isKindOfClass:[NSString class]] && tipMessage.length > 0){
        [self showTipMessage:tipMessage];
    } else {
        [self showTipMessage:NetWork_NotReachable];
    }
}

- (void)receivedDataSuccess:(NSArray *)letaoPageDataArray andIndex:(NSInteger)index {
    if (self.currentPageIndex > index) {
        [self insertContentTableViewUseData:letaoPageDataArray];
    } else {
        [self addMoreContentTableViewUseData:letaoPageDataArray];
    }
    
    [self letaoRemoveLoading];
    [self letaoRemoveErrorView];
    
    [self letaoStopRefreshState];
    if (self.letaoPageDataArray.count > 0) {
        [self letaoRemoveEmptyView];
        if(letaoPageDataArray.count < 1) {
            [self letaoStopLoadMoreStateWithNoMoreData];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.contentTableView.mj_insetT + self.contentTableView.mj_contentH <= self.contentTableView.mj_h) {
                    self.contentTableView.mj_footer.hidden =  (self.letaoPageDataArray.count == 0);
                    [self letaoStopLoadMoreState];
                    [self.letaoRefreshAutoFooter beginRefreshing];
                } else {
                    [self letaoStopLoadMoreState];
                }
            });
        }
    } else {
        [self letaoShowEmptyView];
        [self letaoStopLoadMoreState];
    }
    
    // 没有数据的时候隐藏mj_footer
    self.contentTableView.mj_footer.hidden =  (self.letaoPageDataArray.count == 0);
    
    self.currentPageIndex = index;
}

// 上一页操作，更新UITableView
- (void)insertContentTableViewUseData:(NSArray *)letaoPageDataArray {
    if([letaoPageDataArray isKindOfClass:[NSArray class]] && [letaoPageDataArray count] > 0) {
        NSArray *tempArray = [self.letaoPageDataArray copy];
        [self.letaoPageDataArray setArray:letaoPageDataArray];
        [self.letaoPageDataArray addObjectsFromArray:tempArray];
        [_contentTableView reloadData];
    }
}

// 更多操作，更新UITableView
- (void)addMoreContentTableViewUseData:(NSArray *)letaoPageDataArray {
    if([letaoPageDataArray isKindOfClass:[NSArray class]] && [letaoPageDataArray count] > 0) {
        NSMutableArray *insertArray = [NSMutableArray array];
        for (int k =0; k < letaoPageDataArray.count; k ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.letaoPageDataArray.count + k inSection:0];
            [insertArray addObject:indexPath];
        }
        
        [self.letaoPageDataArray addObjectsFromArray:letaoPageDataArray];
                
        [_contentTableView beginUpdates];
        if (insertArray.count) {
            [_contentTableView insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationNone];
        }
        [_contentTableView endUpdates];
    }
}


// clear letaoPageDataArray and reload contentTableView data
- (void)clearPageData {
    [self.letaoPageDataArray removeAllObjects];
    [_contentTableView reloadData];
    self.contentTableView.mj_footer.hidden = YES;
    self.currentPageIndex = kTheFirstPageIndex;
}


- (void)letaoRemoveMJLoadingsStatus {
    [self letaoStopRefreshState];
    [self letaoStopLoadMoreState];
}

- (void)letaoShowEmptyView {

}

- (void)letaoRemoveEmptyView {
}

- (void)letaoShowErrorView {

}

- (void)letaoRemoveErrorView {
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DYVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DYVideoCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.letaoPageDataArray.count) {
        NSDictionary *info = self.letaoPageDataArray[indexPath.row];
        // 播放前，先停止所有的预加载任务
        [self cancelAllPreload];
        [cell updateDataInfo:info atIndexPath:indexPath tableView:tableView];
        cell.delegate = self;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.letaoPageDataArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DYVideoCell *videoCell =  (DYVideoCell *)cell;
    if ([cell isKindOfClass:[DYVideoCell class]]) {
        [videoCell stopPlay];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    DYVideoCell *videoCell =  (DYVideoCell *)cell;
    if ([videoCell isKindOfClass:[DYVideoCell class]]) {
        [videoCell gestureControlSingleTapHandler];
    }
}

- (void)cell:(DYVideoCell *)cell playerAssetStatusReadyToPlayInfo:(NSDictionary *)info {
    [self preloadForCurrentData:info];
}

- (void)cell:(DYVideoCell *)cell playerAssetStatusDidFinishInfo:(NSDictionary *)info {
    if ([self.contentTableView.visibleCells containsObject:cell]) {
        [cell tryReplay];
    }
}

- (void)cell:(DYVideoCell *)cell buyButtonAction:(id)sneder {
    if ([cell.letaoInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *itemInfo = cell.letaoInfo[@"goods_info"];
        if ([itemInfo isKindOfClass:[NSDictionary class]]) {
            NSString *letaoGoodsId = itemInfo[@"_id"];
            NSString *letaoStoreId = itemInfo[@"seller_shop_id"];
            XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
            goodDetailViewController.letaoPassDetailInfo = itemInfo;
            goodDetailViewController.letaoGoodsId = letaoGoodsId;
            goodDetailViewController.letaoStoreId = letaoStoreId;
            NSString *item_source = itemInfo[@"item_source"];
            goodDetailViewController.letaoGoodsSource = item_source;
            NSString *letaoGoodsItemId = itemInfo[@"item_id"];
            goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;
            [self.navigationController pushViewController:goodDetailViewController animated:YES];
        }
    }

}

- (void)cell:(DYVideoCell *)cell backButtonAction:(id)sneder {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cell:(DYVideoCell *)cell textButtonAction:(id)sneder {
    if ([cell.letaoInfo isKindOfClass:[NSDictionary class]]) {
        NSString *item_desc = cell.letaoInfo[@"item_desc"];
        DYVideoTextPopController *textPopController = [[DYVideoTextPopController alloc] init];
        textPopController.shareText = item_desc;
        [self letaoPresentBottomVC:textPopController];
    }
}

- (void)cell:(DYVideoCell *)cell shareButtonAction:(id)sneder {
    if ([cell.letaoInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *goods_info = cell.letaoInfo[@"goods_info"];
        if ([goods_info isKindOfClass:[NSDictionary class]]) {
            [self prepareShareGoodInfo:goods_info itemInfo:cell.letaoInfo];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 2*kScreenHeight) {
        [self letaoTriggerLoadMore];
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

#pragma mark -  Preload
/*
- (void)preloadForRefreshData {
    [self cancelAllPreload];
    // 默认预加载前几条数据
    NSRange range = NSMakeRange(0, _initPreloadNum);
    if (range.length > self.letaoPageDataArray.count) {
        range.length = self.letaoPageDataArray.count;
    }
    NSArray *subArr = [self.letaoPageDataArray subarrayWithRange: range];
    for (NSDictionary *info in subArr) {
        NSString *url =  info[@"dy_video_url"];
        DYPreLoaderModel *preload = [self getPreloadModel:url];
        if (preload) {
            @synchronized (self.preloadArr) {
                [self.preloadArr addObject: preload];
            }
        }
    }
    [self processLoader];
}*/

- (void)preloadForCurrentData:(NSDictionary *)resource {
    if (self.letaoPageDataArray.count <= 1)
        return;
    if (_nextLoadNum == 0 && _preLoadNum == 0)
        return;
    NSInteger start = [self.letaoPageDataArray indexOfObject:resource];
    if (start == NSNotFound)
        return;
    [self cancelAllPreload];
    NSInteger index = 0;
    for (NSInteger i = start + 1; i < self.letaoPageDataArray.count && index < _nextLoadNum; i++)
    {
        index += 1;
        NSDictionary *info = self.letaoPageDataArray[i];
        NSString *url =  info[@"dy_video_url"];
        DYPreLoaderModel *preModel = [self getPreloadModel:url];
        if (preModel) {
            @synchronized (self.preloadArr) {
                [self.preloadArr addObject: preModel];
            }
        }
    }
    index = 0;
    for (NSInteger i = start - 1; i >= 0 && index < _preLoadNum; i--) {
        index += 1;
        NSDictionary *info = self.letaoPageDataArray[i];
        NSString *url =  info[@"dy_video_url"];
        DYPreLoaderModel *preModel = [self getPreloadModel:url];
        if (preModel) {
            @synchronized (self.preloadArr) {
                [self.preloadArr addObject:preModel];
            }
        }
    }
    [self processLoader];
}

/// 取消所有的预加载
- (void)cancelAllPreload {
    @synchronized (self.preloadArr) {
        if (self.preloadArr.count == 0)
        {
            return;
        }
        [self.preloadArr enumerateObjectsUsingBlock:^(DYPreLoaderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.loader close];
        }];
        [self.preloadArr removeAllObjects];
    }
}

- (DYPreLoaderModel *)getPreloadModel: (NSString *)urlStr {
    if (!urlStr)
        return nil;
    // 判断是否已在队列中
    __block Boolean res = NO;
    @synchronized (self.preloadArr) {
        [self.preloadArr enumerateObjectsUsingBlock:^(DYPreLoaderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.url isEqualToString:urlStr])
            {
                res = YES;
                *stop = YES;
            }
        }];
    }
    if (res)
        return nil;
    NSURL *proxyUrl = [KTVHTTPCache proxyURLWithOriginalURL: [NSURL URLWithString:urlStr]];
    KTVHCDataCacheItem *item = [KTVHTTPCache cacheCacheItemWithURL:proxyUrl];
    double cachePrecent = 1.0 * item.cacheLength / item.totalLength;
    // 判断缓存已经超过10%了
    if (cachePrecent >= self.preloadPrecent)
        return nil;
    KTVHCDataRequest *req = [[KTVHCDataRequest alloc] initWithURL:proxyUrl headers:[NSDictionary dictionary]];
    KTVHCDataLoader *loader = [KTVHTTPCache cacheLoaderWithRequest:req];
    DYPreLoaderModel *preModel = [[DYPreLoaderModel alloc] initWithURL:urlStr loader:loader];
    return preModel;
}

- (void)processLoader {
    @synchronized (self.preloadArr) {
        if (self.preloadArr.count == 0)
            return;
        DYPreLoaderModel *model = self.preloadArr.firstObject;
        model.loader.delegate = self;
        [model.loader prepare];
    }
}

/// 根据loader，移除预加载任务
- (void)removePreloadTask: (KTVHCDataLoader *)loader {
    @synchronized (self.preloadArr) {
        DYPreLoaderModel *target = nil;
        for (DYPreLoaderModel *model in self.preloadArr) {
            if ([model.loader isEqual:loader])
            {
                target = model;
                break;
            }
        }
        if (target)
            [self.preloadArr removeObject:target];
    }
}

// MARK: - KTVHCDataLoaderDelegate
- (void)ktv_loaderDidFinish:(KTVHCDataLoader *)loader {
}

- (void)ktv_loader:(KTVHCDataLoader *)loader didFailWithError:(NSError *)error {
    // 若预加载失败的话，就直接移除任务，开始下一个预加载任务
    [self removePreloadTask:loader];
    [self processLoader];
}

- (void)ktv_loader:(KTVHCDataLoader *)loader didChangeProgress:(double)progress {
    if (progress >= self.preloadPrecent
        || loader.loadedLength > self.preloadSize)
    {
        [loader close];
        [self removePreloadTask:loader];
        [self processLoader];
    }
}


- (NSMutableArray<DYPreLoaderModel *> *)preloadArr {
    if (_preloadArr == nil) {
        _preloadArr = [NSMutableArray array];
    }
    return _preloadArr;
}


#pragma mark -  文案
- (void)letaoPresentBottomVC:(DYVideoTextPopController *)viewController {
    
    viewController.view.hidden = YES;
    self.definesPresentationContext = YES;
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:viewController animated:NO completion:^{
        viewController.view.hidden = NO;
        viewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        viewController.view.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewController.view.transform=CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
        }];
    }];
}

#pragma mark -  分享
- (void)letaoShowClearBgLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}

- (void)prepareShareGoodInfo:(NSDictionary *)goodBase itemInfo:(NSDictionary *)itemInfo {
    if ([goodBase isKindOfClass: [NSDictionary class]]) {
        NSString *letaoGoodsId = goodBase[@"_id"];
        NSString *source = goodBase[@"item_source"];
        NSString *dy_video_url =  itemInfo[@"dy_video_url"];
        if (self.letaoGoodsDetailLogic == nil) {
            self.letaoGoodsDetailLogic = [[XLTGoodsDetailLogic alloc] init];
        }
        [self letaoShowClearBgLoading];
             __weak typeof(self)weakSelf = self;
            BOOL letaoIsAliSource = ([source isKindOfClass:[NSString class]]
                                         && ([source isEqualToString:XLTTaobaoPlatformIndicate] || [source isEqualToString:XLTTianmaoPlatformIndicate]));
            if (letaoIsAliSource) {
                [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsJumpUrlDataWithGoodsId:letaoGoodsId itemSource:source isAliCommandTextOnly:YES success:^(XLTBaseModel * _Nonnull model,BOOL isAliCommandTextOnly) {
                    [weakSelf letaoRemoveLoading];
                    NSDictionary *data = model.data;
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        if ([XLTGoodsDetailLogic letaoIsNeedAliAuthorizationCode:model]) {
                            NSString *auth_url = data[@"auth_url"];
                            if ([auth_url isKindOfClass:[NSString class]]) {
                                [weakSelf letaoOpenAliTrandWithURLString:auth_url authorization:NO];
                            }
                        } else {
                            if (isAliCommandTextOnly) {
                                NSString *share_text = data[@"share_code"];
                                [weakSelf letaoCopyPasteboardText:share_text];
                                [weakSelf startFetchVideo:dy_video_url shareText:share_text];
                            }

                        }
                    }
                } failure:^(NSString * _Nonnull errorMsg) {
                   [weakSelf letaoRemoveLoading];
                    [weakSelf showTipMessage:errorMsg];
                }];
            } else {
                [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsJumpUrlDataWithGoodsId:letaoGoodsId itemSource:source isAliCommandTextOnly:YES success:^(XLTBaseModel * _Nonnull model,BOOL isAliCommandTextOnly) {
                    [weakSelf letaoRemoveLoading];
                    NSDictionary *data = model.data;
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        if ([XLTGoodsDetailLogic letaoIsNeedPDDAuthorizationCode:model]) {
                            NSString *auth_url = model.data[@"auth_url"];
                            if ([auth_url isKindOfClass:[NSString class]]) {
                                [weakSelf letaoOpenPddWithUrlString:auth_url];
                            }
                        }else {
                            if (isAliCommandTextOnly) {
                                NSString *share_text = data[@"share_code"];
                                [weakSelf letaoCopyPasteboardText:share_text];
                                [weakSelf startFetchVideo:dy_video_url shareText:share_text];
                            }
                        }
                        
                    }
                } failure:^(NSString * _Nonnull errorMsg) {
                    [weakSelf letaoRemoveLoading];
                    [weakSelf showTipMessage:errorMsg];
                }];
            }
        }

}

- (void)letaoOpenAliTrandWithURLString:(NSString *)url
                        authorization:(BOOL)authorization {
    [[XLTAliManager shareManager] openAliTrandPageWithURLString:url sourceController:self authorized:authorization];
}
- (void)letaoOpenPddWithUrlString:(NSString *)url{
    [[XLTPDDManager shareManager] openPDDPageWithURLString:url sourceController:self close:NO];
}
- (void)letaoCopyPasteboardText:(NSString *)text {
    if ([text isKindOfClass:[NSString class]]
        && text.length > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = text;
        [MBProgressHUD letaoshowTipMessageInWindow:@"商品口令已复制!" hideAfterDelay:0.5];
    }
}

- (void)startFetchVideo:(NSString *)videoUrl shareText:(NSString *)shareText {
    // 如果有缓存，直接取本地缓存
    NSURL *assetURL = [NSURL URLWithString:videoUrl];
    NSURL *url = [KTVHTTPCache cacheCompleteFileURLWithURL:assetURL];
    NSString *suffix = [url pathExtension];
    if (url && [[DYVideoManager shareManager] isPlayableSuffix:suffix]) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
        activityVC.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError) {
            if ([shareText isKindOfClass:[NSString class]]
                   && shareText.length > 0) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                 pasteboard.string = shareText;
            }
        };
        [self.navigationController presentViewController:activityVC animated:YES completion:nil];
    } else {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        NSMutableArray *videos = [[NSMutableArray alloc] initWithObjects:videoUrl, nil];
        info[@"videos"] = videos;
         __weak typeof(self)weakSelf = self;
        [self downLoadShareResource:info complete:^(NSArray *videoArray, NSArray *imageArray) {
            [weakSelf showActivityViewControllerWithVideoArray:videoArray shareText:shareText];
        }];
    }
}

- (void)downLoadShareResource:(NSDictionary *)info complete:(void(^)(NSArray *videoArray, NSArray *imageArray))complete {
    
    XLTShareFeedMediaDownloadVC *mediaDownloadVC = [[XLTShareFeedMediaDownloadVC alloc] init];
    [mediaDownloadVC letaoPresentWithSourceVC:self.navigationController downloadMediaWithItemInfo:info complete:^(NSArray * _Nonnull videoArray, NSArray * _Nonnull imageArray) {
        complete(videoArray,imageArray);
    }];
}



- (void)showActivityViewControllerWithVideoArray:(NSArray *)videoArray shareText:(NSString *)shareText {
    NSMutableArray *activityItems = [NSMutableArray array];
    if (videoArray.count > 0) {
        NSString *videoPath = videoArray.firstObject;
        if ([videoPath isKindOfClass:[NSString class]]) {
            NSURL *url = [NSURL URLWithString:videoPath];
            [activityItems addObject:url];
        }
    }

    if (activityItems.count > 0) {
        if (activityItems.count >9) {
            [activityItems removeObjectsInRange:NSMakeRange(9, activityItems.count-9)];
        }
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:[XLTGoodsDisplayHelp processSizeForShareActivityItems:activityItems goodsImage:nil] applicationActivities:nil];
        
        activityVC.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError) {
            if ([shareText isKindOfClass:[NSString class]]
                   && shareText.length > 0) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                 pasteboard.string = shareText;
            }
        };
        
        [self.navigationController presentViewController:activityVC animated:YES completion:nil];
    } else {
        [self showTipMessage:@"没有分享素材"];
    }
}


#pragma mark -  引导页

#define kYVideoIsFristCome @"DYVideoViewController.kisFristCome"

- (BOOL)isFristCome {
    NSNumber *isInstalledFlag = [[NSUserDefaults standardUserDefaults] objectForKey:kYVideoIsFristCome];
    BOOL isFristInstall = !([isInstalledFlag isKindOfClass:[NSNumber class]] && [isInstalledFlag boolValue]);
    return isFristInstall;
}


- (void)displayGuardViewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        DYGuardViewController *guardViewController = [[DYGuardViewController alloc] init];
        guardViewController.delegate = self;
        self.definesPresentationContext = YES;
        guardViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:guardViewController animated:NO completion:^{
            guardViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
            [self.contentTableView.visibleCells enumerateObjectsUsingBlock:^(__kindof DYVideoCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj tryPauseWhenViewWillDisappear];
            }];
        }];
    });
}


- (void)dismissGuardViewController {
    [self dismissViewControllerAnimated:NO completion:^{
        [self.contentTableView.visibleCells enumerateObjectsUsingBlock:^(__kindof DYVideoCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj tryPlayWhenViewWillAppear];
        }];
    }];
}


- (void)guardShouldDismiss {
    [self dismissGuardViewController];
    // 看过了
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kYVideoIsFristCome];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
