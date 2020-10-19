//
//  XLTWKWebViewController+GoodsActivity.m
//  XingLeTao
//
//  Created by chenhg on 2020/4/22.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTWKWebViewController+GoodsActivity.h"
#import "XLTNetworkHelper.h"
#import "XLTBaseModel.h"
#import "XLTGoodsDetailVC.h"

@implementation XLTWKWebViewController (GoodsActivity)

- (BOOL)decideGoodsActivityPolicyForNavigationAction:(WKNavigationAction *)navigationAction {
    NSString *reqUrl = navigationAction.request.URL.absoluteString;
    return [self decideGoodsActivityPolicyForNavigationUrl:reqUrl];
}

/**
*  是否是金刚区商品活动NavigationUrl
*/
- (BOOL)decideGoodsActivityPolicyForNavigationUrl:(NSString *)reqUrl {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:reqUrl];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name) {
            parameters[obj.name] = obj.value;
        }
    }];
    __block BOOL isGoodsActivityNavigationUrl = NO;
    __weak typeof(self)weakSelf = self;
    // 是否是淘宝、天猫商品活动NavigationUrl
    [self fetchTBGoodsItemIdWithActivityNavigationUrl:reqUrl parameters:parameters completion:^(NSString * _Nullable itemId,BOOL success,NSString * _Nullable itemSource) {
        if (success && itemId) {
            isGoodsActivityNavigationUrl = YES;
            [weakSelf decideGoodsActivityPolicyForNavigationUrl:reqUrl itemId:itemId itemSource:itemSource];
        }
    }];
    // 是否是京东商品活动NavigationUrl
    if (!isGoodsActivityNavigationUrl) {
        [self fetchJDGoodsItemIdWithActivityNavigationUrl:reqUrl parameters:parameters completion:^(NSString * _Nullable itemId,BOOL success,NSString * _Nullable itemSource) {
            if (success && itemId) {
                isGoodsActivityNavigationUrl = YES;
                [weakSelf decideGoodsActivityPolicyForNavigationUrl:reqUrl itemId:itemId itemSource:itemSource];
            }
        }];
    }
    //  是否是拼多多商品活动NavigationUrl
    if (!isGoodsActivityNavigationUrl) {
        [self fetchPDDGoodsItemIdWithActivityNavigationUrl:reqUrl parameters:parameters completion:^(NSString * _Nullable itemId,BOOL success,NSString * _Nullable itemSource) {
            if (success && itemId) {
                isGoodsActivityNavigationUrl = YES;
                [weakSelf decideGoodsActivityPolicyForNavigationUrl:reqUrl itemId:itemId itemSource:itemSource];
            }
        }];
    }
    
    // 是否是唯品会商品活动NavigationUrl
    if (!isGoodsActivityNavigationUrl) {
        [self fetchWPHGoodsItemIdWithActivityNavigationUrl:reqUrl parameters:parameters completion:^(NSString * _Nullable itemId,BOOL success,NSString * _Nullable itemSource) {
            if (success && itemId) {
                isGoodsActivityNavigationUrl = YES;
                [weakSelf decideGoodsActivityPolicyForNavigationUrl:reqUrl itemId:itemId itemSource:itemSource];
            }
        }];
    }
    
    // 是否是苏宁商品活动NavigationUrl需要最后解析，
    if (!isGoodsActivityNavigationUrl) {
        [self fetchSuningGoodsItemIdWithActivityNavigationUrl:reqUrl parameters:parameters completion:^(NSString * _Nullable itemId,BOOL success,NSString * _Nullable itemSource) {
            if (success && itemId) {
                isGoodsActivityNavigationUrl = YES;
                [weakSelf decideGoodsActivityPolicyForNavigationUrl:reqUrl itemId:itemId itemSource:itemSource];
            }
        }];
    }
    
    return isGoodsActivityNavigationUrl;
}

/**
*  是否是淘宝、天猫商品活动NavigationUrl
*/
- (void)fetchTBGoodsItemIdWithActivityNavigationUrl:(NSString *)reqUrl
                                         parameters:(NSDictionary *)reqParameters
                                         completion:(void(^)(NSString * _Nullable itemId,BOOL success,NSString * _Nullable itemSource))completion {
    
    
    if ([reqUrl containsString:@"m.tb.cn"]
        || [reqUrl containsString:@"item.taobao.com"]
        || [reqUrl containsString:@"h5.m.taobao.com/awp/core/detail.htm"]
        || [reqUrl containsString:@"traveldetail.fliggy.com/item.htm"]) {
        NSString *itemId = reqParameters[@"id"];
        BOOL success = (itemId != nil);
        completion(itemId,success,XLTTaobaoPlatformIndicate);
    } else if ([reqUrl containsString:@"a.m.taobao.com/i"]) {
        NSString *regexStr = @"a.m.taobao.com/i(\\d+).htm";
        NSString *itemId  = [self arrayForRegex:regexStr string:reqUrl].lastObject;
        BOOL success = (itemId != nil);
        completion(itemId,success,XLTTaobaoPlatformIndicate);
    } else if ([reqUrl containsString:@"nmi.juhuasuan.com/market/ju/detail_wap.php"]
               || [reqUrl containsString:@"ju.taobao.com/m/jusp/alone/detailwap/mtp.htm"]) {
        NSString *itemId = reqParameters[@"item_id"];
        BOOL success = (itemId != nil);
        completion(itemId,success,XLTTaobaoPlatformIndicate);
    } else if ([reqUrl containsString:@"detail.m.tmall.com"]
                || [reqUrl containsString:@"detail.tmall.com"]
                || [reqUrl containsString:@"detail.tmall.hk/hk/item.htm"]) {
        NSString *itemId = reqParameters[@"id"];
        BOOL success = (itemId != nil);
        completion(itemId,success,XLTTianmaoPlatformIndicate);
    } else {
        completion(nil,NO,XLTTianmaoPlatformIndicate);
    }
}

/**
*  是否是京东商品活动NavigationUrl
*/
- (void)fetchJDGoodsItemIdWithActivityNavigationUrl:(NSString *)reqUrl
                                         parameters:(NSDictionary *)reqParameters
                                         completion:(void(^)(NSString * _Nullable itemId,BOOL success,NSString * _Nullable itemSource))completion {
    if ([reqUrl containsString:@"item.m.jd.com/product"] || [reqUrl containsString:@"item.jd.com"]) {
        NSString *regexStr = @"(\\d+).htm";
        NSString *itemId  = [self arrayForRegex:regexStr string:reqUrl].lastObject;
        BOOL success = (itemId != nil);
        completion(itemId,success,XLTJindongPlatformIndicate);
    } else if ([reqUrl containsString:@"item.m.jd.com"]) {
        NSString *itemId = reqParameters[@"wareId"];
        BOOL success = (itemId != nil);
        completion(itemId,success,XLTJindongPlatformIndicate);
    } else {
        completion(nil,NO,XLTJindongPlatformIndicate);
    }
}

/**
*  是否是拼多多商品活动NavigationUrl
*/

- (void)fetchPDDGoodsItemIdWithActivityNavigationUrl:(NSString *)reqUrl
                                          parameters:(NSDictionary *)reqParameters
                                          completion:(void(^)(NSString * _Nullable itemId,BOOL success,NSString * _Nullable itemSource))completion {
    if ([reqUrl containsString:@"mobile.yangkeduo.com/duo_coupon_landing.html"] || [reqUrl containsString:@"mobile.yangkeduo.com/goods"]) {
        NSString *itemId = reqParameters[@"goods_id"];
        BOOL success = (itemId != nil);
        completion(itemId,success,XLTPDDPlatformIndicate);
    } else if ([reqUrl containsString:@"mobile.yangkeduo.com/app.html"]) {
        NSString *launch_url = reqParameters[@"launch_url"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if ([launch_url isKindOfClass:[NSString class]]) {
            NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:launch_url];
            [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.name) {
                    parameters[obj.name] = obj.value;
                }
            }];
        }
        NSString *itemId = parameters[@"goods_id"];
        BOOL success = (itemId != nil);
        completion(itemId,success,XLTPDDPlatformIndicate);
    } else {
        completion(nil,NO,XLTPDDPlatformIndicate);
    }
}
/**
*  是否是唯品会商品活动NavigationUrl
*/

- (void)fetchWPHGoodsItemIdWithActivityNavigationUrl:(NSString *)reqUrl
                                          parameters:(NSDictionary *)reqParameters
                                          completion:(void(^)(NSString * _Nullable itemId,BOOL success,NSString * _Nullable itemSource))completion {
    if ([reqUrl containsString:@"click.union.vip.com/deeplink/showGoodsDetail"]) {
        NSString *itemId = reqParameters[@"pid"];
        BOOL success = (itemId != nil);
        completion(itemId,success,XLTVPHPlatformIndicate);
    } else if ([reqUrl containsString:@"m.vip.com/product"]) {
        NSString *regexStr = @"m.vip.com/product-(\\d+)-(\\d+).htm";
        NSString *itemId  = [self arrayForRegex:regexStr string:reqUrl].lastObject;
        BOOL success = (itemId != nil);
        completion(itemId,success,XLTVPHPlatformIndicate);
    } else {
        completion(nil,NO,XLTVPHPlatformIndicate);
    }
}



/**
*  是否是苏宁商品活动NavigationUrl
*/

- (void)fetchSuningGoodsItemIdWithActivityNavigationUrl:(NSString *)reqUrl
                                          parameters:(NSDictionary *)reqParameters
                                          completion:(void(^)(NSString * _Nullable itemId,BOOL success,NSString * _Nullable itemSource))completion {
    if ([reqUrl containsString:@"sumfs.suning.com/sumis-web/staticRes/web/pgWelfare/index.html"]) {
        NSString *vendorCode = reqParameters[@"supplierCode"];
        NSString *commodityCode = reqParameters[@"commodityCode"];
        BOOL success = (vendorCode != nil && commodityCode != nil);
        NSString *itemId  = [NSString stringWithFormat:@"%@-%@",vendorCode,commodityCode];
        completion(itemId,success,XLTSuNingPlatformIndicate);
    } else if ([reqUrl containsString:@"product.suning.com"]) {
        NSString *regexStr = @"product.suning.com/(\\d+)/(\\d+).htm";
        NSString *itemId  = nil;
        BOOL success = NO;
        NSArray *resultArray = [self arrayForRegex:regexStr string:reqUrl];
        if (resultArray.count > 2) {
            NSString *itemId1  = resultArray[1];
            NSString *itemId2  = resultArray[2];
            success = YES;
            itemId  = [NSString stringWithFormat:@"%@-%@",itemId1,itemId2];
        }
        completion(itemId,success,XLTSuNingPlatformIndicate);
    } else if ([reqUrl containsString:@"m.suning.com/product"]) {
        NSString *regexStr = @"m.suning.com/product/(\\d+)/(\\d+).htm";
        NSString *itemId  = nil;
        BOOL success = NO;
        NSArray *resultArray = [self arrayForRegex:regexStr string:reqUrl];
        if (resultArray.count > 2) {
            NSString *itemId1  = resultArray[1];
            NSString *itemId2  = resultArray[2];
            success = YES;
            itemId  = [NSString stringWithFormat:@"%@-%@",itemId1,itemId2];
        }
        completion(itemId,success,XLTSuNingPlatformIndicate);
    } else {
        completion(nil,NO,XLTSuNingPlatformIndicate);
    }
}


/**
*  处理商品活动NavigationUrl
*/

- (void)decideGoodsActivityPolicyForNavigationUrl:(NSString *)reqUrl itemId:(NSString *)itemId itemSource:(NSString *)itemSource {
    [self letaoShowLoading];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (itemId) {
        [parameters setObject:itemId forKey:@"item_id"];
    }
    if (itemSource) {
        [parameters setObject:itemSource forKey:@"item_source"];
    }
    __weak typeof(self)weakSelf = self;
    [XLTNetworkHelper GET:kGoodsDetailUrl parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
        XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
        if ([model isCorrectCode]
            && [model.data isKindOfClass:[NSDictionary class]]
            && model.data[@"_id"]) {
            NSString *letaoGoodsId = model.data[@"_id"];
            NSString *item_source = model.data[@"item_source"];
            if ([item_source isKindOfClass:[NSString class]] && item_source.length > 0) {
                [weakSelf jumpGoodsDetailWithGoodsId:letaoGoodsId itemId:itemId itemSource:item_source];;
            } else {
                [weakSelf jumpGoodsDetailWithGoodsId:letaoGoodsId itemId:itemId itemSource:itemSource];
            }
            
        } else {
            [weakSelf jumpWebWithURLStr:reqUrl];
        }
        [weakSelf letaoRemoveLoading];
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        [weakSelf letaoRemoveLoading];
        [self showTipMessage:Data_Error];
    }];
}

- (void)jumpWebWithURLStr:(NSString *)jump_URL {
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.shouldDecideGoodsActivity = NO;
    web.jump_URL = jump_URL;
    [self.navigationController pushViewController:web animated:YES];
}


- (void)jumpGoodsDetailWithGoodsId:(NSString *)letaoGoodsId  itemId:(NSString *)itemId itemSource:(NSString *)itemSource {
    XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
    goodDetailViewController.letaoGoodsId = letaoGoodsId;
    goodDetailViewController.letaoIsCustomPlate = NO;
    goodDetailViewController.letaoGoodsSource = itemSource;
    goodDetailViewController.letaoGoodsItemId = itemId;
    [self.navigationController pushViewController:goodDetailViewController animated:YES];
}


- (NSMutableArray *)arrayForRegex:(NSString *)regexString string:(NSString *)str {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matches = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    NSMutableArray *array = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        for (int i = 0; i < [match numberOfRanges]; i++) {
            NSString *component = [str substringWithRange:[match rangeAtIndex:i]];
            [array addObject:component];
        }
    }
    return array;
}
@end
