--Kteří uživatelé nemají žádného přítele? Očekává se tabulka výsledku se schématem
--(přihlašovací jméno, jméno a příjmení, e-mail).



SELECT "loginName", "nameSurname","email"
FROM "USER"  t1
LEFT JOIN ASSOCIATED_ACCOUNTS t2 ON t2."accountNumber1" = t1."accountNumber"  OR  "accountNumber2" = t1."accountNumber"
WHERE t2."accountNumber1" IS NULL  or t2."accountNumber2"  IS NULL