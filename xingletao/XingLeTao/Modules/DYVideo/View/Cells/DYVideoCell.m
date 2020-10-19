//
//  DYVideoCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/4/26.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "DYVideoCell.h"
#import "SJVideoPlayer.h"
#import <KTVHTTPCache/KTVHTTPCache.h>
#import "DYVideoManager.h"
#import "SJProgressSlider.h"
#import "UIImage+UIColor.h"
#import "NSString+Size.h"
#import "UIImage+UIColor.h"

@interface DYVideoCell ()

@property (nonatomic, strong) NSDictionary *letaoInfo;
@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) NSURL *assetURL;
@property (nonatomic, weak) IBOutlet UIButton *playButton;

@property (nonatomic, weak) IBOutlet UIView *maskVIew;

@property (nonatomic, weak) IBOutlet UILabel *videoTitleLabel;

@property (nonatomic, weak) IBOutlet UIImageView *letaogoodsImageView;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;
@property (nonatomic, weak) IBOutlet UIButton *shareEarnLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopriceLabel;
@property (nonatomic, weak) IBOutlet UIButton *letaocouponAmountButton;
@property (nonatomic, weak) IBOutlet UIButton *goodsBuyButton;


@property (nonatomic, weak) IBOutlet UIImageView *topGradImageView;
@property (nonatomic, weak) IBOutlet UIImageView *bottomGradImageView;;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topGradImageHieght;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomGradImageHieght;
@end

@implementation DYVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        CGFloat safeAreaInsetsBottom = keyWindow.safeAreaInsets.bottom;
        CGFloat safeAreaInsetsTop = keyWindow.safeAreaInsets.top;
        self.topGradImageHieght.constant = 119  + safeAreaInsetsTop;
        self.bottomGradImageHieght.constant = 110  + safeAreaInsetsBottom;
    } else {
        // Fallback on earlier versions
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateDataInfo:(NSDictionary *)info atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    self.letaoInfo = info;
    
    NSDictionary *goods_info = info[@"goods_info"];
    
    [self letaoUpdateGoodsDataWithInfo:goods_info];
    
    NSString *dy_video_title =  [NSString stringWithFormat:@"%@",info[@"dy_video_title"]];
    self.videoTitleLabel.text = dy_video_title;
    
    NSString *url =  info[@"dy_video_url"];
    NSURL *assetURL = [NSURL URLWithString:url];
    if (url) {
        [self updateNewAssetURL:assetURL];
        if (!_player) {
            _player = [SJVideoPlayer player];
            _player.gestureControl.supportedGestureTypes =  SJPlayerGestureTypeMask_None;
            _player.defaultEdgeControlLayer.hiddenBackButtonWhenOrientationIsPortrait = YES;
            _player.resumePlaybackWhenAppDidEnterForeground = YES;
            _player.resumePlaybackWhenPlayerHasFinishedSeeking = YES;
            _player.disableBrightnessSetting = YES;
            _player.disableVolumeSetting = YES;
            
            __weak typeof(self) _self = self;
            _player.playbackObserver.playbackStatusDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
                __strong typeof(_self) self = _self;
                if ( !self ) return;
                if (player.assetStatus == SJAssetStatusReadyToPlay) {
                    [self playerAssetStatusReadyToPlay];
                }
            };
            
            _player.playbackObserver.playbackDidFinishExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
                __strong typeof(_self) self = _self;
                if ( !self ) return;
                [self playerAssetStatusDidFinish];
            };

            /*
            _player.gestureControl.singleTapHandler = ^(id<SJPlayerGestureControl>  _Nonnull control, CGPoint location) {
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
                [self gestureControlSingleTapHandler];
            };*/
            

            
            _player.view.frame = self.contentView.bounds;
            [self.contentView insertSubview:_player.view belowSubview:self.topGradImageView];
        }
        _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:self.assetURL];
        self.playButton.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _player.view.frame = self.contentView.bounds;
}

- (void)updateNewAssetURL:(NSURL *)assetURL {
    // 如果有缓存，直接取本地缓存
    NSURL *url = [KTVHTTPCache cacheCompleteFileURLWithURL:assetURL];
    NSString *suffix = [url pathExtension];
    if (url && [[DYVideoManager shareManager] isPlayableSuffix:suffix]) {
        _assetURL = url;
    } else {
        // 设置代理
        _assetURL = [KTVHTTPCache proxyURLWithOriginalURL:assetURL];
    }
}

- (void)tryReplay {
    [_player replay];
}

- (void)gestureControlSingleTapHandler {
    if (_player.timeControlStatus != SJPlaybackTimeControlStatusPaused) {
        [_player pause];
        [self.contentView bringSubviewToFront:self.playButton];
        self.playButton.hidden = NO;
        _player.resumePlaybackWhenAppDidEnterForeground = NO;
    } else {
        [_player play];
        self.playButton.hidden = YES;
        _player.resumePlaybackWhenAppDidEnterForeground = YES;
    }
}


- (void)tryPlayWhenViewWillAppear {
    if (self.playButton.hidden) {
        [_player play];
        self.playButton.hidden = YES;
        _player.resumePlaybackWhenAppDidEnterForeground = YES;
    } else {
        // 用户暂停了 do noting
    }
}


- (void)tryPauseWhenViewWillDisappear {
    [_player pause];
    _player.resumePlaybackWhenAppDidEnterForeground = NO;
}


- (IBAction)playButtonAction {
    [_player play];
    self.playButton.hidden = YES;
    _player.resumePlaybackWhenAppDidEnterForeground = YES;
}

- (void)stopPlay {
    [_player rotate:SJOrientation_Portrait animated:NO];
    [_player stop];
    _player = nil;
}

- (void)playerAssetStatusReadyToPlay {
    if ([self.delegate respondsToSelector:@selector(cell:playerAssetStatusReadyToPlayInfo:)]) {
        [self.delegate cell:self playerAssetStatusReadyToPlayInfo:self.letaoInfo];
    }
}

- (void)playerAssetStatusDidFinish {
    if ([self.delegate respondsToSelector:@selector(cell:playerAssetStatusDidFinishInfo:)]) {
        [self.delegate cell:self playerAssetStatusDidFinishInfo:self.letaoInfo];
    }
}



- (void)letaoUpdateGoodsDataWithInfo:(id _Nullable )itemInfo {
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
    
    NSNumber *status = nil;

    
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *rebate = itemInfo[@"rebate"];
        if ([rebate isKindOfClass:[NSDictionary class]]) {
            earnAmount = rebate[@"xkd_amount"];
        }
        originalPrice = itemInfo[@"item_min_price"];
        status = itemInfo[@"status"];

        price = itemInfo[@"item_price"];
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
    if ([picUrlString isKindOfClass:[NSString class]]) {
        [self.letaogoodsImageView sd_setImageWithURL:[NSURL URLWithString:[picUrlString letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderSmallImage];
    } else {
        [self.letaogoodsImageView setImage:kPlaceholderSmallImage];
    }

    
    if (![letaoGoodsTitleLabelString isKindOfClass:[NSString class]]) {
        letaoGoodsTitleLabelString = nil;
    }
    self.letaoGoodsTitleLabel.text = letaoGoodsTitleLabelString;
    
    BOOL isCouponValid = [XLTGoodsDisplayHelp letaoShouldShowCouponWithAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];

    
    NSString *couponAmountText = [NSString stringWithFormat:@"  %@元券  ",[XLTGoodsDisplayHelp letaoFormatterIntegerYuanWithFenMoney:couponAmount]];
    [self.letaocouponAmountButton setTitle:couponAmountText forState:UIControlStateNormal];
    self.letaocouponAmountButton.hidden = !isCouponValid;
    
    self.letaopriceLabel.attributedText = [self formattingPriceAmountt:price];
    
    
    NSString *earnAmountText = [NSString stringWithFormat:@"  分享赚￥%@  ",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:earnAmount]];
    CGSize textMaxSize = CGSizeMake(kScreenWidth, MAXFLOAT);
    NSDictionary *textAttrs = @{NSFontAttributeName : [UIFont letaoRegularFontWithSize:10]};
    CGFloat textWidtht = [earnAmountText boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttrs context:nil].size.width;
   
    UIImage *bgImage = [UIImage gradientColorImageFromColors: @[[UIColor colorWithHex:0xFFFF9D02],[UIColor colorWithHex:0xFFFF6702]] gradientType:1 imgSize:CGSizeMake(textWidtht, 13)];
    [self.shareEarnLabel setBackgroundImage:bgImage forState:UIControlStateNormal];
    [self.shareEarnLabel setTitle:earnAmountText forState:UIControlStateNormal];

}


- (NSMutableAttributedString *)formattingPriceAmountt:(NSNumber *)earnAmount {
    if ([earnAmount isKindOfClass:[NSNumber class]] && earnAmount.intValue > 0) {
        NSString *amountText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:earnAmount];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",amountText]];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:10],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, 1)];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(attributedString.length -amountText.length-1, amountText.length+1)];

        return attributedString;
    } else {
        return nil;
    }

}

- (NSMutableAttributedString *)formattingEarnAmountt:(NSNumber *)earnAmount {
    BOOL canshow = [XLTAppPlatformManager shareManager].checkEnable;
    if (canshow
        && [earnAmount isKindOfClass:[NSNumber class]] && earnAmount.intValue > 0) {
        NSString *amountText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:earnAmount];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"分享赚￥%@",amountText]];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:12],NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]} range:NSMakeRange(0, 3)];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFF34264]} range:NSMakeRange(attributedString.length -amountText.length-1, amountText.length+1)];

        return attributedString;
    } else {
        return nil;
    }
}

- (IBAction)buyButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cell:buyButtonAction:)]) {
        [self.delegate cell:self buyButtonAction:sender];
    }
}

- (IBAction)backButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cell:backButtonAction:)]) {
        [self.delegate cell:self backButtonAction:sender];
    }
}


- (IBAction)textButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cell:textButtonAction:)]) {
        [self.delegate cell:self textButtonAction:sender];
    }
}


- (IBAction)shareButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cell:shareButtonAction:)]) {
        [self.delegate cell:self shareButtonAction:sender];
    }
}
@end
