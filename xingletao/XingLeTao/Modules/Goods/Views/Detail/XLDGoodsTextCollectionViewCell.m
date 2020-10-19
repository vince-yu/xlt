//
//  XLDGoodsTextCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/9.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsTextCollectionViewCell.h"
#import "XLDGoodsImageCollectionViewCell.h"

@implementation XLDGoodsTextCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)letaoUpdateCellDataWithInfo:(XLDGoodsDetailCollectionViewCellDisplayModel *)model {
    if ([model isKindOfClass:[XLDGoodsDetailCollectionViewCellDisplayModel class]]
        && [model.text isKindOfClass:[NSString class]]) {
        self.letaoGoodDetailTextLabel.text = model.text;
    } else {
        self.letaoGoodDetailTextLabel.text = nil;
    }
}

@end
