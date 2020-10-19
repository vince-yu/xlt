//
//  JMLinkService.h
//  JMLink
//
//  Created by guoqingping on 2019/5/29.
//  Copyright © 2019 hxhg. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JMLINK_VERSION_NUMBER 1.0.0



@interface JMLinkConfig : NSObject

/* appKey 必须的,应用唯一的标识. */
@property (nonatomic, copy) NSString * _Nonnull appKey;
/* channel 发布渠道. 可选，默认为空*/
@property (nonatomic, copy) NSString * _Nullable channel;
/* advertisingIdentifier 广告标识符（IDFA). 可选，默认为空*/
@property (nonatomic, copy) NSString * _Nullable advertisingId;
/* isProduction 是否生产环境. 如果为开发状态,设置为NO;如果为生产状态,应改为YES.可选，默认为NO */
@property (nonatomic, assign) BOOL isProduction;

@end

@interface JMLinkService : NSObject

/**
 *  注册JMLink
 *  @param config 注册配置
 */
+ (void)setupWithConfig:(JMLinkConfig *_Nonnull)config;


/**
 * 注册一个mLink handler，当接收到URL的时候，会根据mLink key进行匹配，当匹配成功会调用相应的handler
 * 需要在 AppDelegate 的 didFinishLaunchingWithOptions 中调用
 * @param key 后台注册mlink时生成的mlink key
 * @param handler mlink的回调
 */
+ (void)registerMLinkHandlerWithKey:(nonnull NSString *)key handler:(void (^_Nonnull)(NSURL * __nonnull url ,NSDictionary * __nullable params))handler;

/**
 * 注册一个默认的mLink handler，当接收到URL，并且所有的mLink key都没有匹配成功，就会调用默认的mLink handler
 * 需要在 AppDelegate 的 didFinishLaunchingWithOptions 中调用
 * @param handler mlink的回调
 */
+ (void)registerMLinkDefaultHandler:(void (^_Nonnull)(NSURL * __nonnull url ,NSDictionary * __nullable params))handler;

/**
 * 根据不同的URL路由到不同的app展示页
 * 需要在 application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options 中调用
 * @param url 传入上面方法中的openUrl
 */
+ (BOOL)routeMLink:(nonnull NSURL *)url;

/**
 *  根据universal link路由到不同的app展示页
 *  需要在 application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler 中调用
 *  @param userActivity 传入上面方法中的userActivity
 *  @return BOOL
 */
+ (BOOL)continueUserActivity:(nonnull NSUserActivity *)userActivity NS_AVAILABLE_IOS(8.0);

/**
 *  获取无码邀请中传回来的相关值
 *  @param paramKey  paramKey,比如:u_id
 *  @handler handler 回调
 */
+ (void)getMLinkParam:(nonnull NSString *)paramKey handler:(void(^_Nonnull)(NSDictionary * __nullable params))handler;

/*!
 * @abstract 开启Crash日志收集
 *
 * @discussion 默认是关闭状态.
 */
+ (void)crashLogON;

/*!
 * @abstract 设置是否打印sdk产生的Debug级log信息, 默认为NO(不打印log)
 *
 * SDK 默认开启的日志级别为: Info. 只显示必要的信息, 不打印调试日志.
 *
 * 请在SDK启动后调用本接口，调用本接口可打开日志级别为: Debug, 打印调试日志.
 * 请在发布产品时改为NO，避免产生不必要的IO
 */
+ (void)setDebug:(BOOL)enable;

@end

