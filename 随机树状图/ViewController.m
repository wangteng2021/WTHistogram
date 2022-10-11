//
//  ViewController.m
//  随机树状图
//
//  Created by 王腾 on 2022/10/11.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "WTHistogramView.h"
#import "WTTableData.h"
@interface ViewController ()

@property (nonatomic, strong) UILabel *minLabel;

@property (nonatomic, strong) UITextField *minTextField;

@property (nonatomic, strong) UILabel *maxLabel;

@property (nonatomic, strong) UITextField *maxTextField;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UITextField *countTextField;

@property (nonatomic, strong) UILabel *sortLabel;

@property (nonatomic, strong) UIButton *downButton;

@property (nonatomic, strong) UIButton *upButton;

@property (nonatomic, strong) NSMutableArray *sourceArray;

@property (nonatomic, strong) WTHistogramView *histogramView;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self bindView];
}
- (void)bindView {
    
    self.minLabel = ({
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"最小值：";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColor.blackColor;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view).offset(10);
            make.top.equalTo(self.view).offset(20 + 34 + 10);
        }];
        label;
    });
    
    self.minTextField = ({
        UITextField *text = [[UITextField alloc] init];
        text.keyboardType = UIKeyboardTypeNumberPad;
        text.placeholder = @"请输入";
        text.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:text];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.minLabel.mas_trailing).offset(10);
            make.centerY.equalTo(self.minLabel);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        text;
    });
    
    self.maxLabel = ({
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"最大值：";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColor.blackColor;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.minTextField.mas_trailing).offset(10);
            make.centerY.equalTo(self.minTextField);
        }];
        label;
    });
    
    self.maxTextField = ({
        UITextField *text = [[UITextField alloc] init];
        text.placeholder = @"请输入";
        text.font = [UIFont systemFontOfSize:12];
        text.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:text];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.maxLabel.mas_trailing).offset(10);
            make.centerY.equalTo(self.maxLabel);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        text;
    });
    self.countLabel = ({
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"数量：";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColor.blackColor;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.maxTextField.mas_trailing).offset(10);
            make.centerY.equalTo(self.maxTextField);
        }];
        label;
    });
    self.countTextField = ({
        UITextField *text = [[UITextField alloc] init];
        text.keyboardType = UIKeyboardTypeNumberPad;
        text.placeholder = @"请输入";
        text.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:text];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.countLabel.mas_trailing).offset(10);
            make.centerY.equalTo(self.countLabel);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        text;
    });
    self.sortLabel = ({
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"排序：";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColor.blackColor;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.minLabel);
            make.top.equalTo(self.minLabel.mas_bottom).offset(10);
        }];
        label;
    });
    
    
    self.downButton = ({
        
        UIButton *button = [[UIButton alloc] init];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitle:@"降序" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        button.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
        [button addTarget:self action:@selector(downButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.sortLabel.mas_trailing).offset(10);
            make.centerY.equalTo(self.sortLabel);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        button;
    });
    self.upButton = ({
        
        UIButton *button = [[UIButton alloc] init];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitle:@"升序" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        button.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
        [button addTarget:self action:@selector(upButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.downButton.mas_trailing).offset(10);
            make.centerY.equalTo(self.sortLabel);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        button;
    });
    
}
-(void)addSubView{
    
    
    self.histogramView = [[WTHistogramView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 300)];
    self.histogramView.backgroundColor = [UIColor whiteColor];
    
    /*
     做对应的属性设置 这里省略了。。。。
     */
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i < self.sourceArray.count; i++) {
        
        WTTableData *data = [WTTableData new];
        data.itemStr = @(i + 1).stringValue;
        NSNumber *number = self.sourceArray[i];
        data.itemValue = [number stringValue];
        [dataArray addObject:data];
    }
    
    self.histogramView.keyValues = dataArray; //传入一个模型数组，作为页面绘制的数据源
    
    [self.view addSubview:self.histogramView];
    
}
- (void)downButtonClick {
    
    /// 最小高度
    NSInteger min = [self.minTextField.text integerValue];
    
    /// 最大高度
    NSInteger max = [self.maxTextField.text integerValue];
    
    /// 树状图个数
    NSInteger count = [self.countTextField.text integerValue];
    
    if (min <= 0 || min > 100) {
        
        return;
    }
    if (max > 100 || max < min || max < 0) {
        
        return;
    }
    
    if (count <= 0 || count > 10) {
        
        return;
    }
    
    [self.sourceArray removeAllObjects];
    
    do {
        
        NSInteger num = arc4random() % max + min;
        [self.sourceArray addObject:@(num)];
        
    } while (self.sourceArray.count < count);
    
    self.sourceArray = [[self.sourceArray sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        
        NSLog(@"%@~%@",obj1,obj2);
        
        return [obj2 compare:obj1]; //升序
        
    }] mutableCopy];
    
    NSLog(@"数据源:%@",self.sourceArray);
    
    [self addSubView];
}
- (void)upButtonClick {
    
    /// 最小高度
    NSInteger min = [self.minTextField.text integerValue];
    
    /// 最大高度
    NSInteger max = [self.maxTextField.text integerValue];
    
    /// 树状图个数
    NSInteger count = [self.countTextField.text integerValue];
    
    if (min <= 0 || min > 100) {
        
        return;
    }
    if (max > 100 || max < min || max < 0) {
        
        return;
    }
    
    if (count <= 0 || count > 10) {
        
        return;
    }
    
    [self.sourceArray removeAllObjects];
    
    do {
        
        NSInteger num = arc4random() % max + min;
        [self.sourceArray addObject:@(num)];
        
    } while (self.sourceArray.count < count);
    
    [self quickSortArray:self.sourceArray withLeftIndex:0 andRightIndex:self.sourceArray.count-1];
    NSLog(@"数据源:%@",self.sourceArray);
    
    [self addSubView];
}
- (void)quickSortArray:(NSMutableArray *)array withLeftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex {
    if (leftIndex >= rightIndex) {//如果数组长度为0或1时返回
        return ;
    }
    
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    //记录比较基准数
    NSInteger key = [array[i] integerValue];
    
    while (i < j) {
        /**** 首先从右边j开始查找比基准数小的值 ***/
        while (i < j && [array[j] integerValue] >= key) {//如果比基准数大，继续查找
            j--;
        }
        //如果比基准数小，则将查找到的小值调换到i的位置
        array[i] = array[j];
        
        /**** 当在右边查找到一个比基准数小的值时，就从i开始往后找比基准数大的值 ***/
        while (i < j && [array[i] integerValue] <= key) {//如果比基准数小，继续查找
            i++;
        }
        //如果比基准数大，则将查找到的大值调换到j的位置
        array[j] = array[i];
        
    }
    
    //将基准数放到正确位置
    array[i] = @(key);
    
    /**** 递归排序 ***/
    //排序基准数左边的
    [self quickSortArray:array withLeftIndex:leftIndex andRightIndex:i - 1];
    //排序基准数右边的
    [self quickSortArray:array withLeftIndex:i + 1 andRightIndex:rightIndex];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}
#pragma mark -- init
- (NSMutableArray *)sourceArray {
    
    if (!_sourceArray) {
        
        _sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
}
@end
