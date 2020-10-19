//
//  XLTTeacherShareEmptyVC.m
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTTeacherShareEmptyVC.h"
#import "XLTTeachShareWebVC.h"

@interface XLTTeacherShareEmptyVC ()

@end

@implementation XLTTeacherShareEmptyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
}
- (IBAction)creatAtion:(id)sender {
    XLTTeachShareWebVC *vc = [[XLTTeachShareWebVC alloc] init];
    vc.jump_URL = [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202009tutor/index.html"];
    vc.fullScreen = YES;
    [self.letaoNav pushViewController:vc animated:YES];
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
