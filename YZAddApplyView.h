//
//  YZAddApplyView.h
//  yz-app
//
//  Created by 燕戏涛 on 16/3/28.
//  Copyright © 2016年 燕戏涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YZApplyType) {

    YZApplyTypeVacation        = 0,
    YZApplyTypeBizTrip,
    YZApplyTypeRest
};

@class YZAddApplyView;
@protocol YZAddApplyViewDelegate <NSObject>

- (void) didTapBtn:(YZAddApplyView *) view btnType:(YZApplyType) btnType;

@end

@interface YZAddApplyView : UIView

@property (weak, nonatomic) id<YZAddApplyViewDelegate> YZAddApplyViewDelegate;

//- (id) initWithApplyType:(NSArray *)type;
- (void)show;

@end
