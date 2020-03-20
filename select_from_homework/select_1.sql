--1.) Kdo jsou přátelé uživatele/uživatelů se jménem Jan Novák? Očekává se tabulka výsledku se
-- schématem (přihlašovací jméno Jana Nováka, e-mail Jana Nováka, přihlašovací jméno přítele,
-- jméno a příjmení přítele, e-mail přítele).Uspořádejte podle přihlašovacího jména Jana
--  Nováka.

-- SELECT "accountNumber" FROM "USER" WHERE "nameSurname" = 'Jan Novak');





-- SELECT "loginName" , "email" from User Where (
 --                                      Select "accountNumber2"
 --                                      from ASSOCIATED_ACCOUNTS
  --                                     WHERE ASSOCIATED_ACCOUNTS."accountNumber1" =
  --                                           (SELECT "accountNumber" FROM "USER" WHERE "nameSurname" = 'Jan Novak')

-- Select "accountNumber2" , "accountNumber1" from ASSOCIATED_ACCOUNTS WHERE
-- ASSOCIATED_ACCOUNTS."accountNumber1" =  (SELECT "accountNumber" FROM "USER" WHERE "nameSurname" = 'Jan Novak');


Select * from "USER"(
    Select "accountNumber2", "accountNumber1"
    from ASSOCIATED_ACCOUNTS
    WHERE ASSOCIATED_ACCOUNTS."accountNumber2" = (SELECT "accountNumber" FROM "USER" WHERE "nameSurname" = 'Jan Novak')
) allData  join  allData."accountNumber2" = "USER"."accountNumber1";

