//
//  XLTGoodsSearchReultVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsSearchReultVC.h"
#import "XLTQRCodeScanLogic.h"
#import "XLTSearchLogic.h"
#import "XLTCouponSwitchView.h"
#import "XLTHomeCategoryGoodsCollectionViewCell.h"
#import "XLTGoodsDetailVC.h"
#import "XLTCustomSearchBar.h"
#import "XLTGoodsSearchEmptyVC.h"
#import "XLTHomeSingleGoodsCollectionViewCell.h"
#import "SPButton.h"
#import "HMSegmentedControl.h"
#import "PYSearchViewController.h"
#import "LetaoEmptyCoverView.h"

@interface XLTGoodsSearchReultVC () <XLTCouponSwitchViewDelegate,UITextFieldDelegate, XLTGoodsSearchEmptyVCDelegate, PYSearchViewControllerDelegate>
@property (nonatomic, strong) XLTQRCodeScanLogic *letaoQRCodeLogic;
@property (nonatomic, strong) NSString *letaoGoodsId;
@property (nonatomic, strong) XLTSearchLogic *letaoSearchLogic;
@property (nonatomic, strong) NSMutableArray *letaoSearchTaskArray;

@property (nonatomic, strong) XLTCouponSwitchView *letaoCouponSwitchView;
@property(nonatomic, assign) BOOL letaoSwitchOn;
@property (nonatomic, assign) BOOL letaoDidDecodedGoods;

@property (nonatomic, strong) NSMutableArray *supportGoodsPlatformNameArray;
@property (nonatomic, strong) NSMutableArray *supportGoodsPlatformCodeArray;
@property (nonatomic, strong) HMSegmentedControl *letaoSegmentedControl;
@property (nonatomic, assign) BOOL letaoShowPlatformSegment;
@property (nonatomic, strong) PYSearchViewController *letaoSearchVC;

@end

@implementation XLTGoodsSearchReultVC

- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置分平台搜索
        NSArray *supportGoodsPlatformArray = [[XLTAppPlatformManager shareManager] supportGoodsPlatformArrayForSearch];
        _supportGoodsPlatformNameArray = [NSMutableArray array];
        _supportGoodsPlatformCodeArray = [NSMutableArray array];
        [supportGoodsPlatformArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull platformInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([platformInfo isKindOfClass:[NSDictionary class]]) {
                NSString *name = platformInfo[@"name"];
                NSString *code = platformInfo[@"code"];
                if (name && code) {
                    [_supportGoodsPlatformNameArray addObject:name];
                    [_supportGoodsPlatformCodeArray addObject:code];
                }
            }
        }];
        
        _letaoShowPlatformSegment = (_supportGoodsPlatformCodeArray.count == _supportGoodsPlatformNameArray.count && _supportGoodsPlatformNameArray.count > 0);
        [self letaoAddObserverForSearchTextField];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (_letaoShowPlatformSegment) {
        [self.view addSubview:self.letaoSegmentedControl];
    }
    
    [self letaoSetupFilterView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.topFilterView.bounds.size.height - 0.5, self.topFilterView.bounds.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xFFEEEEF0];
    [self.topFilterView addSubview:line];
    
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.topFilterView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.topFilterView.frame));
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.letaoCustomSearchBar];
    
    __weak __typeof(self)weakSelf = self;
    [self setXltBackToTopButtonCallback:^{
        [weakSelf.collectionView setContentOffset:CGPointZero animated:YES];
    }];
    
    
    [self.view addSubview:self.letaoSearchVC.view];
    self.letaoSearchVC.view.backgroundColor = [UIColor letaolightgreyBgSkinColor];
    self.letaoSearchVC.view.hidden = YES;
    
    XLTRightFilterType type = XLTRightFilterTypeFreePost | XLTRightFilterTypePrice;
    self.letaoFilterArray = [XLTRightFilterViewController buildFilterDataArrayWithType:type];
}

- (void)letaoCustomTextFiledFirstResponder {
    [self.letaoCustomSearchBar.letaoSearchTextFiled becomeFirstResponder];
}

- (HMSegmentedControl *)letaoSegmentedControl {
    if (!_letaoSegmentedControl) {
        _letaoSegmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.letaoCustomSearchBar.frame), self.view.bounds.size.width - 20,  44)];
        _letaoSegmentedControl.backgroundColor = [UIColor whiteColor];
        _letaoSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _letaoSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15);
        _letaoSegmentedControl.selectionIndicatorHeight = 2.0;
        _letaoSegmentedControl.selectionIndicatorColor = [UIColor letaomainColorSkinColor];
        _letaoSegmentedControl.sectionTitles = self.supportGoodsPlatformNameArray;
        _letaoSegmentedControl.type = HMSegmentedControlTypeText;
        _letaoSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        [_letaoSegmentedControl addTarget:self action:@selector(letaoSegmentedValueChanged:) forControlEvents:UIControlEventValueChanged];

        _letaoSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _letaoSegmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]};
        _letaoSegmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]};
        
        if (self.item_source) {
            NSUInteger index =  [self.supportGoodsPlatformCodeArray indexOfObject:self.item_source];
            if (index != NSNotFound && index < self.supportGoodsPlatformNameArray.count) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      self.letaoSegmentedControl.selectedSegmentIndex = index;
                  });
            }
        } else {
            self.item_source = self.supportGoodsPlatformCodeArray.firstObject;
        }
        [self adjustLetaoSetupFilterViewStyle];
    }
    return _letaoSegmentedControl;
    
}

- (void)letaoSegmentedValueChanged:(HMSegmentedControl *)segmentedControl {
    NSString *item_source = nil;
    if (self.letaoSegmentedControl.selectedSegmentIndex < self.supportGoodsPlatformCodeArray.count) {
        item_source = self.supportGoodsPlatformCodeArray[self.letaoSegmentedControl.selectedSegmentIndex];
        self.item_source = item_source;
        [self adjustLetaoSetupFilterViewStyle];
    }
    [self adjustLetaoSetupFilterViewStyle];

    NSString *text = self.letaoCustomSearchBar.letaoSearchTextFiled.text;
    [self letaoStartSearchWithText:text];
}

- (void)adjustLetaoSetupFilterViewStyle {
    if (self.topFilterView == nil) {
        [self letaoSetupFilterView];
    }
    
    BOOL isPDD = ([self.item_source isKindOfClass:[NSString class]] && [self.item_source isEqualToString:XLTPDDPlatformIndicate]);
    BOOL isTaobao = ([self.item_source isKindOfClass:[NSString class]] && ([self.item_source isEqualToString:XLTTaobaoPlatformIndicate] || [self.item_source isEqualToString:XLTTianmaoPlatformIndicate]));
    BOOL isVPH = ([self.item_source isKindOfClass:[NSString class]] && [self.item_source isEqualToString:XLTVPHPlatformIndicate]);
    BOOL isJD = ([self.item_source isKindOfClass:[NSString class]] && [self.item_source isEqualToString:XLTJindongPlatformIndicate]);
    BOOL isSuning = ([self.item_source isKindOfClass:[NSString class]] && [self.item_source isEqualToString:XLTSuNingPlatformIndicate]);

    if (isPDD || isSuning) {
        if (isPDD) {
            [self.topFilterView.letaoPriceSortBtn setTitle:@"券后价" forState:UIControlStateNormal];
            self.topFilterView.letaosalesSortBtn.hidden = NO;
            self.topFilterView.letaoEarnSortBtn.hidden = NO;
        } else {
            [self.topFilterView.letaoPriceSortBtn setTitle:@"价格" forState:UIControlStateNormal];
            self.topFilterView.letaosalesSortBtn.hidden = YES;
            self.topFilterView.letaoEarnSortBtn.hidden = NO;
            // 当前选中了销量
            if (self.topFilterView.letaoSortValueType == XLTSortTypeSalesAsc
                || self.topFilterView.letaoSortValueType == XLTSortTypeSalesDesc) {
                [self.topFilterView.letaoCompreSortButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }

    } else {
        [self.topFilterView.letaoPriceSortBtn setTitle:@"价格" forState:UIControlStateNormal];
        self.topFilterView.letaosalesSortBtn.hidden = YES;
        self.topFilterView.letaoEarnSortBtn.hidden = YES;
        // 当前选中了销量和返利金
        if (self.topFilterView.letaoSortValueType == XLTSortTypeSalesAsc
            || self.topFilterView.letaoSortValueType == XLTSortTypeSalesDesc
            || self.topFilterView.letaoSortValueType == XLTSortTypeEarnAsc
            || self.topFilterView.letaoSortValueType == XLTSortTypeEarnDesc) {
            [self.topFilterView.letaoCompreSortButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.topFilterView.sortPriceAscAndDesc = (isTaobao || isJD || isVPH || isSuning);
    self.topFilterView.sortEarneAscAndDesc = (isPDD);
}

- (void)goodsSearchEmptyVC:(XLTGoodsSearchEmptyVC *)vc changedSortType:(XLTTopFilterSortType)type {
    if (self.letaoSortValueType != type) {
         SPButton *filterBtn = nil;
         if (type == XLTSortTypeComprehensive) {
             filterBtn = self.topFilterView.letaoCompreSortButton;
         } else if (type == XLTSortTypePriceAsc || type == XLTSortTypePriceDesc) {
             filterBtn = self.topFilterView.letaoPriceSortBtn;
         } else if (type == XLTSortTypeSalesAsc || type == XLTSortTypeSalesDesc) {
             filterBtn = self.topFilterView.letaosalesSortBtn;
         } else if (type == XLTSortTypeEarnAsc || type == XLTSortTypeEarnDesc) {
            filterBtn = self.topFilterView.letaoEarnSortBtn;
         }
         if (filterBtn) {
             [filterBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
         }
     }
}

- (void)goodsSearchEmptyVC:(XLTGoodsSearchEmptyVC *)vc changedSwitchOn:(BOOL)isOn {
    if (self.letaoSwitchOn != isOn) {
        self.letaoCouponSwitchView.couponSwitch.on = isOn;
        self.letaoSwitchOn = isOn;
        [self requestFristPageData];
    }
}

- (void)goodsSearchEmptyVC:(XLTGoodsSearchEmptyVC *)vc changedFilterArray:(NSArray *)filterArray {
    self.letaoFilterArray = filterArray;
    [self requestFristPageData];
}

- (void)goodsSearchEmptyVC:(XLTGoodsSearchEmptyVC *)vc changedItemSource:(NSString *)item_source {
    if (item_source) {
        NSUInteger index =  [self.supportGoodsPlatformCodeArray indexOfObject:item_source];
        if (index != NSNotFound && index < self.supportGoodsPlatformNameArray.count) {
            self.item_source = item_source;
            _letaoSegmentedControl.selectedSegmentIndex = index;
            [self adjustLetaoSetupFilterViewStyle];
            [self clearPageData];
            [self requestFristPageData];
        }
    }
}


- (void)letaoSetupFilterView {
    if (self.topFilterView == nil) {
        self.topFilterView = [[NSBundle mainBundle]loadNibNamed:@"XLTTopFilterView" owner:self options:nil].lastObject;
     }
    self.topFilterView.delegate = self;
    self.topFilterView.frame = CGRectMake(0, CGRectGetMaxY(self.letaoSegmentedControl.frame), self.view.bounds.size.width, 44.0);
    [self.view addSubview: self.topFilterView];
}


- (UICollectionViewFlowLayout *)collectionViewLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
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
    self.letaoErrorView.contentViewOffset = 80;
    [self.view bringSubviewToFront:self.letaoCustomSearchBar];
}

- (void)letaoShowEmptyView {
    XLTGoodsSearchEmptyVC *goodsEmptyViewController = [[XLTGoodsSearchEmptyVC alloc] init];
    goodsEmptyViewController.letaoFilterArray = [self.letaoFilterArray copy];
    goodsEmptyViewController.letaoSearchText = self.letaoSearchText;
    goodsEmptyViewController.letaoDidDecodedGoods = YES;
    goodsEmptyViewController.delegate = self;
    goodsEmptyViewController.letaoFristSortValueType =  self.letaoSortValueType;
    goodsEmptyViewController.letaoSortValueType =  self.letaoSortValueType;
    goodsEmptyViewController.letaoFristSwitchOn = self.letaoSwitchOn;
    goodsEmptyViewController.letaoSwitchOn = self.letaoSwitchOn;
    goodsEmptyViewController.letaoShowPlatformSegment = self.letaoShowPlatformSegment;
    goodsEmptyViewController.item_source = self.item_source;
    goodsEmptyViewController.pasteboardSearchText = self.pasteboardSearchText;

    [self.navigationController pushViewController:goodsEmptyViewController animated:NO];
}

- (BOOL)isPasteboardSearchTextValid {
    return [self.pasteboardSearchText isKindOfClass:[NSString class]] && self.pasteboardSearchText.length > 0;
}


- (void)requestFristPageData {
    if ([self isPasteboardSearchTextValid]) {
        [super requestFristPageData];
    } else if (self.letaoDidDecodedGoods) {
        [super requestFristPageData];
    } else {
        if (self.letaoQRCodeLogic == nil) {
            self.letaoQRCodeLogic = [[XLTQRCodeScanLogic alloc] init];
        }
        NSString *letaoSearchText = self.letaoSearchText;
        [self letaoShowLoading];
        __weak typeof(self) weakSelf = self;
        // 调用接口解析
        [self.letaoQRCodeLogic decodeResultForCodeText:letaoSearchText is_serch:YES success:^(XLTBaseModel *model) {
            [weakSelf letaoDidDecodedGoods:model.data letaoSearchText:letaoSearchText];
        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf letaoDidDecodedGoodsFailure:errorMsg letaoSearchText:letaoSearchText];
        }];
    }
}

- (void)letaoDidDecodedGoods:(NSDictionary *)result letaoSearchText:(NSString *)letaoSearchText {
    NSString *letaoGoodsId = result[@"goods_id"];
    if ([letaoGoodsId isKindOfClass:[NSString class]] && letaoGoodsId.length > 0) {
        self.letaoGoodsId = letaoGoodsId;
        NSString *item_source = result[@"item_source"];
        if ([item_source isKindOfClass:[NSString class]] && item_source.length > 0) {
            self.item_source = item_source;
            NSUInteger index =  [self.supportGoodsPlatformCodeArray indexOfObject:self.item_source];
            if (index != NSNotFound && index < self.supportGoodsPlatformNameArray.count) {
                _letaoSegmentedControl.selectedSegmentIndex = index;
            }
            [self adjustLetaoSetupFilterViewStyle];
        }
    }
    self.letaoDidDecodedGoods = YES;
    [super requestFristPageData];
}

- (void)letaoDidDecodedGoodsFailure:(NSString *)errorMsg letaoSearchText:(NSString *)letaoSearchText {
    self.letaoDidDecodedGoods = YES;
    [super requestFristPageData];
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
    [self searchDataForIndex:index pageSize:pageSize success:success failed:failed];
}

- (void)searchDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    if (self.letaoSearchLogic == nil) {
        self.letaoSearchLogic = [[XLTSearchLogic alloc] init];
    }
    [self letaoCancelAllSearchTask];
    __weak typeof(self)weakSelf = self;
    
    NSURLSessionTask *sessionTask = [self.letaoSearchLogic letaoSearchGoodsWithIndex:index pageSize:pageSize sort:[self letaoSortValueTypeParameter] source:[self sourceParameter] postage:[self postageParameter] hasCoupon:self.letaoSwitchOn letaoSearchText:self.letaoSearchText letaoGoodsId:self.letaoGoodsId startPrice:[self startPriceParameter] endPrice:[self endPriceParameter] success:^(NSArray * _Nonnull goodsArray, NSURLSessionTask * _Nonnull task) {
        if ([weakSelf.letaoSearchTaskArray containsObject:task]) {
            [weakSelf.letaoSearchTaskArray removeObject:task];
            success(goodsArray);
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

- (void)pasteboardSearchDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    if (self.letaoSearchLogic == nil) {
        self.letaoSearchLogic = [[XLTSearchLogic alloc] init];
    }
    [self letaoCancelAllSearchTask];
    __weak typeof(self)weakSelf = self;
    
    NSURLSessionTask *sessionTask = [self.letaoSearchLogic letaoPasteboardSearchGoodsWithIndex:index pageSize:pageSize sort:[self letaoSortValueTypeParameter] source:[self sourceParameter] postage:[self postageParameter] hasCoupon:self.letaoSwitchOn letaoSearchText:self.letaoSearchText letaoGoodsId:self.letaoGoodsId startPrice:[self startPriceParameter] endPrice:[self endPriceParameter] success:^(NSArray * _Nonnull goodsArray, NSURLSessionTask * _Nonnull task) {
        if ([weakSelf.letaoSearchTaskArray containsObject:task]) {
            [weakSelf.letaoSearchTaskArray removeObject:task];
            success(goodsArray);
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

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.popParameters isKindOfClass:[NSDictionary class]]) {
        NSNumber *isTextFiledFirstResponder = self.popParameters[@"TextFiledFirstResponder"];
        if ([isTextFiledFirstResponder isKindOfClass:[NSNumber class]] && isTextFiledFirstResponder.boolValue) {
            [self letaoCustomTextFiledFirstResponder];
        }
    }
    self.popParameters = nil;
}*/


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
    return self.item_source;
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


// CELL
static NSString *const kXLTHomeSingleGoodsCollectionViewCell = @"XLTHomeSingleGoodsCollectionViewCell";

#define kFilterHeaderViewIdentifier @"kFilterHeaderViewIdentifier"

- (void)letaoListRegisterCells {
    [self.collectionView  registerNib:[UINib nibWithNibName:kXLTHomeSingleGoodsCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeSingleGoodsCollectionViewCell];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFilterHeaderViewIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.letaoPageDataArray.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTHomeSingleGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeSingleGoodsCollectionViewCell forIndexPath:indexPath];
    NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];;
    [cell letaoUpdateCellDataWithInfo:itemInfo];
    return cell;
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, 157);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 0) {
         if (kind == UICollectionElementKindSectionHeader) {
             UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFilterHeaderViewIdentifier forIndexPath:indexPath];
             
             // 优惠券
             if (self.letaoCouponSwitchView == nil) {
                 self.letaoCouponSwitchView = [[NSBundle mainBundle]loadNibNamed:@"XLTCouponSwitchView" owner:self options:nil].lastObject;
              }
              self.letaoCouponSwitchView.delegate = self;
              self.letaoCouponSwitchView.frame = CGRectMake(0, 0, headerView.bounds.size.width, 44.0);
              self.letaoCouponSwitchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
              [headerView addSubview:self.letaoCouponSwitchView];
              
             return headerView;
         }
     }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0 && [self canShowCouponSwitchView]) {
        return CGSizeMake(collectionView.bounds.size.width, 44);
    } else {
        return CGSizeZero;
    }
}
- (BOOL)canShowCouponSwitchView {
    return !([self.item_source isKindOfClass:[NSString class]]
             && ([self.item_source isEqualToString:XLTVPHPlatformIndicate] || [self.item_source isEqualToString:XLTSuNingPlatformIndicate]));
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
    
    //汇报
    NSMutableDictionary *dic = @{}.mutableCopy;
    dic[@"good_id"] = [SDRepoManager repoResultValue:letaoGoodsId];
    dic[@"good_name"] = [SDRepoManager repoResultValue:itemInfo[@"item_title"]];
    NSString *paste_content = self.letaoSearchText;
    dic[@"xlt_item_search_keyword"] = [SDRepoManager repoResultValue:paste_content];
    dic[@"xlt_item_source"] = [SDRepoManager repoResultValue:item_source];
    dic[@"position_number"] = [NSNumber numberWithInteger:indexPath.row + 1];
    dic[@"key_word_type"] = [SDRepoManager repoResultValue:self.searchType];
    dic[@"search_way"] = @"关键词搜索";
    dic[@"xlt_item_firstcate_title"] = @"null";
    dic[@"xlt_item_thirdcate_title"] = @"null";
    dic[@"xlt_item_secondcate_title"] = @"null";
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_SEARCHRESULT_CLICK properties:dic];
}



- (void)letaoCouponSwitchView:(XLTCouponSwitchView *)topFilterView didSwitchOn:(BOOL)isOn {
    self.letaoSwitchOn = isOn;
    [self requestFristPageData];
}

- (XLTCustomSearchBarTwo *)letaoCustomSearchBar {
    if (_letaoCustomSearchBar == nil) {
        _letaoCustomSearchBar = [[XLTCustomSearchBarTwo alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSafeAreaInsetsTop)];
        [_letaoCustomSearchBar.letaoLeftBtn addTarget:self action:@selector(letaoDidClickedCancel) forControlEvents:UIControlEventTouchUpInside];
        [_letaoCustomSearchBar.letaoSearchBtn addTarget:self action:@selector(letaoDidClickedSearch) forControlEvents:UIControlEventTouchUpInside];
        _letaoCustomSearchBar.letaoSearchTextFiled.delegate = self;
        _letaoCustomSearchBar.letaoSearchTextFiled.text = self.letaoSearchText;
    }
    return _letaoCustomSearchBar;
}


- (void)letaoDidClickedCancel {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)letaoDidClickedSearch {
    NSString *letaoSearchText = [self.letaoCustomSearchBar.letaoSearchTextFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self letaoStartSearchWithText:letaoSearchText];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    /*
    self.letaoSearchVC.view.hidden = NO;

    NSString *text = [self.letaoCustomSearchBar.letaoSearchTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (text.length) {
        [self xingletaonetwork_requestSearchSuggestionData:text];
    } else {
        self.letaoSearchVC.searchSuggestions = nil;
    }
    return YES;*/
    if (textField.text == nil || textField.text.length == 0) {
        [self letaoPopViewControllerWithParameters:@{@"kNearestTextFiledText":@""} animated:NO];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *letaoSearchText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self letaoStartSearchWithText:letaoSearchText];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.letaoPageDataArray.count > 0) {
        self.letaoSearchVC.view.hidden = YES;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self xlt_scrollViewDidScroll:scrollView needAutoShowBackToTop:YES];
}


- (void)letaoAddObserverForSearchTextField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoSearchTextFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)letaoSearchTextFieldDidChangeNotification:(NSNotification *)notification {
    if (notification.object == self.letaoCustomSearchBar.letaoSearchTextFiled) {
        NSString *text = [self.letaoCustomSearchBar.letaoSearchTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (text.length) {
            self.letaoSearchVC.view.hidden = NO;
            [self xingletaonetwork_requestSearchSuggestionData:text];
        } else {
            self.letaoSearchVC.view.hidden = YES;
            self.letaoSearchVC.searchSuggestions = nil;
        }
    }
}


- (void)xingletaonetwork_requestSearchSuggestionData:(NSString *)inputText {
    if (self.letaoSearchLogic == nil) {
        self.letaoSearchLogic = [[XLTSearchLogic alloc] init];
    }
    [self.letaoSearchLogic letaoCancelSearchSuggestionTask];
     __weak typeof(self)weakSelf = self;
    [self.letaoSearchLogic xingletaonetwork_xingletaonetwork_requestSearchSuggestionDataWithInputText:inputText success:^(NSArray * _Nonnull suggestionArray) {
        [weakSelf letaoReloadSuggestionData:suggestionArray];
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}


- (void)letaoReloadSuggestionData:(NSArray *)suggestionArray {
    NSMutableArray *searchSuggestions = [NSMutableArray array];
    [suggestionArray  enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]
                       && [obj[@"key"] isKindOfClass:[NSString class]]) {
            [searchSuggestions addObject:obj[@"key"]];
        }
    }];
    self.letaoSearchVC.searchSuggestions = searchSuggestions;
}

- (PYSearchViewController *)letaoSearchVC {
    if (_letaoSearchVC == nil) {
        _letaoSearchVC = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:[[XLTAppPlatformManager shareManager] platformText:@"搜索商品标题 领优惠券拿返现"]];
        _letaoSearchVC.delegate = self;
        _letaoSearchVC.removeSpaceOnSearchString = NO;
        _letaoSearchVC.hotSearchStyle = PYHotSearchStyleBorderTag;
        _letaoSearchVC.searchHistoryStyle = PYSearchHistoryStyleBorderTag;
        _letaoSearchVC.showSearchHistory = NO;
    }
    return _letaoSearchVC;
}

- (void)letaoStartSearchWithText:(NSString *)letaoSearchText {
    [self.view endEditing:YES];
    if (letaoSearchText.length) {
        self.letaoDidDecodedGoods = [self.letaoSearchText isEqualToString:letaoSearchText];
        self.letaoSearchText = letaoSearchText;
    
        [self clearPageData];
        [self requestFristPageData];
        self.letaoSearchVC.view.hidden = YES;
        [self letaoSaveSearchTextAndRefreshView:letaoSearchText];
        
        [[XLTRepoDataManager shareManager] repoSearchActionWithKeyword:letaoSearchText];

        // 汇报事件
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        properties[@"xlt_item_search_keyword"] = letaoSearchText;
        properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:self.item_source];
        [SDRepoManager xltrepo_trackEvent:XLT_EVENT_SEARCH properties:properties];
    }
}

- (void)letaoSaveSearchTextAndRefreshView:(NSString *)searchText {
    self.letaoSearchVC.searchBar.text = searchText;
    [self.letaoSearchVC saveSearchCacheAndRefreshView];
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat segmentedControlHeight = 0;
    if (_letaoShowPlatformSegment) {
        segmentedControlHeight = 44;
    }
    self.letaoSearchVC.view.frame = CGRectMake(0, kSafeAreaInsetsTop +segmentedControlHeight, self.view.bounds.size.width, self.view.bounds.size.height - kSafeAreaInsetsTop -segmentedControlHeight);
    
}

- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath
                   searchBar:(UISearchBar *)searchBar {
    NSString *letaoSearchText = searchViewController.searchSuggestions[indexPath.row];
    self.letaoCustomSearchBar.letaoSearchTextFiled.text = letaoSearchText;
    [self letaoStartSearchWithText:letaoSearchText];
}


- (NSInteger)miniPageSizeForMoreData {
    return 5;
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
