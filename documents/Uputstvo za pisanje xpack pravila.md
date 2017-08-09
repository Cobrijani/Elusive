# Uputstvo za pisanje pravila u X-pack rule engine-u

Fakultet Tehničkih Nauka, Novi Sad<br/>
Stefan Bratic SW8/2013<br/>
Datum: 20.07.2017<br/>


## Uvod

Modul koji sluzi za rule-engine podršku se naziva X-Pack watcher API. 
Pravila u Rule-engine se unose preko Kibane (Management -> Watchers), što predstavlja client za Elasticsearch, ili putem [WATCHER REST api-ja](https://www.elastic.co/guide/en/x-pack/5.4/watcher-api.html)

## Struktura pravila

Pravila se pišu u JSON fajlu koji se sastoji iz više delova.
Ti delovi su: Ulazni podaci (Inputs), Okidači (Triggers), Uslovi (Conditions), Akcije (Actions), Transformacije (Transformations).

1. **_Ulazni podaci_** predstavljaju izvori iz kojih dobavljamo podatke za dato pravilo, to moze biti http zahtev (Http input), podaci iz elasticsearch-a (Simple input, Search input), ili ulančavanje prethodno pomenutih (Chain input).

- Primer Http input-a
```JSON
"input" : {
  "http" : {
    "request" : {
      "url" : "http://api.openweathermap.org/data/2.5/weather",
      "params" : {
        "lat" : "52.374031",
        "lon" : "4.88969",
        "appid" : "<your openweathermap appid>"
      }
    }
  }
}
```
- Primer Search Input-a
```JSON
"input" : {
  "search" : {
    "request" : {
      "indices" : [ "logs" ],
      "types" : [ "event" ],
      "body" : {
        "query" : { "match_all" : {}}
      }
     }
  }
}

```

- Primer Chain input-a
```JSON
"input" : {
  "chain" : { <- definisan chain input
    "inputs" : [ 
      {
        "first" : { <- naziv prvog input-a je 'first' in on je tipa simple
          "simple" : { "path" : "/_search" }
        }
      },
      {
        "second" : { <- naziv drugog input-a je 'second' in on je tipa http
          "http" : {
            "request" : {
              "host" : "localhost",
              "port" : 9200,
              "path" : "{{ctx.payload.first.path}}" 
            }
          }
        }
      }
    ]
  }
}

```
Detaljnije na [Zvanicnom sajtu](https://www.elastic.co/guide/en/x-pack/5.4/input.html)


2. **_Okidač_** predstavlja uslov kada da Watcher izvrši proveru pravila. Trenutno su podržani planirani okidači (Schedule Trigger) koji se aktiviraju periodično u odnosu na vreme koje je definisano (1 minut, pola sata, sat, dan itd.)

- Primer okidača

```JSON
{
  "trigger" : {
    "schedule" : {
      "interval" : "5m" <- Podešeno da se vrši obrada na svakih 5 minuta
    }
  }
}
```

Detaljnije o okidačima na [Zvaničnom sajtu](https://www.elastic.co/guide/en/x-pack/5.4/trigger.html)

3. **_Uslovi_** predstavljaju okolnosti u kojem pravila treba da se nađe da se aktivira znak za upozorenje. Postoji više vrste uslova koji mogu da se definišu, jedna od najćešće korišćenih je komparacioni uslov (compare condition) koji poredi ulazne podatke sa definisanom vrednošću.

```JSON
{
  "condition" : {
    "compare" : {
      "ctx.payload.hits.total" : { 
        "gte" : 5 <- Uslov treba da aktivira upozorenje ukoliko postoji ukupno podataka više ili jednako od 5
      }
  }
}
```


Detaljnije o uslovima na [Zvaničnom sajtu](https://www.elastic.co/guide/en/x-pack/5.4/condition.html)


4. **_Akcije_** definišu izvršenja koja će se dogoditi ako je uslov ispunjen, to može biti na primer slanje mejla, slanje http zahteva i sl.

- Prikaz akcije koja pravi Github issue kada je uslov ispunjen
```JSON
"actions" : { <- sekcija sa akcijama
  "create_github_issue" : { <- ime naše akcije
    "webhook" : { <- vrsta akcije (http webhook request)
      "method" : "POST",
      "url" : "https://api.github.com/repos/<owner>/<repo>/issues",
      "body" : "{
        \"title\": \"Found errors in 'contact.html'\",
        \"body\": \"Found {{ctx.payload.hits.total}} errors in the last 5 minutes\",
        \"assignee\": \"web-admin\",
        \"labels\": [ \"bug\", \"sev2\" ]
      }",
      "auth" : {
        "basic" : {
          "username" : "<username>", 
          "password" : "<password>"
        }
      }
    }
  }
}
```

Detaljnije o akcijama na [Zvaničnom sajtu](https://www.elastic.co/guide/en/x-pack/5.4/actions.html)


5. **_Transformacije_** služe za promenu strukture podataka koje pravilo koristi. Transformacije imaju dva opsega važenja: na nivou celog pravila ili na nivou akcije. Ukoliko je na nivou celog pravila onda se definiše posle uslova, a ukoliko je na nivou akcija definiše se pre same akcije.


```JSON
{
  "trigger" : { ...}
  "input" : { ... },
  "condition" : { ... },
  "transform" : { <- Transformacija na nivou pravila
    "search" : {
      "body" : { "query" : { "match_all" : {} } }
    }
  },
  "actions" : {
    "my_webhook": {
      "transform" : { <- Transformacija na nivou akcije
        "script" : "return ctx.payload.hits"
      },
      "webhook" : {
        "host" : "host.domain",
        "port" : 8089,
        "path" : "/notify/{{ctx.watch_id}}"
      }
    }
  ]
}
```

Detaljnije o akcijama na [Zvaničnom sajtu](https://www.elastic.co/guide/en/x-pack/5.4/transform.html)

## Primer celog pravila


```JSON
{
  "metadata": { <- Metapodaci su konstante koje se mogu dalje u fajlu koristiti
    "name": "Client bank disk checker",
    "description": "This watcher checks disk usage of a system",
    "url": "http://simulator:3000/systemParts/client-bank/health",
    "threshold": 0.8
  },
  "trigger": { <- Definisan okidač na svaki minut
    "schedule": {
      "interval": "1m"
    }
  },
  "input": { <- Ulazni podataka je http zahtev koji vrši proveru statusa nekog sistema
    "http": {
      "request": {
        "url": "http://localhost:3000/systemParts/client-bank/health"
      }
    }
  },
  "condition": { <- Uslov za aktiviranje upozorenja je da je pun preko 80%
    "compare": {
      "ctx.payload.disk": {
        "gte": "{{ctx.metadata.threshold}}" <- referenciranje vrednosti iz metadata sekcije
      }
    }
  },
  "actions": { <- Spisak akcija
    "logging-action": {
      "logging": { <- Akcije koja loguje u elasticsearch
        "text": "Main bank disk usage is over {{ctx.metadata.threshold}}%, contacting administrator"
      }
    },
    "send_email": {
      "email": {<- Akcija koja salje mail administratoru
        "to": "admin@admin.com",
        "subject": "Client bank client usage warning",
        "body": "Rule engine reports that disk usage for client bank disk usage is over 80%",
        "priority": "high"
      }
    }
  }
}


```
