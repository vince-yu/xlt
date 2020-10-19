//
//  XLTFeedRecommedRankingTextCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/19.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedRecommedRankingTextCell.h"

@interface XLTFeedRecommedRankingTextCell ()
@property (nonatomic, weak) IBOutlet UILabel *rankingLabel;
@property (nonatomic, weak) IBOutlet UILabel *saleLabel;
@end

@implementation XLTFeedRecommedRankingTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info rankingType:(NSString *)rankingType {
    NSString *order_count = nil;
    NSString *rank = nil;
    
    if ([info isKindOfClass:[NSDictionary class]]) {
        //  rankingType空的时候显示销量
        if (rankingType == nil){
            if ([info[@"order_count"] isKindOfClass:[NSNumber class]]) {
                order_count = info[@"order_count"];
            }
        }
        if ([info[@"rank"] isKindOfClass:[NSNumber class]]) {
            rank = info[@"rank"];
        }
    }
    
    NSString *rankText = nil;
    if(([rank integerValue] >0 && [rank integerValue] <= 100)) {
        rankText = [NSString stringWithFormat:@"%ld",(long)[rank integerValue]];
    } else {
        rankText = @"100+";
    }
    NSMutableAttributedString *rankAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"商品排名:%@",rankText]];
    [rankAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFF73737],NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:14.0]} range:[rankAttributedString.string rangeOfString:rankText]];
    self.rankingLabel.attributedText = rankAttributedString;
    
    if (order_count) {
        NSString *orderCountText = [NSString stringWithFormat:@"%ld",(long)[order_count integerValue]];
        NSMutableAttributedString *saleAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"下单量:%@",orderCountText]];
        [saleAttributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:14.0]} range:[saleAttributedString.string rangeOfString:orderCountText]];
        self.saleLabel.attributedText = saleAttributedString;

    } else {
        self.saleLabel.attributedText = nil;
    }
}





@end
