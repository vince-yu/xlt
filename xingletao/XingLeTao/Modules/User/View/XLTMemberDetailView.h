//
//  XLTMemberDetailView.h
//  XingLeTao
//
//  Created by SNQU on 2019/11/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTUserTeamInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTMemberDetailView : UIView
- (instancetype)initWithNib;
- (void)show;
@property (nonatomic ,strong) XLTUserIncomeModel *model;
@end

NS_ASSUME_NONNULL_END
