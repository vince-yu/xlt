//
//  XLTNavigationController.m
//  ShopAnalytics
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019  . All rights reserved.
//

#import "XLTNavigationController.h"
#import <objc/runtime.h>

@interface XLTNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation XLTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.delegate = self.swipeBackEnabled ? self : nil;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    self.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]] && [touch.view isDescendantOfView:self.navigationBar]) {
        UIButton *button = (id)touch.view;
        button.highlighted = YES;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 || !self.swipeBackEnabled) {
        return NO;
    }
    
    CGPoint location = [gestureRecognizer locationInView:self.navigationBar];
    UIView *view = [self.navigationBar hitTest:location withEvent:nil];
    
    if ([view isKindOfClass:[UIButton class]] && [view isDescendantOfView:self.navigationBar]) {
        UIButton *button = (id)view;
        button.highlighted = NO;
    }
    return YES;
}


#pragma mark - swipeBackEnabled

- (BOOL)swipeBackEnabled {
    NSNumber *enabled = objc_getAssociatedObject(self, @selector(swipeBackEnabled));
    if (enabled == nil) {
        return YES; // default value
    }
    return enabled.boolValue;
}

- (void)setSwipeBackEnabled:(BOOL)enabled {
    objc_setAssociatedObject(self, @selector(swipeBackEnabled), @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
