//
//  XLDGoodsInfoMemberUpgradeCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/1/4.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLDGoodsInfoMemberUpgradeCell.h"
#import "UIImage+UIColor.h"
#import "XLTGoodsDisplayHelp.h"
#import "UIImage+WebP.h"
@interface XLDGoodsInfoMemberUpgradeCell ()
@property (nonatomic, weak) IBOutlet UIImageView *diamondImageView;
@property (nonatomic, weak) IBOutlet UIButton *memberUpgradeButton;
@property (nonatomic, weak) IBOutlet UILabel *memberUpgradeLabel;

@end

@implementation XLDGoodsInfoMemberUpgradeCell

- (void)awakeFromNib {
    [super awakeFromNib]; 
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];

}

- (IBAction)upgradeBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(memberUpgradeCell:upgradeBtnClicked:)]) {
        [self.delegate memberUpgradeCell:sender upgradeBtnClicked:sender];
    }
}

- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)itemInfo {
    NSString *level_txt = nil;
    NSNumber *xkd_amount = nil;
    // level:4黑色 其他金色
    NSNumber *level = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        if ([itemInfo[@"level_txt"] isKindOfClass:[NSString class]]) {
            level_txt = itemInfo[@"level_txt"];
        }
        
        if ([itemInfo[@"level"] isKindOfClass:[NSNumber class]]) {
            level = itemInfo[@"level"];
        }
        NSDictionary *rebate = itemInfo[@"rebate"];
        if ([rebate isKindOfClass:[NSDictionary class]]) {
            if ([rebate[@"xkd_amount"] isKindOfClass:[NSNumber class]]) {
                xkd_amount = rebate[@"xkd_amount"];
            }
        }
    }

    UIImage *gradientImage = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFF312F2B],[UIColor blackColor]] gradientType:1 imgSize:CGSizeMake(kScreenWidth - 20, 28)];
    [self.memberUpgradeButton setBackgroundImage:gradientImage forState:UIControlStateNormal];
    NSString *amount = [NSString stringWithFormat:@"￥%@",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:xkd_amount]];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"成为运营总监, 下单最高可返利%@",amount]];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFE07100],
                                      NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:13.0]
    } range:NSMakeRange(0, attributedString.length)];
    
    NSRange amountRange = [attributedString.string rangeOfString:amount];
    if (amountRange.length) {
        [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFF34264],
                                          NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:13.0]
        } range:amountRange];
    }
    self.memberUpgradeLabel.attributedText = attributedString;
    
    NSString *file =  [[NSBundle mainBundle] pathForResource:@"member_diamond" ofType:@"webp"];
    UIImage *diamondImage = [UIImage sd_imageWithWebPData:[NSData dataWithContentsOfFile:file]];
    self.diamondImageView.image = diamondImage;
}



@end
