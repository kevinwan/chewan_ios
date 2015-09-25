//
//  AppDelegate.m
//  CarPlay
//
//  Created by chewan on 15/9/19.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "AppDelegate.h"
#import "CPTabBarController.h"
#import "Aspects.h"
#import "CPMyCareController.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CPTabBarController *tabVc = [CPTabBarController new];
    tabVc.delegate = self;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = tabVc;
    
    [self.window makeKeyAndVisible];
    
    [self setViewCycleAop];
    
    return YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    UINavigationController *nav = (UINavigationController *)viewController;
//    if ([nav.childViewControllers.firstObject isKindOfClass:[CPMyCareController class]]) {
//        return CPIsLogin?YES:NO;
//    }
    return YES;
}

- (void)setViewCycleAop
{
    
    [UIViewController aspect_hookSelector:NSSelectorFromString(@"viewDidLoad") withOptions:AspectPositionAfter usingBlock:^(id info){

        if (![[info instance] isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
            
            NSLog(@"%@viewDidLoad..",[[info instance] class]);
        }
        
    }error:NULL];
    /**
    [UIViewController aspect_hookSelector:NSSelectorFromString(@"viewWillDisappear:") withOptions:AspectPositionBefore usingBlock:^(id info){
        
        if (![[info instance] isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
            
            NSLog(@"%@viewWillDisappear..",[[info instance] class]);
        }
    }error:NULL];
    
    [UIViewController aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id info){
        
        if (![[info instance] isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
            NSLog(@"%@ dealloc..",[[info instance] class]);
        }
    }error:NULL];
     */
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
