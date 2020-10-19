//
//  XLTArticleDetailViewController.m
//  XingLeTao
//
//  Created by chenhg on 2020/2/18.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTArticleDetailViewController.h"

@interface XLTArticleDetailViewController ()

@end

@implementation XLTArticleDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoconfigRightBarItemWithImage:[UIImage imageNamed:@"nav_share_icon"] target:self action:@selector(shareAction:)];
}

- (void)shareAction:(id) sender {
    NSDictionary *info = self.articleInfo;
    NSString *title = nil;
    NSString *content = nil;
    NSString *url = nil;
    NSString *cover_image = nil;
    if ([info isKindOfClass:[NSDictionary class]]) {
        title = info[@"title"];
        url = info[@"jump_url"];
        if ([info[@"cover_image"] isKindOfClass:[NSString class]]) {
            cover_image = info[@"cover_image"];
        }
    }
     __weak typeof(self)weakSelf = self;
    if (cover_image) {
        [self letaoShowLoading];
        [self downloadImage:cover_image complete:^(UIImage * _Nullable image) {
            [weakSelf letaoRemoveLoading];
            [weakSelf startShareWithTitle:title content:content image:image url:url];
        }];
    } else {
         [self startShareWithTitle:title content:content image:nil url:url];
    }
}

- (void)startShareWithTitle:(NSString *)title content:(NSString *)content image:(UIImage *)image url:(NSString *)url {
    if (title || content || url || image) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        NSMutableArray *textArray = [NSMutableArray array];
        if (title) {
            [textArray addObject:title];
        }
        if (content) {
            [textArray addObject:content];
        }
        if ([textArray count] > 0) {
            [items addObject:[NSString stringWithFormat:@"%@",[textArray componentsJoinedByString:@""]]];
        }
        if (url) {
            NSURL *shareUrl = [NSURL URLWithString:url];
            if (shareUrl) {
                [items addObject:shareUrl];
            }
        }
        if (image) {
            [items addObject:image];
        }
        if (items) {
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:[XLTGoodsDisplayHelp processSizeForShareActivityItems:items goodsImage:nil] applicationActivities:nil];
            [self.navigationController presentViewController:activityVC animated:TRUE completion:nil];
        }
    }
}


- (void)downloadImage:(NSString *)imageUrl complete:(void(^)(UIImage * _Nullable image))complete {
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image && !error) {
                complete(image);;
            } else {
               complete(nil);
            }
        });
    }];
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
