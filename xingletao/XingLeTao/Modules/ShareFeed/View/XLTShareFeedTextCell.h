//
//  XLTShareFeedTextCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTShareFeedTextCell;
@protocol XLTShareFeedTextCellDelegate <NSObject>

- (void)cell:(XLTShareFeedTextCell *)cell fold:(BOOL)fold;

@end

@interface XLTShareFeedTextCell : UITableViewCell

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *stackViewTop;


- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info fold:(BOOL)fold;
- (void)letaoUpdateCellContentText:(NSString *)content fold:(BOOL)fold;
@property (nonatomic, weak) id<XLTShareFeedTextCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
