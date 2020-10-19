//
//  SndoDataManager.h
//  XingKouDai
//
//  Created by SNQU on 2019/12/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 http://sd.sndo.com/p?project=xingkoudai
http://sd.sndo.com/p?project=xingletao
 */
#define SndoData_Default_ServerURL @"http://sd.sndo.com/p?service=sndo&project=ov3k17dq"
#define SndoData_Default_TestServerURL @"http://sd.sndo.com/p?project=zjxabyor"

#pragma mark 事件定义


NS_ASSUME_NONNULL_BEGIN

@interface SDRepoManager : NSObject
//初始化方法
+ (void)xltrepo_startWithLaunchOptions:(NSDictionary *)launchOptions;
//自定义上报方法
+ (void)xltrepo_trackEvent:(NSString *)event properties:(NSDictionary  * _Nullable)dic;

//分类商品列表点击上报
+ (void)xltrepo_trackCategoryGoodsSelectedWithInfo:(NSDictionary *)goodsInfo
                                  xlt_item_firstcate_id:(NSString * _Nullable) xlt_item_firstcate_id
                               xlt_item_firstcate_title:(NSString * _Nullable) xlt_item_firstcate_title
                                 xlt_item_secondcate_id:(NSString * _Nullable) xlt_item_secondcate_id
                              xlt_item_secondcate_title:(NSString * _Nullable) xlt_item_secondcate_title
                                  xlt_item_thirdcate_id:(NSString * _Nullable) xlt_item_thirdcate_id
                               xlt_item_thirdcate_title:(NSString * _Nullable) xlt_item_thirdcate_title
                                 xlt_item_good_position:(NSNumber * _Nullable) xlt_item_good_position;


//Platle商品列表点击上报
+ (void)xltrepo_trackPlatleGoodsSelected:(NSDictionary *)goodsInfo
                              xlt_item_firstplatle_id:(NSString * _Nullable) xlt_item_firstplatle_id
                           xlt_item_firstplatle_title:(NSString * _Nullable) xlt_item_firstplatle_title
                             xlt_item_secondplatle_id:(NSString * _Nullable) xlt_item_secondplatle_id
                          xlt_item_secondplatle_title:(NSString * _Nullable) xlt_item_secondplatle_title
                               xlt_item_good_position:(NSNumber * _Nullable) xlt_item_good_position;
//分类商品列表展示数量上报
+ (void)xltrepo_trackCategoryGoodsEventWithListCount:(NSInteger)goodsListCount
                              xlt_item_firstcate_id:(NSString * _Nullable) xlt_item_firstcate_id
                           xlt_item_firstcate_title:(NSString * _Nullable) xlt_item_firstcate_title
                             xlt_item_secondcate_id:(NSString * _Nullable) xlt_item_secondcate_id
                          xlt_item_secondcate_title:(NSString * _Nullable) xlt_item_secondcate_title
                              xlt_item_thirdcate_id:(NSString * _Nullable) xlt_item_thirdcate_id
                           xlt_item_thirdcate_title:(NSString * _Nullable) xlt_item_thirdcate_title;


//商品列表位置点击上报
+ (void)xltrepo_trackGoodsSelectedWithInfo:(NSDictionary *)goodsInfo
                            xlt_item_place:(NSString * _Nullable) xlt_item_place
                    xlt_item_good_position:(NSNumber * _Nullable) xlt_item_good_position;

///**
//* 板块点击
//*  xlt_item_id:_id
//*  xlt_item_pid:pid
//*  xlt_item_title:title
//*/
//+ (void)xltrepo_trackPlatleClickEvent:(NSString * _Nullable) xlt_item_pid
//                           xlt_item_id:(NSString * _Nullable) xlt_item_id
//                        xlt_item_title:(NSString * _Nullable) xlt_item_title;


/**
* 首页模块点击
*  xlt_item_id:_id
*  xlt_item_title:title
*/
+ (void)xltrepo_trackHomeModulClickEvent:(NSString * _Nullable) xlt_item_id
                          xlt_item_title:(NSString * _Nullable) xlt_item_title
                         xlt_item_source:(NSString * _Nullable) xlt_item_source;
/**
* 大数据推荐位点击
*   good_id:_id
*   good_name:title
*   xlt_item_source:item_source
*   is_power:0,1
*   power_position:@"猜你喜欢"
*   power_model:power_model
*   xlt_item_place:商品在数据列表中的位置
*/
+ (void)xltrepo_trackReommenClickEventWithIs_pow:(BOOL) is_power
                          power_position:(NSString * _Nullable) power_position
                                       power_model:(NSString *)power_model
                                           good_id:(NSString *)good_id
                                         good_name:(NSString *)good_name
                                    xlt_item_place:(NSString *)xlt_item_place
                                 xlt_item_source:(NSString *)xlt_item_source;
/**
* 大数据推荐位展示
*   good_id:_id
*   good_name:title
*   xlt_item_source:item_source
*   is_power:0,1
*   power_position:@"猜你喜欢"
*   power_model:power_model
*   xlt_item_place:商品在数据列表中的位置
*/
+ (void)xltrepo_trackReommenShowEventWithIs_pow:(BOOL) is_power
                          power_position:(NSString * _Nullable) power_position
                                       power_model:(NSString *)power_model
                                           good_id:(NSString *)good_id
                                         good_name:(NSString *)good_name
                                    xlt_item_place:(NSString *)xlt_item_place
                                xlt_item_source:(NSString *)xlt_item_source;

+ (void)xltrepo_trackUserLogin:(NSString *)userId;
+ (void)xltrepo_trackUserLogout;
+ (id )repoResultValue:(id )value;
@end

NS_ASSUME_NONNULL_END
