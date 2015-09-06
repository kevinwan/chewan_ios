//
//  CPEditInfoTableViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPEditInfoTableViewController.h"
#import "CPEditHeadIconCell.h"
#import "CPRegisterCellsTableViewCell3.h"
#import "ZHPickView.h"
#import "CPEditUsernameViewController.h"
#import "CPMySubscribeModel.h"
#import "UIImage+Extension.h"

@interface CPEditInfoTableViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,ZHPickViewDelegate>
{
    NSString *photoId;
    int brithYear;
    int birthMonth;
    int birthDay;
    CPOrganizer *organizer;
    NSString *fileName;
    UIImage *editedImage;
}
@end

@implementation CPEditInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    fileName=[[NSString alloc]initWithFormat:@"%@.data",[Tools getValueFromKey:@"userId"]];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [UIApplication sharedApplication].keyWindow.backgroundColor=[UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePickview) name:@"remove" object:nil];
    self.tableView.bounces=NO;
}

-(void)viewWillAppear:(BOOL)animated{
    if (![Tools getValueFromKey:@"userId"]) {
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
    }else{
        organizer=[NSKeyedUnarchiver unarchiveObjectWithFile:CPDocmentPath(fileName)];
        [self.tableView reloadData];
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.pickview removeFromSuperview];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([Tools getValueFromKey:@"userId"]) {
        return 1;
    }else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier1=@"CPEditHeadIconCell";
    static NSString *cellIdentifier2=@"CPRegisterCellsTableViewCell3";
    if (indexPath.row==0) {
        CPEditHeadIconCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CPEditHeadIconCell" owner:nil options:nil] lastObject];
        }
        if (organizer.photo) {
            NSURL *url=[[NSURL alloc]initWithString:organizer.photo];
            [cell.headIcon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"morenHeadBtnImg"]];
            [cell.headIcon setImageWithURL:url];
        }
        
        return cell;
    }else{
        CPRegisterCellsTableViewCell3 *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CPRegisterCellsTableViewCell3" owner:nil options:nil] lastObject];
        }
        

        NSString *nickname=organizer.nickname;
        NSString *gender=organizer.gender;
        NSString *drivingExperience=[[NSString alloc]initWithFormat:@"%ld年",(long)organizer.drivingExperience];
        NSString *city=organizer.city;
        NSString *district=organizer.district;
        
        if (indexPath.row==1) {
            cell.cellTitle.text=@"昵称";
            cell.cellContent.text=nickname;
        }else if (indexPath.row==2){
            cell.cellTitle.text=@"性别";
            cell.cellContent.text=gender;
            [cell.arrowImgView setHidden:YES];
            cell.cellContentRight.constant = -17.0f;
        }else if (indexPath.row==3){
            cell.cellTitle.text=@"驾龄";
            cell.cellContent.text=drivingExperience;
            [cell.arrowImgView setHidden:YES];
            cell.cellContentRight.constant = -17.0f;
        }else if (indexPath.row==4){
            cell.cellTitle.text=@"地区";
            cell.cellContent.text=[[NSString alloc]initWithFormat:@"%@ %@",city,district];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",nil];
        [sheet showInView:self.view];
    }else if (indexPath.row==1) {
        CPEditUsernameViewController *CPEditUsernameVC=[[CPEditUsernameViewController alloc]init];
        CPEditUsernameVC.title=@"昵称";
        CPEditUsernameVC.organizer = organizer;
        [self.navigationController pushViewController:CPEditUsernameVC animated:YES];
        //        [self presentViewController:CPEditUsernameVC animated:YES completion:nil];
    }else{
        [_pickview remove];
        _indexPath=indexPath;
        CPRegisterCellsTableViewCell3 *cell=(CPRegisterCellsTableViewCell3 *)[tableView cellForRowAtIndexPath:indexPath];
        //开始动画
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:.3];
        //动画的内容
        cell.arrowImgView.transform = CGAffineTransformMakeRotation(M_PI_2);
        //动画结束
        [UIView commitAnimations];
//        if (indexPath.row==2) {
//            _pickview=[[ZHPickView alloc] initPickviewWithArray:@[@"男", @"女"] isHaveNavControler:NO];
//            _pickview.delegate=self;
//            [_pickview show];
//            CGRect frame=self.tableView.frame;
//            frame.size.height=SCREEN_HEIGHT-_pickview.height;
//            [self.tableView setFrame:frame];
//            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
//        }else if (indexPath.row==3) {
//            _pickview=[[ZHPickView alloc] initPickviewWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20"] isHaveNavControler:NO];
//            _pickview.delegate=self;
//            [_pickview show];
//            CGRect frame=self.tableView.frame;
//            frame.size.height=SCREEN_HEIGHT-_pickview.height;
//            [self.tableView setFrame:frame];
//            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
       if (indexPath.row==4) {
            _pickview=[[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
            _pickview.delegate=self;
            [_pickview show];
            CGRect frame=self.tableView.frame;
            frame.size.height=SCREEN_HEIGHT-_pickview.height;
            [self.tableView setFrame:frame];
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
        }
    }
}

#pragma actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==1) {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else if (buttonIndex == 0){
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else
        return;
}

#pragma PickerController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    editedImage=[info objectForKey:UIImagePickerControllerEditedImage];
//    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    
//    CPEditHeadIconCell *cell=(CPEditHeadIconCell *)[self.tableView cellForRowAtIndexPath:index];
//    [cell.headIcon setImage:editedImage];
//    [self.tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSData *data=UIImageJPEGRepresentation(editedImage, 0.4);
        [self upLoadImageWithBase64Encodeing:data];
    }];
}

-(void)upLoadImageWithBase64Encodeing:(NSData *)encodedImageData{
    ZYHttpFile *file=[[ZYHttpFile alloc]init];
    file.name=@"photo";
    file.data=encodedImageData;
    file.filename=@"avatar.jpg";
    file.mimeType=@"image/jpeg";
    NSArray *files=[[NSArray alloc]initWithObjects:file, nil];
    [self showLoadingWithInfo:@"加载中…"];
    NSString *path=[[NSString alloc]initWithFormat:@"v1/user/%@/avatar?token=%@",[Tools getValueFromKey:@"userId"],[Tools getValueFromKey:@"token"]];
    [ZYNetWorkTool postFileWithUrl:path params:nil files:files success:^(id responseObject){
        [self disMiss];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
        if ([state isEqualToString:@"0"]) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            CPEditHeadIconCell *cell=(CPEditHeadIconCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            NSDictionary *data=[responseObject objectForKey:@"data"];
            [Tools setValueForKey:[data objectForKey:@"photoId"] key:@"photoId"];
            [Tools setValueForKey:[data objectForKey:@"photoUrl"] key:@"photoUrl"];
            [Tools setValueForKey:data[@"photoUrl"] key:@"headUrl"];
            
            [[SDImageCache sharedImageCache]clearMemory];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                
                [cell.headIcon sd_setImageWithURL:[data objectForKey:@"photoUrl"]];
                EMChatCommand *cmdChat = [[EMChatCommand alloc] init];
                cmdChat.cmd = @"updateAvatar";
                EMCommandMessageBody *body = [[EMCommandMessageBody alloc] initWithChatObject:cmdChat];
                // 生成message
                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                for (EMGroup *group in groupArray) {
                    EMMessage *message = [[EMMessage alloc] initWithReceiver:group.groupId bodies:@[body]];
                    message.ext=[[NSDictionary alloc]initWithObjectsAndKeys:[data objectForKey:@"photoUrl"],@"headUrl", nil];
                    message.messageType = eConversationTypeGroupChat;// 设置为群聊消息
                    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];
                }
                
                organizer.headImgUrl = [data objectForKey:@"photoUrl"];
                organizer.headImgId = data[@"photoId"];
                organizer.photo = data[@"photoUrl"];
                [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
            }];
//            [[SDImageCache sharedImageCache] removeImageForKey:[data objectForKey:@"photoUrl"]];
//            [[SDImageCache sharedImageCache] clearMemory];
//            [[SDImageCache sharedImageCache] removeImageForKey:[data objectForKey:@"photoUrl"] fromDisk:YES withCompletion:^(SDWebImageNoParamsBlock *completion){
//                [[SDImageCache sharedImageCache] storeImage:editedImage forKey:[data objectForKey:@"photoUrl"] toDisk:YES];
//                [[SDImageCache sharedImageCache] storeImage:editedImage forKey:[data objectForKey:@"photoUrl"]];
//                [cell.headIcon sd_setImageWithURL:[data objectForKey:@"photoUrl"]];
//                EMChatCommand *cmdChat = [[EMChatCommand alloc] init];
//                cmdChat.cmd = @"updateAvatar";
//                EMCommandMessageBody *body = [[EMCommandMessageBody alloc] initWithChatObject:cmdChat];
//                // 生成message
//                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//                for (EMGroup *group in groupArray) {
//                    EMMessage *message = [[EMMessage alloc] initWithReceiver:group.groupId bodies:@[body]];
//                    message.ext=[[NSDictionary alloc]initWithObjectsAndKeys:[data objectForKey:@"photoUrl"],@"headUrl", nil];
//                    message.messageType = eConversationTypeGroupChat;// 设置为群聊消息
//                    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];
//                }
//                
//                organizer.headImgUrl = [data objectForKey:@"photoUrl"];
//                organizer.headImgId = data[@"photoId"];
//                organizer.photo = data[@"photoUrl"];
//                [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
//            }];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败，请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }failure:^(NSError *erro){
        [self disMiss];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
}

-(void)removePickview{
    CGRect frame=self.tableView.frame;
    frame.size.height=SCREEN_HEIGHT;
    [self.tableView setFrame:frame];
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    CPRegisterCellsTableViewCell3 * cell=(CPRegisterCellsTableViewCell3 *)[self.tableView cellForRowAtIndexPath:_indexPath];
    if (_indexPath.row==2) {
        NSDictionary *paras=[[NSDictionary alloc]initWithObjectsAndKeys:resultString,@"gender", nil];
        [self updataUserInfo:paras];
    }else if (_indexPath.row==3) {
        NSDictionary *paras=[[NSDictionary alloc]initWithObjectsAndKeys:@([resultString intValue]),@"drivingExperience", nil];
        [self updataUserInfo:paras];
    }else{
        NSArray *array = [resultString componentsSeparatedByString:@","];
        NSDictionary *paras=[[NSDictionary alloc]initWithObjectsAndKeys:[array objectAtIndex:0],@"province",[array objectAtIndex:1],@"city",[array objectAtIndex:2],@"district", nil];
        [self updataUserInfo:paras];
    }
    //开始动画
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:.3];
    //动画的内容
    cell.arrowImgView.transform = CGAffineTransformMakeRotation(0);
    //动画结束
    [UIView commitAnimations];
}

-(void)updataUserInfo:(NSDictionary *)paras{
    NSString *path=[[NSString alloc]initWithFormat:@"v1/user/%@/info?token=%@",[Tools getValueFromKey:@"userId"],[Tools getValueFromKey:@"token"]];
     [self showLoadingWithInfo:@"加载中…"];
    [ZYNetWorkTool postJsonWithUrl:path params:paras success:^(id responseObject) {
        [self disMiss];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
        if ([state isEqualToString:@"0"]) {

            
            if ([paras objectForKey:@"drivingExperience"]) {
                organizer.drivingExperience =[paras[@"drivingExperience"] integerValue];
            }

            if ([paras objectForKey:@"province"]) {
                organizer.province = paras[@"province"];
            }
            
            if ([paras objectForKey:@"city"]) {
                organizer.city = paras[@"city"];
            }
            
            if ([paras objectForKey:@"district"]) {
                organizer.district = paras[@"district"];
            }

            [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
            [self.tableView reloadData];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败，请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    } failed:^(NSError *error) {
        [self disMiss];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
}

@end
