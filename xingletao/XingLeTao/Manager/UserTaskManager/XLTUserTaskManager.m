//
//  XLTUserTaskManager.m
//  XingLeTao
//
//  Created by chenhg on 2020/4/8.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTUserTaskManager.h"
#import "XLTNetworkHelper.h"
#import "XLTBaseModel.h"
#import "XLTTipConstant.h"
#import "XLTCompleteTaskView.h"
#import "XLTUserManager.h"


NSString *const XLTUserDidCompleteTaskNotification = @"XLTUserDidCompleteTaskNotification";


@interface XLTUserTaskManager ()

@end

@implementation XLTUserTaskManager

+ (instancetype)shareManager {
    static XLTUserTaskManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(logoutNotifi) name:kXLTNotifiLogoutSuccess object:nil];
    });
    return sharedInstance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)logoutNotifi {
    self.hasReportedPasteboard = NO;
}
/**
*  汇报剪贴板商品任务完成
*/
- (void)letaoRepoPasteboardTaskInfo {
//    [XLTCompleteTaskView showTaskCompleteTitle:@"商品标题查询成功" gold:5];
//    return;
    if (![XLTUserManager shareManager].isLogined || self.hasReportedPasteboard) return;
    // NewTaskOne-新手观看教程；NewTaskTwo-复制淘宝商品标题；NewTaskThree-查看购物佣金；NewTaskFour-填写微信号；
    // 1-新手观看教程；2-复制淘宝商品标题；3-查看购物佣金；4-填写微信号；
    [self letaoRepoTaskWithId:@"NewTaskTwo" success:^(NSDictionary *info) {
        // 弹窗
        NSNumber *status = [info objectForKey:@"status"];
        if ([status isKindOfClass:[NSNumber class]] || [status isKindOfClass:[NSString class]]) {
            if (status.intValue ==  1) { // 成功
                NSUInteger money = [self safeMoneyForTaksInfo:info];
                if (money > 0) {
                    [XLTCompleteTaskView showTaskCompleteTitle:@"商品标题查询成功" gold:money];
                    self.hasReportedPasteboard = YES;
                }
                [self userDidCompleteTask:nil];
            } else if (status.intValue == 2) { // 重复
                self.hasReportedPasteboard = YES;
            }
        }

        
    } failure:^(NSString *errorMsg) {

    }];
}


/**
*  汇报查看佣金任务完成
*/
- (void)letaoRepoCheckCommissionTaskInfo {
    if (![XLTUserManager shareManager].isLogined) return;
    
    // NewTaskOne-新手观看教程；NewTaskTwo-复制淘宝商品标题；NewTaskThree-查看购物佣金；NewTaskFour-填写微信号；
    // 1-新手观看教程；2-复制淘宝商品标题；3-查看购物佣金；4-填写微信号；
    [self letaoRepoTaskWithId:@"NewTaskThree" success:^(NSDictionary *info) {
        // 弹窗
        NSNumber *status = [info objectForKey:@"status"];
        if (status.intValue ==  1) {
            NSUInteger money = [self safeMoneyForTaksInfo:info];
            if (money > 0) {
                [XLTCompleteTaskView showTaskCompleteTitle:@"佣金查看成功" gold:money];
            }
            [self userDidCompleteTask:nil];
        }
    } failure:^(NSString *errorMsg) {

    }];
}


/**
*  汇报填写微信任务完成
*/
- (void)letaoRepoInputWeChatTaskInfo {
    if (![XLTUserManager shareManager].isLogined) return;
    // NewTaskOne-新手观看教程；NewTaskTwo-复制淘宝商品标题；NewTaskThree-查看购物佣金；NewTaskFour-填写微信号；
    // 1-新手观看教程；2-复制淘宝商品标题；3-查看购物佣金；4-填写微信号；

    [self letaoRepoTaskWithId:@"NewTaskFour" success:^(NSDictionary *info) {
        // 弹窗
        NSNumber *status = [info objectForKey:@"status"];
        if (status.intValue ==  1) {
            NSUInteger money = [self safeMoneyForTaksInfo:info];
            if (money > 0) {
                [XLTCompleteTaskView showTaskCompleteTitle:@"微信号填写成功" gold:money];
            }
            [self userDidCompleteTask:nil];
        }
    } failure:^(NSString *errorMsg) {

    }];
}


/**
*  日常汇报浏览商品任务完成
*/
- (void)letaoRepoBrowseTaskInfo:(NSDictionary *)taskInfo success:(void(^)(BOOL result,NSString * _Nullable errorMsg))success {
    if ([taskInfo isKindOfClass:[NSDictionary class]]) {
          // 浏览商品任务
        NSString *taskId = taskInfo[@"id"];
        [self letaoRepoDayTaskWithId:taskId success:^(NSDictionary *info,XLTBaseModel *model) {
            NSNumber *status = [info objectForKey:@"status"];
            BOOL repoSuccess = NO;
            if ([status isKindOfClass:[NSNumber class]] || [status isKindOfClass:[NSString class]]) {
                if (status.intValue ==  1) { // 成功
                    NSUInteger money = [self safeMoneyForTaksInfo:info];
                    if (money > 0) {
                        repoSuccess = YES;
                    }
                }else if (status.intValue == 2) { // 重复任务也认为成功
                    repoSuccess = YES;
                }
            }
            if (repoSuccess) {
                success(YES,model.message);
                [self userDidCompleteTask:nil];
            } else {
                success(NO,model.message);
            }
           
        } failure:^(NSString *errorMsg) {
            success(NO,nil);
        }];
    }
}


/**
*  日常汇报分享商品任务完成
*/
- (void)letaoRepoShareTaskInfo:(NSDictionary *)taskInfo {
    if ([taskInfo isKindOfClass:[NSDictionary class]]) {
        // 分享任务
        NSString *taskId = taskInfo[@"id"];
        [self letaoRepoDayTaskWithId:taskId success:^(NSDictionary *info,XLTBaseModel *model) {
            // 弹窗
            NSNumber *status = [info objectForKey:@"status"];
            if (status.intValue ==  1) {
                NSUInteger money = [self safeMoneyForTaksInfo:info];
                if (money > 0) {
                    [XLTCompleteTaskView showTaskCompleteTitle:@"分享成功" gold:money];
                }
                [self userDidCompleteTask:nil];
            }
        } failure:^(NSString *errorMsg) {
            
        }];
    }
}

    
    

/**
*  获取taskInfo中的reward
*/

- (NSUInteger)safeMoneyForTaksInfo:(NSDictionary *)taskInfo {
    NSUInteger money = 0;
    if ([taskInfo[@"x_number"] isKindOfClass:[NSNumber class]] || [taskInfo[@"x_number"] isKindOfClass:[NSString class]]) {
        money = MAX(0, [((NSString *)taskInfo[@"x_number"]) integerValue]);
    }
    return money;
}

/**
*  汇报新手任务通用接口
*  @param taskId      1-新手观看教程；2-复制淘宝商品标题；3-查看购物佣金；4-填写微信号；
*/
- (void)letaoRepoTaskWithId:(NSString *)taskId
                    success:(void(^)(NSDictionary *info))success
                    failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (taskId) {
        [parameters setObject:taskId forKey:@"type"];
    }
    [XLTNetworkHelper POST:kUserTaskRepoUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model.data isKindOfClass:[NSDictionary class]]) {
                success(model.data);
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

#pragma mark 日常任务
/**
*  汇报日常任务通用接口
*  @param taskId      1-每日签到；2-浏览商品；3-分享商品到微信；4-送好友免单福利；
*/
- (void)letaoRepoDayTaskWithId:(NSString *)taskId
                    success:(void(^)(NSDictionary *info,XLTBaseModel *model))success
                    failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (taskId) {
        [parameters setObject:taskId forKey:@"type"];
    }
    [XLTNetworkHelper POST:kUserDayTaskRepoUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model.data isKindOfClass:[NSDictionary class]]) {
                success(model.data,model);
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

#pragma mark 日常任务
/**
*获取任务状态接口
*  @param taskId      1-每日签到；2-浏览商品；3-分享商品到微信；4-送好友免单福利；
*/
- (void)letaofetchTaskSatusWithId:(NSString *)taskId
                    success:(void(^)(NSDictionary *info,XLTBaseModel *model))success
                    failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (taskId) {
        [parameters setObject:taskId forKey:@"code"];
    }
    [XLTNetworkHelper GET:kUserTaskStatusUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model.data isKindOfClass:[NSDictionary class]]) {
                success(model.data,model);
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


- (void)userDidCompleteTask:(NSDictionary * _Nullable)taskInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:XLTUserDidCompleteTaskNotification object:taskInfo];
}
@end
