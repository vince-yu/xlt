//
//  XLTShareFeedTopCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTShareFeedTopCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTMyRecommedRankingTopCell : UITableViewCell
@property (nonatomic, weak) id<XLTShareFeedTopCellDelegate> delegate;
- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
