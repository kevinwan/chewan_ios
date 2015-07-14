//
//  HWPhotoView.m
//  3期微博
//
//  Created by apple on 14/12/31.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWPhotoView.h"
//#import "UIImageView+WebCache.h"
//#import "HWPicUrl.h"

@interface HWPhotoView()
@property (nonatomic, weak)  UIImageView *gifIv;
@end

@implementation HWPhotoView
/**
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 创建gif图片
        UIImageView *gifIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif"]];
        [self addSubview:gifIv];
        self.gifIv = gifIv;
        
        // 设置当前控件的图片的内容模式
        self.contentMode =  UIViewContentModeScaleAspectFill;
        // 剪切掉超出内容的部分
        self.clipsToBounds = YES;
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setPicUrl:(HWPicUrl *)picUrl
{
    _picUrl = picUrl;
    
    NSURL *url = [NSURL URLWithString:_picUrl.thumbnail_pic];
//    NSLog(@"%@", _picUrl.thumbnail_pic.pathExtension);
    // 判断是否是gif图片
    // http://ww2.sinaimg.cn/bmiddle/70e0a133gw1ensv7eodupg208p05kkjl.gif
    // http://ww2.sinaimg.cn/bmiddle/70e0a133gw1ensv7eodupg208p05kkjl.GIF
//    if ([_picUrl.thumbnail_pic.lowercaseString hasSuffix:@".gif"])
    if ([_picUrl.thumbnail_pic.pathExtension.lowercaseString isEqualToString:@"gif"]) {
    
    
        // 是gif图片
        self.gifIv.hidden = NO;
    }else
    {
        self.gifIv.hidden = YES;
    }
    
    // 下载图片
     [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifIv.y = self.height - self.gifIv.height;
    self.gifIv.x = self.width - self.gifIv.width;
}*/
@end
