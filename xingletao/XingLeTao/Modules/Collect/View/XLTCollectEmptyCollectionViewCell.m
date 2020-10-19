//
//  XLTCollectEmptyCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/10.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTCollectEmptyCollectionViewCell.h"

@implementation XLTCollectEmptyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.letaoGoHomeBtn.layer.masksToBounds = YES;
    self.letaoGoHomeBtn.layer.cornerRadius = 18.0;
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (IBAction)goHomeAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(letaoEmptyCollectCell:goHomeAction:)]) {
        [self.delegate letaoEmptyCollectCell:self goHomeAction:sender];
    }

}

@end
