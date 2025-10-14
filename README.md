# dsci-310-group-8

# Project Title: U.S. Adult Census Income Prediction with Logistic Regression

# List of contributors/authors:

```         
- Michael Tham
- Yui Mikuriya
- Benjamin Gerochi
- Izzy Zhou
```

# Project Summary:

This project aims to investigate income prediction using the UCI Adult Dataset, which compiles demographic and income data from the 1994 U.S. Census. The primary objective is to predict whether an individual earns over \$50,000 annually using factors such as age, education level, and hours worked per week. By employing a logistic regression model, we aim to effectively predict income levels on test cases while assessing model performance using metrics like the ROC curve (AUC ≈ 0.79), sensitivity, specificity, and accuracy.

Some tools and concepts we will include: 
- R programming language for data loading, wrangling, cleaning, and analysis. 
- Docker to containerize our environments. 
- A variety of R packages, including tidyverse, broom, and repr.

Summary of Findings and Implications:
 - Our logistic regression model demonstrated strong predictive power (AUC = 0.7965), highlighting that key factors like education level, age, and hours worked significantly influence income levels. 
 - Higher education and increased work hours are strongly linked to higher income, reinforcing the importance of skill development and labor market participation. 
 - These findings suggest that policy efforts aimed at reducing income inequality should focus on education accessibility and work-life balance initiatives.

Expectations and Results: 
The results align with expectations: 
- Age & Experience: Older individuals generally earn more due to accumulated experience. 
- Education: Those with higher degrees earn significantly more. 
- Work Hours: More hours worked often lead to higher pay.

Future Research: 
- Geographic Factors: Examining regional disparities in income may provide insights into location-based economic opportunities. 
- Demographic Intersections: Investigating how race, gender, and marital status interact with income could enhance model accuracy. 
- Health & Disability: Including health variables could highlight additional barriers affecting earnings potential.

# How to Run the Analysis

To reproduce the analysis, follow these steps:

1.  **Clone the repository**:

    ``` bash
    git clone https://github.com/DSCI-310-2025/dsci-310-group-8.git
    cd dsci-310-group-8
    ```

2.  **Set Up the Environment**:

-   Use the Docker container as described in the "Docker Container Setup" section below
-   Access the RStudio server at http://localhost:8787

3.  **Run the Analysis**:

-   In RStudio's terminal, navigate to the project directory: `cd project`
-   Run the complete analysis pipeline: `make all`
-   The final report will be generated as `docs/index.html`

## View the Published Report

The analysis report is published via GitHub Pages at:
**https://inigogrch.github.io/dsci-workflow-automation/**

# Dependencies

The following dependencies are required to run the analysis:

## Software:

```         
- Docker
- R (version 4.3.1 or higher)
- Docker Compose (recommended)
```

## R Packages:

```         
- tidyverse
- ggplot2
- dplyr
- readr
- docopt
- repr
- pROC
- GGally
- infer
- incomepredictability (our custom package)
```
For more details about the custom package, see the incomepredictability repository: https://github.com/DSCI-310-2025/incomepredictability 

# Docker Container Setup

This project uses Docker to ensure a consistent and reproducible computational environment. The Docker image contains all necessary R packages and dependencies to run the analysis, including our custom `incomepredictability` package.

**Prerequisites**: Ensure Docker Desktop is installed and running on your system.
- [Docker Installation Guide](https://docs.docker.com/get-docker/)

## Option 1: Using Pre-built Image with Docker Compose (Quickest)

The easiest way to get started is using the pre-built image with Docker Compose:

1.  **Pull the latest image**:
    ```bash
    docker pull zx2yizzy/dsci-310-group-8-project-docker:latest
    ```

2.  **Start the container**:
    ```bash
    docker-compose up
    ```
    
    Or run in detached mode:
    ```bash
    docker-compose up -d
    ```

3.  **Access RStudio** at http://localhost:8787
    - Username: `rstudio`
    - Password: `group8`

4.  **Stop the container** when done:
    ```bash
    docker-compose down
    ```

## Option 2: Building Your Own Image Locally

If you want to build the Docker image yourself (useful for making custom modifications):

1.  **Build the image**:
    ```bash
    docker build -t my-dsci-310-analysis .
    ```
    *Note: This may take 10-15 minutes as it installs all R packages.*

2.  **Run the container**:
    ```bash
    docker run -d -p 8787:8787 -e PASSWORD=group8 -v $(pwd):/home/rstudio/project my-dsci-310-analysis
    ```

3.  **Access RStudio** at http://localhost:8787
    - Username: `rstudio`
    - Password: `group8`

4.  **Stop the container**:
    ```bash
    docker ps  # Find the container ID
    docker stop <container-id>
    ```

### Optional: Push Your Own Image to Docker Hub

If you want to share your custom image:

1.  **Create a Docker Hub account** at https://hub.docker.com

2.  **Tag your image**:
    ```bash
    docker tag my-dsci-310-analysis YOUR-DOCKERHUB-USERNAME/dsci-310-analysis:latest
    ```

3.  **Login and push**:
    ```bash
    docker login
    docker push YOUR-DOCKERHUB-USERNAME/dsci-310-analysis:latest
    ```

4.  **Update docker-compose.yml** to use your image:
    ```yaml
    image: YOUR-DOCKERHUB-USERNAME/dsci-310-analysis:latest
    ```

# Running the Analysis Pipeline

Once you have Docker running and have accessed RStudio:

1.  **Navigate to the project directory** in RStudio's terminal:
    ```bash
    cd project
    ```

2.  **Run the complete analysis**:
    ```bash
    make all
    ```
    
    This automated pipeline will:
    - Download the UCI Adult dataset
    - Clean and preprocess the data
    - Split into training/testing sets
    - Perform exploratory data analysis (EDA)
    - Train a logistic regression model
    - Evaluate the model and generate results
    - Render the final HTML report to `docs/index.html`

3.  **View the report**:
    - The report will be available at `docs/index.html`
    - Or view it online at: https://inigogrch.github.io/dsci-workflow-automation/

4.  **Clean up and start fresh** (if needed):
    ```bash
    make clean
    ```
    This removes all generated outputs and allows you to re-run the analysis from scratch.

# Licenses

This project is dual-licensed:

-   **Code** (all scripts, programs, and automation files) is licensed under the **MIT License**. See the `LICENSE` file.
-   **Documentation, reports, and datasets** are licensed under **Creative Commons Attribution 4.0 (CC BY 4.0)**. See `LICENSE-docs`.

# Contributing

Contributions to this project are welcome. Please follow the CONTRIBUTING.md if you'd like to contribute.

# Acknowledgments

This project was completed as part of DSCI 310 at the University of British Columbia.
