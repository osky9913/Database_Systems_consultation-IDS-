# Zadanie prvého selectu 

- 1.) Kdo jsou přátelé uživatele/uživatelů se jménem Jan Novák? Očekává se tabulka výsledku se 
schématem (přihlašovací jméno Jana Nováka, e-mail Jana Nováka, přihlašovací jméno přítele, jméno a příjmení přítele, e-mail přítele).Uspořádejte podle přihlašovacího jména Jana Nováka.

- Informácie o uživateľoch máme v tabulke "USER" a informácie o tom kto je s kým priateľ máme v tabulke ASSOCIATED_ACCOUNTS

- Tabulka ASSOCIATED_ACCOUNTS môže mať aj v stĺpci "accountNumber1" a v "accountNumber2" ID pána Nováka
preto  najprv si túto tabuľku upravíme a to 

```sql
        (SELECT "accountNumber2" as "Jan", "accountNumber1" as "Friend" FROM ASSOCIATED_ACCOUNTS)
        UNION
        (SELECT "accountNumber1" as "Jan", "accountNumber2"  as Friend FROM ASSOCIATED_ACCOUNTS )
```
a z tabuľky "USER" si vyberieme riadok kde meno sa volá "Jan Novak"

```sql
 ( SELECT "loginName" as "login_name1" , "email" as "email_1","nameSurname" as "name_1" , "accountNumber" FROM "USER" WHERE "nameSurname" = 'Jan Novak' ) t1

```

Tieto dve tabuľky sa napoja pomocou spoločného kľúča 
```sql
    ON  associated."Jan" = t1."accountNumber"
```
a pomocou príkazu inner join

```sql
( Select * From
    ( SELECT "loginName" as "login_name1" , "email" as "email_1","nameSurname" as "name_1" , "accountNumber" FROM "USER" WHERE "nameSurname" = 'Jan Novak' ) t1
inner join
    (
        (SELECT "accountNumber2" as "Jan", "accountNumber1" as "Friend" FROM ASSOCIATED_ACCOUNTS)
        UNION
        (SELECT "accountNumber1" as "Jan", "accountNumber2"  as Friend FROM ASSOCIATED_ACCOUNTS )
    ) associated
ON  associated."Jan" = t1."accountNumber"
) leftSide
```
Takto nám vznikne tabuľka s informáciami Jána Nováka a s kĺúčom priateľov Jána Nováka

Teraz si upravíme tabuľku "USER" na informácie o priateľovi a to nasledovne

```sql
(select "accountNumber", "nameSurname" as "name_2" ,"loginName" as "login_name2", "email"  as "email_2" from "USER" ) rightside
```
a túto tabuľku znova napojíme pomocou inner join na základe kľúču priateľa 
```sql
ON leftSide."Friend" = rightside."accountNumber"
```

Následne nám vznikne celý kód:
```sql

Select  "login_name1",  "email_1" , "login_name2" , "name_2","email_2" From

(select "accountNumber", "nameSurname" as "name_2" ,"loginName" as "login_name2", "email"  as "email_2" from "USER" ) rightside

inner join

(Select * From
    ( SELECT "loginName" as "login_name1" , "email" as "email_1","nameSurname" as "name_1" , "accountNumber" FROM "USER" WHERE "nameSurname" = 'Jan Novak' ) t1
inner join
    (
        (SELECT "accountNumber2" as "Jan", "accountNumber1" as "Friend" FROM ASSOCIATED_ACCOUNTS)
        UNION
        (SELECT "accountNumber1" as "Jan", "accountNumber2"  as Friend FROM ASSOCIATED_ACCOUNTS )
    ) associated
ON  associated."Jan" = t1."accountNumber"
) leftSide
On leftSide."Friend" = rightside."accountNumber"
```


# Zadanie piateho selectu 

- 5.Kteří uživatelé nemají žádného přítele? Očekává se tabulka výsledku se schématem
(přihlašovací jméno, jméno a příjmení, e-mail).
```sql
SELECT "loginName", "nameSurname","email"
FROM "USER"  t1
LEFT JOIN ASSOCIATED_ACCOUNTS t2 ON t2."accountNumber1" = t1."accountNumber"  OR  "accountNumber2" = t1."accountNumber"
WHERE t2."accountNumber1" IS NULL  or t2."accountNumber2"  IS NULL
```

Vyberáme "loginName", "nameSurname","email" podľa zadania pričom pomocou letfJoinu kontroluje napojenie na tabuľu ASSOCIATED_ACCOUNTS
pričom kontrolujeme  pomocou podmienky IS NULL pravu alebo ľavú časť ASSOCIATED_ACCOUNTS.