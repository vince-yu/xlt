//
//  XLTUserWithDrawTableViewCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserWithDrawTableViewCell.h"

@interface XLTUserWithDrawTableViewCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@end

@implementation XLTUserWithDrawTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.moneyTextField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void )setMaxPrice:(NSString *)maxPrice{
    _maxPrice = [maxPrice priceStr];
    self.balanceLabel.text = [NSString stringWithFormat:@"余额：¥%@",self.maxPrice.length ? self.maxPrice  : @""];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)allWithDrawAction:(id)sender {
    self.moneyTextField.text = self.maxPrice;
    if (self.textFieldChange) {
        self.textFieldChange(self.maxPrice);
    }
}
- (void)textChanged:(NSNotification *)note{
    UITextField *textField = note.object;
    if (![textField isEqual:self.moneyTextField]) {
        return;
    }
    if (self.textFieldChange) {
        self.textFieldChange(textField.text);
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"0"]&&( [textField.text hasPrefix:@"0"] && ![textField.text hasPrefix:@"0."])) {
        textField.text = @"0.";
        return NO;
    }
    if ([string isEqualToString:@"."]) {
        if (!textField.text.length) {
            textField.text = @"0.";
            return NO;
        }
        if ([textField.text containsString:@"."]) {
            return NO;
        }
    };
    
    NSString *text = [textField.text stringByAppendingString:string];
    NSArray *array = [text componentsSeparatedByString:@"."];
    if ([array count] > 1 && string.length) {
        if ([array.lastObject length] > 2) {
            return NO;
        }
    }
    return YES;
}
- (void)clearTextField{
    self.moneyTextField.text = @"";
}
@end
