//
//  XLTBaseCollectionFilterViewController.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/4.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseCollectionViewController.h"
#import "XLTTopFilterView.h"
#import "XLTRightFilterViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTBaseCollectionFilterViewController : XLTBaseCollectionViewController <XLTTopFilterViewDelegate, XLTRightFilterViewControllerDelegate>
@property (nonatomic, assign) XLTTopFilterSortType letaoSortValueType;
@property (nonatomic, strong) NSArray *letaoFilterArray;
@property (nonatomic, strong) XLTTopFilterView *topFilterView;
@end

NS_ASSUME_NONNULL_END
