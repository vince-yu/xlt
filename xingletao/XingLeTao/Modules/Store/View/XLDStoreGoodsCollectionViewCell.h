//
//  XLDStoreGoodsCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/4.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLDStoreGoodsCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) BOOL letaoShowImageFlag;
@property (nonatomic, weak) IBOutlet UILabel *letaoBuyLabel;

- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo;
@end

NS_ASSUME_NONNULL_END
