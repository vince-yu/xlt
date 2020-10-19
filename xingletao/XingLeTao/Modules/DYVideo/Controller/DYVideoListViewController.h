//
//  DYVideoListViewController.h
//  XingLeTao
//
//  Created by chenhg on 2020/4/26.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseCollectionViewController.h"
#import "DYVideoContainerViewController.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYVideoListViewController : XLTBaseCollectionViewController<JXPagerViewListViewDelegate>
@property (nonatomic ,copy) NSString *cid;
@property (nonatomic ,weak) UINavigationController *xlt_navigationController;
@end

NS_ASSUME_NONNULL_END
