//
//  LoadScrollView.m
//  ScrollViewUnit
//
//  Created by Marvin on 15/9/6.
//  Copyright (c) 2015年 Marvin. All rights reserved.
//

#import "LoadScrollView.h"

@interface LoadScrollView ()<UIScrollViewDelegate>
{
    UIScrollView *backgroundScrollView;
    BOOL HideOrDisplay;
    int selectItem;
    BOOL isScacle;
    NSTimer *timerAlpha;
    NSDate *startDate;
    
}

@property (strong, nonatomic) UIButton *startButton;//中间的button

@property (strong, nonatomic) UIImageView *headImageView;

@property (strong, nonatomic) NSMutableArray *allImageArray;//用来存放imageView的可变数组
@end

@implementation LoadScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    
    return self;
}


-(void)setUI{
    
    backgroundScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    backgroundScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:backgroundScrollView];
    
    
    backgroundScrollView.delegate = self;
    
    //初始化数组
    _allImageArray = [NSMutableArray array];
    
    
    //模拟测试使用
    for (int i = 0; i < 13; i++) {
        
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i + 1];//获取图片的名字
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.center.x - 30) + i * 75, backgroundScrollView.bounds.size.height / 2 - 30, 60, 60)];//创建imageView
        
        //图片的边界属性
        _headImageView.layer.cornerRadius = 30;
        _headImageView.layer.masksToBounds = YES;
        
        _headImageView.image = [UIImage imageNamed:imageName];
        
        [backgroundScrollView addSubview:_headImageView];
        
        [_allImageArray addObject:_headImageView];//将图片存放到数组里面
        
    }
    
    
    //将选中的图片变大
    UIImageView *imageViewD = [_allImageArray objectAtIndex:0];
    imageViewD.transform =CGAffineTransformMakeScale(1.2, 1.2);
    
    
    //backgroundScrollView的内容大小
    backgroundScrollView.contentSize = CGSizeMake((self.center.x - 30) + (_allImageArray.count + 2) * 75, 0);
    
    //创建中间开始的button
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.startButton.frame = CGRectMake(self.center.x - 45, backgroundScrollView.bounds.size.height / 2 - 45, 90, 90);
//    self.startButton.backgroundColor = [UIColor clearColor];
    
    self.startButton.layer.cornerRadius = 45;//startButton的半径
    self.startButton.layer.borderWidth = 2;//边框的宽度
    self.startButton.layer.borderColor = [UIColor redColor].CGColor;//边框的颜色
    
    [self.startButton addTarget:self action:@selector(startButtonAction:) forControlEvents:UIControlEventTouchUpInside];//startButton的点击事件
    
    [backgroundScrollView addSubview:self.startButton];
    
    HideOrDisplay = YES;//设置初值
    
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
//    [self.startButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    //初始化一个定时器,控制头像alpha的头像显隐
    timerAlpha = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(changeAlpha) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timerAlpha forMode:NSRunLoopCommonModes];
    [timerAlpha setFireDate:[NSDate distantFuture]];
}

#pragma mark - 根据定时器动态改变头像的alpha值
-(void)changeAlpha{
    UIImageView *selectImageView = [_allImageArray objectAtIndex:selectItem];//根据上面的下标获取当前的图片
    for (UIImageView *imageView in _allImageArray) {
        if (selectImageView == imageView) {
            selectImageView.alpha = 1.0;
        }else{
            if (HideOrDisplay) {
                imageView.alpha =(([timerAlpha.fireDate timeIntervalSinceDate:startDate] /5) * 10);
            }else{
                imageView.alpha = 1.0 - (([timerAlpha.fireDate timeIntervalSinceDate:startDate] /5) * 10);
            }
        }
        
    }
    NSLog(@"%f",[timerAlpha.fireDate timeIntervalSinceDate:startDate]);
    
}


//一旦发生偏移就将X方向偏移量再加上初使的x的坐标就会是当前的startButton的新坐标
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    self.startButton.frame = CGRectMake(self.center.x - 60 + backgroundScrollView.contentOffset.x, backgroundScrollView.bounds.size.height / 2 - 60, 120, 120);
//    self.startButton.layer.cornerRadius = 60;
////    self.startButton.layer.borderWidth = 1.0;
//    self.startButton.alpha = 0.6;

    
    if (!isScacle) {
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotateTransform = CATransform3DMakeRotation(0, 0, 0, 0);
        CATransform3D scaleTransform = CATransform3DMakeScale(1.3,1.3, 1.3);
        CATransform3D positionTransform = CATransform3DMakeTranslation(0, 0, 0); //位置移动
        CATransform3D combinedTransform = CATransform3DConcat(rotateTransform, scaleTransform); //Concat就是combine的意思
        combinedTransform = CATransform3DConcat(combinedTransform, positionTransform); //再combine一次把三个动作连起来
        
        [anim setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]]; //放在3D坐标系中最正的位置
        [anim setToValue:[NSValue valueWithCATransform3D:combinedTransform]];
        [anim setDuration:0.5];
        anim.repeatCount = 1;
        [self.startButton.layer addAnimation:anim forKey:nil];
        [self.startButton.layer setTransform:combinedTransform];  //如果没有这句，layer执行完动画又会返回最初的state
        
        
//        CAKeyframeAnimation *centerZoom = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//        centerZoom.duration = 0.5;
//        centerZoom.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.3)]];
//        centerZoom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//        [self.startButton.layer addAnimation:centerZoom forKey:@"buttonScale"];
        
        
        isScacle = YES;
        
        
        self.startButton.alpha = 0.6;
        
        
    }
    
    
    self.startButton.center = CGPointMake(self.center.x + backgroundScrollView.contentOffset.x, backgroundScrollView.bounds.size.height / 2);


    
    for (UIImageView *imageView in _allImageArray) {
        
        [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        
            //判断imageView的中心点要是在button的内部就让图片放大，否则就缩小
            if (imageView.center.x >= _startButton.frame.origin.x && imageView.center.x <= _startButton.frame.origin.x + _startButton.frame.size.width) {
            
                imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);//等比例缩放
                
            }else{
            
                imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);//等比例缩放
              
            }
        } completion:nil];
        
    }

}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    NSLog(@"scrollViewDidEndDragging");
    
     self.startButton.frame = CGRectMake(self.center.x - 45  + backgroundScrollView.contentOffset.x, backgroundScrollView.bounds.size.height / 2 - 45 , 90 , 90);
    
    if (!decelerate) {
        
    int scrollViewContentOffsetX = backgroundScrollView.contentOffset.x / 75;
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        
        backgroundScrollView.contentOffset = CGPointMake(scrollViewContentOffsetX * 75, 0);
        
    } completion:^(BOOL finished){

        
        if (isScacle) {
         
            CAKeyframeAnimation *centerZoom = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            centerZoom.duration = 1.0f;
            centerZoom.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.3)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
            centerZoom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [self.startButton.layer addAnimation:centerZoom forKey:@"buttonScale"];
            [self.startButton.layer setTransform:CATransform3DMakeScale(1, 1, 1)];

            isScacle = NO;
        }
        
        
            self.startButton.center = CGPointMake(self.center.x + backgroundScrollView.contentOffset.x, backgroundScrollView.bounds.size.height / 2);
        
        self.startButton.alpha = 1.0;
        
    }];

    NSLog(@"----2---%f",self.startButton.frame.size.width);
        
    selectItem = scrollView.contentOffset.x / 75;
    
    NSLog(@"XXX第%d个",selectItem);
    
    if ([_delegate respondsToSelector:@selector(getSelectItem:)]) {
        [_delegate getSelectItem:selectItem];
    }
    }
 
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSLog(@"scrollViewDidEndDecelerating");
    
    int scrollViewContentOffsetX = backgroundScrollView.contentOffset.x / 75;
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
    backgroundScrollView.contentOffset = CGPointMake(scrollViewContentOffsetX * 75, 0);
        
    } completion:^(BOOL finished){
        
//        self.startButton.frame = CGRectMake(self.center.x - 45 + backgroundScrollView.contentOffset.x, backgroundScrollView.bounds.size.height / 2 - 45, 90, 90);
//        
//        self.startButton.layer.cornerRadius = 45;
//        self.startButton.layer.borderWidth = 2;//边框的宽度
//        self.startButton.alpha = 1;
//
        
        
        
        if (isScacle) {
            
            CAKeyframeAnimation *centerZoom = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            centerZoom.duration = 1.0f;
            centerZoom.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.3)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
            centerZoom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [self.startButton.layer addAnimation:centerZoom forKey:@"buttonScale"];
            [self.startButton.layer setTransform:CATransform3DMakeScale(1, 1, 1)];
            
            isScacle = NO;
            
            
        }
            self.startButton.center = CGPointMake(self.center.x + backgroundScrollView.contentOffset.x, backgroundScrollView.bounds.size.height / 2);
       
        self.startButton.alpha = 1.0;
        
       
        
    }];
    

    NSLog(@"----1---%f",self.startButton.frame.size.width);
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    
    selectItem = scrollView.contentOffset.x / 75;
        NSLog(@"第%d个",selectItem);
#warning 代理
    if ([_delegate respondsToSelector:@selector(getSelectItem:)]) {
        [_delegate getSelectItem:selectItem];
    }
}



- (void)_startDoSomething {
    NSLog(@"StartDoSomething");
}

- (void)_cancelDoSomething {
    NSLog(@"XXXX----cancel----");
}



//startButton的点击事件
-(void)startButtonAction:(UIButton *)sender
{
    int scrollViewContentOffsetX = backgroundScrollView.contentOffset.x / 75;//获取在button里面的图片的下标
    
    UIImageView *imgView = [_allImageArray objectAtIndex:scrollViewContentOffsetX];//根据上面的下标获取当前的图片
    
    [backgroundScrollView bringSubviewToFront:imgView];
    
    
    CAKeyframeAnimation *centerZoom = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    centerZoom.duration = 1.0f;
    centerZoom.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.3)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.3)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    centerZoom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.startButton.layer addAnimation:centerZoom forKey:@"buttonScale"];
    [self.startButton.layer setTransform:CATransform3DMakeScale(1, 1, 1)];
    
    
    
    if (HideOrDisplay) {
        /**
         *  @author apple, 2015-09-04 10:09:29
         *
         *  点击Start按钮时，响应的事件
         */
        [self _startDoSomething];
        
        //利用动画实现图片往中间靠拢
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            
            //开启定时器
            startDate = [NSDate date];
            [timerAlpha setFireDate:startDate];
            
            //遍历数组让所有的图片的frame都等于当前图片的frame，也就是图片往中间靠拢的效果
            for (UIImageView *imageView in _allImageArray) {
                
                imageView.frame = CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y, imgView.frame.size.width, imgView.frame.size.height);
                
            }
            
            
        } completion:^(BOOL finished) {
            
            backgroundScrollView.scrollEnabled = NO;//当所有的图片集中到中间的时候让backgroundScrollView不再偏移
            
            //再遍历数组隐藏所有的图片
            for (UIImageView *imageView in _allImageArray) {
                imageView.hidden = YES;
            }
            
            imgView.hidden = NO;//当前图片不隐藏
            
            //暂停定时器
            [timerAlpha setFireDate:[NSDate distantFuture]];
            
        }];
        
        HideOrDisplay = NO;
        
        
        [self.startButton setTitle:@"Cancel" forState:UIControlStateNormal];
        
        self.startButton.center = CGPointMake(self.center.x + backgroundScrollView.contentOffset.x, backgroundScrollView.bounds.size.height / 2);
        
        self.startButton.alpha = 1.0;
        
        
//        [self.startButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
    } else {
        
        /**
         *  @author apple, 2015-09-04 10:09:23
         *
         *  点击Cancel按钮时，响应的事件
         */
        [self _cancelDoSomething];
        
        //遍历数组让当前的图片之前的图片恢复到之前的frame
        for (int i = 0; i <= scrollViewContentOffsetX; i++) {
            
            [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
                
                startDate = [NSDate date];
                [timerAlpha setFireDate:startDate];

                
                UIImageView *imageView = [_allImageArray objectAtIndex:scrollViewContentOffsetX - i];//以当前图片为起始倒折从数组里面取出图片
                
                //再按顺序给图片布局位置
                imageView.frame = CGRectMake(imgView.frame.origin.x - i * 75, imgView.frame.origin.y, imgView.frame.size.width, imgView.frame.size.height);
                
                //让所有的图片保持原样
                imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
                
            } completion:^(BOOL finished){
                
                [timerAlpha setFireDate:[NSDate distantFuture]];
                
            }];
            
            [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
            
//            [self.startButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }
        
        
        __block int j = 1;
        
        for (int i = scrollViewContentOffsetX + 1; i < _allImageArray.count; i++) {
            
            [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
                
                UIImageView *imageView = [_allImageArray objectAtIndex:i];
                
                imageView.frame = CGRectMake(imgView.frame.origin.x + j * 75, imgView.frame.origin.y, imgView.frame.size.width, imgView.frame.size.height);
                j++;
            } completion:nil];
            
        }
        
        UIImageView *imageViewD = [_allImageArray objectAtIndex:scrollViewContentOffsetX];
        imageViewD.transform =CGAffineTransformMakeScale(1.2, 1.2);
        
        backgroundScrollView.scrollEnabled = YES;//当所有的图片集中到中间的时候让backgroundScrollView不再偏移
        
        //再次遍历数组隐藏所有的图片
        for (UIImageView *imageView in _allImageArray) {
            imageView.hidden = NO;
        }
        
        HideOrDisplay = YES;
    }
    
    [backgroundScrollView bringSubviewToFront:self.startButton];
    
    

    
    
}


-(void)startButtonIsScroll:(BOOL)isScrolled scrollSize:(CGFloat)scrollSize{
    
    
    if (!isScrolled) {
        isScacle = YES;
        self.startButton.alpha = 0.6;
    }else{
        
        isScacle = NO;
        self.startButton.alpha = 1.0;
        
    }
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D rotateTransform = CATransform3DMakeRotation(0, 0, 0, 0);
    CATransform3D scaleTransform = CATransform3DMakeScale(scrollSize,scrollSize,scrollSize);
    CATransform3D positionTransform = CATransform3DMakeTranslation(0, 0, 0); //位置移动
    CATransform3D combinedTransform = CATransform3DConcat(rotateTransform, scaleTransform); //Concat就是combine的意思
    combinedTransform = CATransform3DConcat(combinedTransform, positionTransform); //再combine一次把三个动作连起来
    
    [anim setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]]; //放在3D坐标系中最正的位置
    [anim setToValue:[NSValue valueWithCATransform3D:combinedTransform]];
    [anim setDuration:0.8];
    anim.repeatCount = 1;
    [self.startButton.layer addAnimation:anim forKey:nil];
    [self.startButton.layer setTransform:combinedTransform];  //如果没有这句，layer执行完动画又会返回最初的state

    
    self.startButton.center = CGPointMake(self.center.x + backgroundScrollView.contentOffset.x, backgroundScrollView.bounds.size.height / 2);
    
   
   
}

-(void)dealloc{
    //不能在这里释放定时器
//    if ([timerAlpha isValid]) {
//        [timerAlpha invalidate];
//    }
//    timerAlpha = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
