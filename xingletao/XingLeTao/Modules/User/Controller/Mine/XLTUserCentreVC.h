//
//  XLTUserCentreVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/9/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserCentreVC : XLTBaseViewController <JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>
@property (nonatomic, strong) JXPagerView *pagerView;

//@property (nonatomic, strong) PagingViewTableHeaderView *userHeaderView;
//@property (nonatomic, strong, readonly) JXCategoryTitleView *categoryView;
@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;

- (JXPagerView *)preferredPagingView;
- (void)pagerViewScrolToTop;
@end

NS_ASSUME_NONNULL_END
