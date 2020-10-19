//
//  XLTMallGoodsDetailInfoCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTMallGoodsDetailInfoCell.h"
#import "UIColor+XLTColorConstant.h"
#import "XLTGoodsDisplayHelp.h"
#import "NSNumber+XLTTenThousandsHelp.h"
#import "NSString+XLTSourceStringHelper.h"

@interface XLTMallGoodsDetailInfoCell ()


@end

@implementation XLTMallGoodsDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.contentView.backgroundColor = [UIColor whiteColor];
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(letaoPressAction)];
    self.letaoGoodsTitleLabel.userInteractionEnabled = YES;
    [self.letaoGoodsTitleLabel addGestureRecognizer:press];
}

- (void)letaoPressAction{
    [[XLTAppPlatformManager shareManager] saveGoodsPasteboardValue:self.letaoGoodsTitleLabel.text];
    [UIPasteboard generalPasteboard].string = self.letaoGoodsTitleLabel.text;
    [MBProgressHUD letaoshowTipMessageInWindow:@"商品标题已复制!"];
}

- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo {
    NSNumber *price = nil;
    NSNumber *paidNumber = nil;
    NSString *letaoGoodsTitleLabelString = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        price = itemInfo[@"price"];
        paidNumber = itemInfo[@"sale_count"];
        letaoGoodsTitleLabelString = itemInfo[@"title"];
        
    }
    self.letaopriceLabel.text = nil;
    if ([price isKindOfClass:[NSString class]]
        || [price isKindOfClass:[NSNumber class]]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ ",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:price]]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont letaoRegularFontWithSize:13.0] range:NSMakeRange(0, 1)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont letaoMediumBoldFontWithSize:20.0] range:NSMakeRange(1, attributedString.length -1)];
        self.letaopriceLabel.attributedText = attributedString;
    }
    else {
        self.letaopriceLabel.attributedText = nil;
    }
    
    

    if (![paidNumber isKindOfClass:[NSNumber class]]
        || [paidNumber integerValue] < 1) {
        self.letaoPaidCountLabel.text = [NSString stringWithFormat:@"销量 %@",@"0"];
    } else {
        self.letaoPaidCountLabel.text = [NSString stringWithFormat:@"销量 %@",[paidNumber letaoTenThousandNumberFormat]];
    }
    
    
    if (![letaoGoodsTitleLabelString isKindOfClass:[NSString class]]) {
        letaoGoodsTitleLabelString = nil;
    }
    self.letaoGoodsTitleLabel.text = letaoGoodsTitleLabelString;
    

}


@end
