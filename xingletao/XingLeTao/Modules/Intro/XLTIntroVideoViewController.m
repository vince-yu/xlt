//
//  XLTIntroVideoViewController.m
//  XingLeTao
//
//  Created by chenhg on 2020/2/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTIntroVideoViewController.h"
#import "SJVideoPlayer.h"
#import "SJBaseVideoPlayer.h"
#import <SJUIKit/NSAttributedString+SJMake.h>
#import "JKCountDownButton.h"
#import "AppDelegate+Coordinator.h"

@interface XLTIntroVideoViewController ()
@property (weak, nonatomic) IBOutlet UIView *playerContainerView;
@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, assign) BOOL canClose;
@property (nonatomic, weak) IBOutlet JKCountDownButton *closeButton;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *closeButtonRight;

@end

@implementation XLTIntroVideoViewController

- (void)dealloc {
    
}

- (IBAction)closeButtonAction:(id)sender {
    // 旋转到竖屏
    [_player rotate:SJOrientation_Portrait animated:NO];
    [_player stop];
    // 进入主界面
    [self enterMainVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupViews];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)_setupViews {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _player = [SJVideoPlayer player];
    _player.defaultEdgeControlLayer.hiddenBottomProgressIndicator = YES;
    _player.defaultEdgeControlLayer.hiddenBackButtonWhenOrientationIsPortrait = YES;
    _player.pausedToKeepAppearState = YES;
    
    _player.controlLayerAppearManager.interval = 5; // 设置控制层隐藏间隔
    NSURL *url =  [[NSBundle mainBundle] URLForResource:@"helpvideo" withExtension:@"mp4"];
//    url = [NSURL URLWithString:@"https://resource.xinletao.vip/static/video/xlt_start_std.mp4"];
    SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset alloc] initWithURL:url];
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
        [self closeButtonAction:nil];
    };
    
    [self setupCloseButtonButtonStyle];
}



- (void)setupCloseButtonButtonStyle {
    UIImage *normalStateImage  = [UIImage letaoimageWithColor:[[UIColor colorWithHex:0xFFFF791D] colorWithAlphaComponent:0.6]];
    UIImage *disabledStateImage  = normalStateImage;
    [self.closeButton setBackgroundImage:normalStateImage forState:UIControlStateNormal];
    [self.closeButton setBackgroundImage:disabledStateImage forState:UIControlStateDisabled];
    
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.closeButton.layer.masksToBounds = YES;
    self.closeButton.layer.cornerRadius = 15.0;
    

    [self verificationCodeButtonStartCountDown];
    if (iPhoneX_All) {
        self.closeButtonRight.constant = -5;
    } else {
        self.closeButtonRight.constant = -5 - (kScreenWidth -  (kScreenHeight/812*kScreenWidth))/2;
    }
    
    
}

- (void)verificationCodeButtonStartCountDown {
    self.closeButton.enabled = NO;
    [self.closeButton startCountDownWithSecond:10];
    [self.closeButton countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"%zdS",second];
        return title;
    }];
    [self.closeButton countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
        countDownButton.enabled = YES;
        return @"跳过";
    }];
}


- (void)enterMainVC {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        [appDelegate displayRootViewControllerForLaunching];
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
