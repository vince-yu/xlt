//
//  XLTHomeCategoryListVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/2.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomeCategoryListVC.h"
#import "XLTHomePageLogic.h"
#import "XLTHomeCategoryGoodsCollectionViewCell.h"
#import "XLTGoodsDetailVC.h"
#import "XLTHomeCategoryTopCollectionViewCell.h"
#import "XLTHomePlateFilterListVC.h"
#import "XLTCategoryFilterListVC.h"
#import "LetaoEmptyCoverView.h"
#import "AppDelegate.h"
#import "XLTCategoryListVC.h"

@interface XLTHomeCategoryListVC () <XLTHomeCategoryTopCellDelegate>
@property (nonatomic, strong) XLTHomePageLogic *letaoHomeLogic;
@property (nonatomic, strong) NSMutableArray *letaoAllTask;
@property (nonatomic, strong) NSArray *letaoCategoryDataArray;
@end

@implementation XLTHomeCategoryListVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.letaoPageDataArray = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoLoginSuccessNotification) name:kXLTNotifiLoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoLogoutSuccessNotification) name:kXLTNotifiLogoutSuccess object:nil];
    }
    return self;
}

- (void)pagerViewScrolToTop {
    [self.collectionView setContentOffset:CGPointZero animated:YES];
}

- (void)letaoLoginSuccessNotification {
    [self requestFristPageData];
}

- (void)letaoLogoutSuccessNotification {
    [self requestFristPageData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    __weak __typeof(self)weakSelf = self;
    [self setXltBackToTopButtonCallback:^{
        [weakSelf.collectionView setContentOffset:CGPointZero animated:YES];
    }];
}

- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}

- (void)letaoShowEmptyView {
    // do nothing
    if (!self.letaoIsHaveCategoryList) {
        [super letaoShowEmptyView];
        self.letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = NO;
        self.letaoEmptyCoverView.frame = CGRectMake(0, 44, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height - 44);
    }
}

- (void)letaoShowErrorView {
    // do nothing
    if (!self.letaoIsHaveCategoryList) {
        [super letaoShowErrorView];
    }
}

- (void)letaoSetupFilterView {
}

- (void)requestFristPageData {
    [super requestFristPageData];
    if (self.letaoIsHaveCategoryList) {
        [self xingletaonetwork_requestCategoryData];
    }
}
- (void)requestFilterPageData {
    [super requestFristPageData];
}

- (void)xingletaonetwork_requestCategoryData {
    if (self.letaoHomeLogic == nil) {
        self.letaoHomeLogic = [[XLTHomePageLogic alloc] init];
    }
    if (self.letaoCategoryDataArray.count == 0) {
        [self letaoShowLoading];
    }
    __weak typeof(self)weakSelf = self;
    //
    [self.letaoHomeLogic xingletaonetwork_requestPlateNextCategoryListWithPlateId:self.letaoChannelId level:self.letaoChannelLevel success:^(NSArray * _Nonnull plateArray) {
        NSMutableArray *letaoCategoryDataArray = [NSMutableArray array];
        if ([plateArray isKindOfClass:[NSArray class]] &&  plateArray.count > 0) {
            [letaoCategoryDataArray addObjectsFromArray:plateArray];
            // 最多10个元素
            if (plateArray.count > 10) {
                [letaoCategoryDataArray removeObjectsInRange:NSMakeRange(9, plateArray.count - 9)];
                // 增加null对象
                [letaoCategoryDataArray addObject:[NSNull null]];
            }
        }
        weakSelf.letaoCategoryDataArray = letaoCategoryDataArray;
        [weakSelf.collectionView reloadData];
        [weakSelf letaoRemoveLoading];
    } failure:^(NSString * _Nonnull errorMsg) {
        // do nothing
    }];
}


//排序 item_sell_count-销量 rebate.xkd_amount-返利金 item_price-卷后价 +从小到大 -从大到小 sort 默认排序
//XLTSortTypeComprehensive = 0,     //综合
//XLTSortTypePriceAsc = 1,        //价格升序
//XLTSortTypePriceDesc = 2,        //价格降序
//XLTSortTypeSalesAsc = 3,         //销量升序
//XLTSortTypeSalesDesc = 4,       //销量降序
//XLTSortTypeEarnAsc = 5,         //返利升序
//XLTSortTypeEarnDesc = 6,       //返利降序
- (NSString *)letaoSortValueTypeParameter {
    switch (self.letaoSortValueType) {
        case XLTSortTypeComprehensive:
            return nil;
            break;
        case XLTSortTypePriceAsc:
            return @"+item_price";
            break;
        case XLTSortTypePriceDesc:
            return @"-item_price";
            break;
        case XLTSortTypeSalesAsc:
            return @"+item_sell_count";
            break;
        case XLTSortTypeSalesDesc:
            return @"-item_sell_count";
            break;
        case XLTSortTypeEarnAsc:
            return @"+rebate.xkd_amount";
            break;
        case XLTSortTypeEarnDesc:
            return @"-rebate.xkd_amount";
            break;
            
        default:
            break;
    }
}

- (NSString *)sourceParameter {
    NSMutableArray *sourceArray = [NSMutableArray array];
    NSArray *sourceSectionArray = self.letaoFilterArray.firstObject;
    [sourceSectionArray enumerateObjectsUsingBlock:^(XLTRightFilterItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (item.isSelected && item.itemCode) {
            [sourceArray addObject:item.itemCode];
        }
    }];
    if (sourceArray.count > 0) {
       return [sourceArray componentsJoinedByString:@","];
    } else {
        return nil;
    }
}

- (NSNumber *)postageParameter {
     NSMutableArray *expressArray = [NSMutableArray array];
     NSArray *expressSectionArray = self.letaoFilterArray.lastObject;
     [expressSectionArray enumerateObjectsUsingBlock:^(XLTRightFilterItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
         if (item.isSelected && item.itemCode) {
             [expressArray addObject:item.itemCode];
         }
     }];
    return expressArray.count >0 ? @1 : nil;
}

- (NSString *)letaoStoreIdParameter{
    return nil;
}

- (NSNumber *)startPriceParameter {
    if (self.letaoFilterArray.count > 1) {
        NSArray *expressSectionArray = self.letaoFilterArray[1];
        XLTRightFilterItem *item = expressSectionArray.firstObject;
        if ([item.minPrice isKindOfClass:[NSString class]] && item.minPrice.length) {
            return [NSNumber numberWithInteger:[item.minPrice integerValue]*100];
        }
    }
    return nil;
}

- (NSNumber *)endPriceParameter {
    if (self.letaoFilterArray.count > 1) {
        NSArray *expressSectionArray = self.letaoFilterArray[1];
        XLTRightFilterItem *item = expressSectionArray.firstObject;
        if ([item.maxPrice isKindOfClass:[NSString class]] && item.maxPrice.length) {
            return [NSNumber numberWithInteger:[item.maxPrice integerValue]*100];
        }
    }
    return nil;
}

- (void)letaoFetchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    if (self.letaoHomeLogic == nil) {
        self.letaoHomeLogic = [[XLTHomePageLogic alloc] init];
    }
    [self letaoCancelAllTask];
     __weak typeof(self)weakSelf = self;
    NSURLSessionTask *sessionTask = [self.letaoHomeLogic requestHomeCategoryGoodsListDataForIndex:index pageSize:pageSize categoryId:self.letaoChannelId sort:[self letaoSortValueTypeParameter] source:[self sourceParameter] postage:[self postageParameter] startPrice:[self startPriceParameter] endPrice:[self endPriceParameter] letaoStoreId:[self letaoStoreIdParameter] hasCoupon:NO success:^(NSArray * _Nonnull goodsArray,NSURLSessionDataTask * task) {
        if ([weakSelf.letaoAllTask containsObject:task]) {
            [weakSelf.letaoAllTask removeObject:task];
            success(goodsArray);
            if (index == [weakSelf theFirstPageIndex] && !self.letaoIsHaveCategoryList) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
                });
            }
            // 汇报分类商品展示
            NSString *xlt_item_firstcate_id = nil;
            NSString *xlt_item_firstcate_title = nil;
            NSString *xlt_item_secondcate_id = nil;
            NSString *xlt_item_secondcate_title = nil;
            NSString *xlt_item_thirdcate_id = nil;
            NSString *xlt_item_thirdcate_title = nil;
            
            if ([self.letaoChannelLevel isKindOfClass:[NSNumber class]] && [self.letaoChannelLevel intValue] == 1) {
                xlt_item_firstcate_id = self.letaoChannelId;
                xlt_item_firstcate_title = self.channelName;
            } else if ([self.letaoChannelLevel isKindOfClass:[NSNumber class]] && [self.letaoChannelLevel intValue] == 2) {
                xlt_item_secondcate_id = self.letaoChannelId;
                xlt_item_secondcate_title = self.channelName;
            } else {
                xlt_item_thirdcate_id = self.letaoChannelId;
                xlt_item_thirdcate_title = self.channelName;
            }
            [SDRepoManager xltrepo_trackCategoryGoodsEventWithListCount:weakSelf.letaoPageDataArray.count xlt_item_firstcate_id:xlt_item_firstcate_id xlt_item_firstcate_title:xlt_item_firstcate_title xlt_item_secondcate_id:xlt_item_secondcate_id xlt_item_secondcate_title:xlt_item_secondcate_title xlt_item_thirdcate_id:xlt_item_thirdcate_id xlt_item_thirdcate_title:xlt_item_thirdcate_title];
        }
    } failure:^(NSString * _Nonnull errorMsg,NSURLSessionDataTask * task) {
        if ([weakSelf.letaoAllTask containsObject:task]) {
            [weakSelf.letaoAllTask removeObject:task];
            failed(nil,errorMsg);
        }
    }];
    sessionTask ? [self.letaoAllTask  addObject:sessionTask] : nil ;
}

- (NSMutableArray *)letaoAllTask {
    if(!_letaoAllTask) {
        _letaoAllTask = [NSMutableArray array];
    }
    return _letaoAllTask;
}

- (void)letaoCancelAllTask {
    @synchronized (self) {
        [self.letaoAllTask enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [self.letaoAllTask removeAllObjects];
    }
}

// CELL
static NSString *const kXLTHomeCategoryGoodsCollectionViewCell = @"XLTHomeCategoryGoodsCollectionViewCell";
static NSString *const kXLTHomeCategoryTopCollectionViewCell = @"XLTHomeCategoryTopCollectionViewCell";

- (void)letaoListRegisterCells {
    [self.collectionView  registerNib:[UINib nibWithNibName:@"XLTHomeCategoryGoodsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeCategoryGoodsCollectionViewCell];
    [self.collectionView  registerNib:[UINib nibWithNibName:kXLTHomeCategoryTopCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeCategoryTopCollectionViewCell];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFilterHeaderViewIdentifier];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0 && self.letaoCategoryDataArray.count > 0) {
       return 1;
    } else if (section == 1){
       return self.letaoPageDataArray.count;
    } else {
        return 0;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XLTHomeCategoryTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeCategoryTopCollectionViewCell forIndexPath:indexPath];
        cell.delegate = self;
        [cell letaoUpdateCellDataWithInfo:self.letaoCategoryDataArray];
        return cell;
    } else {
        XLTHomeCategoryGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeCategoryGoodsCollectionViewCell forIndexPath:indexPath];
        NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];
        [cell letaoUpdateCellDataWithInfo:itemInfo];
        return cell;
    }

}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        CGFloat itemHeight = floorf(kScreenWidth/5);
        if (self.letaoCategoryDataArray.count > 5) {
            return CGSizeMake(kScreenWidth, itemHeight *2 + 8);
        } else {
            return CGSizeMake(kScreenWidth, itemHeight + 8);
        }
    } else {
        CGFloat offset = ceilf(((kScreenWidth -375)/39)*15);
        // 因为间距不是等比放大，调整一个修正量offset
        CGFloat height = kScreen_iPhone375Scale(340) - offset;
        return CGSizeMake(collectionView.bounds.size.width/2 -15, height);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(section == 0) {
        if (self.letaoCategoryDataArray.count > 0) {
            return UIEdgeInsetsMake(0, 0, 10, 0);
        } else {
            return UIEdgeInsetsZero;
        }
    } else {
        return UIEdgeInsetsMake(10, 10, 15, 10);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 1) {
         if (kind == UICollectionElementKindSectionHeader) {
             UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFilterHeaderViewIdentifier forIndexPath:indexPath];
            if (self.topFilterView == nil) {
                self.topFilterView = [[NSBundle mainBundle]loadNibNamed:@"XLTTopFilterView" owner:self options:nil].lastObject;
             }
             self.topFilterView.delegate = self;
             self.topFilterView.frame = CGRectMake(0, 0, headerView.bounds.size.width, 44.0);
             self.topFilterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
             [headerView addSubview:self.topFilterView];
              
             return headerView;
         }
     }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(collectionView.bounds.size.width, 44);
    } else {
        return CGSizeZero;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];
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
    

    // 汇报分类商品展示
    NSString *xlt_item_firstcate_id = nil;
    NSString *xlt_item_firstcate_title = nil;
    NSString *xlt_item_secondcate_id = nil;
    NSString *xlt_item_secondcate_title = nil;
    NSString *xlt_item_thirdcate_id = nil;
    NSString *xlt_item_thirdcate_title = nil;
    
    if ([self.letaoChannelLevel isKindOfClass:[NSNumber class]] && [self.letaoChannelLevel intValue] == 1) {
        xlt_item_firstcate_id = self.letaoChannelId;
        xlt_item_firstcate_title = self.channelName;
    } else if ([self.letaoChannelLevel isKindOfClass:[NSNumber class]] && [self.letaoChannelLevel intValue] == 2) {
        xlt_item_secondcate_id = self.letaoChannelId;
        xlt_item_secondcate_title = self.channelName;
    } else {
        xlt_item_thirdcate_id = self.letaoChannelId;
        xlt_item_thirdcate_title = self.channelName;
    }
    [SDRepoManager xltrepo_trackCategoryGoodsSelectedWithInfo:itemInfo xlt_item_firstcate_id:xlt_item_firstcate_id xlt_item_firstcate_title:xlt_item_firstcate_title xlt_item_secondcate_id:xlt_item_secondcate_id xlt_item_secondcate_title:xlt_item_secondcate_title xlt_item_thirdcate_id:xlt_item_thirdcate_id xlt_item_thirdcate_title:xlt_item_thirdcate_title xlt_item_good_position:[NSNumber numberWithInteger:indexPath.row + 1]];
    
}


- (void)letaoTopCell:(XLTHomeCategoryTopCollectionViewCell *)cell didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.letaoCategoryDataArray.count) {
        NSDictionary *plateInfo = self.letaoCategoryDataArray[indexPath.item];
        if ([plateInfo isKindOfClass:[NSDictionary class]]) {
            NSString *plateName = plateInfo[@"title"];
            if (![plateName isKindOfClass:[NSString class]] || plateName.length == 0) {
                plateName = plateInfo[@"name"];
            }
            if (![plateName isKindOfClass:[NSString class]]) {
                plateName = @"";
            }
            NSString *letaoCurrentPlateId = plateInfo[@"_id"];
            NSNumber *level = plateInfo[@"level"];
            XLTCategoryFilterListVC *plateFilterListViewController = [[XLTCategoryFilterListVC alloc] init];
            plateFilterListViewController.nonePlateList = YES;
            plateFilterListViewController.plateName = plateName;
            plateFilterListViewController.categoryId = letaoCurrentPlateId;            
            plateFilterListViewController.categoryLevel = level;
            plateFilterListViewController.parentCategoryName = self.channelName;
            plateFilterListViewController.parentCategoryId = self.letaoChannelId;
            
            [self.navigationController pushViewController:plateFilterListViewController animated:YES];
            // 分类展示汇报
            NSMutableDictionary *properties = @{}.mutableCopy;
            properties[@"xlt_item_id"] = letaoCurrentPlateId;
            properties[@"xlt_item_title"] = plateName;
            properties[@"xlt_item_level"] = [NSString stringWithFormat:@"%@",[SDRepoManager repoResultValue:level]];
            [SDRepoManager xltrepo_trackEvent:XLT_EVENT_HOME_CATEGORY properties:properties];
        } else {
             // 最后一个是更多，跳转分类
            /*
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            XLTTabBarController *tab = delegate.tabBar;
            if (tab.viewControllers.count > 1) {
                XLTCategoryListVC *categoryListVC = tab.viewControllers[1];
                if ([categoryListVC isKindOfClass:[XLTCategoryListVC class]]) {
                    tab.selectedIndex = 1;
                    [categoryListVC needPickCategory:self.letaoChannelId categoryLevel:self.letaoChannelLevel];
                }
            }*/
            
            XLTCategoryPushListVC *categoryPushListVC = [[XLTCategoryPushListVC alloc] init];
            [categoryPushListVC needPickCategory:self.letaoChannelId categoryLevel:self.letaoChannelLevel];
            [self.navigationController pushViewController:categoryPushListVC animated:YES];
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self xlt_scrollViewDidScroll:scrollView needAutoShowBackToTop:YES];
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
