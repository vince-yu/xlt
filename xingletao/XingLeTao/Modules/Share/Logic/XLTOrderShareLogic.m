//
//  XLTOrderShareLogic.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTOrderShareLogic.h"

@implementation XLTOrderShareLogic
//1微信好友 2QQ 3微博 4邀请链接
+ (void)xingletaonetwork_requestInviteCodeWithOrderId:(NSString * _Nullable)orderId
                           channel:(NSString * _Nullable)channel
                           success:(void(^)(NSDictionary *inviteInfo))success
                           failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (orderId) {
        [parameters setObject:orderId forKey:@"order_id"];
    }
    if (channel) {
        [parameters setObject:channel forKey:@"channel"];
    }
    [XLTNetworkHelper POST:kOrderShareInviteCodeUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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
