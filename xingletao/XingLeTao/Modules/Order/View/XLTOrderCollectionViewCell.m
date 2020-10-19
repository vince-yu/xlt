//
//  XLTOrderCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTOrderCollectionViewCell.h"
#import "XLTGoodsDisplayHelp.h"
#import "UIImage+UIColor.h"
#import "XLTAppPlatformManager.h"

@interface XLTOrderCollectionViewCell ();
@property (nonatomic, weak) IBOutlet UILabel *letaoOrderNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoOrderStateLabel;
@property (nonatomic, weak) IBOutlet UIImageView *letaogoodsImageView;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *lettaoGoodsCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoOrderDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoearnLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoMoneyArrivedDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoSalesReturnLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *letaoMoneyArriveLeading;

@property (weak, nonatomic) IBOutlet UIImageView *jqrIcon;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;


@property (nonatomic, strong) XLTOrderListModel *cellDataModel;


@property (nonatomic, assign) BOOL letaoOrderCanRebate;
@end

@implementation XLTOrderCollectionViewCell

- (void)dealloc {
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 10.0;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self.tipsLabel addRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(5, 5)];
    
    self.letaogoodsImageView.layer.masksToBounds = YES;
    self.letaogoodsImageView.layer.cornerRadius = 5.0;
    
}

- (void)letaoClearContentText {
    [super prepareForReuse];
    self.letaoOrderStateLabel.text = nil;
    self.letaoearnLabel.text = nil;
    self.letaoMoneyArrivedDateLabel.text = nil;
    self.letaoSalesReturnLabel.text = nil;
    self.letaoOrderCanRebate = NO;
}
/*
 {
    "_id":"mock",                //类型：String  可有字段  备注：ID
    "item_source":"mock",                //类型：String  必有字段  备注：商品来源第三方平台淘宝/天猫/京东
    "item_source_text":"mock",                //类型：String  必有字段  备注：商品来源第三方平台淘宝/天猫/京东
    "item_id":"mock",                //类型：String  必有字段  备注：第三方品台商品ID
    "goods_id":"mock",                //类型：String  必有字段  备注：商品ID
    "item_title":"mock",                //类型：String  必有字段  备注：商品名称
    "item_image":"mock",                //类型：String  必有字段  备注：商品首图
    "item_price":"mock",                //类型：String  必有字段  备注：商品价格
    "item_num":"mock",                //类型：String  必有字段  备注：商品数量
    "third_order_id":"mock",                //类型：String  必有字段  备注：订单编号：第三方平台订单id
    "create_time":"mock",                //类型：String  必有字段  备注：用户下单时间
    "xlt_settle_status":"mock",                //类型：String  必有字段  备注：订单状态[1:即将到账,2:已到账,10:已失效]
    "xlt_settle_status_text":"已到账",                //类型：String  必有字段  备注：订单状态[1:即将到账,2:已到账,10:已失效]
    "xlt_estimated_settle_time":"2019-11-21",                //类型：String  必有字段  备注：预估结算时间
    "xlt_total_amount":"1200",                //类型：String  必有字段  备注：用户总返利金额
    "xlt_refund_status":"1",                //类型：String  必有字段  备注：维权状态 0 无维权，1 维权创建[维权处理中] 2 维权成功，3 维权失败
    "xlt_refund_status_text":"维权创建[维权处理中]"                //类型：String  必有字段  备注：维权状态 0 无维权，1 维权创建[维权处理中] 2 维权成功，3 维权失败
}
*/
- (void)letaoUpdateCellWithData:(XLTOrderListModel *)info{
//    info.activity_voucher_tips = @"5元优惠券，满50可用";
    self.cellDataModel = info;
    [self letaoClearContentText];
    self.letaoOrderStateLabel.text = self.cellDataModel.xlt_settle_status_text;
    if (self.cellDataModel.text_color.length > 1) {
        self.letaoOrderStateLabel.textColor = [UIColor colorWithHexString:[self.cellDataModel.text_color substringWithRange:NSMakeRange(1, self.cellDataModel.text_color.length - 1)]];
    }
    [self.letaogoodsImageView sd_setImageWithURL:[NSURL URLWithString:[self.cellDataModel.item_image letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderSmallImage];
    self.letaoOrderNumberLabel.text = self.cellDataModel.third_order_id.length ? [NSString stringWithFormat:@"订单编号：%@",self.cellDataModel.third_order_id] : @"订单编号：--";
    if (self.cellDataModel.item_title.length) {
        self.letaoGoodsTitleLabel.text = self.cellDataModel.item_title;
    }else{
        self.letaoGoodsTitleLabel.text = self.cellDataModel.item_source_text.length ? self.cellDataModel.item_source_text : @"";
        
    }
    
    self.letaoPriceLabel.text = self.cellDataModel.paid_amount.length ? [NSString stringWithFormat:@"商品价格：￥%@",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:self.cellDataModel.paid_amount]] : @"商品价格：￥--";
    if ([self.cellDataModel.item_source isEqualToString:XLTCZBPlatformIndicate]) {
        self.lettaoGoodsCountLabel.text = self.cellDataModel.discount.length ? [NSString stringWithFormat:@"折扣：￥%@",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:self.cellDataModel.discount]] : @"折扣：￥--";
    }else{
        self.lettaoGoodsCountLabel.text = self.cellDataModel.item_num.length ? [NSString stringWithFormat:@"数量：%@",self.cellDataModel.item_num] : @"数量：--";
    }
    
    self.letaoOrderDateLabel.text = self.cellDataModel.create_time.length ? [NSString stringWithFormat:@"下单时间：%@",self.cellDataModel.create_time] : @"下单时间：--";
    switch (self.cellDataModel.xlt_settle_status.intValue) {
        case 1:
        {
            //维权状态 0 无维权，1 维权创建[维权处理中] 2 维权成功，3 维权失败
//            self.letaoOrderStateLabel.textColor = [UIColor colorWithHex:0xFF8202];
            if (self.cellDataModel.xlt_refund_status.intValue == 0) {
                self.letaoMoneyArrivedDateLabel.text = self.cellDataModel.xlt_order_tips.length ? self.cellDataModel.xlt_order_tips : @"" ;
                self.letaoSalesReturnLabel.hidden = YES;
                self.letaoMoneyArrivedDateLabel.hidden = NO;
            }else{
                //没有处于维权中会显示预返利金额和高反按钮（沒有返利金都不显示这个高反和返利金按钮）
               self.letaoSalesReturnLabel.text = self.cellDataModel.xlt_order_tips.length ? self.cellDataModel.xlt_order_tips : @"" ;
                self.letaoSalesReturnLabel.hidden = NO;
                self.letaoMoneyArrivedDateLabel.hidden = YES;
            }
            
        }
            break;
        case 2:
        {
//            self.letaoOrderStateLabel.textColor = [UIColor colorWithHex:0xFF8202];
            if (self.cellDataModel.xlt_refund_status.intValue == 0) {
                self.letaoMoneyArrivedDateLabel.text = self.cellDataModel.xlt_order_tips.length ? self.cellDataModel.xlt_order_tips : @"" ;
                self.letaoSalesReturnLabel.hidden = YES;
                self.letaoMoneyArrivedDateLabel.hidden = NO;
            }else{
                //没有处于维权中会显示预返利金额和高反按钮（沒有返利金都不显示这个高反和返利金按钮）
                self.letaoSalesReturnLabel.text = self.cellDataModel.xlt_order_tips.length ? self.cellDataModel.xlt_order_tips : @"" ;
                self.letaoSalesReturnLabel.hidden = NO;
                self.letaoMoneyArrivedDateLabel.hidden = YES;
            }
        }
            break;
        case 10:
        {
            if (self.cellDataModel.xlt_refund_status.intValue == 0) {
                self.letaoMoneyArrivedDateLabel.text = self.cellDataModel.xlt_order_tips.length ? self.cellDataModel.xlt_order_tips : @"" ;
                self.letaoSalesReturnLabel.hidden = YES;
                self.letaoMoneyArrivedDateLabel.hidden = NO;
            }else{
                self.letaoSalesReturnLabel.text = self.cellDataModel.xlt_order_tips.length ? self.cellDataModel.xlt_order_tips : @"" ;
                self.letaoSalesReturnLabel.hidden = NO;
                self.letaoMoneyArrivedDateLabel.hidden = YES;
            }
//            self.letaoOrderStateLabel.textColor = [UIColor colorWithHex:0x848487];
        }
            break;
        default:
            break;
    }
    //单独的一种状态，没有返利金，优先权也是最高的不能加else不然前面的状态判断就会不对了
    if (self.cellDataModel.xlt_total_amount.intValue == 0 || !self.cellDataModel.xlt_total_amount.length) {
        self.letaoearnLabel.hidden = YES;
        self.letaoMoneyArriveLeading.constant = 0;
//        self.letaoSalesReturnLabel.hidden = YES;
//        self.letaoMoneyArrivedDateLabel.hidden = NO;
//        self.letaoMoneyArrivedDateLabel.text = self.cellDataModel.xlt_order_tips.length ? self.cellDataModel.xlt_order_tips : @"" ;
    }else{
        if (self.cellDataModel.xlt_refund_status.intValue == 1) {
            self.letaoearnLabel.hidden = YES;
            self.letaoMoneyArriveLeading.constant = 0;
        }else{
            self.letaoearnLabel.hidden = NO;
            self.letaoMoneyArriveLeading.constant = 10;
            NSString *estimatedRebateAmount = [NSString stringWithFormat:@"￥%@",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:self.cellDataModel.xlt_total_amount]];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预估返：%@",estimatedRebateAmount]];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont letaoRegularFontWithSize:12] range:NSMakeRange(0, attributedString.length)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFF25282D] range:NSMakeRange(0, attributedString.length - estimatedRebateAmount.length)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF73737] range:NSMakeRange(attributedString.length - estimatedRebateAmount.length, estimatedRebateAmount.length)];
            self.letaoearnLabel.attributedText = attributedString;
        }
        
    }
    if (!self.letaoMoneyArrivedDateLabel.hidden && self.cellDataModel.highlight.length) {
        NSString *str = self.letaoMoneyArrivedDateLabel.text;
        if (str.length) {
            NSRange range = [str rangeOfString:self.cellDataModel.highlight];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xF73737]} range:range];
            self.letaoMoneyArrivedDateLabel.text = nil;
            self.letaoMoneyArrivedDateLabel.attributedText = attr;
//
            
        }
    }
    //机器人订单
    self.jqrIcon.hidden = ![self.cellDataModel.from isEqualToString:@"wx_robot"];
    if (self.cellDataModel.activity_voucher_tips.length) {
        self.tipsLabel.text = self.cellDataModel.activity_voucher_tips;
        self.tipsLabel.hidden = NO;
    }else{
        self.tipsLabel.hidden = YES;
    }
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

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}




- (void)layoutSubviews {
    [super layoutSubviews];
}

- (IBAction)letaoShareBtnClicked:(UIButton *)btn {
     if (self.operateButtonClicked)
         self.operateButtonClicked(self.cellDataModel,self.letaoOrderCanRebate);
}
@end
