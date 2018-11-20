# Klimatsmarta pensioner
Detta är ett verktyg för att hämta information om fonder listade
på [Pensionsmyndigheten](www.pensionsmyndigheten.se) och länka dessa
till information på [Hållbarhetsprofilen.se](www.hallbarhetsprofilen.se).
Denna information används sedan i verktyget
[klimatklubben.shinyapps.io/pensioner](https://klimatklubben.shinyapps.io/pensioner)
där användare kan jämföra fonder utifrån olika etiska val.

This is a tool to collect information about funds listed at
[Pensionsmyndigheten](www.pensionsmyndigheten.se) and link these to
information at [Hållbarhetsprofilen.se](www.hallbarhetsprofilen.se).
The information is then used in the tool
[klimatklubben.shinyapps.io/pensioner](https://klimatklubben.shinyapps.io/pensioner)
where a use can compare funds based on ethical considerations.


## Installation
You will need a working installation of [conda](https://conda.io/docs/user-guide/install/index.html)
to install the required software.

To install the required software packages run:

```
conda env create -f environment.yaml
```

Activate the created environment and then run:

```
python src/download_funds.py -h
```

to see available options for how to download fund information.

## Shiny app
The Shiny app is located in the directory `pensioner/`.