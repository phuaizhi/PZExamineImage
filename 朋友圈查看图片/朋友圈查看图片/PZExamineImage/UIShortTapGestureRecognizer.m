//
//  UIShortTapGestureRecognizer.m
//  tabBarText
//
//  Created by tsb1119 on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UIShortTapGestureRecognizer.h"

@implementation UIShortTapGestureRecognizer
-(instancetype)initWithTarget:(id)target action:(SEL)action{
    
    self=[super initWithTarget:target action:action];
    
    if(self){
        
        self.maxDelay= 0.25;
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.maxDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(self.state!=UIGestureRecognizerStateRecognized){
            
            self.state=UIGestureRecognizerStateFailed;
        }
    });
}
@end
