//
//  XLTStoreSearchTopSpaceCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/13.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTStoreSearchTopSpaceCollectionViewCell.h"

@interface XLTStoreSearchTopSpaceCollectionViewCell ()
@property (nonatomic, weak) IBOutlet UIButton *tipButton;
@end

@implementation XLTStoreSearchTopSpaceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor letaolightgreyBgSkinColor];
    self.tipButton.hidden = !self.letaoShowTipButton;
}


- (void)setLetaoShowTipButton:(BOOL)showTip {
    _letaoShowTipButton = showTip;
    self.tipButton.hidden = !showTip;
}
@end
