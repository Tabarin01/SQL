/*Selezionare i ciclisti che si sono 
classificati in prima posizione in una gara ciclistica partita da Milano*/

SELECT partecipa.nomeciclista, gara.partenza, partecipa.posizione
FROM partecipa, gara
WHERE partecipa.nomecorsa = gara.nomecorsa
AND partecipa.posizione LIKE 'Primo%'
AND gara.partenza LIKE 'Milano%';

/*Selezionare il nome dei ciclisti che non si sono mai ritirati al Giro (corsa con nome Giro)*/
SELECT DISTINCT partecipa.nomeciclista, partecipa.nomecorsa
FROM partecipa
WHERE partecipa.nomecorsa IN(SELECT gara.nomecorsa
						     FROM gara
							 WHERE gara.nomecorsa LIKE 'Giro%')
AND partecipa.posizione NOT LIKE 'R%';

/*Selezionare le corse per le quali in ogni edizione c'e' stato almeno un ritirato*/
SELECT DISTINCT partecipa.nomecorsa, partecipa.anno
FROM partecipa
WHERE partecipa.nomecorsa NOT IN (SELECT partecipa.nomecorsa 
                                  FROM partecipa
                                  WHERE partecipa.posizione LIKE 'R%'
                                  GROUP BY partecipa.nomecorsa, partecipa.anno
                                  HAVING COUNT(*) = SUM(partecipa.posizione NOT LIKE 'R'));

/*Selezionare, per ogni corsa ciclistica, l'anno in cui c'e' stato il maggior numero di ciclisti ritirati*/
SELECT partecipa.nomecorsa, partecipa.anno, COUNT(partecipa.posizione) AS NumeroRitirati
FROM partecipa
WHERE partecipa.posizione LIKE 'R%'
GROUP BY partecipa.anno, partecipa.nomecorsa
HAVING COUNT(partecipa.posizione) = (SELECT MAX(ritirati.NumeroRitirati) 
                                     FROM (SELECT COUNT(partecipa.posizione) AS NumeroRitirati 
                                           FROM partecipa 
                                           WHERE partecipa.posizione LIKE 'R%'
                                           GROUP BY partecipa.anno, partecipa.nomecorsa) ritirati);;
