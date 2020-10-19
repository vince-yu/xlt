//
//  XLTMyWatermarkCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/30.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTMyWatermarkCell.h"


@interface XLTMyWatermarkCell () 

@property (nonatomic, assign) BOOL isAddWatermarkObserver;
@property (nonatomic, weak) IBOutlet UIImageView *watermarkBGImageView;

@end

@implementation XLTMyWatermarkCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (!self.isAddWatermarkObserver) {
        self.isAddWatermarkObserver = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(watermarkDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.watermarkTextField];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browserImageTap:)];
    [self.watermarkBGImageView addGestureRecognizer:tap];
}

- (void)browserImageTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(watermarkCell:browserImage:)]) {
        [self.delegate watermarkCell:self browserImage:self.watermarkBGImageView.image];
    }
}

- (void)watermarkDidChangeNotification:(NSNotification *)notification {
    if (notification.object == self.watermarkTextField) {
        UITextField *textField = self.watermarkTextField;
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 10) {
                [MBProgressHUD letaoshowTipMessageInWindow:@"水印文字不能超过10个字!"];
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:10];
                if (rangeIndex.length == 1)  {
                    textField.text = [toBeString substringToIndex:10];
                }else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 10)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(watermarkCell:didChangeWatermarkText:)]) {
            [self.delegate watermarkCell:self didChangeWatermarkText:self.watermarkTextField.text];
        }
        self.watermarkLabel.text = self.watermarkTextField.text;;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
