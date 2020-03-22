--1.) Kdo jsou přátelé uživatele/uživatelů se jménem Jan Novák? Očekává se tabulka výsledku se
-- schématem (přihlašovací jméno Jana Nováka, e-mail Jana Nováka, přihlašovací jméno přítele,
-- jméno a příjmení přítele, e-mail přítele).Uspořádejte podle přihlašovacího jména Jana
--  Nováka.

Select  "login_name1",  "name_1" , "login_name2" , "name_2","email" From
(select "accountNumber", "nameSurname" as "name_2" ,"loginName" as "login_name2", "email"  from "USER" ) rightside

inner join

(Select * From
    ( SELECT "loginName" as "login_name1" , "nameSurname" as "name_1" , "accountNumber" FROM "USER" WHERE "nameSurname" = 'Jan Novak' ) t1
inner join
    (
        (SELECT "accountNumber2" as "Jan", "accountNumber1" as "Friend" FROM ASSOCIATED_ACCOUNTS)
        UNION
        (SELECT "accountNumber1" as "Jan", "accountNumber2"  as Friend FROM ASSOCIATED_ACCOUNTS )
    ) associated
ON  associated."Jan" = t1."accountNumber"
) leftSide
On leftSide."Friend" = rightside."accountNumber";














