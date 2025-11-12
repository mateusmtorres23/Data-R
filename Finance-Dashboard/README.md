# 💸 Expense Tracker Dashboard — Shiny App

This project is an **interactive web dashboard** built with **R and Shiny** for exploring and visualizing **personal finance data**.
Using the dataset **Expense Tracker – Personal_Finance_Dataset.csv**, the app allows users to filter and analyze expenses by category, date, and type, displaying **dynamic charts and quick summary statistics**.

---

## 🎯 Objective

Build a **simple and functional dashboard** to visualize spending patterns and apply data analysis and interactive visualization techniques using R.

---

## ⚙️ Technologies

| Category | Tool |
|-----------|------|
| Web Interface | **Shiny** |
| Interactive Charts | **Plotly** |
| Dynamic Tables | **DT** |
| Data Manipulation | **dplyr**, **ggplot2** |
| Styling and Layout | **bslib** |

---

## 🧩 Features

- 📊 Interactive charts with filters (category, date, type of expense, etc.)
- 🧮 Quick statistics (totals, averages, record counts)
- 📅 Dynamic filters using `selectInput()` and `sliderInput()`
- 📋 Interactive tables with pagination and search
- 🌐 Online deployment via **shinyapps.io**

---

## 🚀 How to Run Locally

1.  **Install the required packages:**
    ```R
    install.packages(c("shiny", "plotly", "DT", "dplyr", "ggplot2", "bslib"))
    ```
2.  **Run the app:**
    ```R
    library(shiny)
    runApp("app.R")
    ```
3.  **Access the app in your browser at:**
    `http://127.0.0.1:xxxx`

---

## 🌍 Live Version

The dashboard is available online at:
👉 [mat-mtorres.shinyapps.io/Finance-Dashboard](https://mat-mtorres.shinyapps.io/Finance-Dashboard)

---

## 💡 Key Learnings

- Building interactive dashboards with Shiny.
- Using reactive programming for live data updates.
- Combining Plotly and DT for rich data visualization.
- Deploying R apps on shinyapps.io.
