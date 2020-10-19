//
//  XLTOrderFindEmptyVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTOrderFindEmptyVC.h"

@interface XLTOrderFindEmptyVC ()

@end

@implementation XLTOrderFindEmptyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"找回订单";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
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
