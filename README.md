This script's intended use is to create a 301 link report from an input csv file. It will do the following.

	- Read in a csv file of urls (assumes first column, no header)
	- http check for each url
	- push from_url, http response code and to_url into a new csv


Example usage

	$ ruby check_301.rb ./input/sites.csv


This will create a new csv file in the /output folder. The file name will be 301\_check\_{date}\_{time}.csv


Example input csv

	http://www.jasonormand.com
	http://www.jasonormand.com/old_blog
	http://www.jasonormand.com/old_blog/sweet-article

Example output csv

	http://www.jasonormand.com, 301, http://jasonormand.com
	http://www.jasonormand.com/old_blog, 301, http://jasonormand.com/blog
	http://www.jasonormand.com/old_blog/sweet-article, 301, http://jasonormand.com/blog/sweet-article