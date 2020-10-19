//
//  XLTHomeGuessYouLikeVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/7/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTHomeGuessYouLikeVC.h"
#import "MJRefresh.h"
#import "LetaoEmptyCoverView.h"
#import "XLTHomePageLogic.h"
#import "XLTHomeCategoryGoodsCollectionViewCell.h"
#import "XLTGoodsDetailVC.h"

@interface XLTHomeGuessYouLikeVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *sndoGoodsArray;
@property (nonatomic, assign) NSInteger sndoGoodsPageIndex;

@property (nonatomic, strong) NSMutableArray *taobaoGoodsArray;
@property (nonatomic, assign) NSInteger taobaoGoodsPageIndex;
/**
*  进入页面有两种模式，模式1和模式2，轮流切换
*   模式0：先请求大数据接口，没有数据时，请求淘宝数据接口
*   模式1：请求淘宝数据
 */
@property (nonatomic, assign) NSInteger apiModelType;
@property (nonatomic, assign) NSInteger curentApiModelType;


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MJRefreshNormalHeader *letaoRefreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *letaoRefreshAutoFooter;

@property (nonatomic, assign) BOOL letaoIsLoadingState;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoEmptyCoverView;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;

@end

@implementation XLTHomeGuessYouLikeVC

/**
 *  进入页面有两种模式，模式1和模式2，轮流切换
 *   模式1：先请求大数据接口，没有数据时，请求淘宝数据接口
 *   模式2：请求淘宝数据
 *   商品点击是汇报，并区分是拿过数据源的数据
 *   两个section，第一个section显示sndo数据接口数据，第二个显示淘宝数据
 */

// 页面进入次数
static NSInteger kGuessYouLikePageViewCount = -1;
- (instancetype)init {
    self = [super init];
    if (self) {
        _sndoGoodsArray = [NSMutableArray array];
        _taobaoGoodsArray = [NSMutableArray array];
        _sndoGoodsPageIndex =  [self theFirstPageIndex];
        _taobaoGoodsPageIndex =  [self theFirstPageIndex];
        /*
        if (kGuessYouLikePageViewCount == -1) {
            // 初始化值，读取
             kGuessYouLikePageViewCount = [self localGuessYouLikePageViewCount];
            [self increaseLocalGuessYouLikePageViewCount];
        } 修改汇报接口
        _apiModelType = (kGuessYouLikePageViewCount %2);*/
        _apiModelType = 1;
        _curentApiModelType = _apiModelType;
    }
    return self;
}


#define kLocalGuessYouLikePageViewCountKey @"XLTHomeGuessYouLikeVC.LocalGuessYouLikePageViewCount"

- (NSInteger)localGuessYouLikePageViewCount {
    NSNumber *viewCount = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalGuessYouLikePageViewCountKey];
    if ([viewCount isKindOfClass:[NSNumber class]]) {
        return MAX(0, [viewCount integerValue]);
    }
    return 0;
}

- (void)increaseLocalGuessYouLikePageViewCount {
    NSInteger viewCount = kGuessYouLikePageViewCount +1;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:viewCount] forKey:kLocalGuessYouLikePageViewCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loadingViewBgColor = self.view.backgroundColor;
    [self loadContentTableView];
    [self requestFristPageData];
}

- (UICollectionViewFlowLayout *)collectionViewLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionHeadersPinToVisibleBounds = YES;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return flowLayout;
}

- (void)loadContentTableView {
    UICollectionViewFlowLayout *flowLayout = [self collectionViewLayout];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor letaolightgreyBgSkinColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self letaoListRegisterCells];
    [self letaoSetupRefreshHeader];
    _collectionView.mj_header = _letaoRefreshHeader;
    
    [self letaoSetupRefreshAutoFooter];
    _collectionView.mj_footer = _letaoRefreshAutoFooter;
    // 首次隐藏
    _collectionView.mj_footer.hidden = YES;
    
    [self.view addSubview:_collectionView];
}

- (void)letaoListRegisterCells {
    [self.collectionView  registerNib:[UINib nibWithNibName:@"XLTHomeCategoryGoodsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTHomeCategoryGoodsCollectionViewCell"];

}

- (void)letaoSetupRefreshHeader {
    if (_letaoRefreshHeader == nil) {
        __weak __typeof(self)weakSelf = self;
        _letaoRefreshHeader =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf letaoTriggerRefresh];
        }];
    }
}

- (void)letaoSetupRefreshAutoFooter {
    if (_letaoRefreshAutoFooter == nil) {
        __weak __typeof(self)weakSelf = self;
        _letaoRefreshAutoFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf letaoTriggerLoadMore];
        }];
        _letaoRefreshAutoFooter.triggerAutomaticallyRefreshPercent = - 5.0;
        _letaoRefreshAutoFooter.autoTriggerTimes = -1;
        
        
        [_letaoRefreshAutoFooter setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
        _letaoRefreshAutoFooter.stateLabel.textColor = [UIColor colorWithHex:0xFFa9a9a9];
        _letaoRefreshAutoFooter.stateLabel.font = [UIFont letaoRegularFontWithSize:12.0];
    }
}

- (void)letaoTriggerRefresh {
    if (_letaoIsLoadingState) {
        return;
    }
    _letaoIsLoadingState = YES;
    [self requestFristPageData];
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



#define kPageSize 10
#define kTheFirstPageIndex 1
- (NSInteger)pageSize {
    return kPageSize;
}

- (NSInteger)theFirstPageIndex {
    return kTheFirstPageIndex;
}


- (NSInteger)miniPageSizeForMoreData {
    return 1;
}


// 刷新，重置 curentApiModelType
- (void)requestFristPageData {
    NSInteger requestIndex = [self theFirstPageIndex];
    self.curentApiModelType = self.apiModelType;
    if (self.sndoGoodsArray.count + self.taobaoGoodsArray.count == 0) {
        [self letaoShowLoading];
        [self letaoRemoveEmptyView];
    }
    [self letaoFetchPageDataForIndex:requestIndex pageSize:kPageSize apiModelType:self.curentApiModelType];
}


- (void)requestPageData:(NSInteger)requestIndex {
    if (self.sndoGoodsArray.count + self.taobaoGoodsArray.count == 0) {
        [self letaoShowLoading];
        [self letaoRemoveEmptyView];
    }
    [self letaoFetchPageDataForIndex:requestIndex pageSize:kPageSize apiModelType:self.curentApiModelType];
}


- (void)requestNextPageData {
    if (self.curentApiModelType == 0) {
        NSInteger requestIndex = _sndoGoodsPageIndex +1;
        [self letaoFetchPageDataForIndex:requestIndex pageSize:kPageSize apiModelType:0];
    } else {
        NSInteger requestIndex = _taobaoGoodsPageIndex +1;
        [self letaoFetchPageDataForIndex:requestIndex pageSize:kPageSize apiModelType:1];
    }

}

- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                      apiModelType:(NSInteger)modelType {
    __weak __typeof(self)weakSelf = self;
    [self letaoFetchPageDataForIndex:index pageSize:pageSize apiModelType:modelType success:^(NSArray * _Nullable letaoPageDataArray,NSInteger apiModelType,BOOL isTaobaoSource) {
        if (weakSelf.curentApiModelType == apiModelType) {
            if (letaoPageDataArray.count > 0) {
                [weakSelf receivedDataSuccess:letaoPageDataArray andIndex:index isTaobaoSource:isTaobaoSource];
            } else {
                // 深度数据加载完毕，则切换api
                if (apiModelType == 0) {
                    weakSelf.curentApiModelType = 1;
                    NSInteger pageIndex = [weakSelf theFirstPageIndex];
                    [weakSelf requestPageData:pageIndex];
                } else {
                    [weakSelf receivedDataSuccess:letaoPageDataArray andIndex:index isTaobaoSource:isTaobaoSource];
                }
            }

        }
    } failed:^(NSError * _Nullable error, NSString * _Nullable tipMessage,NSInteger apiModelType) {
        if (weakSelf.curentApiModelType == apiModelType) {
            // 深度数据加载完毕，则切换api
            if (apiModelType == 0) {
                weakSelf.curentApiModelType = 1;
                NSInteger pageIndex = [weakSelf theFirstPageIndex];
                [weakSelf requestPageData:pageIndex];
            } else {
                [weakSelf receivedDataError:error tipMessage:tipMessage];
            }
        }
    }];
}

// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                      apiModelType:(NSInteger)apiModelType
                        success:(void(^)(NSArray *goodArray,NSInteger apiModelType,BOOL isTaobaoSource))success
                        failed:(void(^)(NSError * _Nullable error, NSString * _Nullable tipMessage,NSInteger apiModelType))failed {
    if (apiModelType == 0) {
        // 请求深度数据
        [XLTHomePageLogic requestSndoHomeGuessYouLikeWithIndex:index pageSize:pageSize success:^(NSArray * _Nonnull goodArray) {
            success(goodArray,apiModelType,NO);
        } failure:^(NSString * _Nonnull errorMsg) {
            failed(nil,errorMsg,apiModelType);
        }];
    } else {
        // 请求淘宝
        [XLTHomePageLogic requestTaobaoHomeGuessYouLikeWithIndex:index pageSize:pageSize success:^(NSArray * _Nonnull goodArray) {
            success(goodArray,apiModelType,YES);
        } failure:^(NSString * _Nonnull errorMsg) {
            failed(nil,errorMsg,apiModelType);
        }];
    }
}

- (void)receivedDataError:(NSError * _Nullable)error tipMessage:(NSString * _Nullable)tipMessage {
    [self letaoRemoveMJLoadingsStatus];
    [self letaoRemoveLoading];
    if (self.sndoGoodsArray.count + self.taobaoGoodsArray.count == 0) {
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

- (void)receivedDataSuccess:(NSArray *)letaoPageDataArray andIndex:(NSInteger)index isTaobaoSource:(BOOL)isTaobaoSource {
    if (index == [self theFirstPageIndex]) {
        if(isTaobaoSource && self.apiModelType == 0) {
            // 如果是第一页数据，然后模式是0，数据淘宝来源，做追加操作
            [self.taobaoGoodsArray removeAllObjects]; // 刷新淘宝数据源
            [self addMoreContentTableViewUseData:letaoPageDataArray];
        } else {
            [self refreshContentTableViewUseData:letaoPageDataArray];
        }
    } else {
        [self addMoreContentTableViewUseData:letaoPageDataArray];
    }
    
    [self letaoRemoveLoading];
    [self letaoRemoveErrorView];
    
    [self letaoStopRefreshState];
    if (self.sndoGoodsArray.count + self.taobaoGoodsArray.count > 0) {
        [self letaoRemoveEmptyView];
        if(letaoPageDataArray.count < [self miniPageSizeForMoreData]) {
            [self letaoStopLoadMoreStateWithNoMoreData];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.collectionView.mj_insetT + self.collectionView.mj_contentH <= self.collectionView.mj_h) {
                    self.collectionView.mj_footer.hidden =  (self.sndoGoodsArray.count + self.taobaoGoodsArray.count == 0);
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
    self.collectionView.mj_footer.hidden =  (self.sndoGoodsArray.count + self.taobaoGoodsArray.count == 0);
    
    if (self.curentApiModelType == 0) {
        self.sndoGoodsPageIndex = index;
    } else {
        self.taobaoGoodsPageIndex = index;
    }
    
    // repo
    [self sndoGuessYouLikeRepoReceivedGoodsArray:letaoPageDataArray];
}

// 刷新操作，更新UITableView
- (void)refreshContentTableViewUseData:(NSArray *)letaoPageDataArray {
    if([letaoPageDataArray isKindOfClass:[NSArray class]]) {
        if (self.curentApiModelType == 0) {
            [self.sndoGoodsArray setArray:letaoPageDataArray];
            [self.taobaoGoodsArray removeAllObjects];
        } else {
            [self.sndoGoodsArray removeAllObjects];
            [self.taobaoGoodsArray setArray:letaoPageDataArray];
        }
        [_collectionView reloadData];
    }
}

// 更多操作，更新UITableView
- (void)addMoreContentTableViewUseData:(NSArray *)letaoPageDataArray {
    if([letaoPageDataArray isKindOfClass:[NSArray class]] && [letaoPageDataArray count] > 0) {
        if (self.curentApiModelType == 0) {
            [self.sndoGoodsArray addObjectsFromArray:letaoPageDataArray];
        } else {
            [self.taobaoGoodsArray addObjectsFromArray:letaoPageDataArray];
        }
        
        [_collectionView reloadData];
    }
}


- (void)letaoRemoveMJLoadingsStatus {
    [self letaoStopRefreshState];
    [self letaoStopLoadMoreState];
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
    [self.collectionView addSubview:self.letaoEmptyCoverView];
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
                                                                  [weakSelf requestFristPageData];
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




#pragma mark - UICollectionViewDelegate




- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _sndoGoodsArray.count;
    } else {
        return _taobaoGoodsArray.count;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTHomeCategoryGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTHomeCategoryGoodsCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *itemInfo = nil;
    if (indexPath.section == 0 && indexPath.item < self.sndoGoodsArray.count) {
        itemInfo = self.sndoGoodsArray[indexPath.item];
    } else if (indexPath.section == 1 && indexPath.item < self.taobaoGoodsArray.count) {
        itemInfo = self.taobaoGoodsArray[indexPath.item];
    }
    [cell letaoUpdateCellDataWithInfo:itemInfo];
    return cell;

}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat offset = ceilf(((kScreenWidth -375)/39)*15);
    // 因为间距不是等比放大，调整一个修正量offset
    CGFloat height = kScreen_iPhone375Scale(340) - offset;
    return CGSizeMake(collectionView.bounds.size.width/2 -15, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(10, 10, 0, 10);
    } else {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = nil;
    if (indexPath.section == 0 && indexPath.item < self.sndoGoodsArray.count) {
        itemInfo = self.sndoGoodsArray[indexPath.item];
    } else if (indexPath.section == 1 && indexPath.item < self.taobaoGoodsArray.count) {
        itemInfo = self.taobaoGoodsArray[indexPath.item];
    }
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
        
        // repo
        [self sndoGuessYouLikeRepoClickGoods:itemInfo indexPath:indexPath];
    }
}


- (BOOL)isSndoRecommendGoods:(NSDictionary *)goods {
    if (goods && [self.sndoGoodsArray indexOfObject:goods] !=  NSNotFound) {
        return YES;
    }
    return NO;
}

- (void)sndoGuessYouLikeRepoClickGoods:(NSDictionary *)goods indexPath:(NSIndexPath *)indexPath{
    if ([goods isKindOfClass:[NSDictionary class]]) {
        BOOL is_power = [self isSndoRecommendGoods:goods];
        NSString *power_position = @"猜你喜欢";
        NSString *power_model = goods[@"power_model"];
        NSString *good_id = goods[@"_id"];
        NSString *good_name = goods[@"item_title"];
        NSInteger index = 0;
        if (is_power) {
            if ([self.sndoGoodsArray indexOfObject:goods] != NSNotFound) {
                index = [self.sndoGoodsArray indexOfObject:goods] + 1;
            }
        } else {
            if ([self.taobaoGoodsArray indexOfObject:goods] != NSNotFound) {
                index = [self.taobaoGoodsArray indexOfObject:goods] + 1 + self.sndoGoodsArray.count;
            }
        }
        NSString *xlt_item_place = [NSString stringWithFormat:@"%ld",(long)index];
        NSString *xlt_item_source = goods[@"item_source"];
        
        [SDRepoManager xltrepo_trackReommenClickEventWithIs_pow:is_power power_position:power_position power_model:power_model good_id:good_id good_name:good_name xlt_item_place:xlt_item_place xlt_item_source:xlt_item_source];
    }

}

- (void)sndoGuessYouLikeRepoReceivedGoodsArray:(NSArray *)goodsArray {
    if ([goodsArray isKindOfClass:[NSArray class]]) {
        [goodsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self sndoGuessYouLikeRepoReceivedGoods:obj];
        }];
    }
}

- (void)sndoGuessYouLikeRepoReceivedGoods:(NSDictionary *)goods {
    if ([goods isKindOfClass:[NSDictionary class]]) {
        BOOL is_power = [self isSndoRecommendGoods:goods];
        NSString *power_position = @"猜你喜欢";
        NSString *power_model = goods[@"power_model"];
        NSString *good_id = goods[@"_id"];
        NSString *good_name = goods[@"item_title"];
        NSInteger index = 0;
        if (is_power) {
            if ([self.sndoGoodsArray indexOfObject:goods] != NSNotFound) {
                index = [self.sndoGoodsArray indexOfObject:goods] + 1;
            }
            
        } else {
            if ([self.taobaoGoodsArray indexOfObject:goods] != NSNotFound) {
                index = [self.taobaoGoodsArray indexOfObject:goods] + 1 + self.sndoGoodsArray.count;
            }
        }
        NSString *xlt_item_place = [NSString stringWithFormat:@"%ld",(long)index];
        NSString *xlt_item_source = goods[@"item_source"];
        [SDRepoManager xltrepo_trackReommenShowEventWithIs_pow:is_power power_position:power_position power_model:power_model good_id:good_id good_name:good_name xlt_item_place:xlt_item_place xlt_item_source:xlt_item_source];
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
