--1.) Kdo jsou přátelé uživatele/uživatelů se jménem Jan Novák? Očekává se tabulka výsledku se
-- schématem (přihlašovací jméno Jana Nováka, e-mail Jana Nováka, přihlašovací jméno přítele,
-- jméno a příjmení přítele, e-mail přítele).Uspořádejte podle přihlašovacího jména Jana
--  Nováka.

( Select "login_name1",  "name_1" , "login_name2" , "name_2","email" from
(Select * From
(
Select "loginName" as "login_name1" , "nameSurname" as "name_1" , "accountNumber1" FROM
    ( SELECT  * FROM "USER" WHERE "nameSurname" = 'Jan Novak' ) t1
 inner join
     ( SELECT "accountNumber2" , "accountNumber1"  FROM ASSOCIATED_ACCOUNTS ) t2
 On t1."accountNumber" = t2."accountNumber2"
 ) leftside
 inner join
(select "accountNumber", "nameSurname" as "name_2" ,"loginName" as "login_name2", "email"  from "USER" ) rightside
On leftside."accountNumber1" = rightside."accountNumber" ) fulltable )

UNION

(Select "login_name1",  "name_1" , "login_name2","name_2" , "email" from
(Select * From
(
Select"loginName" as "login_name1" , "nameSurname" as "name_1" , "accountNumber2" FROM
    ( SELECT  * FROM "USER" WHERE "nameSurname" = 'Jan Novak' ) t1
inner join
    ( SELECT "accountNumber1" , "accountNumber2"  FROM ASSOCIATED_ACCOUNTS ) t2
On t1."accountNumber" = t2."accountNumber1"
) leftside

inner join
(select "accountNumber", "nameSurname" as "name_2" ,"loginName" as "login_name2", "email"  from "USER" ) rightside
On leftside."accountNumber2" = rightside."accountNumber" ) fulltable)















