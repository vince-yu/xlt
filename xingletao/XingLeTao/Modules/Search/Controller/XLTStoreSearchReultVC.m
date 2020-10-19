//
//  XLTStoreSearchReultVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/12.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTStoreSearchReultVC.h"
#import "XLTQRCodeScanLogic.h"
#import "XLTSearchLogic.h"
#import "XLTGoodsDetailVC.h"
#import "XLTCustomSearchBar.h"
#import "HMSegmentedControl.h"
#import "XLTHomePageLogic.h"
#import "XLTCelebrityStoreHeaderView.h"
#import "XLTCelebrityStoreGoodsCell.h"
#import "XLTStoreSearchFooterView.h"
#import "XLTBGCollectionViewFlowLayout.h"
#import "XLTStoreContainerVC.h"
#import "XLTStoreSearchTopSpaceCollectionViewCell.h"

@interface XLTStoreSearchReultVC () <UITextFieldDelegate,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XLTBGCollectionViewDelegateFlowLayout, XLTCelebrityStoreHeaderDelegate>
@property (nonatomic, strong) XLTSearchLogic *letaoSearchLogic;
@property (nonatomic, strong) NSMutableArray *letaoSearchTaskArray;

@property (nonatomic, strong) XLTCustomSearchBar *letaoCustomSearchBar;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, assign) BOOL isLetaoRecommendStyle;

@end

@implementation XLTStoreSearchReultVC

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.frame = CGRectMake(10, kSafeAreaInsetsTop +44, self.view.bounds.size.width - 20, self.view.bounds.size.height - kSafeAreaInsetsTop -44);
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.letaoCustomSearchBar];
    [self.view addSubview:self.segmentedControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
        if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }

}

- (XLTCustomSearchBar *)letaoCustomSearchBar {
    if (_letaoCustomSearchBar == nil) {
        _letaoCustomSearchBar = [[XLTCustomSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSafeAreaInsetsTop)];
        [_letaoCustomSearchBar.letaoCancelBtn addTarget:self action:@selector(letaoDidClickedCancel) forControlEvents:UIControlEventTouchUpInside];
        _letaoCustomSearchBar.letaoSearchTextFiled.delegate = self;
        _letaoCustomSearchBar.letaoSearchTextFiled.text = self.letaoSearchText;
    }
    return _letaoCustomSearchBar;
}

- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.letaoCustomSearchBar.frame), self.view.bounds.size.width,  44)];
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15);
        _segmentedControl.userDraggable = NO;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.sectionTitles = @[@"全部",@"淘宝",@"天猫",@"京东"];
        _segmentedControl.type = HMSegmentedControlTypeText;
        _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]};
        _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]};
        [_segmentedControl addTarget:self action:@selector(letaoSegmentedValueChanged:) forControlEvents:UIControlEventValueChanged];

    }
    return _segmentedControl;
    
}

- (void)letaoSegmentedValueChanged:(id)sender {
    self.isLetaoRecommendStyle = NO;
    [self requestFristPageData];
}



- (UICollectionViewFlowLayout *)collectionViewLayout {
    XLTBGCollectionViewFlowLayout *flowLayout = [[XLTBGCollectionViewFlowLayout alloc] init];
    flowLayout.sectionHeadersPinToVisibleBounds = NO;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return flowLayout;
}

- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
    [self.view bringSubviewToFront:self.letaoCustomSearchBar];
}

- (void)letaoShowErrorView {
    [super letaoShowErrorView];
    [self.view bringSubviewToFront:self.letaoCustomSearchBar];
}

- (void)letaoShowEmptyView {
    self.isLetaoRecommendStyle = YES;
    [self requestFristPageData];
}

- (void)letaoDidClickedCancel {
    NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
    if (array.count > 2) {
        [array removeObject:self];
        [array removeLastObject];
        [self.navigationController setViewControllers:array animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.navigationController popViewControllerAnimated:NO];
    return NO;
}

- (NSString * _Nullable)sourceParameter {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    switch (index) {
        case 0:
            return nil;
        case 1:
            return XLTTaobaoPlatformIndicate;
        case 2:
            return XLTTianmaoPlatformIndicate;
        case 3:
            return XLTJindongPlatformIndicate;
    }
    return nil;

}


- (NSMutableArray *)letaoSearchTaskArray {
    if(!_letaoSearchTaskArray) {
        _letaoSearchTaskArray = [NSMutableArray array];
    }
    return _letaoSearchTaskArray;
}

- (void)letaoCancelAllSearchTask {
    @synchronized (self) {
        [self.letaoSearchTaskArray enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [self.letaoSearchTaskArray removeAllObjects];
    }
}

- (void)letaoFetchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    if (self.letaoSearchLogic == nil) {
        self.letaoSearchLogic = [[XLTSearchLogic alloc] init];
    }
    [self letaoCancelAllSearchTask];
    if (self.isLetaoRecommendStyle) {
        [self letaoFetchRecommendPageDataForIndex:index pageSize:pageSize success:success failed:failed];
    } else {
        [self letaoFetchSearchPageDataForIndex:index pageSize:pageSize success:success failed:failed];
    }
}

- (void)letaoFetchSearchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    __weak typeof(self)weakSelf = self;
     NSURLSessionTask *sessionTask = [self.letaoSearchLogic letaoSearchStoreWithIndex:index pageSize:pageSize letaoSearchText:self.letaoSearchText source:[self sourceParameter] success:^(NSArray * _Nonnull storeArray, NSURLSessionTask * _Nonnull task) {
        if ([weakSelf.letaoSearchTaskArray containsObject:task]) {
            [weakSelf.letaoSearchTaskArray removeObject:task];
            NSMutableArray *hadNullArray = storeArray.mutableCopy;
            if ((index == [weakSelf theFirstPageIndex]) && hadNullArray.count > 0) {
                [hadNullArray insertObject:[NSNull null] atIndex:0];
            }
            success(hadNullArray);
            if (index == [weakSelf theFirstPageIndex]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
                });
            }
        }
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionTask * _Nonnull task) {
        if ([weakSelf.letaoSearchTaskArray containsObject:task]) {
            [weakSelf.letaoSearchTaskArray removeObject:task];
            failed(nil,errorMsg);
        }
    }];
    
    sessionTask ? [self.letaoSearchTaskArray  addObject:sessionTask] : nil ;
}

- (void)letaoFetchRecommendPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    __weak typeof(self)weakSelf = self;
     NSURLSessionTask *sessionTask = [self.letaoSearchLogic letaoRecommendStoreWithIndex:index pageSize:pageSize source:[self sourceParameter] success:^(NSArray * _Nonnull storeArray, NSURLSessionTask * _Nonnull task) {
        if ([weakSelf.letaoSearchTaskArray containsObject:task]) {
            [weakSelf.letaoSearchTaskArray removeObject:task];
            NSMutableArray *hadNullArray = storeArray.mutableCopy;
            if ((index == [weakSelf theFirstPageIndex]) && hadNullArray.count > 0) {
                [hadNullArray insertObject:[NSNull null] atIndex:0];
            }
            success(hadNullArray);
            if (index == [weakSelf theFirstPageIndex]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
                });
            }
        }
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionTask * _Nonnull task) {
        if ([weakSelf.letaoSearchTaskArray containsObject:task]) {
            [weakSelf.letaoSearchTaskArray removeObject:task];
            failed(nil,errorMsg);
        }
    }];
    
    sessionTask ? [self.letaoSearchTaskArray  addObject:sessionTask] : nil ;
}



// CELL
static NSString *const kXLTCelebrityStoreHeaderView = @"XLTCelebrityStoreHeaderView";
static NSString *const kXLTCelebrityStoreGoodsCell = @"XLTCelebrityStoreGoodsCell";
static NSString *const kXLTStoreSearchFooterView = @"XLTStoreSearchFooterView";
static NSString *const kXLTStoreSearchTopSpaceCollectionViewCell = @"XLTStoreSearchTopSpaceCollectionViewCell";


- (void)letaoListRegisterCells {
    [self.collectionView registerNib:[UINib nibWithNibName:kXLTCelebrityStoreHeaderView bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLTCelebrityStoreHeaderView];

    [self.collectionView registerNib:[UINib nibWithNibName:kXLTCelebrityStoreGoodsCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTCelebrityStoreGoodsCell];
    [self.collectionView registerNib:[UINib nibWithNibName:kXLTStoreSearchTopSpaceCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTStoreSearchTopSpaceCollectionViewCell];

    
    [self.collectionView registerNib:[UINib nibWithNibName:kXLTStoreSearchFooterView bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kXLTStoreSearchFooterView];
}

- (NSArray *)letaoGoodsArrayForSection:(NSInteger)section {
    NSDictionary *letaoBigVDictionary = self.letaoPageDataArray[section];
    if ([letaoBigVDictionary isKindOfClass:[NSDictionary class]]) {
        NSArray *goodsArray = letaoBigVDictionary[@"goods"];
        if ([goodsArray isKindOfClass:[NSArray class]]) {
            return goodsArray;
        }
    }
    return nil;
}

- (NSDictionary *)letaoGoodsInfoForIndexPath:(nonnull NSIndexPath *)indexPath {
    NSArray *goodsArray = [self letaoGoodsArrayForSection:indexPath.section];
    if (indexPath.row < goodsArray.count) {
        return goodsArray[indexPath.row];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.letaoPageDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *iteminfo = self.letaoPageDataArray[section];
    if ([iteminfo isKindOfClass:[NSDictionary class]]) {
        NSArray *goodsArray = iteminfo[@"goods"];
        if ([goodsArray isKindOfClass:[NSArray class]]) {
            return MIN(3, goodsArray.count);
        }
    } else if ([self isTopSpaceCellSection:section]){
        return 1;
    }
    return 0;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([self isTopSpaceCellSection:indexPath.section]) {
        return [self collectionView:collectionView topEmptycellForItemAtIndexPath:indexPath];
    } else {
        XLTCelebrityStoreGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTCelebrityStoreGoodsCell forIndexPath:indexPath];
        NSDictionary *iteminfo = self.letaoPageDataArray[indexPath.section];
        NSArray *goodsArray = iteminfo[@"goods"];
        NSDictionary *goodInfo = nil;
        if (indexPath.row < goodsArray.count) {
            goodInfo = goodsArray[indexPath.row];
        }
        [cell letaoUpdateCellDataWithInfo:goodInfo];
        return cell;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView topEmptycellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTStoreSearchTopSpaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTStoreSearchTopSpaceCollectionViewCell forIndexPath:indexPath];
    cell.letaoShowTipButton = self.isLetaoRecommendStyle;
    return cell;
    
}


- (BOOL)isTopSpaceCellSection:(NSInteger)section {
    NSDictionary *iteminfo = self.letaoPageDataArray[section];
    return (section == 0 && [iteminfo isKindOfClass:[NSNull class]]);
}

//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isTopSpaceCellSection:indexPath.section]) {
        return CGSizeMake(collectionView.bounds.size.width, (self.isLetaoRecommendStyle ? 15+22 :15));
    } else {
        CGFloat width = floorl((collectionView.bounds.size.width -40)/3);
        return CGSizeMake(width, width +60 + 15);
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    NSDictionary *letaoStoreDictionary = self.letaoPageDataArray[section];
    if ([letaoStoreDictionary isKindOfClass:[NSDictionary class]]) {
        CGFloat height = 110;

        NSArray *goodsArray = letaoStoreDictionary[@"goods"];
        if ([goodsArray isKindOfClass:[NSArray class]] && goodsArray.count > 0) {
            height += 10;
        }
        if (![XLTCelebrityStoreHeaderView letaoStoreisEvaluatesValidForInfo:letaoStoreDictionary]) {
            height -= 40;
        }
        return CGSizeMake(collectionView.bounds.size.width, height);
    }

    return CGSizeZero;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
     NSDictionary *letaoStoreDictionary = self.letaoPageDataArray[section];
    if ([letaoStoreDictionary isKindOfClass:[NSDictionary class]]) {
        return CGSizeMake(collectionView.bounds.size.width, 25);
    } else {
        return CGSizeZero;
    }
}

 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if (kind == UICollectionElementKindSectionHeader) {
         XLTCelebrityStoreHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLTCelebrityStoreHeaderView forIndexPath:indexPath];
          headerView.indexPath = indexPath;
          NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.section];
         [headerView updateCelebrityData:itemInfo];
         headerView.delegate = self;
         return headerView;
     } else {
         XLTStoreSearchFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kXLTStoreSearchFooterView forIndexPath:indexPath];
         return footer;
     }

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![self isTopSpaceCellSection:indexPath.section]) {
        NSDictionary *itemInfo = [self letaoGoodsInfoForIndexPath:indexPath];
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


- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section {
    return [UIColor whiteColor];
}

- (void)letaoPushToStoreAction:(XLTCelebrityStoreHeaderView *)storeHeaderView {
    if (storeHeaderView.indexPath.section < self.letaoPageDataArray.count) {
        NSDictionary *seller  = self.letaoPageDataArray[storeHeaderView.indexPath.section];
        XLTStoreContainerVC *storeViewController = [[XLTStoreContainerVC alloc] init];
        NSString *letaoStoreId = nil;
        if ([seller isKindOfClass:[NSDictionary class]]) {
            letaoStoreId = seller[@"seller_shop_id"];
        }
        storeViewController.letaoStoreId = letaoStoreId;
        storeViewController.letaoStoreDictionary = seller;
        [self.navigationController pushViewController:storeViewController animated:YES];
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
