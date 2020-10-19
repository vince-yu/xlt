//
//  XLTUserInvatHeaderView.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserInvatHeaderView.h"
#import "XLTUserManager.h"
#import "XLTHomeCustomHeadView.h"

@interface XLTUserInvatHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *invateLabel;
@property (weak, nonatomic) IBOutlet UIButton *invateBtn;
@property (weak, nonatomic) IBOutlet UILabel *letaodescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *btnBg;

@end

@implementation XLTUserInvatHeaderView
- (instancetype)initWithNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTUserInvatHeaderView" owner:nil options:nil] lastObject];
    if (self) {
        UIImageView *_letaobgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
        UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFF8A28],[UIColor colorWithHex:0xFF5221]] gradientType:1 imgSize:_letaobgImageView.bounds.size];
        _letaobgImageView.image = bgImage;
        [self insertSubview:_letaobgImageView atIndex:0];
        
        self.contentView.layer.shadowOffset = CGSizeMake(0,10);
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowOpacity = 0.05;
        self.contentView.layer.shadowRadius = 5;
        self.contentView.layer.cornerRadius = 10;
        self.contentView.clipsToBounds = NO;
        
        self.btnBg.layer.cornerRadius = 16;
//        self.invateBtn.layer.cornerRadius = 16;
//        self.btnBg.clipsToBounds = YES;
//        self.invateBtn.layer.borderWidth = 1;
        UIImage *btnImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFAE01],[UIColor colorWithHex:0xFF6E02]] gradientType:1 imgSize:CGSizeMake(80, 32)];
        self.btnBg.image = btnImage;
        
        NSString *str = @"1 复制邀请码给好友下载APP注册时填写\n2 转发邀请海报，好友下载APP注册时填写海报上的邀请码\n3 复制邀请链接给好友下载APP注册并使用链接后的邀请码";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
//        [attr addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:12]} range:NSMakeRange(0, 3)];
        [attr addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:12]} range:NSMakeRange(0, 20)];
//        [attr addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:12]} range:NSMakeRange(24, 3)];
        [attr addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:12]} range:NSMakeRange(20, 28)];
//        [attr addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:12]} range:NSMakeRange(56, 3)];
        [attr addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:12]} range:NSMakeRange(48, 28)];
        self.letaodescribeLabel.attributedText = attr;
        
        if ([XLTUserManager shareManager].curUserInfo.invite_link_code) {
            self.invateLabel.text = [XLTUserManager shareManager].curUserInfo.invite_link_code;
        }
    }
    return self;
}
- (IBAction)pasterAction:(id)sender {
    [UIPasteboard generalPasteboard].string = [XLTUserManager shareManager].curUserInfo.invite_link_code;
    [MBProgressHUD letaoshowTipMessageInWindow:@"复制成功!"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
