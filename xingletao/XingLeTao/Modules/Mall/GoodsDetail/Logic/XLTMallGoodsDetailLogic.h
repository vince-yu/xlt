//
//  XLTMallGoodsDetailLogic.h
//  XingLeTao
//
//  Created by chenhg on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTMallGoodsDetailLogic : XLTNetBaseLogic
// 商品详情数据
+ (void)fetchGoodsDetailWithGoodsId:(NSString * _Nullable)goodsId
                            success:(void(^)(XLTBaseModel *goodsDetail))success
                            failure:(void(^)(NSString *errorMsg))failure;
@end

NS_ASSUME_NONNULL_END
