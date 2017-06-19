# Elusive

## Apstrakt
Smisao ovog dokumenta je da opiše sistem, delove sistema i način na koji ti delovi sistema funkcionišu.

## Uvod

Elusive je projekat čiji je cilj prikupljanje informacija, u najčešćem slučaju logovi sistemima, o heterogenim sistemima iz heterogenih okruženja. Sa tako raspoloživim informacijama Elusive, koji koristi *__Elk__* stek tehnologiju, daje mogućnosti da se iz tih podataka izvuku informacije koje mogu pomoći da se identifikuju i spreče bezbednosni propusti u sistemima.

Kao što je napomenuto gore, Elusive koristi Elk steka tehnologiju koja uključuje: _Elasticsearch_, _Logstash_, _Kibana_, _Beats_ i _X-pack_.

Pored Elk steka, koristi se _Docker_ , koji omogućuje verzioniziranje sistema, tako da u svakom trenutku sistem može biti obrisan, ponovo pokrenut i vraćen u stanje u koje bi trebao da bude.

Za generisanje sertifikata i java key store-ova koristila se _Open Ssl_ biblioteka.

## Prikupljanje podataka

Ulazne tačke sistema predstavljaju _Beatovi_, oni su _data collectori_ čiji cilj je da prikupe podatke sa nekog izvora, bilo to da je fajl, mreža, baza podataka, ili neki drugi sistem, i te podatke prosledeđuju u sistem koji mi želimo. U našem slučaju to predstavlja __Logstash__. Uloga __Logstash-a__ u našem sistemu je da bude centralna tačka gde će svi Beatovi ili neki drugi sakupljači podataka slati podatke, pre nego što te podatke perzistujemo u trajno skladište.

## Perzistencija podataka
Glavna perzistencija sistema je _Elasticsearch_. TO je NoSql baza podataka koji u sebi ima jako dobru podršku za Upitima i filterovanjem.
Pošto podaci se sakupljaju iz različitih izvora, svaki izvor podataka ima sopstveni indeks u _Elasticsearch-u_ koji vodi računa o jednoj vrsti podatka.

## Transformacija podataka

Transformacija podataka je takođe važan proces u celokupnom sistemu, zato što se bavimo podacima koji dolaze sa različitih izvora podataka. Samim tim, njihov format može veoma da se razlikuje i za rešenje ovog problema koristi se _Logstash_ koji ima podršku za parsiranje i transformaciju podataka u format koji je pogodniji za dalju obradu i manipulaciju.

## Prikaz i vizuelizacija podataka  

Podaci nisu vredni ako nisu čitljivi za svakog čoveka. U tu svrhu se pronalazi primena _Kibane_, koja predstavlja klijentsku aplikaciju dizajniranu za potrebe čitanja podataka iz _Elasticsearch-a_. _Kibana_ ima podršku za kreiranje raznih widget-a nad podacima koje čuvamo u Elasticsearch-u takođe grupisanje tih Widget-a u grupacije zvane _Dashboard-i_.

## Korišćenje pravila i rule engine-a

## Autentifikacija
## Zaštita podataka
## Enkripcija komunikacije
## Generisanje sertifikata
## Zaključak



