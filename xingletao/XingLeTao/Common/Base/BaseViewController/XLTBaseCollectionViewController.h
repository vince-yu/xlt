//
//  XLTBaseCollectionViewController.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"
#import "XLTBaseListViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class LetaoEmptyCoverView;
@interface XLTBaseCollectionViewController : XLTBaseViewController <UICollectionViewDelegate, UICollectionViewDataSource>
// the CollectionView data array
@property (nonatomic, strong) NSMutableArray *letaoPageDataArray;
@property (nonatomic, readonly) UICollectionView *collectionView;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoEmptyCoverView;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;
@property (nonatomic, readonly) NSInteger currentPageIndex;

// clear letaoPageDataArray, reload contentTableView data, and back to the original state
- (void)clearPageData;

// requestFristPageData
- (void)requestFristPageData;

// requestNextPageData
- (void)requestNextPageData;

// registerTableViewCells should overwrite by sub class
- (void)letaoListRegisterCells;


// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                         failed:(XLTBaseListRequestFailed)failed;

- (NSInteger)pageSize;

- (NSInteger)theFirstPageIndex;

- (void)letaoShowEmptyView;

- (void)letaoRemoveEmptyView;

- (void)letaoShowErrorView;

- (void)letaoRemoveErrorView;

- (void)letaoTriggerRefresh;
@end

NS_ASSUME_NONNULL_END
