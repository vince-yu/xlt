//
//  XLTRightFilterPriceCell.m
//  XingLeTao
//
//  Created by SNQU on 2020/1/9.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTRightFilterPriceCell.h"

@interface XLTRightFilterPriceCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *maxField;
@property (weak, nonatomic) IBOutlet UITextField *minField;
@property (weak, nonatomic) IBOutlet UILabel *minBgLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxBgLabel;

@end

@implementation XLTRightFilterPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.minBgLabel.layer.masksToBounds = YES;
    self.maxBgLabel.layer.masksToBounds = YES;
    self.minBgLabel.layer.cornerRadius = 16.5;
    self.maxBgLabel.layer.cornerRadius = 16.5;
    
    self.maxField.delegate = self;
    self.minField.delegate = self;
    
    self.maxField.keyboardType = UIKeyboardTypeDecimalPad;
    self.minField.keyboardType = UIKeyboardTypeDecimalPad;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)setModel:(XLTRightFilterItem *)model{
    _model = model;
    self.minField.text = model.minPrice.length ? model.minPrice : @"";
    self.maxField.text = model.maxPrice.length ? model.maxPrice : @"";
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textChanged:(NSNotification *)note{
    UITextField *textField = note.object;
    if (![textField isEqual:self.minField] && ![textField isEqual:self.maxField]) {
        return;
    }
    
    if (textField.text.length && ![textField.text isPureInt]) {
        [MBProgressHUD letaoshowTipMessageInWindow:@"只能输入整数！"];
        textField.text = @"";
        return;
    };
    if (textField.text.length > 15) {
        [MBProgressHUD letaoshowTipMessageInWindow:@"最多只能输入15位数字！"];
        textField.text = @"";
        return;
    }
    
    if ([textField isEqual:self.minField]) {
        self.model.minPrice = textField.text;
    }
    if ([textField isEqual:self.maxField]) {
        self.model.maxPrice = textField.text;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"."]) {
        [MBProgressHUD letaoshowTipMessageInWindow:@"只能输入整数！"];
        return NO;
    }
    if (textField.text.length >= 15 && string.length) {
        [MBProgressHUD letaoshowTipMessageInWindow:@"最多只能输入15位数字！"];
        return NO;
    }
    
    return YES;
}
@end
