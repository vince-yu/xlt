//
//  XLTVersionsUpdateView.m
//  XingLeTao
//
//  Created by chenhg on 2020/2/3.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTVersionsUpdateView.h"

@interface XLTVersionsUpdateView ()


@end

@implementation XLTVersionsUpdateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.cornerRadius = 18.0;
    self.cancelButton.layer.borderColor = [UIColor colorWithHex:0xFFE3E3E6].CGColor;
    self.cancelButton.layer.borderWidth = 0.5;
    
    self.updateButton.layer.masksToBounds = YES;
    self.updateButton.layer.cornerRadius = 18.0;
    
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;

}


- (IBAction)cancelButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelButtonAction:)]) {
        [self.delegate cancelButtonAction:sender];
    }
}

- (IBAction)updateButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(updateButtonAction:)]) {
        [self.delegate updateButtonAction:sender];
    }
}
@end
