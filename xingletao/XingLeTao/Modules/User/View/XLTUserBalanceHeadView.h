//
//  XLTUserBalanceHeadView.h
//  XingLeTao
//
//  Created by SNQU on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTBalanceInfoModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface XLTUserBalanceHeadView : UIView
@property (nonatomic ,strong) XLTBalanceInfoModel *balanceInfo;
@property (nonatomic ,copy) void(^selectTimeBlock)(void);
@property (nonatomic ,copy) void(^selectTypeBlock)(NSInteger type);
- (void)setTime:(NSString *)timeStr;
- (instancetype)initWithNib;
@end

NS_ASSUME_NONNULL_END
