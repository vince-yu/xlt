//
//  XLTMyRecommendFailedCell.m
//  XingLeTao
//
//  Created by SNQU on 2020/6/19.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTMyRecommendFailedCell.h"

@interface XLTMyRecommendFailedCell()

@property (weak, nonatomic) IBOutlet UILabel *lookLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeight;

@end

@implementation XLTMyRecommendFailedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 5;
    self.lookLabel.layer.cornerRadius = 11;
    self.lookLabel.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setStatus:(NSString *)status{
    _status = status;
    if (_status.intValue == 2) {
        self.bgView.hidden = NO;
        self.bgHeight.constant = 40;
    }else{
        self.bgView.hidden = YES;
        self.bgHeight.constant = 30;
    }
}
@end
