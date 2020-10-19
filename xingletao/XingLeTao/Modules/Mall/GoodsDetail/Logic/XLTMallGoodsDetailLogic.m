//
//  XLTMallGoodsDetailLogic.m
//  XingLeTao
//
//  Created by chenhg on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTMallGoodsDetailLogic.h"

@implementation XLTMallGoodsDetailLogic
// 商品详情数据
+ (void)fetchGoodsDetailWithGoodsId:(NSString * _Nullable)goodsId
                            success:(void(^)(XLTBaseModel *goodsDetail))success
                            failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (goodsId) {
        [parameters setObject:goodsId forKey:@"_id"];
    }
    
    [XLTNetworkHelper GET:kMallGoodsDetailUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
//            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
//                success(model);
//            } else {
//                NSString *msg = model.message;
//                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
//                    msg = Data_Error;
//                }
//                failure(msg);
//            }
            success(model);
        } else {
            failure(Data_Error);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error);
    }];
}
@end
