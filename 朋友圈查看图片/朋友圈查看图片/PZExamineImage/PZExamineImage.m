//
//  PZExamineImage.m
//  朋友圈查看图片
//
//  Created by erongchuang on 2018/5/21.
//  Copyright © 2018年 erongchuang. All rights reserved.
//

#import "PZExamineImage.h"
#import "UIShortTapGestureRecognizer.h"
#define Wscreen [UIScreen mainScreen].bounds.size.width
#define Hscreen [UIScreen mainScreen].bounds.size.height
@interface PZExamineImage()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (strong,nonatomic)UIPageControl  *pageControl;
@property (strong,nonatomic)NSArray        *imageArr;
@property (strong,nonatomic)NSArray        *frameArray;
@property (strong,nonatomic)UIScrollView   *imgScroll;
@property (strong,nonatomic)UIScrollView   *scrollView;
@property(strong,nonatomic)UIImageView * imageView;
@property(assign,nonatomic)CGRect fromFrame;
@end
@implementation PZExamineImage
-(instancetype)init
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    }
    return self;
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Wscreen + 20, Hscreen)];
        _scrollView.contentSize = CGSizeMake((Wscreen+20) * (self.imageArr.count), 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.tag = 666;
        _scrollView.delegate = self;
        for (int i = 0; i<self.imageArr.count; i++)
        {
            UIScrollView * imageviewScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(i*(Wscreen+20), 0, Wscreen, Hscreen)];
            imageviewScrollView.minimumZoomScale = 1;
            imageviewScrollView.maximumZoomScale = 2;
            imageviewScrollView.delegate = self;
            imageviewScrollView.showsVerticalScrollIndicator=  NO;
            imageviewScrollView.showsHorizontalScrollIndicator = NO;
            //点击
            UIShortTapGestureRecognizer * singleTap = [[UIShortTapGestureRecognizer alloc]initWithTarget:self action:@selector(makeScrollViewDismiss:)];
            [imageviewScrollView addGestureRecognizer:singleTap];
            //双击
            UIShortTapGestureRecognizer *doubleTap = [[UIShortTapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
            doubleTap.numberOfTapsRequired = 2;
            [imageviewScrollView addGestureRecognizer:doubleTap];
            
            [singleTap requireGestureRecognizerToFail:doubleTap];
            
            [_scrollView addSubview:imageviewScrollView];
            UIImage * image =  self.imageArr[i];
            CGFloat scale = image.size.width/image.size.height;
            CGFloat imageViewH  = Wscreen / scale;
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (Hscreen-imageViewH)/2, Wscreen, imageViewH)];
            imageView.tag = 555;
            imageView.image = image;
            [imageviewScrollView addSubview:imageView];
        }
       
    }
    return _scrollView;
}
//imgArr 传入需要展示的图片数组   index：当前选中的是哪个图片 frameArr是图片之前的frame数组
- (void)showImageWithImgArray:(NSArray *)imgArr selectIndex:(NSInteger)index  imageFrameArr:(NSArray *)frameArr
{
    self.imageArr = imgArr;
    self.frameArray = frameArr;
    self.pageControl.currentPage = index;
    UIImage * currentImage = imgArr[self.pageControl.currentPage];
    self.scrollView.contentOffset = CGPointMake((Wscreen+20) * self.pageControl.currentPage, 0);
    self.imgScroll = [[UIScrollView alloc]init];
    self.imageView = [[UIImageView alloc]initWithImage:currentImage];
    self.fromFrame = [frameArr[self.pageControl.currentPage] CGRectValue];
    self.imgScroll.frame = self.fromFrame;
    self.imageView.frame = self.imgScroll.bounds;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.imgScroll addSubview:self.imageView];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview: self.imgScroll];
    [[UIApplication sharedApplication].keyWindow addSubview:self.pageControl];
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat scale = currentImage.size.width/currentImage.size.height;//宽高比
        CGFloat imageH = Wscreen/scale;
        self.imgScroll.frame = CGRectMake(0, (Hscreen-imageH)/2, Wscreen, imageH);
        self.imageView.frame = self.imgScroll.bounds;
    } completion:^(BOOL finished) {
        [self addSubview:self.scrollView];
        [self.imgScroll setHidden:YES];
    }];
}
#pragma mark -- Method

- (void)makeScrollViewDismiss:(UITapGestureRecognizer *)tap
{
    //调整返回的图片
    self.imageView.image = self.imageArr[self.pageControl.currentPage];
    //调整返回的初始位置
    CGFloat scale = self.imageView.image.size.width/self.imageView.image.size.height;
    UIScrollView * imageScrollView = self.scrollView.subviews[self.pageControl.currentPage];
    CGFloat imageViewW = Wscreen * imageScrollView.zoomScale;
    CGFloat imageViewH = imageViewW / scale;
    self.imgScroll.frame = CGRectMake(0, imageViewH<=Hscreen?(Hscreen-imageViewH)/2:0, imageViewW, imageViewH);
    self.imageView.frame = self.imgScroll.bounds;
    self.imgScroll.contentOffset = imageScrollView.contentOffset;//跟原始的scroll吻合
    //调整返回的最终位置
    self.fromFrame = [self.frameArray[self.pageControl.currentPage] CGRectValue];
    self.imgScroll.hidden = NO;
    [self.pageControl removeFromSuperview];
    [self.scrollView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.imgScroll.frame = self.fromFrame;
        self.imageView.frame =self.imgScroll.bounds;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.imgScroll removeFromSuperview];
    }];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"%@",NSStringFromClass([touch.view class]));
    return YES;
}
#pragma mark -- UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 666) {
        self.pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x /(Wscreen+20));
    }
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return (UIImageView *)[scrollView viewWithTag:555];
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentSize.width);
    UIImageView * imageView = (UIImageView *)[scrollView viewWithTag:555];
    imageView.center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height<Hscreen?Hscreen/2: scrollView.contentSize.height/2);
}
- (void)doubleTap:(UITapGestureRecognizer *)gesture
{
    UIScrollView * imageScrollView  = (UIScrollView *)gesture.view;
    if (imageScrollView.zoomScale >1.0) {
        [imageScrollView setZoomScale:1.0 animated:YES];
    }
    else
    {
        CGPoint location = [gesture locationInView:imageScrollView];
        [imageScrollView zoomToRect:CGRectMake(location.x, location.y, 1, 1) animated:YES];
    }
}
#pragma mark -- getter
-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, Hscreen-60, Wscreen, 20)];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.numberOfPages = self.imageArr.count;
    }
    return _pageControl;
}

@end
