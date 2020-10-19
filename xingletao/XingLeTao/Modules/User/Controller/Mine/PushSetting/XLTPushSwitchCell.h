//
//  XLTPushSwitchCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/2/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTPushSwitchCell;
@protocol XLTPushSwitchCellDelegate <NSObject>

- (void)cell:(XLTPushSwitchCell *)cell pushSwitchOn:(BOOL)on;

@end

@interface XLTPushSwitchCell : UITableViewCell
@property (nonatomic, weak) id<XLTPushSwitchCellDelegate> delegate;
@property (nonatomic, weak) IBOutlet UILabel *pushTitleLabel;
@property (nonatomic, weak) IBOutlet UISwitch *pushSwitch;
@property (nonatomic, strong) NSDictionary *switchInfo;

@end

NS_ASSUME_NONNULL_END
