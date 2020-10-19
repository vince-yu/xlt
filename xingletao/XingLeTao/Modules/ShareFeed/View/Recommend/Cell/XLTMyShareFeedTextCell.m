//
//  XLTShareFeedTextCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTMyShareFeedTextCell.h"

@interface XLTMyShareFeedTextCell ()
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIButton *allButton;
@end


@implementation XLTMyShareFeedTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(letaoPressAction)];
    press.minimumPressDuration = 1;
    self.contentLabel.userInteractionEnabled = YES;
    [self.contentLabel addGestureRecognizer:press];
}

- (void)letaoPressAction{
    [[XLTAppPlatformManager shareManager] saveGoodsPasteboardValue:self.contentLabel.text];
    [UIPasteboard generalPasteboard].string = self.contentLabel.text;
    [MBProgressHUD letaoshowTipMessageInWindow:@"复制成功!"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info fold:(BOOL)fold {
    NSString *content = nil;
    if ([info isKindOfClass:[NSDictionary class]]) {
        if ([info[@"content"] isKindOfClass:[NSString class]]) {
            content = info[@"content"];
        }
    }
    [self letaoUpdateCellContentText:content fold:fold];
}

- (void)letaoUpdateCellContentText:(NSString *)content fold:(BOOL)fold {
    if (fold) {
        self.contentLabel.numberOfLines = 8;
        [self.allButton setTitle:@"全文" forState:UIControlStateNormal];
    } else {
        self.contentLabel.numberOfLines = 0;
        [self.allButton setTitle:@"收起" forState:UIControlStateNormal];
    }
    self.contentLabel.text = [content isKindOfClass:[NSString class]] ? content : nil;
    
    
    CGSize textMaxSize = CGSizeMake(kScreenWidth - 10 - 54, MAXFLOAT);
    NSDictionary *textAttrs = @{NSFontAttributeName : [UIFont letaoRegularFontWithSize:14]};
    CGFloat textHeight = [content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttrs context:nil].size.height;
    BOOL isAllShowed = (textHeight <= 160);
    self.allButton.hidden = isAllShowed;
    self.allButton.selected = fold;
}




- (IBAction)allBtnClicked:(id)sender {
    self.allButton.selected = !self.allButton.selected;
    if ([self.delegate respondsToSelector:@selector(cell:fold:)]) {
        [self.delegate cell:self fold:self.allButton.selected];
    }
}

@end
