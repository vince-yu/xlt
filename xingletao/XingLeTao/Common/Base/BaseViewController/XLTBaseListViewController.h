//
//  QQWBaseListViewController.h
//  ShopAnalytics
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019  . All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 请求成功的Block
typedef void(^XLTBaseListRequestSuccess)(NSArray * _Nullable letaoPageDataArray);

/// 请求失败的Block
typedef void(^XLTBaseListRequestFailed)(NSError * _Nullable error, NSString * _Nullable tipMessage);

@class LetaoEmptyCoverView;
@interface XLTBaseListViewController : XLTBaseViewController <UITableViewDelegate, UITableViewDataSource>

// the tableview data array
@property (nonatomic, strong) NSMutableArray *letaoPageDataArray;
@property (nonatomic, readonly) UITableView *contentTableView;
// default is UITableViewStyleGrouped
@property (nonatomic, assign) UITableViewStyle contentTableViewStyle;
@property (nonatomic, readonly) LetaoEmptyCoverView *letaoEmptyCoverView;
@property (nonatomic, readonly) LetaoEmptyCoverView *letaoErrorView;


// clear letaoPageDataArray, reload contentTableView data, and back to the original state
- (void)clearPageData;

// requestFristPageData
- (void)requestFristPageData;

// requestNextPageData
- (void)requestNextPageData;

// registerTableViewCells should overwrite by sub class
- (void)registerTableViewCells;


// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                         failed:(XLTBaseListRequestFailed)failed;

- (NSInteger)pageSize;

- (NSInteger)theFirstPageIndex;

- (void)letaoShowEmptyView;
- (void)letaoRemoveEmptyView;
- (void)letaoTriggerRefresh;

- (void)letaoShowErrorView;
@end

NS_ASSUME_NONNULL_END
