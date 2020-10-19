//
//  XLDGoodsDetailTopMenuView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/10.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTMallGoodsDetailCustomBar.h"
#import "XLTUIConstant.h"
#import "UIColor+Helper.h"

@implementation XLTMallGoodsDetailCustomBar

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
        
        NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor colorWithHex:0xFF333333],
                               NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:18.0]
        };
        _letaoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, self.bounds.size.width, 44)];
        _letaoTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"商品详情" attributes:dict];
        _letaoTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_letaoTitleLabel];
        
        
        _letaoLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _letaoLeftButton.frame = CGRectMake(5, kStatusBarHeight, 44, 44);
        
        
        [self addSubview:_letaoLeftButton];
        
    }
    return self;
}



#define kTopOffset 44
- (void)letaoAdjustMenuStyleWithOffset:(CGPoint)offset {
    if (offset.y < kTopOffset) {
        CGFloat alpha = 1.f - offset.y / kTopOffset;
        self.alpha = alpha;
        [self.letaoLeftButton setImage:[UIImage imageNamed:@"xinletao_gooddetail_graybackground_back"] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
        self.letaoTitleLabel.alpha = 0;

    } else {
        CGFloat alpha = MIN(1.f, (offset.y - kTopOffset) / 100.f);
        self.alpha = alpha;
        self.letaoTitleLabel.alpha = alpha;
        [self.letaoLeftButton setImage:[UIImage imageNamed:@"xinletao_nav_left_back_gray"] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:alpha];
    }
}
@end
