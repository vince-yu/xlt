//
//  XLTUserAliPayListTableViewCell.h
//  XingLeTao
//
//  Created by SNQU on 2019/10/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserAliPayListTableViewCell : UITableViewCell
@property (nonatomic ,strong) id model;
@property (nonatomic ,copy) void(^editBlock)(void);
@end

NS_ASSUME_NONNULL_END
