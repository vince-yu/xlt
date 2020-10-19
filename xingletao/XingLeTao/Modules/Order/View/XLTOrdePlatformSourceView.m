//
//  XLTOrdePlatformSourceView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTOrdePlatformSourceView.h"
#import "XLTHomePageLogic.h"
#import "UIView+Extension.h"

@interface XLTOrdePlatformSourceView ()
@property (nonatomic, weak) IBOutlet UIButton *letaoTianmaoButton;
@property (nonatomic, weak) IBOutlet UIButton *letaoTaobaoButton;
@property (nonatomic, weak) IBOutlet UIButton *letaoJDongButton;
@property (weak, nonatomic) IBOutlet UIButton *letaoAllPlatformButton;
@property (weak, nonatomic) IBOutlet UIButton *letaoPddButton;

@property (nonatomic, strong) NSMutableArray *itemsArray;


@property (nonatomic ,strong) UIButton *selectBtn;

@end

@implementation XLTOrdePlatformSourceView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
//    _itemsArray = @[self.letaoAllPlatformButton,self.letaoTianmaoButton,self.letaoTaobaoButton,self.letaoJDongButton].mutableCopy;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.letaoAllPlatformButton.center = CGPointMake(self.width * 1/10.0, self.center.y);
//    self.letaoTianmaoButton.center = CGPointMake(self.width * 3/10.0   , self.center.y);
//    self.letaoTaobaoButton.center = CGPointMake(self.width * 5/10.0, self.center.y);
//    self.letaoJDongButton.center = CGPointMake(self.width * 7/10.0, self.center.y);
//    self.letaoPddButton.center = CGPointMake(self.width * 9/10.0, self.center.y);
    [self configWithSource];
    UIButton *middleItem = self.itemsArray[0];
    self.selectBtn = middleItem;
    [middleItem setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:1.2];
    animation.duration = 0.3;
    animation.removedOnCompletion = NO;
    animation.fillMode=kCAFillModeForwards;
    [middleItem.layer addAnimation:animation forKey:@"zoom"];
}
- (void)configWithSource{
    NSMutableArray *sourceArray = [[NSMutableArray alloc] initWithObjects:self.letaoAllPlatformButton, nil];
    NSArray *array = [XLTAppPlatformManager shareManager].supportGoodsPlatformArrayForOrder;
    if (array.count) {
        for (NSDictionary *info in array) {
            if ([info isKindOfClass:[NSDictionary class]]) {
                NSString *code = info[@"code"];
                if ([code isEqualToString:XLTTianmaoPlatformIndicate]) {
                    self.letaoTianmaoButton.hidden = NO;
                    [sourceArray addObject:self.letaoTianmaoButton];
                }
                if ([code isEqualToString:XLTTaobaoPlatformIndicate]) {
                    self.letaoTaobaoButton.hidden = NO;
                    [sourceArray addObject:self.letaoTaobaoButton];
                }
                if ([code isEqualToString:XLTJindongPlatformIndicate]) {
                    self.letaoJDongButton.hidden = NO;
                    [sourceArray addObject:self.letaoJDongButton];
                }
                if ([code isEqualToString:XLTPDDPlatformIndicate]) {
                    self.letaoPddButton.hidden = NO;
                    [sourceArray addObject:self.letaoPddButton];
                }
            }

        }
        self.itemsArray = sourceArray;
    }else{
        self.itemsArray = @[self.letaoAllPlatformButton,self.letaoTianmaoButton,self.letaoTaobaoButton,self.letaoJDongButton,self.letaoPddButton].mutableCopy;
    }
    NSInteger count = self.itemsArray.count;
    for (int i = 0; i < count; i ++) {
        UIButton *btn = [self.itemsArray objectAtIndex:i];
        btn.frame = CGRectMake(0, 0, self.width / count, self.height);
        CGFloat bili = (2*(i + 1) - 1) / (2.0*count);
        btn.center = CGPointMake(self.width *bili, self.center.y);
        
        
        NSLog(@"");
    }
}
- (IBAction)sourceItemClicked:(id)sender {
//    UIButton *middleItem = self.itemsArray[1];
//    if (sender != self.selectBtn) {
        [self stratAnimation:sender];
        // 回调
        if ([self.delegate respondsToSelector:@selector(letaoSourceView:didChangeSource:)]) {
            NSString *source = nil;
            if (sender == self.letaoTaobaoButton) {
                source = XLTTaobaoPlatformIndicate;
            } else if (sender == self.letaoTianmaoButton) {
                source = XLTTianmaoPlatformIndicate;
            } else if (sender == self.letaoJDongButton){
               source = XLTJindongPlatformIndicate;
            }else if (sender == self.letaoPddButton){
               source = XLTPDDPlatformIndicate;
            }else{
                source = @"";
            }
            [self.delegate letaoSourceView:sender didChangeSource:source];
        }
//    }
}

#define kItemWidth 96
#define kItemHeight kItemWidth
- (void)stratAnimation:(UIButton *)item {
    if (item == self.selectBtn) {
        return;
    }
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:1.2];
    animation.duration = 0.3;
    animation.removedOnCompletion = NO;
    animation.fillMode=kCAFillModeForwards;
    [item.layer addAnimation:animation forKey:@"zoom"];


    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue=[NSNumber numberWithFloat:1.2];
    animation2.toValue=[NSNumber numberWithFloat:1.0];
    animation2.duration = 0.3;
    animation2.removedOnCompletion = YES;
    [self.selectBtn.layer addAnimation:animation2 forKey:@"zoom"];
    [item setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
    [self.selectBtn setTitleColor:[UIColor colorWithHex:0xFF848487] forState:UIControlStateNormal];
    self.selectBtn = item;
}
//Mark://旋转跳跃，光闭着眼
//- (void)stratAnimation:(UIButton *)item {
//    UIButton *leftItem = self.itemsArray[0];
//    UIButton *middleItem = self.itemsArray[1];
//    UIButton *rightItem = self.itemsArray[2];
//    if (item == leftItem) {
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            middleItem.center = CGPointMake(self.center.x*0.5, self.center.y);
//            item.center = CGPointMake(self.center.x, self.center.y);
//                } completion:^(BOOL finished) {
//                    [item setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
//                    [middleItem setTitleColor:[UIColor colorWithHex:0xFF848487] forState:UIControlStateNormal];
//        }];
//        CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        animation.fromValue=[NSNumber numberWithFloat:1.0];
//        animation.toValue=[NSNumber numberWithFloat:1.2];
//        animation.duration = 0.3;
//        animation.removedOnCompletion = NO;
//        animation.fillMode=kCAFillModeForwards;
//        [item.layer addAnimation:animation forKey:@"zoom"];
//
//
//        CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        animation2.fromValue=[NSNumber numberWithFloat:1.2];
//        animation2.toValue=[NSNumber numberWithFloat:1.0];
//        animation2.duration = 0.3;
//        animation2.removedOnCompletion = YES;
//        [middleItem.layer addAnimation:animation2 forKey:@"zoom"];
//        self.itemsArray[1] = item;
//        self.itemsArray[0] = middleItem;
//    } else if (item == rightItem) {
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            middleItem.center = CGPointMake(self.center.x*1.5, self.center.y);
//            item.center = CGPointMake(self.center.x, self.center.y);
//                } completion:^(BOOL finished) {
//                    [item setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
//                    [middleItem setTitleColor:[UIColor colorWithHex:0xFF848487] forState:UIControlStateNormal];
//        }];
//        CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        animation.fromValue=[NSNumber numberWithFloat:1.0];
//        animation.toValue=[NSNumber numberWithFloat:1.2];
//        animation.duration = 0.3;
//        animation.removedOnCompletion = NO;
//        animation.fillMode=kCAFillModeForwards;
//        [item.layer addAnimation:animation forKey:@"zoom"];
//
//
//        CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        animation2.fromValue=[NSNumber numberWithFloat:1.2];
//        animation2.toValue=[NSNumber numberWithFloat:1.0];
//        animation2.duration = 0.3;
//        animation2.removedOnCompletion = YES;
//        [middleItem.layer addAnimation:animation2 forKey:@"zoom"];
//        self.itemsArray[1] = item;
//        self.itemsArray[2] = middleItem;
//    }
//
//}
@end
