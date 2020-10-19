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

@interface XLTMyInviteMembersCell : UITableViewCell
@property (nonatomic ,strong) XLTUserTeamItemListModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

NS_ASSUME_NONNULL_END
