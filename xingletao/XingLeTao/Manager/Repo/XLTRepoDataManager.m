//
//  XLTRepoDataManager.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/22.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTRepoDataManager.h"
#import "FCUUID.h"
#import "XLTNetworkHelper.h"
#import "AFNetworkReachabilityManager.h"
#import "XLTUserManager.h"
#import "AFHTTPSessionManager.h"
#import <UMAnalytics/MobClick.h>
#import "NSString+XLTMD5.h"

@implementation XLTRepoDataModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _udid = [FCUUID uuidForDevice];
        _client_type = @3;
        _client_version = [[XLTAppPlatformManager shareManager] appVersion];
        _device =  [NSString stringWithFormat:@"APPLE %@",[[UIDevice currentDevice] model]];
        _os_version = [[UIDevice currentDevice] systemVersion];
        _net_type = [NSNumber numberWithInteger:[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus];
        _uid = [XLTUserManager shareManager].curUserInfo._id;
        _time = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]];
        _source = @2;
        _user_level = [XLTUserManager shareManager].curUserInfo.level;

    }
    return self;
}
@end


@interface XLTRepoDataManager ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation XLTRepoDataManager



+ (instancetype)shareManager {
    static XLTRepoDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURL *baseUrl = [NSURL URLWithString:[XLTAppPlatformManager shareManager].repoApiSeverUrl];
        AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
         sessionManager.requestSerializer.timeoutInterval = NetWork_TimeoutInterval;
         sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
        sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.sessionManager = sessionManager;
    }
    return self;
}


- (void)repoWithModel:(XLTRepoDataModel *)model {
    if([model.model1 isKindOfClass:[NSString class]]
       && [model.model2 isKindOfClass:[NSString class]]
       && [model.model1 isEqualToString:model.model2]) {
       model.model2 = nil;
    }
    NSDictionary *parameters = [model modelToJSONObject];
    if (parameters != nil) {
        [self.sessionManager POST:@"api/report/log" parameters:@[parameters] progress:nil success:nil failure:nil];
    }

}

// 首页模块

- (void)repoPlateViewPage:(NSString * _Nullable)plate childPlate:(NSString * _Nullable)childPlate {
    XLTRepoDataModel *repoModel = [[XLTRepoDataModel alloc] init];
    repoModel.action = @"1";
    repoModel.model1 = plate;
    repoModel.model2 = childPlate;
    [self repoWithModel:repoModel];
}

// 红人街道
- (void)repoRedStreetWithPlate:(NSString * _Nullable)plate
                    childPlate:(NSString * _Nullable)childPlate {
    XLTRepoDataModel *repoModel = [[XLTRepoDataModel alloc] init];
    repoModel.action = @"1";
    repoModel.model_type = @1;
    repoModel.model1 = plate;
    repoModel.model2 = childPlate;
    [self repoWithModel:repoModel];
}

// 商品详情
- (void)repoGoodDetailPage:(NSString * _Nullable)plate
                childPlate:(NSString * _Nullable)childPlate
                    goodId:(NSString * _Nullable)goodId
                model_type:(NSNumber * _Nullable)model_type
               item_source:(NSString *)item_source {
    XLTRepoDataModel *repoModel = [[XLTRepoDataModel alloc] init];
    repoModel.action = @"1";
    repoModel.model1 = plate;
    repoModel.model2 = childPlate;
    repoModel.model_type = model_type;
    repoModel.item_id = goodId;
    repoModel.model_type = model_type;
    repoModel.platform = [self parserItem_source:item_source];
    [self repoWithModel:repoModel];
}

// 下单Taobao
- (void)repoTaobaoOrderAction:(NSString * _Nullable)plate
           childPlate:(NSString * _Nullable)childPlate
               goodId:(NSString * _Nullable)goodId
          item_source:(NSString *)item_source
            jump_link:(NSString *)jump_link
          position_id:(NSString *)position_id
           model_type:(NSNumber * _Nullable)model_type {
    XLTRepoDataModel *repoModel = [[XLTRepoDataModel alloc] init];
    repoModel.action = @"2";
    repoModel.model1 = plate;
    repoModel.model2 = childPlate;
    repoModel.item_id = goodId;
    repoModel.platform = [self parserItem_source:item_source];
    repoModel.jump_link = jump_link;
    repoModel.tb_relation_id = position_id;
    repoModel.model_type = model_type;
    [self repoWithModel:repoModel];
}


// 下单Jingdong
- (void)repoJingdongOrderAction:(NSString * _Nullable)plate
           childPlate:(NSString * _Nullable)childPlate
               goodId:(NSString * _Nullable)goodId
          item_source:(NSString *)item_source
            jump_link:(NSString *)jump_link
          position_id:(NSString *)position_id
           model_type:(NSNumber * _Nullable)model_type {
    XLTRepoDataModel *repoModel = [[XLTRepoDataModel alloc] init];
    repoModel.action = @"2";
    repoModel.model1 = plate;
    repoModel.model2 = childPlate;
    repoModel.item_id = goodId;
    repoModel.platform = [self parserItem_source:item_source];
    repoModel.jump_link = jump_link;
    repoModel.jd_position_id = position_id;
    repoModel.model_type = model_type;
    [self repoWithModel:repoModel];
}



// 复制淘口令
- (void)repoCopyTKLAction:(NSString * _Nullable)plate
           childPlate:(NSString * _Nullable)childPlate
               goodId:(NSString * _Nullable)goodId
                    item_source:(NSString *)item_source
                    model_type:(NSNumber * _Nullable)model_type {
    XLTRepoDataModel *repoModel = [[XLTRepoDataModel alloc] init];
    repoModel.action = @"5";
    repoModel.model1 = plate;
    repoModel.model2 = childPlate;
    repoModel.platform = [self parserItem_source:item_source];
    repoModel.model_type = model_type;
    repoModel.item_id = goodId;
    [self repoWithModel:repoModel];
}


// 订单分享
- (void)repoOrderSharActionOrderId:(NSString * _Nullable)order_id
           activity:(NSString * _Nullable)activity
               goodId:(NSString * _Nullable)goodId
                    item_source:(NSString *)item_source {
    XLTRepoDataModel *repoModel = [[XLTRepoDataModel alloc] init];
    repoModel.action = @"6";
    repoModel.activity = [NSString stringWithFormat:@"%@",activity];
    repoModel.order_id = order_id;
    repoModel.platform = [self parserItem_source:item_source];
    repoModel.item_id = goodId;
    [self repoWithModel:repoModel];
}

/// 收藏/取消收藏
- (void)repoCollect:(BOOL)collect
              plate:(NSString * _Nullable)plate
           childPlate:(NSString * _Nullable)childPlate
               goodId:(NSString * _Nullable)goodId
            item_source:(NSString *)item_source {
    XLTRepoDataModel *repoModel = [[XLTRepoDataModel alloc] init];
    repoModel.action = collect ? @"7" :@"9";
    repoModel.model1 = plate;
    repoModel.model2 = childPlate;
    repoModel.item_id = goodId;
    repoModel.platform = [self parserItem_source:item_source];
    [self repoWithModel:repoModel];
}

// 搜索
- (void)repoSearchActionWithKeyword:(NSString * _Nullable)keyword {
    XLTRepoDataModel *repoModel = [[XLTRepoDataModel alloc] init];
    repoModel.action = @"8";
    repoModel.keyword = keyword;
    [self repoWithModel:repoModel];
}

- (void)repoGoodsShareActionWithPlate:(NSString * _Nullable)plate
                           childPlate:(NSString * _Nullable)childPlate
                               goodId:(NSString * _Nullable)goodId
                          item_source:(NSString *)item_source {
    XLTRepoDataModel *repoModel = [[XLTRepoDataModel alloc] init];
    repoModel.action = @"10";
    repoModel.model1 = plate;
    repoModel.model2 = childPlate;
    repoModel.item_id = goodId;
    repoModel.platform = [self parserItem_source:item_source];
    [self repoWithModel:repoModel];
}

- (NSNumber *)parserItem_source:(NSString *)item_source {
    if ([item_source isKindOfClass:[NSString class]]) {
        if ([item_source isEqualToString:XLTTaobaoPlatformIndicate]) {
            return @1;
        } else if ([item_source isEqualToString:XLTTianmaoPlatformIndicate]) {
            return @2;
        } else if ([item_source isEqualToString:XLTJindongPlatformIndicate]) {
            return @3;
        } else {
            return @4;
        }
    }
    return nil;
}


// 登录/注册

- (void)repoLoginIsNewUser:(BOOL)isNewUser {
    XLTRepoDataModel *repoModel = [[XLTRepoDataModel alloc] init];
    repoModel.action = isNewUser ? @"21" : @"22";
    [self repoWithModel:repoModel];
}
- (void)umeng_repoEvent:(NSString *)event params:(NSDictionary *)dic{
    if ([XLTAppPlatformManager shareManager].debugModel) {
        return;
    }
    if (event.length) {
        if (![dic  count]) {
            [MobClick event:event];
        }else{
            [MobClick event:event attributes:dic];
        }
        
    }
}

- (void)umeng_repoPasteboardError:(NSString *)text failureCode:(NSNumber * _Nullable)failureCode {
    if (![XLTAppPlatformManager shareManager].debugModel) {
        NSString *appVersion =  [[XLTAppPlatformManager shareManager] appVersion];
        NSString *uid = [NSString stringWithFormat:@"%@",[XLTUserManager shareManager].curUserInfo._id];
        NSString *phone = [NSString stringWithFormat:@"%@",[XLTUserManager shareManager].curUserInfo.phone];
        NSString *textMD5 = [[NSString stringWithFormat:@"%@",text] letaomd5];
        NSString *failure = [NSString stringWithFormat:@"%@",failureCode ? failureCode : @"-101"];
        NSString *dateStr = [NSString stringWithFormat:@"%@",[XLTGoodsDisplayHelp letaoSecondDateStringWithDate:[NSDate date]]];
        
        // 汇报失败信息
        NSString *label = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@",dateStr,appVersion,uid,phone,textMD5,failure];
        [MobClick event:@"kPasteboardDecodeError" label:label];
        // 汇报失败的text
        [MobClick event:@"kPasteboardErrorText" label:[NSString stringWithFormat:@"%@|%@",textMD5,text]];
    }
    
}


@end
