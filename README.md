This repository provides data, replication code, and a latex manuscript to replicate "The Lessons Private Schools Teach: Using a Field Experiment to Understand the Effects of Private Services on Political Behavior" accepted at _Comparative Political Studies_.

# Contact
For any questions regarding the replication code and data, please contact [Emmerich Davies](mailto:emmerich.davies@gmail.com)

# Replication
Data can be accessed from [CPS's dataverse](https://doi.org/10.7910/DVN/TDUVCJ) or the [author's personal github page](https://github.com/eeemda/cps-downstream)

To replicate the R scripts, the easiest way would likely be to open the `cps_downstream.Rproj` file in RStudio and the files _should_ be easy to run from there.

For stata, you will have to change the absolute paths at the beginning of each stata do-file.

# Data Access
Please email me if gaining access to non-public data is not straightforward. I should be able to point to locations where this is available with requests now if the information below is out of date.

* For the data to reproduce the tables in `data/scripts/08_analysis_academics.do`, please contact [Karthik Muralidharan](mailto:kamurali@ucsd.edu). Data is taken from ["The Aggregate Effect of School Choice: Evidence from a Two-Stage Experiment in India"](https://doi.org/10.1093/qje/qjv013) published in _The Quarterly Journal of Economics_
* For the data to reproduce the table in `data/scripts/04_analysis_downstreamexperiment.do/sample_comparison.csv`, you will need access to files that are not mine to share:
    1. The census rural directory that matches the 2001 and 2011 Indian Census. This was initially downloaded from [Sumit Mishra's website](https://sumitrmishra.github.io/), but is unfortunately no longer available there. Fortunately, this has now been replaced by the [Indian Government's Local Government Directory](https://lgdirectory.gov.in/).
    2. The raw census data. Again, this is publicly available from the [Indian Government's Local Government Directory](https://lgdirectory.gov.in/).
* Likewise, to reproduce `data/output/figures/mapdistricts.pdf`, you will need access to Indian state and district level shapefiles.
    * For state-level shapefiles, those are available at [Datameet's repository of state-level shapefiles](http://projects.datameet.org/maps/states/)
    * For district-level shapefiles, those are available at [Datameet's repository of district-level shapefiles](http://projects.datameet.org/maps/districts/)
* All other data is available in `data/raw`

# Packages

## R Packages
All R packages should be publicly available through CRAN. A list of packages required to run the code here is provided at the top of every script and in `data/scripts/01_r_setup.R`. You can also run `data/scripts/01_r_setup.R` that will check if your computer has the required packages, download, install and load them if not (this is very aggressive), and create the requried file paths. NB: If you clone this repository from github, the file path should automatically be created.

## Stata packages
The code requires two stata packages:
1. [`center`](https://ideas.repec.org/c/boc/bocode/s444102.html). You should be able to install it either by running `data/scripts/02_stata_setup.do` or typing `ssc install center` in your Stata command line.
2. [`estout`](http://repec.org/bocode/e/estout/eststo.html). You should be able to install it either by running `data/scripts/02_stata_setup.do` or typing `ssc install estout` in your Stata command line.
2. [`make_index`](https://github.com/cdsamii/make_index). You will need to manually download this.

# Software versions
Analysis was conducted using Stata V16.1 and R V4.0.2 (2020-06-22)