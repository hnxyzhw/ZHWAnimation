//
//  LoadScrollView.h
//  ScrollViewUnit
//
//  Created by Marvin on 15/9/6.
//  Copyright (c) 2015年 Marvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadScrollViewDelegate <NSObject>

-(void)getSelectItem:(NSInteger) selectItem;

@end

@interface LoadScrollView : UIView

-(instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic,assign)id <LoadScrollViewDelegate>delegate;

@end
