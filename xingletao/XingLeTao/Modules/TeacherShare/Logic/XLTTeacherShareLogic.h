//
//  XLTTeacherShareLogic.h
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"
#import "XLTTeacherShareListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTTeacherShareLogic : XLTNetBaseLogic
//导师分享的列表
+ (void)getTutorShareListWithIndex:(NSString *)index page:(NSString *)page success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//我的导师分享的列表
+ (void)getTutorShareListFromMineWithStatus:(NSNumber *)status index:(NSString *)index page:(NSString *)page success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//设置导师分享文章是否展示
////@param status  类型：Number  必有字段  备注：1 展示 0 不展示
+ (void)setTeacherShareShowWith:(NSString *)listId status:(NSNumber *)status success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//设置导师分享文章是否置顶
////@param status  类型：Number  必有字段  备注：1 置顶 0 不置顶
+ (void)setTeacherShareTopWith:(NSString *)listId status:(NSNumber *)status success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//移动导师分享文章排序
////@param status  类型：Number  必有字段  备注：1 往上 2 往下
+ (void)moveTeacherShareSortWith:(NSString *)listId status:(NSNumber *)status success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
@end

NS_ASSUME_NONNULL_END
