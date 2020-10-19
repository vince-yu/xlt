//
//  XLTGoodsEarnShareVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTGoodsEarnShareVC : XLTBaseViewController
@property (nonatomic, strong) UIImage *sharePosterImage;
@property (nonatomic, copy) NSString *shareCode;
@property (nonatomic, copy) NSString *shareText;
@property (nonatomic, assign) BOOL isAliSource;

@property (nonatomic, copy) NSDictionary *goodsInfo;
@property (nonatomic, strong) NSMutableArray *shareImageArray;
@end

NS_ASSUME_NONNULL_END
