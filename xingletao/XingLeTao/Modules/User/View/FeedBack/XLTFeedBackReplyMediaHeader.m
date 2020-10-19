//
//  XLTFeedBackReplyMediaHeader.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/15.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedBackReplyMediaHeader.h"

@interface XLTFeedBackReplyMediaHeader ()
@property (nonatomic, weak) IBOutlet UILabel *feedTextLabel;
@property (nonatomic, weak) IBOutlet UIView *letaoContentView;

@end

@implementation XLTFeedBackReplyMediaHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
}

- (void)updateFeedText:(NSString *)feedText {
    if ([feedText isKindOfClass:[NSString class]]) {
        self.feedTextLabel.text = feedText;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.letaoContentView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(8.0, 8.0)];

}


@end
