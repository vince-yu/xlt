//
//  XLDGoodsDetailVideoView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/9.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsDetailVideoView.h"

@implementation XLDGoodsDetailVideoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _letaoVideoPlayBtn = [UIButton new];
        _letaoVideoPlayBtn.frame = CGRectMake(ceilf((self.bounds.size.width-60)/2), ceilf((self.bounds.size.height-60)/2), 60, 60);
        [_letaoVideoPlayBtn setImage:[UIImage imageNamed:@"xinletao_gooddetail_play"] forState:UIControlStateNormal];
        _letaoVideoPlayBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin
                 |UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_letaoVideoPlayBtn];
    }
    return self;
}
@end
