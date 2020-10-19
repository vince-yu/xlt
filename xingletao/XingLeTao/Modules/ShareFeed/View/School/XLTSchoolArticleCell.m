//
//  XLTSchoolArticleCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/2/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTSchoolArticleCell.h"
#import "UIImageView+WebCache.h"

@interface XLTSchoolArticleCell ()
@property (nonatomic, weak) IBOutlet UIImageView *articleImageView;
@property (nonatomic, weak) IBOutlet UILabel *articleTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;

@property (nonatomic, strong) NSDictionary *articleInfo;

@end

@implementation XLTSchoolArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.shareButton.layer.masksToBounds = YES;
    self.shareButton.layer.cornerRadius = 11.0;
    
    self.articleImageView.layer.masksToBounds = YES;
    self.articleImageView.layer.cornerRadius = 5.0;
}

- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info {
    
    self.articleInfo = info;
    
    NSString *title = nil;
    NSString *cover_image = nil;
    NSNumber *itime = nil;
    NSNumber *share_wechat_open = nil;
    NSArray *tag = nil;

    if ([info isKindOfClass:[NSDictionary class]]) {
        if ([info[@"title"] isKindOfClass:[NSString class]]) {
            title = info[@"title"];
        }
        if ([info[@"cover_image"] isKindOfClass:[NSString class]]) {
            cover_image = info[@"cover_image"];
        }
        
        if ([info[@"itime"] isKindOfClass:[NSNumber class]]) {
            itime = info[@"itime"];
        }
        
        if ([info[@"share_wechat_open"] isKindOfClass:[NSNumber class]]) {
            share_wechat_open = info[@"share_wechat_open"];
        }
        
        
        if ([info[@"tag"] isKindOfClass:[NSArray class]]) {
            NSArray *tagArray = info[@"tag"];
            NSMutableArray *tagTextArray = [NSMutableArray array];
            [tagArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSString class]]) {
                    [tagTextArray addObject:[NSString stringWithFormat:@"#%@#",obj]];
                }
            }];
            tag = tagTextArray;
        } else {
            tag = @[];
        }
    }
    self.articleTitleLabel.text = title;
    [self.articleImageView sd_setImageWithURL:[NSURL URLWithString:[cover_image letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderSmallImage];

    if (itime && itime.longLongValue > 0) {
        self.dateLabel.text = [XLTGoodsDisplayHelp letaoSecondDateStringWithDate:[NSDate dateWithTimeIntervalSince1970:itime.longLongValue]];
    } else {
        self.dateLabel.text = nil;
    }
    
    
    self.descriptionLabel.text =  [tag componentsJoinedByString:@" "];
    
    
    self.shareButton.hidden = !([share_wechat_open isKindOfClass:[NSNumber class]] && [share_wechat_open integerValue] ==1);

}

- (IBAction)shareButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(articleCell:shareWithInfo:)]) {
        [self.delegate articleCell:self shareWithInfo:self.articleInfo];
    }
}

@end
