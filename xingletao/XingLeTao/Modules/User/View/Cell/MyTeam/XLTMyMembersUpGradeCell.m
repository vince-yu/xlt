//
//  XLTVipProgressCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/30.
//  Copyright © 2019 snqu. All rights reserved.
//


#import "XLTNomalProgress.h"
#import "XLTMyMembersUpGradeCell.h"

@interface XLTMyMembersUpGradeCell ()
@property (weak, nonatomic) IBOutlet UILabel *describeLaebel;
@property (weak, nonatomic) IBOutlet UILabel *biliLabel;


@property (weak, nonatomic) IBOutlet UIView *progressBgView;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@end

@implementation XLTMyMembersUpGradeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
- (void)setModel:(XLTVipTaskRulesModel *)model {
    _model = model;
    
    self.describeLaebel.text = [self.model.desc isKindOfClass:[NSString class]] ? self.model.desc : @"";
    NSString *has_value = ([self.model.has_value isKindOfClass:[NSString class]] || [self.model.has_value isKindOfClass:[NSNumber class]]) ? [NSString stringWithFormat:@"%@",self.model.has_value] : @"0";
    NSString *max_value = ([self.model.max_value isKindOfClass:[NSString class]] || [self.model.max_value isKindOfClass:[NSNumber class]]) ? [NSString stringWithFormat:@"%@",self.model.max_value] : @"0";
    self.biliLabel.text = nil;
    if ([max_value floatValue] > 0) {
        NSString *suffix = [NSString stringWithFormat:@"/%@",max_value];
        NSString *text = [has_value stringByAppendingString:suffix];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont letaoRegularFontWithSize:13.0] range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFF25282D] range:NSMakeRange(0, attributedString.length)];

        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFFA5A5A6] range:[text rangeOfString:suffix]];
        self.biliLabel.attributedText = attributedString;
        CGFloat value = MIN(1.0, has_value.floatValue / max_value.floatValue);
        [self updateProgressValue:value];
    } else {
        [self updateProgressValue:0];
        self.biliLabel.attributedText = nil;
    }
}


- (void)updateProgressValue:(CGFloat)progressValue {
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.height.mas_equalTo(8.0);
        make.width.equalTo(self.progressBgView.mas_width).multipliedBy(progressValue);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
