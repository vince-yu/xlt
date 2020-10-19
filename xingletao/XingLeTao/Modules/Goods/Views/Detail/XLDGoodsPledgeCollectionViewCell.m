//
//  XLDGoodsPledgeCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsPledgeCollectionViewCell.h"

@implementation XLDGoodsPledgeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}


- (void)letaoUpdateCellDataWithInfo:(NSArray * )protection {
    NSMutableArray *protectionArray = [NSMutableArray new];
    [protection enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *value = obj[@"title"];
            if ([value isKindOfClass:[NSString class]]) {
                [protectionArray addObject:value];
            }
        }
    }];
    NSString *protectionText =  [protectionArray componentsJoinedByString:@" · "];
    self.letaoSafeguardLabel.text = protectionText;
}
@end
