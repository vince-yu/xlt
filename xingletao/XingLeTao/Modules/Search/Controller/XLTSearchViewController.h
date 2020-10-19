//
//  XLTSearchViewController.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTSearchViewController : XLTBaseViewController

@property (nonatomic, copy) NSString *letaoPasteboardSearchText;

@property (nonatomic, copy) NSString *letaoSearchText;

// 商品来源
@property (nonatomic, copy) NSString *item_source;

- (void)letaoSaveSearchTextAndRefreshView:(NSString *)searchText;

@end

NS_ASSUME_NONNULL_END
