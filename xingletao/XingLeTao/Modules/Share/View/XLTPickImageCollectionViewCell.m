//
//  XLTPickImageCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTPickImageCollectionViewCell.h"

@implementation XLTPickImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0;
    self.qrcodeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
}

@end
