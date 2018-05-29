//
//  PZExamineImage.h
//  朋友圈查看图片
//
//  Created by erongchuang on 2018/5/21.
//  Copyright © 2018年 erongchuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZExamineImage : UIView

- (void)showImageWithImgArray:(NSArray *)imgArr selectIndex:(NSInteger)index imageFrameArr:(NSArray *)frameArr;
@end
