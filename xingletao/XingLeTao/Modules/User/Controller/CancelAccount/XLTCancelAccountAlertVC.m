//
//  XLTCancelAccountAlertVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTCancelAccountAlertVC.h"

@interface XLTCancelAccountAlertVC ()

@end

@implementation XLTCancelAccountAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
}
- (IBAction)cancelAction:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
- (IBAction)noAction:(id)sender {
    if (self.dismisBlock) {
        self.dismisBlock();
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
