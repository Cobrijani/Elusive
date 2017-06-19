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

1. ```run docker-compose -f deployments/docker-compose.yml up -d``` to start elastic stack 

2. ``` python log_generator/main.py ``` to start generation of logs

3. After system is up, go to: https://localhost:5601 which represents kibana client for elastics stack

4. Navigate to Management -> Index Patterns

5. In the text field in the middle of the current screen write __firebeat-\*__, then click out of text field to refresh loading and lastly in options box below text field select '@timestamp' as time field and click 'Create'.

6. Repeat 5. for __appbeat-\*__, __apachebeat-\*__, __linuxbeat-\*__, __winlogbeat-*__

7. In _Discover_ menu you can watch in real time logs that are coming to elasticsearch from different sources separated by indexes you defined above.

8. Folders located in resources folder(_resources/apachebeat_, _resources/appbeat_ and _resources/firebeat_)  contain visualization and dashboards exports for kibana. In order to import them, you need navigate in kibana to path _Management -> Saved Objects_ and press _Import_. When file dialog is opened select json file that represents Visualization or Dashboard export.

### Useful resources
 
- [Xpack (official site)](https://www.elastic.co/guide/en/x-pack/current/index.html)

- [Elasticsearch (official site)](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
 
- [Logz.io Complete Guide to Elk Stack](https://logz.io/learn/complete-guide-elk-stack/)

- [Docker tips and cheatsheet](https://blog.jez.io/2015/07/12/docker-tips-and-cheatsheet/)

- [Github repo for Docker cheatsheets](https://github.com/wsargent/docker-cheat-sheet)


