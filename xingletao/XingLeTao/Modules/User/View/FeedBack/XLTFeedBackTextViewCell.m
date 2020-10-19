//
//  XLTFeedBackTextViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedBackTextViewCell.h"
#import "FSTextView.h"
#import "MBProgressHUD+TipView.h"

@interface XLTFeedBackTextViewCell ()
@property (nonatomic, weak) IBOutlet FSTextView *feedbackTextView;
@property (nonatomic, weak) IBOutlet UILabel *maxNoticeLabel;

@end

@implementation XLTFeedBackTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _feedbackTextView.maxLength = 500;
    _feedbackTextView.placeholder = @"请填写3字以上的问题描述，我们将尽快解决";
    __weak __typeof(self)weakSelf = self;
    [_feedbackTextView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        NSString *tipMessage = [NSString stringWithFormat:@"最多限制输入%zi个字符", textView.maxLength];
        [weakSelf letaoshowTipMessageInWindow:tipMessage];
    }];
    
    
    __weak __typeof(&*self.maxNoticeLabel)weakNoticeLabel = self.maxNoticeLabel;
    
    // 添加输入改变Block回调.
    [_feedbackTextView addTextDidChangeHandler:^(FSTextView *textView) {
        (textView.text.length <= textView.maxLength) ? weakNoticeLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)textView.text.length,(long)textView.maxLength]:NULL;
        [weakSelf textDidChanged:textView.text];
    }];

    self.contentView.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];

}

- (void)letaoshowTipMessageInWindow:(NSString *)message {
    [MBProgressHUD letaoshowTipMessageInWindow:message];
}

- (void)textDidChanged:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(feedBackTextViewCell:textDidChanged:)]) {
        [self.delegate feedBackTextViewCell:self textDidChanged:text];
    }
}


@end
