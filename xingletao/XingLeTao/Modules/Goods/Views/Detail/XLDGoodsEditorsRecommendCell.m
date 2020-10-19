//
//  XLDGoodsEditorsRecommendCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/7/2.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLDGoodsEditorsRecommendCell.h"

@interface XLDGoodsEditorsRecommendCell ()
@property (nonatomic, weak) IBOutlet UIView *recommendTitelView;

@property (nonatomic, weak) IBOutlet UILabel *recommendLabel;
@end

@implementation XLDGoodsEditorsRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.recommendTitelView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerBottomRight withRadii:CGSizeMake(4.0, 4.0)];
}

- (void)letaoUpdateCellDataWithInfo:(NSString *)recommend_text  {
    self.recommendLabel.attributedText = [XLDGoodsEditorsRecommendCell formatRecommendText:recommend_text];
}

+ (CGFloat)cellHeightForRecommendText:(NSString *)text {
    if ([text isKindOfClass:[NSString class]] && text.length > 0) {
        NSAttributedString *attributedString = [self formatRecommendText:text];
        CGFloat top = 26 + 10 + 10;
        CGFloat bottomOffset =  10;
        CGFloat bottom =  15;
        CGFloat textHeight = ceilf([attributedString boundingRectWithSize:CGSizeMake(kScreenWidth - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height);
        return top + textHeight + bottom + bottomOffset;
    }
    return 0;
}

+ (NSMutableAttributedString *)formatRecommendText:(NSString *)text  {
    if ([text isKindOfClass:[NSString class]] && text.length > 0) {
        NSString *appendingString = @" 点我复制";
        NSString *recommendText = [text stringByAppendingString:appendingString];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:recommendText];
        NSDictionary *textAttrs = @{NSFontAttributeName : [UIFont letaoRegularFontWithSize:12],
                                    NSForegroundColorAttributeName: [UIColor colorWithHex:0xFF333333]};
        [attributedString addAttributes:textAttrs range:[recommendText rangeOfString:text]];
        NSDictionary *dianAttrs = @{NSFontAttributeName : [UIFont letaoRegularFontWithSize:13],
                                    NSForegroundColorAttributeName: [UIColor colorWithHex:0xFFFF8202]};
        [attributedString addAttributes:dianAttrs range:[recommendText rangeOfString:appendingString]];
        return attributedString;
    }
    return nil;
}

@end
