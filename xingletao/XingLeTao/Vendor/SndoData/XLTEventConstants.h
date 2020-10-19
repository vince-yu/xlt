//
//  XKDEventConstants.h
//  XingKouDai
//
//  Created by SNQU on 2019/12/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDRepoManager.h"


//事件
//首页事件点击
static NSString * const XLT_EVENT_HOME_SCAN = @"xlt_event_home_scan";      //首页扫一扫
static NSString * const XLT_EVENT_COURSE = @"xlt_event_course";  //首页视频教程
static NSString * const XLT_EVENT_HOME_SEARCH = @"xlt_event_home_search";
/*
 搜索商品
 xlt_item_id:_id
 jgq_rank:金刚区排序
 xlt_item_title:name
*/
static NSString * const XLT_EVENT_JGQ = @"xlt_event_jgq";  //首页金刚区点击
/*
 搜索商品
 xlt_item_search_keyword:搜索内容
*/
static NSString * const XLT_EVENT_SEARCH = @"xlt_event_search";
/*
 复制链接搜索
 xlt_item_search_keyword:搜索内容
*/
static NSString * const XLT_EVENT_POPUP = @"xlt_event_popup";

/*
 搜索结果点击
 xlt_item_search_keyword:搜索内容
*/
static NSString * const XLT_EVENT_SEARCHRESULT_CLICK = @"SearchResultClick";

/*
 推送点击
 xlt_item_search_keyword:搜索内容
*/
static NSString * const XLT_EVENT_PUSH_CLICK = @"PushClick";

/**
 * 板块点击
 * xlt_item_id:_id
 * xlt_item_pid:pid
 * xlt_item_title:title
 */
static NSString * const XLT_EVENT_PLATE = @"xlt_event_plate";


/**
* 首页模块点击
*  xlt_item_id:_id
*  xlt_item_title:title
*/
static NSString * const XLT_EVENT_HOME_MODULCLICK = @"xlt_event_home_modulclick";

/**
 * 首页tab点击
 * xlt_item_title:首页、分类、收藏、个人中心
 */
static NSString * const XLT_EVENT_HOME_TAB = @"xlt_event_home_tab";


/*
首页banner
banner_id:_id
banner_name:title
url:link_url
banner_rank：banner排序
*/
static NSString * const XLT_EVENT_HOME_BANNER = @"xlt_event_home_banner";  //首页banner

/*
 首页每日推荐
xlt_item_id:_id
 xlt_item_title:title
 xlt_item_good_id:item_id
 xlt_item_source:item_source
 */
static NSString * const XLT_EVENT_HOME_RECOMMEND_DAY = @"xlt_event_home_recommend_day";  //首页每日推荐
/*
 首页为你推荐等分类点击
 xlt_item_title:对应点击的title
 */
static NSString * const XLT_EVENT_HOME_RECOMMEND = @"xlt_event_home_recommend";    //为你推荐等分类点击

/* 分类 properties
xlt_item_id:_id
xlt_item_title:name
xlt_item_level:level

*/
static NSString * const XLT_EVENT_HOME_CATEGORY = @"xlt_event_home_category";    //首页分类点击


//收藏
static NSString * const XLT_EVENT_FAVORITE_MANAGE = @"xlt_event_favorite_manage";//收藏管理事件

//商品详情
/*
商品详情领取优惠券事件
商品信息
xlt_item_id:_id
xlt_item_title:item_title
xlt_item_source:item_source
优惠券信息
xlt_item_coupon_amount:amount
xlt_item_coupon_id:coupon_id
*/
static NSString * const XLT_EVENT_GOODDETAIL_COUPON = @"xlt_event_gooddetail_coupon";//商品详情领取优惠券事件
/*
商品进入店铺事件
商品信息
xlt_item_id:_id
xlt_item_title:item_title
xlt_item_source:item_source
店铺信息
xlt_item_shop_id:seller_shop_id
xlt_item_shop_title:seller_shop_name
xlt_item_shop_type:seller_type
*/
static NSString * const XLT_EVENT_GOODDETAIL_SHOP = @"xlt_event_gooddetail_shop";//商品进入店铺事件
/*
商品详情点击保障事件
商品信息
xlt_item_id:_id
xlt_item_title:item_title
xlt_item_source:item_source
*/
static NSString * const XLT_EVENT_GOODDETAIL_GUARANTEE = @"xlt_event_gooddetail_guarantee";//商品详情点击保障事件
/*
 商品详情点击参数事件
 商品信息
xlt_item_id:_id
 xlt_item_title:item_title
 xlt_item_source:item_source
 */
static NSString * const XLT_EVENT_GOODDETAIL_PARAMETER = @"xlt_event_gooddetail_parameter";//商品详情点击参数事件
/*
商品详情点击首页事件
商品信息
xlt_item_id:_id
xlt_item_title:item_title
xlt_item_source:item_source
*/
static NSString * const XLT_EVENT_GOODDETAIL_HOME = @"xlt_event_gooddetail_home";//商品详情点击首页事件
/*
商品详情点击收藏事件
xlt_item_id:_id
xlt_item_title:item_title
xlt_item_source:item_source
xlt_item_collected:1 // 1、收藏  0 取消收藏
*/
static NSString * const XLT_EVENT_GOODDETAIL_FAVORITE = @"xlt_event_gooddetail_favorite";//商品详情点击收藏事件
/*
商品详情点击复制口令事件
xlt_item_id:_id
xlt_item_title:item_title
xlt_item_source:item_source
*/
static NSString * const XLT_EVENT_GOODDETAIL_COPYLINK = @"xlt_event_gooddetail_copylink";//商品详情点击复制口令事件
/*
商品详情查看全部事件
xlt_item_id:_id
xlt_item_title:item_title
xlt_item_source:item_source
*/
static NSString * const XLT_EVENT_GOODDETAIL_LOOKALL = @"xlt_event_gooddetail_lookall";//商品详情查看全部事件
/*
商品详情点击分享事件
xlt_item_id:_id
xlt_item_title:item_title
xlt_item_source:item_source
分享赚金额
xlt_item_rebate_amount:xkd_amount
*/
static NSString * const XLT_EVENT_GOODDETAIL_SHARE = @"xlt_event_gooddetail_share";//商品详情点击分享事件
/*
商品详情点击下单事件
xlt_item_id:_id
xlt_item_title:item_title
xlt_item_source:item_source
下单返利金额
xlt_item_rebate_amount:xkd_amount
*/
static NSString * const XLT_EVENT_GOODDETAIL_BUY = @"xlt_event_gooddetail_buy";//商品详情点击下单事件

//个人中心
static NSString * const XLT_EVENT_USER_SETTING = @"xlt_event_user_setting";//个人中心点击设置事件
/*
个人中心点击订单事件
xlt_item_title:对应订单title（已完成之类）
xlt_item_source_title:对应平台title
*/
static NSString * const XLT_EVENT_USER_ORDER = @"xlt_event_user_order";//个人中心点击订单事件（订单相关事件,订单分类）
static NSString * const XLT_EVENT_GROUP_ORDER = @"xlt_event_group_order";//个人中心点击粉丝订单事件（订单相关事件,订单分类）


static NSString * const XLT_EVENT_GETBACK_ORDER = @"xlt_event_getback_order";//个人中心点击找回订单
static NSString * const XLT_EVENT_USER_PROBLEM = @"xlt_event_user_problem";//个人中心点击常见问题事件
static NSString * const XLT_EVENT_USER_SERVICE = @"xlt_event_user_service";//个人中心点击在线客服事件
static NSString * const XLT_EVENT_USER_TASK = @"xlt_event_user_task";//个人中心任务
static NSString * const XLT_EVENT_USER_MENTOR = @"xlt_event_user_mentor";//联系导师

static NSString * const XLT_EVENT_GROUP_EARNINGS = @"xlt_event_group_earnings";//个人中心团购收益金额
static NSString * const XLT_EVENT_SELF_EARNINGS = @"xlt_event_self_earnings";//个人中心自购收益
static NSString * const XLT_EVENT_APP_POSTER_SHARE = @"xlt_event_app_poster_share";//个人中心分享邀请海报
static NSString * const XLT_EVENT_APP_lINk_COPY = @"xlt_event_app_link_copy";//个人中心复制邀请链接
static NSString * const XLT_EVENT_USER_COLLECTION = @"xlt_event_user_collection";//个人中心点击收藏事件




/*
个人中心点击专属推荐和我的足迹事件
xlt_item_title:对应点击title
*/
static NSString * const XLT_EVENT_USER_CATEGORY = @"xlt_event_user_category";//个人中心点击专属推荐和我的足迹事件

//仅显示有优惠券按钮点击
static NSString * const XLT_EVENT_FILTER_COUPON = @"xlt_event_filter_coupon";


/*广告位点击
xlt_item_id:_id
xlt_item_title:title
xlt_item_ad_platform:platform
xlt_item_ad_position:show_position
*/
static NSString * const XLT_EVENT_AD = @"xlt_event_ad";


/* 分类事件点击
 分类 properties
xlt_item_id:_id
 xlt_item_title:name
 xlt_item_level:level
*/
static NSString * const XLT_EVENT_CATEGORY = @"xlt_event_category";  //分类点击（包含一、二、三级）

/*
筛选事件
xlt_item_title:对应点击title
xlt_item_page:对应页面title
+所属分类或版块
*/
//筛选事件
static NSString * const XLT_EVENT_FILTER = @"xlt_event_filter";  //筛选事件

/*
商品点击
xlt_item_id:_id
xlt_item_title:item_title
xlt_item_source:item_source
xlt_item_good_id:item_id
xlt_item_good_position:商品位于列表中的位置index
 xlt_item_place:商品点击所属位置
+所属分类或版块
 */
//商品点击
static NSString * const XLT_EVENT_GOODS = @"xlt_event_goods";

/*
商品列表展示
xlt_item_goodslist_count:count(列表所加载的商品数量)
xlt_item_page:对应页面title
xlt_item_place:商品点击所属位置
+所属分类或版块
 */
static NSString * const XLT_EVENT_GOODSLIST_COUNT = @"xlt_event_goodslist_count";

/*
大数据商品推荐位点击
is_power:是否智能推荐（由接口来区分）
power_position:推荐位置（所在模块名：例猜你喜欢）
power_model:智能推荐模型参数（后台数据返回）
good_id:商品ID
good_name:商品名称
xlt_item_place:商品位置(在商品数据列表中的位置)
xlt_item_source:来源平台
 */
static NSString * const XLT_EVENT_RECOMMEN_POSITION_CLICK = @"recommend_position_click";


/*
大数据商品推荐位展示
is_power:是否智能推荐（由接口来区分）
power_position:推荐位置（所在模块名：例猜你喜欢）
power_model:智能推荐模型参数（后台数据返回）
good_id:商品ID
good_name:商品名称
xlt_item_place:商品位置(在商品数据列表中的位置)
xlt_item_source:来源平台
 */
static NSString * const XLT_EVENT_RECOMMEN_POSITION_SHOW = @"recommend_position_show";

//成员元素
static NSString * const XLT_ITEM_ID = @"xlt_item_id";
static NSString * const XLT_ITEM_NAME = @"xlt_item_name";
static NSString * const XLT_ITEM_TITLE = @"xlt_item_title";
static NSString * const XLT_ITEM_VALUE = @"xlt_item_value";

//所属于的分类
static NSString * const XLT_ITEM_FIRSTCate_ID = @"xlt_item_firstcate_id";
static NSString * const XLT_ITEM_FIRSTCate_TITLE = @"xlt_item_firstcate_title";
static NSString * const XLT_ITEM_SECONDCate_ID = @"xlt_item_secondcate_id";
static NSString * const XLT_ITEM_SECONDCate_TITLE = @"xlt_item_secondcate_title";
static NSString * const XLT_ITEM_THIRDCate_ID = @"xlt_item_thirdcate_id";
static NSString * const XLT_ITEM_THIRDCate_TITLE = @"xlt_item_thirdcate_title";
//所属版块
static NSString * const XLT_ITEM_FIRSTPLATE_ID = @"xlt_item_firstplatle_id";
static NSString * const XLT_ITEM_FIRSTPLATE_TITLE = @"xlt_item_firstplatle_title";
static NSString * const XLT_ITEM_SECONDPLATE_ID = @"xlt_item_secondplatle_id";
static NSString * const XLT_ITEM_SECONDPLATE_TITLE = @"xlt_item_secondplatle_title";
static NSString * const XLT_ITEM_THIRDPLATE_ID = @"xlt_item_thirdplatle_id";
static NSString * const XLT_ITEM_THIRDPLATE_TITLE = @"xlt_item_thirdplatle_title";

static NSString * const XLT_ITEM_SEARCHKEY = @"xlt_item_searchkey";
static NSString * const XLT_ITEM_GOOD_POSITION = @"xlt_item_good_position";      //所在位置（商品所在列表的位置）

static NSString * const XLT_ITEM_AD_POSITION = @"xlt_item_ad_position";      //广告位置
static NSString * const XLT_ITEM_AD_PLATForm = @"xlt_item_ad_platform";      //广告来源

static NSString * const XLT_ITEM_GOOD_ID = @"xlt_item_good_id";     //每日推荐商品id
static NSString * const XLT_ITEM_SOURCE = @"xlt_item_source";       //来源
static NSString * const XLT_ITEM_SOURCE_TITLE = @"xlt_item_source_title";       //来源名称

static NSString * const XLT_ITEM_COUPON_ID = @"xlt_item_coupon_id";       //优惠券id
static NSString * const XLT_ITEM_COUPON_AMOUNT = @"xlt_item_coupon_amount";       //优惠券金额

static NSString * const XLT_ITEM_REBATE_AMOUNT = @"xlt_item_rebate_amount";       //返利

static NSString * const XLT_ITEM_MODULE = @"xlt_item_module";    //所属模块(首页，分类等)
static NSString * const XLT_ITEM_Page = @"xlt_item_page";    //所属页面title
static NSString * const XLT_ITEM_GOODSLIST_COUNT = @"xlt_item_goodslist_count";    //所属页面加载商品数量
/**
  店铺元素
 */
static NSString * const XLT_ITEM_SHOP_ID = @"xlt_item_shop_id";         //店铺ID
static NSString * const XLT_ITEM_SHOP_TITLE = @"xlt_item_shop_title";   //店铺Title
static NSString * const XLT_ITEM_SHOP_TYPE = @"xlt_item_shop_type";     //店铺Type


    /**
     * 首页-为你推荐：homepage_unique_recommend
     * 首页-推荐天猫：homepage_unique_tm_recommend
     * 首页-推荐淘宝：homepage_unique_tb_recommend
     * 首页-推荐京东：homepage_unique_jd_recommend
     * 收藏夹-猜你喜欢：collection_guessyoulike
     * 详情页-店铺推荐：item_details_recommend
     * 详情页-大家都在买：item_details_popular
     * 我的-专属推荐：personal_center_exclusive_recommend
     * 我的-我的足迹：personal_center_browsing_history
     */
static NSString * const XLT_ITEM_PLACE = @"xlt_item_place";// 商品点击所属位置
/*
 大数据推荐新增元素
 xlt_item_place:在此事件中定义为商品在数据列表中的位置
 */
static NSString * const XLT_IS_POWER = @"is_power";
static NSString * const XLT_POWER_POSITION = @"power_position";
static NSString * const XLT_POWER_MODEL = @"power_model";
static NSString * const XLT_GOOD_ID = @"good_id";
static NSString * const XLT_GOOD_NAME = @"good_name";
