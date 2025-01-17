# Student performance predition
A simple data science project, centred around a student performance dataset.<br/>
The goal is to analyse current conditions of students, and use the dataset together with different ML models to predict which students might benefit from additional help or a change of environment.<br/>
Current version of the project includes final exam score prediction based on students' factors.<br/>
This is a *practice project* in preparation to a diploma thesis, on the same topic, which will include a larger database and more complex analysis.

This project currently includes:
* Data import and standardisation scripts
* Data analysis using:
    * Random Sample Consensus
    * K-Nearest-Neighbours
    * Support Vector Machine

You will need the latest release of [Java](https://www.java.com/download), [python](https://www.python.org/downloads/), as well as a local ~~or remote~~ [PostgreSQL database](https://www.postgresql.org/). The drivers for proper database communication and the sample data are already included.

## Prediction performance
![performance analysis chart](analysis%20chart.png)
**Data size:** 32 intependent features, 3 dependent features (only 1 used for prediction), 6608 observations (split 80-20)

Random sample consensus was chosen for its ability to handle outliers better than other methods.<br/>
Best achived metrics:
* **Mean Squared Error**: 2.8230
* **R<sup>2</sup>**: 0.8007
* **Maximum Error**: 30.1322

The result can be replicated by manually setting the random seed to **598**.

## Usage
* Clone this repository
    ```console
    git clone https://github.com/PROJ-D-2024/Tutor4_s28021.git
    cd Tutor4_s28021
    ```
* **( :heavy_exclamation_mark: This step is optional in the current release)** <br/>Run a [PostgreSQL database instance](https://www.postgresql.org/) to use as the final storage for the data. 

  > :warning: Currently only **non-containerised**, **localhost** PostgreSQL databases are supported.<br/>
  `TODO`: replace server side `COPY` with client side `\copy`.
* **( :heavy_exclamation_mark: This step is optional in the current release)** <br/>Copy `sample_config` as `database.cfg` into `/src`:
    * Windows: `copy sample_config.cfg ./PRO1D/scr/database.cfg -a`
    * Linux: `cp sample_config.cfg ./PRO1D/src/database.cfg`

    and fill out the database connection info and credentials in this format:
    ```properties
    dbname=<database name>
    hostname=<hostname>
    port=<port>
    username=<username>
    password=<password>
    ```
* Execute the `run.sh` script:
    * Windows: `./run.sh`
    * Linux: `sudo bash run.sh`

## License
Free to use for personal / educational cases. <br/> 
Do not reupload or submit as you own. Your professor will know.<br/>
Unsure? Ask » ekreceannmor@gmail.com
