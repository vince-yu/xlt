//
//  XLTLogManager.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/8.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTLogManager.h"
#import "FCUUID.h"
#import "AFNetworkReachabilityManager.h"
#import "XLTUserManager.h"
#import "SSZipArchive.h"
#import "XLTUserManager.h"
#import "AFHTTPSessionManager.h"
#import "XLTNetCommonParametersModel.h"

// 日志保留最大天数
static const int kXLTLogMaxSaveDay = 3;
// 日志文件保存目录
static const NSString * kXLTLogFilePath = @"/Documents/XLTLog/";
// 日志压缩文件保存目录
static const NSString * kXLTLogZipFilePath = @"/Documents/XLTZIPLog/";

// 日志压缩包文件名
static NSString * kXLTZipFileName = @"XLTLog.zip";

@interface XLTLogManager ()

// 日期格式化
@property (nonatomic,retain) NSDateFormatter* dateFormatter;
// 时间格式化
@property (nonatomic,retain) NSDateFormatter* timeFormatter;
 
// 日志的目录路径
@property (nonatomic,copy) NSString* basePath;
// 日志的压缩文件目录路径
@property (nonatomic,copy) NSString* baseZipPath;


@property (nonatomic, strong, nonnull) dispatch_queue_t logWriteQueue;


// 基础信息
@property (nonatomic, copy) NSString *udid;
@property (nonatomic, copy) NSNumber *client_type;
@property (nonatomic, copy) NSString *client_version;
@property (nonatomic, copy) NSString *device;
@property (nonatomic, copy) NSString *os_version;


@property (nonatomic, copy) NSString *commonDeviceInfoString;

@end

@implementation XLTLogManager

/**
 * 获取单例实例
 *
 * @return 单例实例
 */
+ (instancetype) sharedInstance{
    static XLTLogManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
         instance = [[XLTLogManager alloc]init];
        }
    });
    return instance;
}
 
// 获取当前时间
+ (NSDate*)getCurrDate{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    return localeDate;
}

#pragma mark - Init
 
- (instancetype)init {
    self = [super init];
    if (self) {
        // 创建日期格式化
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        // 设置时区，解决8小时
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        self.dateFormatter = dateFormatter;
        
        // 创建时间格式化
        NSDateFormatter* timeFormatter = [[NSDateFormatter alloc]init];
        [timeFormatter setDateFormat:@"HH:mm:ss"];
        [timeFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        self.timeFormatter = timeFormatter;
        
        // 日志的目录路径
        self.basePath = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),kXLTLogFilePath];
        
        // 日志的目录路径
        self.baseZipPath = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),kXLTLogZipFilePath];
        
        
        _logWriteQueue = dispatch_queue_create("com.xlt.logCache", DISPATCH_QUEUE_SERIAL);
        
        

        _udid = [FCUUID uuidForDevice];
        _client_type = @3;
        _client_version = [[XLTAppPlatformManager shareManager] appVersion];
        _device =  [NSString stringWithFormat:@"APPLE %@",[[UIDevice currentDevice] model]];
        _os_version = [[UIDevice currentDevice] systemVersion];

        [self clearExpiredLog];
    }
    return self;
}
 
#pragma mark - Method


- (NSString *)commonInfoString {
    if (self.commonDeviceInfoString == nil) {
        self.commonDeviceInfoString = [NSString stringWithFormat:@"%@|%@|%@|%@|%@",_udid,_udid,_client_version,_device,_os_version];
    }
    NSString *uid = [XLTUserManager shareManager].curUserInfo._id;
    NSString *phone = [NSString stringWithFormat:@"%@",[XLTUserManager shareManager].curUserInfo.phone];
    NSNumber *net_type = [NSNumber numberWithInteger:[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus];

    return [NSString stringWithFormat:@"|%@|%@|%@|%@",self.commonDeviceInfoString,uid,phone,net_type];
}
 
/**
 * 写入网络请求日志
 *
 * @param url 请求地址
 * @param parameters 参数
 */


- (void)logNetRequestInfo:(NSString *)url parameters:(NSDictionary *)parameters {
    NSString *commonInfoString = [self commonInfoString];
    NSString *urlString = [NSString stringWithFormat:@"%@",url];
    NSString *parametersString = [NSString stringWithFormat:@"%@",[parameters modelToJSONString]];
    [self logInfo:@"NETRequestInfo" logStr:commonInfoString,urlString,parametersString,nil];
}



/**
* 写入网络请求结果日志
*
* @param url 请求地址
* @param response 返回接口
* @param error 返回错误
*/

- (void)logNetResponseInfo:(NSString *)url response:(NSDictionary * _Nullable )response error:(NSError * _Nullable )error {
    NSString *urlString = [NSString stringWithFormat:@"%@",url];
    // 首页日志太多了不写入了
    if ([url isEqualToString:kHomePagesLayoutUrl]) return;
    NSString *commonInfoString = [self commonInfoString];
    if (!error) {
        NSString *responseString = [NSString stringWithFormat:@"%@",[response modelToJSONString]];
        [self logInfo:@"NETResponseInfo" logStr:commonInfoString,urlString,responseString,nil];
    } else {
        NSString *errorString = [NSString stringWithFormat:@"%@",[error description]];
        [self logInfo:@"NETResponseInfo" logStr:commonInfoString,urlString,errorString,nil];
    }
    
}



 
/**
 * 写入日志
 *
 * @param module 模块名称
 * @param logStr 日志信息,动态参数
 */


- (void)logInfo:(NSString*)module logStr:(NSString*)logStr, ... {
    NSMutableString* parmaStr = [NSMutableString string];
    // 声明一个参数指针
    va_list paramList;
    // 获取参数地址，将paramList指向logStr
    va_start(paramList, logStr);
    id arg = logStr;
    @try {
        // 遍历参数列表
        while (arg) {
            [parmaStr appendString:arg];
            // 指向下一个参数，后面是参数类似
            arg = va_arg(paramList, NSString*);
        }
    } @catch (NSException *exception) {
        [parmaStr appendString:@"【记录日志异常】"];
    } @finally {
        // 将参数列表指针置空
        va_end(paramList);
        
    }
     
    // 异步执行
    dispatch_async(_logWriteQueue, ^{
        // 获取当前日期做为文件名
        NSString* fileName = [self.dateFormatter stringFromDate:[NSDate date]];
        NSString* filePath = [NSString stringWithFormat:@"%@%@",self.basePath,fileName];
        
        // [时间]-[模块]-日志内容
        NSString* timeStr = [self.timeFormatter stringFromDate:[XLTLogManager getCurrDate]];
        NSString* writeStr = [NSString stringWithFormat:@"[%@]-[%@]-%@\n",timeStr,module,parmaStr];
        
        // 写入数据
        [self writeFile:filePath stringData:writeStr];
    });
}
 
/**
 * 清空过期的日志
 */
- (void)clearExpiredLog {
    // 获取日志目录下的所有文件
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.basePath error:nil];
    for (NSString* file in files) {
        NSDate* date = [self.dateFormatter dateFromString:file];
        if (date) {
            NSTimeInterval oldTime = [date timeIntervalSince1970];
            NSTimeInterval currTime = [[XLTLogManager getCurrDate] timeIntervalSince1970];
            NSTimeInterval second = currTime - oldTime;
            int day = (int)second / (24 * 3600);
            if (day >= kXLTLogMaxSaveDay) {
                // 删除该文件
                [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",self.basePath,file] error:nil];
                NSLog(@"[%@]日志文件已被删除！",file);
            }
        }
    }
}

/**
 * 写入字符串到指定文件，默认追加内容
 *
 * @param filePath 文件路径
 * @param stringData 待写入的字符串
 */
- (void)writeFile:(NSString*)filePath stringData:(NSString*)stringData {
    // 待写入的数据
    NSData* writeData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
 
    // NSFileManager 用于处理文件
    BOOL createPathOk = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByDeletingLastPathComponent] isDirectory:&createPathOk]) {
        // 目录不存先创建
        [[NSFileManager defaultManager] createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        // 文件不存在，直接创建文件并写入
        [writeData writeToFile:filePath atomically:NO];
    } else {
        
        // NSFileHandle 用于处理文件内容
        // 读取文件到上下文，并且是更新模式
        NSFileHandle* fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        
        // 跳到文件末尾
        [fileHandler seekToEndOfFile];
        @try {
            // 追加数据
            [fileHandler writeData:writeData];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        // 关闭文件
        [fileHandler closeFile];
    }
}


 
/**
 * 处理上传日志
 *
 */
- (void)uploadLogWithInputText:(NSString * _Nullable)inputText
                       success:(void(^)(NSDictionary *info))success
                       failure:(void(^)(NSString *errorMsg))failure {
    // 先清理几天前的日志
    [self clearExpiredLog];
    // 压缩包文件路径
    NSString *zipFile = [self.baseZipPath stringByAppendingString:kXLTZipFileName];
    // 删除之前的压缩包
    if ([[NSFileManager defaultManager] fileExistsAtPath:zipFile]) {
        BOOL result = [[NSFileManager defaultManager] removeItemAtPath:zipFile error:nil];
        if (result) {
            NSLog(@"删除之前的压缩包");
        }
    }
    
    // NSFileManager 用于处理文件
    BOOL createPathOk = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[zipFile stringByDeletingLastPathComponent] isDirectory:&createPathOk]) {
        // 目录不存先创建
        [[NSFileManager defaultManager] createDirectoryAtPath:[zipFile stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    // 创建压缩文件
    if ([SSZipArchive createZipFileAtPath:zipFile withContentsOfDirectory:self.basePath]) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSURL *baseUrl = [NSURL URLWithString:[XLTAppPlatformManager shareManager].baseApiSeverUrl];
        AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
        [XLTNetworkHelper configSessionManager:sessionManager];
        sessionManager.requestSerializer.timeoutInterval = 60;

//        NSString *url = @"upload/file-txt";
        [parameters setObject:@"zip" forKey:@"save_type"];
        NSString *url = @"v2/feedback/upfile";
        parameters = [self commonParametersAdd:parameters URLString:url sessionManager:sessionManager];
        
        [sessionManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSError *error = nil;
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:zipFile] name:@"files" error:&error];
            (failure && error) ? failure(Data_Error) : nil;
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject != nil) {
                XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
                if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                    NSArray *fileArray = model.data;
                    success(fileArray.firstObject);
                }else {
                    failure(Data_Error);
                }
            } else {
                failure(Data_Error);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(Data_Error);
        }];
    } else {
        failure(@"日志信息压缩处理失败");
    }
}

- (NSMutableDictionary *)commonParametersAdd:(NSDictionary *)parameters URLString:(NSString *)URLString sessionManager:(AFHTTPSessionManager *)sessionManager {
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
    
    [XLTNetworkHelper generateSecrtetWithParameters:parameters path:urlPath sessionManager:sessionManager];

    return result;
}
 
@end
