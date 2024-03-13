# HEADER------------------------------------
#
# Author:             sunyuyu
# Copyright   Copyright 2024-sunyuyu
# Email:              sunyuyu@email.ustc.edu.cn
#
# Date:               2024-03-13
#
# Script Name:        pak_info.R
#
# Script Description: This code will load the tidyverse package, retrieve the 
#                     list of functions available in the package, and then print
#                     the list of functions. Additionally, it demonstrates
#                     how to get help documentation for a specific function
#                     using the help() function. You can run this code in R or
#                     RStudio to access the requested information.
# SETUP ----------------------------------------------
install.packages("tidyverse")

# Get the packagedescription of tidyverse
packageDescription("tidyverse")

# Load the necessary libraries within the tidyverse
library(tidyverse)

# Get the list of functions in tidyverse package
tidyverse_functions <- ls("package:tidyverse")

# Print the list of functions
cat("Functions in tidyverse package:\n")
print(tidyverse_functions)

# Get help documentation for function
help("tidyverse")
