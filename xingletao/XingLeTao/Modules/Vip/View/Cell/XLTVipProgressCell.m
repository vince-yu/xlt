//
//  XLTVipProgressCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTVipProgressCell.h"
#import "XLTNomalProgress.h"

@implementation XLTVipProgressModel


@end

@interface XLTVipProgressCell ()
@property (weak, nonatomic) IBOutlet UILabel *describeLaebel;
@property (weak, nonatomic) IBOutlet UILabel *biliLabel;
@property (weak, nonatomic) IBOutlet XLTNomalProgress *progress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressWidth;

@end

@implementation XLTVipProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.progressWidth.constant = kScreenWidth - 34 - 30;
    // Initialization code
}
- (void)setModel:(XLTVipTaskRulesModel *)model{
    _model = model;
    if (!_model) {
        return;
    }
    if ([model isKindOfClass:[XLTVipProgressModel class]]) {
        XLTVipProgressModel *pmodel = (XLTVipProgressModel *)_model;
        self.detailTextLabel.text = pmodel.name;
        self.progress.taskProgressValue = pmodel.value;
        self.biliLabel.text = pmodel.content;
    }else{
        
        
        
        self.describeLaebel.text = self.model.desc ? self.model.desc : @"";
        self.biliLabel.text = [NSString stringWithFormat:@"%@/%@",self.model.has_value ? [self convertValue:self.model.has_value] : @"0",self.model.max_value ? [self convertValue:self.model.max_value] : @"0"];
        if (!self.model.has_value || !self.model.max_value || self.model.has_value.intValue == 0 || self.model.max_value.intValue == 0) {
            self.progress.taskProgressValue = 0;
        } else {
            if (self.model.has_value.doubleValue > self.model.max_value.doubleValue) {
                self.progress.taskProgressValue = 1;
            }else{
                self.progress.taskProgressValue = self.model.has_value.doubleValue / self.model.max_value.doubleValue;
            }
        }
    }

}
- (NSString *)convertValue:(NSNumber *)value{
    double d            = [value doubleValue];
    NSString *dStr      = [NSString stringWithFormat:@"%f", d];
    NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
    NSString *has_value = [dn stringValue];
    return has_value;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
