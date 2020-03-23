-- 2.) Kolik přátel a kolika různých ročníků (roků narození) mají jednotliví
-- uživatelé se jménem Jan Novák? Očekává se tabulka výsledku se schématem
-- (přihlašovací jméno Jana Nováka, e-mail Jana Nováka, počet přátel, počet ročníků).

SELECT "USER"."nameSurname",  "USER"."loginName", matches.count
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
WHERE "USER"."accountNumber" = matches.account3;
