-- 2.) Kolik přátel a kolika různých ročníků (roků narození) mají jednotliví
-- uživatelé se jménem Jan Novák? Očekává se tabulka výsledku se schématem
-- (přihlašovací jméno Jana Nováka, e-mail Jana Nováka, počet přátel, počet ročníků).

(SELECT "USER"."loginName", "USER"."email",
        (SELECT COUNT(friendsData.account1)
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
        WHERE NovakAccounts.account3 = friendsData.account2 OR  NovakAccounts.account3 = friendsData.account1) NumOfFriends,
        (SELECT DISTINCT COUNT("USER"."birthday")
        FROM "USER"
        WHERE "USER"."nameSurname" = 'Jan Novak') numOfDiffBirthdays
FROM "USER"
WHERE "USER"."nameSurname" = 'Jan Novak');
/*
TRASH maybe useful

(SELECT friendsData.account1, friendsData.account2
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
WHERE NovakAccounts.account3 = friendsData.account2 OR  NovakAccounts.account3 = friendsData.account1) ;

povodny shit
(SELECT "USER"."loginName", "USER"."email",
        (SELECT COUNT("USER"."loginName")
        FROM "USER"
        INNER JOIN (
            SELECT ASSOCIATED_ACCOUNTS."accountNumber2"
            FROM ASSOCIATED_ACCOUNTS
            WHERE ASSOCIATED_ACCOUNTS."accountNumber1" =
                    (SELECT "USER"."accountNumber"
                     FROM "USER"
                     WHERE "USER"."nameSurname" = 'Jan Novak')
            ) friendsData
        ON "USER"."accountNumber" = friendsData."accountNumber2") numOfFriends,

        (SELECT DISTINCT COUNT("USER"."birthday")
        FROM "USER"
        WHERE "USER"."nameSurname" = 'Jan Novak') numOfDiffBirthdays
FROM "USER"
WHERE "USER"."nameSurname" = 'Jan Novak');
*/



-- INNER JOIN  allData."accountNumber2" = ."accountNumber1";"USER"
