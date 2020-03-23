-- 3.) Kolik přátel a kolika různých ročníků (roků narození) mají
-- jednotliví uživatelé se jménem Jan Novák? Očekává se tabulka
-- výsledku se schématem (přihlašovací jméno Jana Nováka, e-mail
-- Jana Nováka, počet přátel, počet ročníků).
-- Musí být vidět i ty Jany Nováky, kteří nemají žádné přátele.

SELECT "USER"."nameSurname",  "USER"."loginName", matches.count numOfFriends
FROM "USER",
    (SELECT NovakAccounts.account3, COUNT(NovakAccounts.account3) count
    FROM (
        SELECT aa1."accountNumber1" account1, aa1."accountNumber2" account2
        FROM ASSOCIATED_ACCOUNTS aa1
        WHERE NOT EXISTS
            (SELECT *
            FROM ASSOCIATED_ACCOUNTS aa2
            WHERE (aa1."accountNumber1" = aa2."accountNumber2" AND aa1."accountNumber2" = aa2."accountNumber1"))
        ) friendsData,
         (SELECT "USER"."accountNumber" account3
         FROM "USER"
         WHERE "USER"."nameSurname" = 'Jan Novak') NovakAccounts
    WHERE NovakAccounts.account3 = friendsData.account2 OR  NovakAccounts.account3 = friendsData.account1
    GROUP BY NovakAccounts.account3) matches
WHERE "USER"."accountNumber" = matches.account3
UNION
SELECT "nameSurname", "loginName", 0
FROM "USER"  t1
LEFT JOIN ASSOCIATED_ACCOUNTS t2 ON  (t2."accountNumber1" = t1."accountNumber"  OR  "accountNumber2" = t1."accountNumber")
WHERE t1."nameSurname" = 'Jan Novak' AND (t2."accountNumber1" IS NULL  or t2."accountNumber2"  IS NULL);
