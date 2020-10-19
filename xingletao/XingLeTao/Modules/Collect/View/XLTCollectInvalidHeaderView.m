//
//  XLTCollectInvalidHeaderView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/14.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTCollectInvalidHeaderView.h"

@implementation XLTCollectInvalidHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}

- (IBAction)invalidGoodsClearAction {
    if ([self.delegate respondsToSelector:@selector(letaoInvalidGoodsClearBtnClicked)]) {
        [self.delegate letaoInvalidGoodsClearBtnClicked];
    }
}

@end
