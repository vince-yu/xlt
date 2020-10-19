//
//  XLTCollectVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/11.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTCollectVC.h"
#import "XLTHomeCustomHeadView.h"
#import "XLTHomeCustomHeadBgView.h"
#import "XLTCollectLogic.h"
#import "XLTGoodsDetailLogic.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "XLTCollectEmptyCollectionViewCell.h"
#import "XLTCollectLikeGoodsCollectionViewCell.h"
#import "XLTGoodsDetailVC.h"
#import "XLTCollectEditCollectionViewCell.h"
#import "Masonry.h"
#import "XLTCollectBottomView.h"
#import "XLTCollectMoneyCollectionViewCell.h"
#import "XLTCollectInvalidHeaderView.h"
#import "XLTCollectLikeHeaderView.h"
#import "NSNumber+XLTTenThousandsHelp.h"
#import "XLTGoodsDisplayHelp.h"
#import "AppDelegate.h"
#import "XLTCollectEditChooseCell.h"


@interface XLTCollectVC () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, XLTCollectEmptyCollectionViewCellDelegate, XLTCollectInvalidHeaderViewDelegate, XLTCollectEditCollectionViewCellDelegate,XLTCollectEditChooseDelegate>
@property (nonatomic, strong) XLTHomeCustomHeadBgView *letaoCustomNavBar;
@property (nonatomic, strong) UIView *customHeadMaskView;
@property (nonatomic, strong) UILabel *letaoCustomNavBarTitleLabel;
@property (nonatomic, strong) UIButton *letaoEditBtn;
@property (nonatomic, strong) XLTCollectLogic *letaoGoodsCollectLogic;
@property (nonatomic, strong) XLTGoodsDetailLogic *letaoGoodsDetailLogic;

@property (nonatomic, strong) NSMutableArray *letapSectionDataArray;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *letaoRefreshAutoFooter;
@property (nonatomic, strong) MJRefreshNormalHeader *letaoRefreshHeader;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL letaoIsEditState;
@property (nonatomic, assign) BOOL letaoIsAllEditState;
@property (nonatomic, strong) NSMutableDictionary *letaoEditSelectedDictionary;
@property (nonatomic, strong) XLTCollectBottomView *letaoBottomView;

@property (nonatomic, assign) NSInteger letaoCurrentPageIndex;
@property (nonatomic ,strong) NSDictionary *collectDataDic;
//下标0,1,2对应每个type数量，3对应选中type
@property (nonatomic ,strong) NSMutableArray *countArray;
@property (nonatomic ,assign) NSInteger selectType;
@end


typedef NS_ENUM(NSInteger, XLTCollectSectionType) {
    XLTCollectSectionEmptyType = 0,
    XLTCollectSectionFrugalType,
    XLTCollectSectionChooseType,
    XLTCollectSectionListType,
    XLTCollectSectionFailListType,
    XLTHomePagesSectionLikeType,
};



@implementation XLTCollectVC

#define kPageSize 10
#define kTheFirstPageIndex 1

- (instancetype)init {
    self = [super init];
    if (self) {
        self.letapSectionDataArray = [NSMutableArray array];
        for (int k =0; k <= XLTHomePagesSectionLikeType; k ++){
            [self.letapSectionDataArray addObject:@[].mutableCopy];
        }
        self.letaoEditSelectedDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectType = -1;
    // Do any additional setup after loading the view.
    [self letaoSetupCustomNavBarHeadView];
    [self letaoSetupContentCollectionView];
    [self letaoShowLoading];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    NSArray *likeArray = self.letapSectionDataArray[XLTHomePagesSectionLikeType];
    BOOL collectDataOnly = (likeArray.count > 0);
    [self requestCollectDataOnly:collectDataOnly];
}

- (void)requestCollectDataOnly:(BOOL)only {
    if (self.letaoGoodsCollectLogic == nil) {
        self.letaoGoodsCollectLogic = [[XLTCollectLogic alloc] init];
    }
    __weak typeof(self)weakSelf = self;
    [self.letaoGoodsCollectLogic xingletaonetwork_requestCollectDataSuccess:^(NSDictionary * _Nonnull collectInfo) {
        [weakSelf letaoRemoveLoading];
        [weakSelf letaoUpdateCollectDataWithDictionary:collectInfo];
        if (!only) {
            [weakSelf xingletaonetwork_requestGuessYouLikePageDataForIndex:kTheFirstPageIndex pageSize:kPageSize];
            [weakSelf.collectionView.mj_header endRefreshing];
        }
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf letaoRemoveLoading];
        [weakSelf showTipMessage:errorMsg];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}


- (void)letaoUpdateCollectDataWithDictionary:(NSDictionary *)collectInfo {
    self.collectDataDic = collectInfo;
//    self.selectType = -1;
    NSArray *list = collectInfo[@"list"];
    if (![list isKindOfClass:[NSArray class]]) {
        list = @[];
    }
    switch (self.selectType) {
        case 0:
        {
            NSArray *array = self.collectDataDic[@"expired"][@"list"];
            if ([array count]) {
                [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:array];
            }else{
                [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:@[]];
            }
            
        }
            break;
        case 1:
        {
            NSArray *array = self.collectDataDic[@"threeMonthsAgo"][@"list"];
            if ([array count]) {
                [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:array];
            }else{
                [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:@[]];
            }
        }
            break;
        case 2:
        {
            NSArray *array = self.collectDataDic[@"noCoupon"][@"list"];
            if ([array count]) {
                [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:array];
            }else{
                [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:@[]];
            }
        }
            break;
        default:
            [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:list];
            break;
    }
    

    NSArray *fail_list = collectInfo[@"fail_list"];
    if (![fail_list isKindOfClass:[NSArray class]]) {
        fail_list = @[];
    }
    [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionFailListType withObject:fail_list];
    
    NSNumber *frugal = collectInfo[@"frugal"];
    if ([frugal isKindOfClass:[NSNumber class]] && [frugal integerValue] > 0) {
        [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionFrugalType withObject:@[frugal]];

    } else {
        [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionFrugalType withObject:@[]];
    }
    BOOL haveCollectListData = ((fail_list.count + list.count) > 0);
    [self showMangerButton:haveCollectListData];
    if (haveCollectListData) {
        [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionEmptyType withObject:@[]];
    } else {
        [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionEmptyType withObject:@[[NSNull null]]];
        self.letaoIsEditState = NO;
    }
    self.letaoBottomView.hidden = !(self.letaoIsEditState && haveCollectListData);

    if (self.letaoIsAllEditState) {
        [self letaoMakeAllCollectToEdit];
    }
    [self letaoReloadData];
}





- (void)letaoUpdateYouLikeGoodsDataWithArray:(NSArray *)goodsArray {
    self.letaoRefreshAutoFooter.hidden = (goodsArray.count == 0);
    [self.letapSectionDataArray replaceObjectAtIndex:XLTHomePagesSectionLikeType withObject:goodsArray];
    [self letaoReloadData];
}


- (void)letaoAddMoreYouLikeGoodsDataWithArray:(NSArray *)goodsArray {
    NSArray *array = self.letapSectionDataArray[XLTHomePagesSectionLikeType];
    if ([array isKindOfClass:[NSArray class]]) {
        NSMutableArray *likeGoodsArray = array.mutableCopy;
        [likeGoodsArray addObjectsFromArray:goodsArray];
        [self.letapSectionDataArray replaceObjectAtIndex:XLTHomePagesSectionLikeType withObject:likeGoodsArray];
        self.letaoRefreshAutoFooter.hidden = (likeGoodsArray.count == 0);
        [self letaoReloadData];
    }

}


- (void)letaoSetupBottomView {
    if (self.letaoBottomView == nil) {
        self.letaoBottomView = [[NSBundle mainBundle]loadNibNamed:@"XLTCollectBottomView" owner:self options:nil].lastObject;
        self.letaoBottomView.frame = CGRectMake(0, self.view.bounds.size.height -65, self.view.bounds.size.width, 65);

        [self.view addSubview:self.letaoBottomView];
        
        [self.letaoBottomView.allSelectButton addTarget:self action:@selector(letaoSelectAllBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.letaoBottomView.deleteButton addTarget:self action:@selector(letaoDeleteCollectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    self.letaoBottomView.hidden = NO;
}

- (void)letaoRemoveBottomView {
    self.letaoBottomView.hidden = YES;
}


- (void)letaoSetupContentCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGRect rect = CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.height - 80);
    _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self letaoSetupRefreshAutoFooter];
    _collectionView.mj_footer = _letaoRefreshAutoFooter;
    _collectionView.mj_footer.hidden = YES;
    
    [self letaoSetupRefreshHeader];
    _collectionView.mj_header = _letaoRefreshHeader;
    
    [self letaoListRegisterCells];
    [self.view addSubview:_collectionView];
}

- (void)letaoSetupCustomNavBarHeadView {
    XLTHomeCustomHeadBgView *letaoTopHeadView = [[XLTHomeCustomHeadBgView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
    letaoTopHeadView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:letaoTopHeadView];
    self.letaoCustomNavBar = letaoTopHeadView;
    self.letaoCustomNavBar.letaoCircleImageView.hidden = YES;
    
    NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                           NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:18.0]
    };
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"我的收藏" attributes:dict];
    
    _letaoCustomNavBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, letaoTopHeadView.bounds.size.width, 44)];
    _letaoCustomNavBarTitleLabel.userInteractionEnabled = YES;
    _letaoCustomNavBarTitleLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    _letaoCustomNavBarTitleLabel.attributedText = title;
    _letaoCustomNavBarTitleLabel.textAlignment = NSTextAlignmentCenter;
    [letaoTopHeadView addSubview:_letaoCustomNavBarTitleLabel];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, kStatusBarHeight , 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"xinletao_nav_left_back_white"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(letaoPopVC) forControlEvents:UIControlEventTouchUpInside];
    [letaoTopHeadView addSubview:leftButton];
    
    //
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, kSafeAreaInsetsTop, letaoTopHeadView.bounds.size.width, letaoTopHeadView.bounds.size.height - kSafeAreaInsetsTop)];
    maskView.backgroundColor = self.view.backgroundColor;
    [letaoTopHeadView addSubview:maskView];
    self.customHeadMaskView = maskView;
}

- (void)letaoPopVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMangerButton:(BOOL)show {
    self.letaoEditBtn.hidden = !show;
    if (show) {
        if (_letaoEditBtn == nil) {
             _letaoEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _letaoEditBtn.frame = CGRectMake(self.letaoCustomNavBar.bounds.size.width -64, kStatusBarHeight, 44, 44);
            [self.letaoCustomNavBar addSubview:_letaoEditBtn];
            [_letaoEditBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_letaoEditBtn setTitle:@"管理" forState:UIControlStateNormal];
            _letaoEditBtn.titleLabel.font = [UIFont letaoRegularFontWithSize:16];
            [_letaoEditBtn addTarget:self action:@selector(letaoEditBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
         }
    }
    if (self.letaoIsEditState) {
        [self.letaoEditBtn setTitle:@"完成" forState:UIControlStateNormal];

    } else {
        [self.letaoEditBtn setTitle:@"管理" forState:UIControlStateNormal];
        self.selectType = -1;
    }
}



- (void)letaoEditBtnClicked:(UIButton *)managerButton {
    self.letaoIsEditState = !self.letaoIsEditState;
    if (self.letaoIsEditState) {
        [managerButton setTitle:@"完成" forState:UIControlStateNormal];
        if (![[self.letapSectionDataArray objectAtIndex:XLTCollectSectionEmptyType] count]){
            [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionChooseType withObject:@[@"1"]];
        }else{
            [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionChooseType withObject:@[]];
        }
    } else {
        [managerButton setTitle:@"管理" forState:UIControlStateNormal];
        self.letaoIsAllEditState = NO;
        self.letaoBottomView.allSelectButton.selected = self.letaoIsAllEditState;
        [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionChooseType withObject:@[]];
        
        NSArray *array = self.collectDataDic[@"list"];
        if ([array count]) {
            [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:array];
        }else{
            [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:@[]];
        }
        self.selectType = -1;
    }
    
    //clear
    [self.letaoEditSelectedDictionary removeAllObjects];
    [self letaoEditDictionaryValuesDidChanged];
    [self letaoReloadData];
    
    if ( self.letaoIsEditState) {
        [self letaoSetupBottomView];
    } else {
        [self letaoRemoveBottomView];
    }
}

- (void)letaoSelectAllBtnClicked {
    self.letaoIsAllEditState = !self.letaoIsAllEditState;
    if (self.letaoIsAllEditState) {
        [self letaoMakeAllCollectToEdit];
    } else {
        [self letaoMakeAllCollectToUnEdit];
    }
    self.letaoBottomView.allSelectButton.selected = self.letaoIsAllEditState;
    [self letaoReloadData];
}

- (void)letaoMakeAllCollectToEdit {
    [self.letaoEditSelectedDictionary removeAllObjects];
    NSMutableArray *collectArray = [NSMutableArray array];
    NSArray *list = self.letapSectionDataArray[XLTCollectSectionListType]; [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:list];

    NSArray *fail_list = self.letapSectionDataArray[XLTCollectSectionFailListType];
    [collectArray addObjectsFromArray:list];
    [collectArray addObjectsFromArray:fail_list];
    [collectArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *collectId = obj[@"_id"];
            if ([collectId isKindOfClass:[NSString class]]) {
                [self.letaoEditSelectedDictionary setObject:collectId forKey:collectId];
            }
        }
    }];
    [self letaoEditDictionaryValuesDidChanged];
}

- (void)letaoMakeAllCollectToUnEdit {
    [self.letaoEditSelectedDictionary removeAllObjects];
    [self letaoEditDictionaryValuesDidChanged];
}

- (BOOL)letaoIsCollectSelected:(NSDictionary *)item {
    if ([item isKindOfClass:[NSDictionary class]]) {
        NSString *itemId = item[@"_id"];
        if ([itemId isKindOfClass:[NSString class]]) {
            return (self.letaoEditSelectedDictionary[itemId] != nil);
        }
    }
    return NO;
}


- (void)letaoDeleteCollectBtnClicked {
    [self letaoShowLoading];
    __weak __typeof(self)weakSelf = self;
    NSArray *deleteIds = self.letaoEditSelectedDictionary.allKeys.copy;
    [self.letaoGoodsCollectLogic xingletaonetwork_cancelCollectsWithCollectIds:deleteIds success:^(XLTBaseModel * _Nonnull model) {
        [weakSelf showTipMessage:@"删除成功"];
        [weakSelf letaoRemoveLoading];
        [weakSelf letaoDidDeleteCollectsWithIdsArray:deleteIds];
        [weakSelf requestCollectDataOnly:YES];
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf showTipMessage:errorMsg];
        [weakSelf letaoRemoveLoading];
    }];
}


- (void)letaoSetupRefreshAutoFooter {
    if (_letaoRefreshAutoFooter == nil) {
        __weak __typeof(self)weakSelf = self;
        _letaoRefreshAutoFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf xingletaonetwork_requestGuessYouLikeNextPageData];
        }];
        _letaoRefreshAutoFooter.triggerAutomaticallyRefreshPercent = - 5.0;
        _letaoRefreshAutoFooter.autoTriggerTimes = -1;
        [_letaoRefreshAutoFooter setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
        _letaoRefreshAutoFooter.stateLabel.textColor = [UIColor colorWithHex:0xFFa9a9a9];
        _letaoRefreshAutoFooter.stateLabel.font = [UIFont letaoRegularFontWithSize:12.0];
    }
}
//
- (void)xingletaonetwork_requestGuessYouLikeNextPageData {
    NSInteger requestIndex = _letaoCurrentPageIndex +1;
    [self xingletaonetwork_requestGuessYouLikePageDataForIndex:requestIndex pageSize:kPageSize];
}

- (void)xingletaonetwork_requestGuessYouLikePageDataForIndex:(NSInteger)index
                                   pageSize:(NSInteger)pageSize {
    __weak __typeof(self)weakSelf = self;
    if (self.letaoGoodsCollectLogic == nil) {
        self.letaoGoodsCollectLogic = [[XLTCollectLogic alloc] init];
    }
    [self.letaoGoodsCollectLogic xingletaonetwork_requestYouLikeGoodsDataWithIndex:index pageSize:pageSize success:^(NSArray * _Nonnull goodsArray) {
        weakSelf.letaoCurrentPageIndex = index;
        if (index == kTheFirstPageIndex) {
            [self letaoUpdateYouLikeGoodsDataWithArray:goodsArray];
        } else {
            [self letaoAddMoreYouLikeGoodsDataWithArray:goodsArray];
        }
        if(goodsArray.count < pageSize) {
            [weakSelf.letaoRefreshAutoFooter endRefreshingWithNoMoreData];
        } else {
            [weakSelf.letaoRefreshAutoFooter endRefreshing];
        }
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf.letaoRefreshAutoFooter endRefreshing];
        [weakSelf showTipMessage:errorMsg];
    }];
}





- (void)letaoSetupRefreshHeader {
    if (_letaoRefreshHeader == nil) {
        __weak __typeof(self)weakSelf = self;
        _letaoRefreshHeader =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf letaoTriggerRefresh];
        }];
    }
}


- (void)letaoTriggerRefresh {
    [self requestCollectDataOnly:NO];
}

- (id)letaoSafeDataAtIndexPath:(NSIndexPath *)indexPath
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


#pragma mark - collectionView

- (void)letaoListRegisterCells {
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTCollectLikeGoodsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTCollectLikeGoodsCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTCollectEmptyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTCollectEmptyCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTCollectEditCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTCollectEditCollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTCollectMoneyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTCollectMoneyCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTCollectEditChooseCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTCollectEditChooseCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTCollectInvalidHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLTCollectInvalidHeaderView"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTCollectLikeHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLTCollectLikeHeaderView"];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return XLTHomePagesSectionLikeType +1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *sectionArray = self.letapSectionDataArray[section];
    if (section == XLTCollectSectionFrugalType) {
        
    }
    if ([sectionArray isKindOfClass:[NSArray class]]) {
       return sectionArray.count;
    } else {
       return 0;
    }
}



- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == XLTCollectSectionEmptyType) {
        XLTCollectEmptyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTCollectEmptyCollectionViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == XLTCollectSectionChooseType) {
        XLTCollectEditChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTCollectEditChooseCell" forIndexPath:indexPath];
        cell.delegate = self;
        NSInteger expireCount = [self.collectDataDic[@"expired"][@"list"] count];
        NSInteger threeMonthsAgoCount = [self.collectDataDic[@"threeMonthsAgo"][@"list"] count];
        NSInteger noCouponCount = [self.collectDataDic[@"noCoupon"][@"list"] count];
        cell.countArray = @[[NSNumber numberWithInt:expireCount],[NSNumber numberWithInt:threeMonthsAgoCount] ,[NSNumber numberWithInt:noCouponCount],@(self.selectType)];
        return cell;
    } else if (indexPath.section == XLTCollectSectionFrugalType) {
        XLTCollectMoneyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTCollectMoneyCollectionViewCell" forIndexPath:indexPath];
        
        NSNumber *saveMoney = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letapSectionDataArray];
        NSString *saveMoneyText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:saveMoney];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[saveMoneyText stringByAppendingString:@"元"]];

        [attributedString addAttributes:@{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:20],
                                          NSForegroundColorAttributeName : [UIColor colorWithHex:0xFFF34264]
        } range:NSMakeRange(0, saveMoneyText.length)];
        
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont letaoRegularFontWithSize:14],
                                          NSForegroundColorAttributeName : [UIColor colorWithHex:0xFF848487]
        } range:NSMakeRange(attributedString.length -1, 1)];
        cell.saveMoneyLabel.attributedText = attributedString;
        return cell;
    } else if (indexPath.section == XLTCollectSectionListType
               || indexPath.section == XLTCollectSectionFailListType) {
        XLTCollectEditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTCollectEditCollectionViewCell" forIndexPath:indexPath];
        NSDictionary *item = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letapSectionDataArray];
        BOOL isItemSelected = [self letaoIsCollectSelected:item];
        BOOL invalidgoods = (indexPath.section == XLTCollectSectionListType);
        [cell letaoUpdateCellDataWithInfo:item isSelected:isItemSelected startEdit:self.letaoIsEditState invalidgoods:invalidgoods];
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == XLTHomePagesSectionLikeType) {
        XLTCollectLikeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTCollectLikeGoodsCollectionViewCell" forIndexPath:indexPath];
        NSDictionary *item = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letapSectionDataArray];
        [cell letaoUpdateCellDataWithInfo:item];
        return cell;
       }
    return [UICollectionViewCell new];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == XLTCollectSectionFailListType) {
        if (kind == UICollectionElementKindSectionHeader) {
            XLTCollectInvalidHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLTCollectInvalidHeaderView" forIndexPath:indexPath];
            headerView.delegate = self;
            return headerView;
        }
    } else if (indexPath.section == XLTHomePagesSectionLikeType) {
        if (kind == UICollectionElementKindSectionHeader) {
            XLTCollectLikeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLTCollectLikeHeaderView" forIndexPath:indexPath];
            return headerView;
        }
    }
    
    return [UICollectionReusableView new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    NSArray *sectionArray = self.letapSectionDataArray[section];;
    if (sectionArray.count > 0){
        if (section == XLTCollectSectionFailListType) {
            return CGSizeMake(collectionView.bounds.size.width, 45);
        } else if (section == XLTHomePagesSectionLikeType) {
            return CGSizeMake(collectionView.bounds.size.width, 45);
        }
    }
    return CGSizeZero;
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == XLTCollectSectionEmptyType) {
         return CGSizeMake(collectionView.bounds.size.width, 207);
    } else if (indexPath.section == XLTCollectSectionFrugalType) {
        return CGSizeMake(collectionView.bounds.size.width, 75);
    }else if (indexPath.section == XLTCollectSectionChooseType) {
        return CGSizeMake(collectionView.bounds.size.width, 50);
    } else if (indexPath.section == XLTCollectSectionListType
                  || indexPath.section == XLTCollectSectionFailListType) {
        return CGSizeMake(collectionView.bounds.size.width, 157);
    }  else if (indexPath.section == XLTHomePagesSectionLikeType) {
        CGFloat offset = ceilf(((kScreenWidth -375)/39)*15);
        // 因为间距不是等比放大，调整一个修正量offset
        CGFloat height = kScreen_iPhone375Scale(340) - offset;
        return CGSizeMake(collectionView.bounds.size.width/2 -15, height);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSArray *sectionArray = self.letapSectionDataArray[section];
    if(sectionArray.count >0) {
        if (section == XLTHomePagesSectionLikeType) {
            return UIEdgeInsetsMake(0, 10, 0, 10);
        } else if (section == XLTCollectSectionFrugalType) {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        } else if (section == XLTCollectSectionListType) {
            if (self.letaoIsEditState) {
                return UIEdgeInsetsMake(0, 0, 10, 0);
            }else{
                return UIEdgeInsetsMake(10, 0, 10, 0);
            }
            
        } else if (section == XLTCollectSectionFailListType) {
            return UIEdgeInsetsMake(0, 0, 10, 0);
        } else if (section == XLTCollectSectionChooseType) {
            return UIEdgeInsetsMake(10, 0, 0, 0);
        }
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letapSectionDataArray];
    if (indexPath.section == XLTHomePagesSectionLikeType
        || indexPath.section == XLTCollectSectionListType
        || indexPath.section == XLTCollectSectionFailListType) {
        if (indexPath.section == XLTCollectSectionListType
            || indexPath.section == XLTCollectSectionFailListType) {
            NSDictionary *collectInfo = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letapSectionDataArray];
            if ([collectInfo isKindOfClass:[NSDictionary class]]) {
                itemInfo = collectInfo[@"goods"];

            }
        } else {
            itemInfo = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letapSectionDataArray];
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
            // 汇报事件
            if (indexPath.section == XLTHomePagesSectionLikeType) {
                [SDRepoManager xltrepo_trackGoodsSelectedWithInfo:itemInfo xlt_item_place:nil xlt_item_good_position:[NSNumber numberWithInteger:indexPath.row + 1]];
            }
        }
    }


}

- (void)letaoEmptyCollectCell:(XLTCollectEmptyCollectionViewCell *)cell goHomeAction:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]
        && [appDelegate.tabBar isKindOfClass:[XLTTabBarController class]]) {
        appDelegate.tabBar.selectedIndex = 0;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)letaoInvalidGoodsClearBtnClicked {
    [self letaoShowLoading];
    __weak typeof(self)weakSelf = self;
    [self.letaoGoodsCollectLogic xingletaonetwork_requestCancelInvalidGoodsSuccess:^(XLTBaseModel * _Nonnull model) {
        [weakSelf letaoRemoveLoading];
        [weakSelf.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionFailListType withObject:@[]];
        [weakSelf.collectionView reloadData];
        
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf showTipMessage:errorMsg];
         [weakSelf letaoRemoveLoading];
    }];
    
}

- (void)letaoEditCell:(XLTCollectEditCollectionViewCell *)cell
              collectId:(NSString *)collectId
     isCollectSelected:(BOOL)isCollectSelected {
    if ([collectId isKindOfClass:[NSString class]]) {
        if (isCollectSelected) {
            [self.letaoEditSelectedDictionary setValue:collectId forKey:collectId];
        } else {
            [self.letaoEditSelectedDictionary removeObjectForKey:collectId];
        }
    }
    [self letaoEditDictionaryValuesDidChanged];
    
    NSArray *list = self.letapSectionDataArray[XLTCollectSectionListType]; [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:list];

    NSArray *fail_list = self.letapSectionDataArray[XLTCollectSectionFailListType];
    NSInteger allItemCount = list.count + fail_list.count;
    self.letaoIsAllEditState = (allItemCount >0 && allItemCount == self.letaoEditSelectedDictionary.count);
    self.letaoBottomView.allSelectButton.selected = self.letaoIsAllEditState;
}

- (void)letaoEditDictionaryValuesDidChanged {
    self.letaoBottomView.deleteButton.enabled = self.letaoEditSelectedDictionary.count > 0;
}

- (void)letaoDidDeleteCollectsWithIdsArray:(NSArray *)deleteIds {
    
    NSArray *list = self.letapSectionDataArray[XLTCollectSectionListType]; [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:list];
    NSArray *fail_list = self.letapSectionDataArray[XLTCollectSectionFailListType];
    
    NSMutableArray *listArray = [list mutableCopy];
    NSMutableArray *fail_listArray = [fail_list mutableCopy];
    
    NSMutableArray *collectArray = [NSMutableArray array];
    [collectArray addObjectsFromArray:list];
    [collectArray addObjectsFromArray:fail_list];
    
    [deleteIds enumerateObjectsUsingBlock:^(NSString * _Nonnull deleteId, NSUInteger idx, BOOL * _Nonnull stop) {
        [collectArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *collectId = obj[@"_id"];
                if ([collectId isKindOfClass:[NSString class]]
                    && [collectId isEqualToString:deleteId]) {
                    [listArray removeObject:obj];
                    [fail_listArray removeObject:obj];
                }
            }
        }];
    }];
    
    [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:listArray];
    [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionFailListType withObject:fail_listArray];
    
    BOOL haveCollectListData = ((listArray.count + fail_listArray.count) > 0);
    if (!haveCollectListData) {
         self.letaoIsEditState = NO;
     }
    [self showMangerButton:haveCollectListData];
 
    if (haveCollectListData) {
        [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionEmptyType withObject:@[]];
    } else {
        [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionEmptyType withObject:@[[NSNull null]]];
        self.letaoIsEditState = NO;
    }
    self.letaoBottomView.hidden = !(self.letaoIsEditState && haveCollectListData);
    [self.letaoEditSelectedDictionary removeAllObjects];
    [self letaoEditDictionaryValuesDidChanged];
    
    [self letaoReloadData];
}

- (void)letaoReloadData {
    [self.collectionView reloadData];
    NSArray *list = self.letapSectionDataArray[XLTCollectSectionListType];
    [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:list];
    NSArray *fail_list = self.letapSectionDataArray[XLTCollectSectionFailListType];
    NSInteger collectCount = (list.count + fail_list.count);
    NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                           NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:18.0]
    };
    NSAttributedString *title = nil;
    if (collectCount > 0) {
        title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"我的收藏(%ld)",(long)collectCount] attributes:dict];
        self.letaoCustomNavBar.letaoCircleImageView.hidden = YES;
        self.customHeadMaskView.hidden = YES;
    } else {
        title = [[NSAttributedString alloc] initWithString:@"我的收藏" attributes:dict];
        self.letaoCustomNavBar.letaoCircleImageView.hidden = YES;
        self.customHeadMaskView.hidden = NO;
    }

    self.letaoCustomNavBarTitleLabel.attributedText = title;
    
    
}
#pragma mark - EditChooseCellDelegate
- (void)chooseType:(NSInteger)status{
    switch (status) {
        case 0:
        {
            NSArray *array = self.collectDataDic[@"expired"][@"list"];
            if ([array count]) {
                [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:array];
            }else{
                [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:@[]];
            }
            
        }
            break;
        case 1:
        {
            NSArray *array = self.collectDataDic[@"threeMonthsAgo"][@"list"];
            if ([array count]) {
                [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:array];
            }else{
                [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:@[]];
            }
        }
            break;
        case 2:
        {
            NSArray *array = self.collectDataDic[@"noCoupon"][@"list"];
            if ([array count]) {
                [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:array];
            }else{
                [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:@[]];
            }
        }
            break;
        default:
        {
            NSArray *array = self.collectDataDic[@"list"];
            if ([array count]) {
                [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:array];
            }else{
                [self.letapSectionDataArray replaceObjectAtIndex:XLTCollectSectionListType withObject:@[]];
            }
        }
            break;
    }
    self.selectType = status;
    [self.collectionView reloadData];
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
