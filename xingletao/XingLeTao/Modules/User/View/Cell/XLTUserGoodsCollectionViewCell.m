//
//  XLTUserGoodsCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserGoodsCollectionViewCell.h"

@interface XLTUserGoodsCollectionViewCell ()

@property (nonatomic, strong) UIButton *letaoCellCoverButton;

@end

@implementation XLTUserGoodsCollectionViewCell


- (void)dealloc {
    self.letaoCellCoverButtonClicked = nil;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeCoverButton];
    }
    return self;
}



- (void)initializeCoverButton  {
    self.letaoCellCoverButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.letaoCellCoverButton addTarget:self action:@selector(bgButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.letaoCellCoverButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.letaoCellCoverButton.frame = self.contentView.bounds;
}

- (void)bgButtonClicked:(UIButton *)btn {
    self.letaoCellCoverButtonClicked();
}
@end
