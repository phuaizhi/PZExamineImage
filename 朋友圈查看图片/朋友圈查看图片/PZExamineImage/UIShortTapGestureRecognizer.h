//
//  UIShortTapGestureRecognizer.h
//  tabBarText
//
//  Created by tsb1119 on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
@interface UIShortTapGestureRecognizer : UITapGestureRecognizer
@property(nonatomic,assign)float maxDelay;//延迟时间
@end
