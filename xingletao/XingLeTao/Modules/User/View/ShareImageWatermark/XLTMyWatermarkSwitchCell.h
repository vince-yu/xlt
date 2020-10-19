//
//  XLTMyWatermarkSwitchCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/5/30.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTMyWatermarkSwitchCell;
@protocol XLTMyWatermarkSwitchCellDelegate <NSObject>

- (void)watermarkSwitchCell:(XLTMyWatermarkSwitchCell *)cell switchOn:(BOOL)on;

@end

@interface XLTMyWatermarkSwitchCell : UITableViewCell

@property (nonatomic, weak) id<XLTMyWatermarkSwitchCellDelegate> delegate;
@property (nonatomic, weak) IBOutlet UISwitch *watermarkSwitch;

@end

NS_ASSUME_NONNULL_END
