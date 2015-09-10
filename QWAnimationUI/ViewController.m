//
//  ViewController.m
//  QWAnimationUI
//
//  Created by Marvin on 15/9/6.
//  Copyright (c) 2015年 Marvin. All rights reserved.
//

#import "ViewController.h"
#import "LoadScrollView.h"


@interface ViewController ()<LoadScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LoadScrollView *tempView = [[LoadScrollView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 145, [UIScreen mainScreen].bounds.size.width, 145)];
    
    tempView.backgroundColor = [UIColor lightGrayColor];
    tempView.delegate = self;
    
    [self.view addSubview:tempView];
    
}

-(void)getSelectItem:(NSInteger)selectItem{
//    NSLog(@"当前选择的单元:%ld",(long)selectItem);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
