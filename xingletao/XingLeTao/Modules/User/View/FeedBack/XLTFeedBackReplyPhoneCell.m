//
//  XLTFeedBackInputPhoneCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/14.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedBackReplyPhoneCell.h"
@interface XLTFeedBackReplyPhoneCell ()
@end
@implementation XLTFeedBackReplyPhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contentView addRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight withRadii:CGSizeMake(8.0, 8.0)];

    });

}

@end
