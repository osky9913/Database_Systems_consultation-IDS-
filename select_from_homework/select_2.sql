-- 2.) Kolik přátel a kolika různých ročníků (roků narození) mají jednotliví
-- uživatelé se jménem Jan Novák? Očekává se tabulka výsledku se schématem
-- (přihlašovací jméno Jana Nováka, e-mail Jana Nováka, počet přátel, počet ročníků).

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

-- INNER JOIN  allData."accountNumber2" = ."accountNumber1";"USER"
