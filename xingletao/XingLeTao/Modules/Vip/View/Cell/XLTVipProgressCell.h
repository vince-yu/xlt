//
//  XLTVipProgressCell.h
//  XingLeTao
//
//  Created by SNQU on 2019/11/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTBaseModel.h"
#import "XLTVipTaskModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTVipProgressModel : XLTBaseModel
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,assign) CGFloat value;
@end



@interface XLTVipProgressCell : UITableViewCell
@property (nonatomic ,strong) XLTVipTaskRulesModel *model;
@end

NS_ASSUME_NONNULL_END
