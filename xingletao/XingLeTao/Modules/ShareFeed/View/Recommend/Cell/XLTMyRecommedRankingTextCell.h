//
//  XLTFeedRecommedRankingTextCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/6/19.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTMyRecommedRankingTextCell : UITableViewCell
@property (nonatomic ,strong) NSString *is_nomal_settle;

- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info rankingType:(NSString * _Nullable)rankingType;


@end

NS_ASSUME_NONNULL_END
