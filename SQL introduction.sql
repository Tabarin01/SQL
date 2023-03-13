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

