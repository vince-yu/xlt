//
//  XLTOrderFindCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTOrderFindCollectionViewCell.h"
#import "XLTGoodsDisplayHelp.h"
#import "UIImage+UIColor.h"
#import "XLTOrderListModel.h"

@interface XLTOrderFindCollectionViewCell ();
@property (nonatomic, weak) IBOutlet UILabel *letaoOrderNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoOrderStateLabel;
@property (nonatomic, weak) IBOutlet UIImageView *letaogoodsImageView;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *lettaoGoodsCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoOrderDateLabel;

@end

@implementation XLTOrderFindCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 10.0;
    self.contentView.backgroundColor = [UIColor whiteColor];
    

    
    self.letaogoodsImageView.layer.masksToBounds = YES;
    self.letaogoodsImageView.layer.cornerRadius = 5.0;
}

- (void)letaoClearContentText {
    [super prepareForReuse];
    self.letaoOrderStateLabel.text = nil;
}

- (void)letaoUpdateCellWithData:(XLTOrderListModel *)orderModel {
    [self letaoClearContentText];
    
    NSString *orderNo = nil;
    NSString *status_text = nil;
    NSString *item_title = nil;
    NSString *item_image = nil;
    NSString *paid_amount = nil;
    NSString *item_num = nil;
    NSString *create_time = nil;
    

    
    if ([orderModel isKindOfClass:[XLTOrderListModel class]]) {
        if ([orderModel.third_order_id isKindOfClass:[NSString class]]) {
            orderNo = [NSString stringWithFormat:@"订单编号：%@",orderModel.third_order_id];
        }
        if ([orderModel.xlt_settle_status_text isKindOfClass:[NSString class]]) {
            status_text = orderModel.xlt_settle_status_text;
        }
        if ([orderModel.item_title isKindOfClass:[NSString class]]) {
            item_title = orderModel.item_title;
        }
        if ([orderModel.item_image isKindOfClass:[NSString class]]) {
            item_image = orderModel.item_image;
        }
        
        
        if ([orderModel.paid_amount isKindOfClass:[NSString class]]
            || [orderModel.paid_amount isKindOfClass:[NSNumber class]]) {
            paid_amount = orderModel.paid_amount;
        }
        if ([orderModel.item_num isKindOfClass:[NSString class]]
            || [orderModel.item_num isKindOfClass:[NSNumber class]]) {
            item_num =orderModel.item_num;
        }
        if ([orderModel.create_time isKindOfClass:[NSString class]]) {
            create_time = orderModel.create_time;
        }
        
    }
    self.letaoOrderNumberLabel.text = orderNo;
    self.letaoOrderStateLabel.text = status_text;
    [self.letaogoodsImageView sd_setImageWithURL:[NSURL URLWithString:[item_image letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderSmallImage];
    self.letaoGoodsTitleLabel.text = item_title;
    
    self.letaoPriceLabel.text = [NSString stringWithFormat:@"商品价格：%@",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:paid_amount]];
    
    self.lettaoGoodsCountLabel.text = [NSString stringWithFormat:@" 数量：%ld",(long)[item_num integerValue]];
    
    self.letaoOrderDateLabel.text = [NSString stringWithFormat:@"下单时间：%@",create_time];

}

+ (NSString *)letaoNoneSecondDateStringWithDate:(NSDate *)date {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    if ([date isKindOfClass:[NSDate class]]) {
        NSString *dateString = [dateFormatter stringFromDate:date];
        return dateString;
    }
    return @"";

}




@end
