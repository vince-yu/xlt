//
//  XLTGoodsSearchEmptyVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsSearchEmptyVC.h"
#import "XLTQRCodeScanLogic.h"
#import "XLTSearchLogic.h"
#import "XLTCouponSwitchView.h"
#import "XLTHomeCategoryGoodsCollectionViewCell.h"
#import "XLTGoodsDetailVC.h"
#import "XLTCustomSearchBar.h"
#import "XLTHomeSingleGoodsCollectionViewCell.h"
#import "UIView+Extension.h"
#import "SPButton.h"
#import "XLTNavigationController.h"
#import "LetaoEmptyCoverView.h"
#import "HMSegmentedControl.h"

@interface XLTGoodsSearchEmptyVC () <XLTCouponSwitchViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) XLTQRCodeScanLogic *letaoQRCodeLogic;
@property (nonatomic, strong) NSString *letaoGoodsId;
@property (nonatomic, strong) XLTSearchLogic *letaoSearchLogic;
@property (nonatomic, strong) NSMutableArray *letaoSearchTaskArray;

@property (nonatomic, strong) XLTCouponSwitchView *letaoCouponSwitchView;
@property(nonatomic, assign) BOOL letaoSwitchOn;
@property (nonatomic, assign) BOOL letaoDidDecodedGoods;

@property (nonatomic, strong) UIButton *emptyTipButton;
@property (nonatomic ,strong) UILabel *letaoEmptyLabel;
@property (nonatomic ,strong) UILabel *letaoBottomEmptyLabel;
@end

@implementation XLTGoodsSearchEmptyVC


- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self letaoSetupEmptyTipButton];
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.topFilterView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.topFilterView.frame));
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self letaoAdjustSortBtnStyle];
}


- (void)letaoFilterView:(XLTTopFilterView *)topFilterView didSelectedSortType:(XLTTopFilterSortType)type {
    if (self.letaoFristSortValueType != type) {
        if ([self.delegate respondsToSelector:@selector(goodsSearchEmptyVC:changedSortType:)]) {
            [self.delegate goodsSearchEmptyVC:self changedSortType:type];
        }
        XLTNavigationController *nav = (XLTNavigationController *)self.navigationController;
        if ([nav isKindOfClass:[XLTNavigationController class]]) {
            nav.swipeBackEnabled = YES;
        }
        [self.navigationController popViewControllerAnimated:NO];
        
    } else {
        if (type !=  self.letaoSortValueType) {
            self.letaoSortValueType = type;
            [self requestFristPageData];
        }
    }
}


- (void)letaoSegmentedValueChanged:(HMSegmentedControl *)segmentedControl {
    
    NSString *item_source = nil;
    if (self.letaoSegmentedControl.selectedSegmentIndex < self.supportGoodsPlatformCodeArray.count) {
        item_source = self.supportGoodsPlatformCodeArray[self.letaoSegmentedControl.selectedSegmentIndex];
        if (item_source) {
            if ([self.delegate respondsToSelector:@selector(goodsSearchEmptyVC:changedItemSource:)]) {
                [self.delegate goodsSearchEmptyVC:self changedItemSource:item_source];
            }
            XLTNavigationController *nav = (XLTNavigationController *)self.navigationController;
            if ([nav isKindOfClass:[XLTNavigationController class]]) {
                nav.swipeBackEnabled = YES;
            }
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
}

- (void)letaoFilterVC:(XLTRightFilterViewController *)filterViewController didChangeFilterData:(NSArray *)letaoFilterArray {
    // set filterInfo
    
    if ([self.delegate respondsToSelector:@selector(goodsSearchEmptyVC:changedFilterArray:)]) {
        [self.delegate goodsSearchEmptyVC:self changedFilterArray:letaoFilterArray];
    }
    XLTNavigationController *nav = (XLTNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[XLTNavigationController class]]) {
        nav.swipeBackEnabled = YES;
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)letaoCouponSwitchView:(XLTCouponSwitchView *)topFilterView didSwitchOn:(BOOL)isOn {
    if (self.letaoFristSwitchOn != isOn) {
        if ([self.delegate respondsToSelector:@selector(goodsSearchEmptyVC:changedSwitchOn:)]) {
            [self.delegate goodsSearchEmptyVC:self changedSwitchOn:isOn];
        }
        XLTNavigationController *nav = (XLTNavigationController *)self.navigationController;
        if ([nav isKindOfClass:[XLTNavigationController class]]) {
            nav.swipeBackEnabled = YES;
        }
        [self.navigationController popViewControllerAnimated:NO];
    } else {
           if (self.letaoSwitchOn != isOn) {
               self.letaoSwitchOn = isOn;
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

- (void)letaoSetupEmptyTipButton {
    if (self.emptyTipButton == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"xinletao_bang_red"] forState:UIControlStateNormal];
        [btn setTitle:@" 暂没找到相关商品，看看下面的推荐商品吧。" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont letaoRegularFontWithSize:13];
        [btn setTitleColor:[UIColor colorWithHex:0xFF25282D] forState:UIControlStateNormal];
        btn.frame = CGRectMake(15, CGRectGetMaxY(self.letaoCouponSwitchView.frame), kScreenWidth - 30, 44.0);
        [btn setBackgroundColor:[UIColor colorWithHex:0xFFF5F5F7]];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.emptyTipButton = btn;
    }
}
- (UILabel *)letaoEmptyLabel{
    if (!_letaoEmptyLabel) {
        _letaoEmptyLabel = [[UILabel alloc] init];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"您还可以精确搜索:"];
        _letaoEmptyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _letaoEmptyLabel.numberOfLines = 0;
        [attStr addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:13],NSForegroundColorAttributeName: [UIColor letaomainColorSkinColor]} range:NSMakeRange(0, 9)];
        
        _letaoEmptyLabel.attributedText = attStr;
    }
    return _letaoEmptyLabel;
}

- (UILabel *)letaoBottomEmptyLabel{
    if (!_letaoBottomEmptyLabel) {
        _letaoBottomEmptyLabel = [[UILabel alloc] init];
        _letaoBottomEmptyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _letaoBottomEmptyLabel.numberOfLines = 1;
        _letaoBottomEmptyLabel.adjustsFontSizeToFitWidth = YES;
        _letaoBottomEmptyLabel.textColor = [UIColor colorWithHex:0x25282D];
        _letaoBottomEmptyLabel.font = [UIFont letaoRegularFontWithSize:13.0];
        _letaoBottomEmptyLabel.minimumScaleFactor = 0.3;
        _letaoBottomEmptyLabel.text = @"复制淘宝、京东、拼多多、唯品会等商品链接/口令，打开星乐桃搜索";
    }
    return _letaoBottomEmptyLabel;
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
    __weak typeof(self)weakSelf = self;
    BOOL isVPHPlatform = ([self.item_source isKindOfClass:[NSString class]] && [self.item_source isEqualToString:XLTVPHPlatformIndicate]);
    BOOL hasCoupon = isVPHPlatform ? NO : self.letaoSwitchOn;
    NSURLSessionTask *sessionTask = [self.letaoSearchLogic letaorecommendGoodsWithIndex:index pageSize:pageSize sort:[self letaoSortValueTypeParameter] source:[self sourceParameter] postage:[self postageParameter] hasCoupon:hasCoupon letaoSearchText:self.letaoSearchText letaoGoodsId:self.letaoGoodsId startPrice:[self startPriceParameter] endPrice:[self endPriceParameter] success:^(NSArray * _Nonnull goodsArray, NSURLSessionTask * _Nonnull task) {
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    XLTNavigationController *nav = (XLTNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[XLTNavigationController class]]) {
        nav.swipeBackEnabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    XLTNavigationController *nav = (XLTNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[XLTNavigationController class]]) {
        nav.swipeBackEnabled = YES;
    }
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

#define kFilterHeaderViewIdentifier @"kFilterHeaderViewIdentifier"

- (void)letaoListRegisterCells {
    [self.collectionView  registerNib:[UINib nibWithNibName:@"XLTHomeSingleGoodsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTHomeSingleGoodsCollectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFilterHeaderViewIdentifier];

    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.letaoPageDataArray.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTHomeSingleGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTHomeSingleGoodsCollectionViewCell" forIndexPath:indexPath];
          NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];;
          [cell letaoUpdateCellDataWithInfo:itemInfo];
          return cell;

}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, 157);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 0) {
         if (kind == UICollectionElementKindSectionHeader) {
             UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFilterHeaderViewIdentifier forIndexPath:indexPath];
             
              // 优惠券
              BOOL showSwitch = [self canShowCouponSwitchView];
              if (self.letaoCouponSwitchView == nil) {
                  self.letaoCouponSwitchView = [[NSBundle mainBundle]loadNibNamed:@"XLTCouponSwitchView" owner:self options:nil].lastObject;
               }
             self.letaoCouponSwitchView.couponSwitch.on = self.letaoSwitchOn;
             self.letaoCouponSwitchView.delegate = self;
                  self.letaoCouponSwitchView.frame = !showSwitch  ? CGRectZero :CGRectMake(0, 0, headerView.bounds.size.width, 44);
             self.letaoCouponSwitchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
             self.letaoCouponSwitchView.hidden = !showSwitch;
             [headerView addSubview:self.letaoCouponSwitchView];
              
              [self letaoSetupEmptyTipButton];
              self.emptyTipButton.frame = CGRectMake(15, CGRectGetMaxY(self.letaoCouponSwitchView.frame), kScreenWidth - 30, 44.0);
              [headerView addSubview: self.emptyTipButton];
              self.letaoEmptyLabel.frame = CGRectMake(15, self.emptyTipButton.y + self.emptyTipButton.height - 5, kScreenWidth - 30, 13);
              [headerView addSubview:self.letaoEmptyLabel];
              self.letaoBottomEmptyLabel.frame = CGRectMake(15, self.letaoEmptyLabel.y + self.letaoEmptyLabel.height + 10, kScreenWidth - 30, 13);
              [headerView addSubview:self.letaoBottomEmptyLabel];
              return headerView;
         }
     }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if ([self canShowCouponSwitchView]) {
             return CGSizeMake(collectionView.bounds.size.width,  44 + 87);
        } else {
             return CGSizeMake(collectionView.bounds.size.width, 87);
        }
       
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
}



- (void)letaoDidClickedSearch {
    if ([self.delegate respondsToSelector:@selector(goodsSearchEmptyVC:changedItemSource:)]) {
        [self.delegate goodsSearchEmptyVC:self changedItemSource:self.item_source];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)letaoAdjustSortBtnStyle {
    self.topFilterView.letaoSortValueType = self.letaoSortValueType;
    [self.topFilterView letaoAdjustSortBtnStyle];
}


- (void)popBackAnimated:(BOOL)animated {
    if (self.navigationController.viewControllers.count >2) {
        XLTNavigationController *nav = (XLTNavigationController *)self.navigationController;
        if ([nav isKindOfClass:[XLTNavigationController class]]) {
            nav.swipeBackEnabled = YES;
        }
        NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
        [viewControllers removeLastObject];
        [viewControllers removeLastObject];
        [self.navigationController setViewControllers:viewControllers animated:animated];
    } else {
       XLTNavigationController *nav = (XLTNavigationController *)self.navigationController;
        if ([nav isKindOfClass:[XLTNavigationController class]]) {
            nav.swipeBackEnabled = YES;
        }
        [self.navigationController popViewControllerAnimated:animated];
    }
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
        if (self.navigationController.viewControllers.count >3) {
            NSUInteger index = self.navigationController.viewControllers.count -3;
             XLTBaseViewController *targetViewController = self.navigationController.viewControllers[index];
            [self letaoPopToViewController:targetViewController addParameters:@{@"kNearestTextFiledText":@""} animated:NO];
        } else {
            [self popBackAnimated:NO];
        }
       } else {
        [self popBackAnimated:NO];;
    }
    
   
    return NO;
}

/*

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    XLTNavigationController *nav = (XLTNavigationController *)self.navigationController;
     if ([nav isKindOfClass:[XLTNavigationController class]]) {
         nav.swipeBackEnabled = YES;
     }
    [self letaoPopViewControllerWithParameters:@{@"TextFiledFirstResponder":@1} animated:NO];

    return NO;
}*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
