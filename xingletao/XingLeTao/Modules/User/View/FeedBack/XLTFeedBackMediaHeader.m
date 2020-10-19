//
//  XLTFeedBackMediaHeader.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedBackMediaHeader.h"
#import "UIView+Extension.h"

@interface XLTFeedBackMediaHeader ()

@property (nonatomic, weak) IBOutlet UIView *letaoContentView;

@end

@implementation XLTFeedBackMediaHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.letaoContentView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(8.0, 8.0)];

}

@end
