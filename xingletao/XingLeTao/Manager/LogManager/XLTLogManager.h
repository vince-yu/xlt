//
//  XLTLogManager.h
//  XingLeTao
//
//  Created by chenhg on 2020/5/8.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTLogManager : NSObject
 
/**
 * 获取单例实例
 *
 * @return 单例实例
 */
+ (instancetype) sharedInstance;
  

 
/**
 * 写入网络请求日志
 *
 * @param url 请求地址
 * @param parameters 参数
 */


- (void)logNetRequestInfo:(NSString *)url parameters:(NSDictionary *)parameters;



/**
* 写入网络请求结果日志
*
* @param url 请求地址
* @param response 返回接口
* @param error 返回错误
*/

- (void)logNetResponseInfo:(NSString *)url response:(NSDictionary * _Nullable )response error:(NSError * _Nullable )error;


/**
* 处理上传日志
*
*/
- (void)uploadLogWithInputText:(NSString * _Nullable)inputText
                       success:(void(^)(NSDictionary *info))success
                       failure:(void(^)(NSString *errorMsg))failure;
@end

NS_ASSUME_NONNULL_END
