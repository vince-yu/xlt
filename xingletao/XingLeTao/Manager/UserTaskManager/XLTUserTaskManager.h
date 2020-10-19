//
//  XLTUserTaskManager.h
//  XingLeTao
//
//  Created by chenhg on 2020/4/8.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


extern NSString *const XLTUserDidCompleteTaskNotification;

@class XLTBaseModel;
@interface XLTUserTaskManager : NSObject
@property (nonatomic ,assign) BOOL hasReportedPasteboard;

+ (instancetype)shareManager;

/**
*  汇报剪贴板商品任务完成
*/
- (void)letaoRepoPasteboardTaskInfo;


/**
*  汇报查看佣金任务完成
*/
- (void)letaoRepoCheckCommissionTaskInfo;

/**
*  汇报填写微信任务完成
*/
- (void)letaoRepoInputWeChatTaskInfo;

/**
*  汇报浏览商品任务完成
*/
- (void)letaoRepoBrowseTaskInfo:(NSDictionary *)taskInfo success:(void(^)(BOOL result,NSString * _Nullable errorMsg))success;

/**
*  汇报分享商品任务完成
*/
- (void)letaoRepoShareTaskInfo:(NSDictionary *)taskInfo;



/**
*获取任务状态接口
*  @param taskId   任务ID；
*/
- (void)letaofetchTaskSatusWithId:(NSString *)taskId
                          success:(void(^)(NSDictionary *info,XLTBaseModel *model))success
                          failure:(void(^)(NSString *errorMsg))failure;
@end

NS_ASSUME_NONNULL_END
