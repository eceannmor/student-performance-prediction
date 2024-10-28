# Tutor2_s28021
A simple data science project, centred around a student performance dataset.

You will need the latest release of Java as well as a local or remote [PostgreSQL database](https://www.postgresql.org/). The drivers for proper database communication and the sample data are already included.


## Usage
* Clone this repository
    ```console
    git clone https://github.com/PROJ-D-2024/Tutor2_s28021.git
    ```
* Run a [PostgreSQL database instance](https://www.postgresql.org/) to use as the final storage for the data. 

  > :warning: Currently only **non-containerised**, **localhost** PostgreSQL databases are supported.<br/>
  `TODO`: replace server side `COPY` with client side `\copy`. <br/>Fixing when I get to the main workstation eta`28-29/10/2024`
* Copy `sample_config` as `database.cfg` into `/src`:
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