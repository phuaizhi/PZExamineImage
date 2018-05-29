//
//  AppDelegate.h
//  朋友圈查看图片
//
//  Created by erongchuang on 2018/5/21.
//  Copyright © 2018年 erongchuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

