//
//  XLTMyTeamMembersCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/5/23.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTUserTeamInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@class XLTMyTeamMembersCell;
@protocol XLTMyTeamMembersCellDelegate <NSObject>

- (void)myTeamMembersCell:(XLTMyTeamMembersCell *)cell shwoProgressWithInfo:(XLTUserTeamItemListModel *)model;

@end

@interface XLTMyTeamMembersCell : UITableViewCell
@property (nonatomic ,strong) XLTUserTeamItemListModel *model;
@property (nonatomic ,weak) id<XLTMyTeamMembersCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
