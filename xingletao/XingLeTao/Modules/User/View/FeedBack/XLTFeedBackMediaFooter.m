//
//  XLTFeedBackMediaFooter.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedBackMediaFooter.h"

@interface XLTFeedBackMediaFooter ()
@property (nonatomic, weak) IBOutlet UIView *letaoContentView;

@end

@implementation XLTFeedBackMediaFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];


}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.letaoContentView addRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight withRadii:CGSizeMake(8.0, 8.0)];;
}

@end
