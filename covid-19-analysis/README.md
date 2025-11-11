# 🇧🇷 COVID-19 Data Analysis — Brazil

This project analyzes the progression of COVID-19 in **Brazil** using data from the **Our World in Data (OWID)** compact dataset.  
The goal is to visualize how the number of cases, deaths, and vaccinations evolved over time — and to discuss how vaccination and the end of sanitary measures influenced the pandemic’s trajectory.

---

## 📊 Dataset

- **Source:** Our World in Data (OWID) — [COVID-19 Dataset](https://ourworldindata.org/coronavirus)
- **Variables used:**
  - `date`: observation date  
  - `total_cases`: cumulative number of confirmed cases  
  - `total_deaths`: cumulative number of confirmed deaths  
  - `people_vaccinated`: total people vaccinated

_*the dataset was too big to send to github_

The dataset was filtered to include only data for **Brazil**.

---

## ⚙️ Methods

Analysis performed in **R** using:
```r
tidyverse, lubridate, ggplot2
```
The workflow:

    Data cleaning and selection of relevant variables

    Time-series visualization of cases, deaths, and vaccinations

    Comparative discussion on how vaccination and public policies affected the trends

## 📈 Results and Discussion

The data shows several key insights about the evolution of COVID-19 in Brazil:

    The peak of cases occurred when sanitary measures were relaxed during the beggining of 2022, indicating that reduced social distancing and mask usage directly contributed to the spike in infections.

    Interestingly, the peak of deaths did(Aug 2021 - nov 2021) not coincide with the peak of cases.
    This happened because during the peak of the deaths was the period people started disrespecting the sanitary measures and the vaccine was not yet well spread. 
    Vaccinations began to ramp up during the same period the peak of cases occured, making infections less fatal even as the virus continued to spread.

    The data reveals a strong correlation between the rise in vaccination coverage and the subsequent decline of the pandemic. 
    Vaccination peaks closely aligning with the reduction in cases and most importantly deaths.

    Despite the overall decline in deaths, COVID-19 has not disappeared. There are still new cases being reported n 2025, emphasizing the need for continued monitoring and prevention wiht vaccines.

## 🧩 Tools Used
R, tidyverse, ggplot2, lubridate

## Plots

<img width="273" height="245" alt="image" src="https://github.com/user-attachments/assets/b49cd5f9-85a6-4777-ad2a-4e33bfca863a" />

<img width="270" height="239" alt="image" src="https://github.com/user-attachments/assets/872a76dc-5afe-454e-9a30-eb92441d1bc6" />

<img width="271" height="247" alt="image" src="https://github.com/user-attachments/assets/a407b55e-477c-4c5f-aa79-dbd8c4a43cc2" />

<img width="269" height="243" alt="image" src="https://github.com/user-attachments/assets/870b387d-15ed-41a9-a045-c793f56b63e0" />

<img width="267" height="243" alt="image" src="https://github.com/user-attachments/assets/1d648590-cba3-4a31-994e-8bb28807b03a" />

<img width="267" height="242" alt="image" src="https://github.com/user-attachments/assets/a4bf4d9f-3215-4f31-8bef-8fbb93cbb595" />
