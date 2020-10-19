//
//  XLTUserWithDrawView.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserWithDrawView.h"

@interface XLTUserWithDrawView ()
@property (weak, nonatomic) IBOutlet UIButton *warnBtn;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@end

@implementation XLTUserWithDrawView
- (instancetype)initWithNib{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTUserWithDrawView" owner:nil options:nil] lastObject];
    if (self) {
        self.warnBtn.hidden = YES;
        self.warnLabel.hidden = YES;
        self.submitBtn.enabled = NO;
    }
    return self;
}
- (IBAction)submitAction:(id)sender {
    if (self.submitBlock) {
        self.submitBlock();
    }
}
- (void)resetView{
    self.warnBtn.hidden = YES;
    self.warnLabel.hidden = YES;
    self.submitBtn.enabled = NO;
    self.submitBtn.backgroundColor = [UIColor colorWithHex:0xC3C4C7];
    self.submitBtn.enabled = NO;
}
- (void)showWarningStr:(NSString *)str contentStr:(NSString *)contentStr{
    if (contentStr.length) {
        if (str.length) {
            self.warnBtn.hidden = NO;
            self.warnLabel.hidden = NO;
            self.submitBtn.backgroundColor = [UIColor colorWithHex:0xC3C4C7];
            self.submitBtn.enabled = NO;
            self.warnLabel.text = str;
        }else{
            self.warnBtn.hidden = YES;
            self.warnLabel.hidden = YES;
            self.submitBtn.backgroundColor = [UIColor letaomainColorSkinColor];
            self.submitBtn.enabled = YES;
        }
    }else{
        [self resetView];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
