//
//  XLTHomeCellsFactory.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/2.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomeCellsFactory.h"
#import "XLTHomeCycleBannerCollectionViewCell.h"
#import "XLTHomeKingKongCell.h"
#import "XLTHomeSingleGoodsCollectionViewCell.h"
#import "XLTUIConstant.h"
#import "XLTHomeSingleBannerCell.h"
#import "XLTHomeTwoBannerBigCell.h"
#import "XLTHomeTwoBannerCell.h"
#import "XLTHomeFourBannerCell.h"
#import "XLTHomeDiscoverGoodsCell.h"
#import "XLTHomeScrollGoodsCell.h"
#import "XLTHomeCycleDailyCell.h"
#import "XLTHomeEmptyModuleTypeCell.h"

@implementation XLTHomeCellsFactory

/// 轮播图
static NSString *const kXLTHomeCycleBannerCollectionViewCell = @"XLTHomeCycleBannerCollectionViewCell";
/// 金刚区
static NSString *const kXLTHomeKingKongCell = @"XLTHomeKingKongCell";

/// 商品列表
static NSString *const kXLTHomeSingleGoodsCollectionViewCell = @"XLTHomeSingleGoodsCollectionViewCell";

/// 单行banner
static NSString *const kXLTHomeSingleBannerCell = @"XLTHomeSingleBannerCell";

/// banner一行两个
static NSString *const kXLTHomeTwoBannerCell = @"XLTHomeTwoBannerCell";

/// banner一行两个Big
static NSString *const kXLTHomeTwoBannerBigCell = @"XLTHomeTwoBannerBigCell";

/// banner一行四个
static NSString *const kXLTHomeFourBannerCell = @"XLTHomeFourBannerCell";

/// 限时秒杀和发现好货
static NSString *const kXLTHomeDiscoverGoodsCell = @"XLTHomeDiscoverGoodsCell";

/// 大额神券（滑动商品）
static NSString *const kXLTHomeScrollGoodsCell = @"XLTHomeScrollGoodsCell";


/// 每日推荐
static NSString *const kXLTHomeDailyRecommendCell = @"XLTHomeDailyRecommendCell";

/// 空cell
static NSString *const kXLTHomeEmptyModuleTypeCell = @"kXLTHomeEmptyModuleTypeCell";

- (void)registerCellsForCollectionView:(UICollectionView *)collectionView {
    /// 轮播图
    [collectionView registerNib:[UINib nibWithNibName:kXLTHomeCycleBannerCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeCycleBannerCollectionViewCell];
    /// 金刚区
    [collectionView registerNib:[UINib nibWithNibName:kXLTHomeKingKongCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeKingKongCell];
    
    /// 单行banner
    [collectionView registerNib:[UINib nibWithNibName:kXLTHomeSingleBannerCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeSingleBannerCell];

    /// banner一行两个
    [collectionView registerNib:[UINib nibWithNibName:kXLTHomeTwoBannerCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeTwoBannerCell];

    /// banner一行两个Big
    [collectionView registerNib:[UINib nibWithNibName:kXLTHomeTwoBannerBigCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeTwoBannerBigCell];

    /// banner一行四个
    [collectionView registerNib:[UINib nibWithNibName:kXLTHomeFourBannerCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeFourBannerCell];

    /// 限时秒杀和发现好货
    [collectionView registerNib:[UINib nibWithNibName:kXLTHomeDiscoverGoodsCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeDiscoverGoodsCell];

    /// 大额神券（滑动商品）
    [collectionView registerNib:[UINib nibWithNibName:kXLTHomeScrollGoodsCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeScrollGoodsCell];
    
    /// 推荐商品列表
    [collectionView registerNib:[UINib nibWithNibName:kXLTHomeSingleGoodsCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeSingleGoodsCollectionViewCell];
    
    /// 每日推荐
    [collectionView registerNib:[UINib nibWithNibName:kXLTHomeDailyRecommendCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeDailyRecommendCell];
    
    /// 空cell
    [collectionView registerClass:[XLTHomeEmptyModuleTypeCell class] forCellWithReuseIdentifier:kXLTHomeEmptyModuleTypeCell];
    
}


-(BOOL)isDailyRecommendModuleSection:(NSInteger)section pageModel:(XLTHomePageModel *)pageModel {
    NSUInteger modulesArrayCount = pageModel.modulesArray.count;
    if (section < modulesArrayCount) {
        XLTHomeModuleModel *moduleModel = pageModel.modulesArray[section];
        return ([moduleModel.moduleType isKindOfClass:[NSString class]] && [moduleModel.moduleType isEqualToString:XLTHomeDailyRecommendModuleType]);
    }
    return NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
               pageModel:(XLTHomePageModel *)pageModel {
    NSUInteger modulesArrayCount = pageModel.modulesArray.count;
    if (indexPath.section < modulesArrayCount) {
        XLTHomeModuleModel *moduleModel = pageModel.modulesArray[indexPath.section];
        if (moduleModel.moduleHeight > 0) {
            return CGSizeMake(collectionView.size.width, moduleModel.moduleHeight);
        }
    } else {
        return CGSizeMake(collectionView.bounds.size.width, 157.0);
    }
    return CGSizeZero;
}



- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                        pageModel:(XLTHomePageModel *)pageModel {
    NSUInteger modulesArrayCount = pageModel.modulesArray.count;
    if (indexPath.section < modulesArrayCount) {
        XLTHomeModuleModel *moduleModel = pageModel.modulesArray[indexPath.section];
        return [self collectionView:collectionView moduleCellForItemAtIndexPath:indexPath moduleModel:moduleModel];
    } else {
        NSDictionary *goodsInfo = nil;
        if (indexPath.item < pageModel.recommendGoodsArray.count) {
            goodsInfo = pageModel.recommendGoodsArray[indexPath.item];
        }
        return [self collectionView:collectionView recommendGoodsCellForItemAtIndexPath:indexPath goodsInfo:goodsInfo];
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
            recommendGoodsCellForItemAtIndexPath:(NSIndexPath *)indexPath
                                        goodsInfo:(NSDictionary *)goodsInfo {
    XLTHomeSingleGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeSingleGoodsCollectionViewCell forIndexPath:indexPath];
    [cell letaoUpdateCellDataWithInfo:goodsInfo];
    return cell;
}
    
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                     moduleCellForItemAtIndexPath:(NSIndexPath *)indexPath
                                      moduleModel:(XLTHomeModuleModel *)moduleModel {
    
    NSString *moduleType = moduleModel.moduleType;
    if ([self isTopCycleBannerModuleType:moduleType]) {
        //1.顶部banner
        return [self collectionView:collectionView creatTopCycleBannerModule:moduleModel atIndexPath:indexPath];
        
    } else if([self isKingKongModuleType:moduleType]) {
        //2.金刚区
        return [self collectionView:collectionView creatKingKongModule:moduleModel atIndexPath:indexPath];
        
    } else if([self isSingleBannerModuleType:moduleType]) {
        //3.单行banner
        return [self collectionView:collectionView creatSingleBannerModule:moduleModel atIndexPath:indexPath];
        
    } else if([self isTwoBannerModuleType:moduleType]) {
        //4.banner一行两个 85高
        return [self collectionView:collectionView creatTwoBannerModule:moduleModel atIndexPath:indexPath];
        
    } else if([self isTwoBannerBigModuleType:moduleType]) {
        //5.banner一行两个 95高
        return [self collectionView:collectionView creatTwoBannerBigModule:moduleModel atIndexPath:indexPath];
        
    } else if([self isFourBannerModuleType:moduleType]) {
        //6.banner一行四个
        return [self collectionView:collectionView creatFourBannerModule:moduleModel atIndexPath:indexPath];
        
    } else if([self isDiscoverGoodsModuleType:moduleType]) {
        //7.限时秒杀和发现好货
        return [self collectionView:collectionView creatDiscoverGoodsModule:moduleModel atIndexPath:indexPath];
        
    } else if([self isScrollGoodsModuleType:moduleType]) {
        //8.限时秒杀和发现好货
        return [self collectionView:collectionView creatScrollGoodsModule:moduleModel atIndexPath:indexPath];
    } else if([self isDailyRecommendModuleType:moduleType]) {
        // 9.每日推荐
        return [self collectionView:collectionView creatDailyRecommendModule:moduleModel atIndexPath:indexPath];
    } else {
        //10. 空cell
        return  [self collectionView:collectionView creatEmptyModule:moduleModel atIndexPath:indexPath];
    }
}

//1.顶部banner
- (BOOL)isTopCycleBannerModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeTopCycleBannerModuleType]);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView creatTopCycleBannerModule:(XLTHomeModuleModel *)moduleModel atIndexPath:(NSIndexPath *)indexPath {
    XLTHomeCycleBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeCycleBannerCollectionViewCell forIndexPath:indexPath];
    return cell;
}


//2.金刚区
- (BOOL)isKingKongModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeKingKongModuleType]);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView creatKingKongModule:(XLTHomeModuleModel *)moduleModel atIndexPath:(NSIndexPath *)indexPath {
    XLTHomeKingKongCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeKingKongCell forIndexPath:indexPath];
    NSArray *modulesItemArray = moduleModel.modulesItemArray;
    if ([modulesItemArray isKindOfClass:[NSArray class]]) {
        XLTHomeModuleItemModel *item = modulesItemArray.firstObject;
        if ([item.itemData isKindOfClass:[NSArray class]]) {
            [cell letaoUpdateCellDataWithInfo:item.itemData moduleHeight:moduleModel.moduleHeight];
        }
    }
    return cell;
}



//3.单行banner
- (BOOL)isSingleBannerModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeSingleBannerModuleType]);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView creatSingleBannerModule:(XLTHomeModuleModel *)moduleModel atIndexPath:(NSIndexPath *)indexPath {
     XLTHomeSingleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeSingleBannerCell forIndexPath:indexPath];
    [cell letaoUpdateCellDataWithInfo:moduleModel];
    return cell;
}


//4.banner一行两个
- (BOOL)isTwoBannerModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeTwoBannerModuleType]);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView creatTwoBannerModule:(XLTHomeModuleModel *)moduleModel atIndexPath:(NSIndexPath *)indexPath {
    XLTHomeTwoBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeTwoBannerCell forIndexPath:indexPath];
    [cell letaoUpdateCellDataWithInfo:moduleModel];
    return cell;
}


//5.banner一行两个Big
- (BOOL)isTwoBannerBigModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeTwoBannerBigModuleType]);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView creatTwoBannerBigModule:(XLTHomeModuleModel *)moduleModel atIndexPath:(NSIndexPath *)indexPath {
    XLTHomeTwoBannerBigCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeTwoBannerBigCell forIndexPath:indexPath];
    [cell letaoUpdateCellDataWithInfo:moduleModel];
    return cell;
}



//6.banner一行四个
- (BOOL)isFourBannerModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeFourBannerModuleType]);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView creatFourBannerModule:(XLTHomeModuleModel *)moduleModel atIndexPath:(NSIndexPath *)indexPath {
    XLTHomeFourBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeFourBannerCell forIndexPath:indexPath];
    [cell letaoUpdateCellDataWithInfo:moduleModel];
    return cell;
}


//7.限时秒杀和发现好货
- (BOOL)isDiscoverGoodsModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeDiscoverGoodsModuleType]);
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView creatDiscoverGoodsModule:(XLTHomeModuleModel *)moduleModel atIndexPath:(NSIndexPath *)indexPath {
    XLTHomeDiscoverGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeDiscoverGoodsCell forIndexPath:indexPath];
    [cell letaoUpdateCellDataWithInfo:moduleModel];
    return cell;
}




//8.大额神券（滑动商品）
- (BOOL)isScrollGoodsModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeScrollGoodsModuleType]);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView creatScrollGoodsModule:(XLTHomeModuleModel *)moduleModel atIndexPath:(NSIndexPath *)indexPath {
    XLTHomeScrollGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeScrollGoodsCell forIndexPath:indexPath];
    [cell letaoUpdateCellDataWithInfo:moduleModel];
    return cell;
}


//9.每日推荐
- (BOOL)isDailyRecommendModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeDailyRecommendModuleType]);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView creatDailyRecommendModule:(XLTHomeModuleModel *)moduleModel atIndexPath:(NSIndexPath *)indexPath {
    XLTHomeCycleDailyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeDailyRecommendCell forIndexPath:indexPath];
    
    NSArray *modulesItemArray = moduleModel.modulesItemArray;
    if ([modulesItemArray isKindOfClass:[NSArray class]]) {
        XLTHomeModuleItemModel *item = modulesItemArray.firstObject;
        if ([item.itemData isKindOfClass:[NSArray class]]) {
            [cell letaoUpdateCellDataWithInfo:item.itemData];
        }
    }
    return cell;
}


//10. 空cell
- (BOOL)isEmptyModuleType:(NSString *)moduleType {
    return ([moduleType isKindOfClass:[NSString class]] && [moduleType isEqualToString:XLTHomeEmptyModuleType]);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView creatEmptyModule:(XLTHomeModuleModel *)moduleModel atIndexPath:(NSIndexPath *)indexPath {
    XLTHomeEmptyModuleTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeEmptyModuleTypeCell forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithHex:0xFFFAFAFA];
    return cell;
}

/*

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                letaoPageDataArray:(NSArray *)letaoPageDataArray {
    if(indexPath.section == XLTHomePagesSectionCycleBannerType) {
        XLTHomeCycleBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeCycleBannerCollectionViewCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    } else if(indexPath.section == XLTHomePagesSectionKingKongType) {
        #ifdef LetaoUseNewKingKongFlag
        XLTHomeKingKongCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeKingKongCell forIndexPath:indexPath];
        if (indexPath.section < letaoPageDataArray.count) {
            NSArray *sectionArray = letaoPageDataArray[indexPath.section];
            [cell letaoUpdateCellDataWithInfo:sectionArray];
        }
        return cell;
        #else
        XLTHomeKingKongAreaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeKingKongAreaCell forIndexPath:indexPath];
        if (indexPath.section < letaoPageDataArray.count) {
            NSArray *sectionArray = letaoPageDataArray[indexPath.section];
            [cell letaoUpdateCellDataWithInfo:sectionArray];
        }
        return cell;
        #endif

    } else if(indexPath.section == XLTHomePagesSectionBannerType) {
        XLTHomeBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeBannerCollectionViewCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    } else if(indexPath.section == XLTHomePagesSectionPlateType) {
        NSDictionary *itemInfo = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray];
       return [self collectionView:collectionView cellForPlateAtIndexPath:indexPath itemInfo:itemInfo];
        
    } else if(indexPath.section == XLTHomePagesSectionDailyType) {
        XLTHomeCycleDailyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeDailyRecommendCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    } else if(indexPath.section == XLTHomePagesSectionRecommendGoodsType) {
        XLTHomeSingleGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeSingleGoodsCollectionViewCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    }
    return  [UICollectionViewCell new];
}




//item大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
               letaoPageDataArray:(NSArray *)letaoPageDataArray {
    if(indexPath.section == XLTHomePagesSectionCycleBannerType) {
        return CGSizeMake(collectionView.bounds.size.width -20, kScreen_iPhone375Scale(115));
    } else if(indexPath.section == XLTHomePagesSectionKingKongType) {
        if ([letaoPageDataArray isKindOfClass:[NSArray class]] && indexPath.section < letaoPageDataArray.count) {
            NSArray *sectionDataArray = letaoPageDataArray[indexPath.section];
            if ([sectionDataArray isKindOfClass:[NSArray class]] && sectionDataArray.count > 0) {
                #ifdef LetaoUseNewKingKongFlag
                CGFloat imageHeight = 44;
                CGFloat textHeight =  16;
                CGFloat textTopMargin = 3;
                CGFloat itemSpace = 12.0;
                CGFloat bottomIndicatorHeight = [sectionDataArray count] > 10 ? (11+2+13) : 7;
                return CGSizeMake(collectionView.size.width, (imageHeight + textHeight + textTopMargin) * 2 + itemSpace + bottomIndicatorHeight);
                #else
                CGFloat height = [XLTHomeKingKongAreaCell homeKingKongAreaCellHeightForInfo:sectionDataArray];
                return CGSizeMake(collectionView.size.width, height);
                #endif

            }
        }
        return CGSizeZero;
    } else if(indexPath.section == XLTHomePagesSectionBannerType) {
        return CGSizeMake(collectionView.bounds.size.width -20, kScreen_iPhone375Scale(59));
    } else if(indexPath.section == XLTHomePagesSectionPlateType) {
        NSDictionary *itemInfo = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray];
        return [self collectionView:collectionView layout:collectionViewLayout sizeForPlateItemAtIndexPath:indexPath itemInfo:itemInfo];
    } else if(indexPath.section == XLTHomePagesSectionDailyType) {
        return CGSizeMake(collectionView.bounds.size.width -20, 35);
    } else if(indexPath.section == XLTHomePagesSectionRecommendGoodsType) {
        return CGSizeMake(collectionView.bounds.size.width, 157);
    }
    return CGSizeMake(collectionView.bounds.size.width, 35);
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForPlateAtIndexPath:(NSIndexPath *)indexPath itemInfo:(NSDictionary *)itemInfo {
    if ([self letaoIsPlateBannerItem:itemInfo]) {
        XLTHomePlateBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomePlateBannerCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:itemInfo];
        return cell;
    } else if ([self isPlateRecommendItem:itemInfo]) {
       XLTHomePlateRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomePlateRecommendCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:itemInfo];
        return cell;
    } else if ([self isFourGoodsRecommendItem:itemInfo]) {
       XLTHomeFourGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeFourGoodsCollectionViewCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:itemInfo];
        return cell;
    } else {
        return  [UICollectionViewCell new];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForPlateItemAtIndexPath:(NSIndexPath *)indexPath
                itemInfo:(NSDictionary *)itemInfo {
    if ([self isPlateRecommendItem:itemInfo]) {
        CGFloat width = floorf((collectionView.bounds.size.width -20  -10)/2);
        // 因为间距不是等比放大，调整一个修正量offset
        CGFloat offset = ceilf(((kScreenWidth -375)/39)*8);
        CGFloat height = kScreen_iPhone375Scale(180) -offset ;
        return CGSizeMake(width, height);
    } else if ([self isFourGoodsRecommendItem:itemInfo]) {
        CGFloat offset = ceilf(((kScreenWidth -375)/39)*8);
        // 因为间距不是等比放大，调整一个修正量offset
        CGFloat height = kScreen_iPhone375Scale(186) - offset;
        return CGSizeMake(collectionView.bounds.size.width -20, height);
    } else {
        return  CGSizeZero;
    }
}

- (NSDictionary *)letaoSafeDataAtIndexPath:(NSIndexPath *)indexPath
                            letaoPageDataArray:(NSArray *)letaoPageDataArray {
    if ([letaoPageDataArray isKindOfClass:[NSArray class]]) {
        if (indexPath.section < letaoPageDataArray.count) {
            NSArray *sectionArray = letaoPageDataArray[indexPath.section];
            if ([sectionArray isKindOfClass:[NSArray class]]) {
                if (indexPath.row < sectionArray.count) {
                    return sectionArray[indexPath.row];
                }
            }
        }
    }
    return nil;
}


- (NSInteger)goodsCountPlateForItem:(NSDictionary *)intemInfo {
    if ([intemInfo isKindOfClass:[NSDictionary class]]) {
        NSNumber *goodsCount = intemInfo[@"goods_count"];
        if ([goodsCount isKindOfClass:[NSNumber class]]) {
            return [goodsCount intValue];
        }
    }
    return 0;
}

- (BOOL)letaoIsPlateBannerItem:(NSDictionary *)intemInfo {
    if ([intemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *bannerItem = intemInfo[@"show_image"];
        if ([bannerItem isKindOfClass:[NSDictionary class]]) {
            NSNumber *status = bannerItem[@"status"];
            return ([status isKindOfClass:[NSNumber class]] && [status boolValue]);
        }
    }
    return NO;
}

- (BOOL)isPlateRecommendItem:(NSDictionary *)intemInfo {
   return ([self goodsCountPlateForItem:intemInfo] == 2);
}

- (BOOL)isFourGoodsRecommendItem:(NSDictionary *)intemInfo {
   return ([self goodsCountPlateForItem:intemInfo] == 4);
}*/
@end
