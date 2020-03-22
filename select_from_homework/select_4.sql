-- 4.) Kdo má nejvíce přátel a kolik? Takových uživatelů může být
-- více. Očekává se tabulka výsledku se schématem (přihlašovací jméno,
-- jméno a příjmení, e-mail, počet přátel).

SELECT *
FROM
    (SELECT f1.login, f1.name, f1.mail, f1.count numOfFriends
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
            ) friendsData
        ON u1."accountNumber" = friendsData."accountNumber1" OR u1."accountNumber" = friendsData."accountNumber2"
        GROUP BY u1."loginName", u1."nameSurname", u1."email") f1
    ORDER BY f1.count DESC) usersWithFriends
WHERE usersWithFriends.numOfFriends =
    (SELECT MAX(f2.count) numbeer
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
            ) friendsData
        ON u2."accountNumber" = friendsData."accountNumber1" OR u2."accountNumber" = friendsData."accountNumber2"
        GROUP BY u2."loginName") f2);

/*
TRASH maybe useful


SELECT f1.login, f1.name, f1.mail, f1.count numOfFriends
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
            ) friendsData
        ON u1."accountNumber" = friendsData."accountNumber1" OR u1."accountNumber" = friendsData."accountNumber2"
        GROUP BY u1."loginName", u1."nameSurname", u1."email") f1
    GROUP BY f1.login, f1.name, f1.mail, f1.count
    ORDER BY f1.count DESC;

SELECT aa1."accountNumber1", aa1."accountNumber2"
FROM ASSOCIATED_ACCOUNTS aa1
WHERE NOT EXISTS
    (SELECT *
    FROM ASSOCIATED_ACCOUNTS aa2
    WHERE (aa1."accountNumber1" = aa2."accountNumber2" AND aa1."accountNumber2" = aa2."accountNumber1"));

SELECT "USER"."loginName", "USER"."nameSurname", "USER"."email", maxCount.numbeer
FROM "USER"
INNER JOIN
    (SELECT MAX(numOfFriends.count) numbeer
     FROM
        (SELECT "USER"."loginName", COUNT("USER"."loginName") as count
        FROM "USER"
        INNER JOIN (
            SELECT ASSOCIATED_ACCOUNTS."accountNumber1"
            FROM ASSOCIATED_ACCOUNTS, "USER"
            WHERE ASSOCIATED_ACCOUNTS."accountNumber1" = "USER"."accountNumber"
            ) friendsData
        ON "USER"."accountNumber" = friendsData."accountNumber1"
        GROUP BY "USER"."loginName") numOfFriends) maxCount
ON maxCount.numbeer = 3;

------------------------------------

(SELECT "USER"."loginName", COUNT("USER"."loginName") as count
FROM "USER"
INNER JOIN (
    SELECT ASSOCIATED_ACCOUNTS."accountNumber1"
    FROM ASSOCIATED_ACCOUNTS, "USER"
    WHERE ASSOCIATED_ACCOUNTS."accountNumber1" = "USER"."accountNumber"
    ) friendsData
ON "USER"."accountNumber" = friendsData."accountNumber1"
GROUP BY "USER"."loginName");

------------------------------------

SELECT "USER"."loginName", "USER"."nameSurname", "USER"."email", maxCount.numbeer
FROM "USER",
     (SELECT MAX(numOfFriends.count) numbeer
     FROM
        (SELECT "USER"."loginName", COUNT("USER"."loginName") as count
        FROM "USER"
        INNER JOIN (
            SELECT ASSOCIATED_ACCOUNTS."accountNumber1"
            FROM ASSOCIATED_ACCOUNTS, "USER"
            WHERE ASSOCIATED_ACCOUNTS."accountNumber1" = "USER"."accountNumber"
            ) friendsData
        ON "USER"."accountNumber" = friendsData."accountNumber1"
        GROUP BY "USER"."loginName") numOfFriends) maxCount;
WHERE maxCount.numbeer =
        (SELECT *
         FROM
            (SELECT COUNT(*) as count
            FROM "USER" f2
            INNER JOIN (
                SELECT ASSOCIATED_ACCOUNTS."accountNumber1"
                FROM ASSOCIATED_ACCOUNTS, "USER"
                WHERE ASSOCIATED_ACCOUNTS."accountNumber1" = "USER"."accountNumber"
                ) friendsData
            ON f2."accountNumber" = friendsData."accountNumber1"
            WHERE f2."accountNumber" = friendsData."accountNumber1"
            GROUP BY f2."loginName")
         WHERE ROWNUM=1);

------------------------------------

SELECT "USER"."loginName", "USER"."nameSurname", "USER"."email",
        (SELECT MAX(numOfFriends.count)
        FROM
            (SELECT "USER"."loginName" login, COUNT("USER"."loginName") as count
            FROM "USER"
            INNER JOIN (
                SELECT ASSOCIATED_ACCOUNTS."accountNumber1"
                FROM ASSOCIATED_ACCOUNTS, "USER"
                WHERE ASSOCIATED_ACCOUNTS."accountNumber1" = "USER"."accountNumber"
                ) friendsData
            ON "USER"."accountNumber" = friendsData."accountNumber1"
            GROUP BY "USER"."loginName") numOfFriends) maxCount
FROM "USER";

*/