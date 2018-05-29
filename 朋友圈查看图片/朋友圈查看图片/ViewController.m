//
//  ViewController.m
//  朋友圈查看图片
//
//  Created by erongchuang on 2018/5/21.
//  Copyright © 2018年 erongchuang. All rights reserved.
//

#import "ViewController.h"
#import "PZExamineImage.h"
#define Wscreen [UIScreen mainScreen].bounds.size.width
#define Hscreen [UIScreen mainScreen].bounds.size.height
@interface ViewController ()
@property (strong,nonatomic)NSMutableArray *imgArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    for (NSInteger i=0; i<4; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20+i*(20+(Wscreen-100)/4), 100, (Wscreen-100)/4, (Wscreen-100)/4)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",i+1]]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(examineShowImageAction:)];
        [imageView addGestureRecognizer:tap];
        imageView.tag = 100+i;
        [self.imgArr addObject:imageView];
        [self.view addSubview:imageView];
    }
    //对空字典取值会发生什么情况
    NSMutableDictionary *testDic = [NSMutableDictionary dictionary];
    NSString *str = [testDic valueForKey:@"111"];
    NSLog(@"test:%@",str);
    NSMutableDictionary *testDic2 = [NSMutableDictionary dictionary];
    [testDic2 setValue:str forKey:@"222"];
    NSLog(@"test2:%@",testDic2);
}
- (void)examineShowImageAction:(UITapGestureRecognizer *)tap
{
    PZExamineImage *examineView = [[PZExamineImage alloc]init];
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *fromFrames = [NSMutableArray array];//图片的frame 用于返回时的效果

    [self.imgArr enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageArray addObject:imageView.image];
        [fromFrames addObject:@([imageView convertRect:imageView.bounds toView:[UIApplication sharedApplication].keyWindow])];//拿到imageView相对于屏幕初始的frame  
    }];
    [examineView showImageWithImgArray:imageArray selectIndex:tap.view.tag-100 imageFrameArr:fromFrames];
}
- (NSMutableArray *)imgArr
{
    if(_imgArr == nil)
    {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
