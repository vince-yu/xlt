//
//  XLTNomalAlterView.m
//  XingLeTao
//
//  Created by SNQU on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTInvetorAlterView.h"
#import "XLTUserManager.h"

@interface  XLTInvetorAlterView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *vLine;
@property (weak, nonatomic) IBOutlet UIView *hline;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *avtorBgView;
@property (weak, nonatomic) IBOutlet UIImageView *avtorImageView;
@property (nonatomic ,strong) NSString *weixin;

@end

@implementation XLTInvetorAlterView
- (instancetype)initWithNib {
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTInvetorAlterView" owner:nil options:nil] lastObject];
    if (self) {
        self.contentView.layer.cornerRadius = 6;
        self.avtorBgView.layer.cornerRadius = 37.5;
        self.avtorImageView.layer.cornerRadius = 35;
        self.avtorBgView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.avtorBgView.layer.shadowOffset = CGSizeMake(1, 1);
        self.avtorBgView.layer.shadowRadius = 1.0;
        
    }
    return self;
}
+ (void)showNamalAlterWithTitle:(NSString *)title content:(NSString *)content weixin:(NSString *)weixin avtor:(NSString *)avtor leftBlock:(void(^)(void))leftblock rightBlock:(void(^)(void))rightBlock{
    XLTInvetorAlterView *alter = [[XLTInvetorAlterView alloc] initWithNib];
    alter.leftBlock = leftblock;
    alter.rightBlock = rightBlock;
    alter.title = title;
    alter.weixin = weixin;
    [alter.avtorImageView sd_setImageWithURL:[NSURL URLWithString:avtor] placeholderImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"]];
    NSMutableString *str = [[NSMutableString alloc] initWithString:content];
    if (weixin.length) {
        [str appendFormat:@"\n%@",weixin];
    }
    alter.contentStr = str;
    
    [alter show];
}

+ (void)showNamalAlterWithTitle:(NSString *)title
                        content:(NSString *)content
                          image:(UIImage *)image
                    leftBtnText:(NSString *)leftBtnText
                   rightBtnText:(NSString *)rightBtnText
                      leftBlock:(void(^)(void))leftblock
                     rightBlock:(void(^)(void))rightBlock {
    XLTInvetorAlterView *alter = [[XLTInvetorAlterView alloc] initWithNib];
    alter.leftBlock = leftblock;
    alter.rightBlock = rightBlock;
    alter.title = title;
    alter.avtorImageView.image = image;
    alter.contentStr = content;
    [alter.leftBtn setTitle:leftBtnText forState:UIControlStateNormal];
    [alter.rightBtn setTitle:rightBtnText forState:UIControlStateNormal];
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
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineSpacing = 5;//段与段之间的间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [attributedString addAttributes:@{NSParagraphStyleAttributeName :paragraphStyle,
                                          NSFontAttributeName:[UIFont letaoRegularFontWithSize:14.0]
        } range:NSMakeRange(0, attributedString.length)];
        if ([self.weixin isKindOfClass:[NSString class]]) {
            [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:14]} range:[contentStr rangeOfString:self.weixin]];
        }
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
