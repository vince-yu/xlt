//
//  XLDGoodsCouponCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsCouponCollectionViewCell.h"
#import "XLTGoodsDisplayHelp.h"
#import "UIFont+XLTFontConstant.h"
#import "NSDate+Utilities.h"
#import "XLTGoodsDisplayHelp.h"

@interface XLDGoodsCouponCollectionViewCell ()
@property (nonatomic, weak) IBOutlet UILabel *couponAmountLabel;
@property (nonatomic, weak) IBOutlet UIImageView *couponBgImageView;

@property (nonatomic, weak) IBOutlet UILabel *expiryDateLabel;
@property (nonatomic, weak) IBOutlet UIButton *fetchCouponButton;
@property (nonatomic, strong) UIView  *dashLineView;

@property (nonatomic, strong) UIImageView *juciImageView;

@property (nonatomic, strong) UIView *topSemicircleView;
@property (nonatomic, strong) UIView *bottomSemicircleView;
@end

@implementation XLDGoodsCouponCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fetchCouponButton.layer.masksToBounds = YES;
    self.fetchCouponButton.layer.cornerRadius = ceilf(self.fetchCouponButton.bounds.size.height/2);
    self.fetchCouponButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.fetchCouponButton.layer.borderWidth = 1.0;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.couponBgImageView.image = [UIImage gradientColorImageFromColors: @[[UIColor colorWithHex:0xFFFE1F68],[UIColor colorWithHex:0xFFF42727]] gradientType:1 imgSize:CGSizeMake(kScreenWidth - 20, 60)];
    self.couponBgImageView.layer.masksToBounds = YES;
    self.couponBgImageView.layer.cornerRadius = 5.0;
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.couponBgImageView.bounds.size.width - 115, 7, 0.5, self.couponBgImageView.height - 14)];
    lineView.backgroundColor = [UIColor clearColor];
    self.dashLineView = lineView;
    [self.couponBgImageView addSubview:lineView];
    [self drawLineOfDashByCAShapeLayer:lineView lineLength:4 lineSpacing:2 lineColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8] lineDirection:NO];
    
    
    UIImageView *juciImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    juciImageView.image = [UIImage imageNamed:@"juci"];
    [self.couponBgImageView addSubview:juciImageView];
    self.juciImageView =  juciImageView;
    
    
    UIView *topSemicircleView = [[UIView alloc] initWithFrame:CGRectZero];
    topSemicircleView.backgroundColor = [UIColor whiteColor];
    topSemicircleView.layer.masksToBounds = YES;
    topSemicircleView.layer.cornerRadius = 4.0;
    [self.couponBgImageView addSubview:topSemicircleView];
    self.topSemicircleView = topSemicircleView;
    
    
    UIView *bottomSemicircleView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomSemicircleView.backgroundColor = [UIColor whiteColor];
    bottomSemicircleView.layer.masksToBounds = YES;
    bottomSemicircleView.layer.cornerRadius = 4.0;
    [self.couponBgImageView addSubview:bottomSemicircleView];
    self.bottomSemicircleView = bottomSemicircleView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dashLineView.frame = CGRectMake(self.couponBgImageView.bounds.size.width - 115, 7, 0.5, self.couponBgImageView.height - 14);
    
    self.juciImageView.frame = CGRectMake(0, 3.5, 2, self.couponBgImageView.height - 7);
    
    self.topSemicircleView.frame = CGRectMake(self.couponBgImageView.bounds.size.width - 115 -4, -4, 8, 8);
    
    self.bottomSemicircleView.frame = CGRectMake(self.couponBgImageView.bounds.size.width - 115 -4, self.couponBgImageView.height - 4, 8, 8);
}

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];

    [shapeLayer setBounds:lineView.bounds];

    if (isHorizonal) {

        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];

    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }

    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {

        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);

    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }

    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}


- (void)letaoUpdateCellDataWithInfo:(id _Nullable )coupon {
    NSNumber *couponAmount = nil;
    NSNumber *couponStartTime = nil;
    NSNumber *couponEndTime = nil;
    NSString *info = nil;
    
    couponAmount = coupon[@"amount"];
    couponStartTime = [coupon[@"start_time"] isKindOfClass:[NSNumber class]] ? coupon[@"start_time"] :@0;
    couponEndTime = [coupon[@"end_time"] isKindOfClass:[NSNumber class]] ? coupon[@"end_time"] :@0;
    info = [coupon[@"info"] isKindOfClass:[NSString class]] ? coupon[@"info"] :nil;
    NSAttributedString *couponAmountAttributedString = nil;
    if (info.length > 0) {
        couponAmountAttributedString = [self letaoFormattingCouponAmount:couponAmount info:info];
    } else {
        couponAmountAttributedString = [self letaoFormattingCouponAmount:couponAmount];
    }
    self.couponAmountLabel.attributedText = couponAmountAttributedString;
    
    NSString *couponStartDate = [XLTGoodsDisplayHelp letaoNoneSecondDateStringWithDate:[NSDate dateWithTimeIntervalSince1970:[couponStartTime longLongValue]]];
    ;
    NSString *couponEndDate = [XLTGoodsDisplayHelp letaoNoneSecondDateStringWithDate:[NSDate dateWithTimeIntervalSince1970:[couponEndTime longLongValue]]];

    self.expiryDateLabel.text = [NSString stringWithFormat:@"有效期：%@ - %@",couponStartDate,couponEndDate];
}

- (NSAttributedString *)letaoFormattingCouponAmount:(NSNumber *)couponAmount {
    NSString *couponAmountText = [XLTGoodsDisplayHelp letaoFormatterIntegerYuanWithFenMoney:couponAmount];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ 优惠券",couponAmountText]];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:15]} range:NSMakeRange(0, 1)];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:19]} range:NSMakeRange(attributedString.length -4 - couponAmountText.length, couponAmountText.length)];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:15]} range:NSMakeRange(attributedString.length -4, 4)];

    return attributedString;
}


- (NSAttributedString *)letaoFormattingCouponAmount:(NSNumber *)couponAmount info:(NSString *)infoText {
    NSString *couponAmountText = [XLTGoodsDisplayHelp letaoFormatterIntegerYuanWithFenMoney:couponAmount];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ %@",couponAmountText,infoText]];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:15]} range:NSMakeRange(0, 1)];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:19]} range:NSMakeRange(attributedString.length -(infoText.length +1) - couponAmountText.length, couponAmountText.length)];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:12]} range:NSMakeRange(attributedString.length -(infoText.length +1), (infoText.length +1))];

    return attributedString;
}



- (IBAction)xingletaonetwork_requestCouponBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(letaoIsCoupon:xingletaonetwork_requestCouponBtnClicked:)]) {
        [self.delegate letaoIsCoupon:self xingletaonetwork_requestCouponBtnClicked:sender];
    }
}
@end
