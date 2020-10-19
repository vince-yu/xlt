//
//  XLTGoodsDetailEmptyCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/10.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsDetailEmptyCollectionViewCell.h"

@implementation XLTGoodsDetailEmptyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSString *lineText = @"—";
    NSString *contentText = @"  猜你喜欢  ";;

     NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",lineText,contentText,lineText]];
     [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFC3C4C7]} range:NSMakeRange(0, attributedString.length)];
     [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]} range:NSMakeRange(lineText.length, contentText.length)];
     [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:15.0]} range:NSMakeRange(0, attributedString.length)];
     [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:15.0]} range:NSMakeRange(lineText.length, contentText.length)];
    
    self.letaoGuessLabel.text = nil;
    self.letaoGuessLabel.attributedText = attributedString;
}

@end
