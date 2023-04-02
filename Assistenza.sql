
-- Selezionaren i clienti che hanno segnalato il codice errore 'E1' -- 
SELECT cliente.codc, cliente.nome_cliente, errore.errore
FROM cliente, errore
WHERE cliente.codc = errore.codc
AND errore.errore LIKE 'E1';

-- Selezionare le città nelle quali non è mai stato segnalato un codice errore ‘E1’ --

SELECT cliente.citta
FROM cliente
WHERE cliente.codc NOT IN (SELECT errore.codc
                           FROM errore
                           WHERE errore.errore LIKE 'E1');

-- Selezionare, per ciacun codice errore, il numero di interventi -- 
SELECT errore.errore, COUNT(*)
FROM errore
GROUP BY errore.errore;

-- Selezionare, per ogni città, i costi totali delle riparazioni --
SELECT cliente.citta, SUM(errore.costo)
FROM cliente, errore
WHERE cliente.codc = errore.codc
GROUP BY cliente.citta;

-- Selezionare i dati del cliente che ha avuto il costo totale maggiore dovuto ad errori --
SELECT cliente.nome_cliente, SUM(errore.costo)
FROM cliente, errore
WHERE cliente.codc = errore.codc
GROUP BY cliente.nome_cliente
HAVING SUM(errore.costo) >= ALL(SELECT SUM(errore.costo) 
                                FROM errore
                                GROUP BY errore.codc);
