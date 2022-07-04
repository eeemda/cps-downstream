#R script that generates tables for downstream experiment paper

library(xtable)
library(foreign)
library(tidyverse)
library(here)

# Setting Directories
rootFolder <- here::here("data/output/tables/")

setwd(rootFolder)

#############
# Balance test:
#############
# Produces table for balance tests in main body of paper:
balance <- read.csv("balance.csv", header = T)
attach(balance)
colnames(balance) <- c("Difference in Means", "Standard Error", "N Control", "N Treated")
rownames(balance) <- c("Normalized baseline Telugu Score", "Normalized baseline math score", "At least one parent has completed grade 10", "Household asset index", "Scheduled Caste or Tribe", "Male", "Age", "Muslim", "Voted: Lok Sabha 2009", "Voted: Vidhan Sabha 2009")

balance_test <- xtable(balance, align = "lrrrr")
label(balance_test) <- "table:balance"
caption(balance_test) <- "Balance Tests Between Treatment and Control Groups"
print(balance_test, file = "balancetest.tex", caption.placement = "top", floating = F, booktabs = T)

############
# Summary Statistics
############
summary <- read.csv("summary.csv", header = T)
attach(summary)

summary <- summary %>%
	mutate(
		summary4 = ifelse(summary4 == -0.00, summary4 * -1, summary4)
	)

colnames(summary) <- c("", "Treatment Mean", "Treatment SD", "Treatment N", "Control Mean", "Control SD", "Control N")
rounding <- matrix(c(rep(2, 104), rep(0, 26), rep(2, 2), rep(0, 1), rep(2, 4), rep(0, 1), rep(2, 4), rep(0, 1), rep(2, 6), rep(0, 1), rep(2, 6), rep(2, 2), rep(0, 1), rep(2, 4), rep(0, 1), rep(2, 4), rep(0, 1), rep(2, 6), rep(0, 1), rep(2, 6), rep(0, 26)),
	nrow = 26, ncol = 8, byrow = F)

summary_statistics <- xtable(summary, align, "llrrrrr", digits = rounding)
label(summary_statistics) <- "table:summarystatistics"
caption(summary_statistics) <- "Summary Statistics"

print(summary_statistics, file = "summarystatistics.tex", caption.placement = "top", include.rownames = F, booktabs = T, floating = F)

############
# Appendix Summary Statistics
############

summaryappendix <- read.csv("summaryappendix.csv", header = T)
attach(summaryappendix)
colnames(summaryappendix) <- c("", "Treatment Mean", "Treatment SD", "Treatment N", "Control Mean", "Control SD", "Control N")

summary_statistics_appendix <- xtable(summaryappendix, align, "llrrrrr")
label(summary_statistics_appendix) <- "table:appendixsummarystatistics"
caption(summary_statistics_appendix) <- "Summary Statistics for Controls Used in Appendix"

print(summary_statistics_appendix, file = "summarystatisticsappendix.tex", caption.placement = "top", include.rownames = F, booktabs = T)

############
# Generating table of comparison between field experiment and census data:
############

comparison <- read.csv("sample_comparison.csv")
attach(comparison)

colnames(comparison) <- c("", "Downstream Sample", "Census: Survey Villages", "Census: Survey Districts", "Census: All India")
table_comparison <- xtable(comparison, align = "llrrrr")
print(table_comparison, file = "comparison.tex", caption.placement = "top", include.rownames = F, booktabs = T, floating = F)

