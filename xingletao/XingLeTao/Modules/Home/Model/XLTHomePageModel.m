//
//  XLTHomePageModel.m
//  XingLeTao
//
//  Created by chenhg on 2020/7/6.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTHomePageModel.h"
#import "NSObject+YYModel.h"
#import "XLTNetworkCache.h"
#import "XLTHomePageLogic.h"
#import "XLTHomePageTopHeadView.h"

@implementation XLTHomeCategoryModel

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone*)zone {
    return [self modelCopy];
}

- (NSUInteger)hash {
    return [self modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}
@end


NSString *const XLTHomeTopCycleBannerModuleType = @"1001";
NSString *const XLTHomeKingKongModuleType = @"1002";
NSString *const XLTHomeSingleBannerModuleType = @"1003";
NSString *const XLTHomeTwoBannerBigModuleType = @"1004";
NSString *const XLTHomeTwoBannerModuleType = @"1005";
NSString *const XLTHomeScrollGoodsModuleType = @"1006";
NSString *const XLTHomeDiscoverGoodsModuleType = @"1007";
NSString *const XLTHomeFourBannerModuleType = @"1008";
NSString *const XLTHomeDailyRecommendModuleType = @"AppLocalModule_Daily";
NSString *const XLTHomeEmptyModuleType = @"AppLocalModule_EmptyModule";

// 模块元素点击通知
NSString *const XLTHomeModuleItemClickedNotification = @"kXLTHomeModuleItemClickedNotification";
// 模块商品点击通知
NSString *const XLTHomeGoodsItemClickedNotification = @"kXLTHomeGoodsItemClickedNotification";
@implementation XLTHomeModuleItemModel

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone*)zone {
    return [self modelCopy];
}

- (NSUInteger)hash {
    return [self modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}

- (void)setItemData:(NSArray *)itemData {
    _itemData = itemData;
    [self predDownloadItemDataImages:itemData];
}

- (void)predDownloadItemDataImages:(NSArray *)itemData {
    if ([itemData isKindOfClass:[NSArray class]]) {
        [itemData enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *imageString = info[@"image"];
            if ([imageString isKindOfClass:[NSString class]]) {
                NSURL *imageURL = [NSURL URLWithString:[imageString letaoConvertToHttpsUrl]];
                if (imageURL) {
                     [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:@[imageURL]];
                }
            }
        }];

    }
}

@end

@implementation XLTHomeModuleModel

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone*)zone {
    return [self modelCopy];
}

- (NSUInteger)hash {
    return [self modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}


- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super init];
    if (self) {
        [self parserModulesInfo:info];
    }
    return self;
}

- (void)setBgImageUrl:(NSString *)bgImageUrl {
    _bgImageUrl = bgImageUrl.copy;
    [self predDownloadItemBgImage:bgImageUrl];

}

- (void)predDownloadItemBgImage:(NSString *)imageString {
    if ([imageString isKindOfClass:[NSString class]]) {
        NSURL *imageURL = [NSURL URLWithString:[imageString letaoConvertToHttpsUrl]];
        if (imageURL) {
             [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:@[imageURL]];
        }
    }
}



+ (CGFloat)homeScaleContentHeight:(CGFloat)height sectionCount:(NSInteger)sectionCount {
    static CGFloat leftMargin = 10.0;
    static CGFloat rightMargin = 10.0;
    CGFloat space = (leftMargin + rightMargin + MAX(0, kContentItemMargin *(sectionCount -1)));
    return ceil(height * ((kScreenWidth - space)/(375.0 - space)));
    
}


- (void)parserModulesInfo:(NSDictionary *)info {
    if ([info isKindOfClass:[NSDictionary class]]) {
        self.modulesItemArray = [self parserModulesItemArrayWithInfo:info];
        NSString *moduleTitle = info[@"moduleTitle"];
        NSString *moduleSubtitle = info[@"moduleSubtitle"];
        NSString *moduleTagText = info[@"moduleTagText"];
        NSString *bgImageUrl = info[@"bgImage"];
        NSString *bgColorText = info[@"bgColor"];
        if ([moduleTitle isKindOfClass:[NSString class]]) {
            self.moduleTitle = moduleTitle;
        }
        if ([moduleSubtitle isKindOfClass:[NSString class]]) {
            self.moduleSubtitle = moduleSubtitle;
        }
        if ([moduleTagText isKindOfClass:[NSString class]]) {
            self.moduleTagText = moduleTagText;
        }
        if ([bgImageUrl isKindOfClass:[NSString class]]) {
            self.bgImageUrl = bgImageUrl;
        }
        if ([bgColorText isKindOfClass:[NSString class]]) {
            self.bgColorText = bgColorText;
        }
    }
}

- (NSArray * _Nullable)parserModulesItemArrayWithInfo:(NSDictionary *)info {
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSString *moduleType = [NSString stringWithFormat:@"%@",info[@"type"]];
        NSArray *itemArray = info[@"data"];
        NSNumber *margin = info[@"margin"];
        if ([self isTopCycleBannerModuleType:moduleType]) {
            //1.顶部banner
            return [self creatTopCycleBannerModuleItemArray:itemArray];
        } else if([self isKingKongModuleType:moduleType]) {
            //2.金刚区
            return [self creatKingKongModuleItemArray:itemArray];
        } else if([self isSingleBannerModuleType:moduleType]) {
            //3.单行banner
            return [self creatSingleBannerModuleItemArray:itemArray margin:margin];
        } else if([self isTwoBannerModuleType:moduleType]) {
            //4.banner一行两个 85高
            return [self creatTwoBannerModuleItemArray:itemArray];
        } else if([self isTwoBannerBigModuleType:moduleType]) {
            //5.banner一行两个 95高
            return [self creatTwoBannerBigModuleItemArray:itemArray];
        } else if([self isFourBannerModuleType:moduleType]) {
            //6.banner一行四个
            return [self creatFourBannerModuleItemArray:itemArray];
        } else if([self isDiscoverGoodsModuleType:moduleType]) {
            //7.限时秒杀和发现好货
            return [self creatDiscoverGoodsModuleItemArray:itemArray];
        } else if([self isScrollGoodsModuleType:moduleType]) {
            //8.限时秒杀和发现好货
            return [self creatScrollGoodsModuleItemArray:itemArray];
        }
    
    }
    return nil;
}


//1.顶部banner
- (BOOL)isTopCycleBannerModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeTopCycleBannerModuleType]);
}

- (NSArray *)creatTopCycleBannerModuleItemArray:(NSArray *)itemArray {
    NSMutableArray *modulesItemArray = [NSMutableArray array];
    if ([itemArray isKindOfClass:[NSArray class]] && itemArray.count > 0) {
        XLTHomeModuleItemModel *item = [[XLTHomeModuleItemModel alloc] init];
        // 底部间距kTopBannerBottom 由本身间隙和空cell拼成，保证界面布局都是顶部为0开始，所以这里是半个间隙
        CGFloat moduleHeight = kTopBannerContentHeight + kTopBannerBottom/2;
        item.itemHeight = moduleHeight;
        item.contentHeight = kTopBannerContentHeight;
        item.itemType = XLTHomeTopCycleBannerModuleType;
        item.itemData = itemArray;
        [modulesItemArray addObject:item];
        
        self.moduleType = XLTHomeTopCycleBannerModuleType;
        self.moduleHeight = moduleHeight;
    }
    return modulesItemArray;
}





//2.金刚区
- (BOOL)isKingKongModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeKingKongModuleType]);
}

- (NSArray *)creatKingKongModuleItemArray:(NSArray *)itemArray {
    NSMutableArray *modulesItemArray = [NSMutableArray array];
    if ([itemArray isKindOfClass:[NSArray class]] && itemArray.count > 0) {
        CGFloat imageHeight = 44;
        CGFloat textHeight =  16;
        CGFloat textTopMargin = 3;
        CGFloat itemSpace = 12.0;

        
        CGFloat bottomIndicatorHeight = 0;
        NSInteger rowCount = 0;
        if (itemArray.count <  15) {
            // 2行显示规则
            bottomIndicatorHeight = itemArray.count > 10 ? (26) : 15;
            rowCount = MIN(2, itemArray.count);
        } else {
            // 三行显示
            bottomIndicatorHeight = itemArray.count > 15 ? (26) : 15;
            rowCount = MIN(3, itemArray.count);
        }

        CGFloat modulesHeight = (imageHeight + textHeight + textTopMargin) * rowCount + MAX((rowCount - 1), 0)*itemSpace + bottomIndicatorHeight;
        XLTHomeModuleItemModel *item = [[XLTHomeModuleItemModel alloc] init];
        item.itemHeight = modulesHeight;
        item.contentHeight = modulesHeight;
        item.itemType = XLTHomeKingKongModuleType;
        item.itemData = itemArray;
        [modulesItemArray addObject:item];
        
        self.moduleType = XLTHomeKingKongModuleType;
        self.moduleHeight = modulesHeight;
    }
    return modulesItemArray;
}


//3.单行banner
- (BOOL)isSingleBannerModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeSingleBannerModuleType]);
}

- (NSArray *)creatSingleBannerModuleItemArray:(NSArray *)itemArray margin:(NSNumber *)margin {
    NSMutableArray *modulesItemArray = [NSMutableArray array];
    if ([itemArray isKindOfClass:[NSArray class]] && itemArray.count > 0) {
        __block CGFloat moduleHeight = 0;
        [itemArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass: [NSDictionary class]]) {
                NSNumber *contentHeight = obj[@"height"];
                CGFloat scaleContentHeight = 0;
                if ([contentHeight isKindOfClass:[NSNumber class]] && [contentHeight integerValue] > 0) {
                    scaleContentHeight = kScreen_iPhone375Scale(([contentHeight floatValue]/3.0));
                } else {
                    scaleContentHeight = kScreen_iPhone375Scale(95.0);
                }
                XLTHomeModuleItemModel *item = [[XLTHomeModuleItemModel alloc] init];
                item.itemHeight = scaleContentHeight;
                item.contentHeight = scaleContentHeight;
                item.itemType = XLTHomeSingleBannerModuleType;
                item.itemData = @[obj];
                [modulesItemArray addObject:item];
                if (!(moduleHeight > 0)) {
                    moduleHeight = scaleContentHeight;
                }
            }

        }];
        self.moduleType = XLTHomeSingleBannerModuleType;
//        if ([margin isKindOfClass:[NSNumber class]] && [margin boolValue]) {
//            moduleHeight += kModuletBottomMargin;
//        }
        self.moduleHeight = moduleHeight + kModuletBottomMargin;
    }
    return modulesItemArray;
}



//4.banner一行两个
- (BOOL)isTwoBannerModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeTwoBannerModuleType]);
}
/*
- (NSArray *)sectionArray:(NSArray *)sourceArr sectionCount:(NSInteger)sectionCount {
    NSMutableArray *sourceM = [sourceArr mutableCopy];
    NSInteger count = sourceArr.count / sectionCount;
    
    NSMutableArray *temp = [NSMutableArray array];
    
    for (NSInteger i = 0; i < count; i++) {
        NSInteger loc =  MAX(sectionCount*i - 1, 0);
        NSArray *arr = [sourceM subarrayWithRange:NSMakeRange(loc, sectionCount)];
        [temp addObject:arr];
    }
    // 切出余数
    NSInteger leftCount = sourceArr.count - count * sectionCount;
    if (leftCount > 0) {
        NSArray *leftArr = [sourceM subarrayWithRange:NSMakeRange(count * sectionCount, leftCount)];
        [temp addObject:leftArr];
    }
    NSArray *resultArr = [temp copy];
    return resultArr;
}*/

- (NSArray *)creatTwoBannerModuleItemArray:(NSArray *)itemArray {
    NSMutableArray *modulesItemArray = [NSMutableArray array];
    if ([itemArray isKindOfClass:[NSArray class]] && itemArray.count > 0) {
        __block CGFloat moduleHeight = 0;
        NSInteger sectionCount = 2;
        NSArray *sectionArray = itemArray;
        NSUInteger count = sectionArray.count;

        [sectionArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass: [NSDictionary class]]) {
                CGFloat scaleContentHeight = [XLTHomeModuleModel homeScaleContentHeight:85.0 sectionCount:sectionCount];
                XLTHomeModuleItemModel *item = [[XLTHomeModuleItemModel alloc] init];
                if (idx == count - 1) {
                    item.itemHeight = scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kModuletBottomMargin sectionCount:sectionCount];
                } else {
                    item.itemHeight = scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kContentBottomMargin sectionCount:sectionCount];
                }
                item.contentHeight = scaleContentHeight;
                item.itemType = XLTHomeTwoBannerModuleType;
                item.itemData = @[obj];
                [modulesItemArray addObject:item];
                if (idx % sectionCount == 0) {
                    BOOL isLastRow = (idx + sectionCount) >= count;
                    if (isLastRow) {
                        moduleHeight += (scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kModuletBottomMargin sectionCount:sectionCount]);
                    } else {
                        moduleHeight += (scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kContentBottomMargin sectionCount:sectionCount]);
                    }
                }
            }

        }];
        self.moduleType = XLTHomeTwoBannerModuleType;
        self.moduleHeight = moduleHeight;
    }
    return modulesItemArray;
}

//5.banner一行两个Big
- (BOOL)isTwoBannerBigModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeTwoBannerBigModuleType]);
}

- (NSArray *)creatTwoBannerBigModuleItemArray:(NSArray *)itemArray {
    NSMutableArray *modulesItemArray = [NSMutableArray array];
    if ([itemArray isKindOfClass:[NSArray class]] && itemArray.count > 0) {
        __block CGFloat moduleHeight = 0;
        NSInteger sectionCount = 2;
        NSArray *sectionArray = itemArray;
        NSUInteger count = sectionArray.count;
        [sectionArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass: [NSDictionary class]]) {
                CGFloat scaleContentHeight = [XLTHomeModuleModel homeScaleContentHeight:95.0 sectionCount:sectionCount];
                XLTHomeModuleItemModel *item = [[XLTHomeModuleItemModel alloc] init];
                if (idx == count - 1) {
                    item.itemHeight = scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kModuletBottomMargin sectionCount:sectionCount];
                } else {
                    item.itemHeight = scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kContentBottomMargin sectionCount:sectionCount];
                }
                item.contentHeight = scaleContentHeight;
                item.itemType = XLTHomeTwoBannerBigModuleType;
                item.itemData = @[obj];
                [modulesItemArray addObject:item];
                if (idx % sectionCount == 0) {
                    BOOL isLastRow = (idx + sectionCount) >= count;
                    if (isLastRow) {
                        moduleHeight += (scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kModuletBottomMargin sectionCount:sectionCount]);
                    } else {
                        moduleHeight += (scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kContentBottomMargin sectionCount:sectionCount]);
                    }
                }
            }

        }];
        self.moduleType = XLTHomeTwoBannerBigModuleType;
        self.moduleHeight = moduleHeight;
    }
    return modulesItemArray;
}



//6.banner一行四个
- (BOOL)isFourBannerModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeFourBannerModuleType]);
}

- (NSArray *)creatFourBannerModuleItemArray:(NSArray *)itemArray {
    NSMutableArray *modulesItemArray = [NSMutableArray array];
    if ([itemArray isKindOfClass:[NSArray class]] && itemArray.count > 0) {
        __block CGFloat moduleHeight = 0;
        NSInteger sectionCount = 4;
        NSArray *sectionArray = itemArray;
        NSUInteger count = sectionArray.count;
        [sectionArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass: [NSDictionary class]]) {
                CGFloat scaleContentHeight = [XLTHomeModuleModel homeScaleContentHeight:110.0 sectionCount:sectionCount];
                XLTHomeModuleItemModel *item = [[XLTHomeModuleItemModel alloc] init];
                if (idx == count - 1) {
                    item.itemHeight = scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kModuletBottomMargin sectionCount:sectionCount];
                } else {
                    item.itemHeight = scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kContentBottomMargin sectionCount:sectionCount];
                }
                item.contentHeight = scaleContentHeight;
                item.itemType = XLTHomeFourBannerModuleType;
                item.itemData = @[obj];
                [modulesItemArray addObject:item];

                if (idx % sectionCount == 0) {
                    BOOL isLastRow = (idx + sectionCount) >= count;
                    if (isLastRow) {
                        moduleHeight += (scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kModuletBottomMargin sectionCount:sectionCount]);
                    } else {
                        moduleHeight += (scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kContentBottomMargin sectionCount:sectionCount]);
                    }
                }
            }

        }];
        self.moduleType = XLTHomeFourBannerModuleType;
        self.moduleHeight = moduleHeight;
    }
    return modulesItemArray;
}


//7.限时秒杀和发现好货
- (BOOL)isDiscoverGoodsModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeDiscoverGoodsModuleType]);
}


- (NSArray *)creatDiscoverGoodsModuleItemArray:(NSArray *)itemArray {
    NSMutableArray *modulesItemArray = [NSMutableArray array];
    if ([itemArray isKindOfClass:[NSArray class]] && itemArray.count > 0) {
        __block CGFloat moduleHeight = 0;
        NSInteger sectionCount = 2;
        NSArray *sectionArray = itemArray;
        NSUInteger count = sectionArray.count;
        [sectionArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass: [NSDictionary class]]) {
                CGFloat scaleContentHeight = [XLTHomeModuleModel homeScaleContentHeight:165.0 sectionCount:sectionCount];
                XLTHomeModuleItemModel *item = [[XLTHomeModuleItemModel alloc] init];
                if (idx == count - 1) {
                    item.itemHeight = scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kModuletBottomMargin sectionCount:sectionCount];
                } else {
                    item.itemHeight = scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kContentBottomMargin sectionCount:sectionCount];
                }
                item.contentHeight = scaleContentHeight;
                item.itemType = XLTHomeDiscoverGoodsModuleType;
                item.itemData = @[obj];
                [modulesItemArray addObject:item];
                
                if (idx % sectionCount == 0) {
                    BOOL isLastRow = (idx + sectionCount) >= count;
                    if (isLastRow) {
                        moduleHeight += (scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kModuletBottomMargin sectionCount:sectionCount]);
                    } else {
                        moduleHeight += (scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kContentBottomMargin sectionCount:sectionCount]);
                    }
                }
            }

        }];
        self.moduleType = XLTHomeDiscoverGoodsModuleType;
        self.moduleHeight = moduleHeight;
    }
    return modulesItemArray;
}


//8.大额神券（滑动商品）
- (BOOL)isScrollGoodsModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeScrollGoodsModuleType]);
}

- (NSArray *)creatScrollGoodsModuleItemArray:(NSArray *)itemArray {
    NSMutableArray *modulesItemArray = [NSMutableArray array];
    if ([itemArray isKindOfClass:[NSArray class]] && itemArray.count > 0) {
        __block CGFloat moduleHeight = 0;
        NSInteger sectionCount = 1;
        NSUInteger count = itemArray.count;
        [itemArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass: [NSDictionary class]]) {
                CGFloat scaleContentHeight = [XLTHomeModuleModel homeScaleContentHeight:189.0 sectionCount:sectionCount];
                XLTHomeModuleItemModel *item = [[XLTHomeModuleItemModel alloc] init];
                if (idx == count - 1) {
                    item.itemHeight = scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kModuletBottomMargin sectionCount:sectionCount];
                } else {
                    item.itemHeight = scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kContentBottomMargin sectionCount:sectionCount];
                }
                item.contentHeight = scaleContentHeight;
                item.itemType = XLTHomeScrollGoodsModuleType;
                item.itemData = @[obj];
                [modulesItemArray addObject:item];
                
                if (idx % sectionCount == 0) {
                    BOOL isLastRow = (idx + sectionCount) >= count;
                    if (isLastRow) {
                        moduleHeight += (scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kModuletBottomMargin sectionCount:sectionCount]);
                    } else {
                        moduleHeight += (scaleContentHeight + [XLTHomeModuleModel homeScaleContentHeight:kContentBottomMargin sectionCount:sectionCount]);
                    }
                }
            }

        }];
        self.moduleType = XLTHomeScrollGoodsModuleType;
        self.moduleHeight = moduleHeight;
    }
    return modulesItemArray;
}

@end



@interface XLTHomePageModel  ()

@end

@implementation XLTHomePageModel

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone*)zone {
    return [self modelCopy];
}

- (NSUInteger)hash {
    return [self modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}

- (instancetype)initCheckEnableData {
    NSDictionary *info = [[NSDictionary alloc] init];
    return [self initWithPageInfo:info];
}


- (instancetype)initWithPageInfo:(NSDictionary *)info {
    self = [super init];
    if (self) {
        self.modulesArray = [self parserModulesArrayWithPageInfo:info];
        
        // 再次处理一些业务布局数据
        if (self.modulesArray.count > 0) {
            // 是否有顶部滑动banner
            XLTHomeModuleModel *cycleBannerModule = self.modulesArray.firstObject;
            BOOL hasCycleBannerModuleType  = ([cycleBannerModule isKindOfClass:[XLTHomeModuleModel class]] && [cycleBannerModule isTopCycleBannerModuleType:cycleBannerModule.moduleType]);
            if (!hasCycleBannerModuleType) {
                // 设置一个包含高度 但是不包含数据的空banner，避免第一行间隙问题
                XLTHomeModuleModel *emptyBannerModule = [[XLTHomeModuleModel alloc] init];
                emptyBannerModule.moduleType = XLTHomeEmptyModuleType;
                emptyBannerModule.moduleHeight = kTopBannerBottom/2;
                NSMutableArray *modulesArray = [NSMutableArray arrayWithObject:emptyBannerModule];
                [modulesArray addObjectsFromArray:self.modulesArray];
                self.modulesArray = modulesArray;
            } else {
                // 插入banner
                NSMutableArray *modulesArray = [NSMutableArray arrayWithObject:cycleBannerModule];
                // 插入banner底部空间隙
                XLTHomeModuleModel *emptyBannerModule = [[XLTHomeModuleModel alloc] init];
                emptyBannerModule.moduleType = XLTHomeEmptyModuleType;
                emptyBannerModule.moduleHeight = kTopBannerBottom/2;
                [modulesArray addObject:emptyBannerModule];
                // 插入其他数据
                [self.modulesArray enumerateObjectsUsingBlock:^(XLTHomeModuleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj != cycleBannerModule) {
                        [modulesArray addObject:obj];
                    }
                }];
                self.modulesArray = modulesArray;
            }
        }
        
        self.categoryArray = [self parserCategoryArrayWithPageInfo:info];
    }
    return self;
}

- (NSArray *)parserModulesArrayWithPageInfo:(NSDictionary *)info {
    NSMutableArray *modulesArray = [NSMutableArray array];
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSDictionary *pageInfo = info[@"page"];
        if ([pageInfo isKindOfClass:[NSDictionary class]]) {
            NSArray *topArray = pageInfo[@"top"];
            NSArray *middleArray = pageInfo[@"middle"];
            NSMutableArray *array = [NSMutableArray array];
            if ([topArray isKindOfClass:[NSArray class]]) {
                [array addObjectsFromArray:topArray];
            }
            if ([middleArray isKindOfClass:[NSArray class]]) {
                [array addObjectsFromArray:middleArray];
            }
            if ([array isKindOfClass:[NSArray class]] && array.count >0) {
                [array enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        XLTHomeModuleModel *moduleModel = [[XLTHomeModuleModel alloc] initWithInfo:obj];
                        if (moduleModel.modulesItemArray.count > 0) {
                            [modulesArray addObject:moduleModel];
                        }
                    }
                }];
            }
        }
    }
    return modulesArray;
}

- (NSArray *)parserCategoryArrayWithPageInfo:(NSDictionary *)info {
    NSMutableArray *categoryArray = [NSMutableArray array];
    // 推荐分类
    XLTHomeCategoryModel *allCategory = [XLTHomePageLogic letaoDefualtCategory];
    [categoryArray addObject:allCategory];
    
    // 猜你喜欢
    XLTHomeCategoryModel *guessYouLikeCategory = [XLTHomePageLogic letaoLocalGuessYouLikeCategory];
    [categoryArray addObject:guessYouLikeCategory];
    
    
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSArray *category = info[@"category"];
        if ([category isKindOfClass:[NSArray class]] && category.count >0) {
            [category enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    XLTHomeCategoryModel *categoryModel = [XLTHomeCategoryModel modelWithDictionary:obj];
                    if (categoryModel) {
                        [categoryArray addObject:categoryModel];
                    }
                }
            }];
        }
    }

    return categoryArray;
}

- (void)updateDailyRecommendData:(NSArray *)dailyRecommendArray {
    if ([dailyRecommendArray isKindOfClass:[NSArray class]] && dailyRecommendArray.count > 0) {
        //  删除之前的
        NSMutableArray *modulesArray = self.modulesArray.mutableCopy;
        NSInteger dailyIndex = modulesArray.count - 2;
        if (dailyIndex >= 0 && dailyIndex < modulesArray.count) {
            
            // 删除dailyModuleModel 和他后面空间隔cell
            XLTHomeModuleModel *dailyModuleModel = modulesArray[dailyIndex];
            if ([dailyModuleModel.moduleType isKindOfClass:[NSString class]] && [dailyModuleModel.moduleType isEqualToString:XLTHomeDailyRecommendModuleType]) {
                [modulesArray removeObject:dailyModuleModel];
                
                // 删除后面空间隔cell
                XLTHomeModuleModel *emptyBannerModule = modulesArray.lastObject;
                if ([emptyBannerModule.moduleType isKindOfClass:[NSString class]] && [emptyBannerModule.moduleType isEqualToString:XLTHomeEmptyModuleType]) {
                    [modulesArray removeObject:emptyBannerModule];
                }
            }
        }


        
        // add
        CGFloat height = 35.0;
        XLTHomeModuleModel *moduleModel = [[XLTHomeModuleModel alloc] init];
        moduleModel.moduleType = XLTHomeDailyRecommendModuleType;
        moduleModel.moduleHeight = height;
        XLTHomeModuleItemModel *item = [[XLTHomeModuleItemModel alloc] init];
        item.itemHeight = height;
        item.contentHeight = height;
        item.itemType = XLTHomeDailyRecommendModuleType;
        item.itemData = dailyRecommendArray;
        moduleModel.modulesItemArray = @[item];
        [modulesArray addObject:moduleModel];
        
        // 增加空间隔cell
        XLTHomeModuleModel *emptyBannerModule = [[XLTHomeModuleModel alloc] init];
        emptyBannerModule.moduleType = XLTHomeEmptyModuleType;
        emptyBannerModule.moduleHeight = kModuletBottomMargin;
        [modulesArray addObject:emptyBannerModule];
        
        self.modulesArray = modulesArray;
    }
}
@end


