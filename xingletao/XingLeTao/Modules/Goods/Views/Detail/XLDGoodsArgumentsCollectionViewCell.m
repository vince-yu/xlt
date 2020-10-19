//
//  XLDGoodsArgumentsCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsArgumentsCollectionViewCell.h"

@implementation XLDGoodsArgumentsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)letaoUpdateCellDataWithInfo:(NSArray * )argument {
    NSDictionary *argumentInfo = argument.firstObject;
    if ([argumentInfo isKindOfClass:[NSDictionary class]]) {
        NSString *argumentText =  [argumentInfo.allKeys componentsJoinedByString:@"  "];
        self.letaoArgLabel.text = argumentText;
    } else {
         self.letaoArgLabel.text = nil;
    }
}
@end
