

#import "SDRepoManager.h"
#import <SndoDataSDK/SndoDataSDK.h>
#import "XLTUserManager.h"

@implementation SDRepoManager

+ (void)xltrepo_startWithLaunchOptions:(NSDictionary *)launchOptions {
    NSString *sndoServerURL = nil;
    if ([XLTAppPlatformManager shareManager].serverType == XLTAppPlatformServerReleaseType) {
        sndoServerURL = SndoData_Default_ServerURL;
    } else {
        sndoServerURL = SndoData_Default_TestServerURL;
    }
    SDConfigOptions *options = [[SDConfigOptions alloc] initWithServerURL:sndoServerURL launchOptions:launchOptions];
    options.autoTrackEventType = SndoDataEventTypeAppStart | SndoDataEventTypeAppEnd | SndoDataEventTypeAppClick | SndoDataEventTypeAppViewScreen;
    options.flushInterval = 300 * 1 * 1000;
//            options.flushBulkSize = 100;
    options.maxCacheSize = 20000;
    options.project = @"xingletao";
    options.enableHeatMap = YES;
    [SndoDataSDK startWithConfigOptions:options];
    
    [[SndoDataSDK sharedInstance] enableLog:NO];
    [[SndoDataSDK sharedInstance] trackInstallation:@"AppInstall" withProperties:nil];
    [[SndoDataSDK sharedInstance] enableTrackGPSLocation:YES];
    NSString *usrId = [XLTUserManager shareManager].curUserInfo._id;
    if ([usrId isKindOfClass:[NSString class]] && usrId.length) {
        [SDRepoManager xltrepo_trackUserLogin:usrId];
        [[SndoDataSDK sharedInstance] registerSuperProperties:@{@"channel":@"appstore",@"client":@"星乐桃APP",@"is_login":[NSNumber numberWithBool:YES]}];
    }else{
        [[SndoDataSDK sharedInstance] registerSuperProperties:@{@"channel":@"appstore",@"client":@"星乐桃APP",@"is_login":[NSNumber numberWithBool:NO]}];
    }
}

+ (void)xltrepo_trackEvent:(NSString *)event properties:(NSDictionary * _Nullable)dic{
    
    if ([event isKindOfClass:[NSString class]] && event.length) {
        if ([dic isKindOfClass:[NSDictionary class]] && dic.count) {
            [[SndoDataSDK sharedInstance] track:event withProperties:dic];
        }else{
            [[SndoDataSDK sharedInstance] track:event];
        }
         
    }
   
}


+ (void)xltrepo_trackCategoryGoodsSelectedWithInfo:(NSDictionary *)goodsInfo
                                xlt_item_firstcate_id:(NSString * _Nullable)xlt_item_firstcate_id
                        xlt_item_firstcate_title:(NSString * _Nullable)xlt_item_firstcate_title
                                xlt_item_secondcate_id:(NSString * _Nullable)xlt_item_secondcate_id
                             xlt_item_secondcate_title:(NSString * _Nullable)xlt_item_secondcate_title
                                 xlt_item_thirdcate_id:(NSString * _Nullable)xlt_item_thirdcate_id
                              xlt_item_thirdcate_title:(NSString * _Nullable)xlt_item_thirdcate_title
                            xlt_item_good_position:(NSNumber * _Nullable) xlt_item_good_position{
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    if ([goodsInfo isKindOfClass:[NSDictionary class]]) {
         properties[@"good_id"] = [SDRepoManager repoResultValue:goodsInfo[@"_id"]];
         properties[@"good_name"] = [SDRepoManager repoResultValue:goodsInfo[@"item_title"]];
         properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:goodsInfo[@"item_source"]];
         properties[@"xlt_item_good_id"] = [SDRepoManager repoResultValue:goodsInfo[@"item_id"]];
         properties[@"xlt_item_rebate_amount"] = @"null";
         properties[@"xlt_item_coupon_amount"] = @"null";
         NSDictionary *rebate = goodsInfo[@"rebate"];
        if ([rebate isKindOfClass:[NSDictionary class]]) {
            properties[@"xlt_item_rebate_amount"] = [SDRepoManager repoResultValue:rebate[@"xkd_amount"]];
        }
         NSDictionary *coupoInfo = goodsInfo[@"coupon"];
        if ([coupoInfo isKindOfClass:[NSDictionary class]]) {
            properties[@"xlt_item_coupon_amount"] = [SDRepoManager repoResultValue:coupoInfo[@"amount"]];
        }
         
        
    }
    properties[@"xlt_item_place"] = [NSString stringWithFormat:@"%@",[SDRepoManager repoResultValue:xlt_item_good_position]];
    properties[@"xlt_item_good_position"] = [SDRepoManager repoResultValue:xlt_item_good_position];
    properties[@"xlt_item_firstcate_id"] = [SDRepoManager repoResultValue:xlt_item_firstcate_id];
    properties[@"xlt_item_firstcate_title"] = [SDRepoManager repoResultValue:xlt_item_firstcate_title];
    properties[@"xlt_item_secondcate_id"] = [SDRepoManager repoResultValue:xlt_item_secondcate_id];
    properties[@"xlt_item_secondcate_title"] = [SDRepoManager repoResultValue:xlt_item_secondcate_title];
    properties[@"xlt_item_thirdcate_id"] = [SDRepoManager repoResultValue:xlt_item_thirdcate_id];
    properties[@"xlt_item_thirdcate_title"] = [SDRepoManager repoResultValue:xlt_item_thirdcate_title];
    if (properties.count) {
        [[SndoDataSDK sharedInstance] track:XLT_EVENT_GOODS withProperties:properties];
    }else{
        [[SndoDataSDK sharedInstance] track:XLT_EVENT_GOODS];
    }
}

//Platle商品列表点击上报
+ (void)xltrepo_trackPlatleGoodsSelected:(NSDictionary *)goodsInfo
                             xlt_item_firstplatle_id:(NSString * _Nullable)xlt_item_firstplatle_id
                          xlt_item_firstplatle_title:(NSString * _Nullable)xlt_item_firstplatle_title
                            xlt_item_secondplatle_id:(NSString * _Nullable)xlt_item_secondplatle_id
                         xlt_item_secondplatle_title:(NSString * _Nullable)xlt_item_secondplatle_title
                  xlt_item_good_position:(NSNumber * _Nullable) xlt_item_good_position{
     NSMutableDictionary *properties = [NSMutableDictionary dictionary];
     if ([goodsInfo isKindOfClass:[NSDictionary class]]) {
          properties[@"good_id"] = [SDRepoManager repoResultValue:goodsInfo[@"_id"]];
          properties[@"good_name"] = [SDRepoManager repoResultValue:goodsInfo[@"item_title"]];
          properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:goodsInfo[@"item_source"]];
          properties[@"xlt_item_good_id"] = [SDRepoManager repoResultValue:goodsInfo[@"item_id"]];
          properties[@"xlt_item_rebate_amount"] = @"null";
          properties[@"xlt_item_coupon_amount"] = @"null";
          NSDictionary *rebate = goodsInfo[@"rebate"];
         if ([rebate isKindOfClass:[NSDictionary class]]) {
             properties[@"xlt_item_rebate_amount"] = [SDRepoManager repoResultValue:rebate[@"xkd_amount"]];
         }
          NSDictionary *coupoInfo = goodsInfo[@"coupon"];
         if ([coupoInfo isKindOfClass:[NSDictionary class]]) {
             properties[@"xlt_item_coupon_amount"] = [SDRepoManager repoResultValue:coupoInfo[@"amount"]];
         }
     }
    if (xlt_item_firstplatle_id || xlt_item_firstplatle_title) {
        properties[@"xlt_item_firstplatle_id"] = [SDRepoManager repoResultValue:xlt_item_firstplatle_id];
        properties[@"xlt_item_firstplatle_title"] = [SDRepoManager repoResultValue:xlt_item_firstplatle_title];
        if (xlt_item_secondplatle_id || xlt_item_secondplatle_title) {
            properties[@"xlt_item_secondplatle_id"] = [SDRepoManager repoResultValue:xlt_item_secondplatle_id];
            properties[@"xlt_item_secondplatle_title"] = [SDRepoManager repoResultValue:xlt_item_secondplatle_title];
        }
    } else {
        if (xlt_item_secondplatle_id || xlt_item_secondplatle_title) {
            properties[@"xlt_item_firstplatle_id"] = [SDRepoManager repoResultValue:xlt_item_secondplatle_id];
            properties[@"xlt_item_firstplatle_title"] = [SDRepoManager repoResultValue:xlt_item_secondplatle_title];
        }
    }

    properties[@"xlt_item_good_position"] = [SDRepoManager repoResultValue:xlt_item_good_position];
    properties[@"xlt_item_place"] = [NSString stringWithFormat:@"%@",[SDRepoManager repoResultValue:xlt_item_good_position]];
    if (properties.count) {
         [[SndoDataSDK sharedInstance] track:XLT_EVENT_GOODS withProperties:properties];
     }else{
         [[SndoDataSDK sharedInstance] track:XLT_EVENT_GOODS];
     }
}


//商品列表点击上报
+ (void)xltrepo_trackGoodsSelectedWithInfo:(NSDictionary *)goodsInfo
                                xlt_item_place:(NSString * _Nullable)xlt_item_place
                    xlt_item_good_position:(NSNumber * _Nullable) xlt_item_good_position{
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
       if ([goodsInfo isKindOfClass:[NSDictionary class]]) {
            properties[@"good_id"] = [SDRepoManager repoResultValue:goodsInfo[@"_id"]];
            properties[@"good_name"] = [SDRepoManager repoResultValue:goodsInfo[@"item_title"]];
            properties[@"xlt_item_source"] = [SDRepoManager repoResultValue:goodsInfo[@"item_source"]];
            properties[@"xlt_item_good_id"] = [SDRepoManager repoResultValue:goodsInfo[@"item_id"]];
            properties[@"xlt_item_rebate_amount"] = @"null";
            properties[@"xlt_item_coupon_amount"] = @"null";
            NSDictionary *rebate = goodsInfo[@"rebate"];
           if ([rebate isKindOfClass:[NSDictionary class]]) {
               properties[@"xlt_item_rebate_amount"] = [SDRepoManager repoResultValue:rebate[@"xkd_amount"]];
           }
            NSDictionary *coupoInfo = goodsInfo[@"coupon"];
           if ([coupoInfo isKindOfClass:[NSDictionary class]]) {
               properties[@"xlt_item_coupon_amount"] = [SDRepoManager repoResultValue:coupoInfo[@"amount"]];
           }
       }
        properties[@"xlt_item_good_position"] = [SDRepoManager repoResultValue:xlt_item_good_position];
        properties[@"xlt_item_place"] = [NSString stringWithFormat:@"%@",[SDRepoManager repoResultValue:xlt_item_good_position]];
        properties[@"xlt_item_firstcate_id"] = @"null";
        properties[@"xlt_item_firstcate_title"] = @"null";
        properties[@"xlt_item_secondcate_id"] = @"null";
        properties[@"xlt_item_secondcate_title"] = @"null";
        properties[@"xlt_item_thirdcate_id"] = @"null";
        properties[@"xlt_item_thirdcate_title"] = @"null";
       if (properties.count) {
           [[SndoDataSDK sharedInstance] track:XLT_EVENT_GOODS withProperties:properties];
       }else{
           [[SndoDataSDK sharedInstance] track:XLT_EVENT_GOODS];
       }
}

+ (void)xltrepo_trackCategoryGoodsEventWithListCount:(NSInteger)goodsListCount
                                xlt_item_firstcate_id:(NSString * _Nullable)xlt_item_firstcate_id
                        xlt_item_firstcate_title:(NSString * _Nullable)xlt_item_firstcate_title
                                xlt_item_secondcate_id:(NSString * _Nullable)xlt_item_secondcate_id
                             xlt_item_secondcate_title:(NSString * _Nullable)xlt_item_secondcate_title
                                 xlt_item_thirdcate_id:(NSString * _Nullable)xlt_item_thirdcate_id
                              xlt_item_thirdcate_title:(NSString * _Nullable)xlt_item_thirdcate_title {
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    properties[@"xlt_item_goodslist_count"] = [NSNumber numberWithInteger:goodsListCount];

    properties[@"xlt_item_firstcate_id"] = xlt_item_firstcate_id;
    properties[@"xlt_item_firstcate_title"] = xlt_item_firstcate_title;
    properties[@"xlt_item_secondcate_id"] = xlt_item_secondcate_id;
    properties[@"xlt_item_secondcate_title"] = xlt_item_secondcate_title;
    properties[@"xlt_item_thirdcate_id"] = xlt_item_thirdcate_id;
    properties[@"xlt_item_thirdcate_title"] = xlt_item_thirdcate_title;
    if (properties.count) {
        [[SndoDataSDK sharedInstance] track:XLT_EVENT_GOODSLIST_COUNT withProperties:properties];
    }else{
        [[SndoDataSDK sharedInstance] track:XLT_EVENT_GOODSLIST_COUNT];
    }
}

/**
* 板块点击
* xlt_item_id:_id
* xlt_item_pid:pid
* xlt_item_title:title
*/
//+ (void)xltrepo_trackPlatleClickEvent:(NSString * _Nullable)xlt_item_pid
//                          xlt_item_id:(NSString * _Nullable)xlt_item_id
//                       xlt_item_title:(NSString * _Nullable)xlt_item_title {
//    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
//    properties[@"xlt_item_pid"] = xlt_item_pid;
//    properties[@"xlt_item_id"] = xlt_item_id;
//    properties[@"xlt_item_title"] = xlt_item_title;
//   
//    if (properties.count) {
//         [[SndoDataSDK sharedInstance] track:XLT_EVENT_PLATE withProperties:properties];
//     }else{
//         [[SndoDataSDK sharedInstance] track:XLT_EVENT_PLATE];
//     }
//}

/**
* 首页模块点击
*  xlt_item_id:_id
*  xlt_item_title:title
*/
+ (void)xltrepo_trackHomeModulClickEvent:(NSString * _Nullable) xlt_item_id
                          xlt_item_title:(NSString * _Nullable) xlt_item_title
                         xlt_item_source:(NSString * _Nullable) xlt_item_source
{
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    properties[@"xlt_item_id"] = xlt_item_id;
    properties[@"xlt_item_title"] = xlt_item_title;
    properties[@"xlt_item_source"] = [xlt_item_source isKindOfClass:[NSNull class]] ? @"null":xlt_item_source;
    properties[@"activity_time"] = @"null";
    if (properties.count) {
        [[SndoDataSDK sharedInstance] track:XLT_EVENT_PLATE withProperties:properties];
    }
}
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
                                   xlt_item_source:(NSString *)xlt_item_source{
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    properties[@"is_power"] = [NSNumber numberWithBool:is_power];
    properties[@"power_position"] = power_position;
    properties[@"power_model"] = [SDRepoManager repoResultValue:power_model];
    properties[@"good_id"] = good_id;
    properties[@"good_name"] = good_name;
    properties[@"xlt_item_place"] = xlt_item_place;
    properties[@"xlt_item_source"] = xlt_item_source;
    properties[@"xlt_item_firstcate_title"] = @"null";
    properties[@"xlt_item_thirdcate_title"] = @"null";
    properties[@"xlt_item_secondcate_title"] = @"null";
    properties[@"activity_time"] = @"null";
    if (properties.count) {
        [[SndoDataSDK sharedInstance] track:XLT_EVENT_RECOMMEN_POSITION_CLICK withProperties:properties];
    }
}
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
                                   xlt_item_source:(NSString *)xlt_item_source{
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    properties[@"is_power"] = [NSNumber numberWithBool:is_power];
    properties[@"power_position"] = power_position;
    properties[@"power_model"] =  [SDRepoManager repoResultValue:power_model];
    properties[@"good_id"] = good_id;
    properties[@"good_name"] = good_name;
    properties[@"xlt_item_place"] = xlt_item_place;
    properties[@"xlt_item_source"] = xlt_item_source;
    properties[@"xlt_item_source"] = xlt_item_source;
    properties[@"xlt_item_firstcate_title"] = @"null";
    properties[@"xlt_item_thirdcate_title"] = @"null";
    properties[@"xlt_item_secondcate_title"] = @"null";
    properties[@"activity_time"] = @"null";
    if (properties.count) {
        [[SndoDataSDK sharedInstance] track:XLT_EVENT_RECOMMEN_POSITION_SHOW withProperties:properties];
    }
}



+ (void)xltrepo_trackUserLogin:(NSString *)userId{
    [[SndoDataSDK sharedInstance] login:userId];
}
+ (void)xltrepo_trackUserLogout{
    [[SndoDataSDK sharedInstance] logout];
}
+ (id )repoResultValue:(id )value{
    if ([value isKindOfClass:[NSNull class]] || value == nil) {
        return @"null";
    }
    return value;
}
@end
