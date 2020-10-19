//
//  XLTCollectEmptyCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/10.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTCollectEmptyCollectionViewCell;
@protocol XLTCollectEmptyCollectionViewCellDelegate <NSObject>

- (void)letaoEmptyCollectCell:(XLTCollectEmptyCollectionViewCell *)cell goHomeAction:(id)sender;

@end

@interface XLTCollectEmptyCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIButton *letaoGoHomeBtn;
@property (nonatomic, weak) id<XLTCollectEmptyCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
