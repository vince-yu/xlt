//
//  XLTGoodDetailCellFactory.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsDetailCellsFactory.h"
#import "XLDGoodsCouponCollectionViewCell.h"
#import "XLDGoodsEarnCollectionViewCell.h"
#import "XLDGoodsInfoMemberUpgradeCell.h"
#import "XLDGoodsPostageCollectionViewCell.h"
#import "XLDGoodsPledgeCollectionViewCell.h"
#import "XLDGoodsArgumentsCollectionViewCell.h"
#import "XLDGoodsStoreCollectionViewCell.h"
#import "XLDGoodsStoreRecomendCollectionViewCell.h"
#import "XLDGoodsStoreRecomendHeaderView.h"
#import "XLDGoodsTextCollectionViewCell.h"
#import "XLDGoodsImageCollectionViewCell.h"
#import "XLDGoodsNoneDetailHeaderView.h"
#import "XLTHomeCategoryGoodsCollectionViewCell.h"
#import "XLTUIConstant.h"

#import "XLDGoodsInfoTopImageCell.h"
#import "XLDGoodsInfoPriceCell.h"
#import "XLDGoodsInfoTitleTextCell.h"
#import "XLDGoodsInfoPrePaidDateCell.h"
#import "XLDGoodsInfoPrePaidDiscountCell.h"
#import "XLDGoodsEditorsRecommendCell.h"

@implementation XLTGoodsDetailCellsFactory


//头部焦点图
static NSString *const kXLDGoodsInfoTopImageCell = @"XLDGoodsInfoTopImageCell";
// 商品价格
static NSString *const kXLDGoodsInfoPriceCell = @"XLDGoodsInfoPriceCell";
//商品title、店铺名字和销量
static NSString *const kXLDGoodsInfoTitleTextCell = @"XLDGoodsInfoTitleTextCell";
//预售时间
static NSString *const kXLDGoodsInfoPrePaidDateCell = @"XLDGoodsInfoPrePaidDateCell";
//预售折扣
static NSString *const kXLDGoodsInfoPrePaidDiscountCell = @"XLDGoodsInfoPrePaidDiscountCell";

//推荐语
static NSString *const kXLDGoodsEditorsRecommendCell = @"XLDGoodsEditorsRecommendCell";

//优惠券
static NSString *const kXLDGoodsCouponCollectionViewCell = @"XLDGoodsCouponCollectionViewCell";
// 返利
static NSString *const kXLDGoodsEarnCollectionViewCell = @"XLDGoodsEarnCollectionViewCell";
// 会员升级
static NSString *const kXLDGoodsInfoMemberUpgradeCell = @"XLDGoodsInfoMemberUpgradeCell";

// 邮寄点
static NSString *const kXLDGoodsPostageCollectionViewCell = @"XLDGoodsPostageCollectionViewCell";
// 保障
static NSString *const kXLDGoodsPledgeCollectionViewCell = @"XLDGoodsPledgeCollectionViewCell";
// 参数
static NSString *const kXLDGoodsArgumentsCollectionViewCell = @"XLDGoodsArgumentsCollectionViewCell";

// 店铺
static NSString *const kXLDGoodsStoreCollectionViewCell = @"XLDGoodsStoreCollectionViewCell";
// 店铺推荐header
NSString *const kXLDGoodsStoreRecomendHeaderView = @"XLDGoodsStoreRecomendHeaderView";

NSString *const kXLDGoodsNoneDetailHeaderView = @"XLDGoodsNoneDetailHeaderView";
// 店铺
static NSString *const kXLDGoodsStoreRecomendCollectionViewCell = @"XLDGoodsStoreRecomendCollectionViewCell";

// 详情图片
static NSString *const kXLDGoodsImageCollectionViewCell = @"XLDGoodsImageCollectionViewCell";
// 详情文字
static NSString *const kXLDGoodsTextCollectionViewCell = @"XLDGoodsTextCollectionViewCell";

// 推荐商品
static NSString *const kXLTHomeCategoryGoodsCollectionViewCell = @"XLTHomeCategoryGoodsCollectionViewCell";

- (void)letaoListRegisterCellsForCollectionView:(UICollectionView *)collectionView {

    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsCouponCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsCouponCollectionViewCell];
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsEarnCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsEarnCollectionViewCell];
    // 会员升级
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsInfoMemberUpgradeCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsInfoMemberUpgradeCell];

    
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsPostageCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsPostageCollectionViewCell];
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsPledgeCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsPledgeCollectionViewCell];
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsArgumentsCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsArgumentsCollectionViewCell];
   
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsStoreCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsStoreCollectionViewCell];
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsStoreRecomendHeaderView bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLDGoodsStoreRecomendHeaderView];
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsNoneDetailHeaderView bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLDGoodsNoneDetailHeaderView];

    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsStoreRecomendCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsStoreRecomendCollectionViewCell];
    // 详情图片
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsImageCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsImageCollectionViewCell];
    // 详情文字
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsTextCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsTextCollectionViewCell];
  
    [collectionView registerNib:[UINib nibWithNibName:kXLTHomeCategoryGoodsCollectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeCategoryGoodsCollectionViewCell];
    
    //头部焦点图
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsInfoTopImageCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsInfoTopImageCell];
    // 商品价格
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsInfoPriceCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsInfoPriceCell];
    //商品title、店铺名字和销量
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsInfoTitleTextCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsInfoTitleTextCell];
    //预售时间
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsInfoPrePaidDateCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsInfoPrePaidDateCell];
    //预售折扣
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsInfoPrePaidDiscountCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsInfoPrePaidDiscountCell];
    
    //推荐语
    [collectionView registerNib:[UINib nibWithNibName:kXLDGoodsEditorsRecommendCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLDGoodsEditorsRecommendCell];
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                        letaoPageDataArray:(NSArray *)letaoPageDataArray {
    if(indexPath.section == XLDGoodsDetailSectionType_GoodsInfo_Image) {
        XLDGoodsInfoTopImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsInfoTopImageCell forIndexPath:indexPath];
        return cell;
    } else if(indexPath.section == XLDGoodsDetailSectionType_GoodsInfo_Price) {
        XLDGoodsInfoPriceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsInfoPriceCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    } else if(indexPath.section == XLDGoodsDetailSectionType_GoodsInfo_TitleText) {
        XLDGoodsInfoTitleTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsInfoTitleTextCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    } else if(indexPath.section == XLDGoodsDetailSectionType_PrePaidDate) {
        XLDGoodsInfoPrePaidDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsInfoPrePaidDateCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    } else if(indexPath.section == XLDGoodsDetailSectionType_PrePaidDiscount) {
        XLDGoodsInfoPrePaidDiscountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsInfoPrePaidDiscountCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    } else if(indexPath.section == XLDGoodsDetailSectionType_Coupon) {
        XLDGoodsCouponCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsCouponCollectionViewCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    }  else if(indexPath.section == XLDGoodsDetailSectionType_Postage) {
        XLDGoodsPostageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsPostageCollectionViewCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    } else if(indexPath.section == XLDGoodsDetailSectionType_Pledge) {
        XLDGoodsPledgeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsPledgeCollectionViewCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    }else if(indexPath.section == XLDGoodsDetailSectionType_Arg) {
        XLDGoodsArgumentsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsArgumentsCollectionViewCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    } else if(indexPath.section == XLDGoodsDetailSectionType_Store) {
        XLDGoodsStoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsStoreCollectionViewCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    } else if(indexPath.section == XLDGoodsDetailSectionType_StoreRecomend) {
        XLDGoodsStoreRecomendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsStoreRecomendCollectionViewCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    } else if(indexPath.section == XLDGoodsDetailSectionType_Detail) {
        XLDGoodsDetailCollectionViewCellDisplayModel *model = (XLDGoodsDetailCollectionViewCellDisplayModel *)[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray];
        if ([model isKindOfClass:[XLDGoodsDetailCollectionViewCellDisplayModel class]]
            && model.isImageType) {
            XLDGoodsImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsImageCollectionViewCell forIndexPath:indexPath];
            [cell letaoUpdateCellDataWithInfo:model];
            return cell;
        } else {
            XLDGoodsTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsTextCollectionViewCell forIndexPath:indexPath];
            [cell letaoUpdateCellDataWithInfo:model];
            return cell;
        }
    } else if(indexPath.section == XLDGoodsDetailSectionType_GoodsRecomend) {
        XLTHomeCategoryGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeCategoryGoodsCollectionViewCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    } else if(indexPath.section == XLDGoodsDetailSectionType_EditorsRecommend) {
           XLDGoodsEditorsRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLDGoodsEditorsRecommendCell forIndexPath:indexPath];
           [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
           return cell;
    }
    return [UICollectionViewCell new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
               letaoPageDataArray:(NSArray *)letaoPageDataArray {
    if(indexPath.section == XLDGoodsDetailSectionType_GoodsInfo_Image) {
        CGFloat width = collectionView.bounds.size.width;
        CGFloat height = width;
        return CGSizeMake(width, height);
    } else if(indexPath.section == XLDGoodsDetailSectionType_GoodsInfo_Price) {
        CGFloat width = collectionView.bounds.size.width;
        CGFloat height = 67;
        NSDictionary *info = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray];
        if ([info isKindOfClass:[NSDictionary class]]) {
            NSDictionary *next_level = info[@"next_level"];
            if ([XLTAppPlatformManager shareManager].checkEnable
                && [next_level isKindOfClass:[NSDictionary class]] && next_level.count > 0) {
                height += (32 + 14);
            }
        }
        return CGSizeMake(width, height);
    } else if(indexPath.section == XLDGoodsDetailSectionType_GoodsInfo_TitleText) {
        NSDictionary *info = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray];
        NSString *titleLabelString = @"";
        if ([info isKindOfClass:[NSDictionary class]]) {
            titleLabelString = [info[@"item_title"] isKindOfClass:[NSString class]] ? info[@"item_title"] : @"";
        }
        CGFloat width = collectionView.bounds.size.width;
        CGFloat textTop = 0;
        CGFloat textWidth = width - 20;
        UIFont *textFont = [UIFont letaoMediumBoldFontWithSize:17];
        CGFloat textHeight = ceilf([titleLabelString sizeWithFont:textFont maxSize:CGSizeMake(textWidth, 48)].height);
        CGFloat height = 15+ 5 + textTop + textHeight + 20;
        return CGSizeMake(width, height);
    } else if(indexPath.section == XLDGoodsDetailSectionType_PrePaidDate) {
        CGFloat width = collectionView.bounds.size.width;
        CGFloat height = 15 +8;
        return CGSizeMake(width, height);
    } else if(indexPath.section == XLDGoodsDetailSectionType_PrePaidDiscount) {
        CGFloat width = collectionView.bounds.size.width;
        CGFloat height = 21 + 8;
        return CGSizeMake(width, height);
    } else if(indexPath.section == XLDGoodsDetailSectionType_Coupon) {
        return CGSizeMake(collectionView.bounds.size.width, 60+15);
    } else if(indexPath.section == XLDGoodsDetailSectionType_Postage
              || indexPath.section == XLDGoodsDetailSectionType_Pledge
              || indexPath.section == XLDGoodsDetailSectionType_Arg) {
        return CGSizeMake(collectionView.bounds.size.width, 50);
    } else if(indexPath.section == XLDGoodsDetailSectionType_Store) {
        
        NSDictionary *letaoStoreDictionary = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray];
        CGFloat height = 120;
        if (![XLDGoodsStoreCollectionViewCell letaoEvaluatesValid:letaoStoreDictionary]) {
            height -= 40;
        }
        return CGSizeMake(collectionView.bounds.size.width, height);
    } else if(indexPath.section == XLDGoodsDetailSectionType_StoreRecomend) {
        CGFloat width = floorl((collectionView.bounds.size.width -40)/3);
        return CGSizeMake(width, width +60 + 15);
    } else if(indexPath.section == XLDGoodsDetailSectionType_Detail) {
        XLDGoodsDetailCollectionViewCellDisplayModel *model = (XLDGoodsDetailCollectionViewCellDisplayModel *)[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray];
        return CGSizeMake(collectionView.bounds.size.width, model.height);
    } else if(indexPath.section == XLDGoodsDetailSectionType_GoodsRecomend) {
        CGFloat offset = ceilf(((kScreenWidth -375)/39)*15);
        // 因为间距不是等比放大，调整一个修正量offset
        CGFloat height = kScreen_iPhone375Scale(340) - offset;
        return CGSizeMake(collectionView.bounds.size.width/2 -15, height);
    } else if(indexPath.section == XLDGoodsDetailSectionType_EditorsRecommend) {
        NSString *recommend_text = (NSString *)[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray];
        if ([recommend_text isKindOfClass:[NSString class]] && recommend_text.length > 0) {
            CGFloat width = collectionView.bounds.size.width;
            CGFloat height = [XLDGoodsEditorsRecommendCell cellHeightForRecommendText:recommend_text];
            return CGSizeMake(width, height);
        }
    }
    

    return CGSizeZero;
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

- (BOOL)isPrepaidGoodsInfo:(NSDictionary *)itemInfo {
    // 高佣金
    if (![self isLetaoHighCommissionGoods:itemInfo]) {
        if ([itemInfo isKindOfClass:[NSDictionary class]]) {
            NSDictionary *goodInfo = itemInfo;
            // 定金预售
            NSDictionary *presale = goodInfo[@"presale"];
            if ([presale isKindOfClass:[NSDictionary class]] && presale.count > 0) {
                NSNumber *start_time = presale[@"start_time"];
                NSNumber *end_time = presale[@"end_time"];
                if ([start_time isKindOfClass:[NSNumber class]] && [start_time longLongValue] > 0
                    && [end_time isKindOfClass:[NSNumber class]] && [end_time longLongValue] > 0) {
                    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
                    return (timeInterval > [start_time longLongValue] && timeInterval < [end_time longLongValue]);
                }
            }
        }
    }
    return NO;
}

// 高佣金
- (BOOL)isLetaoHighCommissionGoods:(NSDictionary *)info {
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSNumber *hight_rebate = info[@"hight_rebate"];
        if ([hight_rebate isKindOfClass:[NSString class]] || [hight_rebate isKindOfClass:[NSNumber class]]) {
            return [hight_rebate boolValue];
        }
    }
    
    return NO;
}


- (BOOL)isPrepaidDateValid:(NSDictionary *)itemInfo {
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *goodInfo = itemInfo;
        // 定金预售
        NSDictionary *presale = goodInfo[@"presale"];
        if ([presale isKindOfClass:[NSDictionary class]] && presale.count > 0) {
            NSNumber *start_time = presale[@"tail_start_time"];
            NSNumber *end_time = presale[@"tail_end_time"];
            return ([start_time isKindOfClass:[NSNumber class]] && [start_time longLongValue] > 0
                    && [end_time isKindOfClass:[NSNumber class]] && [end_time longLongValue] > 0);
        }
    }
    return NO;
}

- (BOOL)isPrepaidDiscountValid:(NSDictionary *)itemInfo {
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *goodInfo = itemInfo;
        // 定金预售
        NSDictionary *presale = goodInfo[@"presale"];
        if ([presale isKindOfClass:[NSDictionary class]] && presale.count > 0) {
            NSString *discount_fee_text = presale[@"discount_fee_text"];
            return ([discount_fee_text isKindOfClass:[NSString class]] && [discount_fee_text length] > 0);
        }
    }
    return NO;
}

@end
