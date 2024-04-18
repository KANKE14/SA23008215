# HEADER------------------------------------
#
# Author:     sunyuyu
# Copyright   Copyright 2024-sunyuyu
# Email:      sunyuyu@email.ustc.edu.cn
#
# Date:       2024-04-14
#
# Script Name:data_exploration
#
# Script Description: 1.处理Doubs数据集中的缺失数据
#                     2.检测环境变量之间是否存在共线性
#                     3.对鱼类与环境变量之间关系进行分析和可视化
#
#
# SETUP ----------------------------------------------

# 加载必要的包
install.packages("car")
install.packages("ellipse")
library(car)
library(ade4)
library(readr)
library(stats)
library(ggplot2)
library(ellipsis)
library(corrplot)
library(tidyverse)


# 1.处理Doubs数据集中的缺失数据
data("doubs")                                   # 加载Doubs数据集
doubs_missing=sum(is.na(doubs))|0               # 识别缺失数据
print(doubs_missing)
if (!doubs_missing) {
  doubs_completion <- data.frame(matrix(ncol = 2, nrow = 0))
} else {
  rownames <- rownames(doubs)
  colnames <- colnames(doubs)
  pos <- which(is.na(doubs), arr.ind = TRUE)
  doubs_completion <- data.frame(rownames[pos[, 1]], colnames[pos[, 2]])
}
names(doubs_completion) <- c("row", "column")
doubs_completion                                # 结果显示无缺失数据

# 如果有缺失数据，处理操作如下
summary(doubs$env)                              # 根据结果确定是数值类数据
doubs[is.na(doubs)] <- mean(doubs, na.rm = TRUE)# 对于数值型数据，用均值填充


# 2.检测环境因素之间是否存在共线性
env_cor <- cor(doubs$env)           # 使用cor()函数计算环境变量之间的相关系数
print(env_cor)
corrplot(env_cor, method = "circle")# 可视化环境变量之间的相关性

high_env_cor <- which(env_cor > 0.7 & env_cor < 1, arr.ind = TRUE)
high_vars <- rownames(env_cor)[high_env_cor[, 1]]
cor_vars <- colnames(env_cor)[high_env_cor[, 2]]
                                    # 获取相关系数大于0.7的环境变量
cat("环境变量之间相关性大于0.7的变量:\n")
for (i in 1:length(high_vars)) {
  cat(high_vars[i], "和", cor_vars[i], "\n")
}                                   # 打印出相关系数大于0.7的环境变量关系

# 拟合鱼类Alal丰度和环境变量之间的线性回归模型
names(doubs$fish)
model <- lm(doubs$fish$Alal ~ ., data = doubs$env)
vif(model)                          # 利用方差膨胀因子VIF评估自变量间的共线性程度
#     dfs        alt        slo        flo         pH        har
# 136.737235  54.161158   5.309589  46.988910   1.746103   4.296977  
#     pho        nit        amm        oxy        bdo 
# 25.658248  16.842868   30.742467  17.581085  17.803821 
# 根据vif=7判断除slo、pH、har外的环境变量与其他自变量之间存在非常强的共线性，
# 可能会导致拟合模型的不稳定性，可删除一些自变量或使用PCA来提取主成分来处理共线性。


# 3.对鱼类与环境变量之间关系进行分析和可视化
fish_env_cor <- cor(doubs$fish, doubs$env)  # 计算鱼类与环境变量之间的相关系数矩阵
fish_env_cor
corrplot(fish_env_cor, method = "color",
         xlab = "Environment Variables", ylab = "Fish Count", 
         main = "Heatmap of Correlation between Environment Variables and Fish Count")
                                            # 可视化鱼类与环境变量之间的相关性

# 以鱼类Alal和环境变量slo为例详细分析
model1 <- lm(doubs$fish$Alal ~ doubs$env$slo)     # 拟合线性回归模型
summary(model1)                                   # 查看线性回归模型的摘要信息
plot(model1)                                      # 可视化，结果显示呈正态分布
rsquared <- summary(model1)$r.squared             # 计算决定系数（R²）
rsquared                                          # R²=0.7842143
pca_result1 <- prcomp(doubs$env, scale. = TRUE)   # 对环境变量进行主成分分析
pca_scores1 <- as.data.frame(predict(pca_result1))# 提取主成分得分
combined_data1 <- cbind(doubs$fish, pca_scores1)  # 将鱼类丰度数据与主成分合并
lm_model1 <- lm(doubs$fish$Alal ~ ., data = combined_data1)
                                                  # 拟合线性模型
summary(lm_model1)                                # 查看模型摘要