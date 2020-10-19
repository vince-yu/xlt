//
//  XLTWKWebViewController+GoodsActivity.h
//  XingLeTao
//
//  Created by chenhg on 2020/4/22.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTWKWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTWKWebViewController (GoodsActivity)

 /**
 *  处理商品活动NavigationUrl
 */
- (BOOL)decideGoodsActivityPolicyForNavigationAction:(WKNavigationAction *)navigationAction;

@end

NS_ASSUME_NONNULL_END
