3月13日课堂代码笔记

# 赋值
x <- 5
x
10 -> x
x
x <- 10-(2+3) 

# 简单运算
x <- c(2, 8, 3)
y <- c(6, 4, 1)
x + y
x > y

# 基础代码运算
floor(8.9)
ceiling(8.9)
round(8.4)

x <- c(TRUE, TRUE, FALSE, FALSE)
y <- c(TRUE, FALSE, TRUE, FALSE)
!x
x | y
x & y
x || y
x && y

# 绘图
x <- c(1,2,3,4,5)
y<- c(1,4,9,16,25)
plot(x, y)

plot(x, y, pch =0, cex = 1.5, col="red", type="l",lwd=2,lty=1, 
     main="This is a graph",col.main='blue',
     xlab="temperature",ylab="body size") 

legend('topleft',inset=0.05,"body size",lty=3,col='green',lwd=4)

# 多线图
x=seq(2,10,0.1)
y1=x^2
y2=x^3
plot(x,y1,type='l',col='red')
lines(x,y2,col='green')
legend('bottomright',inset=0.05,c("Squares","Cubes"),lty=1,col=c("red","green"),title="Graph type")

abline(a=4,b=5,col='blue') # a= slope and b=intercept
abline(h=c(4,6,8),col="dark green",lty=2)
abline(v=c(4,6,8),col="dark green",lty=2)

# 安装并加载包
install.packages("packagefinder", dependencies = TRUE)
library(packagefinder)
findPackage("community ecology") 

# 包的解释
help(package="tidyverse")

#------------------------------------------

3月15日课堂代码笔记

# getwd() # current working directory
# setwd() # set working directory

x <- pi
class(pi) # 查看变量分类
typeof(pi) # 查看数据类型

a<-4:-10 # 创建整数序列向量
a 
class(a)
typeof(a)

seq_vec<-seq(1,4,by=0.5)  # 从1到4，以0.5为步长逐步增加的序列向量
seq_vec  
class(seq_vec)  

a<-c(1,3,5,7)  # 向量
length(a)      # 向量长度（元素个数）
b<-c(2,4,6,8)  
length(b)
a+b  
length(a+b)
a-b  
a/b  

vec <- c(3,4,5,6)  # 创建向量
char_vec<-c("shubham","nishka","gunjan","sumit")  
logic_vec<-c(TRUE,FALSE,FALSE,TRUE)  

out_list<-list(vec,char_vec,logic_vec)  # 创建列表
out_list  

list_data <- list(c("Shubham","Arpita","Nishka"), 
                  matrix(c(40,80,60,70,90,80), nrow = 2),  
                  list("BCA","MCA","B.tech"))  # 创建列表，包含向量、矩阵、列表
list_data  
print(list_data[1])  # 打印第一部分元素
 

list1 <- list(10:20)  
print(list1)  
v1 <- unlist(list1)  # 将列表转换为向量
class(v1)

P <- matrix(c(5:16), nrow = 4, byrow = TRUE) # 创建矩阵数组

emp.data<- data.frame(  
  employee_id = c (1:5),   
  employee_name = c("Shubham","Arpita","Nishka","Gunjan","Sumit"),  
  sal = c(623.3,915.2,611.0,729.0,843.25),   
  starting_date = as.Date(c("2012-01-01", "2013-09-23", "2014-11-15", "2014-05-11",  
                            "2015-03-27")),  
  stringsAsFactors = FALSE)  # 数据框

data <- c("Shubham","Nishka","Arpita","Nishka","Shubham","Sumit","Nishka","Shubham","Sumit","Arpita","Sumit")  
print(data)  
print(is.factor(data)) # 检查向量 data 是否为因子（factor）类型
class(data)
typeof(data)

factor_data<- factor(data) # 将字符向量 data 转换为因子（factor）类型的数据
print(factor_data)  
print(is.factor(factor_data))  

# 将矩阵转换为数据框
dataframe_data=as.data.frame(matrix_data) 
# 将数据框转换为矩阵
matrix_data1 <- data.matrix(dataframe_data1[1:2])
# 将数据框转化为多维数据矩阵
df1 <- data.frame(x = 1:5, y = 5:1)
df2 <- data.frame(x = 11:15,y = 15:11)
Array1 <- array(data = c(unlist(df1),  unlist(df2)),
                dim = c(5, 2, 2),
                dimnames = list(rownames(df1),
                                colnames(df1)))

# 将数据框保存为xlsx类型
library("xlsx") 
write.xlsx(emp.data, file = "data/employee.xlsx", # save in a file
           col.names=TRUE, 
           row.names=FALSE, # if TRUE, get new X. column
           sheetName="Sheet4",
           append = TRUE)
# 保存为csv类型
excel_data<- read.xlsx("data/employee.xlsx", sheetIndex = 4)  
print(excel_data) 
write.csv(excel_data, "data/exployee.csv")

csv_data <- read.csv("data/exployee.csv")  

# 查看数据
str()
head(,x)

#------------------------------------------

3月20日课堂代码笔记

#将向量转换为矩阵,指定了矩阵应该有4行,数据从1到8顺序填充
matrix_data=matrix(c(1,2,3,4,5,6,7,8),nrow = 4)
print(matrix_data)
class(matrix_data)
dataframe_data1<-data.frame(a=1:3,b=letters[10:12],
                            c=seq(as.Date("2004-01-01"),by="week",length.out=3),
                            stringsAsFactors = TRUE)
#用于控制字符型变量是否转换为因子（factor）,因子是一种特殊数据类型用于表示分类变量，通常用于有限个数的离散取值。
class(dataframe_data1)#分类
matrix_data<-data.matrix(dataframe_data1[1:2])#[1:2]是指第1和2列的数据，[1,2]是指第一行第二列的数据

df1<-data.frame(x=1:10,y=10:1)
df2<-data.frame(x=11:15,y=15:11)
# 创建数组并指定维度名称 
Array1<-array(data = c(unlist(df1),unlist(df2),
                       dim=c(5,2,2),
                       dimnames = list(rownames(df1),
                                       colnames(df2)))) #c(5,2,2)中最后一个2是指第二个数组    

#apply
m1<-matrix(c(1:10),nrow = 5,ncol = 6)
a_m1<-apply(m1,2,sum)#这里的2是margin,margin=1(行)或者2（列）  #是指对m1中每一列的数据进行求和

#lapply
movies<-c("A","B","C")
movies_lower<-lapply(movies,tolower)#将小写功能应用于向量
str(movies_lower)#查看
#将包含电影名称的向量 movies 中的每个元素转换为小写字母，并将结果存储在一个新的列表 movies_lower 中

films_lower<-unlist(movies_lower)
#使用 unlist() 函数将存储在列表 movies_lower 中的元素转换为一个单独的向量。list函数用于将列表转换为向量。

dt<-cars
lmn_cars<-lapply(dt,min)
#使用lapply()函数从cars数据集中提取每列的最小值，并将结果存储在一个列表lmn_cars中

avg<-function(x){(min(x)+max(x))/2}
fcars<-sapply(dt,avg)
#对cars数据集中的每一列应用一个自定义函数avg，该函数计算每列数据的最小值和最大值的平均值，并将这些平均值存储在向量fcars中

data(iris)
tapply(iris$Sepal.Width, iris$Species, median)
#用了tapply()函数。第一个参数iris$Sepal.Width是要进行分组的数值向量，第二个参数iris$Species指定了分组的依据，
#按照鸢尾花的种类进行分组。最后一个参数median表示对每个组应用的函数，即计算每个组的中位数。

any(grepl("xlsx",install.packages()))#确定是否有安装这个包
library(xlsx)
write.xlsx(emp.data,file=文件地址"data/employee.xlsx",
           col.name=TRUE,row.name=TRUE,sheetName="sheet2",
           append=TRUE)
#emp.data: 这是要写入到 Excel 文件中的数据框（data frame）
#file="data/employee.xlsx": 这表示要写入的 Excel 文件的文件路径和文件名。在这个例子中，文件将被写入到名为 "employee.xlsx" 的 "data" 文件夹中。
#col.name=TRUE: 这表示是否在写入数据时包括列名。设置为 TRUE 表示包括列名。
#sheetName="sheet2": 这表示要将数据写入到 Excel 文件中的工作表的名称。在这个例子中，数据将被写入到名为 "sheet2" 的工作表中。
#append=TRUE: 这表示是否将数据追加到现有的 Excel 文件中。设置为 TRUE 表示追加数据。如果设置为 FALSE，则会覆盖现有文件中的数据。
excel_data<-read.xlsx("data/employee.xlsx",sheetIndex=2)#sheetIndex=2: 这表示要读取的工作表在 Excel 文件中的索引号。代码尝试读取索引号为2的工作表
write.csv(excel_data,"data/employee.csv")#将名为 excel_data 的数据写入到名为 "employee.csv" 的 CSV 文件中



#is.na() 函数用于检查单个数值和向量中的元素是否是缺失值
surveys_sml<-surveys %<%
  filter(weight<5)%>%
  select(species_id,sex,weight)
#从原始的 surveys 数据集中选择出体重小于5的记录，并且只保留了 species_id、sex 和 weight 这三个变量，将处理后的结果保存到了 surveys_sml 中

#------------------------------------------

3月22日课堂代码笔记

download.file("tinyurl.com/dcmac2017dec/data/surveys_wide.csv",dest="D:/Ryuyanshuju/github--Rstudio/SA23008215/surveys_wide.csv")
surveys_wide<-read.csv("D:/Ryuyanshuju/github--Rstudio/SA23008215/surveys_wide.csv")
head(surveys_wide)

surveys_gather<-surveys_wide %>%
  gather(key = year, value = plot_id)
str(surveys_gather)
head(surveys_gather)
tail(surveys_gather)

spread(surveys_gather,key = year, value = plot_id)
surveys_gw<-surveys

ggplot(data=surveys_wide,
       aes(x=weight,y=hindfoot_length))

ggplot(data = surveys, 
       aes(x = species_id, y = weight)) +
  geom_boxplot(alpha = 0) +
  geom_jitter(alpha = 0.3, color = "green") 

#-------------------------------------------

3月27日课堂代码笔记

cart for classification

class<-as.factor(c(0,0,0,0,0,1,1,1,1,1))
x1<-c(4,4,5,5,5,5,3,5.6,6,6.5,6.2,5.9)
x2<-c(9,10,11,10,9,8,7,8,7,8)
df<-cbind.data.frame(class,x1,x2)#把这三个数据集以列的方式组合成一个数据框

plot(x1,x2,col="white")
points(x1[class=="0"],x2[class=="0"],col="blue",pch=19)
points(x1[class=="1"],x2[class=="1"],col="red",pch=19)

predictor1test<-seq(from=3,to=7,by=0.1)
length(predictor1test)
predictor2test<-seq(from=7,to=11,by=0.1)
length(predictor2test)

calculatep<-function(i,index,m,k){if(m=="L"){Nm<-length(df$class[which(df[,index]<=i)])
count<-df$class[which(df[,index]<=i)]==k}else{Nm<-length(df$class[which(df[,index]>i)])
count<-df$class[which(df[,index]>i)]==k}
p<-length(count[count==TRUE])/Nm return(c(P,Nm))}

calculategini<-function(x,index){gini<-NULL for(i in x){
  pl0<-calculatep(i,index,"L",0)
  pl1<-calculatep(i,index,"L",1)
  ginil<-pl0[1]*(1-pl0[1])+pl1[1]*(1-pl1[1])
  pr0<-calculatep(i,index,"R",0)
  pr1<-calculatep(i,index,"R",1)
  gini<-rbind(gini,sum(ginil*pl0[2]/(pl0[2]+pr0[2]),ginir*pr))
}return(gini)}

#-------------------------------------------

3月29日课堂代码笔记

# install.packages(c('caret', 'skimr', 'RANN', 'randomForest', 'fastAdaboost', 'gbm', 'xgboost', 'caretEnsemble', 'C50', 'earth'))

install.packages("caret")
library(caret)
orange <- read.csv('https://raw.githubusercontent.com/selva86/datasets/master/orange_juice_withmissing.csv')
orange<-read.csv()
str(Orange)
head(orange[,1:10])

# 创建训练和测试数据集
set.seed(100)

# Step 1: Get row numbers for the training data
trainRowNumbers <- createDataPartition(orange$Purchase, p=0.8, list=FALSE)
# 将源数据集中的 Y 变量和应进入训练的百分比数据作为参数作为输入
# 返回应构成训练数据集的行号
# 防止将结果作为列表返回

# Step 2: Create the training  dataset
trainData <- orange[trainRowNumbers,]

# Step 3: Create the test dataset
testData <- orange[-trainRowNumbers,]

# Store X and Y for later use.
x = trainData[, 2:18]
y = trainData$Purchase

install.packages("skimr")
library(skimr)
skimmed <- skim_to_wide(trainData)
skimmed[, c(1:5, 9:11, 13, 15:16)]

# Create the knn imputation model on the training data
# 设置 k 最近邻并将其应用于训练数据。这将创建一个模型
preProcess_missingdata_model <- preProcess(trainData, method='knnImpute')
preProcess_missingdata_model

# Pre-processing:
# - centered (16)
# - ignored (2)
# - 5 nearest neighbor imputation (16)
# - scaled (16)
# 上面的输出显示了在 knn 插补过程中完成的各种预处理步骤。
# 也就是说，它居中（减去平均值）16 个变量，忽略 2 个变量，使用 k=5（考虑 5 个最近邻）来预测缺失值，最后缩放（除以标准差）16 个变量

# 使用此模型来预测中的缺失值
install.packages("RANN")
library(RANN)  # required for knnInpute
trainData <- predict(preProcess_missingdata_model, newdata = trainData)
anyNA(trainData)
# 所有缺失值均已成功插补

#-------------------------------------------

4月3日课堂代码笔记

# creat a API request(url)

base_url="https:data.colorado.gov/resource "
install.packages('reticulate') # Install R package for interacting with Python
library(reticulate)
use_python("C:/Users/22651/AppData/Local/r-miniconda/python.exe")
py_config()
py_install("retriever")
retriever <- import("retriever")


reticulate::install_miniconda() # Install Python
reticulate::py_install('retriever') # Install the Python retriever package
install.packages('rdataretriever') # Install the R package for running the retriever
library(rdataretriever)
rdataretriever::get_updates()  # Update the available datasets
reticulate::py_config()
install.packages("rdataretriever", dependencies = TRUE)


library(reticulate)
py_install("pip")  # 安装 pip
py_run_string("import sys; sys.stdout.write(str(sys.path))")

install.packages("devtools")
library(devtools)
install_github("ropensci/rdataretriever")
library(rdataretriever)


library(reticulate)
py_install("pip")  # 安装 pip
py_run_string("import sys; sys.stdout.write(str(sys.path))")

# rdataretriever::get_updates()  # Update the available datasets
Please wait while the retriever updates its scripts, ...
List of 22
$ python              : chr "C:/Users/22651/AppData/Local/r-miniconda/python.exe"
$ libpython           : chr "C:/Users/22651/AppData/Local/r-miniconda/python312.dll"
$ pythonhome          : chr "C:/Users/22651/AppData/Local/r-miniconda"
$ pythonpath          : chr "C:\\Users\\22651\\AppData\\Local\\R\\win-library\\4.3\\reticulate\\config;C:\\Users\\22651\\AppData\\Local\\R-M"| __truncated__
$ prefix              : chr "C:\\Users\\22651\\AppData\\Local\\R-MINI~1"
$ exec_prefix         : chr "C:\\Users\\22651\\AppData\\Local\\R-MINI~1"
$ base_exec_prefix    : chr "C:\\Users\\22651\\AppData\\Local\\R-MINI~1"
$ virtualenv          : chr ""
$ virtualenv_activate : chr ""
$ executable          : chr "C:\\Users\\22651\\AppData\\Local\\R-MINI~1\\python.exe"
$ base_executable     : chr "C:\\Users\\22651\\AppData\\Local\\R-MINI~1\\python.exe"
$ version_string      : chr "3.12.1 | packaged by Anaconda, Inc. | (main, Jan 19 2024, 15:44:08) [MSC v.1916 64 bit (AMD64)]"
$ version             : chr "3.12"
$ architecture        : chr "64bit"
$ anaconda            : logi TRUE
$ conda               : chr "True"
$ numpy               : NULL
$ required_module     : chr "retriever"
$ required_module_path: NULL
$ available           : logi TRUE
$ python_versions     : chr "C:/Users/22651/AppData/Local/r-miniconda/python.exe"
$ forced              : chr "use_python() function"
- attr(*, "class")= chr "py_config"
错误: Python module retriever was not found.

Detected Python configuration: