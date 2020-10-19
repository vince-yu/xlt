//
//  XLTOrderListVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseCollectionViewController.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTOrderListVC : XLTBaseCollectionViewController <JXPagerViewListViewDelegate>

@property (nonatomic, copy, nullable) NSString *letaoYearMonthText;
@property (nonatomic, copy, nullable) NSString *letaoOrderSource;
@property (nonatomic, copy, nullable) NSNumber *status;
@property (nonatomic, copy, nullable) NSString *letaoSearchText;
@property (nonatomic, copy, nullable) NSString *retrieveOrderId;
@property (nonatomic, weak) UINavigationController *letaonavigationController;
@property (nonatomic, assign) BOOL isGroup;
@end

NS_ASSUME_NONNULL_END
