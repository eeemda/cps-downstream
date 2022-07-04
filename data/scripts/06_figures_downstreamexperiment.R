#Figures for Downstream Experiment Results

library(ggplot2)
library(foreign)
library(gridExtra)
library(grid)
library(readstata13)
library(ggmap)
library(tmap)
library(rgdal)
library(here)

###############################################################################
# Setting Directories
###############################################################################

# Sub-directories:
rootFolder <- paste0(here::here("data/"))
figures <- paste0(here::here("data/output/figures/"))

# Loading dataframes:
plot.part <- read.csv(paste0(figures, "plot_part.csv"), header = T)
plot.nonpart <- read.csv(paste0(figures, "plot_nonpart.csv"), header = T)
plot.privatisation <- read.csv(paste0(figures, "plot_privatisation.csv"), header = T)
plot.valuation <- read.csv(paste0(figures, "plot_valuation.csv"), header = T)
plot.monitor <- read.csv(paste0(figures, "plot_monitoring.csv"), header = T)
plot.evaluation <- read.csv(paste0(figures, "plot_evaluation.csv"), header = T)
plot.english <- read.csv(paste0(figures, "plot_english.csv"), header = T)

#Loading district shapefiles:
distmaps <- paste0(rootFolder, "raw/shapefiles/Districts")
statemaps <- paste0(rootFolder, "raw/shapefiles/States")

setwd(figures)

###################
# MAIN PAPER
###################

#######
# Map of Survey Districts
#######

#Loading maps
state_map <- readOGR(dsn = statemaps, layer = "IND_adm1")
district_map <- readOGR(dsn = distmaps, layer = "IND_adm2")

#Removing Andaman & Nicobar:
state_map <- subset(state_map, NAME_1 != "Andaman and Nicobar")

#Create dummy for AP:
state_map$andhra_dummy <- as.numeric(state_map$NAME_1 == "Andhra Pradesh")

#Subsetting to only have AP:
ap <- subset(district_map, NAME_1 == "Andhra Pradesh")
#Create dummy for project districts:
ap$exp_dummy <- as.numeric((ap$NAME_2 != "Nizamabad") & (ap$NAME_2 != "East Godavari") & (ap$NAME_2 != "Medak") & (ap$NAME_2 != "Vishakhapatnam") & (ap$NAME_2 != "Cuddapah"))

# Creating grey scale colour palette:
grey.colors(n, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL)

#Map of India with AP survey districts highlighted:
pdf("mapdistricts.pdf", width = 10, height = 4)
survey_districts <- tm_shape(state_map) + tm_layout(legend.show = F, frame = F) + tm_borders(lwd = 0.3) + tm_fill(col = "andhra_dummy", palette = "white")
survey_districts <- survey_districts + tm_shape(ap) + tm_fill(col = "exp_dummy", palette = grey.colors(2)) + tm_layout(legend.show = F) + tm_borders(lwd = 0.3)
survey_districts
dev.off()

################
# Partisan Political Participation:
################
figure.part <- ggplot(plot.part, aes(x = beta, y = yaxis)) +
	geom_point(size = 1.5) +
	geom_segment(aes(x = beta - se, y = yaxis, xend = beta + se, yend = yaxis), size = 0.5) +
	geom_segment(aes(x = beta - ((se / 1.96) * 1.645), y = yaxis + 0.035, xend = beta - ((se / 1.96) * 1.645), yend = yaxis - 0.035)) +
	geom_segment(aes(x = beta + ((se / 1.96) * 1.645), y = yaxis + 0.035, xend = beta + ((se / 1.96) * 1.645), yend = yaxis - 0.035)) +
	#SECONDARY AESTHETICS:
	geom_vline(aes(xintercept = 0), linetype = "dashed") +
	#X-AXIS:
	xlim(-0.1, 0.4) +
	xlab("Standard Deviations") +
	theme(axis.line.x = element_blank()) +
	theme(axis.text.x = element_text(color = "black", size = 12)) +
	theme(axis.title.x = element_text(size = 12)) +
	#Y-AXIS:
	scale_y_continuous(breaks = c(1, 2, 3, 4, 5), labels = c("Distributed Political\nLeaflets", "Canvassed for a\nParty", "Attended a\nPolitical Meeting", "Member of a\nPoliticalParty", "Partisan Political\nParticipation Index"), limits = c(0.5,5.5)) +
	theme(axis.title.y = element_blank()) +
	theme(axis.text.y = element_text(color = "black", size = 12)) +
	#BACKGROUND AND TITLE:
	theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank())

figure.height <- nrow(plot.part)
ggsave("figurepartisan.pdf", width = 10, height = figure.height)

########
# Non-Partisan Political Participation:
########
figure.nonpart <- ggplot(plot.nonpart, aes(x = beta, y = yaxis)) +
	geom_point(size = 1.5) +
	geom_segment(aes(x = beta - se, y = yaxis, xend = beta + se, yend = yaxis), size = 0.5) +
	geom_segment(aes(x = beta - ((se / 1.96) * 1.645), y = yaxis + 0.035, xend = beta - ((se / 1.96) * 1.645), yend = yaxis - 0.035)) +
	geom_segment(aes(x = beta + ((se / 1.96) * 1.645), y = yaxis + 0.035, xend = beta + ((se / 1.96) * 1.645), yend = yaxis - 0.035)) +
	#SECONDARY AESTHETICS:
	geom_vline(aes(xintercept = 0), linetype = "dashed") +
	#X-AXIS:
	xlim(-0.15, 0.35) +
	xlab("Standard Deviations") +
	theme(axis.line.x = element_blank()) +
	theme(axis.text.x = element_text(color = "black", size = 12)) +
	theme(axis.title.x = element_text(size = 12)) +
	# Y-Axis:
	scale_y_continuous(breaks = c(1, 2, 3, 4, 5), labels = c("Attended the\nGram Sabha", "Member of an\nSHG", "Member of an\nCooperative Association", "Member of a\nCaste Association", "Non-Partisan Political\n Participation Index"), limits = c(0.5, 5.5)) +
	theme(axis.title.y = element_blank()) +
	theme(axis.text.y = element_text(color = "black", size = 12)) +
	#Background and Title:
	theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank())

figure.height <- nrow(plot.nonpart)
ggsave("figurenonpartisan.pdf", width = 10, height = figure.height)

########
# Preference for Privatisation
########
figure.privatisation <- ggplot(plot.privatisation, aes(x = beta, y = yaxis)) + geom_point(size = 1.5) + geom_segment(aes(x = beta - se, y = yaxis, xend = beta + se, yend = yaxis), size = 0.5)
figure.privatisation <- figure.privatisation + geom_segment(aes(x = beta - ((se/1.96)*1.645), y = yaxis + 0.035, xend = beta - ((se/1.96)*1.645), yend = yaxis - 0.035)) + geom_segment(aes(x = beta + ((se/1.96)*1.645), y = yaxis + 0.035, xend = beta + ((se/1.96)*1.645), yend = yaxis - 0.035))
#Secondary Aesthetics:
figure.privatisation <- figure.privatisation + geom_vline(aes(xintercept = 0), linetype = "dashed")
#x-Axis:
figure.privatisation <- figure.privatisation +  xlim(-0.1, 0.4) + xlab("Standard Deviations") + theme(axis.line.x = element_blank()) + theme(axis.text.x = element_text(color = "black", size = 12)) + theme(axis.title.x = element_text(size = 12))
# Y-Axis:
figure.privatisation <- figure.privatisation + scale_y_continuous(breaks = c(1, 2, 3, 4, 5, 6, 7), labels = c("Private Doctor", "Number of Children in Private Schools", "Voucher Child in Private School", "Private Financing\nof Public Services", "Private Provision\nof Services", "Job in the\nPrivate Sector", "Private Services\nIndex"), limits = c(0.5, 7.5)) + theme(axis.title.y = element_blank()) + theme(axis.text.y = element_text(color = "black", size = 12))
#Background and Title:
figure.privatisation <- figure.privatisation + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank())
figure.height <- nrow(plot.privatisation)
ggsave("figureprivatisation.pdf", width = 10, height = figure.height)

########
# Valuation of Public Services
########
figure.valuation <- ggplot(plot.valuation, aes(x = beta, y = yaxis)) + geom_point(size = 1.5) + geom_segment(aes(x = beta - se, y = yaxis, xend = beta + se, yend = yaxis), size = 0.5)
figure.valuation <- figure.valuation + geom_segment(aes(x = beta - ((se/1.96)*1.645), y = yaxis + 0.035, xend = beta - ((se/1.96)*1.645), yend = yaxis - 0.035)) + geom_segment(aes(x = beta + ((se/1.96)*1.645), y = yaxis + 0.035, xend = beta + ((se/1.96)*1.645), yend = yaxis - 0.035))
#Secondary Aesthetics:
figure.valuation <- figure.valuation + geom_vline(aes(xintercept = 0), linetype = "dashed")
#x-Axis:
figure.valuation <- figure.valuation +  xlim(-0.6, 0.15) + xlab("Standard Deviations") + theme(axis.line.x = element_blank()) + theme(axis.text.x = element_text(color = "black", size = 12)) + theme(axis.title.x = element_text(size = 12))
# Y-Axis:
figure.valuation <- figure.valuation + scale_y_continuous(breaks = c(1, 2, 3), labels = c("Valuation of\nFood Subsidies", "Valuation of\nGovernment Schools", "Valuation of Public\nServices Index"), limits = c(0.5, 3.5)) + theme(axis.title.y = element_blank()) + theme(axis.text.y = element_text(color = "black", size = 12))
#Background and Title:
figure.valuation <- figure.valuation + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank())
figure.height <- nrow(plot.valuation)
ggsave("figurevaluation.pdf", width = 10, height = figure.height)

########
# Government Teachers as Monitors
########
figure.monitor <- ggplot(plot.monitor, aes(x = beta, y = yaxis)) + geom_point(size = 1.5) + geom_segment(aes(x = beta - se, y = yaxis, xend = beta + se, yend = yaxis), size = 0.5)
figure.monitor <- figure.monitor + geom_segment(aes(x = beta - ((se/1.96)*1.645), y = yaxis + 0.035, xend = beta - ((se/1.96)*1.645), yend = yaxis - 0.035)) + geom_segment(aes(x = beta + ((se/1.96)*1.645), y = yaxis + 0.035, xend = beta + ((se/1.96)*1.645), yend = yaxis - 0.035))
#Secondary Aesthetics:
figure.monitor <- figure.monitor + geom_vline(aes(xintercept = 0), linetype = "dashed")
#x-Axis:
figure.monitor <- figure.monitor +  xlim(-0.1, 0.1) + xlab("Standard Deviations") + theme(axis.line.x = element_blank()) + theme(axis.text.x = element_text(color = "black", size = 12)) + theme(axis.title.x = element_text(size = 12))
# Y-Axis:
figure.monitor <- figure.monitor + scale_y_continuous(breaks = c(1, 2), labels = c("Teachers in this Village\nWork as Census Enumerators", "Teachers in this Village\nWork as Election Monitors"), limits = c(0.5, 2.5)) + theme(axis.title.y = element_blank()) + theme(axis.text.y = element_text(color = "black", size = 12))
#Background and Title:
figure.monitor <- figure.monitor + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank())
figure.height <- nrow(plot.monitor)
ggsave("figuremonitor.pdf", width = 10, height = figure.height)

########
# Evaluation of Quality of Government Teachers
########
figure.evaluation <- ggplot(plot.evaluation, aes(x = beta, y = yaxis)) + geom_point(size = 1.5) + geom_segment(aes(x = beta - se, y = yaxis, xend = beta + se, yend = yaxis), size = 0.5)
figure.evaluation <- figure.evaluation + geom_segment(aes(x = beta - ((se/1.96)*1.645), y = yaxis + 0.035, xend = beta - ((se/1.96)*1.645), yend = yaxis - 0.035)) + geom_segment(aes(x = beta + ((se/1.96)*1.645), y = yaxis + 0.035, xend = beta + ((se/1.96)*1.645), yend = yaxis - 0.035))
#Secondary Aesthetics:
figure.evaluation <- figure.evaluation + geom_vline(aes(xintercept = 0), linetype = "dashed")
#x-Axis:
figure.evaluation <- figure.evaluation +  xlim(-0.2, 0.1) + xlab("Standard Deviations") + theme(axis.line.x = element_blank()) + theme(axis.text.x = element_text(color = "black", size = 12)) + theme(axis.title.x = element_text(size = 12))
# Y-Axis:
figure.evaluation <- figure.evaluation + scale_y_continuous(breaks = c(1, 2), labels = c("Teachers Treat All\nStudents Equally", "Teachers Care about the\nWell-Being of Students"), limits = c(0.5, 2.5)) + theme(axis.title.y = element_blank()) + theme(axis.text.y = element_text(color = "black", size = 12))
#Background and Title:
figure.evaluation <- figure.evaluation + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank())
figure.height <- nrow(plot.evaluation)
ggsave("figureevaluation.pdf", width = 10, height = figure.height)

########
# English Language Schools
########
figure.english <- ggplot(plot.english, aes(x = beta, y = yaxis)) + geom_point(size = 1.5) + geom_segment(aes(x = beta - se, y = yaxis, xend = beta + se, yend = yaxis), size = 0.5)
 figure.english <- figure.english + geom_segment(aes(x = beta - ((se/1.96)*1.645), y = yaxis + 0.035, xend = beta - ((se/1.96)*1.645), yend = yaxis - 0.035)) + geom_segment(aes(x = beta + ((se/1.96)*1.645), y = yaxis + 0.035, xend = beta + ((se/1.96)*1.645), yend = yaxis - 0.035))
#Secondary Aesthetics:
figure.english <- figure.english + geom_vline(aes(xintercept = 0), linetype = "dashed")
#x-Axis:
figure.english <- figure.english +  xlim(-2, 2) + xlab("Standard Deviations") + theme(axis.line.x = element_blank()) + theme(axis.text.x = element_text(color = "black", size = 12)) + theme(axis.title.x = element_text(size = 12))
# Y-Axis:
figure.english <- figure.english + scale_y_continuous(breaks = c(1, 2, 3, 4), labels = c("Valuation of Public\nServices Index", "Private Services\nIndex", "Non-Partisan Political\nParticipation Index", "Partisan Political\nParticipation Index"), limits = c(0.5, 4.5)) + theme(axis.title.y = element_blank()) + theme(axis.text.y = element_text(color = "black", size = 12))
#Background and Title:
figure.english <- figure.english + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank())
figure.height <- nrow(plot.english)
ggsave("figureenglish.pdf", width = 10, height = figure.height)
