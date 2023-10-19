import requests
import pandas as pd
from bs4 import BeautifulSoup
import time

'''
web scraper to get solar array data from secondsol
author: Jan Luca Uphoff
'''

columns = ['Type', 'Manufacturer', 'Model', 'WattPeak', 'Current', 'Voltage', 'ShortCurrent', 'OpenVoltage', 'Width',
           'Length', 'Weight']

df = pd.DataFrame(columns=columns)
database = "https://www.secondsol.com/de/datenblatt/pv-module/"

for i in range(6035):  # max: 6035
    website = "https://www.secondsol.com/de/datenblatt/pv-module/?manufacturer={}".format(i + 1)
    try:
        r = requests.get(website)
        web = BeautifulSoup(r.text, 'html.parser')
    except requests.exceptions.RequestException as e:
        print("Error to get manufacturer data from {i}")
        time.sleep(10)
        continue

    for ref in web.find("tbody").find_all("a"):
        link = database + ref.get('href')
        # print(link)
        try:
            info = requests.get(link, timeout=20)
            soup = BeautifulSoup(info.text, "html.parser")
        except requests.exceptions.RequestException as e:
            print("Error to get {}".format(link))
            continue

        data = []
        for div in soup.find_all("div", class_="col-8"):
            data.append(div.get_text())
        for div in soup.find_all("div", class_="col-2 text-right p-0"):
            data.append(div.get_text())

        if len(data) == 11:
            new_data = pd.DataFrame([data], columns=columns)
            df = df.append(new_data, sort=False, ignore_index=True)
            if len(df) % 100 == 0:
                #df.to_hdf('./temp.h5', 'df')
                df.to_csv('./temp.csv')
                print("Number of found data: {} ({} manufacturers)".format(len(df), i + 1))  # last read manufacturer
            else:
                print("Number of found data: {} ({} manufacturers)".format(len(df),
                                                                           i + 1))  # last read manufacturer

#df.to_hdf('./secondsol.h5', 'df')
df.to_csv('./secondsol.csv')
print("Process finished!")
