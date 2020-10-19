//
//  XLTHomePageModel.h
//  XingLeTao
//
//  Created by chenhg on 2020/7/6.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kContentItemMargin 5.0
#define kContentBottomMargin 5.0
#define kModuletBottomMargin 10.0

#define  kHomeModuleDefaultBGColor [UIColor colorWithHex:0xFFFAFAFA]

extern NSString *const XLTHomeTopCycleBannerModuleType;
extern NSString *const XLTHomeKingKongModuleType;
extern NSString *const XLTHomeSingleBannerModuleType;
extern NSString *const XLTHomeTwoBannerBigModuleType;
extern NSString *const XLTHomeTwoBannerModuleType;
extern NSString *const XLTHomeScrollGoodsModuleType;
extern NSString *const XLTHomeDiscoverGoodsModuleType;
extern NSString *const XLTHomeFourBannerModuleType;
extern NSString *const XLTHomeDailyRecommendModuleType;
extern NSString *const XLTHomeEmptyModuleType;


// 模块元素点击通知
extern NSString *const XLTHomeModuleItemClickedNotification;
// 模块商品点击通知
extern NSString *const XLTHomeGoodsItemClickedNotification;
/// 分类数据
@interface XLTHomeCategoryModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSNumber *sort;
@property (nonatomic, copy) NSNumber *level;
@property (nonatomic, copy) NSString *idpath;
@property (nonatomic, copy) NSString *root_id;

@end

/// item
@interface XLTHomeModuleItemModel : NSObject  <NSCoding, NSCopying>
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, copy) NSString *itemType;
@property (nonatomic, strong) NSArray *itemData;


@end


/// 块
@interface XLTHomeModuleModel : NSObject  <NSCoding, NSCopying>
@property (nonatomic, copy) NSString *moduleType;
@property (nonatomic, assign) CGFloat moduleHeight;
@property (nonatomic, copy) NSString *moduleTitle;
@property (nonatomic, copy) NSString *moduleSubtitle;
@property (nonatomic, copy) NSString *moduleTagText;
@property (nonatomic, copy) NSString *bgImageUrl;
@property (nonatomic, copy) NSString *bgColorText;

@property (nonatomic, strong) NSArray<XLTHomeModuleItemModel *> *modulesItemArray;

+ (CGFloat)homeScaleContentHeight:(CGFloat)height sectionCount:(NSInteger)sectionCount;


@end

/// 页面
@interface XLTHomePageModel : NSObject <NSCoding, NSCopying>


/// 页面布局数据
@property (nonatomic, strong) NSArray<XLTHomeModuleModel *> *modulesArray;
/// 分类数据
@property (nonatomic, strong) NSArray<XLTHomeCategoryModel *> *categoryArray;

/// 推荐商品信息
@property (nonatomic, strong) NSArray<NSDictionary *> *recommendGoodsArray;

/// 数据来源是否是缓存
@property (nonatomic, assign) BOOL isLocalCacheData;

- (instancetype)initWithPageInfo:(NSDictionary *)info;

// 本地CheckEnable初始化信息
- (instancetype)initCheckEnableData;

- (void)updateDailyRecommendData:(NSArray *)dailyRecommendArray;
@end





NS_ASSUME_NONNULL_END
