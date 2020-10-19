//
//  XLTFullScreenVideoVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTFullScreenVideoVC.h"


@interface XLTFullScreenVideoVC ()
@property (nonatomic, strong) IBOutlet UIView *letaoDetailVideoView;

@end

@implementation XLTFullScreenVideoVC


- (void)dealloc {
    [self.letaoDetailVideoView jp_stopPlay];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}



- (BOOL)shouldAutoReplayForURL:(nonnull NSURL *)videoURL {
    return NO;
}



- (BOOL)shouldResumePlaybackWhenApplicationDidBecomeActiveFromBackgroundForURL:(NSURL *)videoURL {
    return NO;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.letaoVideoUrl != nil) {
        [self.letaoDetailVideoView jp_playVideoWithURL:[NSURL URLWithString:self.letaoVideoUrl]
                                 bufferingIndicator:nil
                                        controlView:nil
                                       progressView:nil
                                      configuration:nil];
        self.letaoDetailVideoView.jp_videoPlayerDelegate = (id)self;
          self.letaoDetailVideoView.jp_progressView.tintColor = [UIColor letaomainColorSkinColor];
    }

}

- (IBAction)letaoLeftButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
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
