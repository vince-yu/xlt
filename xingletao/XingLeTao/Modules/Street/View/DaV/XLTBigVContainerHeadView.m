//
//  XLTBigVContainerHeadView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/27.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBigVContainerHeadView.h"


@interface XLTBigVContainerHeadView ()

@property (nonatomic, weak) IBOutlet UIImageView *dvPhotoImageView;
@property (nonatomic, weak) IBOutlet UIImageView *dvSourceImageView;
@property (nonatomic, weak) IBOutlet UILabel *dvNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dvScoureLabel;
@end

@implementation XLTBigVContainerHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

    self.dvPhotoImageView.layer.masksToBounds = YES;
    self.dvPhotoImageView.layer.cornerRadius = 38;
    self.dvPhotoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.dvPhotoImageView.layer.borderWidth = 2.0;

}

- (void)updateDaVData:(id _Nullable )itemInfo {
    
    NSString *name = nil;
    NSString *avatar = nil;
    NSNumber *source = nil;
    NSString *source_text = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        name = [itemInfo[@"name"] isKindOfClass:[NSString class]] ? itemInfo[@"name"] : nil;
        avatar = [itemInfo[@"avatar"] isKindOfClass:[NSString class]] ? itemInfo[@"avatar"] : nil;
        source = [itemInfo[@"source"] isKindOfClass:[NSNumber class]] ? itemInfo[@"source"] : nil;
        source_text = [itemInfo[@"source_text"] isKindOfClass:[NSString class]] ? [NSString stringWithFormat:@"%@知名博主",itemInfo[@"source_text"]] : nil;
    }
    self.dvNameLabel.text = name;
    [self.dvPhotoImageView sd_setImageWithURL:[NSURL URLWithString:avatar]];
    self.dvScoureLabel.text = source_text;
    UIImage *sourceImage = nil;
    if ([source intValue] ==1) {
        // 新浪
        sourceImage = [UIImage imageNamed:@"xinletao_dv_weibo_icon"];
    } else if ([source intValue] ==2) {
        // 小红书
        sourceImage = [UIImage imageNamed:@"xinletao_dv_xiaohongshu_icon"];
    } else {
        sourceImage = [UIImage imageNamed:@"xinletao_dv_tengxun_icon"];
    }
    self.dvSourceImageView.image = sourceImage;
}

@end
