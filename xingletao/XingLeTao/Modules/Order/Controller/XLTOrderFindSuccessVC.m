//
//  XLTOrderFindSuccessVC.m
//  XingLeTao
//
//  Created by SNQU on 2020/6/12.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTOrderFindSuccessVC.h"
#import "UIImage+UIColor.h"
#import "XLTRootOrderVC.h"

@interface XLTOrderFindSuccessVC ()
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;

@end

@implementation XLTOrderFindSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"找回订单";
    UIImage *image = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFAE01],[UIColor colorWithHex:0xFF6E02]] gradientType:1 imgSize:CGSizeMake(80, 40)];
    [self.lookBtn setBackgroundImage:image forState:UIControlStateNormal];
    self.lookBtn.layer.cornerRadius = 20;
    self.lookBtn.clipsToBounds = YES;
}

- (IBAction)LookAction:(id)sender {
    XLTRootOrderVC *vc = [[XLTRootOrderVC alloc] init];
    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    if (viewControllers.count > 3 ) {
        [viewControllers removeObjectsInRange:NSMakeRange(viewControllers.count - 3, 3)];
        [viewControllers addObject:vc];
        [self.navigationController setViewControllers:viewControllers animated:YES];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)letaopopViewController {
    NSArray *array = self.navigationController.viewControllers;
    if (array.count > 2 ) {
        [self.navigationController popToViewController:[array objectAtIndex:array.count - 3] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated{
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
