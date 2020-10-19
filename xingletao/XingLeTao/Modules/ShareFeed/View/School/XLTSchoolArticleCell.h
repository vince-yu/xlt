//
//  XLTSchoolArticleCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/2/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTSchoolArticleCell;
@protocol XLTSchoolArticleCellDelegate <NSObject>

- (void)articleCell:(XLTSchoolArticleCell *)cell shareWithInfo:(NSDictionary *)info;

@end
@interface XLTSchoolArticleCell : UICollectionViewCell
- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info;

@property (nonatomic, weak) id<XLTSchoolArticleCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
