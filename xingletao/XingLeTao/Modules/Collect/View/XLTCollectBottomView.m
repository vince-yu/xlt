//
//  XLTCollectBottomView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/14.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTCollectBottomView.h"
#import "UIImage+UIColor.h"
#import "XLTUIConstant.h"
#import "UIColor+Helper.h"

@implementation XLTCollectBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deleteButton.layer.masksToBounds = YES;
    self.deleteButton.layer.cornerRadius = 20.0;
    
    [self.deleteButton setBackgroundImage:[UIImage letaoimageWithColor:[UIColor letaomainColorSkinColor] ] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFC3C4C7] ] forState:UIControlStateDisabled];

}

@end
