-- 4.) Kdo má nejvíce přátel a kolik? Takových uživatelů může být
-- více. Očekává se tabulka výsledku se schématem (přihlašovací jméno,
-- jméno a příjmení, e-mail, počet přátel).

SELECT table1."loginName", table1."nameSurname", table1."email", MAX(numOfFriends.count)
FROM "USER" table1
INNER JOIN (
    SELECT "USER"."loginName" login, COUNT("USER"."loginName") count
    FROM "USER"
    INNER JOIN (
        SELECT ASSOCIATED_ACCOUNTS."accountNumber1"
        FROM ASSOCIATED_ACCOUNTS, "USER"
        WHERE ASSOCIATED_ACCOUNTS."accountNumber1" = "USER"."accountNumber"
        ) friendsData
    ON "USER"."accountNumber" = friendsData."accountNumber1"
    GROUP BY "USER"."loginName") numOfFriends
ON numOfFriends.login = table1."loginName"
GROUP BY table1."loginName", table1."nameSurname", table1."email";


