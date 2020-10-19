//
//  XLTHotOnlinenRecommendHeadView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/26.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHotOnlinenRecommendHeadView.h"

@implementation XLTHotOnlinenRecommendHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)letaoStartFilter:(id)sender {
    if ([self.delegate respondsToSelector:@selector(letaoStartFilter)]) {
        [self.delegate letaoStartFilter];
    }
   
}

@end
