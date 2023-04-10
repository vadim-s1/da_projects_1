SELECT DISTINCT p.id,
       e.instituition
FROM people AS p
JOIN education AS e ON p.id = e.person_id
WHERE p.company_id IN (SELECT c.id
                       FROM company AS c
                       JOIN funding_round AS fr ON c.id = fr.company_id
                       WHERE status = 'closed'
                       AND is_first_round = 1
                       AND is_last_round = 1);