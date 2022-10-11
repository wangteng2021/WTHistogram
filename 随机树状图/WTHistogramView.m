//
//  WTHistogramView.m
//  随机树状图
//
//  Created by 王腾 on 2022/10/11.
//

#import "WTHistogramView.h"
#import "WTTableData.h"
#define Left_Margin 34
#define Right_Margin 16

//RGB颜色
#define colorWithRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define colorWithRGBAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
#define colorWithRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define colorWithSameRGB(rgb) [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0]


@interface WTHistogramView ()

@property(nonatomic,assign)float rowSpace;//行距

@property(nonatomic,assign)float bigestNumber;//最大值

@property(nonatomic,assign)float con_pillars_margin;//底部文字距离柱子间距 默认是8

/**
 下面的三个属性都不需要设置 都是根数传入的数据源获取的
 */
@property(nonatomic,strong)NSMutableArray *ys; //y轴坐标 [0,2,4,6,8,10]

@property(nonatomic,strong)NSArray *xs; //x轴坐标 默认为空

@property(nonatomic,strong)NSArray *numbers; //y轴实际值 默认为空

@end

@implementation WTHistogramView

//初始化
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _vertVersion = 5;
        
        _pillarsWidth = 18;
        
        _pillarsMargin = 26;
        
        _con_pillars_margin = 8;
        
        _showPillarsTopText = YES;
        
    }
    return self;
}

//柱状图的绘制
- (void)drawRect:(CGRect)rect {
    
    //创建画布
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    
    [colorWithRGB(235, 235, 235) set];
    
    CGContextSetLineWidth(ctr, 1);
    
    //横向分隔线
    for (NSInteger index = 0; index < 6; index++) {
        CGContextMoveToPoint(ctr, Left_Margin, _rowSpace * (index + 2));
        CGContextAddLineToPoint(ctr, self.frame.size.width - Left_Margin - Right_Margin, _rowSpace * (index + 2));
        CGContextStrokePath(ctr);
    }
    
    //左侧边
    if (self.showleftLine) {
        
        CGContextMoveToPoint(ctr, Left_Margin, _rowSpace * 4 / 3.0);
        CGContextAddLineToPoint(ctr, Left_Margin, _rowSpace * ((_vertVersion + 2)));
        CGContextStrokePath(ctr);
        
    }
    
    
    //绘制分数分割数字
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:colorWithRGBValue(0x9b9b9b)};
    
    for (NSInteger inde = 0; inde < self.ys.count; inde++) {
        NSString *scaleValue = self.ys[(self.ys.count - 1) - inde];
        paragraph.alignment = NSTextAlignmentCenter;
        
        if (_leftTextColor) {
            NSDictionary *attribute1 = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:_leftTextColor};
            [scaleValue drawInRect:CGRectMake(0, _rowSpace * (inde + 1) + _rowSpace / 2, Left_Margin, _rowSpace) withAttributes:attribute1];
        }else{
            [scaleValue drawInRect:CGRectMake(0, _rowSpace * (inde + 1) + _rowSpace / 2, Left_Margin, _rowSpace) withAttributes:attribute];
        }
    }
    
    //绘制分数两个字
    if (_saidMeaning) {
        [_saidMeaning drawInRect:CGRectMake(Left_Margin / 4, _rowSpace / 1.5 , Left_Margin, _rowSpace) withAttributes:attribute];
    }else{
        [@"分数" drawInRect:CGRectMake(Left_Margin / 4, _rowSpace / 1.5 , Left_Margin, _rowSpace) withAttributes:attribute];
    }
    
    //绘制柱子
    for (NSInteger index = 0; index < self.xs.count; index++) {
        
        CGFloat number = [self.numbers[index] floatValue];
        
        CGFloat scale =  number / _bigestNumber;
        
        UIButton *barBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat x = _pillarsMargin * (index + 1) + _pillarsWidth * (index) + Left_Margin / 2.0;
        CGFloat height = _rowSpace * _vertVersion * scale;
        CGFloat y = _rowSpace * (_vertVersion + 2) - height;
        CGFloat width = _pillarsWidth;
        
        
        barBtn.frame = CGRectMake(x,  _rowSpace * _vertVersion + _rowSpace * 2, _pillarsWidth, 0);
        barBtn.tag = index;
        [self addSubview:barBtn];
        [barBtn addTarget:self action:@selector(barChartClick:) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:1.0 animations:^{
            barBtn.frame = CGRectMake(x, y, width, height);
            barBtn.backgroundColor = [self colorWithIndex:(int)index];
        }];
        
        //横向文字
        NSString *itemStr = self.xs[index];
        
        if (_bottomTextColor) {
            NSDictionary *attribute1 = [attribute copy];
            attribute1 = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:_bottomTextColor};
            [itemStr drawInRect:CGRectMake(_pillarsMargin * index + _pillarsMargin / 2.0 + _pillarsWidth * index + + Left_Margin / 2.0, _rowSpace * (_vertVersion + 2) + _con_pillars_margin ,_pillarsMargin + _pillarsWidth ,_rowSpace) withAttributes:attribute1];
        }else{
            [itemStr drawInRect:CGRectMake(_pillarsMargin * index + _pillarsMargin / 2.0 + _pillarsWidth * index + + Left_Margin / 2.0, _rowSpace * (_vertVersion + 2) + _con_pillars_margin ,_pillarsMargin + _pillarsWidth ,_rowSpace) withAttributes:attribute];
        }
        
        // 分数
        if (_showPillarsTopText) {
            if (_pillarsTopTextColor) {
               attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:_pillarsTopTextColor};
            }
            NSString *actureScore = self.numbers[index];
            //绘制每个item的得分
            [actureScore drawInRect:CGRectMake(_pillarsMargin * index + _pillarsMargin / 2.0 + _pillarsWidth * index + Left_Margin / 2.0, y - _rowSpace / 2.0 ,_pillarsMargin + _pillarsWidth ,_rowSpace) withAttributes:attribute];
        }
        
    }
}

/**
 获取临接柱子的颜色
 */
-(UIColor *)colorWithIndex:(int)index{
    UIColor *color;
    NSInteger num = index % 7;
    switch (num) {
        case 0:
            color = colorWithRGB(122, 174, 235);
            break;
        case 1:
            color = colorWithRGB(130, 224, 181);
            break;
        case 2:
            color = colorWithRGB(235, 195, 122);
            break;
        case 3:
            color = colorWithRGB(122, 174, 235);
            break;
        case 4:
            color = colorWithRGB(236, 145, 143);
            break;
        case 5:
            color = colorWithRGB(235, 195, 122);
            break;
        default:
            color = colorWithRGB(130, 224, 181);
            break;
    }
    return color;
}


/**
 有的时候一些要求柱子能够点击 这个方法是点击柱子的回调
 方法
 */
-(void)barChartClick:(UIButton *)button{
    
    if (self.clickBlock) {
        
        self.clickBlock(button.tag);
        
    }
    
}


#pragma mark------setter getter

-(void)setShowleftLine:(BOOL)showleftLine{
    
    _showleftLine = showleftLine;
    
}

-(void)setSaidMeaning:(NSString *)saidMeaning{
    
    _saidMeaning = saidMeaning;
    
}

-(void)setBottomTextColor:(UIColor *)bottomTextColor{
    
    _bottomTextColor = bottomTextColor;
}

-(void)setLeftTextColor:(UIColor *)leftTextColor{
    
    _leftTextColor = leftTextColor;
}

-(void)setShowPillarsTopText:(BOOL)showPillarsTopText{
    
    _showPillarsTopText = showPillarsTopText;
}


-(void)setPillarsTopTextColor:(UIColor *)pillarsTopTextColor{
    
    _pillarsTopTextColor = pillarsTopTextColor;
}


-(void)setKeyValues:(NSArray *)keyValues{
    
    _keyValues = keyValues;
    
    _pillarsNumber = [self.xs count];
    
    _rowSpace = self.frame.size.height /(_vertVersion + 3.0);
    
    _bigestNumber = [self getMaxFloatNumberFrom:self.numbers];
    
    if (_bigestNumber == 0) {
        
        _bigestNumber = 10;
        
    }
    
    CGFloat maxWidth = [self getMaxContentWidth:self.xs];
    
    if (maxWidth <= _pillarsWidth) {
        
        _pillarsMargin = _pillarsWidth + 10;
        
    }else{
        
        _pillarsMargin = maxWidth;
        
    }
}

/**
 给定一组数据 求出数据中的最大值 最大值返回值是一个整数
 因为在此纵轴的分割以整数为单位
 */
-(CGFloat)getMaxFloatNumberFrom:(NSArray *)numbers{
    //和上面这个方法一样 只不过返回了 浮点数
    //因为刻画纵向刻度整数 而绘制柱子则要的就是精确一点的数字
    
    CGFloat max = [numbers[0] floatValue];
    
    for (NSInteger inde = 1; inde < numbers.count; inde++) {
        
        CGFloat number = [numbers[inde] floatValue];
        
        if (number > max) {
            
            max = number;
        }
    }
    return max;
}


/**
 给定一组字符串 根据字符串中的内容获取字符串的最大宽度
 整体上各个柱子之间的间距以字符串的最大宽度为基准
 */
-(CGFloat)getMaxContentWidth:(NSArray *)contents{
    
    CGFloat maxWidth = 0.0;
    
    for (NSInteger inde= 0; inde < contents.count ; inde++) {
        
        NSString *str = contents[inde];
        
        CGSize sizeToFit = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, _rowSpace) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil].size;
        
        if (sizeToFit.width > maxWidth) {
            
            maxWidth = sizeToFit.width;
        }
    }
    return maxWidth;
}



#pragma mark------Lazy Loading

-(NSArray *)xs{
    
    if (!_xs) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSInteger inde = 0; inde < self.keyValues.count; inde++) {
            
            WTTableData *data = self.keyValues[inde];
            
            [array addObject:data.itemStr];
            
        }
        _xs = [array copy];
    }
    return _xs;
    
}

-(NSMutableArray *)ys{
    
    if (!_ys) {
        
        _ys = [NSMutableArray arrayWithObjects:@"0", nil];
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSInteger inde = 0; inde < self.keyValues.count; inde++) {
            
            WTTableData *data = self.keyValues[inde];
            
            [array addObject:data.itemValue];
            
        }
        
        NSInteger max = [self getMaxFloatNumberFrom:[array copy]];
        
        //每个纵格的数字之差
        CGFloat difference = (max * 1.0) / (_vertVersion * 1.0);
//        if (max % _vertVersion > 0) {
//            _vertVersion += 1;
//        }
        
        for (NSInteger ind = 0; ind < _vertVersion; ind++) {
            
            [_ys addObject:[NSString stringWithFormat:@"%ld",(NSInteger)((ind + 1) * difference)]];
        }
    }
    return _ys;
}


-(NSArray *)numbers{
    
    if (!_numbers) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSInteger inde = 0; inde < self.keyValues.count; inde++) {
            
            WTTableData *data = self.keyValues[inde];
            
            [array addObject:data.itemValue];
            
        }
        _numbers = [array copy];
    }
    return _numbers;
    
}

@end
