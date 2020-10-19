//
//  XLTSchoolSearchReusableView.m
//  XingLeTao
//
//  Created by chenhg on 2020/2/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTSchoolSearchReusableView.h"

@interface XLTSchoolSearchReusableView () <UITextFieldDelegate>
@end

@implementation XLTSchoolSearchReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self letaoSetupSearchTextFiled];
}

- (void)letaoSetupSearchTextFiled {
    UITextField *letaoSearchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, kScreenWidth - 20, 30)];
    letaoSearchTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0xFFC0C2C4],NSFontAttributeName:[UIFont letaoRegularFontWithSize:13]}];
    letaoSearchTextFiled.tintColor = [UIColor letaomainColorSkinColor];
    letaoSearchTextFiled.font = [UIFont letaoRegularFontWithSize:13];
    letaoSearchTextFiled.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
    letaoSearchTextFiled.layer.masksToBounds = YES;
    letaoSearchTextFiled.returnKeyType = UIReturnKeySearch;
//    letaoSearchTextFiled.delegate = self;
    letaoSearchTextFiled.layer.cornerRadius = 15;
    letaoSearchTextFiled.userInteractionEnabled = NO;
    [self addSubview:letaoSearchTextFiled];
    
    UIImageView *searchIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 3, 13, 13)];
    searchIconImageView.image = [UIImage imageNamed:@"xinletao_home_search_image"];
    UIView *leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15+13+5, 20)];
    [leftPaddingView addSubview:searchIconImageView];
    leftPaddingView.backgroundColor = [UIColor clearColor];
    letaoSearchTextFiled.leftView = leftPaddingView;
    letaoSearchTextFiled.leftViewMode = UITextFieldViewModeAlways;
    ;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame= letaoSearchTextFiled.frame;
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(startSearchAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    NSString *letaoSearchText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    [self letaoStartSearchWithText:letaoSearchText];
//    return YES;
//}

- (void)startSearchAction {
     [self letaoStartSearchWithText:@""];
}

- (void)letaoStartSearchWithText:(NSString *)letaoSearchText {
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(letaoStartSearchWithText:)]) {
        [self.delegate letaoStartSearchWithText:letaoSearchText];
    }
}

@end
