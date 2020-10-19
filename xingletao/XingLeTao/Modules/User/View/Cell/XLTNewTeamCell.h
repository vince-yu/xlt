//
//  XLTNewTeamCell.h
//  XingLeTao
//
//  Created by SNQU on 2020/3/11.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTUserTeamInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTNewTeamCell : UITableViewCell
@property (nonatomic ,strong) XLTUserTeamItemListModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@end

NS_ASSUME_NONNULL_END
