//
//  AppDelegate.m
//  OnePai
//
//  Created by HuaLaLa on 2021/10/25.
//

#import "AppDelegate.h"
#import "XZCameraViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController * rootTabBarVC = [[UINavigationController alloc] initWithRootViewController:[XZCameraViewController new]];
    self.window.rootViewController = rootTabBarVC;

    [self.window makeKeyAndVisible];
    
    if (@available(iOS 15.0, *)) {
        [UITableView appearance].sectionHeaderTopPadding = 0;
    }
    
    return YES;
}

@end
