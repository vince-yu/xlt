//
//  XLTMallGoodsDetailInfoCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface XLTMallGoodsDetailInfoCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UIView *letaoCycleBgView;
@property (nonatomic, weak) IBOutlet UILabel *letaopriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoPaidCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;
- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo;
@end

NS_ASSUME_NONNULL_END
