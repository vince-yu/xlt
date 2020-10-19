//
//  XLTMallOrderLogic.h
//  XingLeTao
//
//  Created by chenhg on 2019/12/4.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTMallOrderLogic : XLTNetBaseLogic
+ (NSURLSessionDataTask *)genOrderWithGoodsId:(NSString *)goodsId
                                      payType:(NSString *)payType
                                      success:(void(^)(XLTBaseModel *model,NSURLSessionDataTask * task))success
                                      failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;
@end

NS_ASSUME_NONNULL_END
