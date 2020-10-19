//
//  XLTContributeCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTContributeCell.h"

@interface XLTContributeCell ()
@property (weak, nonatomic) IBOutlet UIButton *avatorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipBg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabe;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desWeith;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipWidth;

@end

@implementation XLTContributeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatorImageView.layer.cornerRadius = 22.5;
    self.avatorImageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(XLTUserContibuteModel *)model{
    _model = model;
    switch (self.model.level.intValue) {
            case 1:
            {
                self.vipBg.hidden = YES;
                self.nameLeft.constant = 18;
            }
                break;
            case 2:
            {
                self.vipBg.hidden = NO;
                UIImage *bgImage  = [UIImage imageNamed:@"xlt_mine_tag"];
                self.vipBg.image = bgImage;
                self.vipWidth.constant = 52;
            }
                break;
            case 3:
            {
                
                self.vipBg.hidden = NO;
                UIImage *bgImage  = [UIImage imageNamed:@"xlt_mine_tag_supper"];
                self.vipBg.image = bgImage;
                self.vipWidth.constant = 75;
        }
                break;
            case 4:
            {
                
                self.vipBg.hidden = NO;
                UIImage *bgImage  = [UIImage imageNamed:@"xlt_mine_tag_md"];
                self.vipBg.image = bgImage;
                self.vipWidth.constant = 75;
    //            [self.vipUpView setImage:[UIImage imageNamed:@"xlt_vip_up_nomal"]];
            }
                break;
            default:{
                self.vipBg.hidden = YES;
            }
                break;
        }
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] forState:UIControlStateNormal placeholderImage: [UIImage imageNamed:@"xingletao_mine_header_placeholder"]];
    if (self.cellType == XLTContributeTypeTotal) {
        self.desLabel.text = @"总预估佣金:";
        self.priceLabel.text = self.model.total_amount.length ? [NSString stringWithFormat:@"￥%@",[self.model.total_amount priceStr]] : @"￥0";
    }else if (self.cellType == XLTContributeTypeNew){
        self.desLabel.text = @"近7日拉新:";
        self.priceLabel.text = self.model.fans_all.length ? self.model.fans_all : @"0";
    }else{
        self.desLabel.text = @"本月预估佣金:";
        self.priceLabel.text = self.model.total_amount.length ? [NSString stringWithFormat:@"￥%@",[self.model.total_amount priceStr]] : @"￥0";
    }
    self.nameLabe.text = self.model.username.length ? self.model.username : @"";
    
}
@end
