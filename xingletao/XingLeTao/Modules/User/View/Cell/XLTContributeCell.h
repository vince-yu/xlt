//
//  XLTContributeCell.h
//  XingLeTao
//
//  Created by SNQU on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTUserContibuteModel.h"
#import "XLTContributeListVC.h"


@interface XLTContributeCell : UITableViewCell
@property (nonatomic ,strong) XLTUserContibuteModel *model;
@property (nonatomic ,assign) XLTContributeType cellType;
@end

