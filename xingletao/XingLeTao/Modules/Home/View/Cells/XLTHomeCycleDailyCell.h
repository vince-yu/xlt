//
//  XLTHomeDailyRecommendCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/2.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTHomeCellsFactory.h"
NS_ASSUME_NONNULL_BEGIN

@class XLTHomeCycleDailyCell;
@protocol XLTHomeDailyRecommendCellDelegate <NSObject>
/// delegate 方法
- (void)letaoDailyCell:(XLTHomeCycleDailyCell *)cell didSelectedItemAtIndex:(NSInteger)index;
@end

@interface XLTHomeCycleDailyCell : UICollectionViewCell <XLTHomePagesCellUpdateProtocol>
@property (nonatomic, weak) id<XLTHomeDailyRecommendCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
