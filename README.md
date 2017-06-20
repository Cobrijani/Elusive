# Elusive - SIEM SIIT 2016

## Faculty of Technical Science
##  Subject: Security in E-Business Systems

Academic Staff:
- Sladic Goran (Professor)
- Luburic Nikola (Teaching Assistant) 

Students:
- Bratic Stefan
- Vojnovic Milorad
- Vladisavljev Arsenije

### Description

Student project that consists of creating SIEM center using ELK stack.

### Requirements

- Python 2.x.x or 3.x.x
- Docker Machine
- Docker Compose
- Docker
- Bash
- Powershell v3 (if on Windows)

### Instructions

1. Run ``` docker-compose -f deployments/docker-compose-local.yml up --build -d``` to start elastic stack. Make sure Docker is up and running in your environment. If you can to run images from docker registry run instead ``` docker-compose -f deployments/docker-compose.yml up --build -d ``` It will download already built docker images for this project and create containers for them.

2. ``` cd log_generator && python main.py ``` to start generation of logs

3. After system is up, go to: https://localhost:5601 which represents kibana client for elastics stack and log in with username _elastic_ and password _changeme_

4. Navigate to Management -> Index Patterns

5. In the text field in the middle of the current screen write __firebeat-\*__, then click out of text field to refresh loading and lastly in the options box below text field, select '@timestamp' as time field and click 'Create'.

6. Repeat 5. for __appbeat-\*__, __apachebeat-\*__, __linuxbeat-\*__, __winlogbeat-*__

7. In _Discover_ menu you can watch in real time logs that are coming to elasticsearch from different sources separated by indexes you defined above.

8. Folders located in resources folder(_resources/apachebeat_, _resources/appbeat_ and _resources/firebeat_)  contain visualization and dashboards exports for kibana. In order to import them, you need navigate in kibana to path _Management -> Saved Objects_ and press _Import_. When file dialog is opened select json file that represents Visualization or Dashboard export.

9. For elastic stack rules you need to run ```./scripts/load-rules.sh ```. It will run a script that will add all existing rules for this project. Make sure elastic stack is up and running.


### Project structure

 - _cryptography_ folder contains scripts and resources needed for creating and managing certificates.
 - _deployment_ folder contains docker-compose and dockerfile configuration of the whole system
 - _documents_ folder pdf, markdown files that contain information related to project and also rule design and rules payload.
 - *log_generator* folder contains python implementation of simulator for generating custom logs.
 - _resources_ folder contain assets related to project
 - _scripts_ folder contain files that are used to configure system properly.
 - *test_logs* is default location where log will be generated

### Useful resources
 
- [Xpack (official site)](https://www.elastic.co/guide/en/x-pack/current/index.html)

- [Elasticsearch (official site)](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
 
- [Logz.io Complete Guide to Elk Stack](https://logz.io/learn/complete-guide-elk-stack/)

- [Docker tips and cheatsheet](https://blog.jez.io/2015/07/12/docker-tips-and-cheatsheet/)

- [Github repo for Docker cheatsheets](https://github.com/wsargent/docker-cheat-sheet)


