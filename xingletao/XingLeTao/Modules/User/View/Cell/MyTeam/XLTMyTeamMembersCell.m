//
//  XLTMyTeamMembersCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/23.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTMyTeamMembersCell.h"

@interface XLTMyTeamMembersCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *validMemberFlagLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *inviterLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviterFlagLabel;

@property (weak, nonatomic) IBOutlet UILabel *memberInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *nextLevelProgressLabel;

@property (weak, nonatomic) IBOutlet UIView *upgradeView;
@property (weak, nonatomic) IBOutlet UIView *progressBgView;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidth;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *progressInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *progressBgButton;

@property (weak, nonatomic) IBOutlet UILabel *wxtgLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIStackView *progressStackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressBottom;
@property (weak, nonatomic) IBOutlet UIImageView *outTipView;

@end

@implementation XLTMyTeamMembersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.progressInfoButton.layer.borderWidth = 0.5;
    self.progressInfoButton.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 7.0;
    self.contentView.backgroundColor = [UIColor letaolightgreyBgSkinColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(XLTUserTeamItemListModel *)model{
    _model = model;
    self.outTipView.hidden = self.model.status.integerValue != -1;
    if (self.model.register_from.intValue == 4) {
        self.progressBgButton.hidden = YES;
        self.progressStackView.hidden = YES;
        self.progressInfoButton.hidden = YES;
        self.wxtgLabel.hidden = NO;
        self.progressBottom.constant = 5;
    }else{
        self.progressBgButton.hidden = NO;
        self.progressStackView.hidden = NO;
        self.progressInfoButton.hidden = NO;
        self.wxtgLabel.hidden = YES;
        self.progressBottom.constant = 14;
    }
    if (![model isKindOfClass:[XLTUserTeamItemListModel class]]) {
        return;
    }
    self.validMemberFlagLabel.hidden = !self.model.recent.boolValue;

    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"]];
    if (self.validMemberFlagLabel.hidden) {
        self.memberNameLabel.text = [self.model.username isKindOfClass:[NSString class]] ? [NSString stringWithFormat:@"%@ ",self.model.username] : @" ";
    } else {
        self.memberNameLabel.text = [self.model.username isKindOfClass:[NSString class]] ? [NSString stringWithFormat:@" %@ ",self.model.username] : @"  ";
    }

    
    NSString *inviterStr = ([self.model.inviterUsername isKindOfClass:[NSString class]] && self.model.inviterUsername.length) ? [NSString stringWithFormat:@"邀请人 %@",self.model.inviterUsername] : @"邀请人 --";
    self.inviterLabel.text = inviterStr;
    self.inviterFlagLabel.hidden = !([model.recommed isKindOfClass:[NSNumber class]] && model.recommed.boolValue);
    
    
    
    NSString *memberNumberTitle = @"粉丝人数 ";
    NSString *memberNumberString = ([self.model.fans_all isKindOfClass:[NSString class]] || [self.model.fans_all isKindOfClass:[NSNumber class]]) ? [NSString stringWithFormat:@"%ld", (long)[self.model.fans_all integerValue]] : @"0";
    NSString *totalEarnTitle = @"累计预估收益 ";
    NSString *totalEarnString = [self.model.estimate_total isKindOfClass:[NSString class]] ? [NSString stringWithFormat:@"¥%@",[self.model.estimate_total priceStr]] : @"¥--";
    NSString *memberInfoText = [NSString stringWithFormat:@"%@%@  %@%@",memberNumberTitle,memberNumberString,totalEarnTitle,totalEarnString];
    
    NSMutableAttributedString *memberInfoAttr = [[NSMutableAttributedString alloc] initWithString:memberInfoText];
    
    [memberInfoAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]} range:NSMakeRange(0, memberInfoAttr.length)];
    [memberInfoAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]} range:[memberInfoText rangeOfString:memberNumberString]];
    [memberInfoAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]} range:[memberInfoText rangeOfString:totalEarnString]];
    self.memberInfoLabel.attributedText = memberInfoAttr;
    
    NSString *creatTimeText = ([self.model.itime isKindOfClass:[NSString class]] && self.model.itime.length) ? [self.model.itime convertDateStringWithSecondTimeStr:@"yyyy-MM-dd hh:mm:ss"] : @"--";
    self.dateLabel.text = creatTimeText;
    //类型：String  必有字段  备注：用户等级 1=>用户 2=>会员 3=>超级会员 4=>最高级(名称未定)
    NSInteger level = ([self.model.level isKindOfClass:[NSString class]] || [self.model.level isKindOfClass:[NSNumber class]]) ? [self.model.level integerValue] : 0;
    
    switch (level) {
        case 3: {
            self.levelImageView.image = [UIImage imageNamed:@"xlt_mine_tag_supper"];
        }
            break;
        case 4: {
            self.levelImageView.image = [UIImage imageNamed:@"xlt_mine_tag_md"];
        }
            break;
        default: {
            self.levelImageView.image = [UIImage imageNamed:@"xlt_mine_tag"];
        }
            break;
    }

    BOOL showProgress = [self.model.process isKindOfClass:[NSNumber class]] && [self.model.process_explain isKindOfClass:[NSString class]] && self.model.process_explain.length > 0;
    if (showProgress) {
        self.upgradeView.hidden = NO;
        NSString *progressText = [NSString stringWithFormat:@"%@",self.model.process_explain];
        self.nextLevelProgressLabel.text = progressText;
        self.progressViewWidth.constant = ceilf(MIN([self.model.process floatValue], 1.0) * 110);
    } else {
        self.upgradeView.hidden = YES;
    }
    self.progressInfoButton.hidden = self.upgradeView.hidden;
    self.progressBgButton.hidden = self.upgradeView.hidden;
    
}

- (IBAction)progressInfoButtonAction:(id)sender {
    if (self.model.register_from.intValue == 4) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(myTeamMembersCell:shwoProgressWithInfo:)]) {
        [self.delegate myTeamMembersCell:self shwoProgressWithInfo:self.model];
    }
}

@end



