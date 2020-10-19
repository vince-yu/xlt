//
//  XLTMemberDetailHeader.h
//  XingLeTao
//
//  Created by SNQU on 2020/3/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTUserTeamInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTMemberDetailHeader : UIView
- (instancetype)initWithNib;
@property (nonatomic ,strong) XLTUserIncomeModel *model;
@property (nonatomic ,copy) void(^sortBlock)(NSInteger index,NSInteger status);
@end

NS_ASSUME_NONNULL_END
