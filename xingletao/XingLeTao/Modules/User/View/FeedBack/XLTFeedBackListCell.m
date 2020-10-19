//
//  XLTFeedBackListCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedBackListCell.h"

@interface XLTFeedBackListCell ()
@property (nonatomic, weak) IBOutlet UILabel *feedTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *feedDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *replyLabel;
@property (nonatomic, weak) IBOutlet UIView *replyFlagView;
@end

@implementation XLTFeedBackListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor letaolightgreyBgSkinColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 7.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateDataInfo:(NSDictionary *)info {
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSString *content = [NSString stringWithFormat:@"%@",info[@"content"]];
        self.feedTitleLabel.text = nil;
        self.feedTitleLabel.attributedText  = [self formattContent:content preText:@"问题和建议："];
        NSTimeInterval itime = [[NSString stringWithFormat:@"%@",info[@"itime"]] longLongValue];
        NSNumber *view_time  = info[@"view_time"];
        BOOL isRead = ([view_time isKindOfClass:[NSNumber class]] && [view_time longLongValue] > 0);
        NSNumber *status = info[@"status"];
        BOOL replyed = [status isKindOfClass:[NSNumber class]] && [status integerValue] == 2;
        if (replyed) {
            self.replyLabel.textColor = [UIColor colorWithHex:0xFF22B66E];
            self.replyLabel.text = @"已回复";
        } else {
            self.replyLabel.textColor = [UIColor colorWithHex:0xFF25282D];
            self.replyLabel.text = @"待回复";
        }
        self.replyFlagView.hidden = isRead || !replyed;

        self.feedDateLabel.text = nil;
        if (itime > 0) {
            NSString *dateText = [self feedDateFormatWithDate:[NSDate dateWithTimeIntervalSince1970:itime]];
            self.feedDateLabel.attributedText  = [self formattContent:dateText preText:@"提交时间："];
        } else {
            self.feedDateLabel.attributedText = nil;
        }
    }
}

- (NSAttributedString *)formattContent:(NSString *)content preText:(NSString *)preText {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[preText stringByAppendingString:content]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFF25282D] range:NSMakeRange(0, preText.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFF9FA0A0] range:NSMakeRange(preText.length, content.length)];
    return attributedString;;

}

- (NSString *)feedDateFormatWithDate:(NSDate *)date {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    }
    if ([date isKindOfClass:[NSDate class]]) {
        NSString *dateString = [dateFormatter stringFromDate:date];
        return dateString;
    }
    return @"";

}

@end
