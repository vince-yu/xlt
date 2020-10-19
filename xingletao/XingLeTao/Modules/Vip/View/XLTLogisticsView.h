//
//  XLT LogisticsView.h
//  XingLeTao
//
//  Created by SNQU on 2019/12/2.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTVipOrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTLogisticsView : UIView
@property (nonatomic ,strong) XLTVipOrderListModel *model;
- (instancetype)initWithNib;
- (void)show;
@end

NS_ASSUME_NONNULL_END
