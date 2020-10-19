//
//  XLTShareFeedGoodsStepCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTShareFeedGoodsStepCell.h"
#import "MBProgressHUD+TipView.h"


@implementation XLTShareFeedGoodsStepCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentCopyButton.layer.masksToBounds = YES;
    self.contentCopyButton.layer.cornerRadius = 11.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)contentCopyBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cell:copyBtnClicked:)]) {
        [self.delegate cell:self copyBtnClicked:sender];
    }
}

- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo {
    NSString *contentText = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        contentText = itemInfo[@"share_code"];
    }
    [self letaoUpdateCellContent:contentText];
}


- (void)letaoUpdateCellContent:(NSString * _Nullable )content {
    NSString *contentText = nil;
    if ([content isKindOfClass:[NSString class]]) {
        contentText = content;
    }
    if ([contentText isKindOfClass:[NSString class]]) {
        self.contentLabel.text = contentText;
    } else {
        self.contentLabel.text = nil;
    }
}

@end
