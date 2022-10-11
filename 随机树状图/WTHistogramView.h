//
//  WTHistogramView.h
//  随机树状图
//
//  Created by 王腾 on 2022/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HistogramViewBlock)(NSInteger inde);


@interface WTHistogramView : UIView

@property(nonatomic,assign) float pillarsWidth;//柱子的宽度 默认是18pt

@property(nonatomic,assign) float pillarsNumber;//柱子数量  默认0

@property(nonatomic,assign) float pillarsMargin;//柱子间距 默认26

@property(nonatomic,assign) NSInteger vertVersion; //纵向等分数量 默认5

@property(nonatomic,strong) NSString *saidMeaning;//柱状图的表示含义 例如：分数---成绩---得分  默认是分数

@property(nonatomic,assign) BOOL showleftLine;//是否显示左侧边

@property(nonatomic,strong) UIColor *bottomTextColor;//底部文字颜色

@property(nonatomic,strong) UIColor *leftTextColor;//左侧文字颜色

@property(nonatomic,strong) UIColor *pillarsTopTextColor;//柱子上面具体的小数字的颜色

@property(nonatomic,assign) BOOL showPillarsTopText;//是否显示柱子上面具体的小数字 默认YES

/**
 柱子的点击事件
 */
@property(nonatomic,copy)HistogramViewBlock clickBlock;

/**
 数据容器
 */
@property(nonatomic,strong)NSArray *keyValues;

@end

NS_ASSUME_NONNULL_END
