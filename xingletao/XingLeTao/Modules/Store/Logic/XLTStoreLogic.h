//
//  XLTStoreLogic.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTStoreLogic : XLTNetBaseLogic
- (void)xingletaonetwork_requestStoreInfoWithStoreId:(NSString * _Nullable)letaoStoreId
                                          sellerType:(NSString *)sellerType
                                             success:(void(^)(NSDictionary *letaoStoreDictionary))success
                                             failure:(void(^)(NSString *errorMsg))failure;
@end

NS_ASSUME_NONNULL_END
