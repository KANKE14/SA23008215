# HEADER------------------------------------
#
# Author:     sunyuyu
# Copyright   Copyright 2024-sunyuyu
# Email:      sunyuyu@email.ustc.edu.cn
#
# Date:       2024-05-22
#
# Script Name:ts_fs_ml
#
# Script Description:1.对ERCah站点VAI物种鱼类密度数据创建时间序列对象并可视化。
#                    2.提取时间序列特征，利用tidymodels包建立预测模型。
#
# SETUP ----------------------------------------------

# 安装并加载需要的包
install.packages("zoo")
install.packages("timetk")
install.packages("plotly")
install.packages("forecast")
install.packages("tidymodels")
library(zoo) 
library(dplyr)
library(timetk)
library(plotly)
library(ggplot2)
library(recipes)
library(forecast)
library(patchwork)
library(tidyverse)
library(tidymodels)

# 获取数据
url <- "https://figshare.com/articles/dataset/Data_for_Contemporary_loss_of_genetic_diversity_in_wild_fish_populations_reduces_biomass_stability_over_time_/13095380"
destfile <- "Prunier et al._RawBiomassData.txt"
download.file(url, destfile, method="auto")
data <- read.table("Prunier et al._RawBiomassData.txt", header = TRUE)
write.csv(data, "BiomassData.csv", row.names = FALSE)
data <- read.csv("BiomassData.csv", header = TRUE)
head(data)

# 1 对ERCah站点VAI物种鱼类密度数据创建时间序列对象并可视化
# 1.1 数据预处理
data_clean <- data |>
dplyr::select(-YEAR) |>
drop_na() |>             # 去除缺失值
distinct()               # 保留数据集中的唯一行,并去除重复行


unique(data_clean$STATION)
table(data_clean$STATION)
unique(data_clean$SP)
table(data_clean$SP)     # 用unique删除重复元素


mydata <- data_clean |>  # 选择station列为VERCah,SP列为VAI的数据
  subset(STATION=="VERCah" & SP == "VAI")

# 1.2 创建时间序列
data_ts = ts(data = mydata[, 7],
             start = c(1994),
             frequency = 1)
# 1.3 可视化
autoplot(data_ts, facets = TRUE) +
  ggtitle("VERCah of Doubs river") +
  ylab("Changes") + xlab("Year")

#--------------------------------------------------

# 2 提取时间序列特征，利用tidymodels包建立预测模型
# 数据预处理
datatk_ts <- mydata |>
  tk_tbl() |>                                     #将数据框转为tibble对象
  mutate(DATE = as_date(as.POSIXct.Date(DATE))) |>#将DATE列转为日期格式
  select(-1) |>                                   #去除第一列
rename(date = DATE) |>                            #重命名列名
relocate(date, .before = STATION) |>              #将date列移动到STATION列前
pivot_longer(cols = c("DENSITY"))                 #将宽格式数据转换为长格式

datatk_ts |>
plot_time_series(date, value,
                 .facet_scale = "free",
                 .interactive = FALSE,
                 .title = "VERCah of Doubs river")

datatk_ts |>
  tk_summary_diagnostics(.date_var = date)        #检查时间序列的规律性

datatk_ts1 <- mydata |>
  tk_tbl() |> 
  mutate(DATE = as_date(as.POSIXct.Date(DATE))) |>
  select(-1) |>
  rename(date = DATE) |>
  relocate(date, .before = STATION)

# 2.1 提取特征
# 2.1.1 日期时间特征
datatk_ts_features_C <- datatk_ts1 |>
  mutate(DENSITY =  log1p(x = DENSITY)) |>
  mutate(DENSITY =  standardize_vec(DENSITY)) |>
  tk_augment_timeseries_signature(.date_var = date) |>
  glimpse()

# 日期时间特征可视化
timetk::plot_time_series_regression(.date_var = date,
                                    .data = datatk_ts_features_C,
                                    .formula = DENSITY ~ as.numeric(date) + index.num
                                    + year + half + quarter + month + month.lbl,
                                    .show_summary = TRUE)

# 2.1.2 傅立叶项特征
datatk_ts_features_F <- datatk_ts1 |>
  mutate(DENSITY =  log1p(x = DENSITY)) |>
  mutate(DENSITY =  standardize_vec(DENSITY)) |>
  tk_augment_fourier(.date_var = date, .periods = 5, .K=1) 

# 傅立叶项特征可视化
plot_time_series_regression(.date_var = date, 
                            .data = datatk_ts_features_F,
                            .formula = DENSITY ~ as.numeric(date) + 
                              date_sin5_K1 + date_cos5_K1,
                            .show_summary = TRUE)

# 2.1.3 滞后特征
datatk_ts_features_L <- datatk_ts1 |>
  mutate(DENSITY =  log1p(x = DENSITY)) |>
  mutate(DENSITY =  standardize_vec(DENSITY)) |>
  tk_augment_lags(.value = DENSITY, .lags = c(4, 7))  

# 滞后特征可视化
plot_time_series_regression(.date_var = date, 
                            .data = datatk_ts_features_L,
                            .formula = DENSITY ~ as.numeric(date) + 
                              BIOMASS_lag4 + BIOMASS_lag7,
                            .show_summary = TRUE)

# 2.1.4 窗口特征
datatk_ts_features_M <- datatk_ts1 |>
  mutate(DENSITY =  log1p(x = DENSITY)) |>
  mutate(DENSITY =  standardize_vec(DENSITY)) |>
  tk_augment_lags(.value = DENSITY, .lags = c(4, 7)) |>
  tk_augment_slidify(.value   = contains("DENSITY"),
                     .f       = ~ mean(.x, na.rm = TRUE), 
                     .period  = c(3, 6),
                     .partial = TRUE,
                     .align   = "center")

# 窗口特征可视化
plot_time_series_regression(.date_var = date, 
                            .data = datatk_ts_features_M,
                            .formula = DENSITY ~ as.numeric(date) + 
                              BIOMASS_roll_3 + BIOMASS_roll_6,
                            .show_summary = TRUE)

# 2.1.5 集合所有特征
datatk_ts_features_all <- datatk_ts1 |>
  mutate(DENSITY =  log1p(x = DENSITY)) |>
  mutate(DENSITY =  standardize_vec(DENSITY)) |>
  # 日期时间特征
  tk_augment_timeseries_signature(.date_var = date) |>
  select(-diff, -matches("(.xts$)|(.iso$)|(hour)|(minute)|(second)|(day)|(week)|(am.pm)")) |>
  select(-month.lbl) |>
  mutate(index.num = normalize_vec(x = index.num)) |>
  mutate(year = normalize_vec(x = year)) |>
  # 傅立叶特征
  tk_augment_fourier(.date_var = date, .periods = 5, .K=1) |>
  # 滞后特征
  tk_augment_lags(.value = DENSITY, .lags = c(4,7)) |>
  # 窗口特征
  tk_augment_slidify(.value   = contains("DENSITY"),
                     .f       = ~ mean(.x, na.rm = TRUE), 
                     .period  = c(3, 6),
                     .partial = TRUE,
                     .align   = "center")

datatk_ts_features_all |> glimpse()

# 集合所有特征可视化
plot_time_series_regression(.date_var = date, 
                            .data = datatk_ts_features_all,
                            .formula = DENSITY ~ as.numeric(date) + 
                              index.num + year + half + quarter + month + 
                              date_sin5_K1 + date_sin5_K1 + 
                              # BIOMASS_lag4 + BIOMASS_lag7 + 
                              BIOMASS_roll_3 + BIOMASS_roll_6,
                            # BIOMASS_lag4_roll_3 + BIOMASS_lag7_roll_3 + 
                            # BIOMASS_lag4_roll_6 + BIOMASS_lag7_roll_6,
                            .show_summary = TRUE)

# 2.2 利用tidymodels包建立预测模型
# 2.2.1 训练/测试集拆分
splits <- datatk_ts1 |>
  time_series_split(date,
                    assess = "3 year",
                    cumulative = TRUE)
n_rows <- nrow(datatk_ts1)
train_rows <- round(0.8 * n_rows)

train_data <- datatk_ts1 |>
  slice(1:train_rows) 
test_data <- datatk_ts1 |>
  slice((train_rows):n_rows)

ggplot() +
  geom_line(data = train_data, 
            aes(x = date, y = DENSITY, color = "Training"), 
            linewidth = 1) +
  geom_line(data = test_data, 
            aes(x = date, y = DENSITY, color = "Test"), 
            linewidth = 1) +
  scale_color_manual(values = c("Training" = "blue", 
                                "Test" = "red")) +
  labs(title = "Training and Test Sets", 
       x = "DATE", y = "DENSITY") +
  theme_minimal()

your_data <- tibble(  
  date = datatk_ts1$date,  
  value = datatk_ts1$DENSITY )  

base_date <- as.Date("1994-05-01")  
your_data_numeric <- your_data %>%  
  mutate(  
    date_numeric = as.numeric(date - base_date) + 1,
    value_interpolated = na.approx(value, na.rm = FALSE)  
  ) 

print(your_data_interpolated)  

# 2.2.2 构建和选择特征
recipe_spec_final <- recipe(DENSITY ~ ., train_data) |>
  step_mutate_at(index, fn = ~if_else(is.na(.), -12345, . )) |>
  step_timeseries_signature(date) |>
  step_rm(date) |>
  step_zv(all_predictors()) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE)

summary(prep(recipe_spec_final))

# 2.2.3 训练和评估模型
# 2.2.3.1 训练增强树模型
bt <- workflow() |>
  add_model(
    boost_tree("regression") |> set_engine("xgboost")
  ) |>
  add_recipe(recipe_spec_final) |>
  fit(train_data)

bt

# 评估树模型
bt <- workflow() |>
add_model(
  boost_tree("regression") |> set_engine("xgboost")
) |>
  add_recipe(recipe_spec_final) |>
  fit(train_data)

bt_test <- bt |> 
  predict(test_data) |>
  bind_cols(test_data) 

bt_test

pbt <- ggplot() +
  geom_line(data = train_data, 
            aes(x = DATE, y = DENSITY, color = "Train"), 
            linewidth = 1) +
  geom_line(data = bt_test, 
            aes(x = DATE, y = DENSITY, color = "Test"), 
            linewidth = 1) +
  geom_line(data = bt_test, 
            aes(x = DATE, y = .pred, color = "Test_pred"), 
            linewidth = 1) +
  scale_color_manual(values = c("Train" = "blue", 
                                "Test" = "red",
                                "Test_pred" ="black")) +
  labs(title = "bt-Train/Test and validation", 
       x = "DATE", y = "DENSITY") +
  theme_minimal()

# 计算树模型预测误差
bt_test |>
  metrics(BIOMASS, .pred)

# 2.2.3.2 训练随机森林模型
rf <- workflow() |>
  add_model(
    spec = rand_forest("regression") |> set_engine("ranger")
  ) |>
  add_recipe(recipe_spec_final) |>
  fit(train_data)

rf

# 评估随机森林模型
rf_test <- rf |> 
  predict(test_data) |>
  bind_cols(test_data) 

rf_test

prf <- ggplot() +
  geom_line(data = train_data, 
            aes(x = DATE, y = DENSITY, color = "Train"), 
            linewidth = 1) +
  geom_line(data = rf_test, 
            aes(x = DATE, y = DENSITY, color = "Test"), 
            linewidth = 1) +
  geom_line(data = rf_test, 
            aes(x = DATE, y = .pred, color = "Test_pred"), 
            linewidth = 1) +
  scale_color_manual(values = c("Train" = "blue", 
                                "Test" = "red",
                                "Test_pred" ="black")) +
  labs(title = "rf-Train/Test and validation", 
       x = "DATE", y = "DENSITY") +
  theme_minimal()

# 计算随机森林模型预测误差
rf_test |>
  metrics(DENSITY, .pred)

pbt + prf

# 不同算法的比较
# 创建模型时间表
model_tbl <- modeltime_table(
  bt,
  rf
)
model_tbl

# 校准表
calibrated_tbl <- model_tbl |>
  modeltime_calibrate(new_data = test_data)

calibrated_tbl 

# 模型评估
calibrated_tbl |>
  modeltime_accuracy(test_data) |>
  arrange(rmse)

# 预测图
calibrated_tbl |>
  modeltime_forecast(
    new_data    = test_data,
    actual_data = datatk_ts1,
    keep_data   = TRUE 
  ) |>
  plot_modeltime_forecast(
    .facet_ncol         = 2, 
    .conf_interval_show = FALSE,
    .interactive        = TRUE
  )

#--------------------------------------------------------
# 保存结果
workflow_Doubs <- list(
  
  workflows = list(
    
    wflw_random_forest = rf,
    wflw_xgboost = bt
    
  ),
  
  calibration = list(calibration_tbl = calibrated_tbl)
  
)

workflow_Doubs |>
  write_rds("data/TSdata/workflows_Doubs_list.rds")