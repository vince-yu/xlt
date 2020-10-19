//
//  XLTStreetTabBarController.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTStreetTabBarController.h"
#import "XLTHotOnlineViewController.h"
#import "XLTFineGoodsViewController.h"
#import "XLTFineShopViewController.h"
#import "XLTBigVViewController.h"

@interface XLTStreetTabBarController ()<UITabBarControllerDelegate>

@end

@implementation XLTStreetTabBarController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.letaoCurrentPlateId = kPlateRedCode;
        self.tabBar.translucent = NO;
        [self setupTabBar];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setupTabBar{
    XLTHotOnlineViewController *explosionViewController = [[XLTHotOnlineViewController alloc] init];
    explosionViewController.letaoParentPlateId = self.letaoCurrentPlateId;
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc]initWithTitle:@"网红爆款" image:[[UIImage imageNamed:@"xinletao_street_tab_explosion"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"xinletao_street_tab_explosion_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self letaoSetupTitleColorForTabBarItem:homeTabBarItem];
    explosionViewController.tabBarItem = homeTabBarItem;

    // 分类
    XLTBigVViewController *bigVViewController = [[XLTBigVViewController alloc] init];
    bigVViewController.letaoParentPlateId = self.letaoCurrentPlateId;

    UITabBarItem *categoryTabBarItem = [[UITabBarItem alloc]initWithTitle:@"大V推荐" image:[[UIImage imageNamed:@"xinletao_street_tab_bigv"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"xinletao_street_tab_bigv_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self letaoSetupTitleColorForTabBarItem:categoryTabBarItem];
    bigVViewController.tabBarItem = categoryTabBarItem;

    //
    /*
    XLTRedShopViewController *redShopViewController = [[XLTRedShopViewController alloc] init];
    redShopViewController.letaoParentPlateId = self.letaoCurrentPlateId;

    UITabBarItem *redShopTabBarItem = [[UITabBarItem alloc]initWithTitle:@"网红店" image:[[UIImage imageNamed:@"xinletao_street_tab_redshop"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"xinletao_street_tab_redshop_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self setupTitleColorAttributesForTabBarItem:redShopTabBarItem];
    redShopViewController.tabBarItem = redShopTabBarItem;
     */
    // 好物说
    XLTFineGoodsViewController *goodThingViewController = [[XLTFineGoodsViewController alloc] init];
    goodThingViewController.letaoParentPlateId = self.letaoCurrentPlateId;
    UITabBarItem *mineTabBarItem = [[UITabBarItem alloc]initWithTitle:@"好物说" image:[[UIImage imageNamed:@"xinletao_street_tab_goodthing"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"xinletao_street_tab_goodthing_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self letaoSetupTitleColorForTabBarItem:mineTabBarItem];
    goodThingViewController.tabBarItem = mineTabBarItem;

    self.delegate = self;
    if (@available(iOS 10.0, *)) {
        [self.tabBar setUnselectedItemTintColor:[UIColor colorWithHex:0xFF1F0B10]];
    } else {
        // Fallback on earlier versions
    }
    self.viewControllers = @[explosionViewController,
                             bigVViewController,
//                             redShopViewController,
                             goodThingViewController];
    
}
- (void)letaoSetupTitleColorForTabBarItem:(UITabBarItem *)tabBarItem {
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0xFF1F0B10], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor letaomainColorSkinColor], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
   
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
