//
//  CPMyViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/25.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyViewController.h"
#import "CPLoginViewController.h"
#import "CPMyInfoController.h"
#import "CPNavigationController.h"

@interface CPMyViewController ()

@end

@implementation CPMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightNavigationBarItemWithTitle:nil Image:@"设置" highImage:@"设置" target:self action:@selector(rightClick)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma privateMethod
-(void)rightClick{
    CPLoginViewController *login = [UIStoryboard storyboardWithName:@"CPLoginViewController" bundle:nil].instantiateInitialViewController;
//    [self.navigationController pushViewController:login animated:YES];
    CPNavigationController *nav=[[CPNavigationController alloc]initWithRootViewController:login];
    self.view.window.rootViewController = nav;
    [self.view.window makeKeyAndVisible];
//    self.view.window
//    CPMyInfoController *myInfoVC = [UIStoryboard storyboardWithName:@"CPMyInfoController" bundle:nil].instantiateInitialViewController;
//    [self.navigationController pushViewController:myInfoVC animated:YES];
}

@end
