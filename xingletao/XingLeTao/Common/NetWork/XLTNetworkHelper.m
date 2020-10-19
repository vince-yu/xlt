//  ShopAnalytics
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019  . All rights reserved.
//


#import "XLTNetworkHelper.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "XLTNetCommonParametersModel.h"
#import "XLTURLConstant.h"
#import "NSString+XLTMD5.h"
#import "XLTURLConstant.h"
#import "XLTUserManager.h"
#import "XLTAppPlatformManager.h"
#import "FCUUID.h"
#import "XLTLogManager.h"
#import "XLTLocationManager.h"
#import <UTDID/UTDevice.h>


#ifdef DEBUG
#define XLTNetworkLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define XLTNetworkLog(...)
#endif

#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]


@interface XLTNetworkHelper ()

@property (nonatomic, strong) NSMutableDictionary *commonParameters; // 通用参数

@end


@implementation XLTNetworkHelper

static BOOL _isOpenLog;   // 是否已开启日志打印
static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;

#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(XLTNetworkStatus)networkStatus {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                networkStatus ? networkStatus(XLTNetworkStatusUnknown) : nil;
                if (_isOpenLog) XLTNetworkLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus ? networkStatus(XLTNetworkStatusNotReachable) : nil;
                if (_isOpenLog) XLTNetworkLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus ? networkStatus(XLTNetworkStatusReachableViaWWAN) : nil;
                if (_isOpenLog) XLTNetworkLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus ? networkStatus(XLTNetworkStatusReachableViaWiFi) : nil;
                if (_isOpenLog) XLTNetworkLog(@"WIFI");
                break;
        }
    }];

}

+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (void)openLog {
    _isOpenLog = YES;
}



+ (void)closeLog {
    _isOpenLog = NO;
}

+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        NSMutableArray *toCancelTask = [NSMutableArray array];
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [toCancelTask addObject:task];
//                *stop = YES;
            }
        }];
        [toCancelTask enumerateObjectsUsingBlock:^(NSURLSessionTask  *  _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
            [[self allSessionTask] removeObject:task];
        }];
    }
}

+ (void)cancelRequestWithPath:(NSString *)path {
    if (!path) { return; }
    @synchronized (self) {
         NSMutableArray *toCancelTask = [NSMutableArray array];
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.path rangeOfString:path].location != NSNotFound) {
                [toCancelTask addObject:task];
                // *stop = YES;
            }
        }];
        [toCancelTask enumerateObjectsUsingBlock:^(NSURLSessionTask  *  _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
            [[self allSessionTask] removeObject:task];
        }];
    }
}

#pragma mark - GET请求无缓存
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
                  success:(XLTHttpRequestSuccess)success
                  failure:(XLTHttpRequestFailed)failure {
    return [self GET:URL parameters:parameters responseCache:nil success:success failure:failure];
}

#pragma mark - POST请求无缓存
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
                   success:(XLTHttpRequestSuccess)success
                   failure:(XLTHttpRequestFailed)failure {
    return [self POST:URL parameters:parameters responseCache:nil success:success failure:failure];
}

#pragma mark - GET请求自动缓存
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
            responseCache:(XLTHttpRequestCache)responseCache
                  success:(XLTHttpRequestSuccess)success
                  failure:(XLTHttpRequestFailed)failure {
    // 设置commonParameters参数
    parameters =  [self commonParametersAdd:parameters URLString:URL];
    //读取缓存
    responseCache!=nil ? responseCache([XLTNetworkCache httpCacheForURL:URL parameters:parameters]) : nil;
    
    // 日志
    [[XLTLogManager sharedInstance] logNetRequestInfo:URL parameters:parameters];
    
    NSURLSessionTask *sessionTask = [_sessionManager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (_isOpenLog) {XLTNetworkLog(@"responseObject = %@",responseObject);}
        // GET只对当前记录的任务回调，已经移除的不在回调
        if ([[self allSessionTask] containsObject:task]) {
            [[self allSessionTask] removeObject:task];
            success ? success(responseObject,task) : nil;
            //对数据进行异步缓存
            responseCache!=nil ? [XLTNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
        }
        // 日志
        [[XLTLogManager sharedInstance] logNetResponseInfo:URL response:responseObject error:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (_isOpenLog) {XLTNetworkLog(@"error = %@",error);}
        // GET只对当前记录的任务回调，已经移除的不在回调
        if ([[self allSessionTask] containsObject:task]) {
            [[self allSessionTask] removeObject:task];
            failure ? failure(error,task) : nil;
        }
        // 日志
        [[XLTLogManager sharedInstance] logNetResponseInfo:URL response:nil error:error];
    }];
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - POST请求自动缓存
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
             responseCache:(XLTHttpRequestCache)responseCache
                   success:(XLTHttpRequestSuccess)success
                   failure:(XLTHttpRequestFailed)failure {
    // 设置commonParameters参数
    parameters =  [self commonParametersAdd:parameters URLString:URL];

    //读取缓存
    responseCache!=nil ? responseCache([XLTNetworkCache httpCacheForURL:URL parameters:parameters]) : nil;
    // 日志
    [[XLTLogManager sharedInstance] logNetRequestInfo:URL parameters:parameters];
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (_isOpenLog) {XLTNetworkLog(@"responseObject = %@",responseObject);}
        // POST只对当前记录的任务回调，已经移除的不在回调
        if ([[self allSessionTask] containsObject:task]) {
            [[self allSessionTask] removeObject:task];
            success ? success(responseObject,task) : nil;
            //对数据进行异步缓存
            responseCache!=nil ? [XLTNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
        }
        // 日志
        [[XLTLogManager sharedInstance] logNetResponseInfo:URL response:responseObject error:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (_isOpenLog) {XLTNetworkLog(@"error = %@",error);}
        // POST只对当前记录的任务回调，已经移除的不在回调
        if ([[self allSessionTask] containsObject:task]) {
            [[self allSessionTask] removeObject:task];
            failure ? failure(error,task) : nil;
        }
        // 日志
        [[XLTLogManager sharedInstance] logNetResponseInfo:URL response:nil error:error];
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

+ (NSDictionary *)commonParametersAdd:(NSDictionary *)parameters URLString:(NSString *)URLString {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        [result addEntriesFromDictionary:parameters];
    }
    NSURL *baseUrl = [[NSURL alloc] initWithString:[[XLTAppPlatformManager shareManager] baseApiSeverUrl]];
    NSURL *url = [NSURL URLWithString:URLString relativeToURL:baseUrl];
    NSString *urlPath = url.path;
    if ([urlPath hasPrefix:@"/"]) {
        urlPath = [urlPath substringFromIndex:1];
    }
   [self generateSecrtetWithParameters:parameters path:urlPath sessionManager:_sessionManager];

    /*
    NSDictionary *commonParameters=  [[XLTNetWorkCommonParametersModel defaultModel] modelToJSONObject];
    if ([commonParameters isKindOfClass:[NSDictionary class]]){
        [result addEntriesFromDictionary:commonParameters];
    }
    
    // 修正dev_type参数为dev-type
//    NSNumber *dev_type
    [result removeObjectForKey:@"dev_type"];
    
    NSString *sign = [self generateSecrtetWithParameters:result];
    if (sign) {
        [result setObject:sign forKey:@"sign"];
    } */
    return [result copy];
}

+ (NSString*)generateSecrtetWithParameters:(NSDictionary *)parameters path:(NSString *)path sessionManager:(AFHTTPSessionManager *)sessionManager {
//    if ([parameters isKindOfClass:[NSDictionary class]] && [parameters allValues].count > 0)
    {
        NSMutableString *resultStr  = [[NSMutableString alloc] initWithString:@""];
        NSArray *keys = [parameters allKeys];
        //排序
        NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        //拼接字符串
        for (NSString *key in sortedArray) {
            id object = [parameters objectForKey:key];
            if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) {
                if(((NSArray *)object).count > 0) {
                    NSString *json = [object modelToJSONString];
                    NSString *modelToJSONString =  [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    [resultStr appendFormat:@"%@=%@",key, modelToJSONString];
                }
            } else {
                [resultStr appendFormat:@"%@=%@",key, object];
            }
        }
        // 删除特殊字符
        
        resultStr = [resultStr letaomd5].mutableCopy;
        
        NSString *prefix = nil;
        if (resultStr.length > 5) {
            prefix = [NSString letaoSafeSubstring:resultStr toIndex:5];
        } else {
            prefix = [NSString stringWithFormat:@"%@",resultStr];
        }
        
        NSString *suffix = nil;
        if (resultStr.length > 5) {
            suffix = [NSString letaoSafeSubstring:resultStr fromReverseIndex:5];
        } else {
            suffix = [NSString stringWithFormat:@"%@",resultStr];
            
        }
        
        NSMutableString *signString = [NSMutableString string];
        [signString appendString:prefix];
        
        NSString *appID =  [[XLTNetCommonParametersModel defaultModel] appID];
        if (appID) {
            [signString appendString:appID];
        }
        if (path) {
            [signString appendString:path];
        }
        
        
        [signString appendString:resultStr];
        NSString *timestamp = [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]];
        [signString appendString:timestamp];
        [signString appendString:suffix];
        
        NSString *appKey =  [[XLTNetCommonParametersModel defaultModel] appKey];
        if (appKey) {
            [signString appendString:appKey];
        }
        //得到MD5 sign签名
        NSString *md5Sign = [signString letaomd5];
        
        
        if (md5Sign) {
            [sessionManager.requestSerializer setValue:md5Sign forHTTPHeaderField:@"x-sign"];
        }
        [sessionManager.requestSerializer setValue:timestamp forHTTPHeaderField:@"x-timestamp"];
        return md5Sign;
    }
//    return nil;
}


#pragma mark - 上传文件
+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                             parameters:(id)parameters
                                   name:(NSString *)name
                               filePath:(NSString *)filePath
                               progress:(XLTHttpProgress)progress
                                success:(XLTHttpRequestSuccess)success
                                failure:(XLTHttpRequestFailed)failure {
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:name error:&error];
        (failure && error) ? failure(error,nil) : nil;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (_isOpenLog) {XLTNetworkLog(@"responseObject = %@",responseObject);}
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject,task) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (_isOpenLog) {XLTNetworkLog(@"error = %@",error);}
        [[self allSessionTask] removeObject:task];
        failure ? failure(error,task) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 上传多张图片
+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                               parameters:(id)parameters
                                     name:(NSString *)name
                                   images:(NSArray<UIImage *> *)images
                                fileNames:(NSArray<NSString *> *)fileNames
                               imageScale:(CGFloat)imageScale
                                imageType:(NSString *)imageType
                                 progress:(XLTHttpProgress)progress
                                  success:(XLTHttpRequestSuccess)success
                                  failure:(XLTHttpRequestFailed)failure {
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSUInteger i = 0; i < images.count; i++) {
            // 图片经过等比压缩后得到的二进制文件
            NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale ?: 1.f);
            // 默认图片的文件名, 若fileNames为nil就使用
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *imageFileName = NSStringFormat(@"%@%lu.%@",str,(unsigned long)i,imageType?:@"jpg");
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:fileNames ? NSStringFormat(@"%@.%@",fileNames[i],imageType?:@"jpg") : imageFileName
                                    mimeType:NSStringFormat(@"image/%@",imageType ?: @"jpg")];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (_isOpenLog) {XLTNetworkLog(@"responseObject = %@",responseObject);}
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject,task) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (_isOpenLog) {XLTNetworkLog(@"error = %@",error);}
        [[self allSessionTask] removeObject:task];
        failure ? failure(error,task) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(XLTHttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(XLTHttpRequestFailed)failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    __block NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        if(failure && error) {failure(error,nil) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    //开始下载
    [downloadTask resume];
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
    
    return downloadTask;
}

/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

#pragma mark - 初始化AFHTTPSessionManager相关属性
/**
 开始监测网络状态
 */
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager
 *  原理参考地址:http://www.jianshu.com/p/5969bbb4af9f
 */
+ (void)initialize {
    NSURL *baseUrl = [[NSURL alloc] initWithString:[[XLTAppPlatformManager shareManager] baseApiSeverUrl]];
    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    [self configSessionManager:_sessionManager];
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

//    [XKDNetworkHelper openLog];
}


+ (void)configSessionManager:(AFHTTPSessionManager *)sessionManager {
    sessionManager.requestSerializer.timeoutInterval = NetWork_TimeoutInterval;
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    // 设置header
    NSInteger dev_type = [[XLTNetCommonParametersModel defaultModel] dev_type];
    NSInteger client_type = [[XLTNetCommonParametersModel defaultModel] client_type];
    [sessionManager.requestSerializer setValue:[[NSNumber numberWithInteger:dev_type] stringValue] forHTTPHeaderField:@"dev-type"];
    [sessionManager.requestSerializer setValue:[[NSNumber numberWithInteger:client_type] stringValue] forHTTPHeaderField:@"client-type"];
    NSString *version =  [XLTNetCommonParametersModel defaultModel].version;
    [sessionManager.requestSerializer setValue:version forHTTPHeaderField:@"client-v"];
    NSString *token = [XLTUserManager shareManager].curUserInfo.token;
    if (token) {
        // 设置token
        [sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    [sessionManager.requestSerializer setValue:@"1" forHTTPHeaderField:@"check-enable"];
    
    // udid
    
    NSString *udid =  [FCUUID uuidForDevice];
    if (udid) {
        [sessionManager.requestSerializer setValue:udid forHTTPHeaderField:@"x-m"];
    }
    
    NSString *appID =  [[XLTNetCommonParametersModel defaultModel] appID];
    if (appID) {
        [sessionManager.requestSerializer setValue:appID forHTTPHeaderField:@"x-appid"];
    }
    
    NSString *appName =  [[XLTNetCommonParametersModel defaultModel] appSource];
    if (appName) {
        [sessionManager.requestSerializer setValue:appName forHTTPHeaderField:@"x-app-source"];
    }
    [sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];

    NSString *utdid = [UTDevice utdid];
    if (utdid) {
        [sessionManager.requestSerializer setValue:utdid forHTTPHeaderField:@"x-utdid"];
    }
    // 设置位置信息
    // [[XLTLocationManager sharedInstance] updateAMapCoordinateHeaderForManager:sessionManager];
}


#pragma mark - 重置AFHTTPSessionManager相关属性

+ (void)setAFHTTPSessionManagerProperty:(void (^)(AFHTTPSessionManager *))sessionManager {
    sessionManager ? sessionManager(_sessionManager) : nil;
}

+ (void)setRequestSerializer:(XLTRequestSerializer)requestSerializer {
    _sessionManager.requestSerializer = requestSerializer==XLTRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)setResponseSerializer:(XLTResponseSerializer)responseSerializer {
    _sessionManager.responseSerializer = responseSerializer==XLTResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _sessionManager.requestSerializer.timeoutInterval = time;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)openNetworkActivityIndicator:(BOOL)open {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName {
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    [_sessionManager setSecurityPolicy:securityPolicy];
}


+ (void)setBaseUrl:(NSString *)baseUrl {
    if (baseUrl) {
        @try {
            [_sessionManager setValue:[NSURL URLWithString:baseUrl] forKey:@"baseURL"];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
}
@end


