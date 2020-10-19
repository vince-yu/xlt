//
//  XLTOrderFindCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XLTOrderListModel;
@interface XLTOrderFindCollectionViewCell : UICollectionViewCell
- (void)letaoUpdateCellWithData:(XLTOrderListModel *)info;

@end

NS_ASSUME_NONNULL_END
