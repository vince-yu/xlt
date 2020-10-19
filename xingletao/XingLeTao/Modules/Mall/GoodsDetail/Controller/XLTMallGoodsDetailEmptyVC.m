//
//  XLTMallGoodsDetailEmptyVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTMallGoodsDetailEmptyVC.h"
#import "LetaoEmptyCoverView.h"


@interface XLTMallGoodsDetailEmptyVC ()
@property (nonatomic, strong) LetaoEmptyCoverView *letaoEmptyCoverView;

@end

@implementation XLTMallGoodsDetailEmptyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self letaoShowEmptyView];
    self.title = @"商品未找到";
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
}

- (void)letaoShowEmptyView {
    if (self.letaoEmptyCoverView == nil) {
        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"page_empty"
                                                                   titleStr:@"暂无商品信息~"
                                                                  detailStr:@""
                                                                btnTitleStr:@""
                                                              btnClickBlock:^(){
                                                                  // do nothings
                                                              }];
        letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = YES;
        letaoEmptyCoverView.subViewMargin = 14.f;
        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:15.f];
        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(172, 172, 172);
        self.letaoEmptyCoverView = letaoEmptyCoverView;
    }
    [self.view addSubview:self.letaoEmptyCoverView];
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
