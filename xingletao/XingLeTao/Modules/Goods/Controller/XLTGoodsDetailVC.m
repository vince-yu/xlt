//
//  XLTGoodsDetailVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsDetailVC.h"
#import "XLTGoodsDetailLogic.h"
#import "XLTUserManager.h"
#import "LetaoEmptyCoverView.h"
#import "SDCycleScrollView.h"
#import "XLTGoodsDetailCellsFactory.h"
#import "XLDGoodsStoreRecomendHeaderView.h"
#import "XLTGoodsDisplayHelp.h"
#import "XLTAppPlatformManager.h"
#import "XLDGoodsImageCollectionViewCell.h"
#import "NSString+Size.h"
#import "XLDGoodsDetailVideoView.h"
#import "Masonry.h"
#import "UIImage+UIColor.h"
#import "XLDGoodsDetailTopMenuView.h"
#import "XLDGoodsNoneDetailHeaderView.h"
#import "MJRefreshAutoNormalFooter.h"
#import "XLTBGCollectionViewFlowLayout.h"
#import "XLTGoodsDetailSukPopVC.h"
#import "XLTGoodsDetailEmptyVC.h"
#import "XLDGoodsDetailFooterView.h"
#import "XLTJingDongManager.h"
#import "XLTAliManager.h"
#import "XLTGoodsDetailTaobaoWordsPopVC.h"
#import "XLTCollectLogic.h"
#import "XLTHomePageLogic.h"
#import "XLDGoodsStoreCollectionViewCell.h"
#import "XLTStoreContainerVC.h"
#import "XLDGoodsCouponCollectionViewCell.h"
#import "XLTGoodsDetailMediaVC.h"
#import "XLDGoodsEarnCollectionViewCell.h"
#import "XLTAlertViewController.h"
#import "MJRefreshNormalHeader.h"
#import "XLDGoodsDetailSoldOutFooterView.h"
#import "XLTGoodsEarnShareVC.h"
#import "XLTGoodsEarnShareImageView.h"
#import "UIView+XLTLoading.h"
#import "AppDelegate.h"
#import "XLDGoodsInfoMemberUpgradeCell.h"
#import "XLTVipVC.h"
#import "XLTPDDManager.h"
#import "XLTWPHManager.h"
#import "XLTTimeoutProgressView.h"
#import "XLTWKWebViewController.h"
#import "KSSDImageManager.h"
#import "KSPhotoBrowser.h"
#import "XLTGoodsDetailVC+RecommendFeed.h"
#import "XLDGoodsInfoTopImageCell.h"
#import "XLDGoodsInfoPriceCell.h"
#import "XLDGoodsInfoTitleTextCell.h"
#import "XLDGoodsInfoPrePaidDateCell.h"
#import "XLDGoodsInfoPrePaidDiscountCell.h"

@interface XLTGoodsDetailVC () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, SDCycleScrollViewDelegate, XLDGoodsImageCollectionViewCellDelegate, JPVideoPlayerDelegate, XLTBGCollectionViewDelegateFlowLayout, XLDGoodsStoreCollectionViewCellDelegate, XLDGoodsStoreRecomendHeaderViewDelegate, XLDGoodsCouponCollectionViewCellDelegate, XLTGoodsDetailMediaVCDelegate, XLDGoodsEarnCollectionViewCellDelegate, XLDGoodsInfoMemberUpgradeCellDelegate>
@property (nonatomic, strong) XLTGoodsDetailLogic *letaoGoodsDetailLogic;
@property (nonatomic, strong) XLTCollectLogic *letaoGoodsCollectLogic;


@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) XLTGoodsDetailCellsFactory *letaoCellFactory;


@property (nonatomic, strong) XLTBaseModel *letaoGoodsDetailModel;
@property (nonatomic, strong) XLTBaseModel *letaoGoodsDescModel;

@property (nonatomic, strong) NSMutableArray *letaoPageDataArray;

@property (nonatomic, strong) SDCycleScrollView *letaoCycleScrollView;
@property (nonatomic, assign) NSUInteger letaoCurrentCycleIndex;

@property (nonatomic, strong) XLDGoodsDetailVideoView *letaoDetailVideoView;
@property (nonatomic, assign) JPVideoPlayerStatus letaoCurrentVideoPlayerStatus;

@property (nonatomic, strong) UIButton *letaoVideoBtn;
@property (nonatomic, strong) UIButton *letaoImageBtn;
@property (nonatomic, strong) UILabel *letaoCurrentCycleIndexLabel;
@property (nonatomic, strong) XLDGoodsDetailTopMenuView *letaoTopHeader;

@property (nonatomic, strong) MJRefreshAutoNormalFooter *letaoRefreshAutoFooter;
@property (nonatomic, strong) MJRefreshNormalHeader *letaoRefreshHeader;

@property (nonatomic, strong) XLDGoodsDetailFooterView *letaoBottomFooter;
@property (nonatomic, strong) UIView *letaoBottomFooterTipView;
@property (nonatomic, strong) UILabel *letaoBottomPreCouponTipLabel;
@property (nonatomic, strong) UILabel *letaoBottomPrePaidTipLabel;
@property (nonatomic, strong) UILabel *letaoBottomFooterTipLabel;

@property (nonatomic, strong) XLDGoodsDetailSoldOutFooterView *letaoDisableBottomFooterView;
@property (nonatomic, copy) NSString *letaoTKLShareCode;
@property (nonatomic, copy) NSString *letaoTKLShareText;


@property (nonatomic, strong) UITapGestureRecognizer *letaoPopGestureRecognizer;

@property (nonatomic, copy) NSString *letaoGoodsItemSource;

@property (nonatomic, assign) BOOL isLetaoCollected;

// 推荐
@property (nonatomic, assign) XLTGoodsRecommendFeedStyle goodsRecommendFeedStyle;
@property (nonatomic, copy, nullable) NSString *goodsRecommendFeedTipText;


@property (nonatomic, assign) BOOL didTryRequestGoodsDesc;

@end

@implementation XLTGoodsDetailVC


- (void)dealloc {
    [self.letaoDetailVideoView jp_stopPlay];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.letaoPageDataArray = [NSMutableArray array];
        for (int k =0; k <= XLDGoodsDetailSectionType_GoodsRecomend; k ++){
            [self.letaoPageDataArray addObject:@[].mutableCopy];
        }
        self.goodsRecommendFeedStyle = XLTGoodsRecommendFeedStyle_Unknow;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoLoginSuccessNotification) name:kXLTNotifiLoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoLogoutSuccessNotification) name:kXLTNotifiLogoutSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoGoodsRecommedSuccessNotification) name:@"kGoodsRecommedSuccessNotification" object:nil];

    }
    return self;
}


- (void)letaoLoginSuccessNotification {
    [self letaoFetchGoodsDetailDataWithLoading:NO];
}

- (void)letaoLogoutSuccessNotification {
    [self letaoFetchGoodsDetailDataWithLoading:NO];
}

- (void)letaoGoodsRecommedSuccessNotification {
    self.goodsRecommendFeedStyle = XLTGoodsRecommendFeedStyle_Recommend;
    self.goodsRecommendFeedTipText = @"商品已推荐 请到[发圈]-[我的推荐]中查看管理";
    [self updateGoodsRecommendFeedButtonData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self letaoSetupContentCollectionView];
    [self setupBottomFooterView];
    [self letaoFetchGoodsDetailDataWithLoading:YES];
    [self letaoAdjustTopHeader];

    __weak __typeof(self)weakSelf = self;
    [self setXltBackToTopButtonCallback:^{
        [weakSelf.collectionView setContentOffset:CGPointZero animated:YES];
    }];
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
       self.letaoBottomFooter = [[NSBundle mainBundle]loadNibNamed:@"XLDGoodsDetailFooterView" owner:self options:nil].lastObject;
        [self.view addSubview:self.letaoBottomFooter];
        [self.letaoBottomFooter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
        }];
        
        [self.letaoBottomFooter.letaoHomeBtn addTarget:self action:@selector(letaoPopRoot) forControlEvents:UIControlEventTouchUpInside];
        [self.letaoBottomFooter.letaoCommandBtn addTarget:self action:@selector(letaoCommandBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.letaoBottomFooter.letaoBuyBtn addTarget:self action:@selector(letaoBuyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.letaoBottomFooter.letaoLimitBuyBtn addTarget:self action:@selector(letaoBuyButtonClicked) forControlEvents:UIControlEventTouchUpInside];

        [self.letaoBottomFooter.letaoShareBtn addTarget:self action:@selector(letaoBottomShareButtonClicked) forControlEvents:UIControlEventTouchUpInside];

        self.letaoBottomFooter.hidden = YES;
    }
}


- (NSString *)preCouponTimeFormatWithDate:(NSDate *)date {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH:mm:ss"];
    }
    if ([date isKindOfClass:[NSDate class]]) {
        NSString *dateString = [dateFormatter stringFromDate:date];
        return dateString;
    }
    return @"";

}

- (NSString *)prePaidEndTimeFormatWithDate:(NSDate *)date {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM.dd HH:mm"];
    }
    if ([date isKindOfClass:[NSDate class]]) {
        NSString *dateString = [dateFormatter stringFromDate:date];
        return dateString;
    }
    return @"";

}

- (BOOL)isLetaoHighCommissionGoods {
    NSDictionary *info = self.letaoGoodsDetailModel.data;
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSNumber *hight_rebate = info[@"hight_rebate"];
        if ([hight_rebate isKindOfClass:[NSString class]] || [hight_rebate isKindOfClass:[NSNumber class]]) {
            return [hight_rebate boolValue];
        }
    }
    
    return NO;
}

- (BOOL)isPrePaidGoods {
    if (![self isLetaoHighCommissionGoods]) {
        if ([self.letaoGoodsDetailModel.data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *goodInfo = self.letaoGoodsDetailModel.data;
            // 定金预售
            NSDictionary *presale = goodInfo[@"presale"];
            if ([presale isKindOfClass:[NSDictionary class]] && presale.count > 0) {
                NSNumber *start_time = presale[@"start_time"];
                NSNumber *end_time = presale[@"end_time"];
                NSNumber *tail_start_time = presale[@"tail_start_time"];
                NSNumber *tail_end_time = presale[@"tail_end_time"];
                if ([start_time isKindOfClass:[NSNumber class]] && [start_time longLongValue] > 0
                    && [end_time isKindOfClass:[NSNumber class]] && [end_time longLongValue] > 0
                    && [tail_start_time isKindOfClass:[NSNumber class]] && [tail_start_time longLongValue] > 0
                    && [tail_end_time isKindOfClass:[NSNumber class]] && [tail_end_time longLongValue] > 0) {
                    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
                    return (timeInterval > [start_time longLongValue] && timeInterval < [end_time longLongValue]);
                }
            }
        }
    }
    return NO;
}

- (void)setupBottomPreCouponTipViewForStartTime:(NSTimeInterval)startTime {
    if (self.letaoBottomPreCouponTipLabel == nil) {
        self.letaoBottomPreCouponTipLabel = [[UILabel alloc] init];
        [self.view addSubview:self.letaoBottomPreCouponTipLabel];
        self.letaoBottomPreCouponTipLabel.backgroundColor = [UIColor colorWithHex:0xFFE5FFE7];
        self.letaoBottomPreCouponTipLabel.font = [UIFont letaoMediumBoldFontWithSize:12];
        self.letaoBottomPreCouponTipLabel.textAlignment = NSTextAlignmentCenter;
        self.letaoBottomPreCouponTipLabel.textColor = [UIColor colorWithHex:0xFF20B766];
        [self.letaoBottomPreCouponTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view.mas_width);
            make.height.equalTo(@35);
            make.left.equalTo(@0);
            make.bottom.mas_equalTo(self.letaoBottomFooter.mas_top);
        }];
    }
    NSString *dateText = [self preCouponTimeFormatWithDate:[NSDate dateWithTimeIntervalSince1970:startTime]];
    self.letaoBottomPreCouponTipLabel.text = [NSString stringWithFormat:@"%@以后可用，请提前领券",dateText];
    self.letaoBottomPreCouponTipLabel.hidden = NO;
    self.letaoBottomPrePaidTipLabel.hidden = YES;
    self.letaoBottomFooterTipView.hidden = YES;
}

- (void)setupBottomPrepaidTipViewForEndTime:(NSTimeInterval)endTime {
    if (self.letaoBottomPrePaidTipLabel == nil) {
        self.letaoBottomPrePaidTipLabel = [[UILabel alloc] init];
        [self.view addSubview:self.letaoBottomPrePaidTipLabel];
        self.letaoBottomPrePaidTipLabel.backgroundColor = [UIColor colorWithHex:0xFFFDF1F3];
        self.letaoBottomPrePaidTipLabel.font = [UIFont letaoMediumBoldFontWithSize:12];
        self.letaoBottomPrePaidTipLabel.textAlignment = NSTextAlignmentCenter;
        self.letaoBottomPrePaidTipLabel.textColor = [UIColor colorWithHex:0xFFF34264];
        [self.letaoBottomPrePaidTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view.mas_width);
            make.height.equalTo(@35);
            make.left.equalTo(@0);
            make.bottom.mas_equalTo(self.letaoBottomFooter.mas_top);
        }];
    }
    NSString *dateText = [self prePaidEndTimeFormatWithDate:[NSDate dateWithTimeIntervalSince1970:endTime]];
    self.letaoBottomPrePaidTipLabel.text = [NSString stringWithFormat:@"%@ 付定金结束",dateText];
    self.letaoBottomPreCouponTipLabel.hidden = YES;
    self.letaoBottomPrePaidTipLabel.hidden = NO;
    self.letaoBottomFooterTipView.hidden = YES;
}


- (void)setupBottomViewWithCommission:(NSNumber * _Nullable)commission subsidy:(NSNumber * _Nullable)subsidy {
    if (self.letaoBottomFooterTipView == nil) {
        self.letaoBottomFooterTipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
     
        UIColor *mainColor = [self isLetaoHighCommissionGoods] ? [UIColor colorWithHex:0xFF7046E0]: [UIColor colorWithHex:0xFFF85555];
        
        UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.letaoBottomFooterTipView.bounds.size.width, 25)];
        topBgView.layer.masksToBounds = YES;
        topBgView.layer.cornerRadius = 2.0;
        topBgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        topBgView.backgroundColor = mainColor;
        [self.letaoBottomFooterTipView addSubview:topBgView];
        
        NSString *arrowImageName = [self isLetaoHighCommissionGoods] ? @"xinletao_goodsdetail_down_arrows_violet" : @"xinletao_goodsdetail_down_arrows";
        UIImageView *arrowsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:arrowImageName]];
        CGFloat x = ceil((self.letaoBottomFooterTipView.bounds.size.width - self.letaoBottomFooter.letaoBuyBtn.width/2));
        arrowsImageView.frame = CGRectMake(x, 30-5, 9, 5);
        arrowsImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.letaoBottomFooterTipView addSubview:arrowsImageView];
        
        self.letaoBottomFooterTipView.backgroundColor = [UIColor clearColor];
        self.letaoBottomFooterTipView.hidden = YES;
        self.letaoBottomFooterTipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.letaoBottomFooterTipLabel.font = [UIFont letaoMediumBoldFontWithSize:11];
        self.letaoBottomFooterTipLabel.textAlignment = NSTextAlignmentCenter;
        self.letaoBottomFooterTipLabel.textColor = [UIColor whiteColor];
        [self.letaoBottomFooterTipView addSubview:self.letaoBottomFooterTipLabel];
        self.letaoBottomFooterTipView.hidden = YES;
        [self.view addSubview:self.letaoBottomFooterTipView];
    }
    
    NSMutableString *letaoTipMessageLabelText = [[NSMutableString alloc] init];
//    if ([commission isKindOfClass:[NSNumber class]] && [commission intValue] > 0)
    {
        if ([self isLetaoHighCommissionGoods]) {
            [letaoTipMessageLabelText appendString:@"平台返利￥"];
        } else {
            [letaoTipMessageLabelText appendString:@"返利￥"];
        }
        [letaoTipMessageLabelText appendString:[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:commission]];
    }
    if (![subsidy isKindOfClass:[NSNumber class]]) {
        subsidy = @0;
    }
//    if ([subsidy isKindOfClass:[NSNumber class]] && [subsidy intValue] > 0)
    {
        if ([letaoTipMessageLabelText length] > 0) {
            [letaoTipMessageLabelText appendString:@" + "];
        }
        if ([self isLetaoHighCommissionGoods]) {
            [letaoTipMessageLabelText appendString:@"奖励￥"];
        } else {
            [letaoTipMessageLabelText appendString:@"平台补贴￥"];
        }
        
        [letaoTipMessageLabelText appendString:[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:subsidy]];
    }
    if ([letaoTipMessageLabelText length] > 0
        && (([subsidy isKindOfClass:[NSNumber class]] && [subsidy intValue] > 0)
        || ([commission isKindOfClass:[NSNumber class]] && [commission intValue] > 0))) {
        self.letaoBottomFooterTipLabel.text = letaoTipMessageLabelText;
        CGFloat width = MIN(ceilf([letaoTipMessageLabelText sizeWithFont:self.letaoBottomFooterTipLabel.font maxSize:CGSizeMake(CGFLOAT_MAX, 21)].width +20), kScreenWidth - 20);
        self.letaoBottomFooterTipView.frame = CGRectMake(kScreenWidth - width -10,self.letaoBottomFooter.frame.origin.y - 35, width, 30);
        self.letaoBottomFooterTipLabel.frame = CGRectMake(0,0, width, 30 - 5);
         self.letaoBottomFooterTipView.hidden = NO;
    } else {
         self.letaoBottomFooterTipView.hidden = YES;
    }
    
    self.letaoBottomPreCouponTipLabel.hidden = YES;
    self.letaoBottomPrePaidTipLabel.hidden = YES;
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
        self.letaoTopHeader = [[XLDGoodsDetailTopMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kSafeAreaInsetsTop)];
//        [self.letaoTopHeader.letaoSegmentedControl addTarget:self action:@selector(letaoSegmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.letaoTopHeader.letaoLeftButton addTarget:self action:@selector(letaoPopBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.letaoTopHeader.letaoCollectButton addTarget:self action:@selector(letaoCollectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.letaoTopHeader.recommendFeedButton addTarget:self action:@selector(recommendFeedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:self.letaoTopHeader];
    CGPoint offset = self.collectionView.contentOffset;
    [self.letaoTopHeader letaoAdjustMenuStyleWithOffset:offset];
}

- (void)letaoSegmentedValueChanged:(HMSegmentedControl *)segmentedControl {
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        NSIndexPath *fristIndexPath = [NSIndexPath indexPathForItem:0 inSection:XLDGoodsDetailSectionType_Detail];
        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:fristIndexPath];
        if (attributes) {
            CGRect rect = attributes.frame;
            [self.collectionView setContentOffset:CGPointMake(0, rect.origin.y  - kSafeAreaInsetsTop) animated:YES];
        } else {
             UICollectionViewLayoutAttributes *headeraAttributes = [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:XLDGoodsDetailSectionType_Detail]];
            if (headeraAttributes) {
                CGRect rect = headeraAttributes.frame;
                [self.collectionView setContentOffset:CGPointMake(0, rect.origin.y - kSafeAreaInsetsTop) animated:YES];
            }
        }
    } else {
        UICollectionViewLayoutAttributes *headeraAttributes = [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:XLDGoodsDetailSectionType_GoodsRecomend]];
        if (headeraAttributes) {
            CGRect rect = headeraAttributes.frame;
            [self.collectionView setContentOffset:CGPointMake(0, rect.origin.y - kSafeAreaInsetsTop) animated:NO];
        }
    }
}

- (BOOL)letaoIsStoreInfoValid {
    NSArray *storeArray = self.letaoPageDataArray[XLDGoodsDetailSectionType_Store];
    NSArray *recomendArray = self.letaoPageDataArray[XLDGoodsDetailSectionType_StoreRecomend];
    if (storeArray.count >0 && recomendArray.count >0) {
        NSDictionary *storeInfo = storeArray.firstObject;
        if ([storeInfo isKindOfClass:[NSDictionary class]]) {
            NSString *seller_shop_id = storeInfo[@"seller_shop_id"];
            NSString *seller_shop_name = storeInfo[@"seller_shop_name"];
            NSString *seller_shop_icon = storeInfo[@"seller_shop_icon"];
            BOOL evaluatesValid = [XLDGoodsStoreCollectionViewCell letaoEvaluatesValid:storeInfo];
            return ([seller_shop_id isKindOfClass:[NSString class]] && seller_shop_id.length
                    && [seller_shop_name isKindOfClass:[NSString class]] && seller_shop_name.length
                    && [seller_shop_icon isKindOfClass:[NSString class]] && seller_shop_icon.length
                    && evaluatesValid);

        }
    }
    return NO;
}

- (BOOL)letaoIsGoodsDetailVisible {
    CGFloat offset = 0;
    NSIndexPath *fristIndexPath = [NSIndexPath indexPathForItem:0 inSection:XLDGoodsDetailSectionType_Detail];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:fristIndexPath];
    if (attributes) {
        CGRect rect = attributes.frame;
        offset = rect.origin.y  - kSafeAreaInsetsTop;
    } else {
         UICollectionViewLayoutAttributes *headeraAttributes = [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:XLDGoodsDetailSectionType_Detail]];
        if (headeraAttributes) {
            CGRect rect = headeraAttributes.frame;
             offset = rect.origin.y - kSafeAreaInsetsTop;
        }
    }
    return self.collectionView.contentOffset.y >= offset;
}

- (BOOL)letaoIsRecomendGoodsVisible {
    CGFloat offset = 0;
    UICollectionViewLayoutAttributes *headeraAttributes = [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:XLDGoodsDetailSectionType_GoodsRecomend]];
    if (headeraAttributes) {
        CGRect rect = headeraAttributes.frame;
        offset = rect.origin.y - kSafeAreaInsetsTop;
    }
    return self.collectionView.contentOffset.y >= offset;
}

- (BOOL)letaoIsRecomendGoodsDisplay {
    CGFloat offset = 0;
    UICollectionViewLayoutAttributes *headeraAttributes = [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:XLDGoodsDetailSectionType_GoodsRecomend]];
    if (headeraAttributes) {
        CGRect rect = headeraAttributes.frame;
        offset = rect.origin.y - kScreenHeight -49- kSafeAreaInsetsTop;
    }
    return self.collectionView.contentOffset.y >= offset;
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
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 显示最多三个详情 清理以前的views
        NSMutableArray *viewControllers =  self.navigationController.viewControllers.mutableCopy;
        __block NSUInteger goodDetailCount = 0;
        [[[self.navigationController.viewControllers reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isMemberOfClass:[XLTGoodsDetailVC class]]) {
                goodDetailCount ++;
                if (goodDetailCount > 3) {
                    [viewControllers removeObject:obj];
                }
            }

        }];
        if (self.navigationController.viewControllers.count != viewControllers.count) {
            [self.navigationController setViewControllers:viewControllers];
        }
    });
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
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"kEmptyFooter"];
    [_collectionView registerNib:[UINib nibWithNibName:kXLDGoodsStoreRecomendHeaderView bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLDGoodsStoreRecomendHeaderView];
    [self letaoSetupRefreshHeader];
    _collectionView.mj_header = _letaoRefreshHeader;
    
    [self letaoSetupRefreshAutoFooter];
    [_letaoRefreshAutoFooter endRefreshingWithNoMoreData];
    _letaoRefreshAutoFooter.hidden = YES;
    _collectionView.mj_footer = _letaoRefreshAutoFooter;
    [self.letaoCellFactory letaoListRegisterCellsForCollectionView:_collectionView];;
    [self.view addSubview:_collectionView];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (NSString *)letaoGoodsSourceParameters {
    if (self.letaoGoodsItemSource) {
        return self.letaoGoodsItemSource;
    } else {
        return self.letaoGoodsSource;
    }
}

- (NSTimeInterval)letaoGoodsDetailTimeoutInterval {
    if ([self letaoIsPassDetailInfoValid]) {
        return 10.0;
    } else {
        return 30.0;
    }
}

- (BOOL)letaoIsPassDetailInfoValid {
    if ([self.letaoPassDetailInfo isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}



- (void)letaoFetchGoodsDetailDataWithLoading:(BOOL)show {
    self.didTryRequestGoodsDesc = NO;
    if (show) {
        [self letaoShowLoading];
    }
    if (self.letaoGoodsDetailLogic == nil) {
        self.letaoGoodsDetailLogic = [[XLTGoodsDetailLogic alloc] init];
    }

    __weak typeof(self)weakSelf = self;
     // 请求商品详情第一部分数据，失败后使用passDetailInfo数据
    [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsDetailDataWithPlate:nil category:nil letaoGoodsId:self.letaoGoodsId
                                                                              item_id:self.letaoGoodsItemId
                                                                              user_id:[XLTUserManager shareManager].curUserInfo._id
                                                                           itemSource:[self letaoGoodsSourceParameters]
                                                                    timeoutInterval:[self letaoGoodsDetailTimeoutInterval]
                                                                              success:^(XLTBaseModel * _Nonnull goodsDetail,NSURLSessionDataTask * task) {
        if ([goodsDetail.data isKindOfClass:[NSDictionary class]]
            || [weakSelf letaoIsPassDetailInfoValid]) {
            if ([goodsDetail.data isKindOfClass:[NSDictionary class]]) {
                //  更新letaoGoodsId，可能存在变化
                NSString *letaoGoodsId = goodsDetail.data[@"_id"];
                if ([letaoGoodsId isKindOfClass:[NSString class]] && letaoGoodsId.length > 0) {
                    weakSelf.letaoGoodsId = letaoGoodsId;
                }
            } else {
                // bulid detailModel with self.passDetailInfo
                goodsDetail = [weakSelf buildGoodsDetailForPassDetailInfo];
            }
            [weakSelf receivedGoodsDetailSuccess:goodsDetail];
        } else {
                // 显示空视图
            weakSelf.collectionView.hidden = YES;
            weakSelf.letaoBottomFooter.hidden = YES;
            [weakSelf letaoShowInValidGoodsVC];
            [weakSelf letaoRemoveLoading];
            [weakSelf.letaoRefreshHeader endRefreshing];
        }
        [weakSelf tryRequestGoodsDescDataAgain];

       } failure:^(NSString * _Nonnull errorMsg,NSURLSessionDataTask * task) {
           if ([weakSelf letaoIsPassDetailInfoValid]) {
               XLTBaseModel *goodsDetail = [self buildGoodsDetailForPassDetailInfo];
               [weakSelf receivedGoodsDetailSuccess:goodsDetail];
           } else {
               [weakSelf receivedGoodsDetailFailed:errorMsg];
           }
           [weakSelf tryRequestGoodsDescDataAgain];

    }];
    
    // 请求商品详情第二部分数据
    [self letaoFetchGoodsDescData];
}

- (void)letaoFetchGoodsDescData {
    if (self.letaoGoodsDetailLogic == nil) {
        self.letaoGoodsDetailLogic = [[XLTGoodsDetailLogic alloc] init];
    }
    __weak typeof(self)weakSelf = self;
    
    // 请求商品详情第二部分数据，需要等第一部分完成以后在刷新界面
    [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsDescDataWithPlate:nil
                                                                      category:nil
                                                                       goodsId:self.letaoGoodsId
                                                                       item_id:self.letaoGoodsItemId
                                                                       user_id:[XLTUserManager shareManager].curUserInfo._id
                                                                    itemSource:[self letaoGoodsSourceParameters]
                                                                       success:^(XLTBaseModel * _Nonnull goodsDetail,NSURLSessionDataTask * task) {
        weakSelf.letaoGoodsDescModel = goodsDetail;
        if (weakSelf.letaoGoodsDetailModel) {
            [weakSelf letaoUpdateGoodsDescInfoSection];
            [weakSelf.collectionView reloadData];
        }
        [weakSelf tryRequestGoodsDescDataAgain];

       } failure:^(NSString * _Nonnull errorMsg,NSURLSessionDataTask * task) {
           XLTBaseModel *goodsDetail = [XLTBaseModel new];
           goodsDetail.xlt_rcode = @0;
           goodsDetail.data = @{};
           weakSelf.letaoGoodsDescModel = goodsDetail;
           if (weakSelf.letaoGoodsDetailModel) {
               [weakSelf letaoUpdateGoodsDescInfoSection];
               [weakSelf.collectionView reloadData];
           }
           [weakSelf tryRequestGoodsDescDataAgain];

    }];
}


 // 请求收藏状态
- (void)requestGoodsCollectState {
     __weak typeof(self)weakSelf = self;
    
    if (self.letaoGoodsCollectLogic == nil) {
        self.letaoGoodsCollectLogic = [[XLTCollectLogic alloc] init];
    }
    [self.letaoGoodsCollectLogic xingletaonetwork_goodsIsCollectWithGoodsId:self.letaoGoodsId itemSource:[self letaoGoodsSourceParameters] success:^(NSDictionary * _Nonnull info,NSURLSessionDataTask * task) {
        NSNumber *is_fav = info[@"is_fav"];
        if ([is_fav isKindOfClass:[NSNumber class]]) {
            weakSelf.isLetaoCollected = [is_fav boolValue];
            [weakSelf.collectionView reloadData];
        }
    } failure:^(NSString * _Nonnull errorMsg,NSURLSessionDataTask * task) {
    }];
}

// 请求推荐信息
- (void)requestGoodsCanRecommendSate {
     __weak typeof(self)weakSelf = self;
    [self requestGoodsCanRecommend:self.letaoGoodsId itemSource:[self letaoGoodsSourceParameters] completion:^(XLTGoodsRecommendFeedStyle recommendFeedStyle,NSString * _Nullable tipText,NSString * _Nullable gId,BOOL show) {
        if ([gId isKindOfClass:[NSString class]] && [weakSelf.letaoGoodsId isKindOfClass:[NSString class]]
            && [weakSelf.letaoGoodsId isEqualToString:gId]) {
            weakSelf.goodsRecommendFeedStyle = recommendFeedStyle;
            weakSelf.goodsRecommendFeedTipText = tipText;
            [weakSelf updateGoodsRecommendFeedButtonData];
        }
    }];
}

- (void)updateGoodsRecommendFeedButtonData {
    if (self.letaoGoodsDetailModel && self.goodsRecommendFeedStyle != XLTGoodsRecommendFeedStyle_Unknow) {
        BOOL isValidGoodsStatus = [self letaoIsValidGoods:self.letaoGoodsDetailModel];
        if (isValidGoodsStatus) {
            self.letaoTopHeader.goodsRecommendFeedStyle = self.goodsRecommendFeedStyle;
            self.letaoTopHeader.goodsRecommendFeedTipText = self.goodsRecommendFeedTipText;
            [self letaoAdjustTopHeader];
        } else {
            // hidden 推荐
            self.letaoTopHeader.goodsRecommendFeedStyle = XLTGoodsRecommendFeedStyle_Hidden;
            self.letaoTopHeader.recommendFeedButton.hidden = YES;
        }
    }
}


- (XLTBaseModel *)buildGoodsDetailForPassDetailInfo {
    if ([self letaoIsPassDetailInfoValid]) {
        XLTBaseModel *goodsDetail  = [XLTBaseModel new];
        goodsDetail.data = [self.letaoPassDetailInfo mutableCopy];
        goodsDetail.xlt_rcode = @0;
        // 删除这个里面的item_image
        goodsDetail.data[@"item_image"] = nil;
        return goodsDetail;
    }
    return nil;
}

- (void)receivedGoodsDetailSuccess:(XLTBaseModel *)model {
    self.letaoGoodsDetailModel = model;
    [self letaoUpdateGoodsInfoDetailSection];
    [self letaoFetchStoreAndRecommendGoodsData];
    self.collectionView.hidden = NO;
    BOOL isValidGoodsStatus = [self letaoIsValidGoods:model];
    if (isValidGoodsStatus) {
        self.letaoBottomFooter.hidden = NO;
        self.letaoDisableBottomFooterView.hidden = YES;

    } else {
        [self letaoSetupDisableBottomView];
        self.letaoBottomFooter.hidden = YES;
        self.letaoDisableBottomFooterView.hidden = NO;
        // 删除优惠券
    }
    if (!isValidGoodsStatus) {
        self.letaoBottomFooterTipView.hidden = YES;
    }
    [self letaoRemoveLoading];
    [self.letaoRefreshHeader endRefreshing];
    
    // 更新DescGoodsDetail
    if (self.letaoGoodsDescModel != nil) {
        [self letaoUpdateGoodsDescInfoSection];
    }
    [self updateGoodsRecommendFeedButtonData];
    [self.collectionView reloadData];
    
    // 添加浏览历史
    [self letaoIsAddBrowsingHistory];
    // 请求推荐信息
    [self requestGoodsCanRecommendSate];
    // 请求收藏
    [self requestGoodsCollectState];
}

- (void)receivedGoodsDetailFailed:(NSString *)errorMsg {
    [self letaoRemoveLoading];
    [self showTipMessage:errorMsg];
    self.collectionView.hidden = YES;
    self.letaoBottomFooter.hidden = YES;
    [self letaoShowErrorView];
    [self.letaoRefreshHeader endRefreshing];
}


- (void)tryRequestGoodsDescDataAgain {
    if (self.didTryRequestGoodsDesc) {
        return;
    }
    // 商品详情请求完成以后，如果item_desc是空的需要再试一次
    if (XLDGoodsDetailSectionType_Detail < self.letaoPageDataArray.count) {
        NSArray *item_desc = self.letaoPageDataArray[XLDGoodsDetailSectionType_Detail];
        BOOL isEmptyItemDesc= !([item_desc isKindOfClass:[NSArray class]] &&  item_desc.count > 0);
        
        NSDictionary *detailInfo = self.letaoGoodsDetailModel.data;
        BOOL receivedGoodsDetail = ([detailInfo isKindOfClass:[NSDictionary class]] && detailInfo.count > 0);
        if (receivedGoodsDetail && isEmptyItemDesc) {
            [self requestGoodsDescDataAgain];
        }
    }
}

- (void)requestGoodsDescDataAgain {
    self.didTryRequestGoodsDesc = YES;
    // 请求商品详情第二部分数据，需要等第一部分完成以后在刷新界面
    __weak typeof(self)weakSelf = self;
    [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsDescDataWithPlate:nil
                                                                      category:nil
                                                                       goodsId:self.letaoGoodsId
                                                                       item_id:self.letaoGoodsItemId
                                                                       user_id:[XLTUserManager shareManager].curUserInfo._id
                                                                    itemSource:[self letaoGoodsSourceParameters]
                                                                       success:^(XLTBaseModel * _Nonnull goodsDetail,NSURLSessionDataTask * task) {
        weakSelf.letaoGoodsDescModel = goodsDetail;
        if (weakSelf.letaoGoodsDetailModel) {
            [weakSelf letaoUpdateGoodsDescInfoSection];
            [weakSelf.collectionView reloadData];
        }
       } failure:^(NSString * _Nonnull errorMsg,NSURLSessionDataTask * task) {
    }];
}

- (void)setLetaoGoodsItemSource:(NSString *)goodsSource {
    if (_letaoGoodsItemSource != goodsSource
        || !([goodsSource isKindOfClass:[NSString class]] && [_letaoGoodsItemSource isEqualToString:goodsSource])) {
        [[XLTRepoDataManager shareManager] repoGoodDetailPage:self.letaoParentPlateId childPlate:self.letaoCurrentPlateId goodId:self.letaoGoodsItemId model_type:self.letaoIsCustomPlate?@1:@0 item_source:goodsSource];

    }
    _letaoGoodsItemSource = goodsSource;

}

- (NSString *)letaoRecommendStoreId {
    if ([self.letaoStoreId isKindOfClass:[NSString class]] && self.letaoStoreId.length > 0) {
        return self.letaoStoreId;
    } else {
        if ([self.letaoGoodsDetailModel.data isKindOfClass:[NSDictionary class]]) {
            NSString *seller_shop_id = self.letaoGoodsDetailModel.data[@"seller_shop_id"];
            if ([seller_shop_id isKindOfClass:[NSString class]] && seller_shop_id.length > 0) {
                return seller_shop_id;
            }
        }
    }
    return nil;
}

- (void)letaoFetchStoreAndRecommendGoodsData {
    __weak typeof(self)weakSelf = self;
    if ([self letaoRecommendStoreId]) {
        // 店铺推荐商品
        
        [self.letaoGoodsDetailLogic xingletaonetwork_requestStoreRecommendGoodsDataWithStoreId:[self letaoRecommendStoreId]
                                                          letaoGoodsId:self.letaoGoodsId
                                                       itemSource:[self letaoGoodsSourceParameters]
                                                          success:^(NSArray * _Nonnull goodsArray) {
                [weakSelf letaoUpdateStoreRecommendGoodsSectionData:goodsArray];
            } failure:^(NSString * _Nonnull errorMsg) {
                // do nothing
        }];
    }
        
    //     推荐商品
    [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsRecommenDataWithGoodsId:self.letaoGoodsId itemSource:[self letaoGoodsSourceParameters] success:^(NSArray * _Nonnull goodsArray) {
            [weakSelf letaoUpdateRecommendGoodsSectionData:goodsArray];
        } failure:^(NSString * _Nonnull errorMsg) {
            // do nothing
    }];
}

- (void)letaoShowInValidGoodsVC {
    XLTGoodsDetailEmptyVC *letaoEmptyCoverViewController = [[XLTGoodsDetailEmptyVC alloc] init];
    letaoEmptyCoverViewController.taskInfo = self.taskInfo;
    NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
    [array removeObject:self];
    [array addObject:letaoEmptyCoverViewController];
    [self.navigationController setViewControllers:array];
}

//status 1上架0下架
- (BOOL)letaoIsValidGoods:(XLTBaseModel * _Nonnull) goodsDetail {
    NSDictionary *goodsInfo = goodsDetail.data;
    if ([goodsInfo isKindOfClass:[NSDictionary class]]
        && goodsInfo.count > 0) {
        NSNumber *status = goodsInfo[@"status"];
        return ([status isKindOfClass:[NSNumber class]] && [status integerValue] == 1);
    }
    return NO;
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
    return XLDGoodsDetailSectionType_GoodsRecomend +1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == XLDGoodsDetailSectionType_Store
        || section == XLDGoodsDetailSectionType_StoreRecomend) {
        if (![self letaoIsStoreInfoValid]) {
            return 0;
        }
    }
    NSArray *sectionArray = self.letaoPageDataArray[section];
    if ([sectionArray isKindOfClass:[NSArray class]]) {
       return sectionArray.count;
    } else {
       return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.letaoCellFactory collectionView:collectionView cellForItemAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
    if ([cell isKindOfClass:[XLDGoodsImageCollectionViewCell class]]) {
        XLDGoodsImageCollectionViewCell *detailCell = (XLDGoodsImageCollectionViewCell *)cell;
        detailCell.delegate = self;
    } else if ([cell isKindOfClass:[XLDGoodsStoreCollectionViewCell class]]) {
           XLDGoodsStoreCollectionViewCell *storeCell = (XLDGoodsStoreCollectionViewCell *)cell;
           storeCell.delegate = self;
    }  else if ([cell isKindOfClass:[XLDGoodsInfoPriceCell class]]) {
        XLDGoodsInfoPriceCell *priceCell = (XLDGoodsInfoPriceCell *)cell;
        priceCell.delegate = self;
    } else if ([cell isKindOfClass:[XLDGoodsCouponCollectionViewCell class]]) {
        XLDGoodsCouponCollectionViewCell *cuponViewCell = (XLDGoodsCouponCollectionViewCell *)cell;
        cuponViewCell.delegate = self;
    } else if ([cell isKindOfClass:[XLDGoodsEarnCollectionViewCell class]]) {
        XLDGoodsEarnCollectionViewCell *earnCell = (XLDGoodsEarnCollectionViewCell *)cell;
        [earnCell adjustStyleForisLetaoHighCommission:[self isLetaoHighCommissionGoods]];
        earnCell.delegate = self;
    } else if ([cell isKindOfClass:[XLDGoodsInfoMemberUpgradeCell class]]) {
        XLDGoodsInfoMemberUpgradeCell *memberUpgradeCell = (XLDGoodsInfoMemberUpgradeCell *)cell;
        memberUpgradeCell.delegate = (id)self;
    }else if ([cell isKindOfClass:[XLDGoodsInfoTopImageCell class]]) {
        NSArray *imageURLStringsGroup = [self topImageURLStringsGroup];
        UIImage *placeholderImage = [self cycleScrollViewPlaceholderImage];
        XLDGoodsInfoTopImageCell *topImageCell = (XLDGoodsInfoTopImageCell *)cell;
        if (self.letaoCycleScrollView == nil) {
             self.letaoCycleScrollView = [[XLTGoodDetailSDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreen_iPhone375Scale(375))];
            self.letaoCycleScrollView.delegate = self;
            self.letaoCycleScrollView.placeholderImage = placeholderImage;
            
            self.letaoCycleScrollView.infiniteLoop = NO;
            self.letaoCycleScrollView.autoScroll = NO;
            self.letaoCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
            self.letaoCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
         }
        // 设置视频和图片
        [self letaoSetupCycleScrollIndicator:imageURLStringsGroup];
        self.letaoCycleScrollView.imageURLStringsGroup = imageURLStringsGroup;
        [topImageCell.contentView addSubview:self.letaoCycleScrollView];
        
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

        if (imageURLStringsGroup.count < 1) {
            [self.letaoCycleScrollView letaoletaoShowBgImageLoadingWithBgImage:placeholderImage];
        } else {
            [self.letaoCycleScrollView letaoletaoRemoveLoading];
        }
        
        
    }
    return cell;
}

- (UIImage *)cycleScrollViewPlaceholderImage {
    static UIImage *iconPlaceholderImage = nil;
    if (iconPlaceholderImage == nil) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreen_iPhone375Scale(375));
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = kIconPlaceholderImage;
        [imageView setNeedsLayout];
        [imageView layoutIfNeeded];
        iconPlaceholderImage = [self letaoConvertViewToImage:imageView size:rect.size];
    }
    return iconPlaceholderImage;
}

//- (UIImage *)letaoConvertViewToImage:(UIView *)view size:(CGSize)size {
//    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.letaoCellFactory collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == XLDGoodsDetailSectionType_GoodsRecomend) {
        return 10;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == XLDGoodsDetailSectionType_GoodsRecomend) {
        return 10;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == XLDGoodsDetailSectionType_StoreRecomend) {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    } else if (section == XLDGoodsDetailSectionType_GoodsRecomend) {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    } else if (section == XLDGoodsDetailSectionType_EditorsRecommend) {
        NSArray *editorsRecommendArray = self.letaoPageDataArray[XLDGoodsDetailSectionType_EditorsRecommend];
        if (editorsRecommendArray.count > 0) {
            return UIEdgeInsetsMake(0, 0, 10, 0);
        }
    }
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == XLDGoodsDetailSectionType_Coupon) {
        return CGSizeMake(collectionView.bounds.size.width, 10);
    } else if (section == XLDGoodsDetailSectionType_Arg) {
        NSArray *postage = self.letaoPageDataArray[XLDGoodsDetailSectionType_Postage];
        NSArray *pledge = self.letaoPageDataArray[XLDGoodsDetailSectionType_Pledge];
        NSArray *arg = self.letaoPageDataArray[XLDGoodsDetailSectionType_Arg];
        if (postage.count  + pledge.count + arg.count > 0) {
            return CGSizeMake(collectionView.bounds.size.width, 10);
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    NSArray *array = self.letaoPageDataArray[section];
    if (section == XLDGoodsDetailSectionType_StoreRecomend) {
        if ([self letaoIsStoreInfoValid]) {
            return CGSizeMake(collectionView.bounds.size.width, 49 );
        }
    } else if (section == XLDGoodsDetailSectionType_Detail) {
        BOOL isEmpty = (![array isKindOfClass:[NSArray class]] || array.count == 0);
        if (!isEmpty) {
            return CGSizeMake(collectionView.bounds.size.width, 49 );
        }
    } else if (section == XLDGoodsDetailSectionType_GoodsRecomend) {
        if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
            return CGSizeMake(collectionView.bounds.size.width, 49 );
        }
    }
   return CGSizeZero;
}

 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == XLDGoodsDetailSectionType_StoreRecomend) {
         if (kind == UICollectionElementKindSectionHeader) {
             XLDGoodsStoreRecomendHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLDGoodsStoreRecomendHeaderView forIndexPath:indexPath];
             headerView.delegate = self;
             return headerView;
         }
     }else if (indexPath.section == XLDGoodsDetailSectionType_Coupon
               || indexPath.section == XLDGoodsDetailSectionType_Arg) {
         if (kind == UICollectionElementKindSectionFooter) {
             UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"kEmptyFooter" forIndexPath:indexPath];
             footerView.backgroundColor = self.view.backgroundColor;
             return footerView;
         }
     }else if (indexPath.section == XLDGoodsDetailSectionType_GoodsRecomend
               || indexPath.section == XLDGoodsDetailSectionType_Detail) {
         if (kind == UICollectionElementKindSectionHeader) {
             XLDGoodsNoneDetailHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLDGoodsNoneDetailHeaderView forIndexPath:indexPath];
             headerView.letaoEmptyTextLabel.text = nil;
             NSString *lineText = @"—";
             NSString *contentText = nil;
             if (indexPath.section == XLDGoodsDetailSectionType_Detail) {
                  contentText = @"  商品详情  ";
             } else {
                  contentText = @"  大家都在买  ";
             }
             NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",lineText,contentText,lineText]];
             [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFC3C4C7]} range:NSMakeRange(0, attributedString.length)];
             [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]} range:NSMakeRange(lineText.length, contentText.length)];
             [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:15.0]} range:NSMakeRange(0, attributedString.length)];
             [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:15.0]} range:NSMakeRange(lineText.length, contentText.length)];

             headerView.letaoEmptyTextLabel.attributedText = attributedString;
             return headerView;
         }
     }
     
     return [UICollectionReusableView new];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
    if (indexPath.section == XLDGoodsDetailSectionType_Pledge
        || indexPath.section == XLDGoodsDetailSectionType_Arg) {
        XLTGoodsDetailSukPopVC *sukViewController = [[XLTGoodsDetailSukPopVC alloc] initWithNibName:@"XLTGoodsDetailSukPopVC" bundle:[NSBundle mainBundle]];
        BOOL letaoIsSafeguardCell = (indexPath.section == XLDGoodsDetailSectionType_Pledge);
        NSString *source =  [self letaoGoodsSourceParameters];
        BOOL isPDDSource = ([source isKindOfClass:[NSString class]] && [source isEqualToString:XLTPDDPlatformIndicate]);
        sukViewController.letaoIsSafeguardCell = letaoIsSafeguardCell;
        sukViewController.letaoIsSingleCellType = (letaoIsSafeguardCell && isPDDSource);
        NSString *title = (indexPath.section == XLDGoodsDetailSectionType_Pledge) ? @"产品保障" : @"产品参数";
        sukViewController.letaoTitleText = title;
        sukViewController.letaoDataInfo =  itemInfo;
        [self letaoPresentSukVC:sukViewController];
        
        // 汇报事件
        NSDictionary *itemInfo = self.letaoGoodsDetailModel.data;
        NSMutableDictionary *properties = @{}.mutableCopy;
        properties[@"good_id"] = [SDRepoManager repoResultValue:itemInfo[@"_id"]];
        properties[@"good_name"] = [SDRepoManager repoResultValue:itemInfo[@"item_title"]];
        properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:itemInfo[@"item_source"]];
        properties[@"xlt_item_firstcate_title"] = @"null";
        properties[@"xlt_item_thirdcate_title"] = @"null";
        properties[@"xlt_item_secondcate_title"] = @"null";
        [SDRepoManager xltrepo_trackEvent:(indexPath.section == XLDGoodsDetailSectionType_Pledge) ? XLT_EVENT_GOODDETAIL_GUARANTEE :XLT_EVENT_GOODDETAIL_PARAMETER properties:properties];
        
    } else if (indexPath.section == XLDGoodsDetailSectionType_GoodsRecomend
               || indexPath.section == XLDGoodsDetailSectionType_StoreRecomend) {
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
        
        // 汇报事件
        NSString *xkd_item_place = nil;
        [SDRepoManager xltrepo_trackGoodsSelectedWithInfo:itemInfo xlt_item_place:xkd_item_place xlt_item_good_position:[NSNumber numberWithInteger:indexPath.row + 1]];
    } else if (indexPath.section == XLDGoodsDetailSectionType_Store) {
        [self letaoGoStoreActionWith:NO];
    } else if (indexPath.section == XLDGoodsDetailSectionType_Detail) {
        if (XLDGoodsDetailSectionType_Detail < self.letaoPageDataArray.count) {
            NSArray *imageDetailArray =        self.letaoPageDataArray[XLDGoodsDetailSectionType_Detail];
            if (indexPath.item < imageDetailArray.count) {
                XLDGoodsDetailCollectionViewCellDisplayModel *model = imageDetailArray[indexPath.item];
                if ([model isKindOfClass:[XLDGoodsDetailCollectionViewCellDisplayModel class]]
                    && model.isImageType) {
                    NSMutableArray *imagesArray = [NSMutableArray array];
                    __block NSUInteger index = 0;
                    [imageDetailArray enumerateObjectsUsingBlock:^(XLDGoodsDetailCollectionViewCellDisplayModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[XLDGoodsDetailCollectionViewCellDisplayModel class]]) {
                            if (obj.isImageType && [obj.imageUrl isKindOfClass:[NSString class]]) {
                                [imagesArray addObject:obj.imageUrl];
                                if (obj == model) {
                                    index = imagesArray.count -1;
                                }
                            }
                        }
                    }];
                    if (imagesArray.count > 0) {
                        [self photoBrowserImagesArray:imagesArray atIndex:index];
                    }
                }
            }
        }
    } else if (indexPath.section == XLDGoodsDetailSectionType_EditorsRecommend) {
        NSString *text = (NSString *)itemInfo;
         if ([text isKindOfClass:[NSString class]] && text.length > 0) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = text;
            [self showTipMessage:@"复制成功!"];
         }
         
    }
}

- (void)photoBrowserImagesArray:(NSArray *)imagesArray atIndex:(NSUInteger)index
 {
    [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
    KSPhotoBrowser.imageViewBackgroundColor = UIColor.clearColor;
    
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < imagesArray.count; i++) {
        NSString *imageUrl = imagesArray[i];
        if ([imageUrl isKindOfClass:[NSString class]]) {
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:nil imageUrl:[NSURL URLWithString:[imageUrl letaoConvertToHttpsUrl]]];
             [items addObject:item];
        }
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:index];
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces = NO;
    [browser showFromViewController:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self letaoAdjustTopHeader];
    //
//    if ([self letaoIsRecomendGoodsVisible]) {
//        self.letaoTopHeader.letaoSegmentedControl.selectedSegmentIndex = 2;
//    } else if ([self letaoIsGoodsDetailVisible]){
//        self.letaoTopHeader.letaoSegmentedControl.selectedSegmentIndex = 1;
//    } else {
//        self.letaoTopHeader.letaoSegmentedControl.selectedSegmentIndex = 0;
//    }
    [self xlt_scrollViewDidScroll:scrollView needAutoShowBackToTop:YES];
    CGFloat offset = 44 + 25;
    self.backToTopButton.frame = CGRectMake(self.collectionView.bounds.size.width - 42 - 22 , self.collectionView.bounds.size.height - 56 -30 - offset + self.collectionView.contentOffset.y, 56, 56);
}

#pragma mark - JHCollectionViewDelegateFlowLayout
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section {
    if (section == XLDGoodsDetailSectionType_StoreRecomend) {
        return [UIColor whiteColor];
    } else {
        return self.collectionView.backgroundColor;
    }
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

- (XLTGoodsDetailCellsFactory *)letaoCellFactory {
    if (_letaoCellFactory == nil) {
        _letaoCellFactory = [[XLTGoodsDetailCellsFactory alloc] init];
    }
    return _letaoCellFactory;
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
            self.letaoCurrentCycleIndexLabel.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)self.letaoCurrentCycleIndex +1,(unsigned long)(imageURLStringsGroup.count - [self letaoVideoUrlArray].count)];
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

#pragma mark -  更新Goods Detai

- (void)letaoUpdateGoodsInfoDetailSection {
  
    if ([self.letaoGoodsDetailModel.data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *goodInfo = self.letaoGoodsDetailModel.data;

        //头部焦点图
        [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_GoodsInfo_Image withObject:@[goodInfo]];
        // 商品价格
        [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_GoodsInfo_Price withObject:@[goodInfo]];
        //商品title、店铺名字和销量
        [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_GoodsInfo_TitleText withObject:@[goodInfo]];
        
        
        NSNumber *couponAmount = nil;
        NSNumber *couponStartTime = nil;
        NSNumber *couponEndTime = nil;
        
        NSString *item_source = goodInfo[@"item_source"];
        if (goodInfo[@"item_id"]) {
            self.letaoGoodsItemId = goodInfo[@"item_id"];
        }
        self.letaoGoodsItemSource = item_source;
        
        // 优惠券
        NSDictionary *coupon = goodInfo[@"coupon"];
        if ([coupon isKindOfClass:[NSDictionary class]]) {
            couponAmount = coupon[@"amount"];
            couponStartTime = [coupon[@"start_time"] isKindOfClass:[NSNumber class]] ? coupon[@"start_time"] :@0;
            couponEndTime = [coupon[@"end_time"] isKindOfClass:[NSNumber class]] ? coupon[@"end_time"] :@0;
        }
        BOOL isCouponValid = NO;
        if ([self letaoIsValidGoods:self.letaoGoodsDetailModel]) {
            if ([couponAmount isKindOfClass:[NSNumber class]] && [couponAmount integerValue] > 0) {
                isCouponValid = [XLTGoodsDisplayHelp letaoShouldShowCouponWithAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];
            }
        }
        if (isCouponValid && ![XLTAppPlatformManager shareManager].isLimitModel) {
            [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_Coupon withObject:@[coupon]];
        }
        
        // 返利
        NSNumber *earnAmount = nil;
        NSNumber *letaocommission = nil;
        NSNumber *letaosubsidy = nil;
        BOOL isEarnAmountValid = NO;
//        fix_rebate_amount ，double_rebate
        NSDictionary *rebate = goodInfo[@"rebate"];
        if ([rebate isKindOfClass:[NSDictionary class]]) {
            earnAmount = rebate[@"xkd_amount"];
            letaocommission = rebate[@"xlt_commission"];
            letaosubsidy = rebate[@"xlt_subsidy"];
            
            if ([earnAmount isKindOfClass:[NSNumber class]] && [earnAmount integerValue] > 0) {
                isEarnAmountValid = YES;
            }
        }
        
        // 推荐语
        NSString *recommend_text = goodInfo[@"recommend_text"];
        NSNumber *reload_rec_text = goodInfo[@"reload_rec_text"];
        if ([reload_rec_text isKindOfClass:[NSNumber class]] && [reload_rec_text boolValue]) {
            // 手动获取recommend_text
            [self fetchEditorsRecommend];
        } else if ([recommend_text isKindOfClass:[NSString class]] && recommend_text.length > 0) {
            [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_EditorsRecommend withObject:@[recommend_text]];
        }
        
        // 发货
//        京东没有发货选项，直接删除
        if ([item_source isKindOfClass:[NSString class]]
            && [item_source isEqualToString:XLTJindongPlatformIndicate]) {
            [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_Postage withObject:@[]];
        } else {
            NSString *item_delivery_from = goodInfo[@"item_delivery_from"];
            NSNumber *item_delivery_postage = goodInfo[@"item_delivery_postage"];
            
            if ([item_delivery_from isKindOfClass:[NSString class]]
                && item_delivery_from.length > 0) {
                if (![item_delivery_postage isKindOfClass:[NSNumber class]]) {
                    item_delivery_postage = [NSNumber numberWithInteger:-1];
                }
                NSDictionary *postageInfo = @{@"item_delivery_from":item_delivery_from,
                                              @"item_delivery_postage":item_delivery_postage
                };
                [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_Postage withObject:@[postageInfo]];
            }
        }

        // 店铺
        if (![XLTAppPlatformManager shareManager].isLimitModel) {
            NSDictionary *seller = goodInfo[@"seller"];
            if ([seller isKindOfClass:[NSDictionary class]] && seller.count > 0) {
                [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_Store withObject:@[seller]];
            }
        }
        
        
        // 定金
        NSNumber *prepaidAmount = nil;
        NSNumber *endTime = nil;
        NSDictionary *presale = goodInfo[@"presale"];
        if ([presale isKindOfClass:[NSDictionary class]] && presale.count > 0) {
            NSNumber *deposit = presale[@"deposit"];
            if ([deposit isKindOfClass:[NSNumber class]]) {
                prepaidAmount = deposit;
            }
            
            NSNumber *end_time = presale[@"end_time"];
            if ([end_time isKindOfClass:[NSNumber class]]) {
                endTime = end_time;
            }
        }

        BOOL preCouponFlag = ([[NSDate dateWithTimeIntervalSince1970:[couponStartTime longLongValue]] isInFuture] && ([couponAmount isKindOfClass:[NSNumber class]]
           && ([couponAmount integerValue] >0)));
        BOOL highCommissionGoods = [self isLetaoHighCommissionGoods];
        BOOL prePaidGoods = [self isPrePaidGoods];
        
        if (prePaidGoods) {
            //预售时间
            [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_PrePaidDate withObject:@[presale]];
            // 预售折扣
            NSString *discount_fee_text = presale[@"discount_fee_text"];
            if([discount_fee_text isKindOfClass:[NSString class]] && [discount_fee_text length] > 0) {
                [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_PrePaidDiscount withObject:@[presale]];
            } else {
                [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_PrePaidDiscount withObject:@[]];
            }
        } else {
            [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_PrePaidDate withObject:@[]];
            [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_PrePaidDiscount withObject:@[]];
        }
        
        // 底部菜单
        [self.letaoBottomFooter letaoUpdateErarnAmount:earnAmount shareAmount:earnAmount couponAmount:couponAmount prepaidAmount:prepaidAmount goodsSource:goodInfo[@"item_source"] isPreCoupon:preCouponFlag isLetaoHighCommission:highCommissionGoods isPrepaidGoods:prePaidGoods isCouponValid:isCouponValid];
        if ([XLTAppPlatformManager shareManager].checkEnable) {
            if (self.letaoBottomFooter.letaoIsAliSource) {
                self.letaoBottomFooter.letaoBuyBtnWidth.constant = 0;
            } else {
                self.letaoBottomFooter.letaoBuyBtnWidth.constant = floorf(151.0/750.0*kScreenWidth/2.0);
            }
            self.letaoBottomFooter.letaoShareBtn.hidden = NO;
        } else {
            CGFloat letaoShareBtnWitdh = floorf(224/750.0*kScreenWidth);
            if (self.letaoBottomFooter.letaoIsAliSource) {
                self.letaoBottomFooter.letaoBuyBtnWidth.constant = letaoShareBtnWitdh;
            } else {
                self.letaoBottomFooter.letaoBuyBtnWidth.constant = floorf(151.0/750.0*kScreenWidth) + letaoShareBtnWitdh;
            }
            self.letaoBottomFooter.letaoShareBtn.hidden = YES;
        }
           
        // adjust Bottom Tip Style
        if (highCommissionGoods) {
            [self setupBottomViewWithCommission:letaocommission subsidy:letaosubsidy];
        } else if (prePaidGoods) {
            [self setupBottomPrepaidTipViewForEndTime:[endTime longLongValue]];
        } else if (preCouponFlag) {
            [self setupBottomPreCouponTipViewForStartTime:[couponStartTime longLongValue]];
        } else {
            [self setupBottomViewWithCommission:letaocommission subsidy:letaosubsidy];
        }
    }
}


#pragma mark -  更新GoodsDesc
- (void)letaoUpdateGoodsDescInfoSection {
  
    if ([self.letaoGoodsDescModel.data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *goodInfo = self.letaoGoodsDescModel.data;
        // 保障
        NSArray *consumer_protection = goodInfo[@"consumer_protection"];
        if ([consumer_protection isKindOfClass:[NSArray class]] && consumer_protection.count > 0) {
            [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_Pledge withObject:@[consumer_protection]];
        }
        
        // 参数
        NSArray *item_props = goodInfo[@"item_props"];
        if ([item_props isKindOfClass:[NSArray class]] && item_props.count > 0) {
            NSDictionary *argumentInfo = item_props.firstObject;
            if ([argumentInfo isKindOfClass:[NSDictionary class]] && argumentInfo.count > 0) {
                [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_Arg withObject:@[item_props]];
            }

        }
        if (![XLTAppPlatformManager shareManager].isLimitModel) {
            NSDictionary *seller = goodInfo[@"seller"];
            if ([seller isKindOfClass:[NSDictionary class]] && seller.count > 0) {
                [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_Store withObject:@[seller]];
            }
        }

        
        // 详情
        NSDictionary *item_desc = goodInfo[@"item_desc"];
        if ([item_desc isKindOfClass:[NSDictionary class]]) {
            NSArray *content = item_desc[@"content"];
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
                    [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_Detail withObject:detailArray];
                }
            }
        }
    }
}



- (void)letaoUpdateStoreRecommendGoodsSectionData:(NSArray *)goodsArray {
    if (![XLTAppPlatformManager shareManager].isLimitModel) {
            // 最多三个
        if (goodsArray.count >3) {
            [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_StoreRecomend withObject:@[goodsArray[0],goodsArray[1],goodsArray[2]]];
        } else {
            [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_StoreRecomend withObject:goodsArray];
        }
        [self.collectionView reloadData];
    }

}


- (void)letaoUpdateRecommendGoodsSectionData:(NSArray *)goodsArray {
    if (goodsArray.count > 0) {
        [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_GoodsRecomend withObject:goodsArray];
        [self.collectionView reloadData];
    }
    self.letaoRefreshAutoFooter.hidden = !(goodsArray.count > 0);
}




- (void)letaGoods:(XLDGoodsImageCollectionViewCell *)cell imageSizeChanged:(UIImage *)image imageSize:(CGSize)size {
//    BOOL isGoodsaGoodsRecomendlVisible = ([self letaoIsRecomendGoodsDisplay]);
//    NSInteger selectedSegmentIndex = self.letaoTopHeader.letaoSegmentedControl.selectedSegmentIndex;
    [self.collectionView reloadData];
    /*
    if (isGoodsaGoodsRecomendlVisible && selectedSegmentIndex == 2) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UICollectionViewLayoutAttributes *headeraAttributes = [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:XLDGoodsDetailSectionType_GoodsRecomend]];
            if (headeraAttributes) {
                CGRect rect = headeraAttributes.frame;
                if (![self letaoIsRecomendGoodsDisplay]) {
                    [self.collectionView scrollRectToVisible:rect animated:NO];
                }
            }
            
        });
    }*/
}



- (NSArray *)topImageURLStringsGroup {
    NSMutableArray *imageURLStringsGroup = @[].mutableCopy;
    if ([self.letaoGoodsDetailModel.data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *itemInfo = self.letaoGoodsDetailModel.data;
        NSString *item_image = itemInfo[@"item_image"];
        if ([item_image isKindOfClass:[NSString class]]) {
            [imageURLStringsGroup addObject:[item_image letaoConvertToHttpsUrl]];
        }
    }
    if ([self.letaoGoodsDescModel.data isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *descImageArray = [self imagesArrayWithItemInfo:self.letaoGoodsDescModel.data].mutableCopy;
//        NSString *source =  [self letaoGoodsSourceParameters];
//        BOOL isJindongSource = ([source isKindOfClass:[NSString class]] && [source isEqualToString:XLTJindongPlatformIndicate]);
        // 不再区分京东
        if (1) {
            // 京东图片需要删除letaoGoodsDescModel中和letaoGoodsDetailModel第一张结尾相同的图片
            NSString *fristImageURLText = imageURLStringsGroup.firstObject;
            if ([fristImageURLText isKindOfClass:[NSString class]]) {
//                NSURL *fristImageURL = [NSURL URLWithString:fristImageURLText];
                // 不再区分京东
//                if ([fristImageURL.host containsString:@"360buyimg.com"])
                {
                    NSRange range = [fristImageURLText rangeOfString:@"/" options:NSBackwardsSearch];
                    if( range.location != NSNotFound ){
                       //以下方法会包含起始索引的字符，所以+1
                        NSString *lastPathComponent = [[fristImageURLText substringFromIndex:range.location + 1] stringByDeletingPathExtension];
                        if (lastPathComponent.length) {
                            // 获取倒数第二个path
                            NSString *subString = [fristImageURLText substringToIndex:range.location];
                            NSRange subRange = [subString rangeOfString:@"/" options:NSBackwardsSearch];
                            if(subRange.location != NSNotFound ){
                                NSString *subPathComponent = [subString substringFromIndex:subRange.location +1];
                                // 组装第二个path和lastPathComponent
                                NSString *pathComponent = [NSString stringWithFormat:@"%@/%@",subPathComponent,lastPathComponent];
                                if (pathComponent) {
                                    NSMutableArray *tempArray = descImageArray.copy;
                                    [tempArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        if ([obj isKindOfClass:[NSString class]] && [obj containsString:pathComponent]) {
                                            [descImageArray removeObject:obj];
                                        }
                                    }];
                                }
                            }
                        }
                    }
                }
            }
        }
        [imageURLStringsGroup addObjectsFromArray:descImageArray];
    }
    if (imageURLStringsGroup.count < 1) {
        NSArray *letaoVideoUrlArray = [self letaoVideoUrlArray];
        BOOL haveVideo = (letaoVideoUrlArray.count > 0);
        if (haveVideo) {
            // 空图
            [imageURLStringsGroup addObject:@""];
        }
    }
    return imageURLStringsGroup;
}


- (NSArray *)imagesArrayWithItemInfo:(NSDictionary *)itemInfo {
    NSMutableArray *array = @[].mutableCopy;
    /*
    // 先解析视频
    NSArray *item_video = itemInfo[@"item_video"];
    if ([item_video isKindOfClass:[NSArray class]]) {
        [item_video enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *thumbnail = @"";
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *thum = obj[@"thumbnail"];
                if ([thum isKindOfClass:[NSString class]]) {
                    thumbnail = [thum letaoConvertToHttpsUrl];;
                    *stop = YES; // 只取一个
                }
            }
            [array addObject:thumbnail];
        }];
    }*/
    
    NSArray *item_images = itemInfo[@"item_images"];
    if ([item_images isKindOfClass:[NSArray class]] && item_images.count > 0) {
        [item_images enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                [array addObject:[obj letaoConvertToHttpsUrl]];
            } else {
                [array addObject:@""];
            }
        }];
    } else {
        NSString *item_image = itemInfo[@"item_image"];
        if ([item_image isKindOfClass:[NSString class]]) {
            [array addObject:[item_image letaoConvertToHttpsUrl]];
        }
    }

    return array;
}

#pragma mark -  视频
- (NSArray *)letaoVideoUrlArray {
    NSMutableArray *array = @[].mutableCopy;
    NSDictionary *goodInfo = self.letaoGoodsDescModel.data;
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

- (void)memberUpgradeCell:(id )cell upgradeBtnClicked:(id)sender {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        XLTVipVC *vip = [[XLTVipVC alloc] init];
        vip.needBack = YES;
        [self.navigationController pushViewController:vip animated:YES];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        XLTTabBarController *tab = delegate.tabBar;
//        if (tab.viewControllers.count > 2) {
//            if ([tab.viewControllers[2] isKindOfClass:[XLTVipVC class]]) {
//                tab.selectedIndex = 2;
//            }
//        }
    }
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

- (void)letaoPresentSukVC:(XLTGoodsDetailSukPopVC *)viewController {
    
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

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    XLTTabBarController *tab = delegate.tabBar;
    if (tab.viewControllers.count > 0) {
        tab.selectedIndex = 0;
    }
    // 汇报事件
    NSDictionary *itemInfo = self.letaoGoodsDetailModel.data;
    NSMutableDictionary *properties = @{}.mutableCopy;
    properties[@"good_id"] = [SDRepoManager repoResultValue:itemInfo[@"_id"]];
    properties[@"good_name"] = [SDRepoManager repoResultValue:itemInfo[@"item_title"]];
    properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:itemInfo[@"item_source"]];
    properties[@"xlt_item_firstcate_title"] = @"null";
    properties[@"xlt_item_thirdcate_title"] = @"null";
    properties[@"xlt_item_secondcate_title"] = @"null";
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_GOODDETAIL_HOME properties:properties];
    
    
}

- (void)letaoCommandBtnClicked {
    
    // 汇报事件
    NSDictionary *itemInfo = self.letaoGoodsDetailModel.data;
    NSMutableDictionary *properties = @{}.mutableCopy;
    properties[@"good_id"] = [SDRepoManager repoResultValue:itemInfo[@"_id"]];
    properties[@"good_name"] = [SDRepoManager repoResultValue:itemInfo[@"item_title"]];
    properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:itemInfo[@"item_source"]];
    properties[@"xlt_item_firstcate_title"] = @"null";
    properties[@"xlt_item_thirdcate_title"] = @"null";
    properties[@"xlt_item_secondcate_title"] = @"null";
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_GOODDETAIL_COPYLINK properties:properties];
       
    
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    if ([self.letaoTKLShareCode isKindOfClass:[NSString class]]
        && self.letaoTKLShareCode.length > 0) {
        [self letaoCopyTaobaoPasteboardText];
    } else {
        /*
        __weak typeof(self)weakSelf = self;
        [self.letaoGoodsDetailLogic xingletaonetwork_requestAliCommandTextActionWithGoodsId:self.letaoGoodsId success:^(NSString * _Nonnull commandText) {
            weakSelf.letaoTKLPasteboardText = commandText;
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = commandText;
            [weakSelf showTipMessage:@"复制口令成功!"];
        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf showTipMessage:errorMsg];
        }];*/
         [self xingletaonetwork_requestAliAndJingDongGoodsURLDataIsAliCommandTextOnly:YES];
    }
}

- (void)letaoCopyTaobaoPasteboardText {
    if ([self.letaoTKLShareCode isKindOfClass:[NSString class]]
        && self.letaoTKLShareCode.length > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.letaoTKLShareCode;
        [[XLTAppPlatformManager shareManager] saveGoodsPasteboardValue:self.letaoTKLShareCode];
        [self letaoShowTKLAlert];
    } else {
        [self showTipMessage:@"复制口令失败!"];
    }
}

- (void)recommendFeedButtonAction:(id)sender {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
    } else {
        __weak typeof(self)weakSelf = self;
        [self startRecommendGoods:self.letaoGoodsDetailModel.data
                            style:self.goodsRecommendFeedStyle
                          goodsId:self.letaoGoodsId
                       itemSource:[self letaoGoodsSourceParameters]
                          tipText:self.goodsRecommendFeedTipText stateChanged:^(XLTGoodsRecommendFeedStyle chanedStyle, NSString * _Nullable tipText) {
            if (chanedStyle != weakSelf.goodsRecommendFeedStyle) {
                weakSelf.goodsRecommendFeedStyle = chanedStyle;
                weakSelf.goodsRecommendFeedTipText = tipText;
                [weakSelf updateGoodsRecommendFeedButtonData];
            }
        }];
    }
}

- (void)letaoCollectBtnClicked {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    
    // 汇报事件
    BOOL collect = !self.isLetaoCollected;
    NSDictionary *itemInfo = self.letaoGoodsDetailModel.data;
    NSMutableDictionary *properties = @{}.mutableCopy;
    properties[@"good_id"] = [SDRepoManager repoResultValue:itemInfo[@"_id"]];
    properties[@"good_name"] = [SDRepoManager repoResultValue:itemInfo[@"item_title"]];
    properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:itemInfo[@"item_source"]];
    properties[@"xlt_item_firstcate_title"] = @"null";
    properties[@"xlt_item_thirdcate_title"] = @"null";
    properties[@"xlt_item_secondcate_title"] = @"null";
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_GOODDETAIL_FAVORITE properties:properties];
    
    [[XLTRepoDataManager shareManager] repoCollect:collect plate:self.letaoParentPlateId childPlate:self.letaoCurrentPlateId goodId:self.letaoGoodsItemId item_source:self.letaoGoodsItemSource];
    
    
    if (self.letaoGoodsCollectLogic == nil) {
        self.letaoGoodsCollectLogic = [[XLTCollectLogic alloc] init];
    }
    __weak typeof(self)weakSelf = self;
    if (self.isLetaoCollected) {
        // 取消
        [self.letaoGoodsCollectLogic xingletaonetwork_cancelCollectWithGoodsId:self.letaoGoodsId itemSource:[self letaoGoodsSourceParameters] success:^(XLTBaseModel * _Nonnull model) {
            weakSelf.isLetaoCollected = NO;
        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf showTipMessage:errorMsg];
        }];
    } else {
        [self.letaoGoodsCollectLogic xingletaonetwork_collectGoodsWithId:self.letaoGoodsId itemSource:[self letaoGoodsSourceParameters] success:^(XLTBaseModel * _Nonnull model) {
            weakSelf.isLetaoCollected = YES;
        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf showTipMessage:errorMsg];
        }];
    }
}


- (void)setIsLetaoCollected:(BOOL)isLetaoCollected {
    _isLetaoCollected = isLetaoCollected;
    self.letaoTopHeader.letaoCollectButton.selected = isLetaoCollected;
}

- (void)letaoShowClearBgLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}

- (void)letaoBuyButtonClicked {
    
    // 汇报事件
    NSDictionary *itemInfo = self.letaoGoodsDetailModel.data;
    NSMutableDictionary *properties = @{}.mutableCopy;
    properties[@"good_id"] = [SDRepoManager repoResultValue:itemInfo[@"_id"]];
    properties[@"good_name"] = [SDRepoManager repoResultValue:itemInfo[@"item_title"]];
    properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:itemInfo[@"item_source"]];
    NSDictionary *rebate = itemInfo[@"rebate"];
    if ([rebate isKindOfClass:[NSDictionary class]]) {
        properties[@"xlt_item_rebate_amount"] = [SDRepoManager repoResultValue:rebate[@"xkd_amount"]];
    }
    NSArray *coupoArray = self.letaoPageDataArray[XLDGoodsDetailSectionType_Coupon];
    if ([coupoArray isKindOfClass:[NSArray class]]
        && [coupoArray.firstObject  isKindOfClass:[NSDictionary class]]) {
        NSDictionary *coupoInfo = coupoArray.firstObject;
        properties[@"xlt_item_coupon_amount"] = [SDRepoManager repoResultValue:coupoInfo[@"amount"]];

    }
    properties[@"xlt_item_firstcate_title"] = @"null";
    properties[@"xlt_item_thirdcate_title"] = @"null";
    properties[@"xlt_item_secondcate_title"] = @"null";
    properties[@"Landing_Page_title"] = @"null";
    properties[@"Landing_Page_url"] = @"null";
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_GOODDETAIL_BUY properties:properties];
    
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    [self xingletaonetwork_requestAliAndJingDongGoodsURLDataIsAliCommandTextOnly:NO];
}


- (void)letaoBottomShareButtonClicked {
    // 汇报事件
    NSDictionary *itemInfo = self.letaoGoodsDetailModel.data;
    NSMutableDictionary *properties = @{}.mutableCopy;
    properties[@"good_id"] = [SDRepoManager repoResultValue:itemInfo[@"_id"]];
    properties[@"good_name"] = [SDRepoManager repoResultValue:itemInfo[@"item_title"]];
    properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:itemInfo[@"item_source"]];
    NSDictionary *rebate = itemInfo[@"rebate"];
    if ([rebate isKindOfClass:[NSDictionary class]]) {
         properties[@"xlt_item_rebate_amount"] = [SDRepoManager repoResultValue:rebate[@"xkd_amount"]];
    }
    properties[@"xlt_item_firstcate_title"] = @"null";
    properties[@"xlt_item_thirdcate_title"] = @"null";
    properties[@"xlt_item_secondcate_title"] = @"null";
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_GOODDETAIL_SHARE properties:properties];
    
    
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    if ([XLTAppPlatformManager shareManager].isLimitModel) {
    } else {
        if (self.letaoGoodsDetailLogic == nil) {
            self.letaoGoodsDetailLogic = [[XLTGoodsDetailLogic alloc] init];
        }
        __weak typeof(self)weakSelf = self;
        if (self.letaoBottomFooter.letaoIsAliSource) {
            [self letaoShowClearBgLoading];
            [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsJumpUrlDataWithGoodsId:self.letaoGoodsId itemSource:[self letaoGoodsSourceParameters] isAliCommandTextOnly:YES success:^(XLTBaseModel * _Nonnull model,BOOL isAliCommandTextOnly) {
                [weakSelf letaoRemoveLoading];
                NSDictionary *data = model.data;
                if ([data isKindOfClass:[NSDictionary class]]) {
                    if ([XLTGoodsDetailLogic letaoIsNeedAliAuthorizationCode:model]) {
                        NSString *auth_url = data[@"auth_url"];
                        if ([auth_url isKindOfClass:[NSString class]]) {
                            [weakSelf letaoOpenAliTrandWithURLString:auth_url authorization:NO];
                        }
                    } else {
                        BOOL isAliSource = YES;
                        NSString *share_code = data[@"share_code"];
                        NSString *share_text = data[@"share_text"];
                        NSString *tkl = data[@"code"];
                        
                        if ([share_text isKindOfClass:[NSString class]]
                            && [share_code isKindOfClass:[NSString class]]) {
                            [weakSelf letaoPushShareVCWithShareCode:share_code shareText:share_text isAliSource:isAliSource tkl:tkl jdkl:nil];
                        } else {
                            [weakSelf showTipMessage:Data_Error];
                        }
                       
                    }
                }
            } failure:^(NSString * _Nonnull errorMsg) {
               [weakSelf letaoRemoveLoading];
                [weakSelf showTipMessage:errorMsg];
            }];
        } else {
            __weak typeof(self)weakSelf = self;
            [self letaoShowClearBgLoading];
            [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsJumpUrlDataWithGoodsId:self.letaoGoodsId itemSource:[self letaoGoodsSourceParameters] isAliCommandTextOnly:YES success:^(XLTBaseModel * _Nonnull model,BOOL isAliCommandTextOnly) {
                [weakSelf letaoRemoveLoading];
                NSDictionary *itemInfo = model.data;
                if ([itemInfo isKindOfClass:[NSDictionary class]]) {
                    if ([XLTGoodsDetailLogic letaoIsNeedPDDAuthorizationCode:model]) {
                        NSString *auth_url = model.data[@"auth_url"];
                        if ([auth_url isKindOfClass:[NSString class]]) {
                            [weakSelf letaoOpenPddWithUrlString:auth_url];
                        }
                    }else{
                        BOOL isAliSource = NO;
                        NSString *share_code = itemInfo[@"share_code"];
                        NSString *share_text = itemInfo[@"share_text"];
                        NSString *jdkl = nil;
                        NSString *click_url = itemInfo[@"click_url"];
                        NSString *item_url = itemInfo[@"item_url"];
                        if ([click_url isKindOfClass:[NSString class]] && click_url.length > 0) {
                            jdkl = click_url;;
                        } else if([item_url isKindOfClass:[NSString class]] && item_url.length > 0){
                            jdkl = item_url;
                        }
                        
                        if ([share_text isKindOfClass:[NSString class]]
                            && [share_code isKindOfClass:[NSString class]]) {
                            [weakSelf letaoPushShareVCWithShareCode:share_code shareText:share_text isAliSource:isAliSource tkl:nil jdkl:jdkl];
                        } else {
                            [weakSelf showTipMessage:Data_Error];
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

- (void)letaoPushShareVCWithShareCode:(NSString * _Nullable)shareCode
                            shareText:(NSString * _Nullable)shareText
                          isAliSource:(BOOL)isAliSource
                                  tkl:(NSString *)tbk_pwd
                                 jdkl:(NSString *)jd_pwd {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.label.text = @"海报生成中...";
    hud.label.textColor = [UIColor colorWithHex:0xFF333333];
    hud.label.font = [UIFont letaoLightFontWithSize:12.0];
    XLTGoodsEarnShareImageView *earnShareImageView = [[NSBundle mainBundle] loadNibNamed:@"XLTGoodsEarnShareImageView" owner:self options:nil].lastObject;
    NSMutableArray *imageURLStringsGroup = [self shareImageURLStringsGroup];
    [earnShareImageView updateGoodsData:self.letaoGoodsDetailModel.data imageURLStringsGroup:imageURLStringsGroup tkl:tbk_pwd jdkl:jd_pwd complete:^(BOOL success, NSMutableArray * _Nonnull imageArray) {
        [hud hideAnimated:NO];
        UIImage *earnShareImage = [self letaoConvertViewToImage:earnShareImageView size:CGSizeMake(kScreenWidth, kScreen_iPhone375Scale(610))];
        XLTGoodsEarnShareVC *goodsEarnShareVC = [[XLTGoodsEarnShareVC alloc] init];
        goodsEarnShareVC.shareCode = shareCode;
        goodsEarnShareVC.shareText = shareText;
        goodsEarnShareVC.isAliSource = isAliSource;
        goodsEarnShareVC.goodsInfo = self.letaoGoodsDetailModel.data;
        goodsEarnShareVC.shareImageArray = imageArray;
        goodsEarnShareVC.sharePosterImage = earnShareImage;
        [self.navigationController pushViewController:goodsEarnShareVC animated:YES];
    }];
    earnShareImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreen_iPhone375Scale(610));

    [earnShareImageView setNeedsLayout];
    [earnShareImageView layoutIfNeeded];
}

// 删除和首图重复的图片
- (NSMutableArray *)shareImageURLStringsGroup {
    if ([self.letaoCycleScrollView.imageURLStringsGroup isKindOfClass:[NSArray class]]) {
        NSMutableArray *imageURLStringsGroup = [self.letaoCycleScrollView.imageURLStringsGroup mutableCopy];
        NSString *picUrlString = nil;
        NSDictionary *itemInfo = self.letaoGoodsDetailModel.data;
        if ([itemInfo isKindOfClass:[NSDictionary class]]) {
            picUrlString = itemInfo[@"item_image"];
        }
        NSString *item_image =  [picUrlString letaoConvertToHttpsUrl];
        if ([item_image isKindOfClass:[NSString class]]) {
            [self.letaoCycleScrollView.imageURLStringsGroup enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSString class]] && [[obj letaoConvertToHttpsUrl] isEqualToString:item_image]) {
                    [imageURLStringsGroup removeObject:obj];
                }
            }];
        }
        return  imageURLStringsGroup;
    }
    return @[].mutableCopy;
}

- (UIImage *)letaoConvertViewToImage:(UIView *)view size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)xingletaonetwork_requestAliAndJingDongGoodsURLDataIsAliCommandTextOnly:(BOOL)isAliCommandTextOnly {
    if (self.letaoGoodsDetailLogic == nil) {
        self.letaoGoodsDetailLogic = [[XLTGoodsDetailLogic alloc] init];
    }
    [self letaoShowClearBgLoading];
     __weak typeof(self)weakSelf = self;
    NSString *source =  [self letaoGoodsSourceParameters];
    BOOL isJindongSource = ([source isKindOfClass:[NSString class]] && [source isEqualToString:XLTJindongPlatformIndicate]);
    BOOL isPDDSource = ([source isKindOfClass:[NSString class]] && [source isEqualToString:XLTPDDPlatformIndicate]);
    BOOL isWPHSource = ([source isKindOfClass:[NSString class]] && [source isEqualToString:XLTVPHPlatformIndicate]);
    if (self.letaoBottomFooter.letaoIsAliSource) {
        [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsJumpUrlDataWithGoodsId:self.letaoGoodsId itemSource:[self letaoGoodsSourceParameters] isAliCommandTextOnly:isAliCommandTextOnly success:^(XLTBaseModel * _Nonnull model,BOOL isAliCommandTextOnly) {
            [weakSelf letaoRemoveLoading];
            NSDictionary *data = model.data;
            if ([data isKindOfClass:[NSDictionary class]]) {
                if ([XLTGoodsDetailLogic letaoIsNeedAliAuthorizationCode:model]) {
                    NSString *auth_url = data[@"auth_url"];
                    if ([auth_url isKindOfClass:[NSString class]]) {
                        [weakSelf letaoOpenAliTrandWithURLString:auth_url authorization:NO];
                    }
                } else {
                    self.letaoTKLShareCode = data[@"share_code"];
                    self.letaoTKLShareText = data[@"share_text"];
                    if (isAliCommandTextOnly) {
                        [weakSelf letaoCopyTaobaoPasteboardText];
                    } else {
                        NSString *click_url = data[@"click_url"];
                        NSString *item_url = data[@"item_url"];
                        NSString *position_id = data[@"position_id"];
                        if ([click_url isKindOfClass:[NSString class]] && click_url.length > 0) {
                            [weakSelf letaoOpenAliTrandWithURLString:click_url authorization:YES];
                        } else if([item_url isKindOfClass:[NSString class]] && item_url.length > 0){
                            [weakSelf letaoOpenAliTrandWithURLString:item_url authorization:YES];
                        }
                        //GoodsSource C:淘宝 B:天猫 D:京东
                        [[XLTRepoDataManager shareManager] repoTaobaoOrderAction:weakSelf.letaoParentPlateId childPlate:weakSelf.letaoCurrentPlateId goodId:weakSelf.letaoGoodsItemId item_source:self.letaoGoodsItemSource jump_link:item_url position_id:position_id model_type:@0];
                    }

                }
            }
   
           
        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf letaoRemoveLoading];
            [weakSelf showTipMessage:errorMsg];
        }];
    } else if (isJindongSource) {
        [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsJumpUrlDataWithGoodsId:self.letaoGoodsId itemSource:[self letaoGoodsSourceParameters] isAliCommandTextOnly:isAliCommandTextOnly success:^(XLTBaseModel * _Nonnull model,BOOL isAliCommandTextOnly) {
            [weakSelf letaoRemoveLoading];
            NSDictionary *itemInfo = model.data;
            if ([itemInfo isKindOfClass:[NSDictionary class]]) {
                NSString *click_url = itemInfo[@"click_url"];
                NSString *item_url = itemInfo[@"item_url"];
                NSString *position_id = itemInfo[@"position_id"];

                if ([click_url isKindOfClass:[NSString class]] && click_url.length > 0) {
                    [weakSelf letaoOpenKeplerWithUrlString:click_url];
                } else if([item_url isKindOfClass:[NSString class]] && item_url.length > 0){
                    [weakSelf letaoOpenKeplerWithUrlString:item_url];
                }
                //GoodsSource C:淘宝 B:天猫 D:京东
                [[XLTRepoDataManager shareManager] repoJingdongOrderAction:weakSelf.letaoParentPlateId childPlate:weakSelf.letaoCurrentPlateId goodId:weakSelf.letaoGoodsItemId item_source:self.letaoGoodsItemSource jump_link:item_url position_id:position_id model_type:@0];
            }

        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf letaoRemoveLoading];
            [weakSelf showTipMessage:errorMsg];
        }];
    } else if (isPDDSource || isWPHSource) {
        [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsJumpUrlDataWithGoodsId:self.letaoGoodsId itemSource:[self letaoGoodsSourceParameters] isAliCommandTextOnly:isAliCommandTextOnly success:^(XLTBaseModel * _Nonnull model,BOOL isAliCommandTextOnly) {
            [weakSelf letaoRemoveLoading];
            NSDictionary *itemInfo = model.data;
            if ([itemInfo isKindOfClass:[NSDictionary class]]) {
                NSString *click_url = itemInfo[@"click_url"];
                NSString *item_url = itemInfo[@"item_url"];
                if (isPDDSource) {
                    // 拼多多
                    if ([XLTGoodsDetailLogic letaoIsNeedPDDAuthorizationCode:model]) {
                        NSString *auth_url = model.data[@"auth_url"];
                        if ([auth_url isKindOfClass:[NSString class]]) {
                            [weakSelf letaoOpenPddWithUrlString:auth_url];
                        }
                    }else{
                        if ([click_url isKindOfClass:[NSString class]] && click_url.length > 0) {
                            [weakSelf letaoOpenPddWithUrlString:click_url];
                        } else if([item_url isKindOfClass:[NSString class]] && item_url.length > 0){
                            [weakSelf letaoOpenPddWithUrlString:item_url];
                        }
                    }
                    
                } else {
                    // 唯品会
                    NSString *nativeUrl = itemInfo[@"app_url"];
                    if ([click_url isKindOfClass:[NSString class]] && click_url.length > 0) {
                        [weakSelf letaoOpenWPHWithNativeUrl:nativeUrl itemUrl:click_url];
                    } else if([item_url isKindOfClass:[NSString class]] && item_url.length > 0){
                        [weakSelf letaoOpenWPHWithNativeUrl:nativeUrl itemUrl:item_url];
                    }
                }

            }
        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf letaoRemoveLoading];
            [weakSelf showTipMessage:errorMsg];
        }];
    } else {
        // 当前平台不支持 web打开
        [self.letaoGoodsDetailLogic xingletaonetwork_requestGoodsJumpUrlDataWithGoodsId:self.letaoGoodsId itemSource:[self letaoGoodsSourceParameters] isAliCommandTextOnly:isAliCommandTextOnly success:^(XLTBaseModel * _Nonnull model,BOOL isAliCommandTextOnly) {
            [weakSelf letaoRemoveLoading];
            NSDictionary *itemInfo = model.data;
            if ([itemInfo isKindOfClass:[NSDictionary class]]) {
                NSString *click_url = itemInfo[@"click_url"];
                NSString *item_url = itemInfo[@"item_url"];
                NSString *nativeUrl = itemInfo[@"app_url"];
                if ([click_url isKindOfClass:[NSString class]] && click_url.length > 0) {
                    [weakSelf webViewOpenApplicationWithNativeUrl:nativeUrl webUrl:click_url];
                } else if([item_url isKindOfClass:[NSString class]] && item_url.length > 0){
                    [weakSelf webViewOpenApplicationWithNativeUrl:nativeUrl webUrl:item_url];
                }
            }
        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf letaoRemoveLoading];
            [weakSelf showTipMessage:errorMsg];
        }];
    }
}

- (void)letaoOpenKeplerWithUrlString:(NSString *)url {
     [[XLTJingDongManager shareManager] openKeplerPageWithURL:url sourceController:self];
}

- (void)letaoOpenAliTrandWithURLString:(NSString *)url
                        authorization:(BOOL)authorization {
    [[XLTAliManager shareManager] openAliTrandPageWithURLString:url sourceController:self authorized:authorization];
}

- (void)letaoOpenPddWithUrlString:(NSString *)url {
    [[XLTPDDManager shareManager] openPDDPageWithURLString:url sourceController:self close:NO];
}


- (void)letaoOpenWPHWithNativeUrl:(NSString *)nativeUrl itemUrl:(NSString *)itemUrl {
    [[XLTWPHManager shareManager] openWPHPageWithNativeURLString:nativeUrl itemUrl:itemUrl sourceController:self];
}

- (void)letaoOpenWebUrl:(NSString *)webUrl {
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.shouldDecideGoodsActivity = NO;
    web.jump_URL = webUrl;
    [self.navigationController pushViewController:web animated:YES];
}



- (void)webViewOpenApplicationWithNativeUrl:(NSString *)nativeUrl webUrl:(NSString *)webUrl {
    if ([nativeUrl isKindOfClass:[NSString class]]
        && nativeUrl.length > 0
        && ![nativeUrl hasPrefix:@"http"]) {
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *openURL = [NSURL URLWithString:nativeUrl];
        if (@available(iOS 10.0, *)) {
            [application openURL:openURL options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    [self letaoOpenWebUrl:webUrl];
                }
            }];
        } else {
            // Fallback on earlier versions
            if ([application canOpenURL:openURL]) {
                [application openURL:openURL];
             } else {
                 [self letaoOpenWebUrl:webUrl];
            };
        }
    } else {
        [self letaoOpenWebUrl:webUrl];
    }
}

#pragma mark -  SharGoods

- (void)letaoSharGoodsAction {

}



- (void)letaoShowTKLAlert {
    XLTGoodsDetailTaobaoWordsPopVC *viewController = [[XLTGoodsDetailTaobaoWordsPopVC alloc] initWithNibName:@"XLTGoodsDetailTaobaoWordsPopVC" bundle:[NSBundle mainBundle]];
    viewController.view.hidden = YES;
    self.definesPresentationContext = YES;
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:viewController animated:NO completion:^{
        viewController.view.hidden = NO;
        viewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
        viewController.letaoBgView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
             viewController.letaoBgView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }];
    
    [[XLTRepoDataManager shareManager] repoCopyTKLAction:self.letaoParentPlateId childPlate:self.letaoCurrentPlateId goodId:self.letaoGoodsItemId item_source:self.letaoGoodsItemSource model_type:@0];
}
- (void )letaoGoStoreActionWith:(BOOL )lookAll{
    if (lookAll) {
        // 汇报事件
        NSDictionary *itemInfo = self.letaoGoodsDetailModel.data;
        NSMutableDictionary *properties = @{}.mutableCopy;
        properties[@"good_id"] = [SDRepoManager repoResultValue:itemInfo[@"_id"]];
        properties[@"good_name"] = [SDRepoManager repoResultValue:itemInfo[@"item_title"]];
        properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:itemInfo[@"item_source"]];
        NSArray *coupoArray = self.letaoPageDataArray[XLDGoodsDetailSectionType_Store];
        if ([coupoArray isKindOfClass:[NSArray class]]
            && [coupoArray.firstObject  isKindOfClass:[NSDictionary class]]) {
            NSDictionary *coupoInfo = coupoArray.firstObject;
            properties[@"xlt_item_shop_id"] = [SDRepoManager repoResultValue:coupoInfo[@"seller_shop_id"]];
            properties[@"xlt_item_shop_title"] = [SDRepoManager repoResultValue:coupoInfo[@"seller_shop_name"]];
            properties[@"xlt_item_shop_type"] = [SDRepoManager repoResultValue:coupoInfo[@"seller_type"]];
        }
        properties[@"xlt_item_firstcate_title"] = @"null";
        properties[@"xlt_item_thirdcate_title"] = @"null";
        properties[@"xlt_item_secondcate_title"] = @"null";
        [SDRepoManager xltrepo_trackEvent:XLT_EVENT_GOODDETAIL_LOOKALL properties:properties];
    }else{
        // 汇报事件
        NSDictionary *itemInfo = self.letaoGoodsDetailModel.data;
        NSMutableDictionary *properties = @{}.mutableCopy;
        properties[@"good_id"] = [SDRepoManager repoResultValue:itemInfo[@"_id"]];
        properties[@"good_name"] = [SDRepoManager repoResultValue:itemInfo[@"item_title"]];
        properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:itemInfo[@"item_source"]];
        NSArray *coupoArray = self.letaoPageDataArray[XLDGoodsDetailSectionType_Store];
        if ([coupoArray isKindOfClass:[NSArray class]]
            && [coupoArray.firstObject  isKindOfClass:[NSDictionary class]]) {
            NSDictionary *coupoInfo = coupoArray.firstObject;
            properties[@"xlt_item_shop_id"] = [SDRepoManager repoResultValue:coupoInfo[@"seller_shop_id"]];
            properties[@"xlt_item_shop_title"] = [SDRepoManager repoResultValue:coupoInfo[@"seller_shop_name"]];
            properties[@"xlt_item_shop_type"] = [SDRepoManager repoResultValue:coupoInfo[@"seller_type"]];
        }
        properties[@"xlt_item_firstcate_title"] = @"null";
        properties[@"xlt_item_thirdcate_title"] = @"null";
        properties[@"xlt_item_secondcate_title"] = @"null";
        [SDRepoManager xltrepo_trackEvent:XLT_EVENT_GOODDETAIL_SHOP properties:properties];
    }
    NSArray *sectionArray = self.letaoPageDataArray[XLDGoodsDetailSectionType_Store];
    NSDictionary *seller = sectionArray.firstObject;
    XLTStoreContainerVC *storeViewController = [[XLTStoreContainerVC alloc] init];
    NSString *letaoStoreId = nil;
    NSString *letaoStoreUrl = seller[@"seller_shop_url"];
//    NSString *itemSource = []
    if ([letaoStoreUrl isKindOfClass:[NSString class]] && [letaoStoreUrl containsString:@"http"]) {
        
        if ([self.letaoGoodsSource isEqualToString:XLTPDDPlatformIndicate]) {
            [[XLTPDDManager shareManager] openPDDPageWithURLString:letaoStoreUrl sourceController:self close:NO];
        }else {
            XLTWKWebViewController *vc = [[XLTWKWebViewController alloc] init];
            if ([self.letaoGoodsSource isEqualToString:XLTTaobaoPlatformIndicate]){
                vc.disableTbPddVphScheme = YES;
            }
            vc.jump_URL = letaoStoreUrl;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        if ([seller isKindOfClass:[NSDictionary class]]) {
            letaoStoreId = seller[@"seller_shop_id"];
        }
        storeViewController.letaoStoreId = letaoStoreId;
        storeViewController.letaoStoreDictionary = seller;
        [self.navigationController pushViewController:storeViewController animated:YES];
    }
    
    
    
    
}
- (void)letaoGoStoreAction {
    [self letaoGoStoreActionWith:YES];
}

- (void)letaoIsAddBrowsingHistory {
    if ([XLTUserManager shareManager].isLogined) {
        if (self.letaoGoodsDetailLogic == nil) {
            self.letaoGoodsDetailLogic = [[XLTGoodsDetailLogic alloc] init];
        }
        [self.letaoGoodsDetailLogic letaoIsAddBrowsingHistoWithId:self.letaoGoodsId itemSource:[self letaoGoodsSourceParameters]];
    }
}

- (void)letaoIsCoupon:(XLDGoodsCouponCollectionViewCell * )cell xingletaonetwork_requestCouponBtnClicked:(id)sender {
    // 汇报事件
    NSDictionary *itemInfo = self.letaoGoodsDetailModel.data;
    NSMutableDictionary *properties = @{}.mutableCopy;
    properties[@"good_id"] = [SDRepoManager repoResultValue:itemInfo[@"_id"]];
    properties[@"good_name"] = [SDRepoManager repoResultValue:itemInfo[@"item_title"]];
    properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:itemInfo[@"item_source"]];
    
    NSArray *coupoArray = self.letaoPageDataArray[XLDGoodsDetailSectionType_Coupon];
    if ([coupoArray isKindOfClass:[NSArray class]]
        && [coupoArray.firstObject  isKindOfClass:[NSDictionary class]]) {
        NSDictionary *coupoInfo = coupoArray.firstObject;
        properties[@"xlt_item_coupon_id"] = [SDRepoManager repoResultValue:coupoInfo[@"coupon_id"]];
        properties[@"xlt_item_coupon_amount"] = [SDRepoManager repoResultValue:coupoInfo[@"amount"]];

    }
    properties[@"xlt_item_firstcate_title"] = @"null";
    properties[@"xlt_item_thirdcate_title"] = @"null";
    properties[@"xlt_item_secondcate_title"] = @"null";
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_GOODDETAIL_COUPON properties:properties];
    
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    [self xingletaonetwork_requestAliAndJingDongGoodsURLDataIsAliCommandTextOnly:NO];
}

- (void)letaoIsQuestionButtonClicked {
    NSString *tipMessage = @"1、星乐桃返利为预估返利值，实际返利金额根据比例按下单支付金额进行计算\n\n2、部分红包和购物券会影响优惠\na. 不可返利的红包/卡券，包含且不仅限于以下几种，使用他们在星乐桃下单时整单没有返利！如：超级红包、天猫新人红包 、新人专享红包、新人福利社红包、淘礼金红包、淘红包、分享奖励红包、天猫购物券\n\nb. 可以返利的红包/卡券，卡券红包抵扣金额不能返利，该类型订单的返利，根据宝贝实际最终支付金额计算，如：店铺/商品优惠券、店铺红包 、类目购物券、旅行券等各种优惠券、购物津贴、淘金币、运费、税费（含报税商品)";
    XLTAlertViewController *alertViewController = [[XLTAlertViewController alloc] init];
    alertViewController.messageFont = [UIFont letaoRegularFontWithSize:12.0];
    [alertViewController letaoPresentWithSourceVC:[UIApplication sharedApplication].keyWindow.rootViewController title:@"返利规则" message:tipMessage sureButtonText:@"知道了" cancelButtonText:nil];

}

- (void)fetchEditorsRecommend {
    __weak __typeof(self)weakSelf = self;
    [XLTGoodsDetailLogic requestEditorsRecommendWithGoodsId:self.letaoGoodsId itemSource:[self letaoGoodsSourceParameters] success:^(XLTBaseModel * _Nonnull model) {
        if ([model.data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *info = model.data;
            NSString *recommend_text = info[@"recommend_text"];
            [weakSelf updateEditorsRecommend:recommend_text];
        }
    } failure:^(NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)updateEditorsRecommend:(NSString *)recommend_text{
    if ([recommend_text isKindOfClass:[NSString class]] && recommend_text.length > 0) {
        [self.letaoPageDataArray replaceObjectAtIndex:XLDGoodsDetailSectionType_EditorsRecommend withObject:@[recommend_text]];
        [self.collectionView reloadData];
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
