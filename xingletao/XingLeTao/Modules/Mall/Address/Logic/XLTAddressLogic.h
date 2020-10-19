//
//  XLTAddressLogic.h
//  XingLeTao
//
//  Created by chenhg on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTAddressLogic : XLTNetBaseLogic
+ (NSURLSessionDataTask *)fetchAddressInfoSuccess:(void(^)(XLTBaseModel *goodsDetail,NSURLSessionDataTask * task))success
                        failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;
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
                                         failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;
@end

NS_ASSUME_NONNULL_END
