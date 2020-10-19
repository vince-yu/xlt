//
//  XLDGoodsInfoPrePaidDiscountCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/23.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLDGoodsInfoPrePaidDiscountCell.h"

@interface XLDGoodsInfoPrePaidDiscountCell ()
@property (nonatomic, weak) IBOutlet UILabel *prepaidDiscountLabel;

@end
@implementation XLDGoodsInfoPrePaidDiscountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo {
    if ([self isPrepaidDiscountValid:itemInfo]) {
        self.prepaidDiscountLabel.text = [self prepaidDiscountText:itemInfo];
    } else {
        self.prepaidDiscountLabel.text = nil;
    }
}


- (BOOL)isPrepaidDateValid:(NSDictionary *)presale {
    if ([presale isKindOfClass:[NSDictionary class]] && presale.count > 0) {
        NSNumber *start_time = presale[@"tail_start_time"];
        NSNumber *end_time = presale[@"tail_end_time"];
        return ([start_time isKindOfClass:[NSNumber class]] && [start_time longLongValue] > 0
                && [end_time isKindOfClass:[NSNumber class]] && [end_time longLongValue] > 0);
    }
    return NO;
}

- (NSString * _Nullable)prepaidDiscountText:(NSDictionary *)presale  {
    if ([presale isKindOfClass:[NSDictionary class]] && presale.count > 0) {
        NSString *discount_fee_text = presale[@"discount_fee_text"];
        if([discount_fee_text isKindOfClass:[NSString class]] && [discount_fee_text length] > 0) {
            return [NSString stringWithFormat:@" %@ ",discount_fee_text];
        }
    }
    return nil;
}


- (NSString * _Nullable)prepaidDateLabelText:(NSDictionary *)presale  {
    if ([presale isKindOfClass:[NSDictionary class]] && presale.count > 0) {
        NSNumber *start_time = presale[@"tail_start_time"];
        NSNumber *end_time = presale[@"tail_end_time"];
        if ([start_time isKindOfClass:[NSNumber class]] && [start_time longLongValue] > 0
            && [end_time isKindOfClass:[NSNumber class]] && [end_time longLongValue] > 0) {
            return [self tailTextWithStartDate:[NSDate dateWithTimeIntervalSince1970:[start_time longLongValue]] endDate:[NSDate dateWithTimeIntervalSince1970:[end_time longLongValue]]];
        }
    }
    return nil;
}

- (BOOL)isPrepaidDiscountValid:(NSDictionary *)itemInfo {
    NSString *discount_fee_text = [self prepaidDiscountText:itemInfo];
    return ([discount_fee_text isKindOfClass:[NSString class]] && [discount_fee_text length] > 0);
}


- (NSString * _Nullable)tailTextWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    }
    if ([startDate isKindOfClass:[NSDate class]] && [endDate isKindOfClass:[NSDate class]]) {
        NSString *startString = [dateFormatter stringFromDate:startDate];
        NSString *endString = [dateFormatter stringFromDate:endDate];
        return [NSString stringWithFormat:@"支付尾款时间：%@~%@",startString,endString];
    }
    return nil;

}
@end
