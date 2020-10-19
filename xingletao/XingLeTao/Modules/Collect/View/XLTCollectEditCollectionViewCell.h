//
//  XLTCollectEditCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTCollectEditCollectionViewCell;
@protocol XLTCollectEditCollectionViewCellDelegate <NSObject>

- (void)letaoEditCell:(XLTCollectEditCollectionViewCell *)cell
     collectId:(NSString *)collectId
     isCollectSelected:(BOOL)isCollectSelected;

@end

@interface XLTCollectEditCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) BOOL letaoIsEditState;
@property (nonatomic, assign) BOOL letaoIsCollectSelected;


@property (nonatomic, weak) id<XLTCollectEditCollectionViewCellDelegate> delegate;

- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo
            isSelected:(BOOL)isSelected
             startEdit:(BOOL)startEdit
          invalidgoods:(BOOL)invalidgoods;
@end

NS_ASSUME_NONNULL_END
