//
//  CPSettingController.m
//  CarPlay
//
//  Created by 公平价 on 15/10/15.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPSettingController.h"
#import "CPMyBaseCell.h"
#import "CPAbout.h"
#import "CPVersionIntroduction.h"
#import "CPLoginViewController.h"
#import "CPNavigationController.h"
#import "SDImageCache.h"
#import "UIImageView+AFNetworking.h"

@interface CPSettingController ()<UIAlertViewDelegate>
{
    NSArray *titleArray;
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation CPSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    titleArray=[[NSArray alloc]initWithObjects:@"清理缓存",@"喜欢我们打分鼓励",@"关于我们",@"版本介绍",@"当前版本", nil];
    [self.loginOutBtn.layer setMasksToBounds:YES];
    [self.loginOutBtn.layer setCornerRadius:20.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"CPMyBaseCell";
    CPMyBaseCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPMyBaseCell" owner:nil options:nil] lastObject];
    }
    cell.icon.image=[UIImage imageNamed:[titleArray objectAtIndex:indexPath.row]];
    cell.titleLable.text=[titleArray objectAtIndex:indexPath.row];
    if (indexPath.row==0) {
        float totalSize = [[SDImageCache sharedImageCache] getSize];
        cell.valueLable.text=[[NSString alloc]initWithFormat:@"%.2fM",totalSize/1024/1024];
        UIFont *font = [UIFont systemFontOfSize:16.0f];
        //设置一个行高上限
        CGSize size = CGSizeMake(ZYScreenWidth,20);
        //计算实际frame大小，并将label的frame变成实际大小
        CGSize labelsize = [[titleArray objectAtIndex:indexPath.row] sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        cell.titleLableWidth.constant=labelsize.width;
        activityIndicator.center=CGPointMake(cell.titleLable.left+labelsize.width+20, 26.0f);
        [cell addSubview:activityIndicator];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [activityIndicator startAnimating];
        [(NSCache *)[UIImageView sharedImageCache] removeAllObjects];
        
        ZYAsyncOperation(^{
            NSString *afCachePath = [NSString stringWithFormat:@"%@/fsCachedData",BundleId].cachePath;
            
            BOOL comple = [[NSFileManager defaultManager] removeItemAtPath:afCachePath error:nil];
            if (comple) {
                ZYMainOperation(^{
                    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                        [self.tableview reloadData];
                        [SVProgressHUD showImage:[UIImage imageNamed:@"清理成功"] status:@"清理成功"];
                        
                        [activityIndicator stopAnimating];
                    }];

                });
            }
        });
           }else if (indexPath.row==1){
        NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d", 1034646246];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }else if (indexPath.row == 2){
        CPAbout *CPAbout=[UIStoryboard storyboardWithName:@"CPAbout" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:CPAbout animated:YES];
    }else{
        CPVersionIntroduction *CPVersionIntroduction=[UIStoryboard storyboardWithName:@"CPVersionIntroduction" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:CPVersionIntroduction animated:YES];
    }
}


- (IBAction)loginOut:(id)sender {
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否注销当前账号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注销", nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            if (error) {
                [self showInfo:@"退出失败，请稍后重试"];
            }
            else{
                //注销成功之后清理useid和token
        
                [ZYUserDefaults setObject:nil forKey:Token];
                [ZYUserDefaults setObject:nil forKey:UserId];
                
                // 清楚图片缓存和筛选条件
                [[NSFileManager defaultManager] removeItemAtPath:CPSelectModelFilePath error:NULL];
                [[SDImageCache sharedImageCache]  clearMemory];
                [[SDImageCache sharedImageCache] cleanDisk];
                CPLoginViewController *login = [UIStoryboard storyboardWithName:@"CPLoginViewController" bundle:nil].instantiateInitialViewController;
                CPNavigationController *nav=[[CPNavigationController alloc]initWithRootViewController:login];
                [self.navigationController popViewControllerAnimated:NO];
                self.view.window.rootViewController = nav;
                [self.view.window makeKeyAndVisible];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DID_LOG_OUT_SUCCESS" object:nil];
            }
        } onQueue:nil];
        
    }
}
@end
