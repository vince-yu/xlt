//
//  XLTCelebrityFooter.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/11.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTCelebrityFooter.h"
#import "SGAdvertScrollView.h"
#import "UIImage+UIColor.h"

@interface XLTCelebrityFooter ()
@property (nonatomic, weak) IBOutlet SGAdvertScrollView *advertScrollView;
@property (nonatomic, weak) IBOutlet UILabel *lettaoGoodsCountLabel;
@property (nonatomic, weak) IBOutlet UIImageView *letaobgImageView;
@property (nonatomic, strong) NSArray *advertArray;;
@end

@implementation XLTCelebrityFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.advertScrollView.layer.masksToBounds = YES;
    self.advertScrollView.layer.cornerRadius = 15.0;
    self.advertScrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.advertScrollView.titleColor = [UIColor whiteColor];
    self.advertScrollView.scrollTimeInterval = 3;
    self.advertScrollView.titles = @[];
    self.advertScrollView.titleFont = [UIFont letaoRegularFontWithSize:12];
    self.advertScrollView.signImagesSize = CGSizeMake(25.0, 25.0);
    self.advertScrollView.signImageViewX = 8.0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIImage *bgImage = [UIImage letaoimageWithColor:[UIColor whiteColor]];
    UIGraphicsBeginImageContextWithOptions(self.letaobgImageView.bounds.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.letaobgImageView.bounds.size.width, self.letaobgImageView.bounds.size.height) byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0, 10.0)] addClip];
    [bgImage drawInRect:CGRectMake(0, 0, self.letaobgImageView.bounds.size.width, self.letaobgImageView.bounds.size.height)];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
              UIGraphicsEndImageContext();
    self.letaobgImageView.image = roundedImage;
}

- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)itemInfo {
    NSArray *scrollArray = nil;
    NSNumber *goods_count = nil;

    
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        if ([itemInfo[@"scroll"] isKindOfClass:[NSArray class]]) {
            scrollArray = itemInfo[@"scroll"];
        }
        if ([itemInfo[@"goods_count"] isKindOfClass:[NSNumber class]]) {
            goods_count = itemInfo[@"goods_count"];
        }
    }
    [self laotaoUpdateAdvertArrayData:scrollArray];
    
    self.lettaoGoodsCountLabel.text = [NSString stringWithFormat:@"共%ld件商品",(long)[goods_count unsignedIntegerValue]];
}

- (void)laotaoUpdateAdvertArrayData:(NSArray *)info {
    if ([info isKindOfClass:[NSArray class]]) {
        if (self.advertArray != info) {
            self.advertArray = info;
            NSMutableArray *titles = [NSMutableArray array];
            NSMutableArray *imageUrl = [NSMutableArray array];
            [self.advertArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]] && [obj[@"content"] isKindOfClass:[NSString class]]) {
                    [titles addObject:obj[@"content"]];
                } else {
                    [titles addObject:@""];
                }
                if ([obj isKindOfClass:[NSDictionary class]] && [obj[@"img_url"] isKindOfClass:[NSString class]]) {
                    NSString *img_url = obj[@"img_url"];
                    [imageUrl addObject:[img_url letaoConvertToHttpsUrl]];
                } else {
                    [imageUrl addObject:@"xinletao_placeholder_loading_small"];
                }
            }];
            self.advertScrollView.titles = titles;
            self.advertScrollView.signImages = imageUrl;
        }
    }
}
@end

