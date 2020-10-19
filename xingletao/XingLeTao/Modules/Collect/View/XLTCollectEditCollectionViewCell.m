//
//  XLTCollectEditCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTCollectEditCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "XLTGoodsDisplayHelp.h"
#import "UIColor+XLTColorConstant.h"
#import "XLTUIConstant.h"
#import "NSNumber+XLTTenThousandsHelp.h"

@interface XLTCollectEditCollectionViewCell ()
@property (nonatomic, weak) IBOutlet UILabel *letaoearnLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaooriginalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopricePrefixLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopriceLabel;
@property (nonatomic, weak) IBOutlet UIButton *letaocouponAmountButton;
@property (nonatomic, weak) IBOutlet UIView *letaoCouponSpace;

@property (nonatomic, weak) IBOutlet UILabel *letaosourceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoStoreNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *letaogoodsImageView;
@property (nonatomic, weak) IBOutlet UIView *invalidgoodsMaskView;

@property (nonatomic, weak) IBOutlet UILabel *letaoPaidCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;
@property (nonatomic, weak) IBOutlet UIButton *selectButton;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *letaoBgLeft;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *letaoContentLeft;

@property (nonatomic, weak) IBOutlet UIView *letaoBgView;

@property (nonatomic, weak) IBOutlet UILabel *cutPriceLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *couponBottom;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *priceBottom;

@property (nonatomic, copy) NSString *letaoCollectId;

@end
@implementation XLTCollectEditCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.letaoearnLabel.layer.masksToBounds = YES;
    self.letaoearnLabel.layer.cornerRadius = 2.0;
    self.letaoearnLabel.layer.borderColor = self.letaoearnLabel.textColor.CGColor;
    self.letaoearnLabel.layer.borderWidth = 1.0;
    
    
    self.letaosourceLabel.layer.masksToBounds = YES;
    self.letaosourceLabel.layer.cornerRadius = ceilf(self.letaosourceLabel.bounds.size.height/2);
    self.letaosourceLabel.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    self.letaosourceLabel.layer.borderWidth = 1.0;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.invalidgoodsMaskView.backgroundColor = [[UIColor letaolightGrayDisableSkinColor] colorWithAlphaComponent:0.5];
}

- (void)updateCutPrice:(NSNumber *)reduce_price {
    if ([reduce_price isKindOfClass:[NSNumber class]] && reduce_price.intValue >= 100) {
        self.cutPriceLabel.hidden = NO;
        self.cutPriceLabel.text = [NSString stringWithFormat:@" 比收藏时下降 ¥%@ ",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:reduce_price]];
        self.couponBottom.constant = 25;
        self.priceBottom.constant = 3;
    } else {
        self.cutPriceLabel.hidden = YES;
        self.couponBottom.constant = 6;
        self.priceBottom.constant = 6;
    }
}


- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo
            isSelected:(BOOL)isSelected
             startEdit:(BOOL)startEdit
          invalidgoods:(BOOL)invalidgoods {
    NSDictionary *goodsInfo = nil;
    NSString *collectId = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        goodsInfo = itemInfo[@"goods"];
        collectId = itemInfo[@"_id"];
    }
    if ([collectId isKindOfClass:[NSString class]]) {
        self.letaoCollectId = collectId;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:goodsInfo];
    if ([itemInfo objectForKey:@"reduce_price"]) {
        dic[@"reduce_price"] = [itemInfo objectForKey:@"reduce_price"];
    }
    self.invalidgoodsMaskView.hidden = invalidgoods;    
    [self updateCellGoodsData:dic isSelected:isSelected startEdit:startEdit];
}

- (void)updateCellGoodsData:(id _Nullable )itemInfo
                 isSelected:(BOOL)isSelected
                  startEdit:(BOOL)startEdit
 {
    NSNumber *earnAmount = nil;
    NSNumber *originalPrice = nil;
    NSNumber *price = nil;
    NSNumber *couponAmount = nil;
    NSNumber *couponStartTime = nil;
    NSNumber *couponEndTime = nil;
    NSString *picUrlString = nil;
    
    NSString *letaosourceLabeltring = nil;
    NSString *letaoStoreNameLabelString = nil;
    NSNumber *paidNumber = nil;
    NSString *letaoGoodsTitleLabelString = nil;
    NSNumber *reduce_price = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *rebate = itemInfo[@"rebate"];
        if ([rebate isKindOfClass:[NSDictionary class]]) {
            earnAmount = rebate[@"xkd_amount"];
        }
        originalPrice = itemInfo[@"item_min_price"];
        price = itemInfo[@"item_price"];
        reduce_price = itemInfo[@"reduce_price"];
        letaosourceLabeltring = [XLTGoodsDisplayHelp letaoSourceTextForType:itemInfo[@"item_source"]];
        paidNumber = itemInfo[@"item_sell_count"];
        letaoStoreNameLabelString = itemInfo[@"seller_shop_name"];
        letaoGoodsTitleLabelString = itemInfo[@"item_title"];
        NSDictionary *coupon = itemInfo[@"coupon"];
        if ([coupon isKindOfClass:[NSDictionary class]]) {
            couponAmount = coupon[@"amount"];
            couponStartTime = [coupon[@"start_time"] isKindOfClass:[NSNumber class]] ? coupon[@"start_time"] :@0;
            couponEndTime = [coupon[@"end_time"] isKindOfClass:[NSNumber class]] ? coupon[@"end_time"] :@0;
        }
        picUrlString = itemInfo[@"item_image"];
    }
    if ([picUrlString isKindOfClass:[NSString class]]) {
        [self.letaogoodsImageView sd_setImageWithURL:[NSURL URLWithString:[picUrlString letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderSmallImage];
    } else {
        [self.letaogoodsImageView setImage:kPlaceholderSmallImage];
    }
    
    if (letaosourceLabeltring == nil) {
        self.letaosourceLabel.hidden = YES;
    } else {
        self.letaosourceLabel.hidden = NO;
        self.letaosourceLabel.text = [NSString stringWithFormat:@"  %@  ",letaosourceLabeltring];
    }
    
    if (![letaoStoreNameLabelString isKindOfClass:[NSString class]]) {
        letaoStoreNameLabelString = nil;
    }
    self.letaoStoreNameLabel.text = letaoStoreNameLabelString;
    if ([XLTAppPlatformManager shareManager].isLimitModel) {
            self.letaoStoreNameLabel.text = nil;
       }
    if (![paidNumber isKindOfClass:[NSNumber class]]
        || [paidNumber integerValue] < 1) {
        self.letaoPaidCountLabel.text = [NSString stringWithFormat:@"%@人付款",@"0"];
    } else {
        self.letaoPaidCountLabel.text = [NSString stringWithFormat:@"%@人付款",[paidNumber letaoTenThousandNumberFormat]];
    }
    
    
    if (![letaoGoodsTitleLabelString isKindOfClass:[NSString class]]) {
        letaoGoodsTitleLabelString = nil;
    }
    self.letaoGoodsTitleLabel.text = letaoGoodsTitleLabelString;
    
    [self updateCutPrice:reduce_price];
    //
    [XLTGoodsDisplayHelp letaoUpdateEarnLabel:self.letaoearnLabel earnAmount:earnAmount letaooriginalPriceLabel:self.letaooriginalPriceLabel originalPrice:originalPrice letaopricePrefixLabel:self.letaopricePrefixLabel letaopriceLabel:self.letaopriceLabel price:price letaocouponAmountButton:self.letaocouponAmountButton couponAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];

    self.letaoearnLabel.text = [NSString stringWithFormat:@" %@ ",self.letaoearnLabel.text];
    
    self.letaopriceLabel.text = [NSString stringWithFormat:@"%@  ",self.letaopriceLabel.text];
    
    NSString *couponAmountText = [NSString stringWithFormat:@" %@元券 ",[XLTGoodsDisplayHelp letaoFormatterIntegerYuanWithFenMoney:couponAmount]];
    [self.letaocouponAmountButton setTitle:couponAmountText forState:UIControlStateNormal];
    self.letaoCouponSpace.hidden = self.letaocouponAmountButton.hidden;
     
     self.letaoIsEditState = startEdit;
     self.letaoIsCollectSelected = isSelected;
     self.selectButton.selected = isSelected;
}


- (void)setLetaoIsEditState:(BOOL)isEditState {
    _letaoIsEditState = isEditState;
    if (isEditState) {
        self.letaoBgLeft.constant = 44;
        self.letaoContentLeft.constant = 44+8;
    } else {
        self.letaoBgLeft.constant = 0;
        self.letaoContentLeft.constant = 8;
    }
}

- (IBAction)selectAction:(id)sender {
    self.letaoIsCollectSelected = !self.letaoIsCollectSelected;
    self.selectButton.selected = self.letaoIsCollectSelected;
    if ([self.delegate respondsToSelector:@selector(letaoEditCell:collectId:isCollectSelected:)]) {
        [self.delegate letaoEditCell:sender
                             collectId:self.letaoCollectId
                    isCollectSelected:self.letaoIsCollectSelected];
    }
}
@end
