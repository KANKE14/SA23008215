# HEADER------------------------------------
#
# Author:     sunyuyu
# Copyright   Copyright 2024-sunyuyu
# Email:      sunyuyu@email.ustc.edu.cn
#
# Date:       2024-03-31
#
# Script Name:homework-4.R
#
# Script Description:
# 1.数据准备和预处理
# 2.特征选择和可视化
# 3.模型训练和调优
# 4.评估模型性能
#
#
# SETUP ----------------------------------------------


# 加载包
install.packages("randomForest")
library(caret)
library(ggplot2)
library(skimr)
library(randomForest)

# 1.数据准备和预处理
# 载入mtcars数据集并查看
data(mtcars)
str(mtcars)

# 设置随机种子以确保随机抽样每次运行时都产生相同的结果
set.seed(100)

# 将mtcars中mpg数据按照7：3的比例分为训练集和测试集，同时不将结果作为列表返回
# 此处根据后续可视化预测结果将7：3更改为8：2
trainRowNumbers <- createDataPartition(mtcars$mpg, p=0.8, list=FALSE)

# 创建训练数据集和测试数据集
trainData <- mtcars[trainRowNumbers,]
testData <- mtcars[-trainRowNumbers,]

# 设置trainData数据框中列2到11包含了自变量x, 选择mpg列是因变量y
x = trainData[, 2:11]
y = trainData$mpg

# 使用skim函数来进行数据摘要统计，查看数据是否缺失
skimmed <- skim(trainData)
skimmed[, c(1:11)]                # 确定数据无缺失


# 2.特征选择和可视化
# 箱线图可视化确定变量之间的相关性
featurePlot(x = as.matrix(trainData[,2:11]), 
            y = as.factor(trainData$mpg), 
            plot = "box",
            strip=strip.custom(par.strip.text=list(cex=.7)),
            scales = list(x = list(relation="free"), 
                          y = list(relation="free")))

# 密度图可视化确定变量之间的相关性
featurePlot(x = as.matrix(trainData[,2:11]), 
            y = as.factor(trainData$mpg), 
            plot = "density",
            strip=strip.custom(par.strip.text=list(cex=.7)),
            scales = list(x = list(relation="free"), 
                          y = list(relation="free")))

# 设置随机种子为100,禁用警告信息的显示
set.seed(100)
options(warn=-1)

# 定义要尝试的特征子集的大小为2到11
subsets <- c(2:11)
# 定义了一个RFE控制参数对象 ctrl，用于在 RFE 过程中使用随机森林模型评估特征重要性
# 并使用重复的K折交叉验证来评估模型性能，重复5次，同时不显示详细输出信息
ctrl <- rfeControl(functions = rfFuncs,
                   method = "repeatedcv",
                   repeats = 5,
                   verbose = FALSE)

# 将训练数据集中的列2到11作为自变量 x，将目标变量 mpg 作为因变量 y,
# 使用rfe函数评估线性回归模型的性能,并选择出最佳的特征子集
lmProfile <- rfe(x=trainData[, 2:11], y=trainData$mpg,
                 sizes = subsets,
                 rfeControl = ctrl)
lmProfile     # 确定了最重要的四个变量:disp, wt, hp, cyl，其中disp是最重要的变量


# 3.模型训练和调优
# 设置随机种子为100
set.seed(100)

# 利用随机森林方法训练模型，使用了训练数据集中disp作为自变量
model_rf <- train(mpg ~ disp,data = trainData,method = 'rf',
                  trControl = trainControl(method = 'cv', number = 5))
model_rf
str(model_rf)


# 4.评估模型性能
# 预测测试数据集
predictions <- predict(model_rf, testData)
head(predictions)

# 计算均方根误差（RMSE）
rmse <- sqrt(mean((predictions - testData$mpg)^2))
print(paste("RMSE:", rmse))
# 训练集与测试集为7:3时的"RMSE: 3.03231332054308"
# 训练集与测试集为8:2时的"RMSE: 2.83677996825379"

# 计算决定系数
r_squared <- cor(predictions, testData$mpg)^2
print(paste("R-squared:", r_squared))
# 训练集与测试集为7:3时的"R-squared: 0.846681809449405"
# 训练集与测试集为8:2时的"R-squared: 0.615857632475227"

# 查看模型预测结果与实际值的散点图
plot(predictions, testData$mpg, main = "Predictions vs. Actuals", xlab = "Predicted mpg", ylab = "Actual mpg")
abline(0, 1, col = "green")