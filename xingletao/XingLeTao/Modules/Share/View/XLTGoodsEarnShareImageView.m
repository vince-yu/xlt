//
//  XLTGoodsEarnShareImageView.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsEarnShareImageView.h"
#import "XLTGoodsDisplayHelp.h"
#import "UIImageView+WebCache.h"
#import "XLTHomePageLogic.h"

@interface XLTGoodsEarnShareImageView ()
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaosourceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *letaogoodsImageView;
@property (nonatomic, weak) IBOutlet UIImageView *qrcodeImageView;
@property (nonatomic, weak) IBOutlet UILabel *letaooriginalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopricePrefixLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopriceLabel;
@property (nonatomic, weak) IBOutlet UIButton *letaocouponAmountButton;

@property (nonatomic, weak) IBOutlet UIImageView *appJDImageView;
@property (nonatomic, weak) IBOutlet UIImageView *appTBImageView;

@property (nonatomic, weak) IBOutlet UILabel *appJDLabel ;
@property (nonatomic, weak) IBOutlet UILabel *appTBLabel ;
@property (nonatomic, copy) void(^completeBlock)(BOOL success, NSMutableArray *imageArray);

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *letaosourceLabelWidth ;

@end
@implementation XLTGoodsEarnShareImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.letaogoodsImageView.layer.masksToBounds = YES;
    self.letaogoodsImageView.layer.cornerRadius = 5.0;

    self.letaosourceLabel.layer.masksToBounds = YES;
    self.letaosourceLabel.layer.cornerRadius = 9.0;
}

- (void)updateGoodsData:(id _Nullable )itemInfo    imageURLStringsGroup:(NSMutableArray *)imageURLStringsGroup
                   tkl:(NSString * _Nullable)tkl
                   jdkl:(NSString * _Nullable)jdkl
complete:(void(^)(BOOL success, NSMutableArray *imageArray))complete {
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
    NSString *item_source = nil;
    NSNumber *postageState = nil;
    NSNumber *letaoGoodsId = nil;
    
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *rebate = itemInfo[@"rebate"];
        if ([rebate isKindOfClass:[NSDictionary class]]) {
            earnAmount = rebate[@"xkd_amount"];
        }
        originalPrice = itemInfo[@"item_min_price"];
        postageState = itemInfo[@"item_delivery_postage"];
        letaoGoodsId = itemInfo[@"_id"];
        price = itemInfo[@"item_price"];
        item_source = itemInfo[@"item_source"];
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
    
    if (letaosourceLabeltring == nil) {
        self.letaosourceLabel.hidden = YES;
    } else {
        self.letaosourceLabel.hidden = NO;
        self.letaosourceLabel.text = [NSString stringWithFormat:@"%@",letaosourceLabeltring];
    }
    
    BOOL isTBSource = NO;
    if ([item_source isKindOfClass:[NSString class]]) {
        if ([item_source isEqualToString:XLTTaobaoPlatformIndicate]
            || [item_source isEqualToString:XLTTianmaoPlatformIndicate]) {
            isTBSource = YES;
        }
    }
    if (isTBSource) {
        self.appJDLabel.hidden = YES;
        self.appJDImageView.hidden = YES;
        self.appTBLabel.hidden = NO;
        self.appTBImageView.hidden = NO;
    } else {
        self.appJDLabel.hidden = NO;
        self.appJDImageView.hidden = NO;
        self.appTBLabel.hidden = YES;
        self.appTBImageView.hidden = YES;
    }
    
    if (![letaoStoreNameLabelString isKindOfClass:[NSString class]]) {
        letaoStoreNameLabelString = nil;
    }
    
    
    if (![letaoGoodsTitleLabelString isKindOfClass:[NSString class]]) {
        letaoGoodsTitleLabelString = nil;
    } else {
        NSString *spaceString = @"        ";
        CGFloat letaosourceLabelWidth = 38.0;
        NSInteger len = letaosourceLabeltring.length;
        while (len > 2) {
            spaceString = [spaceString stringByAppendingString:@"  "];
            len--;
            letaosourceLabelWidth += 10;
        }
        self.letaosourceLabelWidth.constant = letaosourceLabelWidth;
        letaoGoodsTitleLabelString = [spaceString  stringByAppendingFormat:@"%@", letaoGoodsTitleLabelString];
    }
    self.letaoGoodsTitleLabel.text = letaoGoodsTitleLabelString;

    //

    [XLTGoodsDisplayHelp letaoUpdateEarnLabel:nil earnAmount:earnAmount letaooriginalPriceLabel:self.letaooriginalPriceLabel originalPrice:originalPrice originalPricePrefixText:@"原价￥" letaopricePrefixLabel:self.letaopricePrefixLabel letaopriceLabel:self.letaopriceLabel price:price letaocouponAmountButton:self.letaocouponAmountButton couponAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];
    self.letaopricePrefixLabel.text = @"券后￥ ";
    NSString *couponAmountText = [NSString stringWithFormat:@" %@元券 ",[XLTGoodsDisplayHelp letaoFormatterIntegerYuanWithFenMoney:couponAmount]];
    [self.letaocouponAmountButton setTitle:couponAmountText forState:UIControlStateNormal];
    self.letaopriceLabel.text = [NSString stringWithFormat:@"%@  ",self.letaopriceLabel.text];
    
    self.completeBlock = complete;
    NSMutableArray *imageArray = [NSMutableArray array];

    __block NSInteger downloadTaskCount = 0;
    NSInteger taskCount = 2 + imageURLStringsGroup.count;
    if ([picUrlString isKindOfClass:[NSString class]]) {
        [self.letaogoodsImageView sd_setImageWithURL:[NSURL URLWithString:[picUrlString letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderLargeImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                downloadTaskCount ++;
                if (downloadTaskCount >= taskCount) {
                    [self completeTask:YES imageArray:imageArray];
                }
            });
        }];
    } else {
        [self.letaogoodsImageView setImage:kPlaceholderLargeImage];
        downloadTaskCount ++;
        if (downloadTaskCount >= taskCount) {
            [self completeTask:YES imageArray:imageArray];
        }
    }
    
    NSString *qrcodeUrl = nil;
    
    if (isTBSource) {
        NSString *contentUrl = [[[XLTAppPlatformManager shareManager] baseH5SeverUrl] stringByAppendingFormat:@"item/%@-%@.html?code=%@",item_source,letaoGoodsId,[self urlEncodeForStr:tkl]];
        qrcodeUrl =  [NSString stringWithFormat:@"%@qrcode?text=%@",[[XLTAppPlatformManager shareManager] baseApiSeverUrl],[NSString stringWithFormat:@"%@",[self urlEncodeForStr:contentUrl]]];

    } else {
        qrcodeUrl = [NSString stringWithFormat:@"%@qrcode?text=%@",[[XLTAppPlatformManager shareManager] baseApiSeverUrl],[NSString stringWithFormat:@"%@",[self urlEncodeForStr:jdkl]]];
    }
    
    [self.qrcodeImageView sd_setImageWithURL:[NSURL URLWithString:qrcodeUrl] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            downloadTaskCount ++;
            if (downloadTaskCount >= taskCount) {
                [self completeTask:YES imageArray:imageArray];
            }
        });
    }];
    
   
    if ([imageURLStringsGroup isKindOfClass:[NSArray class]]) {
        [imageURLStringsGroup enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *imageUrl = (NSString *)obj;
            if ([imageUrl isKindOfClass:[NSString class]]) {
                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         downloadTaskCount ++;
                        if (image && !error) {
                            [imageArray addObject:image];
                        }
                        if (downloadTaskCount >= taskCount) {
                            [self completeTask:YES imageArray:imageArray];
                        }
                    });
                }];
            } else {
                downloadTaskCount ++;
                if (downloadTaskCount >= taskCount) {
                    [self completeTask:YES imageArray:imageArray];
                }
            }

        }];
    }
    
}

- (void)completeTask:(BOOL)success imageArray:(NSMutableArray *)imageArray {
    if (self.completeBlock) {
        self.completeBlock(success,imageArray);
        self.completeBlock = nil;
    }
}


- (NSString *)urlEncodeForStr:(NSString *)str {
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    return [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}
@end
