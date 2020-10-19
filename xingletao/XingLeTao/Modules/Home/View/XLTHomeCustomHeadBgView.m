//
//  XLTHomeCustomHeadBgView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomeCustomHeadBgView.h"
#import "XLTUIConstant.h"
#import "UIColor+Helper.h"

@interface XLTHomeCustomHeadBgView ()



@end

@implementation XLTHomeCustomHeadBgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _letaobgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFFF6E02],[UIColor colorWithHex:0xFFFFAE01]] gradientType:0 imgSize:_letaobgImageView.bounds.size];
        _letaobgImageView.image = bgImage;
        [self addSubview:_letaobgImageView];
        
        UIImage *bottomCircleImage = [UIImage imageNamed:@"home_header_bg"];
        CGFloat bottomCircleHeight = ceilf(self.bounds.size.width/375*35);
        _letaoCircleImageView = [[UIImageView alloc] initWithImage:bottomCircleImage];
        _letaoCircleImageView.frame = CGRectMake(0, self.bounds.size.height - bottomCircleHeight, self.bounds.size.width, bottomCircleHeight);
        [self addSubview:_letaoCircleImageView];
        
        _letaoCircleImageView.hidden = ([XLTAppPlatformManager shareManager].isLimitModel);
    }
    return self;
}



@end
