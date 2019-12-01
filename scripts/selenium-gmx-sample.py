import os
from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException

# CRON # 0 22 * * * / usr/bin/python / SCRIPTPATH

#
# init
#

chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument('--headless')
# required when running as root user. otherwise you would get no sandbox errors.
chrome_options.add_argument('--no-sandbox')
driver = webdriver.Chrome(executable_path='/opt/selenium/chromedriver/chromedriver', chrome_options=chrome_options,
                          service_args=['--verbose', '--log-path=/var/log/chromedriver.log'])

#
# login once a day
#
driver.get(os.environ["SWM_SELENIUM_GMX_DOMAIN"])

element = driver.find_element_by_id("freemailLoginUsername")
element.send_keys(os.environ["SWM_SELENIUM_GMX_MAIL"])

element = driver.find_element_by_id("freemailLoginPassword")
element.send_keys(os.environ["SWM_SELENIUM_GMX_PASSWORD"])

element = driver.find_element_by_xpath("//input[@value='Login']")
element.click()

element = driver.find_element_by_xpath("//pos-icon-item[2]/span/pos-svg-icon")
element.click()

#
# finish
#

driver.quit()
