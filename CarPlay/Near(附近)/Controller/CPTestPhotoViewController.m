//
//  CPTestPhotoViewController.m
//  CarPlay
//
//  Created by chewan on 9/28/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPTestPhotoViewController.h"

#import "PhotoBroswerVC.h"
#import "PhotoCotentView.h"


@interface CPTestPhotoViewController ()

@property (strong, nonatomic) PhotoCotentView *contentView;

@property (nonatomic,strong) NSArray *images;

@end

@implementation CPTestPhotoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //展示数据
    [self contentViewDataPrepare];
    
    //事件
    [self event];
}


/** 展示数据 */
-(void)contentViewDataPrepare{
    
    self.contentView = [PhotoCotentView new];
    self.contentView.frame = self.view.bounds;
    [self.view addSubview:self.contentView];
    _contentView.images =self.images;
}



/** 事件 */
-(void)event{
    ZYWeakSelf
    _contentView.ClickImageBlock = ^(NSUInteger index){
        ZYStrongSelf
        //本地图片展示
//        [self localImageShow:index];
        
        //展示网络图片
                [self networkImageShow:index];
    };
}


- (IBAction)showAction:(id)sender {
    
    
}
/*
 *  展示网络图片
 */
-(void)networkImageShow:(NSUInteger)index{
    
    
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self userId:CPUserId type:PhotoBroswerVCTypePush index:index photoModelBlock:^NSArray *{
        
        
        NSArray *networkImages=@[
                                 @"http://www.netbian.com/d/file/20150519/f2897426d8747f2704f3d1e4c2e33fc2.jpg",
                                 @"http://www.netbian.com/d/file/20130502/701d50ab1c8ca5b5a7515b0098b7c3f3.jpg",
                                 @"http://www.netbian.com/d/file/20110418/48d30d13ae088fd80fde8b4f6f4e73f9.jpg",
                                 @"http://www.netbian.com/d/file/20150318/869f76bbd095942d8ca03ad4ad45fc80.jpg",
                                 @"http://www.netbian.com/d/file/20110424/b69ac12af595efc2473a93bc26c276b2.jpg",
                                 
                                 @"http://www.netbian.com/d/file/20140522/3e939daa0343d438195b710902590ea0.jpg",
                                 
                                 @"http://www.netbian.com/d/file/20141018/7ccbfeb9f47a729ffd6ac45115a647a3.jpg",
                                 
                                 @"http://www.netbian.com/d/file/20140724/fefe4f48b5563da35ff3e5b6aa091af4.jpg",
                                 
                                 @"http://www.netbian.com/d/file/20140529/95e170155a843061397b4bbcb1cefc50.jpg"
                                 ];
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
            pbModel.desc = [NSString stringWithFormat:@"我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字%@",@(i+1)];
            pbModel.image_HD_U = networkImages[i];
            
            //源frame
            UIImageView *imageV =(UIImageView *) weakSelf.contentView.subviews[i];
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}

/*
 *  本地图片展示
 */
-(void)localImageShow:(NSUInteger)index{
    
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self userId:CPUserId type:PhotoBroswerVCTypePush index:index photoModelBlock:^NSArray *{
        
        NSArray *localImages = weakSelf.images;
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:localImages.count];
        for (NSUInteger i = 0; i< localImages.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            //            pbModel.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
            //            pbModel.desc = [NSString stringWithFormat:@"我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字%@",@(i+1)];
            pbModel.image = localImages[i];
            
            //源frame
            //            UIImageView *imageV =(UIImageView *) weakSelf.contentView.subviews[i];
            //            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}

-(NSArray *)images{
    
    if(_images ==nil){
        NSMutableArray *arrayM = [NSMutableArray array];
        
        for (NSUInteger i=0; i<9; i++) {
            
            UIImage *imagae =[UIImage imageNamed:[NSString stringWithFormat:@"%@",@(i+1)]];
            
            [arrayM addObject:imagae];
        }
        
        _images = arrayM;
    }
    
    return _images;
}

@end
