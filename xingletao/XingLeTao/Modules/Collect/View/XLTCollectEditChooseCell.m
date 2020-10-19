//
//  XLTCollectEditChooseCell.m
//  XingLeTao
//
//  Created by vince on 2020/10/12.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTCollectEditChooseCell.h"
#import "SPButton.h"
#import "NSArray+Bounds.h"

@interface XLTCollectEditChooseCell ()
@property (weak, nonatomic) IBOutlet SPButton *ysxBtn;
@property (weak, nonatomic) IBOutlet SPButton *sgyBtn;
@property (weak, nonatomic) IBOutlet SPButton *noBtn;

@end

@implementation XLTCollectEditChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
//    self.ysxBtn.selected = YES
}
- (IBAction)ysxAction:(id)sender {
    self.ysxBtn.selected = !self.ysxBtn.selected;
    self.sgyBtn.selected = NO;
    self.noBtn.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseType:)]) {
        if (self.ysxBtn.selected) {
            [self.delegate chooseType:0];
        }else{
            [self.delegate chooseType:-1];
        }
    }
    
}
- (IBAction)sgyqAction:(id)sender {
    self.ysxBtn.selected = NO;
    self.sgyBtn.selected = !self.sgyBtn.selected;
    self.noBtn.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseType:)]) {
        if (self.sgyBtn.selected) {
            [self.delegate chooseType:1];
        }else{
            [self.delegate chooseType:-1];
        }
    }
}
- (IBAction)noAction:(id)sender {
    self.ysxBtn.selected = NO;
    self.sgyBtn.selected = NO;
    self.noBtn.selected = !self.noBtn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseType:)]) {
        if (self.noBtn.selected) {
            [self.delegate chooseType:2];
        }else{
            [self.delegate chooseType:-1];
        }
        
    }
}
- (void)setCountArray:(NSArray *)countArray{
    _countArray = countArray;
//    self.ysxBtn.selected = NO;
//    self.sgyBtn.selected = NO;
//    self.noBtn.selected = NO;
    
    [self.ysxBtn setTitle:[NSString stringWithFormat:@"已失效(%@)",countArray.firstObject] forState:UIControlStateNormal];
    [self.sgyBtn setTitle:[NSString stringWithFormat:@"三个月前(%@)",[countArray by_ObjectAtIndex:1]] forState:UIControlStateNormal];
    [self.noBtn setTitle:[NSString stringWithFormat:@"无优惠券(%@)",[countArray by_ObjectAtIndex:2]] forState:UIControlStateNormal];
    
    [self.ysxBtn setTitle:[NSString stringWithFormat:@"已失效(%@)",countArray.firstObject] forState:UIControlStateSelected];
    [self.sgyBtn setTitle:[NSString stringWithFormat:@"三个月前(%@)",[countArray by_ObjectAtIndex:1]] forState:UIControlStateSelected];
    [self.noBtn setTitle:[NSString stringWithFormat:@"无优惠券(%@)",[countArray by_ObjectAtIndex:2]] forState:UIControlStateSelected];
    
    NSInteger selectType = [_countArray.lastObject integerValue];
    switch (selectType) {
        case 0:
            self.ysxBtn.selected = YES;
            break;
        case 1:
            self.sgyBtn.selected = YES;
            break;
        case 2:
            self.noBtn.selected = YES;
            break;
        default:
            self.ysxBtn.selected = NO;
            self.sgyBtn.selected = NO;
            self.noBtn.selected = NO;
            break;
    }
}
@end
