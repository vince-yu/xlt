
//

#import "UIViewController+XLTPresent.h"
#import <objc/runtime.h>

@implementation UIViewController (XLTPresent)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method presentM = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
        Method presentSwizzlingM = class_getInstanceMethod(self.class, @selector(letaopresentViewController:animated:completion:));
        
        method_exchangeImplementations(presentM, presentSwizzlingM);
    });
}

- (void)letaopresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        if (alertController.title == nil && alertController.message == nil) {
            return;
        } else {
            [self letaopresentViewController:viewControllerToPresent animated:flag completion:completion];
            return;
        }
    }
    
    [self letaopresentViewController:viewControllerToPresent animated:flag completion:completion];
}


@end

