//
//  XLTAddressLogic.m
//  XingLeTao
//
//  Created by chenhg on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTAddressLogic.h"

@implementation XLTAddressLogic
+ (NSURLSessionDataTask *)fetchAddressInfoSuccess:(void(^)(XLTBaseModel *goodsDetail,NSURLSessionDataTask * task))success
                        failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    return [XLTNetworkHelper GET:kAddressListUrl parameters:nil success:^(id responseObject,NSURLSessionDataTask * task) {
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


+ (NSURLSessionDataTask *)addAddressInfoWithName:(NSString *)name
                         phone:(NSString *)phone
                 province_name:(NSString *)province_name
                   province_id:(NSString *)province_id
city_name:(NSString *)city_name
                     city_code:(NSString *)city_code
                   county_name:(NSString *)county_name
                   county_code:(NSString *)county_code
                        sketch:(NSString *)sketch
    success:(void(^)(XLTBaseModel *goodsDetail,NSURLSessionDataTask * task))success
                        failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (name) {
        [parameters setObject:name forKey:@"name"];
    }
    if (phone) {
        [parameters setObject:phone forKey:@"phone"];
    }
    if (province_name) {
        [parameters setObject:province_name forKey:@"province_name"];
    }
    if (province_id) {
        [parameters setObject:province_id forKey:@"province_id"];
    }
    if (city_name) {
        [parameters setObject:city_name forKey:@"city_name"];
    }
    if (city_code) {
        [parameters setObject:city_code forKey:@"city_code"];
    }
    if (county_name) {
        [parameters setObject:county_name forKey:@"county_name"];
    }
    if (county_code) {
        [parameters setObject:county_code forKey:@"county_code"];
    }
    if (sketch) {
        [parameters setObject:sketch forKey:@"sketch"];
    }
    
    return [XLTNetworkHelper POST:kAddAddressUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
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
