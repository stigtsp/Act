#!/bin/sh


cat <<'BANNER'
 ____           _                 ____   ___  _     
|  _ \ ___  ___| |_ __ _ _ __ ___/ ___| / _ \| |    
| |_) / _ \/ __| __/ _` | '__/ _ \___ \| | | | |    
|  __/ (_) \__ \ || (_| | | |  __/___) | |_| | |___ 
|_|   \___/|___/\__\__, |_|  \___|____/ \__\_\_____|
                   |___/                            
                                                    
BANNER

set -e
set -x

export LANG="en_US.UTF8"
export LC_ALL="en_US.UTF8"

#
# install PostgrSQL
#

#
# edit settings for access to PostgreSQL
#
#
# create a Act Database user
#

createuser --superuser --createdb --createrole actuser_data
psql -U postgres <<END
\x
ALTER USER actuser_data WITH PASSWORD 'md58b5a506eb50be08b4602152e79749da9';
END

createuser --superuser --createdb --createrole actuser_wiki
psql -U postgres <<END
\x
ALTER USER actuser_wiki WITH PASSWORD 'md5d55c7e1c47b492e33a9adcaaf02d3f61';
END

#
# setup PostgreSQL for Act! as usual
#

createdb act           --encoding=UTF8
createdb acttest       --encoding=UTF8
createdb actwiki       --encoding=UTF8

psql -U postgres act     < /act/docker/dbinit.sql
psql -U postgres acttest < /act/docker/dbinit.sql

#
# setup Sample Databases
# they come up with some odd names
#

#####sudo -u postgres pg_restore -O -C -d template1 /vagrant/actdb
#####sudo -u postgres pg_restore -O -C -d template1 /vagrant/actwikidb
#####
#####psql -h localhost -U postgres <<END
#####\x
#####ALTER DATABASE actdev     RENAME TO act_sample;
#####ALTER DATABASE actdevwiki RENAME TO act_sample_wiki;
#####END

#####psql -h localhost -U postgres <<END
#####\x
#####GRANT ALL PRIVILEGES ON DATABASE act             TO actuser_data;
#####GRANT ALL PRIVILEGES ON DATABASE acttest         TO actuser_data;
#####GRANT ALL PRIVILEGES ON DATABASE actwiki         TO actuser_wiki;
#####GRANT ALL PRIVILEGES ON DATABASE act_sample      TO actuser_data;
#####GRANT ALL PRIVILEGES ON DATABASE act_sample_wiki TO actuser_wiki;
#####END

psql -U postgres <<END
\x
GRANT ALL PRIVILEGES ON DATABASE act             TO actuser_data;
GRANT ALL PRIVILEGES ON DATABASE acttest         TO actuser_data;
GRANT ALL PRIVILEGES ON DATABASE actwiki         TO actuser_wiki;
END

#
# Setup or Upgrade the Wiki databases,  (This utility is installed by Wiki::Toolkit.)
#

#wiki-toolkit-setupdb --type postgres --name actwiki         --user actuser_wiki --pass xyzzy;

