//
//  XLDGoodsStoreCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsStoreCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "XLTUIConstant.h"
#import "XLTHomePageLogic.h"
#import "XLTUIConstant.h"
#import "UIColor+Helper.h"

@interface XLDGoodsStoreCollectionViewCell ()
@property (nonatomic, weak) IBOutlet UIImageView *letaoStoreImageView;

@property (nonatomic, weak) IBOutlet UILabel *letaostoreNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *letaostorePushButton;
@property (nonatomic, weak) IBOutlet UILabel *letaosourceLabel;

@property (nonatomic, weak) IBOutlet UILabel *letaodescribeLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoserviceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaologisticsLabel;


@property (nonatomic, weak) IBOutlet UIButton *letaolevel1Button;
@property (nonatomic, weak) IBOutlet UIButton *letaolevel2Button;
@property (nonatomic, weak) IBOutlet UIButton *letaolevel3Button;
@property (nonatomic, weak) IBOutlet UIButton *letaolevel4Button;
@property (nonatomic, weak) IBOutlet UIButton *letaolevel5Button;

@property (nonatomic, weak) IBOutlet UIImageView *letaoStoreFlagImageView;
@property (nonatomic, weak) IBOutlet UILabel *letaofansLabel;

@property (nonatomic, weak) IBOutlet UIView *letaoStoreFlagImageViewSpace;
@property (nonatomic, weak) IBOutlet UIView *letaoSpaceView;

@end


@implementation XLDGoodsStoreCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.letaosourceLabel.layer.masksToBounds = YES;
    self.letaosourceLabel.layer.cornerRadius = ceilf(self.letaosourceLabel.bounds.size.height/2);
    self.letaosourceLabel.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    self.letaosourceLabel.layer.borderWidth = 1.0;
    
    self.letaostorePushButton.layer.masksToBounds = YES;
    self.letaostorePushButton.layer.cornerRadius = ceilf(self.letaostorePushButton.bounds.size.height/2);
    self.letaostorePushButton.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    self.letaostorePushButton.layer.borderWidth = 1.0;
}

- (void)letaoUpdateCellDataWithInfo:(NSDictionary * )letaoStoreDictionary {
    NSString *storeImageString = letaoStoreDictionary[@"seller_shop_icon"];
    
    if ([storeImageString isKindOfClass:[NSString class]]) {
        [self.letaoStoreImageView sd_setImageWithURL:[NSURL URLWithString:[storeImageString letaoConvertToHttpsUrl]] placeholderImage:kStorePlaceholderImage];
    }
    NSString *storeNameString = letaoStoreDictionary[@"seller_shop_name"];
    if ([storeNameString isKindOfClass:[NSString class]]) {
        self.letaostoreNameLabel.text = storeNameString;
    } else {
        self.letaostoreNameLabel.text = nil;
    }
    
    NSString *storeSourceString = [self letaoSourceTextForType:letaoStoreDictionary[@"seller_type"]];
    self.letaosourceLabel.text = storeSourceString;
    self.letaosourceLabel.hidden = (storeSourceString == nil);
    
    NSArray *seller_evaluates = letaoStoreDictionary[@"seller_evaluates"];
    if (!([seller_evaluates isKindOfClass:[NSArray class]] && seller_evaluates.count > 0)) {
        seller_evaluates = [XLDGoodsStoreCollectionViewCell letaoStoreBuildSellerEvaluatesArrayWithInfo:letaoStoreDictionary];
    }
    self.letaodescribeLabel.attributedText = ([seller_evaluates isKindOfClass:[NSArray class]] && seller_evaluates.count >0) ? [XLDGoodsStoreCollectionViewCell letaoFormattingEvaluates:seller_evaluates[0]] : nil;
    self.letaoserviceLabel.attributedText = ([seller_evaluates isKindOfClass:[NSArray class]] && seller_evaluates.count >1) ? [XLDGoodsStoreCollectionViewCell letaoFormattingEvaluates:seller_evaluates[1]] : nil;
    self.letaologisticsLabel.attributedText = ([seller_evaluates isKindOfClass:[NSArray class]] && seller_evaluates.count >2) ? [XLDGoodsStoreCollectionViewCell letaoFormattingEvaluates:seller_evaluates[2]] : nil;
    
    NSString *type = letaoStoreDictionary[@"seller_type"];
    NSString *jd_self = letaoStoreDictionary[@"jd_self"];
    NSNumber *credit_level = letaoStoreDictionary[@"credit_level"];
    [self letaoUpdateCreditWithType:type jd_self:jd_self credit_level:credit_level];
    
    //
    
    NSString *seller_fans = letaoStoreDictionary[@"seller_fans"];
    if ([type isKindOfClass:[NSString class]] && [type isEqualToString:XLTPDDPlatformIndicate]) {
//        NSString *storeSaleCount= letaoStoreDictionary[@"sell_count"];
//        NSAttributedString *letaoStoreSaleCountAttributed = [self letaoStoreSaleCountAttributedForCountText:storeSaleCount];
//        NSAttributedString *fansAttributedText  = [self letaoFansAttributedForCountText:seller_fans];
//        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
//        if (letaoStoreSaleCountAttributed) {
//            [attributedText appendAttributedString:letaoStoreSaleCountAttributed];
//        }
//        if (fansAttributedText) {
//            [attributedText appendAttributedString:fansAttributedText];
//        }
        self.letaofansLabel.attributedText = nil;
    } else {
        self.letaofansLabel.attributedText = [self letaoFansAttributedForCountText:seller_fans];
    }
}

- (NSAttributedString *)letaoFansAttributedForCountText:(NSString *)count {
    if ([count isKindOfClass:[NSNumber class]]
        || [count isKindOfClass:[NSString class]]) {
        NSString *fans = nil;
        NSUInteger number = [count integerValue];
        if (number > 10000) {
            fans =  [NSString stringWithFormat:@"%0.1f万",number / 10000.0];
        } else {
            fans = [NSString stringWithFormat:@"%ld",(long)number];
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[fans stringByAppendingString:@"人关注"]];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:11]} range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]} range:NSMakeRange(0, fans.length)];

        [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]} range:NSMakeRange(fans.length, attributedString.length - fans.length)];
        return attributedString;

    }
    return nil;
}

- (NSAttributedString *)letaoStoreSaleCountAttributedForCountText:(NSString *)count {
    if (([count isKindOfClass:[NSNumber class]] || [count isKindOfClass:[NSString class]])
        && [count integerValue] > 0) {
        NSString *fans = nil;
        NSUInteger number = [count integerValue];
        if (number > 10000) {
            fans =  [NSString stringWithFormat:@"%0.1f万",number / 10000.0];
        } else {
            fans = [NSString stringWithFormat:@"%ld",(long)number];
        }

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString  stringWithFormat:@"已拼%@件   ",fans]];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:11]} range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]} range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]} range:NSMakeRange(2, fans.length)];

        return attributedString;

    }
    return nil;
}



- (NSString *)letaoSourceTextForType:(NSString *)type {
    NSString *sourceText=  [[XLTAppPlatformManager shareManager] letaoSourceTextForType:type];
    if (sourceText) {
        return [NSString stringWithFormat:@"  %@  ",sourceText];
    }
    return nil;
}

+ (NSAttributedString *)letaoFormattingEvaluates:(NSDictionary *)evaluates {
    NSString *title = @"";
    NSString *score = @"";
    NSString *type = @"";
    NSNumber *level = @1;
    if ([evaluates[@"title"] isKindOfClass:[NSString class]]) {
        title = evaluates[@"title"] ;
    }
    if ([evaluates[@"type"] isKindOfClass:[NSString class]]) {
        type = evaluates[@"type"];
    }
    if ([evaluates[@"level"] isKindOfClass:[NSNumber class]]
        || [evaluates[@"level"] isKindOfClass:[NSString class]]) {
        level = evaluates[@"level"];
    }
    
    if ([evaluates[@"score"] isKindOfClass:[NSString class]]
        || [evaluates[@"score"] isKindOfClass:[NSNumber class]]) {
        score =[NSString stringWithFormat:@"%@ %@", evaluates[@"score"],[self letaoStoreLevelDecForType:level]];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",title,score]];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:13]} range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF848487]} range:NSMakeRange(0, title.length)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[XLDGoodsStoreCollectionViewCell letaoStoreLevelColorForType:level]} range:NSMakeRange(attributedString.length - score.length, score.length)];

    
    return attributedString;
}
// score_desc_level;//-1 0 1 低中高
+ (UIColor *)letaoStoreLevelColorForType:(NSNumber *)level {
    if ([level integerValue] == -1) {
        return [UIColor colorWithHex:0xFF08B12B];
     } else if ([level integerValue] == 0) {
        return [UIColor colorWithHex:0xFF1393FF];
     } else if ([level integerValue] == 1) {
        return [UIColor letaomainColorSkinColor];
    }
    return [UIColor redColor];
}

+ (NSString *)letaoStoreLevelDecForType:(NSNumber *)level {
    if ([level integerValue] == -1) {
        return @"低";
     } else if ([level integerValue] == 0) {
        return @"中";
     } else if ([level integerValue] == 1) {
        return @"高";
    }
    return @"";
}

+ (BOOL)letaoEvaluatesValid:(NSDictionary * )letaoStoreDictionary {
    if ([letaoStoreDictionary isKindOfClass:[NSDictionary class]]) {
        NSArray *seller_evaluates = letaoStoreDictionary[@"seller_evaluates"];
        if (!([seller_evaluates isKindOfClass:[NSArray class]] && seller_evaluates.count > 0)) {
            seller_evaluates = [XLDGoodsStoreCollectionViewCell letaoStoreBuildSellerEvaluatesArrayWithInfo:letaoStoreDictionary];
        }
        NSAttributedString *describe = ([seller_evaluates isKindOfClass:[NSArray class]] && seller_evaluates.count >0) ? [self letaoFormattingEvaluates:seller_evaluates[0]] : nil;
        NSAttributedString *service = ([seller_evaluates isKindOfClass:[NSArray class]] && seller_evaluates.count >1) ? [self letaoFormattingEvaluates:seller_evaluates[1]] : nil;
        NSAttributedString *logistics = ([seller_evaluates isKindOfClass:[NSArray class]] && seller_evaluates.count >2) ? [self letaoFormattingEvaluates:seller_evaluates[2]] : nil;
        
        return (describe.length || service.length || logistics.length);
    }
    return NO;
}

+ (NSArray *)letaoStoreBuildSellerEvaluatesArrayWithInfo:(NSDictionary * )letaoStoreDictionary  {
    if (![letaoStoreDictionary isKindOfClass:[NSDictionary class]]) {
        return @[];
    }
    NSNumber *score_desc = letaoStoreDictionary[@"score_desc"];
    NSNumber *score_serv = letaoStoreDictionary[@"score_serv"];
    NSNumber *score_post = letaoStoreDictionary[@"score_post"];
    
    NSNumber *score_desc_level = letaoStoreDictionary[@"score_desc_level"];
    NSNumber *score_serv_level = letaoStoreDictionary[@"score_serv_level"];
    NSNumber *score_post_level = letaoStoreDictionary[@"score_post_level"];
    NSMutableArray *seller_evaluates = [NSMutableArray array];

    if (score_desc && score_desc_level) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"title"] = @"宝贝描述";
        dic[@"score"] = score_desc;
        dic[@"type"] = @"desc";
        dic[@"level"] = score_desc_level;
        [seller_evaluates addObject:dic];
    }
    if (score_serv && score_serv_level) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"title"] = @"卖家服务";
        dic[@"score"] = score_serv;
        dic[@"type"] = @"serv";
        dic[@"level"] = score_serv_level;
        [seller_evaluates addObject:dic];
    }
    
    if (score_post && score_post_level) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"title"] = @"物流服务";
        dic[@"score"] = score_post;
        dic[@"type"] = @"post";
        dic[@"level"] = score_post_level;
        [seller_evaluates addObject:dic];
    }
    return seller_evaluates;
}

- (IBAction)letaoGoStoreAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(letaoGoStoreAction)]) {
        [self.delegate letaoGoStoreAction];
    }
}

- (void)letaoUpdateCreditWithType:(NSString *)type jd_self:(NSString *)jd_self credit_level:(NSNumber *)credit_level {
    if ([type isKindOfClass:[NSString class]] && [type isEqualToString:XLTJindongPlatformIndicate]) {
        if ([jd_self isKindOfClass:[NSNumber class]] && [jd_self floatValue] == 0) {
            if ([credit_level isKindOfClass:[NSNumber class]] && [credit_level intValue] > 0) {
                self.letaoStoreFlagImageView.hidden = YES;
                self.letaoStoreFlagImageViewSpace.hidden = YES;
                [self letaoUpdateJDdongWithCreditLevel:[credit_level floatValue]];
            } else {
                self.letaoStoreFlagImageView.hidden = NO;
                self.letaoStoreFlagImageViewSpace.hidden = YES;
                [self letaoUpdateJDdongWithCreditLevel:0];
            }
        } else {
            self.letaoStoreFlagImageView.hidden = YES;
            self.letaoStoreFlagImageViewSpace.hidden = YES;
            [self letaoUpdateJDdongWithCreditLevel:0];
        }
    } else if ([type isKindOfClass:[NSString class]]
               && ([type isEqualToString:XLTTaobaoPlatformIndicate] || [type isEqualToString:XLTTianmaoPlatformIndicate])) {
        if ([credit_level isKindOfClass:[NSNumber class]] && [credit_level intValue] > 0) {
            [self letaoUpdateTaobaoWithCreditLevel:[credit_level integerValue]];
            self.letaoSpaceView.hidden = NO;
        } else {
            [self letaoUpdateTaobaoWithCreditLevel:0];
            self.letaoSpaceView.hidden = YES;
        }
        self.letaoStoreFlagImageView.hidden = YES;
        self.letaoStoreFlagImageViewSpace.hidden = YES;
        
    } else {
        self.letaoStoreFlagImageView.hidden = YES;
        self.letaoStoreFlagImageViewSpace.hidden = YES;
        [self letaoUpdateJDdongWithCreditLevel:0];
    }
}


- (void)letaoUpdateJDdongWithCreditLevel:(CGFloat)creditLevel {
    self.letaolevel1Button.hidden = (creditLevel == 0);
    self.letaolevel2Button.hidden = (creditLevel == 0);
    self.letaolevel3Button.hidden = (creditLevel == 0);
    self.letaolevel4Button.hidden = (creditLevel == 0);
    self.letaolevel5Button.hidden = (creditLevel == 0);
    if (creditLevel == 0)
        return;
    NSArray *levelButtonsArray = @[self.letaolevel1Button,self.letaolevel2Button,self.letaolevel3Button,self.letaolevel4Button,self.letaolevel5Button];
    NSInteger fullStarCount =  (NSInteger) floorf(creditLevel);
    BOOL halfStar = ((creditLevel - fullStarCount) >= 0.5);
    [levelButtonsArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = NO;
        if (idx < fullStarCount) {
            [obj setImage:[UIImage imageNamed:@"xinletao_jd_star_full"] forState:UIControlStateNormal];
            [obj setBackgroundImage:nil forState:UIControlStateNormal];
        } else if (idx == fullStarCount) {
            if (halfStar) {
                [obj setImage:[UIImage imageNamed:@"xinletao_jd_star_half"] forState:UIControlStateNormal];
                [obj setBackgroundImage:[UIImage imageNamed:@"xinletao_jd_star_empty"] forState:UIControlStateNormal];
            } else {
                [obj setImage:[UIImage imageNamed:@"xinletao_jd_star_empty"] forState:UIControlStateNormal];
                [obj setBackgroundImage:nil forState:UIControlStateNormal];
            }
        } else {
            [obj setImage:[UIImage imageNamed:@"xinletao_jd_star_empty"] forState:UIControlStateNormal];
            [obj setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }];
   
}


- (void)letaoUpdateTaobaoWithCreditLevel:(NSInteger)creditLevel {
    self.letaolevel1Button.hidden = (creditLevel == 0);
    self.letaolevel2Button.hidden = (creditLevel == 0);
    self.letaolevel3Button.hidden = (creditLevel == 0);
    self.letaolevel4Button.hidden = (creditLevel == 0);
    self.letaolevel5Button.hidden = (creditLevel == 0);
    if (creditLevel == 0)
    return;

    NSInteger starTypeCount = (NSInteger) ceilf(creditLevel/5.0);
    UIImage *creditLevelImage = nil;
    if (starTypeCount == 1) {
        creditLevelImage = [UIImage imageNamed:@"xinletao_tb_credit_level1"];
    } else if (starTypeCount == 2) {
        creditLevelImage = [UIImage imageNamed:@"xinletao_tb_credit_level2"];
    } else if (starTypeCount == 3) {
        creditLevelImage = [UIImage imageNamed:@"xinletao_tb_credit_level3"];
    } else if (starTypeCount == 4) {
        creditLevelImage = [UIImage imageNamed:@"xinletao_tb_credit_level4"];
    }
    NSInteger starCount = 0;
    if (creditLevel <= 5) {
        starCount = creditLevel;
    } else if (creditLevel <= 10) {
        starCount = creditLevel -5;
    } else if (creditLevel <= 15) {
        starCount = creditLevel - 10;
    } else {
        starCount = creditLevel - 15;
    }
    starCount = MAX(0, starCount);
    NSArray *levelButtonsArray = @[self.letaolevel1Button,self.letaolevel2Button,self.letaolevel3Button,self.letaolevel4Button,self.letaolevel5Button];
    [levelButtonsArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setBackgroundImage:nil forState:UIControlStateNormal];
        if (idx < starCount) {
            [obj setImage:creditLevelImage forState:UIControlStateNormal];
            obj.hidden = NO;
        } else {
            [obj setImage:nil forState:UIControlStateNormal];
            obj.hidden = YES;
        }
    }];
   
}

@end
