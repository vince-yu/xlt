//
//  XLTShareFeedMediaDownloadVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTShareFeedMediaDownloadVC.h"
#import "XLTNetworkHelper.h"
#import "UIImage+UIColor.h"

@interface XLTShareFeedMediaDownloadVC ()
@property (nonatomic, weak) IBOutlet UIView *bgView;

@property (nonatomic, weak) IBOutlet UILabel *progressLabel;
@property (nonatomic, weak) IBOutlet UIView *progressBgView;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) UIImageView *progressImageView;

@property (nonatomic, assign) NSUInteger downloadTaskCount;
@property (nonatomic, assign) NSUInteger totalTaskCount;
@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, copy) void(^completeBlock)(NSArray *videoArray, NSArray *imageArray);

@end

@implementation XLTShareFeedMediaDownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.progressBgView.layer.masksToBounds = YES;
    self.progressBgView.layer.cornerRadius = 3.5;
    self.progressBgView.layer.borderWidth = 0.5;
    self.progressBgView.layer.borderColor = [UIColor colorWithHex:0xFFFFFDFD].CGColor;
    
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.cornerRadius = 18;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)updateProgress {
    if(self.progressImageView == nil) {
        self.progressImageView = [[UIImageView alloc] init];
        self.progressImageView.layer.masksToBounds = YES;
        self.progressImageView.layer.cornerRadius = 3.5;
    }
    CGFloat progress = (CGFloat)MIN(self.downloadTaskCount, self.totalTaskCount);
    CGFloat height = 7.0;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = ceilf((progress/self.totalTaskCount)*self.progressBgView.width);
    UIImage *progressImage = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFFFAE01],[UIColor colorWithHex:0xFFFF6E02]] gradientType:1 imgSize:CGSizeMake(width, height)];
    self.progressImageView.image = progressImage;
    self.progressImageView.frame = CGRectMake(x, y, width, height);
    [self.progressBgView addSubview:self.progressImageView];
    self.progressLabel.text = [NSString stringWithFormat:@"已下载%ld/%ld个",(long)MIN(self.downloadTaskCount, self.totalTaskCount), (long)self.totalTaskCount];
}

- (void)downloadMediaWithItemInfo:(id _Nullable )itemInfo complete:(void(^)(NSArray *videoArray, NSArray *imageArray))complete {
    NSArray *images = nil;
    NSArray *videos = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        if ([itemInfo[@"images"] isKindOfClass:[NSArray class]]) {
            images = itemInfo[@"images"];
        }
        if ([itemInfo[@"videos"] isKindOfClass:[NSArray class]]) {
            videos = itemInfo[@"videos"];
        }
    }
    NSMutableArray *mediaArray = [NSMutableArray array];
    if (videos.count) {
        [mediaArray addObjectsFromArray:videos];
    }
    if (images.count) {
        [mediaArray addObjectsFromArray:images];
    }
    if (mediaArray.count > 0) {
        self.totalTaskCount = mediaArray.count;
        self.downloadTaskCount = 0;
        self.imageArray = [NSMutableArray array];
        self.videoArray = [NSMutableArray array];
        [self downloadVideos:videos complete:complete];
        [self downloadImages:images complete:complete];
    } else {
        [self showTipMessage:Data_Error];
    }
    self.progressLabel.text = [NSString stringWithFormat:@"已下载%ld/%ld个",(long)MIN(self.downloadTaskCount, self.totalTaskCount), (long)self.totalTaskCount];
    self.completeBlock = complete;
}

- (void)downloadImages:(NSArray *)imageUrls complete:(void(^)(NSArray *videoArray, NSArray *imageArray))complete {
    if (imageUrls.count > 0) {
        __weak typeof(self)weakSelf = self;
        [imageUrls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *imageUrl = (NSString *)obj;
            if ([imageUrl isKindOfClass:[NSString class]]) {
                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[imageUrl letaoConvertToHttpsUrl]] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (image && !error) {
                            [weakSelf.imageArray addObject:image];
                        }
                        [weakSelf increaseOneTask];
                    });
                }];
            } else {
                [weakSelf increaseOneTask];
            }

        }];
    }
}

- (void)downloadVideos:(NSArray *)videosUrls complete:(void(^)(NSArray *videoArray, NSArray *imageArray))complete{
    if (videosUrls.count > 0) {
        __weak typeof(self)weakSelf = self;
        [videosUrls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *videosUrl = (NSString *)obj;
            if ([videosUrl isKindOfClass:[NSString class]]) {
                [XLTNetworkHelper downloadWithURL:[videosUrl letaoConvertToHttpsUrl] fileDir:nil progress:nil success:^(NSString *filePath) {
                    if (filePath) {
                        [weakSelf.videoArray addObject:filePath];
                    }
                    [weakSelf increaseOneTask];
                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                    [weakSelf increaseOneTask];
                }];
            } else {
                [weakSelf increaseOneTask];
            }
        }];
    }
}


- (void)increaseOneTask {
    self.downloadTaskCount ++;
    [self updateProgress];
    if (self.downloadTaskCount >= self.totalTaskCount) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self completeTask];
        });
       
    }
}

- (void)completeTask {    
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.completeBlock) {
            self.completeBlock(self.videoArray,self.imageArray);
            self.completeBlock = nil;
        }
    }];

}


- (void)letaoPresentWithSourceVC:(UIViewController *)sourceViewController downloadMediaWithItemInfo:(id _Nullable )itemInfo complete:(void(^)(NSArray *videoArray, NSArray *imageArray))complete {
    self.view.hidden = YES;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sourceViewController.definesPresentationContext = YES;
    [sourceViewController presentViewController:self animated:NO completion:^{
        self.view.hidden = NO;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.bgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
             self.bgView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
        [self downloadMediaWithItemInfo:itemInfo complete:complete];
    }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)cancelDownloadAction:(id)sender {
    [self dismiss];
    self.completeBlock = nil;
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
