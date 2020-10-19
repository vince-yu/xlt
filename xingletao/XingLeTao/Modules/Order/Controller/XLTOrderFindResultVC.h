//
//  XLTOrderFindResultVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"
#import "XLTBaseCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTOrderFindResultVC : XLTBaseCollectionViewController
@property (nonatomic, copy) NSString *letaoSearchText;
@property (nonatomic, assign) BOOL isGroup;
@end

NS_ASSUME_NONNULL_END
