//
//  XLTMallGoodsDetailVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/12/2.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTMallGoodsDetailVC.h"
#import "XLTUserManager.h"
#import "LetaoEmptyCoverView.h"
#import "SDCycleScrollView.h"
#import "XLTGoodsDisplayHelp.h"
#import "XLTAppPlatformManager.h"
#import "XLDGoodsImageCollectionViewCell.h"
#import "XLDGoodsTextCollectionViewCell.h"
#import "NSString+Size.h"
#import "XLDGoodsDetailVideoView.h"
#import "XLDGoodsNoneDetailHeaderView.h"
#import "XLTBGCollectionViewFlowLayout.h"
#import "XLTGoodsDetailSukPopVC.h"
#import "XLTGoodsDetailMediaVC.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "XLDGoodsDetailSoldOutFooterView.h"
#import "XLTMallGoodsDetailFooter.h"
#import "XLTMallGoodsDetailCustomBar.h"
#import "XLTMallGoodsDetailLogic.h"
#import "XLTUserManager.h"
#import "XLTMallGoodsDetailPledgeCell.h"
#import "XLTMallGoodsDetailInfoCell.h"
#import "XLTMallGoodsDetailEmptyVC.h"
#import "XLTMallGoodsDetailPledgePopVC.h"
#import "XLTMallPledgeTextCell.h"
#import "XLTMallMakeOrderVC.h"

typedef NS_ENUM(NSInteger, XLTMallGoodsDetailSectionType) {
    XLTMallGoodsDetailSectionType_GoodsInfo = 0,
    XLTMallGoodsDetailSectionType_Pledge,
    XLTMallGoodsDetailSectionType_Detail,
};

@interface XLTMallGoodsDetailVC () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource,SDCycleScrollViewDelegate, XLDGoodsImageCollectionViewCellDelegate, JPVideoPlayerDelegate, XLTBGCollectionViewDelegateFlowLayout, XLTGoodsDetailMediaVCDelegate>

@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) XLTBaseModel *letaoGoodsDetailModel;

@property (nonatomic, strong) NSMutableArray *letaoPageDataArray;

@property (nonatomic, strong) SDCycleScrollView *letaoCycleScrollView;
@property (nonatomic, assign) NSUInteger letaoCurrentCycleIndex;

@property (nonatomic, strong) XLDGoodsDetailVideoView *letaoDetailVideoView;
@property (nonatomic, assign) JPVideoPlayerStatus letaoCurrentVideoPlayerStatus;

@property (nonatomic, strong) UIButton *letaoVideoBtn;
@property (nonatomic, strong) UIButton *letaoImageBtn;
@property (nonatomic, strong) UILabel *letaoCurrentCycleIndexLabel;
@property (nonatomic, strong) XLTMallGoodsDetailCustomBar *letaoTopHeader;

@property (nonatomic, strong) MJRefreshAutoNormalFooter *letaoRefreshAutoFooter;
@property (nonatomic, strong) MJRefreshNormalHeader *letaoRefreshHeader;

@property (nonatomic, strong) XLTMallGoodsDetailFooter *letaoBottomFooter;


@property (nonatomic, strong) XLDGoodsDetailSoldOutFooterView *letaoDisableBottomFooterView;
@property (nonatomic, copy) NSString *letaoTKLPasteboardText;


@property (nonatomic, strong) UITapGestureRecognizer *letaoPopGestureRecognizer;
@property (nonatomic, copy) NSString *letaoGoodsItemSource;
@property (nonatomic, copy) NSString *letaoGoodsItemId;
@end

@implementation XLTMallGoodsDetailVC


- (void)dealloc {
    [self.letaoDetailVideoView jp_stopPlay];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.letaoPageDataArray = [NSMutableArray array];
        for (int k =0; k <= XLTMallGoodsDetailSectionType_Detail; k ++){
            [self.letaoPageDataArray addObject:@[].mutableCopy];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoLoginSuccessNotification) name:kXLTNotifiLoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoLogoutSuccessNotification) name:kXLTNotifiLogoutSuccess object:nil];
    }
    return self;
}


- (void)letaoLoginSuccessNotification {
    [self letaoFetchGoodsDetailDataWithLoading:NO];
}

- (void)letaoLogoutSuccessNotification {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self letaoSetupContentCollectionView];
    [self setupBottomFooterView];
    [self letaoFetchGoodsDetailDataWithLoading:YES];
    [self letaoAdjustTopHeader];

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

- (void)letaoPopBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)letaoSetupRefreshAutoFooter {
    if (_letaoRefreshAutoFooter == nil) {
        _letaoRefreshAutoFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        }];
        _letaoRefreshAutoFooter.triggerAutomaticallyRefreshPercent = - 5.0;
        _letaoRefreshAutoFooter.autoTriggerTimes = -1;
        [_letaoRefreshAutoFooter setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
        _letaoRefreshAutoFooter.stateLabel.textColor = [UIColor colorWithHex:0xFFa9a9a9];
        _letaoRefreshAutoFooter.stateLabel.font = [UIFont letaoRegularFontWithSize:12.0];
    }
}

- (void)letaoSetupRefreshHeader {
    if (_letaoRefreshHeader == nil) {
        __weak __typeof(self)weakSelf = self;
        _letaoRefreshHeader =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf letaoFetchGoodsDetailDataWithLoading:NO];
        }];
    }
}

- (void)setupBottomFooterView {
    if (self.letaoBottomFooter == nil) {
       self.letaoBottomFooter = [[NSBundle mainBundle]loadNibNamed:@"XLTMallGoodsDetailFooter" owner:self options:nil].lastObject;
        [self.view addSubview:self.letaoBottomFooter];
        [self.letaoBottomFooter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
        }];
        
        [self.letaoBottomFooter.letaoBuyBtn addTarget:self action:@selector(letaoBuyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
        self.letaoBottomFooter.hidden = YES;
    }
}

- (void)letaoSetupDisableBottomView {
    if (self.letaoDisableBottomFooterView == nil) {
       self.letaoDisableBottomFooterView = [[NSBundle mainBundle] loadNibNamed:@"XLDGoodsDetailSoldOutFooterView" owner:self options:nil].lastObject;
        [self.view addSubview:self.letaoDisableBottomFooterView];
        [self.letaoDisableBottomFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
        }];
        
        [self.letaoDisableBottomFooterView.letaoHomeBtn addTarget:self action:@selector(letaoPopRoot) forControlEvents:UIControlEventTouchUpInside];
    }
}

#define kTopOffset 44
- (void)letaoAdjustTopHeader {
    if (self.letaoTopHeader == nil) {
        self.letaoTopHeader = [[XLTMallGoodsDetailCustomBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kSafeAreaInsetsTop)];
        [self.letaoTopHeader.letaoLeftButton addTarget:self action:@selector(letaoPopBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [self.view addSubview:self.letaoTopHeader];
    CGPoint offset = self.collectionView.contentOffset;
    [self.letaoTopHeader letaoAdjustMenuStyleWithOffset:offset];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGFloat safeAreaInsetsBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeAreaInsetsBottom = self.view.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    safeAreaInsetsBottom = safeAreaInsetsBottom + 49 + 40;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, safeAreaInsetsBottom, 0);
}

- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor whiteColor];
    [super letaoShowLoading];
    [self letaoAdjustTopHeader];
}


- (void)letaoSetupContentCollectionView {
    XLTBGCollectionViewFlowLayout *flowLayout = [[XLTBGCollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = self.view.backgroundColor;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;

    [self letaoSetupRefreshHeader];
    _collectionView.mj_header = _letaoRefreshHeader;
    
    [self letaoSetupRefreshAutoFooter];
    [_letaoRefreshAutoFooter endRefreshingWithNoMoreData];
    _collectionView.mj_footer = _letaoRefreshAutoFooter;
    [self letaoListRegisterCellsForCollectionView:_collectionView];
    _collectionView.hidden = YES;
    [self.view addSubview:_collectionView];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

//GoodsInfo
static NSString *const kXLTMallGoodsDetailInfoCell = @"XLTMallGoodsDetailInfoCell";
// 保障
static NSString *const kXLTMallGoodsDetailPledgeCell = @"XLTMallGoodsDetailPledgeCell";

// 详情图片
static NSString *const kXLDGoodsImageCollectionViewCell = @"XLDGoodsImageCollectionViewCell";
// 详情文字
static NSString *const kXLDGoodsTextCollectionViewCell = @"XLDGoodsTextCollectionViewCell";


- (void)letaoListRegisterCellsForCollectionView:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:kXLTMallGoodsDetailInfoCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTMallGoodsDetailInfoCell];
    
    [collectionView registerNib:[UINib nibWithNibName:kXLTMallGoodsDetailPledgeCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTMallGoodsDetailPledgeCell];
   
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsNoneDetailHeaderView bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLDGoodsNoneDetailHeaderView];

    // 详情图片
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsImageCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsImageCollectionViewCell];
    // 详情文字
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsTextCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsTextCollectionViewCell];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFooter"];

  
}


- (NSString *)letaoGoodsSourceParameters {

    
    return  nil;
}

- (void)letaoFetchGoodsDetailDataWithLoading:(BOOL)show {
    if (show) {
        [self letaoShowLoading];
    }
    __weak typeof(self)weakSelf = self;
    [XLTMallGoodsDetailLogic fetchGoodsDetailWithGoodsId:self.mallGoodsId success:^(XLTBaseModel * _Nonnull goodsDetail) {
        BOOL letaoIsValidGoods = [weakSelf letaoIsValidGoods:goodsDetail];
        if (letaoIsValidGoods) {
            weakSelf.letaoBottomFooter.hidden = NO;
            weakSelf.letaoDisableBottomFooterView.hidden = YES;
            weakSelf.letaoGoodsDetailModel = goodsDetail;
            [weakSelf letaoUpdateGoodsSectionData];
            weakSelf.collectionView.hidden = NO;
        } else {
            [self letaoShowInValidGoodsVC];
        }
        [weakSelf letaoRemoveLoading];
        [weakSelf.letaoRefreshHeader endRefreshing];
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf showTipMessage:errorMsg];
        [weakSelf letaoRemoveLoading];
        [weakSelf.letaoRefreshHeader endRefreshing];
        if (weakSelf.letaoGoodsDetailModel == nil) {
            weakSelf.collectionView.hidden = YES;
            weakSelf.letaoBottomFooter.hidden = YES;
            [weakSelf letaoShowErrorView];
        }
    }];
}


//status 1上架0下架
- (BOOL)letaoIsValidGoods:(XLTBaseModel * _Nonnull) goodsDetail {
    NSDictionary *goodsInfo = goodsDetail.data;
    if ([goodsInfo isKindOfClass:[NSDictionary class]]
        && goodsInfo.count > 0) {
        return YES;
    }
    return NO;
}

- (void)letaoShowInValidGoodsVC {
    XLTMallGoodsDetailEmptyVC *letaoEmptyCoverViewController = [[XLTMallGoodsDetailEmptyVC alloc] init];
    NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
    [array removeObject:self];
    [array addObject:letaoEmptyCoverViewController];
    [self.navigationController setViewControllers:array];
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
            [weakSelf letaoFetchGoodsDetailDataWithLoading:YES];
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
    [self letaoAdjustTopHeader];
}

- (void)letaoRemoveErrorView {
    [self.letaoErrorView removeFromSuperview];
}

#pragma mark -  UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return XLTMallGoodsDetailSectionType_Detail +1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *sectionArray = self.letaoPageDataArray[section];
    if ([sectionArray isKindOfClass:[NSArray class]]) {
       return sectionArray.count;
    } else {
       return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == XLTMallGoodsDetailSectionType_GoodsInfo) {
        XLTMallGoodsDetailInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTMallGoodsDetailInfoCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray]];
        NSArray *sectionArray = self.letaoPageDataArray[indexPath.section];
        NSArray *imageURLStringsGroup = [self letaoImagesArrayForSection:sectionArray.firstObject];
        if (self.letaoCycleScrollView == nil) {
            self.letaoCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreen_iPhone375Scale(375)) delegate:self placeholderImage:kPlaceholderLargeImage];
            self.letaoCycleScrollView.infiniteLoop = NO;
            self.letaoCycleScrollView.autoScroll = NO;
            self.letaoCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
            self.letaoCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
            // 设置视频和图片
            [self letaoSetupCycleScrollIndicator:imageURLStringsGroup];
         }
        self.letaoCycleScrollView.imageURLStringsGroup = imageURLStringsGroup;
        [cell.letaoCycleBgView addSubview:self.letaoCycleScrollView];
        NSArray *letaoVideoUrlArray = [self letaoVideoUrlArray];
        BOOL haveVideo = (letaoVideoUrlArray.count > 0);
        if (haveVideo) {
            if (self.letaoCurrentVideoPlayerStatus != JPVideoPlayerStatusStop
                && self.letaoCurrentVideoPlayerStatus != JPVideoPlayerStatusUnknown) {
                [self letaoRemoveVideoBtn];
            } else {
                [self letaoShowVideoBtn];
            }
        }

        return cell;
    } else if(indexPath.section == XLTMallGoodsDetailSectionType_Pledge) {
        XLTMallGoodsDetailPledgeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTMallGoodsDetailPledgeCell forIndexPath:indexPath];
        return cell;
    } else {
        XLDGoodsDetailCollectionViewCellDisplayModel *model = (XLDGoodsDetailCollectionViewCellDisplayModel *)[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
        if ([model isKindOfClass:[XLDGoodsDetailCollectionViewCellDisplayModel class]]
            && model.isImageType) {
            XLDGoodsImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsImageCollectionViewCell forIndexPath:indexPath];
            cell.delegate = self;
            [cell letaoUpdateCellDataWithInfo:model];
            return cell;
        } else {
            XLDGoodsTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsTextCollectionViewCell forIndexPath:indexPath];
            [cell letaoUpdateCellDataWithInfo:model];
            return cell;
        }
    }
    return [UICollectionViewCell new];
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == XLTMallGoodsDetailSectionType_GoodsInfo) {
        NSString *titleString = nil;
        NSDictionary *itemInfo = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
        if ([itemInfo isKindOfClass:[NSDictionary class]]) {
            titleString = itemInfo[@"title"];
        }
        if (![titleString isKindOfClass:[NSString class]]) {
            titleString = @"";
        }
        CGFloat titleHeigt = ceilf([titleString sizeWithFont:[UIFont letaoMediumBoldFontWithSize:17.0] maxSize:CGSizeMake(kScreenWidth -20, 48)].height);
        return CGSizeMake(collectionView.bounds.size.width, kScreen_iPhone375Scale(375) + 58 + titleHeigt);
    } else if(indexPath.section == XLTMallGoodsDetailSectionType_Pledge) {
        return CGSizeMake(collectionView.bounds.size.width, 78);
    } else if(indexPath.section == XLTMallGoodsDetailSectionType_Detail) {
        XLDGoodsDetailCollectionViewCellDisplayModel *model = (XLDGoodsDetailCollectionViewCellDisplayModel *)[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
        if ([model isKindOfClass:[XLDGoodsDetailCollectionViewCellDisplayModel class]]) {
            return CGSizeMake(collectionView.bounds.size.width, model.height);
        }
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == XLTMallGoodsDetailSectionType_GoodsInfo
        || section == XLTMallGoodsDetailSectionType_Pledge) {
        return UIEdgeInsetsMake(0, 0, 10, 0);
    } else {
        return UIEdgeInsetsZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == XLTMallGoodsDetailSectionType_Detail) {
        return CGSizeMake(collectionView.bounds.size.width, 50 );
    }
   return CGSizeZero;
}

 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == XLTMallGoodsDetailSectionType_Detail) {
         if (kind == UICollectionElementKindSectionHeader) {
             XLDGoodsNoneDetailHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLDGoodsNoneDetailHeaderView forIndexPath:indexPath];
             headerView.backgroundColor = [UIColor whiteColor];
             NSArray *sectionArray = self.letaoPageDataArray[indexPath.section];
             if ([sectionArray isKindOfClass:[NSArray class]] &&  sectionArray.count > 0) {
                 headerView.letaoEmptyTextLabel.text = @"商品详情";
             } else {
                 headerView.letaoEmptyTextLabel.text = @"商品暂无详情";
             }
             return headerView;
         }
     }
     return [UICollectionReusableView new];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == XLTMallGoodsDetailSectionType_Pledge) {
        XLTMallGoodsDetailPledgePopVC *sukViewController = [[XLTMallGoodsDetailPledgePopVC alloc] initWithNibName:@"XLTMallGoodsDetailPledgePopVC" bundle:[NSBundle mainBundle]];
        NSString *title = @"产品保障";
        sukViewController.letaoTitleText = title;
        [self letaoPresentSukVC:sukViewController];
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self letaoAdjustTopHeader];
}

#pragma mark - JHCollectionViewDelegateFlowLayout
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section {
    return self.collectionView.backgroundColor;
}

- (NSDictionary *)letaoSafeDataAtIndexPath:(NSIndexPath *)indexPath
                            letaoPageDataArray:(NSArray *)letaoPageDataArray {
    if ([letaoPageDataArray isKindOfClass:[NSArray class]]) {
        if (indexPath.section < letaoPageDataArray.count) {
            NSArray *sectionArray = letaoPageDataArray[indexPath.section];
            if ([sectionArray isKindOfClass:[NSArray class]]) {
                if (indexPath.row < sectionArray.count) {
                    return sectionArray[indexPath.row];
                }
            }
        }
    }
    return nil;
}



#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)letaoCycleScrollView didSelectItemAtIndex:(NSInteger)index {
    [self letaoPresentVideoVC:index];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)letaoCycleScrollView didScrollToIndex:(NSInteger)index {
    if (self.letaoCurrentCycleIndex != index) {
        self.letaoCurrentCycleIndex = index;
        NSArray *letaoVideoUrlArray = [self letaoVideoUrlArray];
        BOOL haveVideo = (letaoVideoUrlArray.count > 0);
        if (haveVideo && index == 0) {
            // 播放视频
            if (self.letaoCurrentVideoPlayerStatus == JPVideoPlayerStatusPause) {
                [self.letaoDetailVideoView jp_resume];
            }
        } else {
            if (haveVideo) {
                if (self.letaoCurrentVideoPlayerStatus == JPVideoPlayerStatusPlaying) {
                    [self.letaoDetailVideoView jp_pause];
                }
            }
        }
        self.letaoVideoBtn.selected = (haveVideo && index < letaoVideoUrlArray.count);
        self.letaoImageBtn.selected = (index >= letaoVideoUrlArray.count);
        if (self.letaoCycleScrollView.imageURLStringsGroup.count >0) {
            self.letaoCurrentCycleIndexLabel.hidden = self.letaoVideoBtn.selected;
            NSInteger pageIndex = haveVideo? index:index+1;
            self.letaoCurrentCycleIndexLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)pageIndex,(unsigned long)(self.letaoCycleScrollView.imageURLStringsGroup.count - [self letaoVideoUrlArray].count)];
        } else {
            self.letaoCurrentCycleIndexLabel.hidden = YES;
        }
    }
}


- (void)letaoSetupCycleScrollIndicator:(NSArray *)imageURLStringsGroup {
    NSNumber *width = @45;
    NSNumber *height = @20;
    NSArray *letaoVideoUrlArray = [self letaoVideoUrlArray];
    BOOL haveVideo = (letaoVideoUrlArray.count > 0);
    if (haveVideo && imageURLStringsGroup.count > 1) {
        NSNumber *space = @10;
        if (self.letaoVideoBtn == nil) {
            NSNumber *left = [NSNumber numberWithFloat:ceilf((kScreenWidth - [space floatValue] - [width floatValue]*2)/2)];
            self.letaoVideoBtn = [UIButton new];
            self.letaoVideoBtn.layer.cornerRadius = 10.0;
            self.letaoVideoBtn.layer.masksToBounds = YES;
            [self.letaoVideoBtn setTitle:@"视频" forState:UIControlStateNormal];
            [self.letaoVideoBtn setBackgroundImage:[UIImage letaoimageWithColor:[UIColor letaomainColorSkinColor]] forState:UIControlStateSelected];
            self.letaoVideoBtn.selected = YES;
            [self.letaoVideoBtn setBackgroundImage:[UIImage letaoimageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [self.letaoVideoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [self.letaoVideoBtn setTitleColor:[UIColor colorWithHex:0xFF333333] forState:UIControlStateNormal];
            self.letaoVideoBtn.titleLabel.font = [UIFont letaoRegularFontWithSize:10.0];
            self.letaoVideoBtn.backgroundColor = [UIColor letaomainColorSkinColor];
            [self.letaoCycleScrollView addSubview:self.letaoVideoBtn];
            [self.letaoVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(width);
                make.height.height.equalTo(height);
                make.left.equalTo(left);
                make.bottom.mas_equalTo(self.letaoCycleScrollView.mas_bottom).offset(-15);
            }];
            [self.letaoVideoBtn addTarget:self action:@selector(letaoVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (self.letaoImageBtn == nil) {
            self.letaoImageBtn = [UIButton new];
            [self.letaoCycleScrollView addSubview:self.letaoImageBtn];
            self.letaoImageBtn.layer.cornerRadius = 10.0;
            self.letaoImageBtn.layer.masksToBounds = YES;
            [self.letaoImageBtn setTitle:@"图片" forState:UIControlStateNormal];
            [self.letaoImageBtn setBackgroundImage:[UIImage letaoimageWithColor:[UIColor letaomainColorSkinColor]] forState:UIControlStateSelected];
            [self.letaoImageBtn setBackgroundImage:[UIImage letaoimageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [self.letaoImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [self.letaoImageBtn setTitleColor:[UIColor colorWithHex:0xFF333333] forState:UIControlStateNormal];
            self.letaoImageBtn.titleLabel.font = [UIFont letaoRegularFontWithSize:10.0];
            self.letaoImageBtn.backgroundColor = [UIColor letaomainColorSkinColor];
            [self.letaoImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(width);
                make.height.height.equalTo(height);
                make.left.mas_equalTo(self.letaoVideoBtn.mas_right).offset([space floatValue]);
                make.bottom.mas_equalTo(self.letaoVideoBtn.mas_bottom);
            }];
            [self.letaoImageBtn addTarget:self action:@selector(letaoImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    // 设置
    if (imageURLStringsGroup.count > 1) {
        if (self.letaoCurrentCycleIndexLabel == nil) {
            self.letaoCurrentCycleIndexLabel = [UILabel new];
            [self.letaoCycleScrollView addSubview:self.letaoCurrentCycleIndexLabel];
            self.letaoCurrentCycleIndexLabel.textColor = [UIColor whiteColor];
            self.letaoCurrentCycleIndexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            self.letaoCurrentCycleIndexLabel.textAlignment = NSTextAlignmentCenter;
            self.letaoCurrentCycleIndexLabel.font = [UIFont letaoRegularFontWithSize:10.0];
            self.letaoCurrentCycleIndexLabel.layer.masksToBounds = YES;
            self.letaoCurrentCycleIndexLabel.layer.cornerRadius = 10;
            self.letaoCurrentCycleIndexLabel.adjustsFontSizeToFitWidth = YES;
            [self.letaoCurrentCycleIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@40);
                make.height.height.equalTo(@20);
                make.right.mas_equalTo(self.letaoCycleScrollView.mas_right).offset(-10);
                               make.bottom.mas_equalTo(self.letaoCycleScrollView.mas_bottom).offset(-15);
            }];
        }
        if (imageURLStringsGroup.count >0) {
             self.letaoCurrentCycleIndexLabel.hidden = self.letaoVideoBtn.selected;
            self.letaoCurrentCycleIndexLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)(imageURLStringsGroup.count - [self letaoVideoUrlArray].count)];
        } else {
            self.letaoCurrentCycleIndexLabel.hidden = YES;
        }
       
    }
}

- (void)letaoVideoButtonClicked:(UIButton *)sender {
    if (self.letaoCycleScrollView.imageURLStringsGroup.count > 0) {
        @try {
            UICollectionView *collectionView = [self.letaoCycleScrollView valueForKey:@"mainView"];
            if ([collectionView isKindOfClass:[UICollectionView class]]) {
                [collectionView addSubview:self.letaoDetailVideoView];
                [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    self.letaoVideoBtn.selected = YES;
    self.letaoImageBtn.selected = NO;
}

- (void)letaoImageButtonClicked:(id)sender {
    NSArray *letaoVideoUrlArray = [self letaoVideoUrlArray];
    BOOL haveVideo = (letaoVideoUrlArray.count > 0);
    if (haveVideo && self.letaoCycleScrollView.imageURLStringsGroup.count > 1) {
        @try {
            UICollectionView *collectionView = [self.letaoCycleScrollView valueForKey:@"mainView"];
            if ([collectionView isKindOfClass:[UICollectionView class]]) {
                [collectionView addSubview:self.letaoDetailVideoView];
                [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    self.letaoVideoBtn.selected = NO;
    self.letaoImageBtn.selected = YES;
}

#pragma mark - Parser DetailModel

- (void)letaoUpdateGoodsSectionData {
    if ([self.letaoGoodsDetailModel.data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *goodInfo = self.letaoGoodsDetailModel.data;
        [self.letaoPageDataArray replaceObjectAtIndex:XLTMallGoodsDetailSectionType_GoodsInfo withObject:@[goodInfo]];
        // 保障 暂时写死
        [self.letaoPageDataArray replaceObjectAtIndex:XLTMallGoodsDetailSectionType_Pledge withObject:@[[NSNull null]]];
        
        // 详情
        NSArray *content = goodInfo[@"detail"];
        if ([content isKindOfClass:[NSArray class]] && content.count > 0) {
            NSMutableArray *detailArray = [NSMutableArray array];
            [content enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSString class]]) {
                    XLDGoodsDetailCollectionViewCellDisplayModel *model = [XLDGoodsDetailCollectionViewCellDisplayModel new];
                    model.isImageType = [obj hasPrefix:@"//"] || [obj hasPrefix:@"http://"] || [obj hasPrefix:@"https://"];
                    if (model.isImageType) {
                        model.height = 80;
                        if ([obj hasPrefix:@"//"]) {
                            model.imageUrl = [@"http:" stringByAppendingString:obj];
                        } else {
                            model.imageUrl = obj;
                        }
                    } else {
                        CGFloat height = ceilf([obj sizeWithFont:[UIFont letaoRegularFontWithSize:13.0] maxSize:CGSizeMake(kScreenWidth -20, CGFLOAT_MAX)].height) + 20;
                        model.height = height;
                        model.text = obj;
                    }
                    [detailArray addObject:model];
                }
            }];
            if (detailArray.count > 0) {
                [self.letaoPageDataArray replaceObjectAtIndex:XLTMallGoodsDetailSectionType_Detail withObject:detailArray];
            }
        }
        
        // 底部菜单

        [self.collectionView reloadData];
    }
}


- (void)letaGoods:(XLDGoodsImageCollectionViewCell *)cell imageSizeChanged:(UIImage *)image imageSize:(CGSize)size {
    [self.collectionView reloadData];
}


- (NSArray *)letaoImagesArrayForSection:(NSDictionary *)itemInfo {
    NSArray *banner = itemInfo[@"banner"];
    if ([banner isKindOfClass:[NSArray class]]) {
        NSMutableArray *bannerArray = [NSMutableArray array];
        [banner enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                [bannerArray addObject:[obj letaoConvertToHttpsUrl]];
            } else {
                [bannerArray addObject:@""];
            }
        }];
        return banner;
    } else {
        return @[];
    }
}

#pragma mark -  视频
- (NSArray *)letaoVideoUrlArray {
    NSMutableArray *array = @[].mutableCopy;
    NSDictionary *goodInfo = self.letaoGoodsDetailModel.data;
    NSArray *item_video = goodInfo[@"item_video"];
    if ([item_video isKindOfClass:[NSArray class]]) {
        [item_video enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *videoUrlString = @"";
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *url = obj[@"url"];
                if ([url isKindOfClass:[NSString class]]) {
                    videoUrlString = url;
                }
            }
            [array addObject:videoUrlString];
        }];
    }
    return array;
}


- (void)letaoShowVideoBtn {
    if (self.letaoDetailVideoView == nil)  {
        self.letaoDetailVideoView = [[XLDGoodsDetailVideoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.letaoCycleScrollView.bounds.size.height)];
        [self.letaoDetailVideoView.letaoVideoPlayBtn addTarget:self action:@selector(letaoPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
        @try {
            UICollectionView *collectionView = [self.letaoCycleScrollView valueForKey:@"mainView"];
            if ([collectionView isKindOfClass:[UICollectionView class]]) {
                [collectionView addSubview:self.letaoDetailVideoView];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    self.letaoDetailVideoView.letaoVideoPlayBtn.hidden = NO;
    [self.letaoDetailVideoView bringSubviewToFront: self.letaoDetailVideoView.letaoVideoPlayBtn];

}

- (void)letaoRemoveVideoBtn {
     self.letaoDetailVideoView.letaoVideoPlayBtn.hidden = YES;
}


- (void)letaoPlayVideo:(UIButton *)videoPlayButton {
    [self letaoRemoveVideoBtn];
    NSArray *letaoVideoUrlArray = [self letaoVideoUrlArray];
    if (self.letaoCurrentCycleIndex < letaoVideoUrlArray.count) {
        UICollectionView *collectionView = [self.letaoCycleScrollView valueForKey:@"mainView"];
        if ([collectionView isKindOfClass:[UICollectionView class]]) {
            NSString *urlString =  letaoVideoUrlArray[self.letaoCurrentCycleIndex];
            NSURL *url = [NSURL URLWithString:urlString];
//                JPVideoPlayerCache *cache = [JPVideoPlayerCache sharedCache];
//            JPVideoPlayerDownloader *downloader = [JPVideoPlayerDownloader sharedDownloader];
//            @property (strong, nonatomic) JPVideoPlayerDownloader *videoDownloader;

            
            [self.letaoDetailVideoView jp_playVideoMuteWithURL:url bufferingIndicator:nil progressView:nil configuration:nil];
            [self.letaoDetailVideoView setJp_videoPlayerDelegate:self];

            self.letaoDetailVideoView.jp_progressView.tintColor = [UIColor letaomainColorSkinColor];

            if (self.letaoPopGestureRecognizer == nil) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(letaoTapGestureRecognizer)];
                tap.cancelsTouchesInView = NO;
                self.letaoPopGestureRecognizer = tap;
            }
            if (![[self.letaoDetailVideoView.jp_videoPlayerView.userInteractionContainerView gestureRecognizers] containsObject:self.letaoPopGestureRecognizer]) {
                [self.letaoDetailVideoView.jp_videoPlayerView.userInteractionContainerView addGestureRecognizer:self.letaoPopGestureRecognizer];
            }
        }
    }
}

- (void)letaoTapGestureRecognizer {
    [self letaoPresentVideoVC:0];
}

- (void)letaoPresentVideoVC:(NSUInteger)pageIndex {
    NSArray *letaoVideoUrlArray = [self letaoVideoUrlArray];
    NSString *urlString =  letaoVideoUrlArray.firstObject;
//    if (self.letaoCurrentCycleIndex < letaoVideoUrlArray.count) {
//        urlString =  letaoVideoUrlArray[self.letaoCurrentCycleIndex];
//    }
    XLTGoodsDetailMediaVC *videoViewController = [[XLTGoodsDetailMediaVC alloc] initWithNibName:@"XLTGoodsDetailMediaVC" bundle:[NSBundle mainBundle]];
    videoViewController.letaoVideoUrl = urlString;
    videoViewController.letaoVideoArray = letaoVideoUrlArray;
    videoViewController.letaoImageArray = [self.letaoCycleScrollView.imageURLStringsGroup copy];
    videoViewController.delegate = self;
    videoViewController.letaoFristIndex = pageIndex;
    videoViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:videoViewController animated:NO completion:nil];
}

#pragma mark -  XLTGoodsDetailMediaVCDelegate

- (void)letaoVideoVCWillBack:(XLTGoodsDetailMediaVC *)videoViewController playerStatus:(JPVideoPlayerStatus)playerStatus {
    
    NSArray *letaoVideoUrlArray = [self letaoVideoUrlArray];
    if (self.letaoCurrentCycleIndex < letaoVideoUrlArray.count) {
        NSString *urlString =  letaoVideoUrlArray[self.letaoCurrentCycleIndex];
        NSURL *url = [NSURL URLWithString:urlString];
        if (playerStatus == JPVideoPlayerStatusPlaying) {
            [self.letaoDetailVideoView jp_resumeMutePlayWithURL:url bufferingIndicator:nil progressView:nil configuration:nil];
        } else  {
            if (self.letaoCurrentVideoPlayerStatus != JPVideoPlayerStatusStop)
            {
                [self.letaoDetailVideoView jp_stopPlay];
              
            }
            [self letaoShowVideoBtn];
        }
    } else {
        [self.letaoDetailVideoView jp_stopPlay];
        [self letaoShowVideoBtn];
    }
}

#pragma mark -  JPVideoPlayerDelegate

- (void)playerStatusDidChanged:(JPVideoPlayerStatus)playerStatus {
    if (playerStatus != self.letaoCurrentVideoPlayerStatus) {
        self.letaoCurrentVideoPlayerStatus = playerStatus;
        if (playerStatus == JPVideoPlayerStatusFailed) {
            [self.letaoDetailVideoView jp_stopPlay];
        }
        if (self.letaoCurrentVideoPlayerStatus != JPVideoPlayerStatusStop) {
            [self letaoRemoveVideoBtn];
        } else {
            [self letaoShowVideoBtn];
            [self.letaoDetailVideoView jp_stopPlay];
        }
    }
}

- (BOOL)shouldAutoReplayForURL:(nonnull NSURL *)videoURL {
    return NO;
}

- (BOOL)shouldResumePlaybackWhenApplicationDidBecomeActiveFromBackgroundForURL:(NSURL *)videoURL {
    return NO;
}

#pragma mark -  弹窗

- (void)letaoPresentSukVC:(XLTMallGoodsDetailPledgePopVC *)viewController {
    
    viewController.view.hidden = YES;
    self.definesPresentationContext = YES;
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:viewController animated:NO completion:^{
        viewController.view.hidden = NO;
        viewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        viewController.letaoBgView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            viewController.letaoBgView.transform=CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
        }];
    }];
}


#pragma mark -  BottomFooter Button Action

- (void)letaoPopRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)letaoShowClearBgLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}

- (void)letaoBuyButtonClicked {
    XLTMallMakeOrderVC *makeOrderVC = [[XLTMallMakeOrderVC alloc] init];
    makeOrderVC.goodsInfo = self.letaoGoodsDetailModel.data;
    [self.navigationController pushViewController:makeOrderVC animated:YES];
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
