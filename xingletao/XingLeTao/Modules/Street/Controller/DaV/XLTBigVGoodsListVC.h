//
//  XLTBigVGoodsListViewController.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomeCategoryListVC.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTBigVGoodsListVC : XLTHomeCategoryListVC <JXPagerViewListViewDelegate>
@property (nonatomic, copy) NSString *daVId;
@property (nonatomic, weak) UINavigationController *letaonavigationController;
@property (nonatomic, copy) NSString *letaoParentPlateId;

@end

NS_ASSUME_NONNULL_END
