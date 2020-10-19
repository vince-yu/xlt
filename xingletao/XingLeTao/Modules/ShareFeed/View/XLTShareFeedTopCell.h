//
//  XLTShareFeedTopCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XLTShareFeedTopCell;
@protocol XLTShareFeedTopCellDelegate <NSObject>

- (void)cell:(UITableViewCell *)cell shareBtnClicked:(id)sender;
- (void)cell:(UITableViewCell *)cell downloadBtnClicked:(id)sender;

@end

@interface XLTShareFeedTopCell : UITableViewCell
@property (nonatomic, weak) id<XLTShareFeedTopCellDelegate> delegate;
- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
