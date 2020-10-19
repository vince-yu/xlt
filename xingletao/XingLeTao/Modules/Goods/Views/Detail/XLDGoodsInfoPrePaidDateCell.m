//
//  XLDGoodsInfoPrePaidDateCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/23.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLDGoodsInfoPrePaidDateCell.h"
@interface XLDGoodsInfoPrePaidDateCell ()
@property (nonatomic, weak) IBOutlet UILabel *prepaidDateLabel;

@end
@implementation XLDGoodsInfoPrePaidDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo {
    if ([self isPrepaidDateValid:itemInfo]) {
        self.prepaidDateLabel.text = [self prepaidDateLabelText:itemInfo];
    } else {
        self.prepaidDateLabel.text = nil;
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
    // 定金预售
    if ([presale isKindOfClass:[NSDictionary class]] && presale.count > 0) {
        NSString *discount_fee_text = presale[@"discount_fee_text"];
        if([discount_fee_text isKindOfClass:[NSString class]] && [discount_fee_text length] > 0) {
            return [NSString stringWithFormat:@" %@ ",discount_fee_text];
        }
    }
    return nil;
}


- (NSString * _Nullable)prepaidDateLabelText:(NSDictionary *)presale  {
    // 定金预售
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
