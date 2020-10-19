//
//  XLTMyMembersUpGradeTitleCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/25.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTMyMembersUpGradeTitleCell.h"

@implementation XLTMyMembersUpGradeTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)myMembersUpGradeCloseAction {
    if ([self.delegate respondsToSelector:@selector(myMembersUpGradeCloseAction)]) {
        [self.delegate myMembersUpGradeCloseAction];
    }
}

@end
