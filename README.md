# A plugin for CAMP - Configuration amplification
This repo is partially funded by research project STAMP (European Commission - H2020).


## Quick start

Clone the repo as:
```
git clone https://github.com/fermenreq/Camp_plugin_uc.git
```

Then move to:
```
cd plugin/
./executeCamp.sh
```

It's a plugin that use [CAMP](https://github.com/STAMP-project/camp/) tool in order to test and recollect some metrics by stressing a **Dockerized app**. It uses the average response time and the std desviation for few differents values from MPM_Parameters amplified by CAMP tool, ```ThreadsPerChild and ThreadLimit```


## Dependencies
1. Linux SO
2. Apache Jmeter
3. App to test

## Maintainair
Fernando Méndez - fernando.mendez@atos.net
