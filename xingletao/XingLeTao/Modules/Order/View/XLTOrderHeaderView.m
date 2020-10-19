//
//  XLTOrderHeaderView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/19.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTOrderHeaderView.h"


@interface XLTOrderHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *letaoTipMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;

@end

@implementation XLTOrderHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.
}
- (IBAction)otherAction:(id)sender {
    if (self.otherBlock) {
        self.otherBlock();
    }
}

@end
