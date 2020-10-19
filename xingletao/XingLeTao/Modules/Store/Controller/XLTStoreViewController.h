//
//  XLTStoreViewController.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomeCategoryListVC.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTStoreViewController : XLTHomeCategoryListVC <JXPagerViewListViewDelegate>
@property (nonatomic, copy) NSString *letaoStoreId;
@property (nonatomic, copy) NSString *letaoStoreSource;
@property (nonatomic, weak) UINavigationController *letaonavigationController;
@end

NS_ASSUME_NONNULL_END
