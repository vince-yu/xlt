//
//  XLTTeacherShareLogic.m
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTTeacherShareLogic.h"

@implementation XLTTeacherShareLogic
//导师分享的列表
+ (void)getTutorShareListWithIndex:(NSString *)index page:(NSString *)page success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"page"] = index;
    dic[@"pageSize"] = page;
    [XLTNetworkHelper GET:kTeacherShareTutorShareListUrl parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                NSArray *letaoPageDataArray = [NSArray modelArrayWithClass:[XLTTeacherShareListModel class] json:model.data];
                success(letaoPageDataArray);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//我的导师分享的列表
+ (void)getTutorShareListFromMineWithStatus:(NSNumber *)status index:(NSString *)index page:(NSString *)page success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"status"] = status;
    dic[@"page"] = index;
    dic[@"pageSize"] = page;
    [XLTNetworkHelper GET:kTeacherShareTutorShareMListUrl parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                NSArray *letaoPageDataArray = [NSArray modelArrayWithClass:[XLTTeacherShareListModel class] json:model.data];
                success(letaoPageDataArray);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//设置导师分享文章是否展示
////@param status  类型：Number  必有字段  备注：1 展示 0 不展示
+ (void)setTeacherShareShowWith:(NSString *)listId status:(NSNumber *)status success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"share_id"] = listId;
    dic[@"status"] = status;
    [XLTNetworkHelper POST:kTeacherShareSetShowStautsUrl parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                
                success(model.data);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//设置导师分享文章是否置顶
////@param status  类型：Number  必有字段  备注：1 置顶 0 不置顶
+ (void)setTeacherShareTopWith:(NSString *)listId status:(NSNumber *)status success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"share_id"] = listId;
    dic[@"type"] = status;
    [XLTNetworkHelper POST:kTeacherShareSetShowTopUrl parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                
                success(model.data);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//移动导师分享文章排序
////@param status  类型：Number  必有字段  备注：1 往上 2 往下
+ (void)moveTeacherShareSortWith:(NSString *)listId status:(NSNumber *)status success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"share_id"] = listId;
    dic[@"type"] = status;
    [XLTNetworkHelper POST:kTeacherShareMoveListUrl parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                
                success(model.data);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
@end
