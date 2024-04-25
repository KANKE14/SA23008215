# HEADER------------------------------------
#
# Author:     sunyuyu
# Copyright   Copyright 2024-sunyuyu
# Email:      sunyuyu@email.ustc.edu.cn
#
# Date:       2024-04-24
#
# Script Name:geodata_,manipul
#
# Script Description:
#                    1.沿着Doubs河设置2公里的缓冲区，并从地图中截取，
#                    以使用qgisprocess包提取每个点的集水区和坡度的光栅值。
#
#                    2.将提取的数据与Doubs数据集中的其他环境因素合并，形成数据框，
#                    最后将数据框传输到包含几何列的sf对象。
#
#
# SETUP ----------------------------------------------

# 安装所需包
install.packages("sf")
install.packages("terra")
install.packages("raster")
install.packages("hydroTSM")
install.packages("qgisprocess")
remotes::install_github("r-spatial/qgisprocess")
options(qgisprocess.path = "D:/QGIS/bin/qgis_process-qgis-Itr.bat")
                          # 设置工作路径
qgis_configure()
qgis_providers()

# 加载所需包
library(sf)
library(ade4)
library(terra)
library(raster)
library(ggplot2)
library(qgisprocess) 
library(raster)
library(hydroTSM)

# 1.沿着Doubs河设置2公里的缓冲区，并从地图中截取
doubs_river <- sf::st_read("C:/Users/22651/Desktop/doubs-river/doubs_river.shp")
                          # 读取河道地理空间数据
doubs_river_utm <- st_transform(doubs_river,32631)
                          # 转换为 UTM 32631 投影坐标系，方便后续空间分析和制图
map <- terra::rast("C:/Users/22651/Desktop/doubs-river/doubs_dem.tif")
                          # 读取地图高程数据
class(map)

buffer_distance <- 2000   # 设置缓冲区距离为2公里
river_buffer <- st_buffer(doubs_river_utm, dist = buffer_distance)
                          # 沿河设置缓冲区
plot(st_geometry(river_buffer),axes = TRUE)
                          # 可视化缓冲区
ggplot() + geom_sf(data = river_buffer) 
                          # 转换为地理坐标系

# 使用qgisprocess包提取每个点的集水区和坡度的光栅值
terra::crs(map)           # 得到地理坐标系CRS
utm_crs <- "EPSG:32631"   # 设置地理坐标系CRS
map_utm <- terra::project(map,utm_crs)
terra::crs(map_utm)       # 转换成投影坐标系

map_utm_cropped = crop(map_utm,river_buffer)
map_utm_masked = mask(map_utm_cropped,river_buffer)
                          # 根据缓冲区对高程数据进行裁剪
plot(map_utm_masked ,axes =TRUE)
                          # 可视化裁剪后的高程数据
masked_map <- projectRaster(map_utm_masked, crs=crs(map))
                          # 恢复经纬度信息
writeRaster(masked_map, filename = "C:/Users/22651/Desktop/doubs-river/masked_map.tif", format = "GTiff",overwrite=TRUE)
                          # 保存为.tif文件
map_utm_masked<-raster("C:/Users/22651/Desktop/doubs-river/doubs_dem.tif")
                          # 读取高程数据（DEM）

# 调用qgisprocess包查找关于算法
qgis_algorithms()
qgis_show_help("native:buffer")
qgis_search_algorithms("wetness") |>
  dplyr::select(provider_title,algorithm) |>
  head(2)

topo_total = qgisprocess::qgis_run_algorithm(
  alg = "sagang:sagwetnessindex",
  DEM = map_utm_masked,
  SLOPE_TYPE = 1,
  SLOPE = tempfile(fileext = ".sdat"),
  AREA = tempfile(fileext = ".sdat"),
  .quiet = TRUE)

topo_select <- topo_total[c("AREA","SLOPE")] |>
  unlist() |>
  rast()

names(topo_select) = c("carea","cslope")
origin(topo_select) = origin(map_utm_masked)
topo_char = c(map_utm_masked,topo_select)
topo_env <- terra::extract(topo_char,doubs_points_utm,ID = FALSE)

watershed <- area(map_utm_masked)
slope <- terrain(map_utm_masked, opt = "slope")
writeRaster(watershed, filename = "C:/Users/22651/Desktop/doubs-river//watershed.tif", format = "GTiff", overwrite = TRUE)
writeRaster(slope, filename = "C:/Users/22651/Desktop/doubs-river/lope.tif", format = "GTiff", overwrite = TRUE)
                          # 保存集水区和坡度数据
sample_points <- read.csv("C:/Users/22651/Desktop/doubs-river/doubsxy-1.png - 副本.csv")
                          # 从CSV文件中读取采样点数据
watershed_file <- "C:/Users/22651/Desktop/doubs-river//watershed.tif"
slope_file <- "C:/Users/22651/Desktop/doubs-river/lope.tif"
                          # 定义栅格文件路径
watershed_values <- extract(points = sample_points, raster = watershed_file)
slope_values <- qgis_process(points = sample_points, raster = slope_file)
                          # 提取集水区和坡度的栅格值
print(watershed_values)
print(slope_values)       # 输出提取的栅格值

watershed_raster <- raster("C:/Users/22651/Desktop/doubs-river/watershed.tif")
slope_raster<-raster("C:/Users/22651/Desktop/doubs-river/lope.tif")
                          # 加载集水区栅格数据
class(watershed_raster)

watershed_values <- raster::extract(watershed_raster, sample_points[, c("mapX", "mapY")])
slope_values <- raster::extract(slope_raster, sample_points[, c("mapX", "mapY")])
                          # 提取栅格值


# 2.将提取的数据与Doubs数据集中的其他环境因素合并，形成数据框
data("doubs")
env<-doubs$env
fish<-doubs$fish
doubsxy_utm_data<-read.csv("C:/Users/22651/Desktop/doubs-river/doubsxy-1.png - 副本.csv")
doubsxy_utm_Lon<-doubsxy_utm_data[,1]
                          # 提取经度数据
doubsxy_utm_Lat<-doubsxy_utm_data[,2]
                          # 提取纬度数据
doubsxy_data <- read.csv("D:/Ryuyanshuju/github--Rstudio/SA23008215/doubsxy.csv")
doubsxy<-doubsxy_data[, -1]
                          # 提取采样点的x、y坐标信息数据
dim(doubsxy)
fish_sum <- rowSums(fish) # 计算各个采样点所有鱼类数量的和
doubs_env <- cbind(Lon=doubsxy_utm_Lon,Lat=doubsxy_utm_Lat,carea = watershed_values, cslope = slope_values,doubs$env, spe_abund = fish_sum,geometry=doubsxy)
                          # 合并各类环境数据

# 将数据框传输到包含几何列的sf对象
doubs_env_sf <- st_as_sf(doubs_env, coords = c("geometry.x", "geometry.y"), crs = st_crs(32631))
                          # 将数据框转换为 sf 对象
print(doubs_env_sf)       # 显示转换后的 sf 对象

doubs_env_df <- st_drop_geometry(doubs_env_sf)
write.csv(doubs_env_df, "C:/Users/22651/Desktop/doubs-river/doubs_env.csv", row.names = FALSE)
                          # 保存结果