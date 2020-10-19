//
//  XLTTeacherShareHeaderView.m
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTTeacherShareHeaderView.h"
#import "XLTUserManager.h"

@interface XLTTeacherShareHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wxLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avtorImageView;

@end

@implementation XLTTeacherShareHeaderView

- (instancetype)initWithNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTTeacherShareHeaderView" owner:nil options:nil] lastObject];
    if (self) {
        self.storeBtn.layer.borderColor = [UIColor colorWithHex:0xFF8202].CGColor;
        self.storeBtn.layer.borderWidth = 0.5;
        XLTUserInfoModel *info = [XLTUserManager shareManager].curUserInfo;
        [self.avtorImageView sd_setImageWithURL:[NSURL URLWithString:info.tutor_inviter_avatar] placeholderImage:[UIImage imageNamed: @"xingletao_mine_header_placeholder"]];
        self.nameLabel.text = info.tutor_inviter_username ? info.tutor_inviter_username : @"";
        self.wxLabel.text = info.tutor_wechat_show_uid ? info.tutor_wechat_show_uid : @"";
    }
    return self;
}
- (IBAction)storeAction:(id)sender {
    if (!self.wxLabel.text.length) {
        return;;
    }
    [UIPasteboard generalPasteboard].string = self.wxLabel.text;
    [MBProgressHUD letaoshowTipMessageInWindow:@"复制成功！"];
}

@end
