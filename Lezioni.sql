SELECT *
FROM studente
WHERE citta= 'MO' AND a_corso=2;

SELECT *
FROM esame
WHERE voto>=24 AND voto<=28;

SELECT *
FROM esame
WHERE voto BETWEEN 24 AND 28
ORDER BY cc DESC, voto;

SELECT *
FROM esame
WHERE voto IN(29,30,33); /*Ponendo il NOT si procederà verso il procedimento inverso al true*/

SELECT *
FROM studente
WHERE s_nome LIKE 'l___%'; /*la percentuale si usa per scorrere, ogni trattino equivale ad una lettera*/  

SELECT *
FROM studente
WHERE citta IS NOT NULL;

/*SELECT matr, voto +20 si possono usare gli operatori matematici */

/*“Esami del corso C1 ordinati in senso discendente rispetto al voto
espresso in sessantesimi (ovvero 30esimi moltiplicato per 2) e a parità di voto rispetto alla matricola”*/
SELECT matr, cc, data, voto *2 AS votoS
FROM esame
WHERE cc = 'c1'
ORDER BY  votoS DESC, matr; 


/*Per inserire due tabelle è opportuno metterle in relazione attraverso
 una condizione, questo si ripete ogni qualvolta si voglia aggiungere una tabella. 
 Si può usare la keyword JOIN
 Il join viene espresso generalmente riportando nella clausola FROM le rela-
zioni interessate e nella clausola WHERE le condizioni di join.*/
SELECT *
FROM esame, studente, corso
WHERE esame.matr = studente.matr
AND esame.cc = corso.cc;

/*Selezionare, per ogni esame, Nome studente, CodiceCorso e voto*/
SELECT studente.s_nome,esame.cc,esame.voto
FROM esame, studente
WHERE esame.matr=studente.matr;

/*Selezionare, per ogni esame, Nome studente, Nome del Corso e voto*/
SELECT studente.s_nome, corso.c_nome, esame.voto
FROM esame, studente, corso
WHERE esame.matr=studente.matr
AND esame.cc=corso.cc;

/*DISTINCT serve per compattare, togliere le ripetizioni*/

/*Selezionare gli studenti (tutti gli attributi di studente) che hanno soste-
nuto almeno un esame con voto maggiore di 24 di un corso tenuto da un
docente di ‘BO’*/
SELECT DISTINCT studente.*
FROM studente, esame, corso, docente
WHERE esame.matr=studente.matr       /* studente ed esame sono unite nel where attraverso la matricola*/
AND  esame.cc=corso.cc /* collegare ogni tabella*/
AND corso.cd=docente.cd
AND docente.citta = 'BO'
AND esame.voto > 24;

/*Nome degli studenti che hanno sostenuto l’esame del corso C1*/
SELECT s_nome
FROM studente, esame /*Leggere bene la consegna, STUDENTI (si prende il nome) che hanno sostenuto l'ESAME e di quest'ultimo si prende il codice del corso (cc)*/
WHERE studente.matr=esame.matr
AND esame.cc= 'C1';

/*Nuovo operatore IN*/
SELECT *
FROM studente
WHERE studente.matr IN ('M1', 'M2') /*Si può selezionare singolarmente sapendo l'ordine della tabella)*/;

-- Visualizza le matricole che hanno sostenuto l'esame C1 --
SELECT esame.matr
FROM esame
WHERE esame.cc= 'C1';

-- con l'operatore IN --
SELECT *
FROM studente
WHERE studente.matr IN (SELECT esame.matr 
                        FROM esame 
						WHERE esame.cc='C1');
                        
-- L'operatore IN ammette anche la negazione NOT --

-- Nome degli studenti che hanno sostenuto l'esame di un corso del docente D1 --
-- Modo normale --
SELECT DISTINCT studente.s_nome
FROM studente, esame, corso
WHERE studente.matr=esame.matr
AND esame.cc=corso.cc
AND corso.cd='D1';
 
-- Con operatore IN --

SELECT studente.s_nome
FROM studente
WHERE studente.matr IN ( SELECT esame.matr
                         FROM esame
                         WHERE esame.cc IN (SELECT corso.cc
                                            FROM corso
                                            WHERE corso.cd = 'D1')); -- Se volessimo mettere il NOT, bisognerebbe inserirlo solamente nella condizione più esterna --
                                            
										/* Doppia negazione, doppio NOT, serve a rispettare la consegna di prendere un 
                                         dato da un insieme tenere solo quelli in 
                                         cui vale una condizione che non sono però accompagnate anche ad altre */

-- Nome degli studenti che non hanno sostenuto l’esame di Fisica 1--
SELECT studente.s_nome
FROM studente
WHERE studente.matr NOT IN (SELECT esame.matr
                            FROM esame
                            WHERE esame.cc IN (SELECT corso.cc
										       FROM corso
                                               WHERE corso.c_nome LIKE 'Fisica 1'))
                                               
                                               -- per selezionare tutti gli esami di Fisica e non solo Fisica 1 si usa 'Fisica%' con l'operatore di scorrimento--
AND studente.matr IN (SELECT esame.matr FROM esame); -- questo serve per inserire gli studenti che non hanno tenuto l'esame di Fisica ma che hanno tenuto almento un esame --
                                               
-- Selezionare studenti che non hanno mai fatto esami  -- 
SELECT studente.s_nome
FROM studente
WHERE studente.matr NOT IN (SELECT esame.matr FROM esame);

SELECT COUNT(*)
FROM studente
WHERE studente.citta = 'MO';

SELECT COUNT(*), count(studente.matr), count(studente.citta)
FROM studente;

SELECT COUNT(*), count(studente.matr), count(studente.citta), count(studente.matr)- count(studente.citta)
FROM studente;

SELECT COUNT(*), COUNT(DISTINCT studente.a_corso), count(studente.matr), count(studente.citta), count(studente.matr)- count(studente.citta)
FROM studente;

SELECT COUNT(*), COUNT(DISTINCT studente.a_corso), count(studente.matr), count(DISTINCT studente.citta), count(studente.matr)- count(studente.citta)
FROM studente;

SELECT COUNT(*)
FROM studente
WHERE citta IS NULL;             

SELECT COUNT(*), min(esame.voto), MAX(esame.voto), AVG(esame.voto), sum(esame.voto)/COUNT(*)   
FROM esame
WHERE esame.matr = 'M1';

SELECT studente.s_nome, COUNT(*), min(esame.voto), MAX(esame.voto), AVG(esame.voto), sum(esame.voto)/COUNT(*)   
FROM esame,studente
WHERE esame.matr = studente.matr
and studente.s_nome = 'Lucia Quaranta';

SELECT COUNT(*), min(esame.voto), MAX(esame.voto), AVG(esame.voto), sum(esame.voto)/COUNT(*)   
FROM esame,studente
WHERE esame.matr = studente.matr
and studente.s_nome like 'Lucia%';

SELECT COUNT(*), min(esame.voto), MAX(esame.voto), AVG(esame.voto), sum(esame.voto)/COUNT(*)   
FROM esame,corso,docente
WHERE esame.cc = corso.cc
and corso.cd=docente.cd
and docente.d_nome = 'Paolo Rossi';

SELECT *
FROM docente, corso, esame
WHERE docente.cd = corso.cd
AND corso.cc = esame.cc
AND docente.d_nome LIKE 'Paolo%';

-- Selezione del numero di studenti che hanno sostenuto almeno un'esame -- 

-- modo con count--
SELECT COUNT(DISTINCT esame.matr), COUNT(*)/COUNT(DISTINCT esame.matr)
FROM esame;
-- attraverso due tabelle --
SELECT COUNT(DISTINCT studente.s_nome)
FROM esame, studente
WHERE esame.matr = studente.matr;

-- stessa struttura cambio chiave, da matricola a codice corso -- 
SELECT COUNT(DISTINCT esame.cc), COUNT(*)/COUNT(DISTINCT esame.cc)
FROM esame;
-- --
SELECT COUNT(DISTINCT esame.cc, esame.matr), COUNT(*)/COUNT(DISTINCT esame.cc) as 'mia'
FROM esame;

-- Quali sono gli studenti con l'anno di corso minore del massimo presente --
SELECT COUNT(*)
FROM studente
WHERE studente.a_corso < (SELECT MAX(a_corso)
                          FROM studente); 
                          
-- Studenti non frequentanti il min corso  =ANYvuol dire appartiene, mentre NOT IN è diverso da ALL--
SELECT COUNT(*)
FROM studente
WHERE studente.a_corso > (SELECT MIN(a_corso)
                          FROM studente); 
                          
-- Massimo voto di ogni matricola, per ogni esame cerco il voto massimo raggruppando le matricole e prendendo da esse il MAX voto--
SELECT esame.matr, MAX(esame.voto)
FROM esame
GROUP BY esame.matr;

-- Minimo, massimo e media dei voti di ogni studente --
SELECT esame.matr, studente.s_nome,MAX(esame.voto),MIN(esame.voto),AVG(esame.voto), COUNT(*)
FROM esame, studente
WHERE esame.matr =studente.matr
GROUP BY esame.matr, studente.s_nome;

-- Per ogni nome di corso, quanti esami sono stati verbalizzati, qual è il minimo, il massimo e la media --
SELECT COUNT(esame.cc), corso.c_nome, MIN(esame.voto), MAX(esame.voto), AVG(esame.voto)
FROM corso, esame
WHERE corso.cc=esame.cc
GROUP BY corso.cc, esame.cc;

-- Per ogni docente vogliamo sapere quanti esami ha fatto, voto eccetera. Per far comparire un solo record bisogna raggruppare solamente per il soggetto in questione. --
SELECT docente.cd, docente.d_nome, MIN(esame.voto), MAX(esame.voto), AVG(esame.voto), COUNT(esame.cc)
FROM corso, esame, docente
WHERE corso.cc=esame.cc
AND corso.cd = docente.cd
GROUP BY docente.cd ,docente.d_nome; -- Per essere più precisi si raggruppa sia per nome che per codice unico --  

-- Nome docente, nome corso, numero di esami e votazioni --
SELECT docente.cd, docente.d_nome, corso.cc, corso.c_nome, MIN(esame.voto), MAX(esame.voto), AVG(esame.voto), COUNT(esame.cc)
FROM corso, esame, docente
WHERE corso.cc=esame.cc
AND corso.cd = docente.cd
GROUP BY docente.cd ,docente.d_nome, corso.cc,corso.c_nome;

-- Nome docente e corso tenuto--
SELECT docente.cd, docente.d_nome, corso.cc, corso.c_nome
FROM corso, docente
WHERE corso.cd=docente.cd
GROUP BY docente.cd ,docente.d_nome, corso.cc,corso.c_nome;

-- Voto Massimo e minimo ottenuto per ogni studente escludendo il corso "C1" --
SELECT esame.matr, studente.s_nome, MAX(esame.voto), MIN(esame.voto)
FROM esame, studente
WHERE esame.matr = studente.matr
AND esame.cc != 'C1%'
GROUP BY esame.matr, studente.s_nome;

-- Stesso esercizio ma togliendo Fisica 1 -- 
SELECT esame.matr, studente.s_nome, MAX(esame.voto), MIN(esame.voto)
FROM esame, studente
WHERE esame.matr = studente.matr
AND esame.cc NOT IN (SELECT corso.cc
                     FROM corso
                     WHERE corso.c_nome LIKE 'Fisica%')  
GROUP BY esame.matr, studente.s_nome;

-- Esercizio con HAVING --
SELECT esame.matr, studente.s_nome, MAX(esame.voto), MIN(esame.voto), AVG(esame.voto), COUNT(esame.voto)
FROM esame, studente, corso
WHERE esame.matr = studente.matr
AND esame.cc = corso.cc  
GROUP BY esame.matr, studente.s_nome
HAVING COUNT(esame.voto) >1;

-- Tutti quelli che hanno la media più alta di quella di Lucia Quaranta --

SELECT studente.s_nome, AVG(esame.voto)
FROM studente, esame
WHERE esame.matr = studente.matr
GROUP BY studente.s_nome
HAVING AVG(esame.voto) > (SELECT AVG(esame.voto)
                          FROM esame, studente
                          WHERE esame.matr = studente.matr
						  AND studente.s_nome = 'Lucia Quaranta');
						  
						  
-- Studenti che hanno la media più alta in assoluto --				  
SELECT studente.s_nome, AVG(esame.voto)
FROM studente, esame
WHERE esame.matr = studente.matr
GROUP BY studente.s_nome
HAVING AVG(esame.voto) >= ALL(SELECT AVG(esame.voto) -- Si mette >= perchè così vengono conteggiati tutti --
                          FROM esame
                          GROUP BY esame.matr);
			  
-- Per ogni corso di cui abbiamo l'esame mostra la media dei voti sostenuto da più di due studenti  -- 
SELECT COUNT(esame.voto), esame.cc, corso.c_nome, MIN(esame.voto), MAX(esame.voto), AVG(esame.voto) 
FROM corso, esame
WHERE corso.cc=esame.cc
GROUP BY corso.c_nome, esame.cc
HAVING COUNT(esame.voto)>3;    

-- Trovare il docente che ha dato il voto più basso --
SELECT  docente.cd, docente.d_nome, MAX(esame.voto),MIN(esame.voto), AVG(esame.voto), COUNT(esame.voto)
FROM esame, corso, docente
WHERE esame.cc = corso.cc
AND corso.cd = docente.cd
GROUP BY docente.cd, docente.d_nome
HAVING MIN(esame.voto) <= (SELECT MIN(esame.voto)
                           FROM esame);
                           

