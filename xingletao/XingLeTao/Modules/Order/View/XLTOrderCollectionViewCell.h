//
//  XLTOrderCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTOrderListModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface XLTOrderCollectionViewCell : UICollectionViewCell
- (void)letaoUpdateCellWithData:(XLTOrderListModel *)info;
@property (nonatomic, copy, nullable) void(^letaoCellCoverButtonClicked)(NSDictionary *cellInfo);
@property (nonatomic, copy, nullable) void(^operateButtonClicked)(NSDictionary *cellInfo,BOOL canRebate);

@end

NS_ASSUME_NONNULL_END
