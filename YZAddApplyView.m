//
//  YZAddApplyView.m
//  yz-app
//
//  Created by 燕戏涛 on 16/3/28.
//  Copyright © 2016年 燕戏涛. All rights reserved.
//

#import "YZAddApplyView.h"
#import "YZTabButton.h"
#import "AppDelegate.h"
#import "UIImage+Utility.h"

@implementation YZAddApplyView
{

    UIView                      *_contentView;
    UIImage                     *bgImage;
    NSMutableArray              *_buttons;
    UIButton                    *_bgButton;
    UIView                      *_bgContentView;
    NSArray                     *_itemImages;
    NSArray                     *_itemTexts;
    CGSize                      _itemSize;
    NSArray                     *_itemImages_select;
    UIButton                    *_closeBtn;
    float                       _angle;
}
- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    _buttons = [[NSMutableArray alloc] initWithCapacity:0];
    
    _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgButton setFrame:self.bounds];
    [_bgButton setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.4]];
    [_bgButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bgButton];
    
    _bgContentView = [[UIView alloc] init];
    [_bgContentView setFrame:self.bounds];
    [_bgContentView setBackgroundColor:[UIColor colorWithString:@"0x000000"]];
    [_bgContentView setAlpha:0.7];
    [_bgContentView setUserInteractionEnabled:NO];
    [_bgButton addSubview:_bgContentView];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setFrame:CGRectMake(SCREEN_WID - 50, 18, 40, 40)];
    [_closeBtn setImage:[UIImage imageNamed:@"creatApply_Item"] forState:UIControlStateNormal];
    [_closeBtn setContentMode:UIViewContentModeCenter];
    [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn];
    
    _itemImages = @[@"vacation_normal",@"bizTrip_normal",@"rest_normal"];
    _itemImages_select = @[@"vacation_select",@"bizTrip_select",@"rest_select"];
    _itemTexts  = @[@"请假",@"出差",@"调休"];
    
    UIEdgeInsets inset  = UIEdgeInsetsMake(10, 10, 10, 10);
    float itemWidth     = (SCREEN_WID - inset.left - inset.right + 10)/4;
    _itemSize           = CGSizeMake(itemWidth, itemWidth);
    NSInteger column = _itemTexts.count;
    NSInteger num = MIN(column, _itemImages.count);
    NSInteger minHMargin = (SCREEN_WID - num * _itemSize.width) / (num + 1);
    for (int i = 0; i < _itemTexts.count; i++) {
        NSInteger c = i % column;
        YZTabButton *tabButton = [YZTabButton buttonWithType:UIButtonTypeCustom];
        [tabButton setFrame:CGRectMake(minHMargin + (minHMargin + _itemSize.width) * c, SCREEN_HEI, _itemSize.width, _itemSize.height)];
        [tabButton addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tabButton setTitle:_itemTexts[i] forState:UIControlStateNormal];
        [tabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tabButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [tabButton setImage:[UIImage imageNamed:_itemImages[i]] forState:UIControlStateNormal];
        [tabButton setImage:[UIImage imageNamed:_itemImages_select[i]] forState:UIControlStateSelected];
        [tabButton setTag:1001 + i];
        [tabButton setSpacing:4];
        [_buttons addObject:tabButton];
        [_bgButton addSubview:tabButton];
    }
    return self;
}

- (void)itemClicked:(UIButton *)sender{

    NSInteger index = [_buttons indexOfObject:sender];
    if (index >= 0 && index < _buttons.count) {
        if ([self.YZAddApplyViewDelegate respondsToSelector:@selector(didTapBtn:btnType:)]) {
            [self.YZAddApplyViewDelegate didTapBtn:self btnType:index];
        }
    }
    [self dismiss];
}

- (void)show{

    UIView * bgImageView = [AppDelegate appDelegate].window;
    CGRect rect = bgImageView.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [bgImageView.layer renderInContext:contextRef];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    bgImage = [[UIImage alloc] init];
    bgImage = [img setImageToBlurWithBlurRadius:2];
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    _bgButton.alpha = 0.f;
    [_bgButton setImage:bgImage forState:UIControlStateNormal];
    [_bgButton setImage:bgImage forState:UIControlStateHighlighted];
    
    _contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.1 animations:^{
    
        _bgButton.alpha = 1.f;
        _contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        
        [self appearSpringAnimate];
    }];
    
}

- (void)dismiss{

    [self removeFromSuperview];
}

- (void)closeBtnAnimation{
    
    _angle += 45;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         _closeBtn.transform = CGAffineTransformMakeRotation(_angle * (M_PI/180.0f));
                     }
                     completion:nil];
}

- (void)appearSpringAnimate{
    
    _angle += 45;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         _closeBtn.transform = CGAffineTransformMakeRotation(_angle * (M_PI/180.0f));
                     }
                     completion:nil];

    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                     
                         [self viewWithTag:1001].centerY = self.centerY;
                         [self viewWithTag:1002].centerY = self.centerY;
                         [self viewWithTag:1003].centerY = self.centerY;
                     }
                     completion:nil];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
