//
//  XLTStartRecommedFooterCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/18.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTStartRecommedFooterCell.h"
#import "SPButton.h"

@interface XLTStartRecommedFooterCell ()
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet SPButton *leftBtn;
@property (weak, nonatomic) IBOutlet SPButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *footTitleLabel;

@end

@implementation XLTStartRecommedFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.leftBtn setImage:[UIImage imageNamed:@"xinletao_edit_selected_icon"] forState:UIControlStateSelected];
    [self.rightBtn setImage:[UIImage imageNamed:@"xinletao_edit_selected_icon"] forState:UIControlStateSelected];
    [self leftAction:self.leftBtn];
    self.backgroundColor = [UIColor colorWithHex:0xF5F5F7];
}
- (void)setShowTomorrow:(BOOL)showTomorrow{
    _showTomorrow = showTomorrow;
    self.footView.hidden = !self.showTomorrow;
    self.footTitleLabel.hidden = !self.showTomorrow;
}
- (IBAction)leftAction:(id)sender {
    self.leftBtn.selected = YES;
    self.rightBtn.selected = NO;
    if (self.selectBlock) {
        self.selectBlock(@"0");
    }
}
- (IBAction)rightAction:(id)sender {
    self.leftBtn.selected = NO;
    self.rightBtn.selected = YES;
    if (self.selectBlock) {
        self.selectBlock(@"1");
    }
}

@end
