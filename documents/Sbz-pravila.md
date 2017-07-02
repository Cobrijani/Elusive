# Sistemi bazirani na znanju

Fakultet Tehnickih Nauka
Softversko Inzenjerstvo i Informacione Tehnologije
Stefan Bratic (sw8/2013)

## Tema projekta

Tema projekta je informacioni sistem banke. Banke su sistemi koji su poznati da imaju jako veliki rizik zato sto njihove poslovanja se bavi transakcijama, izdavanjem kredita i sve sto je u vezi sa novcem. Samim tim, bezbednost takvih sistema mora biti adekvatna. 

## Delovi informacionog sistema

Informacioni sistem banke se sastoji od sledecih komponenti:
- Banka ima glavni server koji sluzi za komunikaciju sa bazama podataka gde su smesteni racuni svih klijenata. Aplikacija trci na apache web serveru. Svaka komunikacija sa bazom se loguje na aplikacionom serveru i potom salje u Elastic stack.
- Web aplikacija koja sluzi korisnicima da se autentifikuju, gledaju stanje svog racuna i vrse tranksakcije preko njega.
- Automati za podizanje novca koji komuniciraju sa glavnim serverom kad vrsi podizanje novca

Napomena:
 - ovi delovi sistemi bice simularni
 - u to spada simuliranje logova, simuliranje dostupnosti sistema itd.
 - ovo nije definitivna lista pravila, moguce promena u odnosu na kolicina posla koja treba biti spram projekta.


## Rule engine

- Za rule engine koristice se funkcionalnost x-packa u Elastic steku za kreiranje pravila.
- Pravila se kreiraju na osnovu informacija koji se prikupljaju iz razlicitih delova sistema i perzistuju u elastic search.
- Pravila ce obuhvatati detekciju bezbednosnih propusta.
- Pervencija bezbednosnih propusta ce biti simularana kroz akcije kao sto su slanje e-maila, logovanje i sl.


## Spisak pravila

- Spisak pravila vezanih za web server na kome se nalazi aplikacija kojoj pristupaju krajnji korisnici:
  1. Vrsi se provera sa koliko razlicitih IP adresa se pristupa sa jednim korisnickim nalogom. Ukoliko je taj pristup veci od 2 u periodu od 10 minuta, prevencija je da se racun blokira daljim transakcijama.
  2. Vrsi se provera koliko se puta desio Response Code 401 (Unauthorized), 403 (Forbidden) ili 500 (Internal Server Error) za svakog korisnika. Ukoliko u roku od sat vremena dodje do 401 ili 403 3 puta nalog korisnika je blokiran dok se ne javi u neku od filijala. Ukoliko dodje do 500 (Internal Server Error) salje se mail development timu da se desava greska koja ne bi smela da postoji.
  3. Ukoliko se desava previse zahteva sa neke IP adrese vise od 50 puta u minuti, prekida se konekcija kako bi se specio DOS.

- Spisak pravila vezanih za firewall koji stoji izmedju glavnom servera i ostalih ucenika koji komuniciraju sa njim
  1. Vrsi se provera sa kojih IP adresa dolazi request. Tacno se zna koje adrese smeju da salje zahtev i ukoliko se primeti da zahtevi sa nekih ip adresa previse dolaze (tipa 20 DENY ili DROP zahteva) vrsi detekcija uljeza i prevencija da napada firewall.
  2. Vrsi se provera na koje portove se salju zahtevi i ako dolaze zahtevi na neki od nedozvoljenih portova takodje se vrsi prevencija daljeg slanja zahteva sa tih IP adresa.
  3. Vrsi se provera gustine prometa u periodu od 10 minuta. Ukoliko gustina saobracaja predje odredjeni threshhold, vrsimo detekciju i psuedo rate liming na zahteve

- Spisak pravila vezanih za web server na kome se nalazi aplikacija koja ima pristup bazama podataka:
  1. Vrsi se provera da li je neki zahtev dosao sa nedozvoljene ip adrese, i ukoliko jeste vrsi se sprecavanje slanje buducih zahteva sa te ip adrese
  2. Vrsi se provera kodova 401, 403 i 500 i ukoliko se desi 401, 403 sprecava se komunikaija sa tim sistemima dok se ne ustanovi sta je uzrok tome, a dok za 500 se vrsi slanje mail administratoru sistema da se ustanovi i ukloni kvar

- Spisak pravila za automate (logovi se prate za vise automata kako bi se mogle zakljuciti neke stvari):
  1. Ukoliko se ustanovi da korinik sa istom karticom podize novac sa vise automata u jakom kratkom vremenskom periodu vrsi se blokiranje kartice, dok se korisnik ne javi na filijalu.
  2. Ukoliko se ustanovi da korisni pokusava vise od 5 puta da podigne novac preko limita sa automata, vrsi se akcija blokiranja kartice.

- Spisak pravila za metrike:
  1. Vrsi se provera metrika za sistem (simuliranjem), tj. pravila ce da proveravaju da li su odredjeni sistema dostupni i ukoliko nisu salje se mail administratoru o trenutnom stanju sistema.
  2. Vrsi se provera disk usage-a i ukoliko se ustanovi da u roku od manje dva dana nece biti dovoljno memorije salje se mail administratoru o obavestenju


