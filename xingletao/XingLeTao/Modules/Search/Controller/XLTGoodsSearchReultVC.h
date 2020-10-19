//
//  XLTGoodsSearchReultVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomePlateFilterListVC.h"

NS_ASSUME_NONNULL_BEGIN

@class XLTCustomSearchBarTwo,HMSegmentedControl;
@interface XLTGoodsSearchReultVC : XLTBaseCollectionFilterViewController

@property (nonatomic, copy) NSString *letaoSearchText;
@property (nonatomic, copy) NSString *pasteboardSearchText;
// 商品来源
@property (nonatomic, copy) NSString *item_source;
@property (nonatomic ,copy) NSString *searchType;

@property (nonatomic, readonly) HMSegmentedControl *letaoSegmentedControl;
@property (nonatomic, readonly) NSMutableArray *supportGoodsPlatformNameArray;
@property (nonatomic, readonly) NSMutableArray *supportGoodsPlatformCodeArray;

@property (nonatomic, strong) XLTCustomSearchBarTwo *letaoCustomSearchBar;
- (BOOL)canShowCouponSwitchView;
@end

NS_ASSUME_NONNULL_END
