//
//  XLTFullScreenSJVideoVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/2/11.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFullScreenSJVideoVC.h"
#import "SJVideoPlayer.h"
#import "SJBaseVideoPlayer.h"
#import <SJUIKit/NSAttributedString+SJMake.h>
#import "AppDelegate+Coordinator.h"

@interface XLTFullScreenSJVideoVC ()
@property (weak, nonatomic) IBOutlet UIView *playerContainerView;
@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, assign) BOOL canClose;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;

@end

@implementation XLTFullScreenSJVideoVC

- (IBAction)closeButtonAction:(id)sender {
    // 旋转到竖屏
    [_player rotate:SJOrientation_Portrait animated:NO];
    [_player stop];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        [appDelegate removeVideoNavigationViewController];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupViews];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
}

- (void)_setupViews {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _player = [SJVideoPlayer player];
    _player.defaultEdgeControlLayer.hiddenBackButtonWhenOrientationIsPortrait = YES;
    _player.defaultEdgeControlLayer.hiddenBottomProgressIndicator = YES;
    _player.pausedToKeepAppearState = YES;
    
    _player.controlLayerAppearManager.interval = 5; // 设置控制层隐藏间隔
    SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"helpvideo" withExtension:@"mp4"]];
    _player.URLAsset = asset;
    [_playerContainerView addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    __weak typeof(self) _self = self;
    _player.rotationObserver.rotationDidStartExeBlock = ^(id<SJRotationManager>  _Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
#ifdef DEBUG
        NSLog(@"%d \t %s", (int)__LINE__, __func__);
#endif
    };
    
    
    _player.playbackObserver.playbackDidFinishExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        self.canClose = YES;
        self.closeButton.hidden = NO;
        [self closeButtonAction:nil];
    };
    
    _player.gestureControl.panHandler = ^(id<SJPlayerGestureControl>  _Nonnull control, SJPanGestureTriggeredPosition position, SJPanGestureMovingDirection direction, SJPanGestureRecognizerState state, CGPoint translate) {
        // do noting
    };
    
    SJEdgeControlButtonItem *progressItem = [_player.defaultEdgeControlLayer.bottomAdapter itemForTag:SJEdgeControlLayerBottomItem_Progress];
    if ([progressItem isKindOfClass:[SJEdgeControlButtonItem class]]) {
        UIView *slider = progressItem.customView;
        slider.userInteractionEnabled = NO;
    }
}

#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_player vc_viewDidAppear];
#ifdef DEBUG
    NSLog(@"AA: %d - %s", (int)__LINE__, __func__);
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_player vc_viewDidDisappear];
#ifdef DEBUG
        NSLog(@"AA: %d - %s", (int)__LINE__, __func__);
#endif
}

- (BOOL)prefersStatusBarHidden {
    return [self.player vc_prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.player vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
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


@implementation UIViewController (RotationControl)
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end


@implementation UITabBarController (RotationControl)
- (UIViewController *)sj_topViewController {
    if ( self.selectedIndex == NSNotFound )
        return self.viewControllers.firstObject;
    return self.selectedViewController;
}

- (BOOL)shouldAutorotate {
    return [[self sj_topViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self sj_topViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self sj_topViewController] preferredInterfaceOrientationForPresentation];
}
@end

@implementation UINavigationController (RotationControl)
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (nullable UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
@end
