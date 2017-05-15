# Architectural Design


## Introduction
This document contains brief overview of the architecture solution for SIEM tool using ELK stack technology. The purpose of this tool is to collect various logs from different sources and store those logs in centralized storage. Also, it should be able to trigger alarms when certain events occur. Events represent certain consequence that is being evaluated with rule-based reasoning strategy.

## System design
In this chapter each part of system will be presented along with solution from techonology that is being used.
### Data collecting
- As stated above, system should be capable of collecting log of various formats and from different operating systems. For this problem, services called __Beats__ will be used for solving it. 
- __Beats__ represent data collectors for various types of data. For this case beats called __Filebeat__ and __WinLogBeat__ will be used to collect logs from __UNIX__ based systems and __Windows__ operating system.
- Their job will be to retrieve data and send that data to specified destination.

### Data retrieving and filtering
- Before logs can be stored in persistent manner, they should be transfomed from raw log lines delimited with given delimiter in actual "objects".
- __Logstash__ will represent part of system that will do this kind of work.
- It job would be to retrieve raw log lines from __Beats__, transform log lines into __JSON__ objects and forward data to persistent storage.

### Data persistence
- Persistence as required part in every system will be acomplished with __Elasticsearch__.
- __Elasticsearch__ represents document-oriented NoSql database that has possibilities of doing various kinds of filtering criterias
- __Elasticsearch__ will receive data from __Logstash__ and persist it.

### Data representation
- For presenting data in certain timeframe __Kibana__ will be used.
- __Kibana__ represents generic client where various kinds of widgets can be created for data and those widgets grouped in dashboards.

### Data security
- Communication between parts of the system will be secured with most secured encryption algorithm that this system supports
- __Xpack__ plugin will be used for rule-based reasoning of data as well as authentication for __Kibana__.

## Conclusion

Elk stack technology has rich features that can be used for solving SIEM related issues, such as investigating certain security breaches by investigating log data.

