//
//  XLTStoreSearchFooterView.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/12.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTStoreSearchFooterView.h"
#import "UIImage+UIColor.h"

@interface XLTStoreSearchFooterView ()
@property (nonatomic, weak) IBOutlet UIImageView *letaobgImageView;

@end

@implementation XLTStoreSearchFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIImage *bgImage = [UIImage letaoimageWithColor:[UIColor whiteColor]];
    UIGraphicsBeginImageContextWithOptions(self.letaobgImageView.bounds.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, -10, self.letaobgImageView.bounds.size.width, 20) byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0, 10.0)] addClip];
    [bgImage drawInRect:CGRectMake(0, 0, self.letaobgImageView.bounds.size.width, self.letaobgImageView.bounds.size.height)];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
              UIGraphicsEndImageContext();
    self.letaobgImageView.image = roundedImage;
}

@end
