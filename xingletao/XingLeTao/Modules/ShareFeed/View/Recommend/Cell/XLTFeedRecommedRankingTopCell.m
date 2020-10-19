//
//  XLTShareFeedTopCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTFeedRecommedRankingTopCell.h"
#import "UIImageView+WebCache.h"
#import "XLTGoodsDisplayHelp.h"
#import "XLTGoodsDisplayHelp.h"

@interface XLTFeedRecommedRankingTopCell ()
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UIImageView *faceMaskImageView;
@property (nonatomic, weak) IBOutlet UIImageView *rankingFlagImageView;


@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIButton *letaoShareBtn;
@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *letaoShareBtnRight;

@end

@implementation XLTFeedRecommedRankingTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 17;
    
    self.letaoShareBtn.layer.masksToBounds = YES;
    self.letaoShareBtn.layer.cornerRadius = 11;
    
    self.downloadButton.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    self.downloadButton.layer.borderWidth = 0.5;
    
    self.downloadButton.layer.masksToBounds = YES;
    self.downloadButton.layer.cornerRadius = 11;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info indexPath:(NSIndexPath *)indexPath {
    self.faceMaskImageView.hidden = indexPath.section > 2;
    self.rankingFlagImageView.hidden = self.faceMaskImageView.hidden;
    if (!self.rankingFlagImageView.hidden) {
        self.rankingFlagImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"feed_ranking%ld",(long)indexPath.section+1]];
    }
    [self letaoUpdateCellDataWithInfo:info];
}

- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info {
    NSString *avatar = nil;
    NSString *username = nil;
    NSNumber *start_time = nil;
    NSNumber *counts = nil;
    NSDictionary *goodBase = nil;
    
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSDictionary *userInfo = info[@"user_info"];
        if ([userInfo isKindOfClass:[NSDictionary class]]) {
            if ([userInfo[@"avatar"] isKindOfClass:[NSString class]]) {
                avatar = userInfo[@"avatar"];
            }
            if ([userInfo[@"username"] isKindOfClass:[NSString class]]) {
                username = userInfo[@"username"];
            }
        }

        
        if ([info[@"start_time"] isKindOfClass:[NSNumber class]]) {
            start_time = info[@"start_time"];
        }
        
        if ([info[@"counts"] isKindOfClass:[NSNumber class]]) {
            counts = info[@"counts"];
        } else {
            counts = @0;
        }
        goodBase = info[@"goods_info"];
    }
    
    NSArray *images = nil;
    NSArray *videos = nil;
    
    if ([info isKindOfClass:[NSDictionary class]]) {
        if ([info[@"images"] isKindOfClass:[NSArray class]]) {
            images = info[@"images"];
        }
        if ([info[@"videos"] isKindOfClass:[NSArray class]]) {
            videos = info[@"videos"];
        }
    }
    NSMutableArray *mediaArray = [NSMutableArray array];
    if (videos.count) {
        [mediaArray addObjectsFromArray:videos];
    }
    if (images.count) {
        [mediaArray addObjectsFromArray:images];
    }
    
    if (mediaArray.count > 0 || ([goodBase isKindOfClass:[NSDictionary class]] && goodBase.count > 0 && ![XLTAppPlatformManager shareManager].isLimitModel)) {
        self.downloadButton.hidden = NO;
        self.letaoShareBtn.hidden = NO;
    } else {
        self.downloadButton.hidden = YES;
        self.letaoShareBtn.hidden = YES;
    }
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"]];
    self.nameLabel.text = username;
    
    if (start_time && start_time.longLongValue > 0) {
        self.timeLabel.text = [XLTGoodsDisplayHelp letaoCommonDateStringForDate:[NSDate dateWithTimeIntervalSince1970:start_time.longLongValue]];
    } else {
        self.timeLabel.text = nil;
    }
}

- (BOOL)isCouponValidForGoodsInfo:(NSDictionary *)itemInfo {
    NSNumber *couponAmount = nil;
    NSNumber *couponStartTime = nil;
    NSNumber *couponEndTime = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *coupon = itemInfo[@"coupon"];
        if ([coupon isKindOfClass:[NSDictionary class]]) {
            couponAmount = coupon[@"amount"];
            couponStartTime = [coupon[@"start_time"] isKindOfClass:[NSNumber class]] ? coupon[@"start_time"] :@0;
            couponEndTime = [coupon[@"end_time"] isKindOfClass:[NSNumber class]] ? coupon[@"end_time"] :@0;
        }
    }
    BOOL isCouponValid = [XLTGoodsDisplayHelp letaoShouldShowCouponWithAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];
    return isCouponValid;
}


- (IBAction)shareBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cell:shareBtnClicked:)]) {
        [self.delegate cell:self shareBtnClicked:sender];
    }
}


- (IBAction)downloadBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cell:downloadBtnClicked:)]) {
        [self.delegate cell:self downloadBtnClicked:sender];
    }
}

@end
