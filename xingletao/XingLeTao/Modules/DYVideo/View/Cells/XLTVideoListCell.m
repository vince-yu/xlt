//
//  XLTVideoListCell.m
//  XingLeTao
//
//  Created by SNQU on 2020/4/27.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTVideoListCell.h"
#import "NSTimer+Block.h"

@interface XLTVideoListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *couponImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shareBgImageView;
@property (weak, nonatomic) IBOutlet UIView *saleView;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UIView *saleBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleViewWidth;
@property (weak, nonatomic) IBOutlet UIImageView *saleImageView;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) NSInteger picIndex;
@end

@implementation XLTVideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.cornerRadius = 10;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor colorWithHex:0x32303B];
    self.saleBgView.layer.cornerRadius = 12;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.clipsToBounds = YES;
    self.shareBgImageView.layer.cornerRadius = 4;
//    [self startAnimation];
//    UIImage *image = [UIImage animatedImageNamed:@"home_video_sale_" duration:0.5];
//    self.saleImageView.image = image;
    if (![self.timer isValid]) {
//        [self.timer fire];
    }
//    // 定义时钟对象
//    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
//    // 添加时钟对象到主运行循环
//    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
- (NSTimer *)timer{
    if (!_timer) {
        XLT_WeakSelf;
        _timer = [NSTimer sd_scheduledTimerWithTimeInterval:0.1 repeats:YES block:^{
            XLT_StrongSelf;
            [self step];
//            NSLog(@"-------------123");
        }];
    
    }
    return _timer;
}
//- (void)layoutSubviews{
////    if (![self.saleImageView isAnimating]) {
////        [self startAnimation];
////    }
//
//}
- (void)setListModel:(XLTVideoListModel *)listModel{
    _listModel = listModel;
//    [self overAnimation];
//    [self startAnimation];
//    NSLog(@"imagearray count is ....%ld",self.saleImageView.image.images.count);
//    NSLog(@"imagearray animation is ....%ld",self.saleImageView.isAnimating);
//    if ([self.saleImageView isAnimating]) {
//
//    }
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.listModel.first_frame] placeholderImage:[UIImage imageNamed:@"xinletao_placeholder_loading_small"]];
    self.titleLabel.text = self.listModel.item_title;
    
    if (self.listModel.goods_info && [self.listModel.goods_info isKindOfClass:[NSDictionary class]]) {
        NSNumber *nsale = [self.listModel.goods_info objectForKey:@"item_min_price"];
        NSNumber *nprice = [self.listModel.goods_info objectForKey:@"item_price"];
        NSString *sale = [[NSString stringWithFormat:@"%@",nsale] priceStr];
        NSString *price = [[NSString stringWithFormat:@"%@",nprice] priceStr];
        
        
        
        
        if (price.length && sale.length && (nsale.intValue != nprice.intValue)) {
            NSString *priceText = [NSString stringWithFormat:@"￥%@ %@",price,sale];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:priceText];
            [attr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kSDPFBoldFont size:12],NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFBB02]} range:NSMakeRange(0, 1)];
            [attr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kSDPFBoldFont size:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFBB02]} range:NSMakeRange(1, price.length)];
            [attr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kSDPFMediumFont size:11],NSForegroundColorAttributeName:[UIColor colorWithHex:0x848487]} range:NSMakeRange(price.length + 1, priceText.length - price.length - 1)];
            
            [attr addAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(price.length + 2, priceText.length - price.length - 2)];
            
            self.priceLabel.attributedText = attr;
        }else{
            NSString *content = @"--";
            if (price.length) {
                content = price;
            }
            if (sale.length) {
                content = sale;
            }
            NSString *priceText = [NSString stringWithFormat:@"￥%@",content];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:priceText];
            [attr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kSDPFBoldFont size:12],NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFBB02]} range:NSMakeRange(0, 1)];
            [attr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kSDPFBoldFont size:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFBB02]} range:NSMakeRange(1, priceText.length - 1)];
            self.priceLabel.attributedText = attr;
        }

        NSDictionary *coupon = [self.listModel.goods_info objectForKey:@"coupon"];
        if ([coupon isKindOfClass:[NSDictionary class]]) {
            NSNumber *cuponAmout = [coupon objectForKey:@"amount"];
            if (cuponAmout.intValue > 0) {
                NSString *couponStr = [NSString stringWithFormat:@"%@元券",[[NSString stringWithFormat:@"%@",cuponAmout] fenToTransyuan]];
                CGSize size = [couponStr sizeWithFont:self.couponLabel.font maxSize:CGSizeMake((kScreenWidth - 30) / 2.0, 18)];
                self.couponWidth.constant = size.width + 10;
                self.couponLabel.text = couponStr;
                
                UIImage *image = [[UIImage imageNamed:@"home_coupon_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10) resizingMode:UIImageResizingModeStretch];
                self.couponImageView.image = image;
            }
        }
        
        NSDictionary *rate = [self.listModel.goods_info objectForKey:@"rebate"];
        if ([rate isKindOfClass:[NSDictionary class]]) {
            NSNumber *rateAmount = [rate objectForKey:@"xkd_amount"];
            if (rateAmount.intValue > 0) {
                NSString *couponStr = [NSString stringWithFormat:@"分享赚 ¥ %@",[[NSString stringWithFormat:@"%@",rateAmount] priceStr]];
                CGSize size = [couponStr sizeWithFont:self.couponLabel.font maxSize:CGSizeMake((kScreenWidth - 30) / 2.0, 18)];
                self.shareLabelWidth.constant = size.width + 10;
                self.shareLabel.text = couponStr;
                
                UIImage *image = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFF9D02],[UIColor colorWithHex:0xFF6702]] gradientType:1 imgSize:CGSizeMake(size.width + 10, 18)];
                self.shareBgImageView.image = image;
            }
        }
        
        NSString *saleCount = self.listModel.item_sale.length ? self.listModel.item_sale : @"0";
        NSString *saleStr = [NSString stringWithFormat:@"%@人已买",saleCount];
        CGSize size = [saleStr sizeWithFont:self.saleLabel.font maxSize:CGSizeMake((kScreenWidth - 30) / 2.0, 22)];
        self.saleLabelWidth.constant = size.width + 2;
        self.saleViewWidth.constant = size.width + 2 + 10 + 26 + 5;
        self.saleLabel.text = saleStr;
    }
    
}
- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)startAnimation {
    // 1.1 加载所有的图片
    NSMutableArray<UIImage *> *imageArr = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        // 获取图片的名称
        NSString *imageName = [NSString stringWithFormat:@"home_video_sale_%d", i];
        // 创建UIImage对象
        UIImage *image = [UIImage imageNamed:imageName];
        // 加入数组
        [imageArr addObject:image];
    }
    // 设置动画图片
    self.saleImageView.animationImages = imageArr;

    // 设置动画的播放次数
    self.saleImageView.animationRepeatCount = 0;

    // 设置播放时长
    // 1秒30帧, 一张图片的时间 = 1/30 = 0.03333 20 * 0.0333
    self.saleImageView.animationDuration = 0.5;

    // 开始动画
    [self.saleImageView startAnimating];
}

#pragma mark - 结束动画
// - (void)overAnimation {
////    [self.saleImageView stopAnimating];
//     self.saleImageView.image = [UIImage imageNamed:@"home_video_sale_0"];
//}
//#pragma mark 每次屏幕刷新就会执行一次此方法(每秒接近60次)
-(void)step {
    NSInteger count = self.picIndex % 6;
    if (count == 0) {
        self.picIndex = 0;
    }
    self.picIndex ++;
    self.saleImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_video_sale_%ld",(long)count]];

}
@end
