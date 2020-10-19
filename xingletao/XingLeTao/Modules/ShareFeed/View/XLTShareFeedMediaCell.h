//
//  XLTShareFeedMediaCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTShareFeedMediaCell;
@protocol XLTShareFeedMediaCellDelegate <NSObject>

- (void)cell:(XLTShareFeedMediaCell *)cell playVideos:(NSString *)url;
- (void)cell:(XLTShareFeedMediaCell *)cell sourceView:(UIButton *)sourceView showImagesArray:(NSArray *)imagesArray atIndex:(NSUInteger)index;

@end

@interface XLTShareFeedMediaCell : UITableViewCell
- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info;
@property (nonatomic, weak) id<XLTShareFeedMediaCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
