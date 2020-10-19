//
//  XLTFeedBackReplyTextViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/15.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedBackReplyTextViewCell.h"

@interface XLTFeedBackReplyTextViewCell ()
@property (nonatomic, weak) IBOutlet UILabel *replyTextLabel;
@property (nonatomic, weak) IBOutlet UIView *emotyView;
@property (nonatomic, weak) IBOutlet UIView *letaoContentView;

@end


@implementation XLTFeedBackReplyTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor letaolightgreyBgSkinColor];
    self.letaoContentView.layer.masksToBounds = YES;
    self.letaoContentView.layer.cornerRadius = 8.0;
    self.emotyView.layer.masksToBounds = YES;
    self.emotyView.layer.cornerRadius = 8.0;
}

- (void)updateReplyText:(NSString *)replyText {
    if ([replyText isKindOfClass:[NSString class]] && replyText.length > 0) {
        self.replyTextLabel.text = replyText;
        self.emotyView.hidden = YES;
    } else {
        self.replyTextLabel.text = nil;
        self.emotyView.hidden = NO;
    }
}


@end
