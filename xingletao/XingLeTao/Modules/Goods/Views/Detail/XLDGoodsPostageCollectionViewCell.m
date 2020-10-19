//
//  XLDGoodsPostageCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsPostageCollectionViewCell.h"
#import "XLTGoodsDisplayHelp.h"

@interface XLDGoodsPostageCollectionViewCell ()
@property (nonatomic, weak) IBOutlet UILabel *letaoLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoPostageLabel;
@property (nonatomic, weak) IBOutlet UIView *letaoSpaceLineView;

@end
@implementation XLDGoodsPostageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}



- (void)letaoUpdateCellDataWithInfo:(id _Nullable )deliveryInfo {
    NSString *item_delivery_from = deliveryInfo[@"item_delivery_from"];
    NSNumber *item_delivery_postage = deliveryInfo[@"item_delivery_postage"];
    
    self.letaoLocationLabel.text = item_delivery_from;

    if ([item_delivery_postage integerValue] >= 0) {
        self.letaoPostageLabel.text = [NSString stringWithFormat:@"快递%@元",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:item_delivery_postage]];
        self.letaoPostageLabel.hidden = NO;
    } else {
        self.letaoPostageLabel.hidden = YES;
    }
    self.letaoSpaceLineView.hidden = self.letaoPostageLabel.hidden;
}
@end
