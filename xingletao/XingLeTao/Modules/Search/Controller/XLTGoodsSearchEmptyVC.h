//
//  XLTGoodsSearchEmptyVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsSearchReultVC.h"

NS_ASSUME_NONNULL_BEGIN
@class XLTGoodsSearchEmptyVC;
@protocol XLTGoodsSearchEmptyVCDelegate <NSObject>

- (void)goodsSearchEmptyVC:(XLTGoodsSearchEmptyVC *)vc changedSortType:(XLTTopFilterSortType)type;
- (void)goodsSearchEmptyVC:(XLTGoodsSearchEmptyVC *)vc changedSwitchOn:(BOOL)isOn;
- (void)goodsSearchEmptyVC:(XLTGoodsSearchEmptyVC *)vc changedFilterArray:(NSArray *)filterArray;
- (void)goodsSearchEmptyVC:(XLTGoodsSearchEmptyVC *)vc changedItemSource:(NSString *)item_source;


@end
@interface XLTGoodsSearchEmptyVC : XLTGoodsSearchReultVC
@property (nonatomic, weak) id<XLTGoodsSearchEmptyVCDelegate> delegate;
@property (nonatomic, assign) XLTTopFilterSortType letaoFristSortValueType;
@property (nonatomic, assign) BOOL letaoFristSwitchOn;

@end

NS_ASSUME_NONNULL_END
