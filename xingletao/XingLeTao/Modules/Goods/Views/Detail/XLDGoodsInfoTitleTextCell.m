//
//  XLDGoodsInfoTitleTextCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsInfoTitleTextCell.h"
#import "UIColor+XLTColorConstant.h"
#import "XLTGoodsDisplayHelp.h"
#import "SDCycleScrollView.h"
#import "XLTUIConstant.h"
#import "MBProgressHUD+TipView.h"

@interface XLDGoodsInfoTitleTextCell ()

@property (nonatomic, weak) IBOutlet UILabel *letaosourceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoStoreNameLabel;

@property (nonatomic, weak) IBOutlet UILabel *letaoPaidCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;

@end

@implementation XLDGoodsInfoTitleTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.letaosourceLabel.layer.masksToBounds = YES;
    self.letaosourceLabel.layer.cornerRadius = ceilf(self.letaosourceLabel.bounds.size.height/2);
    self.letaosourceLabel.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    self.letaosourceLabel.layer.borderWidth = 1.0;

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
    NSNumber *earnAmount = nil;
    NSNumber *originalPrice = nil;
    NSNumber *price = nil;
    NSNumber *couponAmount = nil;
    NSNumber *couponStartTime = nil;
    NSNumber *couponEndTime = nil;

    
    NSString *letaosourceLabeltring = nil;
    NSString *letaoStoreNameLabelString = nil;
    NSNumber *paidNumber = nil;
    NSString *letaoGoodsTitleLabelString = nil;
    
    NSNumber *postageState = nil;

    
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *rebate = itemInfo[@"rebate"];
        if ([rebate isKindOfClass:[NSDictionary class]]) {
            earnAmount = rebate[@"xkd_amount"];
        }
        originalPrice = itemInfo[@"item_min_price"];
        postageState = itemInfo[@"item_delivery_postage"];

        price = itemInfo[@"item_price"];
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
    if ([paidNumber isKindOfClass:[NSNumber class]]
        || [paidNumber isKindOfClass:[NSString class]]) {
        self.letaoPaidCountLabel.text = [NSString stringWithFormat:@"销量 %@",[paidNumber letaoTenThousandNumberFormat]];
    } else {
        self.letaoPaidCountLabel.text = nil;
    }

    
    
    if (![letaoGoodsTitleLabelString isKindOfClass:[NSString class]]) {
        letaoGoodsTitleLabelString = nil;
    }
    self.letaoGoodsTitleLabel.text = letaoGoodsTitleLabelString;
}

- (BOOL)isLetaoHighCommissionGoods:(NSDictionary *)info {
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSNumber *hight_rebate = info[@"hight_rebate"];
        if ([hight_rebate isKindOfClass:[NSString class]] || [hight_rebate isKindOfClass:[NSNumber class]]) {
            return [hight_rebate boolValue];
        }
    }
    
    return NO;
}



- (IBAction)letaoCollectBtnClicked:(id)sender {
}


@end
