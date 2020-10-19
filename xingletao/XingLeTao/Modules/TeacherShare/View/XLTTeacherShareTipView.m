//
//  XLTTeacherShareTipView.m
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTTeacherShareTipView.h"
#import "XLTTeacherShareListForMeVC.h"

@interface XLTTeacherShareTipView ()
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;

@end

@implementation XLTTeacherShareTipView

- (instancetype)initWithNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTTeacherShareTipView" owner:nil options:nil] lastObject];
    if (self) {
        self.lookBtn.layer.borderColor = [UIColor colorWithHex:0xFF8202].CGColor;
        self.lookBtn.layer.borderWidth = 0.5;
    }
    return self;
}
- (IBAction)lookAction:(id)sender {
    XLTTeacherShareListForMeVC *vc = [[XLTTeacherShareListForMeVC alloc] init];
    [self.letaoNav pushViewController:vc animated:YES];
}

@end
