//
//  XLTShareFeedListVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseListViewController.h"
#import "XLTShareFeedTopCell.h"
#import "XLTShareFeedTextCell.h"
#import "XLTShareFeedMediaCell.h"
#import "XLTShareFeedGoodsCell.h"
#import "XLTShareFeedGoodsStepCell.h"
#import "XLTShareFeedEmptyCell.h"
#import "KSPhotoBrowser.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTShareFeedListVC : XLTBaseListViewController <XLTShareFeedTopCellDelegate, XLTShareFeedTextCellDelegate, XLTShareFeedMediaCellDelegate, KSPhotoBrowserDelegate, XLTShareFeedGoodsStepCellDelegate>
@property (nonatomic, copy, nullable) NSString *letaoChannelId;
@property (nonatomic, copy, nullable) NSString *rootChannelId;
@property (nonatomic, copy, nullable) NSArray *tagArray;
@property (nonatomic, copy, nullable) NSString *currentTag;

@property (nonatomic, readonly) NSMutableDictionary *unFoldIndexDictionary;
- (BOOL)isUnFoldIndexPath:(NSIndexPath *)indexPath;
- (BOOL)isCouponValidForGoodsInfo:(NSDictionary *)itemInfo;
@end



NS_ASSUME_NONNULL_END
