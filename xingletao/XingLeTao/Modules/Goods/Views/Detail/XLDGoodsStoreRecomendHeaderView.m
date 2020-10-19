//
//  XLDGoodsStoreRecomendHeaderView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsStoreRecomendHeaderView.h"
#import "SPButton.h"

@interface XLDGoodsStoreRecomendHeaderView ()
@property (nonatomic, weak) IBOutlet SPButton *letaoMoreBtn;

@end

@implementation XLDGoodsStoreRecomendHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.letaoMoreBtn.imagePosition = SPButtonImagePositionRight;
}

- (IBAction)letaoMoreBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(letaoGoStoreAction)]) {
        [self.delegate letaoGoStoreAction];
    }
}

@end
