//
//  XLTVersionsUpdateView.h
//  XingLeTao
//
//  Created by chenhg on 2020/2/3.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLTVersionsUpdateViewDelegate <NSObject>

- (void)cancelButtonAction:(id)sender;

- (void)updateButtonAction:(id)sender;

@end

@interface XLTVersionsUpdateView : UIView
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *updateButton;
@property (nonatomic, weak) IBOutlet UILabel *updateTextLabel;

@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) id<XLTVersionsUpdateViewDelegate> delegate;
@property (nonatomic, assign) BOOL isForceUpdate;

@end

NS_ASSUME_NONNULL_END
