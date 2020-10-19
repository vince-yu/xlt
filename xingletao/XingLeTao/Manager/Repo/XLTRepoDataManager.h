//
//  XLTRepoManager.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/22.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTRepoDataModel : NSObject
/**
     * udid : 设备唯一id
     * client_type : 1
     * client_version : 1.0
     * device : 小米3
     * os_version : android9.0
     * net_type : 1
     * uid : 用户id
     * action : 1
     * time : 11111111111
     * page : 访问页面
     * title : 页面名称
     * referer :
     * item_id : 商品id
     * model1 : 一级板块id
     * model2 : 二级板块id
     * platform : 平台 1 淘宝 2 天猫 3 京东
     * jump_link : 跳转链接
     * activity : 活动id
     * order_id : 订单id
     * keyword : 搜索关键词
     */
@property (nonatomic, copy) NSString *udid;
@property (nonatomic, copy) NSNumber *client_type;
@property (nonatomic, copy) NSString *client_version;
@property (nonatomic, copy) NSString *device;
@property (nonatomic, copy) NSString *os_version;

@property (nonatomic, copy) NSNumber *net_type;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSNumber *time;
@property (nonatomic, copy) NSString *item_id;
@property (nonatomic, copy) NSNumber *platform;
@property (nonatomic, copy) NSString *model1;
@property (nonatomic, copy, nullable) NSString *model2;
@property (nonatomic, copy) NSString *jump_link;
@property (nonatomic, copy) NSString *activity;//活动id 订单分享赚佣金哪里的
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, copy) NSString *jd_position_id; //京东推广位id
@property (nonatomic, copy) NSString *tb_relation_id; //淘宝渠道id
@property (nonatomic, copy) NSNumber *model_type; //0(或不传)：通用板块，model传板块id     1：人工编辑板块，model传板块code
@property (nonatomic, copy) NSNumber *source; //
@property (nonatomic, copy) NSNumber *user_level; //

@end

@interface XLTRepoDataManager : NSObject

+ (instancetype)shareManager;


- (void)repoPlateViewPage:(NSString * _Nullable)plate childPlate:(NSString * _Nullable)childPlate;

// 红人街道
- (void)repoRedStreetWithPlate:(NSString * _Nullable)plate
                    childPlate:(NSString * _Nullable)childPlate;

// 商品详情
- (void)repoGoodDetailPage:(NSString * _Nullable)plate
                childPlate:(NSString * _Nullable)childPlate
                    goodId:(NSString * _Nullable)goodId
                model_type:(NSNumber * _Nullable)model_type
               item_source:(NSString *)item_source;


// 下单Taobao
- (void)repoTaobaoOrderAction:(NSString * _Nullable)plate
           childPlate:(NSString * _Nullable)childPlate
               goodId:(NSString * _Nullable)goodId
          item_source:(NSString *)item_source
            jump_link:(NSString *)jump_link
          position_id:(NSString *)position_id
                   model_type:(NSNumber * _Nullable)model_type;


// 下单Jingdong
- (void)repoJingdongOrderAction:(NSString * _Nullable)plate
           childPlate:(NSString * _Nullable)childPlate
               goodId:(NSString * _Nullable)goodId
          item_source:(NSString *)item_source
            jump_link:(NSString *)jump_link
          position_id:(NSString *)position_id
                     model_type:(NSNumber * _Nullable)model_type;

// 复制淘口令
- (void)repoCopyTKLAction:(NSString * _Nullable)plate
           childPlate:(NSString * _Nullable)childPlate
               goodId:(NSString * _Nullable)goodId
                    item_source:(NSString *)item_source
               model_type:(NSNumber * _Nullable)model_type;




// 订单分享
- (void)repoOrderSharActionOrderId:(NSString * _Nullable)order_id
           activity:(NSString * _Nullable)activity
               goodId:(NSString * _Nullable)goodId
                       item_source:(NSString *)item_source;


/// 收藏/取消收藏
- (void)repoCollect:(BOOL)collect
              plate:(NSString * _Nullable)plate
           childPlate:(NSString * _Nullable)childPlate
               goodId:(NSString * _Nullable)goodId
        item_source:(NSString *)item_source;


// 搜索
- (void)repoSearchActionWithKeyword:(NSString * _Nullable)keyword;

// 商品分享
- (void)repoGoodsShareActionWithPlate:(NSString * _Nullable)plate
                           childPlate:(NSString * _Nullable)childPlate
                               goodId:(NSString * _Nullable)goodId
                          item_source:(NSString *)item_source;


// 登录/注册

- (void)repoLoginIsNewUser:(BOOL)isNewUser;

// 剪贴板错误日志事件
- (void)umeng_repoPasteboardError:(NSString *)text failureCode:(NSNumber * _Nullable)failureCode;
//友盟事件统计
- (void)umeng_repoEvent:(NSString *)event params:(nullable NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
