//
//  XLTOrdePlatformSourceView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTOrdePlatformSourceView;
@protocol XLTOrdePlatformSourceViewDelegate <NSObject>

- (void)letaoSourceView:(XLTOrdePlatformSourceView *)ordeSourceView didChangeSource:(NSString *)source;

@end

@interface XLTOrdePlatformSourceView : UIView
@property (nonatomic, weak) id<XLTOrdePlatformSourceViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
