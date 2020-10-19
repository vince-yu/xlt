//
//  XLDGoodsPledgeCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTGoodsDetailCellsFactory.h"
NS_ASSUME_NONNULL_BEGIN

@interface XLDGoodsPledgeCollectionViewCell : UICollectionViewCell <XLTGoodsDetailCellProtocol>
@property (nonatomic, weak) IBOutlet UILabel *letaoSafeguardLabel;

@end

NS_ASSUME_NONNULL_END
