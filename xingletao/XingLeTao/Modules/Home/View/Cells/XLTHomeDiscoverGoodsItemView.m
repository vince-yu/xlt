//
//  XLTHomeDiscoverGoodsItemView.m
//  XingLeTao
//
//  Created by chenhg on 2020/7/8.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTHomeDiscoverGoodsItemView.h"

@interface XLTHomeDiscoverGoodsItemView ()

@property (nonatomic, weak) IBOutlet UILabel *itemTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *itemSubTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *itemTagLabel;


@property (nonatomic, weak) IBOutlet UIImageView *fristImageView;
@property (nonatomic, weak) IBOutlet UILabel *fristPriceLabel;

@property (nonatomic, weak) IBOutlet UIImageView *secondImageView;
@property (nonatomic, weak) IBOutlet UILabel *secondPriceLabel;
@end


@implementation XLTHomeDiscoverGoodsItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)letaoUpdateInfo:(NSDictionary *)info {
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSDictionary *titleInfo = info[@"attribute"];
        [self letaoUpdateTitleInfo:titleInfo];
        
        NSArray *goodsList = info[@"goodsList"];
        if ([goodsList isKindOfClass:[NSArray class]]) {
            NSDictionary *fristGoods = goodsList.firstObject;
            NSDictionary *secondGoods = goodsList.lastObject;
            [self letaoUpdateFristGoodsInfo:fristGoods];
            [self letaoUpdateSecondGoodsInfo:secondGoods];
        }
    }
}

- (void)letaoUpdateTitleInfo:(NSDictionary *)info {
    self.itemTitleLabel.text = nil;
    self.itemSubTitleLabel.text = nil;
    self.itemTagLabel.hidden = YES;
    
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSString *title = info[@"title"];
        if ([title isKindOfClass:[NSString class]]) {
            self.itemTitleLabel.text = title;
            NSString *title_font_color = info[@"title_font_color"];
            if ([title_font_color isKindOfClass:[NSString class]]) {
                UIColor *titleColor =  [UIColor colorWithHexString:[title_font_color stringByReplacingOccurrencesOfString:@"#" withString:@""]];
                if ([titleColor isKindOfClass:[UIColor class]]) {
                    self.itemTitleLabel.textColor = titleColor;
                }
            }
        }
        
        
        NSString *sub_title = info[@"sub_title"];
        if ([sub_title isKindOfClass:[NSString class]]) {
            self.itemSubTitleLabel.text = sub_title;
            NSString *sub_title_font_color = info[@"sub_title_font_color"];
            if ([sub_title_font_color isKindOfClass:[NSString class]]) {
                UIColor *subTitleColor =  [UIColor colorWithHexString:[sub_title_font_color stringByReplacingOccurrencesOfString:@"#" withString:@""]];
                if ([subTitleColor isKindOfClass:[UIColor class]]) {
                    self.itemSubTitleLabel.textColor = subTitleColor;
                }
            }
        }

        NSString *label = info[@"label"];
        if ([label isKindOfClass:[NSString class]]) {
            self.itemTagLabel.text = label;
            if ([label isKindOfClass:[NSString class]] && label.length > 0) {
                self.itemTagLabel.hidden = NO;
                self.itemTagLabel.text = [NSString stringWithFormat:@"  %@  ",label];
            }
            NSString *label_font_color = info[@"label_font_color"];
            if ([label_font_color isKindOfClass:[NSString class]]) {
                UIColor *tagColor =  [UIColor colorWithHexString:[label_font_color stringByReplacingOccurrencesOfString:@"#" withString:@""]];
                if ([tagColor isKindOfClass:[UIColor class]]) {
                    self.itemTagLabel.textColor = tagColor;
                    [self.itemTagLabel setNeedsLayout];
                    [self.itemTagLabel layoutIfNeeded];
                                        
                    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:self.itemTagLabel.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomRight|UIRectCornerTopRight cornerRadii:CGSizeMake(9.5, 9.5)];
                    CAShapeLayer *border = [CAShapeLayer layer];
                    border.strokeColor = tagColor.CGColor;
                    border.fillColor = [UIColor clearColor].CGColor;
                    border.path = path.CGPath;
                    border.frame = self.itemTagLabel.bounds;
                    border.lineWidth = 0.5f;
                    [self.itemTagLabel.layer addSublayer:border];

                }
            }
        }

    }
}

- (void)letaoUpdateFristGoodsInfo:(NSDictionary *)itemInfo {
    NSNumber *price = nil;
    NSNumber *couponAmount = nil;
    NSNumber *couponStartTime = nil;
    NSNumber *couponEndTime = nil;
    NSString *picUrlString = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        price = itemInfo[@"item_price"];
        NSDictionary *coupon = itemInfo[@"coupon"];
        if ([coupon isKindOfClass:[NSDictionary class]]) {
            couponAmount = coupon[@"amount"];
            couponStartTime = [coupon[@"start_time"] isKindOfClass:[NSNumber class]] ? coupon[@"start_time"] :@0;
            couponEndTime = [coupon[@"end_time"] isKindOfClass:[NSNumber class]] ? coupon[@"end_time"] :@0;
        }
        picUrlString = itemInfo[@"item_image"];
    }
    BOOL isCouponValid = [XLTGoodsDisplayHelp letaoShouldShowCouponWithAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];

    self.fristPriceLabel.attributedText = [self formatterPrice:price isCouponValid:isCouponValid];
    if ([picUrlString isKindOfClass:[NSString class]]) {
        NSString *picUrl = [picUrlString letaoConvertToHttpsUrl];
        NSString *imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:picUrl]];
        UIImage *picImage  = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageKey];
        if ([picImage isKindOfClass:[UIImage class]]) {
            self.fristImageView.image = picImage;
            // 直接设置有webp会有bug，需要重新设置
            [self.fristImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil];
        } else {
            [self.fristImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil];
        }
    } else {
        self.fristImageView.image = nil;
    }
    

    
}

- (void)letaoUpdateSecondGoodsInfo:(NSDictionary *)itemInfo {
    NSNumber *price = nil;
    NSNumber *couponAmount = nil;
    NSNumber *couponStartTime = nil;
    NSNumber *couponEndTime = nil;
    NSString *picUrlString = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        price = itemInfo[@"item_price"];
        NSDictionary *coupon = itemInfo[@"coupon"];
        if ([coupon isKindOfClass:[NSDictionary class]]) {
            couponAmount = coupon[@"amount"];
            couponStartTime = [coupon[@"start_time"] isKindOfClass:[NSNumber class]] ? coupon[@"start_time"] :@0;
            couponEndTime = [coupon[@"end_time"] isKindOfClass:[NSNumber class]] ? coupon[@"end_time"] :@0;
        }
        picUrlString = itemInfo[@"item_image"];
    }
    BOOL isCouponValid = [XLTGoodsDisplayHelp letaoShouldShowCouponWithAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];

    self.secondPriceLabel.attributedText = [self formatterPrice:price isCouponValid:isCouponValid];
    
    if ([picUrlString isKindOfClass:[NSString class]]) {
        NSString *picUrl = [picUrlString letaoConvertToHttpsUrl];
        NSString *imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:picUrl]];
        UIImage *picImage  = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageKey];
        if ([picImage isKindOfClass:[UIImage class]]) {
            self.secondImageView.image = picImage;
            // 直接设置有webp会有bug，需要重新设置
            [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil];
        } else {
            [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil];
        }
    } else {
        self.secondImageView.image = nil;
    }
}

- (NSAttributedString *)formatterPrice:(NSNumber *)price isCouponValid:(BOOL)isCouponValid {
    NSString *priceText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:price];
    if (isCouponValid) {
        NSString *couponText = @"券后 ";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",couponText,priceText]];
        NSRange couponRang = [attributedString.string rangeOfString:couponText];
        NSRange priceRang = [attributedString.string rangeOfString:priceText];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:11.0],
                                          NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]
        } range:couponRang];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:13.0],
                                          NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFF73737]
        } range:priceRang];
        return attributedString;

    } else {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceText];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:13.0],
                                               NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFF73737]
        } range:NSMakeRange(0, priceText.length)];
        return attributedString;

    }
}


@end

