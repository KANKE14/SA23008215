# HEADER------------------------------------
#
# Author:     sunyuyu
# Copyright   Copyright 2024-sunyuyu
# Email:      sunyuyu@email.ustc.edu.cn
#
# Date:       2024-03-24
#
# Script Name:data_manipul.R
#
# Script Description:1.import data; 
#                    2.inspect data structure; 
#                    3.check whether a column or row has missing data;
#                    4.extract values from a column or select/add a column;
#                    5.transform a wider table to along format;
#                    6.visualize the data;
#                    7.save data.
#
# SETUP ----------------------------------------------


# 1.import data
download.file("tinyurl.com/dcmac2017dec/data/surveys_wide.csv",
              dest="D:/Ryuyanshuju/github--Rstudio/SA23008215/surveys_wide.csv")
                       #从指定路径下载文件surveys_wide.csv,
                       #并通过dest参数将下载的文件保存至指定位置

library(tidyverse)     #加载tidyverse包

surveys <- read.csv("D:/Ryuyanshuju/github--Rstudio/SA23008215/portal_data_joined.csv")

surveys_wide <- read.csv("D:/Ryuyanshuju/github--Rstudio/SA23008215/surveys_wide.csv")
                       # 使用read.csv()函数从指定路径导入CSV文件存储为surveys_wide数据框


# 2.inspect data structure
str(surveys)           # 使用str()函数查看surveys数据框的结构和摘要信息


# 3.check whether a column or row has missing data
any(is.na(surveys))    # 使用any()函数检查surveys数据框是否有缺失值


# 4.extract values from a column or select/add a column
surveys_sml <- surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)
# 使用select()函数对surveys数据框进行筛选操作，只保留体重小于5的动物观测，
# 保留筛选结果获得数据中的species_id， sex，和weight这三列，舍弃其他列
# 将结果保存到surveys_sml的新数据框中

head(surveys_sml,5)    # 使用head()函数查看surveys_sml数据框的前五行内容


# 5.transform a wider table to along format
surveys_gather<-surveys %>%
  gather(key=species_id,value=hindfoot_length, -c(month:plot_id))
# 利用gather()函数将 surveys 数据框中 month到plot_id四列外的所有列从宽格式转换为长格式
# 并将 species_id 和 hindfoot_length 两列合并，将结果保存到surveys_gather的新数据框中

head(surveys_gather，5)# 使用head()函数查看surveys_gather数据框的前五行内容


# 6.visualize the data
ggplot(data = surveys, 
       aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1, 
             aes(color = species_id))
# 基于surveys数据框，以weight为x轴变量，hindfoot_length为y轴变量，创建一个散点图
# 点的透明度为 0.1，并根据每个数据点所对应的species_id来给点着色

ggplot(data = surveys, 
       aes(x = species_id, y = weight)) +
  geom_boxplot(alpha = 0) +
  geom_jitter(alpha = 0.3, color = "green") 
# 基于surveys数据框，以species_id为x轴变量，weight为y轴变量
# 添加箱线图，设置箱线的透明度为 0，只显示箱线的轮廓
# 添加抖动点图，设置了点的透明度为 0.3，颜色为绿色


# 7.save data
write.csv(surveys_gather, "surveys_gather.csv", row.names = FALSE)
# 将surveys_gather数据框导出为名为"surveys_gather.csv"的CSV文件，不包含行号