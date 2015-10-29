//
//  ZYDownloadImageOperation.h
//  CarPlay
//
//  Created by chewan on 10/28/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ZYFinishBlock) (UIImage *image);
@interface ZYDownloadImageOperation : NSOperation

/**
 *  下载图片的一个operation
 *
 *  @param completion 完成图片回调
 */
+ (void)downloadImageWithUrl:(NSString *)url completion:(ZYFinishBlock)finish;

@end
