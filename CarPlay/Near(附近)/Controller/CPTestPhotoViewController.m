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
        [self localImageShow:index];
        
        //展示网络图片
        //        [self networkImageShow:index];
    };
}


- (IBAction)showAction:(id)sender {
    
    
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
