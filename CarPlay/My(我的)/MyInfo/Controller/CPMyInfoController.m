//
//  CPMyInfoController.m
//  CarPlay
//
//  Created by 公平价 on 15/10/12.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyInfoController.h"

@interface CPMyInfoController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@end

@implementation CPMyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"个人信息";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNorImage:nil higImage:nil title:@"完成" target:self action:@selector(finish)];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.view.backgroundColor=[Tools getColor:@"efefef"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        NSString *str = @"1990年01月01号";
        fmt.dateFormat = @"yyyy年MM月dd号";
        NSDate *defualtDate = [fmt dateFromString:str];
        _pickview=[[ZHPickView alloc] initDatePickWithDate:defualtDate datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
        _pickview.delegate=self;
        [_pickview show];
    }
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日";
    NSDate *brithDay=[[NSDate alloc]initWithTimeIntervalSinceNow:[resultString doubleValue]];
    NSString * dateToString = [fmt stringFromDate:brithDay];
    self.brithDay.text=dateToString;
    long age=[resultString longLongValue];
}

- (void)finish{
    NSLog(@"完成");
}
- (IBAction)headIconBtnClick:(id)sender {
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",nil];
    [sheet showInView:self.view];
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
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            DLog(@"相机不可用");
            return;
        }
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
    UIImage *editedImage=[info objectForKey:UIImagePickerControllerEditedImage];
    [self.userHeadIcon setImage:editedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSData *data=UIImageJPEGRepresentation(editedImage, 0.4);
//        [self upLoadImageWithBase64Encodeing:data];
        
    }];
    
//    editedImage=[info objectForKey:UIImagePickerControllerEditedImage];
//    [self.userIconBtn setImage:editedImage forState:UIControlStateNormal];
//    [picker dismissViewControllerAnimated:YES completion:^{
//        NSData *data=UIImageJPEGRepresentation(editedImage, 0.4);
//        [self upLoadImageWithBase64Encodeing:data];
//        
//    }];
}

-(void)upLoadImageWithBase64Encodeing:(NSData *)encodedImageData{
    ZYHttpFile *file=[[ZYHttpFile alloc]init];
    file.name=@"photo";
    file.data=encodedImageData;
    file.filename=@"avatar.jpg";
    file.mimeType=@"image/jpeg";
    NSArray *files=[[NSArray alloc]initWithObjects:file, nil];
//    [ZYNetWorkTool postFileWithUrl:@"v1/avatar/upload" params:nil files:files success:^(id responseObject){
//        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
//        NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
//        if ([state isEqualToString:@"0"]) {
//            NSDictionary *data=[responseObject objectForKey:@"data"];
//            [Tools setValueForKey:[data objectForKey:@"photoId"] key:@"photoId"];
//            [Tools setValueForKey:[data objectForKey:@"photoUrl"] key:@"photoUrl"];
//            if (organizer) {
//                organizer.headImgUrl=[data objectForKey:@"photoUrl"];
//                organizer.headImgId =[data objectForKey:@"photoId"];
//                [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
//            }else{
//                CPOrganizer *organizer1=[[CPOrganizer alloc]init];
//                organizer1.headImgUrl=[data objectForKey:@"photoUrl"];
//                organizer1.headImgId = [data objectForKey:@"photoId"];
//                [NSKeyedArchiver archiveRootObject:organizer1 toFile:CPDocmentPath(fileName)];
//            }
//            [self.userIconBtn setImage:editedImage forState:UIControlStateNormal];
//        }else{
//            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败，请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//        }
//    }failure:^(NSError *erro){
//        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//    }];
}
@end
