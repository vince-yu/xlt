//
//  XLTNewTeamCell.m
//  XingLeTao
//
//  Created by SNQU on 2020/3/11.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTNewTeamCell.h"
#import "XLTHomeCustomHeadView.h"

@interface  XLTNewTeamCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avtorImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UILabel *invateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *memberLabelBg;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameleading;
@property (weak, nonatomic) IBOutlet UILabel *totalLable;
@property (weak, nonatomic) IBOutlet UILabel *itimeLabel;




@end

@implementation XLTNewTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.memberLabel.layer.cornerRadius = 7.5;
    self.memberLabel.layer.masksToBounds = YES;
//    self.memberLabelBg.layer.cornerRadius = 7.5;
//    self.memberLabelBg.layer.masksToBounds = YES;
    self.avtorImage.layer.cornerRadius = 24;
    self.avtorImage.layer.masksToBounds = YES;
//    self.tipLabel.layer.borderColor = [UIColor colorWithHex:0xCFCFCE].CGColor;
//    self.tipLabel.layer.borderWidth = 1;
    self.tipLabel.layer.cornerRadius = 7.5;
    self.tipLabel.layer.masksToBounds = YES;
}
- (void)setModel:(XLTUserTeamItemListModel *)model{
    _model = model;
    if (!self.model) {
        self.tipLabel.hidden = YES;
        self.tipBg.hidden = YES;
        return;
    }
    self.tipLabel.hidden = !self.model.recent.boolValue;
    if (self.model.recent.boolValue) {
        self.nameleading.constant = 49;
    }else{
        self.nameleading.constant = 10;
    }
    self.tipBg.hidden = !self.model.recent.boolValue;
    [self.avtorImage sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"]];
    self.nameLabel.text = self.model.username.length ? self.model.username : @"";
    NSString *subStr = self.model.fans_all.length ? [NSString stringWithFormat:@"粉丝人数 %@",self.model.fans_all] : @"粉丝人数 0";
    NSString *totalStr = self.model.estimate_total.length ? [NSString stringWithFormat:@"累计预估收益 ¥%@",[self.model.estimate_total priceStr]] : @"累计预估收益 ¥--";
    NSString *inviterStr = self.model.inviterUsername.length ? [NSString stringWithFormat:@"邀请人 %@",self.model.inviterUsername] : @"邀请人 --";
    
    NSMutableAttributedString *subAttr = [[NSMutableAttributedString alloc] initWithString:subStr];
    [subAttr addAttributes:@{NSFontAttributeName: [UIFont letaoRegularFontWithSize:12.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xA5A5A6]} range:NSMakeRange(0, 4)];
    [subAttr addAttributes:@{NSFontAttributeName: [UIFont letaoRegularFontWithSize:12.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(4, subAttr.length - 4)];
    self.subLabel.attributedText = subAttr;
    
    NSMutableAttributedString *totalAttr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [totalAttr addAttributes:@{NSFontAttributeName: [UIFont letaoRegularFontWithSize:12.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(0, 6)];
    [totalAttr addAttributes:@{NSFontAttributeName: [UIFont letaoRegularFontWithSize:12.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xF73737]} range:NSMakeRange(6, totalAttr.length - 6)];
    self.totalLable.attributedText = totalAttr;
    
    NSMutableAttributedString *inviterAttr = [[NSMutableAttributedString alloc] initWithString:inviterStr];
    [inviterAttr addAttributes:@{NSFontAttributeName: [UIFont letaoRegularFontWithSize:12.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xA5A5A6]} range:NSMakeRange(0, 3)];
    [inviterAttr addAttributes:@{NSFontAttributeName: [UIFont letaoRegularFontWithSize:12.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(4, inviterAttr.length - 4)];
    self.invateLabel.attributedText = inviterAttr;
    
    NSString *creatTimeText = self.model.itime.length ? [self.model.itime convertDateStringWithSecondTimeStr:@"yyyy-MM-dd hh:mm:ss"] : @"--";
//    NSMutableAttributedString *createTimeAttr = [[NSMutableAttributedString alloc] initWithString:creatTimeText];
//    [createTimeAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xA5A5A6]} range:NSMakeRange(0, 4)];
//    [createTimeAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(4,creatTimeText.length - 4)];
//    self.creatTimeLabel.attributedText = createTimeAttr;
    self.itimeLabel.text = creatTimeText;
    
    switch (self.model.level.intValue) {
        case 1:
            self.memberLabel.hidden = YES;
            self.memberLabelBg.hidden = YES;
            break;
        case 2:
        {
//            self.memberLabel.hidden = NO;
//            self.memberLabel.textColor = [UIColor whiteColor];
//            self.memberLabel.text = @"会员";
            self.memberLabelBg.hidden = NO;
//            UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFAE01],[UIColor colorWithHex:0xFF6E02]] gradientType:1 imgSize:self.memberLabelBg.size];
            self.memberLabelBg.image = [UIImage imageNamed:@"xlt_mine_tag"];
        }
            break;
        case 3:
        {
//            self.memberLabel.hidden = NO;
//            self.memberLabel.textColor = [UIColor whiteColor];
//            self.memberLabel.text = @"超级会员";
            self.memberLabelBg.hidden = NO;
            UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xEBBF79],[UIColor colorWithHex:0xCB9239]] gradientType:1 imgSize:self.memberLabelBg.size];
            self.memberLabelBg.image = bgImage;
            self.memberLabelBg.image = [UIImage imageNamed:@"xlt_mine_tag_supper"];
    }
            break;
        case 4:
        {
//            self.memberLabel.hidden = NO;
//            self.memberLabel.text = @"运营总监";
//            self.memberLabel.textColor = [UIColor colorWithHex:0xE8C48B];
            self.memberLabelBg.hidden = NO;
//            UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0x000000],[UIColor colorWithHex:0x312F2B]] gradientType:1 imgSize:self.memberLabelBg.size];
//            self.memberLabelBg.image = bgImage;
            self.memberLabelBg.image = [UIImage imageNamed:@"xlt_mine_tag_md"];
        }
            break;
        default:{
            self.memberLabel.hidden = YES;
            self.memberLabelBg.hidden = YES;
        }
            break;
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
