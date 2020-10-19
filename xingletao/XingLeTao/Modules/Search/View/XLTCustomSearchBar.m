//
//  XLTCustomSearchBar.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTCustomSearchBar.h"
#import "UIColor+Helper.h"
#import "XLTUIConstant.h"

@implementation XLTCustomSearchBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancleButton setTitleColor:[UIColor colorWithHex:0xFF25282D] forState:UIControlStateNormal];
        [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        cancleButton.titleLabel.font = [UIFont letaoRegularFontWithSize:13];
        cancleButton.frame = CGRectMake(self.bounds.size.width -44 - 5, kStatusBarHeight, 44, 44);
        self.letaoCancelBtn = cancleButton;
        [self addSubview:cancleButton];
        
        UITextField *letaoSearchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, cancleButton.frame.origin.y +7, cancleButton.frame.origin.x - 10 , 30)];
        self.letaoSearchTextFiled = letaoSearchTextFiled;
        letaoSearchTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[[XLTAppPlatformManager shareManager] platformText:@"搜索商品标题 领优惠券拿返现"] attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0xFFC0C2C4],NSFontAttributeName:[UIFont letaoRegularFontWithSize:13]}];
        letaoSearchTextFiled.tintColor = [UIColor letaomainColorSkinColor];
        letaoSearchTextFiled.font = [UIFont letaoRegularFontWithSize:13];
        letaoSearchTextFiled.backgroundColor = [UIColor colorWithHex:0xFFE6E6EA];
        letaoSearchTextFiled.layer.masksToBounds = YES;
        letaoSearchTextFiled.returnKeyType = UIReturnKeySearch;
        letaoSearchTextFiled.layer.cornerRadius = 15;
        [self addSubview:letaoSearchTextFiled];
        
        UIImageView *searchIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 3, 13, 13)];
        searchIconImageView.image = [UIImage imageNamed:@"xinletao_home_search_image"];
        UIView *leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15+13+5, 20)];
        [leftPaddingView addSubview:searchIconImageView];
        leftPaddingView.backgroundColor = [UIColor clearColor];
        letaoSearchTextFiled.leftView = leftPaddingView;
        letaoSearchTextFiled.leftViewMode = UITextFieldViewModeAlways;
        letaoSearchTextFiled.clearButtonMode = UITextFieldViewModeAlways;
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

@end



@implementation XLTCustomSearchBarTwo
- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        UIButton *letaoSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [letaoSearchBtn setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
        [letaoSearchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        letaoSearchBtn.titleLabel.font = [UIFont letaoMediumBoldFontWithSize:14];
        letaoSearchBtn.frame = CGRectMake(self.bounds.size.width -44 - 5, kStatusBarHeight, 44, 44);
        self.letaoSearchBtn = letaoSearchBtn;
        [self addSubview:letaoSearchBtn];
        
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, kStatusBarHeight , 44, 44);
        [leftButton setImage:[UIImage imageNamed:@"xinletao_nav_left_back_gray"] forState:UIControlStateNormal];
        self.letaoLeftBtn = leftButton;
        [self addSubview:leftButton];
        
        UITextField *letaoSearchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftButton.frame) + 5, letaoSearchBtn.frame.origin.y +7, letaoSearchBtn.frame.origin.x - 10 - CGRectGetMaxX(leftButton.frame) , 30)];
        self.letaoSearchTextFiled = letaoSearchTextFiled;
        letaoSearchTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[[XLTAppPlatformManager shareManager] platformText:@"搜索商品标题 领优惠券拿返现"] attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0xFFC0C2C4],NSFontAttributeName:[UIFont letaoRegularFontWithSize:13]}];
        letaoSearchTextFiled.tintColor = [UIColor letaomainColorSkinColor];
        letaoSearchTextFiled.font = [UIFont letaoRegularFontWithSize:13];
        letaoSearchTextFiled.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
        letaoSearchTextFiled.layer.masksToBounds = YES;
        letaoSearchTextFiled.returnKeyType = UIReturnKeySearch;
        letaoSearchTextFiled.layer.cornerRadius = 15;
        [self addSubview:letaoSearchTextFiled];
        
        UIImageView *searchIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 3, 13, 13)];
        searchIconImageView.image = [UIImage imageNamed:@"xinletao_home_search_image"];
        UIView *leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15+13+5, 20)];
        [leftPaddingView addSubview:searchIconImageView];
        leftPaddingView.backgroundColor = [UIColor clearColor];
        letaoSearchTextFiled.leftView = leftPaddingView;
        letaoSearchTextFiled.leftViewMode = UITextFieldViewModeAlways;
        letaoSearchTextFiled.clearButtonMode = UITextFieldViewModeAlways;
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}


@end
