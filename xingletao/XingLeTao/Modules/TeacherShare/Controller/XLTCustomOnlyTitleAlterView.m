//
//  XLTNomalAlterView.m
//  XingLeTao
//
//  Created by SNQU on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTCustomOnlyTitleAlterView.h"

@interface  XLTCustomOnlyTitleAlterView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *vLine;
@property (weak, nonatomic) IBOutlet UIView *hline;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation XLTCustomOnlyTitleAlterView
- (instancetype)initWithNib {
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTCustomOnlyTitleAlterView" owner:nil options:nil] lastObject];
    if (self) {
        self.contentView.layer.cornerRadius = 6;
    }
    return self;
}
+ (void)showNamalAlterWithTitle:(NSString *)title content:(NSString *)content leftBlock:(void(^)(void))leftblock rightBlock:(void(^)(void))rightBlock{
    XLTCustomOnlyTitleAlterView *alter = [[XLTCustomOnlyTitleAlterView alloc] initWithNib];
    alter.leftBlock = leftblock;
    alter.rightBlock = rightBlock;
    if(title.length) alter.title = title;
    alter.contentStr = content;
    [alter show];
}
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}
- (void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;

    if ([contentStr isKindOfClass:[NSString class]]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;//段与段之间的间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [attributedString addAttributes:@{NSParagraphStyleAttributeName :paragraphStyle,
                                          NSFontAttributeName:[UIFont letaoRegularFontWithSize:13.0]
        } range:NSMakeRange(0, attributedString.length)];
        self.contentLabel.attributedText = attributedString;
    } else {
        self.contentLabel.attributedText = nil;
    }
}
- (void)show{
    if (self.superview) {
        return;
    }
    XLT_WeakSelf
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];

    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        XLT_StrongSelf
        self.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}
- (void)dissMissAfterDelay:(NSTimeInterval )time{
    XLT_WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XLT_StrongSelf;
        [self dissMiss];
    });
}
- (void)dissMiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    XLT_WeakSelf
    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        XLT_StrongSelf
        self.alpha = 0;
    } completion:^(BOOL finished) {
        XLT_StrongSelf;
        [self removeFromSuperview];
    }];
}

- (IBAction)leftAction:(id)sender {
    if (self.leftBlock) {
        self.leftBlock();
    }
    [self dissMiss];
}
- (IBAction)rightAction:(id)sender {
    if (self.rightBlock) {
        self.rightBlock();
    }
    [self dissMiss];
}

@end
