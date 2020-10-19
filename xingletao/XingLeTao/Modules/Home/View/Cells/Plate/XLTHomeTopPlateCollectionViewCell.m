//
//  XLTHomeTopPlateCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomeTopPlateCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "XLTUIConstant.h"

@implementation XLTHomeTopPlateCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info {
    NSString *subjectText = nil;
    NSString *subjectPicUrlString = nil;
    if ([info isKindOfClass:[NSDictionary class]]) {
        subjectText = [info[@"title"]isKindOfClass:[NSString class]] ? info[@"title"] : nil;
        subjectPicUrlString = [info[@"icon"]isKindOfClass:[NSString class]] ? info[@"icon"] : nil;
    }
    [self.subjectImageView sd_setImageWithURL:[NSURL URLWithString:[subjectPicUrlString letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderSmallImage];
    self.subjectLabel.text = subjectText;
}


@end
