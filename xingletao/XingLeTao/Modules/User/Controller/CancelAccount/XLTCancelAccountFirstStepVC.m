//
//  XLTCancelAccountFirstStepVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTCancelAccountFirstStepVC.h"
#import "FSTextView.h"
#import "XLTCancelAccountSecondStepVC.h"
#import "XLTUserManager.h"
#import "NSArray+Bounds.h"

@interface XLTCancelAccountFirstStepVC ()

@property (nonatomic, weak) IBOutlet FSTextView *feedbackTextView;
@property (nonatomic, weak) IBOutlet UILabel *maxNoticeLabel;


@property (nonatomic, weak) IBOutlet UIButton *checkBox1;
@property (nonatomic, weak) IBOutlet UIButton *checkBox2;
@property (nonatomic, weak) IBOutlet UIButton *checkBox3;
@property (nonatomic, weak) IBOutlet UIButton *checkBox4;
@property (nonatomic, weak) IBOutlet UIButton *checkBox5;
@property (nonatomic, weak) IBOutlet UIButton *otherCheckBox;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;

@property (nonatomic ,strong) NSMutableArray *reasonArray;

@end

@implementation XLTCancelAccountFirstStepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [XLTUserManager shareManager].reasonArray = nil;
    __weak __typeof(self)weakSelf = self;
    [_feedbackTextView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        NSString *tipMessage = [NSString stringWithFormat:@"最多限制输入%zi个字符", textView.maxLength];
        [weakSelf showTipMessage:tipMessage];
    }];
       
       
       __weak __typeof(&*self.maxNoticeLabel)weakNoticeLabel = self.maxNoticeLabel;
       
       // 添加输入改变Block回调.
       
       [_feedbackTextView addTextDidChangeHandler:^(FSTextView *textView) {
           (textView.text.length <= textView.maxLength) ? weakNoticeLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)textView.text.length,(long)textView.maxLength]:NULL;
           [weakSelf feedbackTextDidChanged:textView.text];
       }];
    
    [self.nextButton setBackgroundImage:[UIImage letaoimageWithColor:[UIColor letaomainColorSkinColor]] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFC3C4C7]] forState:UIControlStateDisabled];

}
- (NSMutableArray *)reasonArray{
    if (!_reasonArray) {
        _reasonArray = [[NSMutableArray alloc] init];
    }
    return _reasonArray;
}
- (IBAction)checkBoxButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self adjustNextButtonStyle];
    [self adjustFeedbackTextViewStyle];
}

- (void)feedbackTextDidChanged:(NSString *)text {
    [self adjustNextButtonStyle];
}

- (void)adjustNextButtonStyle {
    BOOL enabled = NO;
    if (self.otherCheckBox.selected) {
        enabled = self.feedbackTextView.text.length > 0;
    } else {
        enabled = (self.checkBox1.selected
                   || self.checkBox2.selected
                   || self.checkBox3.selected
                   || self.checkBox4.selected
                   || self.checkBox5.selected);
    }
    self.nextButton.enabled = enabled;
}

- (void)adjustFeedbackTextViewStyle {
    self.feedbackTextView.hidden = !self.otherCheckBox.selected;
    self.maxNoticeLabel.hidden = self.feedbackTextView.hidden;
}

- (IBAction)nextButtonAction:(UIButton *)sender {
    if (self.checkBox1.selected) {
        [self.reasonArray by_AddObject:self.label1.text];
    }
    if (self.checkBox2.selected) {
        [self.reasonArray by_AddObject:self.label2.text];
    }
    if (self.checkBox3.selected) {
        [self.reasonArray by_AddObject:self.label3.text];
    }
    if (self.checkBox4.selected) {
        [self.reasonArray by_AddObject:self.label4.text];
    }
    if (self.checkBox5.selected) {
        [self.reasonArray by_AddObject:self.label5.text];
    }
    if (self.otherCheckBox.selected) {
        [self.reasonArray by_AddObject:self.feedbackTextView.text];
    }
    [XLTUserManager shareManager].reasonArray = self.reasonArray;
    XLTCancelAccountSecondStepVC *vc = [[XLTCancelAccountSecondStepVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
