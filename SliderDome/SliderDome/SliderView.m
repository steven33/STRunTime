//
//  SliderView.m
//  SliderDome
//
//  Created by 李方建 on 2018/8/7.
//  Copyright © 2018年 李方建. All rights reserved.
//

#import "SliderView.h"
@interface SliderView ()
@property (nonatomic,strong)UIView *huaView;
@property (nonatomic,strong)UIActivityIndicatorView *indicator;
@property (nonatomic,strong)UILabel *titleLabel;

@end
@implementation SliderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blueColor];
        self.layer.cornerRadius = KdefaultHeight/2;
        
        [self addSubview:self.huaView];
        [self addSubview:self.indicator];
        [self addSubview:self.titleLabel];
        
    }
    return self;
}
- (void)panAction:(UIPanGestureRecognizer *)ges{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow ;
    CGPoint translatedPoint = [ges translationInView:self];
    switch (ges.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:{
            
            if (ges.view.frame.origin.x< KPushLeft && self.isShow!=YES) {//小于一半，收回去
                [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    CGRect frame = CGRectMake(2, ges.view.frame.origin.y, ges.view.frame.size.width, ges.view.frame.size.height);
                    ges.view.frame = frame;
                } completion:^(BOOL finished) {
                }];
                
                return;
            }
            [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                CGRect frame = CGRectMake(self.frame.size.width-ges.view.frame.size.width - 2, ges.view.frame.origin.y, ges.view.frame.size.width, ges.view.frame.size.height);
                ges.view.frame = frame;
            } completion:^(BOOL finished) {
                self.isShow = YES;
            }];
            //大于一半，弹出来
            return;
        }break;
        default:{//拖动时候改变坐标
            [UIView animateWithDuration:0.1 animations:^{
                CGFloat markLeft = ges.view.frame.origin.x+translatedPoint.x;
                CGRect frame = CGRectMake(markLeft, ges.view.frame.origin.y, ges.view.frame.size.width, ges.view.frame.size.height);
                ges.view.frame = frame;
            }];
            [ges setTranslation:CGPointZero inView:keyWindow];
        }break;
    }
}
- (void)setIsShow:(BOOL)isShow{
    _isShow = isShow;
    if (_isShow == YES) {
        [self.indicator startAnimating];
    }else{
        [self.indicator stopAnimating];
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.huaView.frame = CGRectMake(2, 2, KdefaultHeight*3.0/2.0, KdefaultHeight-4);
        } completion:^(BOOL finished) {
        }];

    }
}
#pragma mark----UI
- (UIView *)huaView{
    if (!_huaView) {
        _huaView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, KdefaultHeight*3.0/2.0, KdefaultHeight-4)];
        _huaView.backgroundColor = [UIColor whiteColor];
        _huaView.layer.cornerRadius = (KdefaultHeight-4)/2;
        UIPanGestureRecognizer * panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [_huaView addGestureRecognizer:panGes];
    }
    return _huaView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, (KdefaultHeight -20)/2, 100, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"滑动结束计费";
    }
    return _titleLabel;
}
- (UIActivityIndicatorView *)indicator{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicator.center = CGPointMake(self.frame.size.width/2-50-15, KdefaultHeight/2);//只能设置中心，不能设置大小
        _indicator.color = [UIColor whiteColor]; // 改变圈圈的颜色为红色； iOS5引入
//        [_indicator startAnimating]; // 开始旋转
//        [_indicator stopAnimating]; // 结束旋转
        [_indicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    }
    return _indicator;
}
@end
