//
//  XLTUserAliPayTableViewCell.h
//  XingLeTao
//
//  Created by SNQU on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserAliPayTableViewCell : UITableViewCell
@property (nonatomic ,strong) id model;
@property (nonatomic ,copy) void(^sendCodeBlock)(void);
@property (nonatomic ,copy) void(^textFieldBlock)(NSString *code,NSString *vlaue);
@end

NS_ASSUME_NONNULL_END
