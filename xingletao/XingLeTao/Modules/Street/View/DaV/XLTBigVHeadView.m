//
//  XLTBigVHeadView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/26.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBigVHeadView.h"
#import "UIImage+UIColor.h"
#import "UIImageView+WebCache.h"

@interface XLTBigVHeadView ()
@property (nonatomic, weak) IBOutlet UILabel *dvNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dvScoureLabel;
@property (nonatomic, weak) IBOutlet UIImageView *dvPhotoImageView;
@property (nonatomic, weak) IBOutlet UIImageView *dvSourceImageView;
@property (nonatomic, strong) UIImageView *letaobgImageView;

@end

@implementation XLTBigVHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIImageView *letaobgImageView = [[UIImageView alloc] init];
    [self insertSubview:letaobgImageView atIndex:0];
    self.letaobgImageView = letaobgImageView;
    
    self.dvPhotoImageView.layer.masksToBounds = YES;
    self.dvPhotoImageView.layer.cornerRadius = 25;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(letaoBigVTopHeadViewClicked)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.letaobgImageView.frame = CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height);
    UIImage *bgImage = [UIImage letaoimageWithColor:[UIColor whiteColor]];
       //圆角
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
                 [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(10.0, 10.0)] addClip];
    [bgImage drawInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
                 UIGraphicsEndImageContext();
    self.letaobgImageView.image = roundedImage;
}

- (void)updateDaVData:(id _Nullable )itemInfo {
    
    NSString *name = nil;
    NSString *avatar = nil;
    NSNumber *source = nil;
    NSString *source_text = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        name = [itemInfo[@"name"] isKindOfClass:[NSString class]] ? itemInfo[@"name"] : nil;
        avatar = [itemInfo[@"avatar"] isKindOfClass:[NSString class]] ? itemInfo[@"avatar"] : nil;
        source = [itemInfo[@"source"] isKindOfClass:[NSNumber class]] ? itemInfo[@"source"] : nil;
        source_text = [itemInfo[@"source_text"] isKindOfClass:[NSString class]] ? [NSString stringWithFormat:@"%@知名博主",itemInfo[@"source_text"]] : nil;;
    }
    self.dvNameLabel.text = name;
    [self.dvPhotoImageView sd_setImageWithURL:[NSURL URLWithString:avatar]];
    self.dvScoureLabel.text = source_text;
    UIImage *sourceImage = nil;
    if ([source intValue] ==1) {
        // 新浪
        sourceImage = [UIImage imageNamed:@"xinletao_dv_weibo"];
    } else if ([source intValue] ==2) {
        // 小红书
        sourceImage = [UIImage imageNamed:@"xinletao_dv_xiaohongshu"];
    } else {
        sourceImage = [UIImage imageNamed:@"xinletao_dv_tengxun"];
    }
    self.dvSourceImageView.image = sourceImage;
}

- (void)letaoBigVTopHeadViewClicked {
    if ([self.delegate respondsToSelector:@selector(letaoBigVTopHeadViewClicked:)]) {
        [self.delegate letaoBigVTopHeadViewClicked:self];
    }
}
@end
