//
//  XLTHomeHotGoodsCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTRewardListCell.h"
#import "UIImageView+WebCache.h"
#import "XLTGoodsDisplayHelp.h"
#import "UIColor+XLTColorConstant.h"
#import "XLTUIConstant.h"
#import "NSNumber+XLTTenThousandsHelp.h"
#import "NSString+XLTSourceStringHelper.h"

@interface XLTRewardListCell ()
@property (weak, nonatomic) IBOutlet UILabel *resultTime;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, weak) IBOutlet UILabel *letaosourceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *letaogoodsImageView;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rankBg;

@end
@implementation XLTRewardListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
   
    
    
    self.letaosourceLabel.layer.masksToBounds = YES;
    self.letaosourceLabel.layer.cornerRadius = ceilf(self.letaosourceLabel.bounds.size.height/2);
    self.letaosourceLabel.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    self.letaosourceLabel.layer.borderWidth = 1.0;

    self.letaogoodsImageView.layer.masksToBounds = YES;
    self.letaogoodsImageView.layer.cornerRadius = 5.0;
    self.letaogoodsImageView.clipsToBounds = YES;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xF67272],[UIColor colorWithHex:0xF73737]] gradientType:1 imgSize:CGSizeMake(90, 20)];
    self.rankBg.image = image;
//    [self.rankBg addRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(5, 5)];
    [self.letaogoodsImageView addSubview:self.rankBg];
}


- (void)letaoUpdateCellDataWithInfo:(XLTMyRewardListModel* _Nullable )itemInfo {
    _itemInfo = itemInfo;
    NSString *letaosourceLabeltring = @"";
    NSString *letaoGoodsTitleLabelString = @"";
    NSString *paidNumber = @"";
    [self.letaogoodsImageView sd_setImageWithURL:[NSURL URLWithString:[self.itemInfo.item_image letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderSmallImage];
    
       
        letaosourceLabeltring = [XLTGoodsDisplayHelp letaoSourceTextForType:self.itemInfo.item_source];
    paidNumber = self.itemInfo.order_count.length ? self.itemInfo.order_count : @"0";
    letaoGoodsTitleLabelString = self.itemInfo.item_title.length ? self.itemInfo.item_title : @"--";
    
    if (letaosourceLabeltring == nil) {
        self.letaosourceLabel.hidden = YES;
    } else {
        self.letaosourceLabel.hidden = NO;
        self.letaosourceLabel.text = [NSString stringWithFormat:@"  %@  ",letaosourceLabeltring];
    }
    
    
    
    
    if (![letaoGoodsTitleLabelString isKindOfClass:[NSString class]]) {
        letaoGoodsTitleLabelString = nil;
    } else {
        NSString *spaceString = @"        ";
        NSInteger len = letaosourceLabeltring.length;
        while (len > 2) {
            spaceString = [spaceString stringByAppendingString:@"  "];
            len--;
        }
        letaoGoodsTitleLabelString = [spaceString  stringByAppendingFormat:@"%@", letaoGoodsTitleLabelString];
    }
    self.letaoGoodsTitleLabel.text = letaoGoodsTitleLabelString;
    self.countLabel.text = [NSString stringWithFormat:@"下单量: %@",paidNumber];
    if (self.itemInfo.status.intValue == 1 || self.itemInfo.status.intValue == 4 || self.itemInfo.status.intValue == 3) {
        if (self.itemInfo.settle_type.intValue == 1) {
            NSMutableAttributedString *pattr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预估: %@",self.itemInfo.reward_amount.length ? [self.itemInfo.reward_amount priceStr]: @"0.00"]];
            [pattr addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:12],NSForegroundColorAttributeName:[UIColor colorWithHex:0x26282E]} range:NSMakeRange(0, 3)];
            [pattr addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0xF34264]} range:NSMakeRange(3, pattr.length - 3)];
            self.priceLabel.attributedText = pattr;
        }else{
            NSMutableAttributedString *pattr = [[NSMutableAttributedString alloc] initWithString:@"预估:—"];
            [pattr addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:12],NSForegroundColorAttributeName:[UIColor colorWithHex:0x26282E]} range:NSMakeRange(0, 3)];
            [pattr addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0xF34264]} range:NSMakeRange(3, 1)];
            self.priceLabel.attributedText = pattr;
        }
        
    }else{
        NSMutableAttributedString *pattr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"获得: %@",self.itemInfo.reward_amount.length ? [self.itemInfo.reward_amount priceStr]: @"0.00"]];
        [pattr addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:12],NSForegroundColorAttributeName:[UIColor colorWithHex:0x26282E]} range:NSMakeRange(0, 3)];
        [pattr addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0xF34264]} range:NSMakeRange(3, pattr.length - 3)];
        self.priceLabel.attributedText = pattr;
    }
    
    self.creatTimeLabel.text = self.itemInfo.recm_itime.length ? [NSString stringWithFormat:@"推荐时间: %@",[self.itemInfo.recm_itime convertDateStringWithSecondTimeStr:@"yyyy.MM.dd hh:mm"] ] : @"推荐时间: --";
    NSInteger rank = self.itemInfo.rank.intValue;
    if (rank > 0 && rank <= 100) {
        self.rankLabel.text = [NSString stringWithFormat:@"商品排名:%@",self.itemInfo.rank];
    }else{
        self.rankLabel.text = @"商品排名:100+";
    }
    
    
    switch (self.itemInfo.status.intValue) {
        case 1:
        {
            self.statusLabel.text = @"待结算";
            self.statusLabel.textColor = [UIColor colorWithHex:0xFF8202];
            self.resultTime.text = self.itemInfo.set_time.length ? [NSString stringWithFormat:@"待结算时间: %@",[self.itemInfo.set_time convertDateStringWithSecondTimeStr:@"yyyy.MM.dd hh:mm"] ] : @"待结算时间: --";
            self.resultTime.textColor = [UIColor colorWithHex:0x26282E];
            self.resultTime.hidden = NO;
        }
        break;
        case 2:
        {
            self.statusLabel.text = @"已结算";
            self.statusLabel.textColor = [UIColor colorWithHex:0x848488];
            self.resultTime.text = self.itemInfo.set_time.length ? [NSString stringWithFormat:@"结算时间: %@",[self.itemInfo.set_time convertDateStringWithSecondTimeStr:@"yyyy.MM.dd hh:mm"]  ] : @"结算时间: --";
            self.resultTime.textColor = [UIColor colorWithHex:0x848488];
            self.resultTime.hidden = NO;
        }
        break;
        
        case 3:
        {
            self.statusLabel.text = @"已失效";
            self.statusLabel.textColor = [UIColor colorWithHex:0x848488];
            self.resultTime.text = self.itemInfo.set_time.length ? [NSString stringWithFormat:@"结算时间: %@",[self.itemInfo.set_time convertDateStringWithSecondTimeStr:@"yyyy.MM.dd hh:mm"] ] : @"结算时间: --";
            self.resultTime.textColor = [UIColor colorWithHex:0x848488];
            self.resultTime.hidden = YES;
        }
        break;
        case 4:
        {
            self.statusLabel.text = @"待结算";
            self.statusLabel.textColor = [UIColor colorWithHex:0xFF8202];
            self.resultTime.text = self.itemInfo.set_time.length ? [NSString stringWithFormat:@"待结算时间: %@",[self.itemInfo.set_time convertDateStringWithSecondTimeStr:@"yyyy.MM.dd hh:mm"] ] : @"待结算时间: --";
            self.resultTime.textColor = [UIColor colorWithHex:0x26282E];
            self.resultTime.hidden = NO;
        }
        default:
            
            break;
    }
}

@end
