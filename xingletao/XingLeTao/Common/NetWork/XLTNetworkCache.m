//  ShopAnalytics
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019  . All rights reserved.
//

#import "XLTNetworkCache.h"
#import "YYCache.h"

static NSString *const kXLTNetworkResponseCache = @"kXLTNetworkResponseCache";

@implementation XLTNetworkCache
static YYCache *_dataCache;

+ (void)initialize {
    static NSString *appVersion = nil;
    if (appVersion == nil) {
        appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
    _dataCache = [YYCache cacheWithName:[NSString stringWithFormat:@"%@_%@",kXLTNetworkResponseCache,appVersion]];
}

+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)parameters {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:httpData forKey:cacheKey withBlock:nil];
}

+ (id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    return [_dataCache objectForKey:cacheKey];
}

+ (NSInteger)getAllHttpCacheSize {
    return [_dataCache.diskCache totalCost];
}

+ (void)removeAllHttpCache {
    [_dataCache.diskCache removeAllObjects];
}

+ (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    if(!parameters || parameters.count == 0){return URL;};
    // 将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];    
    return [NSString stringWithFormat:@"%@%@",URL,paraString];
}


@end

