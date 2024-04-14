# HEADER------------------------------------
#
# Author:     sunyuyu
# Copyright   Copyright 2024-sunyuyu
# Email:      sunyuyu@email.ustc.edu.cn
#
# Date:       2024-04-07
#
# Script Name:r_database
#
# Script Description:
#                    1.安装并加载所需的包
#                    2.从 ade4 包中获取 Doubs 数据集
#                    3.连接SQLite、PostgreSQL数据库
#                    4.将数据上传到 SQLite 数据库
#                    5.查看上传到 SQLite 数据库中的doubs_env数据，并关闭数据库连接
#
# SETUP ----------------------------------------------

# 1.安装并加载所需的包
install.packages("reticulate")                     # 安装reticulate包
library(reticulate)
reticulate::py_config()                            # 显示Python配置信息
reticulate::py_install("retriever")                # 安装retriever包
reticulate::install_miniconda()                    # 安装Python Miniconda
system("conda create --name myenv python")         # 创建Python虚拟环境
reticulate::use_condaenv("myenv", required = TRUE) # 激活虚拟环境
use_python("C:/Users/22651/AppData/Local/r-miniconda/envs/r-reticulate/python.exe")
                                                   # 指定使用的Python解释器路径
install.packages(rdataretriever)                 # 安装rdataretriever包
library(rdataretriever)
rdataretriever::get_updates()                      # 更新数据集
rdataretriever::datasets()                         # 列出可用数据集

install.packages("RSQLite")
install.packages("PostgreSQL")
library(reticulate)
library(rdataretriever)
library(DBI)
library(ade4)
library(RSQLite)
library(PostgreSQL)


# 2.从 ade4 包中获取 Doubs 数据集
data("doubs")
str(doubs)


# 3.连接 SQLite 数据库
SQLite_conn<-DBI::dbConnect(RSQLite::SQLite(), dbname = "D:/SQlite/SA23008215.db")
#   连接 PostgreSQL 数据库
PostgreSQL_conn <- dbConnect(RPostgreSQL::PostgreSQL(),
                     dbname = "D:/SQlite/SA23008215.db",
                     host = "localhost",
                     port = "5432",
                     user = "SA23008215",
                     password = "SA23008215")


# 4.将数据上传到 SQLite 数据库
dbWriteTable(SQLite_conn, "doubs_env",     doubs[[1]], append = FALSE)
dbWriteTable(SQLite_conn, "doubs_fish",    doubs[[2]], append = FALSE)
dbWriteTable(SQLite_conn, "doubs_xy",      doubs[[3]], append = FALSE)
dbWriteTable(SQLite_conn, "doubs_species", doubs[[4]], append = FALSE)
#   将数据上传到 PostgreSQL 数据库
dbWriteTable(PostgreSQL_conn, "doubs_env",     doubs[[1]], append = FALSE)
dbWriteTable(PostgreSQL_conn, "doubs_fish",    doubs[[2]], append = FALSE)
dbWriteTable(PostgreSQL_conn, "doubs_xy",      doubs[[3]], append = FALSE)
dbWriteTable(PostgreSQL_conn, "doubs_species", doubs[[4]], append = FALSE)

# 5.查看上传到 SQLite 数据库中的doubs_env数据，并关闭数据库连接
result <- dbGetQuery(SQLite_conn, "SELECT * FROM doubs_env")
print(result)

# 关闭数据库连接
dbDisconnect(SQLite_conn)
dbDisconnect(PostgreSQL_conn)