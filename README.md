# Tutor2_s28021
A simple data science project, centred around a student performance dataset.

You will need the latest release of Java as well as a local or remote [PostgreSQL database](https://www.postgresql.org/). The drivers for proper database communication and the sample data are already included.


## Usage
* Clone this repository
    ```console
    git clone https://github.com/PROJ-D-2024/Tutor2_s28021.git
    ```
* Run a [PostgreSQL database instance](https://www.postgresql.org/) to use as the final storage for the data.
* Copy `sample_config` as `database.cfg` into `/src`:
    * Windows: `copy sample_config.cfg ./PRO1D/scr/database.cfg -a`
    * Linux: `cp sample_config.cfg ./PRO1D/src/database.cfg`

    and fill out the database connection info and credentials in this format:
    ```properties
    database=<database name>
    host=<hostname>
    port=<port>
    username=<username>
    password=<password>
    ```
* Execute the `run.sh` script:
    * Windows: `./run.sh`
    * Linux: `sudo bash run.sh`