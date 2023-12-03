installed_packages <- rownames(installed.packages())

required_packages <- c("readr", "BiocManager") # Add your package names here
for (pkg in required_packages) {
  if (!pkg %in% installed_packages) {
    install.packages(pkg, repos = "http://cran.rstudio.com/")
  }
}

required_biocmanager_packages <-  c("TCGAbiolinks") # Add your package names here
for (pkg in required_packages) {
  if (!pkg %in% installed_packages) {
    BiocManager::install(pkg)
  }
}

# To create a requirements file with the currently installed packages:
writeLines(paste("install.packages(", dQuote(installed_packages), ", repos = 'http://cran.rstudio.com/')"), "requirements.R")