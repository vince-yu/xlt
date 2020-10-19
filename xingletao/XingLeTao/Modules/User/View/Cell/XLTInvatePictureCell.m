//
//  XLTInvatePictureCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTInvatePictureCell.h"
#import "XLTUserManager.h"

@interface XLTInvatePictureCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *letaobgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *invateImageView;
@property (weak, nonatomic) IBOutlet UIView *labelBgView;
@property (weak, nonatomic) IBOutlet UILabel *invateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *invateLabelWith;

@end

@implementation XLTInvatePictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.invateLabel.layer.cornerRadius = 7.0;
    self.invateLabel.layer.masksToBounds = YES;
    self.labelBgView.layer.cornerRadius = 7.0;
    self.labelBgView.layer.masksToBounds = YES;
    self.selectBtn.userInteractionEnabled = NO;
    // Initialization code
}
- (void)setModel:(XLTUserInvateModel *)model{
    _model = model;
    if ([model.gen_image isKindOfClass:[NSString class]]) {
        [self.letaobgImageView sd_setImageWithURL:[NSURL URLWithString:self.model.gen_image]];
    } else {
        self.letaobgImageView.image = nil;
    }
//    if ([XLTUserManager shareManager].curUserInfo.invite_link_code) {
//        self.invateLabel.text = [NSString stringWithFormat:@"邀请码：%@",[XLTUserManager shareManager].curUserInfo.invite_link_code];
//    }
//    [self.invateLabel sizeToFit];
//    self.invateLabelWith.constant = self.invateLabel.width + 20;
    if (self.model.seleted) {
        [self.selectBtn setImage:[UIImage imageNamed:@"xingletao_mine_invate_select"] forState:UIControlStateNormal];
    }else{
        [self.selectBtn setImage:[UIImage imageNamed:@"xingletao_mine_invate_unselect"] forState:UIControlStateNormal];
    }
}
@end
