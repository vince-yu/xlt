//
//  XLTHomeCategoryListVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/2.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseCollectionFilterViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface XLTHomeCategoryListVC : XLTBaseCollectionFilterViewController
@property (nonatomic, copy) NSString *letaoChannelId;
@property (nonatomic, copy) NSNumber *letaoChannelLevel;
@property (nonatomic, copy) NSString *channelName;

@property (nonatomic, assign) BOOL letaoIsHaveCategoryList;

@property (nonatomic, readonly) NSMutableArray *letaoAllTask;
- (void)letaoCancelAllTask;
- (NSString *)letaoSortValueTypeParameter;

- (NSString *)sourceParameter;

- (NSNumber *)postageParameter;

- (void)pagerViewScrolToTop;
@end

NS_ASSUME_NONNULL_END
