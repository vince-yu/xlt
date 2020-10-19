//
//  XLTCustomSheetVC.m
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTCustomSheetVC.h"

@interface XLTCustomSheetVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
//@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *titlBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIView *editLine;

@end

@implementation XLTCustomSheetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.titlBtn setTitle:self.titleStr forState:UIControlStateNormal];
    [self.sureBtn setTitle:self.sureBtnTitle forState:UIControlStateNormal];
    [self.editBtn setTitle:self.eidtStr forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor clearColor];
    if (self.canEdit) {
        self.contentHeight.constant = 260;
        self.editBtn.hidden = NO;
        self.editLine.hidden = NO;
    }else{
        self.contentHeight.constant = 200;
        self.editBtn.hidden = NO;
        self.editLine.hidden = NO;
    }
}
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [UIView animateWithDuration:0.1 animations:^{
//        self.bgView.alpha = 0.3;
//    }];
//
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)editAction:(id)sender {
    XLT_WeakSelf;
    [self dismissViewControllerAnimated:NO completion:^{
        XLT_StrongSelf;
        if (self.editBlock) {
            self.editBlock();
        }
    }];
}
- (IBAction)cancelAction:(id)sender {
    XLT_WeakSelf;
    [self dismissViewControllerAnimated:NO completion:^{
        XLT_StrongSelf;
        if (self.titleBlock) {
            self.titleBlock();
        }
    }];
}
- (IBAction)sureAction:(id)sender {
    XLT_WeakSelf;
    [self dismissViewControllerAnimated:NO completion:^{
        XLT_StrongSelf;
        if (self.sureBlock) {
            self.sureBlock();
        }
    }];
    
}
- (IBAction)disMiss:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
