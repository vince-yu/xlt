//
//  XLDGoodsStoreCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTGoodsDetailCellsFactory.h"
NS_ASSUME_NONNULL_BEGIN

@protocol XLDGoodsStoreCollectionViewCellDelegate <NSObject>

- (void)letaoGoStoreAction;

@end
@interface XLDGoodsStoreCollectionViewCell : UICollectionViewCell <XLTGoodsDetailCellProtocol>
+ (BOOL)letaoEvaluatesValid:(NSDictionary * )letaoStoreDictionary;
@property (nonatomic, weak) id<XLDGoodsStoreCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
