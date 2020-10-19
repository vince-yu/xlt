//
//  XLTMallOrderLogic.m
//  XingLeTao
//
//  Created by chenhg on 2019/12/4.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTMallOrderLogic.h"

@implementation XLTMallOrderLogic

+ (NSURLSessionDataTask *)genOrderWithGoodsId:(NSString *)goodsId
                                      payType:(NSString *)payType
                                      success:(void(^)(XLTBaseModel *model,NSURLSessionDataTask * task))success
                                      failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (goodsId) {
        [parameters setObject:goodsId forKey:@"goods_id"];
    }
    if (payType) {
        [parameters setObject:payType forKey:@"pay_way"];
    }
    [parameters setObject:@"APP" forKey:@"trade_type"];
    
    return [XLTNetworkHelper POST:kMallGenOrderUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                success(model,task);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg,task);
            }
        } else {
            failure(Data_Error,task);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error,task);
    }];
}
@end
