//
//  XLTStoreLogic.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTStoreLogic.h"

@implementation XLTStoreLogic
- (void)xingletaonetwork_requestStoreInfoWithStoreId:(NSString * _Nullable)letaoStoreId
                                          sellerType:(NSString *)sellerType
                                             success:(void(^)(NSDictionary *letaoStoreDictionary))success
                                             failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (letaoStoreId) {
        [parameters setObject:letaoStoreId forKey:@"seller_shop_id"];
    }
    if (sellerType) {
        [parameters setObject:sellerType forKey:@"item_source"];
    }
    [XLTNetworkHelper GET:kStoreInfoUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                success(model.data);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        } else {
            failure(Data_Error);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error);
    }];
}
@end
