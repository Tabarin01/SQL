/*Selezionare le sale nelle quali e' stato esposto, nell'anno 1997, un quadro di Picasso*/ 
SELECT DISTINCT espone.sala
FROM espone, mostra, quadro
WHERE espone.cm IN(SELECT mostra.cm
                   FROM mostra
                   WHERE mostra.anno LIKE 1997)
AND espone.cq IN (SELECT quadro.cq
                  FROM quadro
                  WHERE quadro.autore LIKE 'Picasso%');
                  
/*Selezionare tutti i dati dei quadri di Picasso che non sono mai stati esposti nell'anno 1997*/
SELECT DISTINCT quadro.*     -- Versione 1 --
FROM quadro, mostra, espone
WHERE quadro.cq NOT IN (SELECT espone.cq
				   FROM espone
                   WHERE espone.cm IN (SELECT mostra.cm
                                           FROM mostra
                                           WHERE mostra.anno LIKE 1997))
AND quadro.autore LIKE 'Picasso%';

SELECT * -- Soluzione nel file --
FROM quadro
WHERE quadro.autore = 'Picasso%'
AND quadro.cq NOT IN (SELECT espone.cq
FROM mostra, espone
WHERE mostra.cm = espone.cm
AND mostra.anno = 1997);
 
 
SELECT DISTINCT quadro.*   -- Versione 2, migliore --
FROM quadro
WHERE quadro.autore LIKE 'Picasso%'
AND quadro.cq NOT IN (SELECT espone.cq
                      FROM espone
                      WHERE espone.cm IN (SELECT mostra.cm
                                          FROM mostra
					                      WHERE mostra.anno = 1997));
                                          
/*Selezionare tutti i dati dei quadri che non sono mai stati esposti insieme ad un quadro di Picasso, ovvero nella stessa mostra in cui compariva anche un quadro di Picasso*/
SELECT DISTINCT quadro.*
FROM quadro, mostra, espone
WHERE quadro.cq NOT IN ( SELECT espone.cq
                         FROM espone
                         WHERE espone.cm IN(SELECT mostra.cm
                                            FROM mostra
                                            WHERE mostra.cm IN(SELECT espone.cm
															   FROM espone, quadro
															   WHERE espone.cq = quadro.cq
                                                               AND quadro.autore LIKE 'Picasso%')));
                    
/*Selezionare per ogni mostra l'autore di cui si esponevano il maggion numero di quadri*/
SELECT quadro.autore, COUNT(espone.cq)
FROM quadro, espone
WHERE quadro.cq = espone.cq
GROUP BY quadro.autore
HAVING COUNT(espone.cq) >= ALL(SELECT COUNT(espone.cq) 
							   FROM espone
							   GROUP BY espone.cq);
