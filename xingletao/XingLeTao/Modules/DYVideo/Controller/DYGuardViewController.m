//
//  DYGuardViewController.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/12.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "DYGuardViewController.h"

@interface DYGuardViewController ()
@property (nonatomic, weak) IBOutlet UIView *fristGuardView;
@property (nonatomic, weak) IBOutlet UIView *secondGuardView;


@end

@implementation DYGuardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fristButtonAction:)];
    [self.fristGuardView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondButtonAction:)];
    [self.secondGuardView addGestureRecognizer:secondTap];

}

- (IBAction)fristButtonAction:(id)sender {
    self.fristGuardView.hidden = YES;
    self.secondGuardView.hidden = NO;
}

- (IBAction)secondButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(guardShouldDismiss)]) {
        [self.delegate guardShouldDismiss];
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
