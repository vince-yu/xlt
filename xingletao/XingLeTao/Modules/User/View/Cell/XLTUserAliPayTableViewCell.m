//
//  XLTUserAliPayTableViewCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserAliPayTableViewCell.h"
#import "JKCountDownButton.h"

@interface XLTUserAliPayTableViewCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentField;
@property (weak, nonatomic) IBOutlet JKCountDownButton *codeBtn;

@end

@implementation XLTUserAliPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.codeBtn.layer.cornerRadius = 15;
    self.codeBtn.layer.borderColor = [UIColor colorWithHex:0xFF8202].CGColor;
    self.codeBtn.layer.borderWidth = 1;
    self.contentField.delegate = self;
    [self.codeBtn countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
           NSString *title = [NSString stringWithFormat:@"重新发送(%zds)",second];
           countDownButton.layer.borderWidth = 0;
           return title;
       }];
   [self.codeBtn countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
       countDownButton.enabled = YES;
       countDownButton.layer.borderWidth = 1.0;
       return @"获取验证码";
       
   }];
}
- (void)setModel:(id )model{
    _model = model;
    self.codeBtn.hidden = [self.model[@"type"] intValue] == 0 ? YES : NO;
    self.nameLabel.text = self.model[@"name"];
    self.contentField.placeholder = self.model[@"palceholder"];
    if ([self.model[@"value"] length]) {
        self.contentField.text = self.model[@"value"];
    }else{
        self.contentField.text = @"";
    }
    self.contentField.enabled = ![[self.model objectForKey:@"noedit"] boolValue];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)sendCode:(id)sender {
    [self.codeBtn startCountDownWithSecond:60];
    if (self.sendCodeBlock) {
        self.sendCodeBlock();
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.textFieldBlock) {
        self.textFieldBlock(self.model[@"code"], textField.text);
    }
}
@end
