//
//  XLTQRCodeScanLogic.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTQRCodeScanLogic.h"

@implementation XLTQRCodeScanLogic
- (NSURLSessionTask *)decodeResultForCodeText:(NSString*)codeText
                        success:(void(^)(XLTBaseModel *model))success
                        failure:(void(^)(NSString *errorMsg))failure {
    return [self decodeResultForCodeText:codeText is_serch:NO success:success failure:failure];
}

- (NSURLSessionTask *)decodeResultForCodeText:(NSString*)codeText
                                     is_serch:(BOOL) is_serch
                        success:(void(^)(XLTBaseModel *model))success
                        failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (codeText) {
        [parameters setObject:codeText forKey:@"code"];
    }
    if (is_serch) {
        [parameters setObject:@1 forKey:@"is_serch"];
    }
    return [XLTNetworkHelper POST:kDecodePasteboardGoodsUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            // 容错处理
            if (![model.data isKindOfClass:[NSDictionary class]]) {
                model.data = @{};
            }
            if ([model.data isKindOfClass:[NSDictionary class]]) {
                success(model);
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
