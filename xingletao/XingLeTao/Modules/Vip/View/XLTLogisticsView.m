//
//  XLT LogisticsView.m
//  XingLeTao
//
//  Created by SNQU on 2019/12/2.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTLogisticsView.h"

@interface XLTLogisticsView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UILabel *expressName;
@property (weak, nonatomic) IBOutlet UILabel *expressOrder;
@property (weak, nonatomic) IBOutlet UIButton *oderIdBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureBtnTop;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@end

@implementation XLTLogisticsView

- (instancetype)initWithNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTLogisticsView" owner:nil options:nil] lastObject];
    if (self) {
        self.bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMiss)];
        [self.bgView addGestureRecognizer:tap];
        
        self.sureBtn.layer.cornerRadius = 22.5;
        self.sureBtn.layer.masksToBounds = YES;
        
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = YES;
        
        self.oderIdBtn.layer.cornerRadius = 2;
        self.oderIdBtn.layer.masksToBounds = YES;
        self.oderIdBtn.layer.borderColor = [UIColor colorWithHex:0xD3D3D3].CGColor;
        self.oderIdBtn.layer.borderWidth = 1;
        
        self.addressLabel.numberOfLines = 0;
        
    }
    return self;
}
- (void)setModel:(XLTVipOrderListModel *)model{
    _model = model;
    CGFloat height = 0;
    self.nameLabel.text = [NSString checkStrLenthWithStr:[NSString stringWithFormat:@"%@ %@", self.model.user_addr.name ,self.model.user_addr.phone] placeholder:@"--" appStr:nil before:NO];
    self.addressLabel.text = [NSString checkStrLenthWithStr:self.model.user_addr.full_addr placeholder:@"--" appStr:nil before:NO];
    self.expressNameLabel.text = [NSString checkStrLenthWithStr:self.model.express_com placeholder:@"--" appStr:nil before:NO];
    self.expressIdLabel.text = [NSString checkStrLenthWithStr:self.model.express_no placeholder:@"--" appStr:nil before:NO];
    if (!self.model.express_no.length) {
        self.sureBtnTop.constant = 34;
//        self.contentHeight.constant =
        height = 330 - 70;
        self.expressName.hidden = YES;
        self.expressNameLabel.hidden = YES;
        self.expressOrder.hidden = YES;
        self.expressIdLabel.hidden = YES;
        self.oderIdBtn.hidden = YES;
        
        
        
    }else{
        self.sureBtnTop.constant = 103;
        height = 330;
        
        self.expressName.hidden = NO;
        self.expressNameLabel.hidden = NO;
        self.expressOrder.hidden = NO;
        self.expressIdLabel.hidden = NO;
        self.oderIdBtn.hidden = NO;
    }
    if (self.model.user_addr.full_addr.length) {
        CGSize maxSize = CGSizeMake(kScreenWidth - 70 - 130, 400);
        CGSize textSize = [NSString sizeWithText:self.model.user_addr.full_addr font:[UIFont fontWithName:kSDPFRegularFont size:12] maxSize:maxSize];
        if (textSize.height > 20) {
            self.addressLabelHeight.constant = textSize.height + 1;
            height = height + textSize.height - 12 + 1;
        }
    }
    self.contentHeight.constant = height;
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setDescribeStr:(NSString *)describeStr{
//    if ([describeStr isKindOfClass:[NSAttributedString class]]) {
//        self.letaodescribeLabel.attributedText = (NSAttributedString *)describeStr;
//    }else if ([describeStr isKindOfClass:[NSString class]]){
//
//        self.letaodescribeLabel.text = self.describeStr;
//    }else {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id414478124?mt=8"]];
//    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
- (IBAction)sureAction:(id)sender {
    [self dissMiss];
    
}
- (void)dissMiss{
    XLT_WeakSelf
    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        XLT_StrongSelf
        self.alpha = 0;
    } completion:^(BOOL finished) {
        XLT_StrongSelf;
        [self removeFromSuperview];
    }];
}
- (IBAction)copyOrderAction:(id)sender {
    [UIPasteboard generalPasteboard].string = self.model.express_no;
    [MBProgressHUD letaoshowTipMessageInWindow:@"复制成功！"];
}

@end
