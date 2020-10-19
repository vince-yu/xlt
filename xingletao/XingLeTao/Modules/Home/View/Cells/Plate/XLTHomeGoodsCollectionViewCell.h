//
//  XLTHomeGoodsCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTHomeGoodsCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL letaoShowImageFlag;

- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo;
@end

NS_ASSUME_NONNULL_END
