//
//  XLTOrderFindVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/19.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTOrderFindVC.h"
#import "XLTOrderFindResultVC.h"

@interface XLTOrderFindVC () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UIView *letaoSearchBgView;
@property (nonatomic, strong) UITextField *letaoSearchTextFiled;

@end

@implementation XLTOrderFindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"找回订单";
    [self letaoSetupSearchTextFiled];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.letaoSearchTextFiled.text = nil;
}

- (void)letaoSetupSearchTextFiled {
    UITextField *letaoSearchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, kScreenWidth - 20, 30)];
    letaoSearchTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入或粘贴商品订单编号" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0xFFC0C2C4],NSFontAttributeName:[UIFont letaoRegularFontWithSize:13]}];
    letaoSearchTextFiled.tintColor = [UIColor letaomainColorSkinColor];
    letaoSearchTextFiled.font = [UIFont letaoRegularFontWithSize:13];
    letaoSearchTextFiled.backgroundColor = [UIColor colorWithHex:0xFFE6E6EA];
    letaoSearchTextFiled.layer.masksToBounds = YES;
    letaoSearchTextFiled.returnKeyType = UIReturnKeySearch;
    letaoSearchTextFiled.delegate = self;
    letaoSearchTextFiled.layer.cornerRadius = 15;
    [self.letaoSearchBgView addSubview:letaoSearchTextFiled];
    
    UIImageView *searchIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 3, 13, 13)];
    searchIconImageView.image = [UIImage imageNamed:@"xinletao_home_search_image"];
    UIView *leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15+13+5, 20)];
    [leftPaddingView addSubview:searchIconImageView];
    leftPaddingView.backgroundColor = [UIColor clearColor];
    letaoSearchTextFiled.leftView = leftPaddingView;
    letaoSearchTextFiled.leftViewMode = UITextFieldViewModeAlways;
    
    self.letaoSearchTextFiled = letaoSearchTextFiled;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *letaoSearchText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self letaoStartSearchWithText:letaoSearchText];
    return YES;
}

- (void)letaoStartSearchWithText:(NSString *)letaoSearchText {
    [self.view endEditing:YES];
    if (letaoSearchText.length) {
        XLTOrderFindResultVC *reultViewController = [[XLTOrderFindResultVC alloc] init];
        reultViewController.letaoSearchText = letaoSearchText;
        [self.navigationController pushViewController:reultViewController animated:YES];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
