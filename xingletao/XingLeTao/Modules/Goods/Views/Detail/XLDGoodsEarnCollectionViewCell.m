//
//  XLDGoodsEarnCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsEarnCollectionViewCell.h"
#import "XLTGoodsDisplayHelp.h"
#import "UIFont+XLTFontConstant.h"
#import "XLTUIConstant.h"
#import "UIColor+Helper.h"
#import "XLTGoodsDisplayHelp.h"





@implementation XLDGoodsEarnQuestionButton
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect rectBig = CGRectMake(self.bounds.origin.x-10, self.bounds.origin.y-10, self.bounds.size.width+20, self.bounds.size.height+20);
    return CGRectContainsPoint(rectBig, point);
}
@end

@interface XLDGoodsEarnCollectionViewCell ()
@property (nonatomic, weak) IBOutlet UILabel *letaoearnLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoDoubleLabel;
@property (nonatomic, weak) IBOutlet XLDGoodsEarnQuestionButton *questionButton;
@property (nonatomic, weak) IBOutlet UIButton *fanliButton;

@end
@implementation XLDGoodsEarnCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)letaoUpdateCellDataWithInfo:(id _Nullable )earnAmounInfo {    
    NSNumber *earnAmount = earnAmounInfo[@"xkd_amount"];
    NSString *item_source = earnAmounInfo[@"item_source"];
    NSMutableAttributedString *earnAmountText = [self letaoFormattingEarnAmountt:earnAmount];
    NSNumber *jd_self = earnAmounInfo[@"jd_self"];
    NSNumber *jd_plus = earnAmounInfo[@"jd_plus"];
    if ([jd_self isKindOfClass:[NSNumber class]] && jd_self.boolValue) {
        NSString *plus = nil;
        if (![jd_plus isKindOfClass:[NSNumber class]]) {
            plus = @"  (Plus会员返利金低于此)";
        } else {
            plus = [NSString stringWithFormat:@"  (Plus￥%@)",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:jd_plus]];
        }

        NSAttributedString *plusAttributedString  = [[NSAttributedString alloc] initWithString:plus attributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:11.0],NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]}];
        [earnAmountText appendAttributedString:plusAttributedString];
    } else if ([item_source isKindOfClass:[NSString class]] && [item_source isEqualToString:XLTPDDPlatformIndicate]){
        NSAttributedString *pddAttributedString  = [[NSAttributedString alloc] initWithString:@"  (不拼单返利将高于此)" attributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:11.0],NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]}];
        [earnAmountText appendAttributedString:pddAttributedString];
    }
    self.letaoearnLabel.attributedText = earnAmountText;
    NSNumber *doubleEarnAmount = earnAmounInfo[@"double_rebate"];
    if (doubleEarnAmount != nil) {
        self.letaoDoubleLabel.hidden = NO;
        NSAttributedString *doubleEarnAmountText = [self letaoFormattingDoubleEarnAmountt:doubleEarnAmount];
        self.letaoDoubleLabel.attributedText = doubleEarnAmountText;
    } else {
        self.letaoDoubleLabel.hidden = YES;
    }
}

- (void)adjustStyleForisLetaoHighCommission:(BOOL)letaoHighCommission {
    UIImage *image = [[UIImage imageNamed:@"gooddetail_earn_bg"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIColor *bgColor = nil;
    if (letaoHighCommission) {
        bgColor = [UIColor colorWithHex:0xFF7046E0];
        [self.fanliButton setTitle:@"下单高返约 " forState:UIControlStateNormal];
    } else {
        bgColor = [UIColor letaomainColorSkinColor];
        [self.fanliButton setTitle:@"下单返利约 " forState:UIControlStateNormal];
    }
    self.fanliButton.tintColor = bgColor;
    [self.fanliButton setBackgroundImage:image forState:UIControlStateNormal];
}


- (NSMutableAttributedString *)letaoFormattingEarnAmountt:(NSNumber *)earnAmount {
    NSString *amountText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:earnAmount];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",amountText]];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:15]} range:NSMakeRange(0, 1)];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:19]} range:NSMakeRange(attributedString.length -amountText.length, amountText.length)];

    return attributedString;
}

- (NSAttributedString *)letaoFormattingDoubleEarnAmountt:(NSNumber *)earnAmount {
    NSString *amountText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:earnAmount];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"购买成功分享该商品，领取双份返利金额:￥%@",amountText]];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:13]} range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]} range:NSMakeRange(0, attributedString.length -amountText.length -1)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]} range:NSMakeRange(attributedString.length -amountText.length -1, amountText.length +1)];


    return attributedString;
}


- (IBAction)letaoQuestionButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(letaoIsQuestionButtonClicked)]) {
        [self.delegate letaoIsQuestionButtonClicked];
    }

}

@end
