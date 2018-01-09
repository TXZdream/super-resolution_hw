# 数图期末大项目

## 代码结构

- part1

data存放所有运行时产生的中间数据
image存放测试数据
target/small是利用双三次缩小后的结果
target/large是双三次放大后的结果
target/large2是利用论文方法处理的结果

## 运行说明

1. main_4是第四题的运行脚本

2. main_5是第五题的运行脚本

3. Px_开头的是第五题的代码，x代表运行顺序

4. 除ssim2之外，其余均为功能函数，ssim2为作者实现的ssim算法，用来对比分析使用