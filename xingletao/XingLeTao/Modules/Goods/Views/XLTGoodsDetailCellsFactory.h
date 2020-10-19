//
//  XLTGoodDetailCellFactory.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSNumber+XLTTenThousandsHelp.h"
#import "NSString+XLTSourceStringHelper.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XLDGoodsDetailSectionType) {
    XLDGoodsDetailSectionType_GoodsInfo_Image = 0,
    XLDGoodsDetailSectionType_GoodsInfo_Price,
//    XLDGoodsDetailSectionType_MemberUpgrade,
    XLDGoodsDetailSectionType_PrePaidDate,
    XLDGoodsDetailSectionType_PrePaidDiscount,
    XLDGoodsDetailSectionType_GoodsInfo_TitleText,
    XLDGoodsDetailSectionType_Coupon,
    XLDGoodsDetailSectionType_EditorsRecommend,
    XLDGoodsDetailSectionType_Postage,
    XLDGoodsDetailSectionType_Pledge,
    XLDGoodsDetailSectionType_Arg,
    XLDGoodsDetailSectionType_Store,
    XLDGoodsDetailSectionType_StoreRecomend,
    XLDGoodsDetailSectionType_Detail,
    XLDGoodsDetailSectionType_GoodsRecomend
};

// 店铺推荐header
extern NSString *const kXLDGoodsStoreRecomendHeaderView;

extern NSString *const kXLDGoodsNoneDetailHeaderView;

@protocol XLTGoodsDetailCellProtocol <NSObject>
@required
- (void)letaoUpdateCellDataWithInfo:(id _Nullable )info;
@end

@interface XLTGoodsDetailCellsFactory : NSObject
- (void)letaoListRegisterCellsForCollectionView:(UICollectionView *)collectionView;
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                        letaoPageDataArray:(NSArray *)letaoPageDataArray;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
               letaoPageDataArray:(NSArray *)letaoPageDataArray;

@end

NS_ASSUME_NONNULL_END
