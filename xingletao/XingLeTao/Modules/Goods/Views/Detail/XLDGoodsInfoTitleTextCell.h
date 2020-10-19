//
//  XLDGoodsInfoTitleTextCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTGoodsDetailCellsFactory.h"
#import "SDCycleScrollView.h"


NS_ASSUME_NONNULL_BEGIN

@interface XLDGoodsInfoTitleTextCell : UICollectionViewCell <XLTGoodsDetailCellProtocol>
@property (nonatomic, strong) IBOutlet UIView *letaoCycleBgView;
@property (nonatomic, weak) IBOutlet UIButton *letaoCollectBtn;
@end

NS_ASSUME_NONNULL_END
