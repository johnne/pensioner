#!/usr/bin/env python
from PyPDF2 import PdfFileReader
import urllib
from bs4 import BeautifulSoup as BS
from selenium import webdriver
import re
import os
import sys
import pandas as pd
from argparse import ArgumentParser
date_re = re.compile("2[0-9]{3}\-[0-9][1-9]\-[0-9][0-9]")
skip_re = re.compile("Sida [0-9]+ av [0-9]+")
driver = webdriver.PhantomJS()

def download_pdf(url, filename):
    fn, headers = urllib.request.urlretrieve(url, filename)
    html = open(fn)
    html.close()


def set_dict(keys):
    d = {}
    for key in keys:
        d[key] = ""
    return d


def get_html(url):
    with urllib.request.urlopen(url) as response:
        html = response.read()
    return html


def count_set_keys(d):
    set_keys = 0
    for key in d.keys():
        if d[key] != "":
            set_keys+=1
    return set_keys


def parse_pdf(fn):
    funds = {}
    pdf = PdfFileReader(open(fn, "rb"))
    keys = ["company","fund_id","fund_name","avg","avg_type","category","fund_type","me","ydev","y5dev","risk"]
    pages = [page.extractText() for page in pdf.pages]
    text = "".join(pages)
    rows = 0
    end_rows = 0
    skip_end_rows = False
    index = 0
    d = set_dict(keys)
    for i, line in enumerate(text.split("\n")):
        line = line.rstrip()
        if len(skip_re.findall(line)) > 0:
            skip_end_rows = True
            rows = 0
            end_rows = 0
            continue
        if skip_end_rows and end_rows<4:
            end_rows += 1
            continue
        if line == "Fondkatalog":
            rows = 0
            index = 0
            d = set_dict(keys)
            continue
        if rows <= 19:
            if rows == 0:
                pdf_date = line
            rows += 1
            continue
        set_keys = count_set_keys(d)
        if set_keys == 11:
            funds[d["fund_id"]] = d
            index = 0
            d = set_dict(keys)
        key = keys[index]
        if index == 3:
            try:
                float(line.replace(",","."))
            except ValueError:
                key = keys[index-1]
                d[key]+=" "
                index-=1
        d[key] += line
        if d[key] == "":
            d[key] = "NA"
        index += 1
        d["avg"] = d["avg"].replace(",",".")
        #for letter, sub in {"å": "a","ä": "a","ö": "o", "Å": "A", "Ä": "A", "Ö": "O"}.items():
        #    d[key] = d[key].replace(letter, sub)
    funds[d["fund_id"]] = d
    return funds


def link_hallbarhetsprofile(fund_df):
    links = []
    found = 0
    sys.stderr.write("Fetching links for {} funds\n".format(len(fund_df)))
    for i, fund_id in enumerate(fund_df.index, start=1):
        if i%10 == 0 and i>0:
            sys.stderr.write("Parsed {}/{} funds ({} links found)\n".format(i,len(fund_df), found))
        url = 'https://www.pensionsmyndigheten.se/service/fondtorg/fond/{}'.format(fund_id)
        html = get_html(url)
        soup = BS(html, features="html.parser")
        hlink = ""
        for link in soup.findAll('a', attrs={'href': re.compile("^http://")}):
            l = link.get('href')
            if "hallbarhetsprofilen.se" in l:
                hlink = l
                found+=1
            else:
                continue
        links.append(hlink)
    sys.stderr.write("{} links found\n".format(found))
    fund_df = fund_df.assign(Link = pd.Series(links, index=fund_df.index))
    return fund_df


def get_vals(url, crits, fund_vals):
    html = get_html(url)
    soup = BS(html)
    for item in soup.findAll('div', attrs={'class': re.compile("."), "style": re.compile(".")}):
        l = item.get("class")
        if len(l) == 2:
            if l[1] == "item":
                try:
                    crit = crits[l[0]]
                    fund_vals[crit] = "Yes"
                except KeyError:
                    continue
    return fund_vals


def init_vals(crits, v):
    d = {}
    for key, value in crits.items():
        d[value] = v
    return d


def lookup_sustainability(fund_df):
    values = {"Klusterbomber, personminor": "Klusterbomber", "Kemiska och biologiska vapen": "Kemiska vapen",
              "Kärnvapen": "Kärnvapen", "Vapen och/eller krigsmateriel": "Vapen/krigsmateriel", "Alkohol": "Alkohol",
              "Tobak": "Tobak", "Kommersiell spelverksamhet": "Spelverksamhet", "Pornografi": "Pornografi",
              "Fossila bränslen (olja, gas, kol)": "Fossila bränslen", "Kol": "Kol", "Uran": "Uran",
              "Genetiskt modifierade organismer (GMO)": "Genmodifierade organismer",
              "Cluster bombs, landmines": "Klusterbomber", "Chemical and biological weapons": "Kemiska vapen",
              "Nuclear weapons": "Kärnvapen", "Weapons and/or munitions": "Vapen/krigsmateriel", "Alcohol": "Alkohol",
              "Tobacco": "Tobak", "Commercial gambling operations": "Spelverksamhet", "Pornography": "Pornografi",
              "Fossil fuels (oil, gas, coal)": "Fossila bränslen", "Coal": "Kol", "Uranium": "Uran",
              "Genetically modified organisms (GMO)": "Genmodifierade organismer"}
    vals = pd.DataFrame()
    comments = {}
    sys.stderr.write("Looking up choices for {} funds\n".format(len(fund_df)))
    for i, fund_id in enumerate(fund_df.index, start=1):
        url = fund_df.loc[fund_id,"Link"]
        if i>0 and i%10==0:
            sys.stderr.write("{}/{} parsed\n".format(i,len(fund_df)))
        if url==url and url!="":
            fund_vals = init_vals(values, "Undviker EJ")
            driver.get(url)
            try:
                p = driver.find_element_by_class_name("products")
            except:
                fund_vals = init_vals(values, "Inget svar")
                _ = pd.DataFrame(fund_vals, index=[fund_id])
                vals = pd.concat([vals, _])
                sys.stderr.write("ERROR: {} (Fund info likely missing)\n".format(url))
                continue
            try:
                items = p.text.split("\n")
            except:
                fund_vals = init_vals(values, "Inget svar")
                _ = pd.DataFrame(fund_vals, index=[fund_id])
                vals = pd.concat([vals, _])
                sys.stderr.write("ERROR: {}\n".format(url))
                continue
            for i, item in enumerate(items):
                try:
                    val = values[item]
                    fund_vals[val] = "UNDVIKER"
                except KeyError:
                    if item == "Fondbolagets kommentar":
                        val = items[i-1]
                        key = "{}_comment".format(val)
                        if items[i+1] in values.keys():
                            continue
                        try:
                            comments[fund_id][key] = items[i+1]
                        except KeyError:
                            comments[fund_id] = {key: items[i+1]}
                    continue
        else:
            fund_vals = init_vals(values, "Inget svar")
        _ = pd.DataFrame(fund_vals, index=[fund_id])
        vals = pd.concat([vals,_])
    return vals,comments


def main():
    parser = ArgumentParser()
    parser.add_argument("out", help="Outfile")
    parser.add_argument("-p", "--pdf",
                        help="Fondkatalog. If empty will download from web.")
    args = parser.parse_args()
    if not args.pdf or not os.path.exists(args.pdf):
        sys.stderr.write("Fetching pdf from pensionsmyndigheten.se\n")
        pdf_url = "https://www.pensionsmyndigheten.se/content/dam/pensionsmyndigheten/blanketter---broschyrer---faktablad/broschyrer-och-faktablad/fondkatalog/Fondkatalog%20fondlista.pdf"
        download_pdf(url=pdf_url, filename="fonder.pdf")
    keys = ["company", "fund_id", "fund_name", "avg", "avg_type", "category", "fund_type", "me", "ydev", "y5dev",
            "risk"]
    sys.stderr.write("Parsing pdf\n")
    if args.pdf and os.path.exists(args.pdf):
        funds = parse_pdf(args.pdf)
    else:
        funds = parse_pdf("fonder.pdf")
    sys.stderr.write("Done. {} funds stored\n".format(len(funds.keys())))
    fund_df = pd.DataFrame(funds).T[keys]
    sys.stderr.write("Fetching links to hallbarhetsprofilen.se\n")
    fund_df = link_hallbarhetsprofile(fund_df)
    vals, comments = lookup_sustainability(fund_df)
    fund_df = pd.merge(fund_df, vals, right_index=True, left_index=True)
    comment_df = pd.DataFrame(comments).T
    fund_df = pd.merge(fund_df, comment_df, right_index=True, left_index=True, how="left")
    fund_df.to_csv(args.out, sep="\t")
    comment_df.to_csv("{}.comments".format(args.out), sep="\t")


if __name__ == '__main__':
    main()
