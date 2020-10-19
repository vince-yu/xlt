//
//  XLTShareFeedGoodsStepCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTShareFeedGoodsStepCell;
@protocol XLTShareFeedGoodsStepCellDelegate <NSObject>

- (void)cell:(XLTShareFeedGoodsStepCell *)cell copyBtnClicked:(id)sender;

@end

@interface XLTShareFeedGoodsStepCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *contentCopyButton;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) id<XLTShareFeedGoodsStepCellDelegate> delegate;

- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo;
- (void)letaoUpdateCellContent:(NSString * _Nullable )content;
@end

NS_ASSUME_NONNULL_END
