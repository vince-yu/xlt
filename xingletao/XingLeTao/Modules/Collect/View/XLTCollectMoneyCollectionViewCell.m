//
//  XLTCollectMoneyCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/14.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTCollectMoneyCollectionViewCell.h"

@implementation XLTCollectMoneyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.masksToBounds = YES;
//    self.contentView.layer.cornerRadius = 10.0;
}

@end
