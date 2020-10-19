//
//  XLTFeedRecommedRankingTextCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/19.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTMyRecommedRankingTextCell.h"

@interface XLTMyRecommedRankingTextCell ()
@property (nonatomic, weak) IBOutlet UILabel *rankingLabel;
@property (nonatomic, weak) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@end

@implementation XLTMyRecommedRankingTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info rankingType:(NSString * _Nullable)rankingType {
    NSString *order_count = nil;
    NSString *rank = nil;
    NSString *reward_amount = nil;
    NSString *settle_status = nil;
    NSString *settle_type = nil;
    
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
        if ([info[@"settle_status"] isKindOfClass:[NSNumber class]]) {
            settle_status = info[@"settle_status"];
        }
        if ([info[@"reward_amount"] isKindOfClass:[NSNumber class]]) {
            reward_amount = info[@"reward_amount"];
        }
        if ([info[@"settle_type"] isKindOfClass:[NSNumber class]]) {
            settle_type = info[@"settle_type"];
        }
    }
    if (rank) {
        NSString *rankText = nil;
        if (rank.intValue > 0 && rank.intValue <= 100) {
            rankText = [NSString stringWithFormat:@"%ld",(long)[rank integerValue]];
        }else{
            rankText = @"100+";
        }
        
        NSMutableAttributedString *rankAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"商品排名:%@",rankText]];
//        [rankAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF848487],NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:14.0]} range:[rankAttributedString.string rangeOfString:rankText]];
        self.rankingLabel.attributedText = rankAttributedString;
    } else {
        self.rankingLabel.attributedText = nil;
    }
    
    if (order_count) {
        NSString *orderCountText = [NSString stringWithFormat:@"%ld",(long)[order_count integerValue]];
        NSMutableAttributedString *saleAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"下单量:%@",orderCountText]];
//        [saleAttributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:14.0]} range:[saleAttributedString.string rangeOfString:orderCountText]];
        self.saleLabel.attributedText = saleAttributedString;

    } else {
        NSMutableAttributedString *saleAttributedString = [[NSMutableAttributedString alloc] initWithString:@"下单量:0"];
        self.saleLabel.attributedText = saleAttributedString;
    }
    if (reward_amount && [reward_amount isKindOfClass:[NSNumber class]] && reward_amount.intValue > 0) {
        NSString *orderCountText =  [[NSString stringWithFormat:@"%ld",(long)[reward_amount integerValue]] priceStr];
        NSMutableAttributedString *saleAttributedString = nil;
        
        if (settle_type.intValue == 1) {
            saleAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预估奖励:￥%@",orderCountText]];
            [saleAttributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:14.0],NSForegroundColorAttributeName:[UIColor colorWithHex:0x848487]} range:[saleAttributedString.string rangeOfString:@"预估奖励:"]];
            [saleAttributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:14.0],NSForegroundColorAttributeName:[UIColor colorWithHex:0xED362F]} range:[saleAttributedString.string rangeOfString:@"￥"]];
            [saleAttributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:14.0],NSForegroundColorAttributeName:[UIColor colorWithHex:0xED362F]} range:[saleAttributedString.string rangeOfString:orderCountText]];
        }else{
            saleAttributedString = [[NSMutableAttributedString alloc] initWithString:@"预估奖励:—"];
            [saleAttributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:14.0],NSForegroundColorAttributeName:[UIColor colorWithHex:0x848487]} range:[saleAttributedString.string rangeOfString:@"预估奖励:"]];
            [saleAttributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:14.0],NSForegroundColorAttributeName:[UIColor colorWithHex:0xED362F]} range:[saleAttributedString.string rangeOfString:@"—"]];
            
        }
        
        
        self.rewardLabel.attributedText = saleAttributedString;
        self.rewardLabel.hidden = NO;
    }else{
        self.rewardLabel.hidden = YES;
    }
}





@end
