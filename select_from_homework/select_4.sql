-- 4.) Kdo má nejvíce přátel a kolik? Takových uživatelů může být
-- více. Očekává se tabulka výsledku se schématem (přihlašovací jméno,
-- jméno a příjmení, e-mail, počet přátel).

SELECT *
FROM
    (SELECT f2.login, f2.name, f2.mail, f2.count numOfFriends
     FROM
        (SELECT u1."loginName" login, u1."nameSurname" name, u1."email" mail, COUNT(u1."loginName") as count
        FROM "USER" u1
        INNER JOIN (
            SELECT aa1."accountNumber1", aa1."accountNumber2"
            FROM ASSOCIATED_ACCOUNTS aa1
            WHERE NOT EXISTS
                (SELECT *
                FROM ASSOCIATED_ACCOUNTS aa2
                WHERE (aa1."accountNumber1" = aa2."accountNumber2" AND aa1."accountNumber2" = aa2."accountNumber1"))
            ) f1
        ON u1."accountNumber" = f1."accountNumber1" OR u1."accountNumber" = f1."accountNumber2"
        GROUP BY u1."loginName", u1."nameSurname", u1."email") f2) usersWithFriends
WHERE usersWithFriends.numOfFriends =
    (SELECT MAX(t2.count) maxCount
     FROM
        (SELECT u2."loginName", COUNT(u2."loginName") as count
        FROM "USER" u2
        INNER JOIN (
            SELECT aa1."accountNumber1", aa1."accountNumber2"
            FROM ASSOCIATED_ACCOUNTS aa1
            WHERE NOT EXISTS
                (SELECT *
                FROM ASSOCIATED_ACCOUNTS aa2
                WHERE (aa1."accountNumber1" = aa2."accountNumber2" AND aa1."accountNumber2" = aa2."accountNumber1"))
            ) t1
        ON u2."accountNumber" = t1."accountNumber1" OR u2."accountNumber" = t1."accountNumber2"
        GROUP BY u2."loginName") t2);
