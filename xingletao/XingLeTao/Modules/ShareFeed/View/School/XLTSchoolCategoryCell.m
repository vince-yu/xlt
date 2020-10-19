//
//  XLTHomeSubjectCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTSchoolCategoryCell.h"
#import "UIImageView+WebCache.h"
#import "XLTUIConstant.h"

@interface XLTSchoolCategoryCell ()
@property (nonatomic, weak) IBOutlet UIImageView *subjectImageView;
@property (nonatomic, weak) IBOutlet UILabel *subjectLabel;
@end

@implementation XLTSchoolCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.subjectImageView.layer.masksToBounds = YES;
    self.subjectImageView.layer.cornerRadius = ceilf(self.subjectImageView.bounds.size.width/2);
}

- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info {
    NSString *subjectText = nil;
    NSString *subjectPicUrlString = nil;
    if ([info isKindOfClass:[NSDictionary class]]) {
        subjectText = [info[@"name"]isKindOfClass:[NSString class]] ? info[@"name"] : nil;
        subjectPicUrlString = [info[@"ico_url"]isKindOfClass:[NSString class]] ? info[@"ico_url"] : nil;
    }
    [self.subjectImageView sd_setImageWithURL:[NSURL URLWithString:[subjectPicUrlString letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderSmallImage];
    self.subjectLabel.text = subjectText;
}

@end
