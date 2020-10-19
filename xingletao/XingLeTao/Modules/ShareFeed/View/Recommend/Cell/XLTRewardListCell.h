//
//  XLTHomeHotGoodsCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTMyRewardListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTRewardListCell : UICollectionViewCell
@property (nonatomic ,strong) XLTMyRewardListModel *itemInfo;
@property (nonatomic ,strong) NSString *is_nomal_settle;
- (void)letaoUpdateCellDataWithInfo:(XLTMyRewardListModel * _Nullable )itemInfo;
@end

NS_ASSUME_NONNULL_END
