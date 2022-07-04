* Metadata ********************************************************************
* Name: 02_stata_setup.do
* Author: Emmerich Davies <emmerich.davies@gmail.com>
* Purpose: Download required stata packages

version 16

* Install and load packages
ssc install center
ssc install estout

* To install make_index, you have to download it manually from
* https://github.com/cdsamii/make_index (last accessed 2020/03/23) or from
* Emmerich Davies <emmerich.davies@gmail.com> and place it in "~/data/scripts"
