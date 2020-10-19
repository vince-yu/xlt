//
//  XLTMyTeamMembersCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/23.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTMyInviteMembersCell.h"

@interface XLTMyInviteMembersCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *validMemberFlagLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *memberInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation XLTMyInviteMembersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
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
    if (!self.model) {
        return;
    }
    self.validMemberFlagLabel.hidden = !self.model.recent.boolValue;

    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"]];
    if (self.validMemberFlagLabel.hidden) {
        self.memberNameLabel.text = [self.model.username isKindOfClass:[NSString class]] ? [NSString stringWithFormat:@"%@ ",self.model.username] : @" ";
    } else {
        self.memberNameLabel.text = [self.model.username isKindOfClass:[NSString class]] ? [NSString stringWithFormat:@" %@ ",self.model.username] : @"  ";
    }
    
    
    
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
}

@end



