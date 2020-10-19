//
//  XLTVipOrderCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/12/2.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTVipOrderCell.h"
#import "XLTLogisticsView.h"

@interface XLTVipOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsIcon;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@end

@implementation XLTVipOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(XLTVipOrderListModel *)model{
    if (!model) {
        return;
    }
    _model = model;
    [self.goodsIcon sd_setImageWithURL:[NSURL URLWithString:self.model.goods_info.banner.firstObject] placeholderImage:[UIImage imageNamed:@"xinletao_placeholder_loading_small"]];
    
    self.nameLabel.text = [NSString checkStrLenthWithStr:self.model.goods_info.title placeholder:@"" appStr:nil before:NO];
    self.orderLabel.text = [NSString checkStrLenthWithStr:self.model.out_trade_no placeholder:@"--" appStr:@"订单编号：" before:YES];
    self.priceLabel.text = [NSString checkStrLenthWithStr:[self.model.amount priceStr]  placeholder:@"0.00" appStr:@"商品价格：￥" before:YES];
    self.countLabel.text = [NSString checkStrLenthWithStr:self.model.num placeholder:@"--" appStr:@"数量：" before:YES];
    self.creatTimeLabel.text = [NSString checkStrLenthWithStr:[self.model.itime convertDateStringWithSecondTimeStr:@"yyyy-MM-dd hh:mm"]  placeholder:@"--" appStr:@"下单时间：" before:YES];
}
- (IBAction)detailShow:(id)sender {
    
    XLTLogisticsView *view = [[XLTLogisticsView alloc] initWithNib];
    view.model = self.model;
    [view show];

}
@end
