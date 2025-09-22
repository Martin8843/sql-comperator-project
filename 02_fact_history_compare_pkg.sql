-- =========================================================================
/*  
	Plik do zadania 1 i 2: 02_fact_history_compare_pkg.sql
	Specyfiakcja pakietu: fact_history_compare_pkg
    Ciało pakietu: fact_history_compare_pkg.
	Implementacja procedury compare_fact z parametrem przekazanym ze srodowiska do programu: id (nowej i starej paczki) oraz opcjnalnym parametrem
	Date: 2025-08-31
*/
-- =========================================================================

CREATE OR REPLACE PACKAGE fact_history_compare_pkg
IS
    PROCEDURE compare_fact (id_pack_new   IN fact_history.id_pack%TYPE, 
                            id_pack_old   IN fact_history.id_pack%TYPE,
                            build_diff    IN BOOLEAN DEFAULT FALSE);
END fact_history_compare_pkg;


CREATE OR REPLACE PACKAGE BODY fact_history_compare_pkg 
IS
  PROCEDURE compare_fact (
      id_pack_new IN fact_history.id_pack%TYPE,
      id_pack_old IN fact_history.id_pack%TYPE,
      build_diff  IN BOOLEAN DEFAULT FALSE
  )
  IS
      v_sql VARCHAR2(1000);  -- zmienna do dynamicznego SQL 
	  
	  /*
      ZAŁOŻENIA:
     - (id_pack, id_fact) jest kluczem złożonym > w każdej pczce jest max 1 wiersz dla id_fact;
     -NULL porównaia kolumn robi się przez COALESCE/TO_CHAR, żeby NULL = NULL
     - wynik: tmp_fact_history_compare_status zawiera tylko różnice; brak reordu oznacza że wiesz jest identyczny w obu paczkach.
      KROKI:
   1) FULL OUTER JOIN 
   - daje komplet wierszy: tylko w starej, tyko w nowej, oraz pary do porównania.
   2) WHERE
      - filtruje tylko te wiersze, które są różne
   3) CASE
      - ustala typ zmiany: DELETD (3), NEW (2), MODIFIED (1).
   4) ROW_NUMBER() ... rn = 1
      - eliminuje ewentualne duplikaty id_fact zwracając dokładnie jeden wiersz na id_fact do INSERT.
		*/
BEGIN
  INSERT INTO tmp_fact_history_compare_status (id_fact, status)
  SELECT id_fact, status
  FROM (
   -- To podzapytanie generuje kolumny a jej wyniki istnieja tylko tutaj a za pomoca aliasu odwoluje sie do niej  w zewnet select
   -- dla każdej jednostki faktu jedną reprezentatywną zmianę – 
   -- to podzapytanie generuje wszystkie zmiany dla każdego id, nadaje im typ (DELETED, NEW, MODIFIED), nadaje numer wierszom w grupie id_fact według priorytetu zmian, 
   -- a w głównym SELECT wybieramy tylko jeden wiersz na fakt (rn = 1). Dzięki temu wiemy, które rekordy faktycznie się zmieniły
    SELECT 
      COALESCE(fact_new.id_fact, fact_old.id_fact) AS id_fact,
      CASE
        WHEN fact_old.id_fact IS NOT NULL AND fact_new.id_fact IS NULL THEN 3  -- DELETED
        WHEN fact_old.id_fact IS NULL AND fact_new.id_fact IS NOT NULL THEN 2  -- NEW
        ELSE 1  -- MODIFIED 
      END AS status, -- generuje kolumne status i zwraca do glownego selecta
      ROW_NUMBER() OVER -- numeruje kazdy wiersz w grupie
        PARTITION BY --grupuje po id_fact w kazdej grupie numeracja zaczyna sie od 1  
		COALESCE(fact_new.id_fact, fact_old.id_fact)  -- rekord istaniejacy w konkrentej paczce trafia do odpowiedniej grupy
        ORDER BY CASE
                 WHEN fact_old.id_pack IS NOT NULL AND fact_new.id_pack IS NULL THEN 1
                 WHEN fact_old.id_pack IS NULL AND fact_new.id_pack IS NOT NULL THEN 2
                 ELSE 3
                 END
      ) AS rn        
   FROM
        (SELECT * FROM fact_history WHERE id_pack = id_pack_old) fact_old
    FULL OUTER JOIN
        (SELECT * FROM fact_history WHERE id_pack = id_pack_new) fact_new
    ON fact_old.id_fact = fact_new.id_fact
    WHERE
      fact_old.id_fact IS NULL 
      OR fact_new.id_fact IS NULL 
      OR COALESCE(TO_CHAR(fact_old.first_name),'<<NULL>>') <> COALESCE(TO_CHAR(fact_new.first_name),'<<NULL>>')
      OR COALESCE(TO_CHAR(fact_old.surname),'<<NULL>>')    <> COALESCE(TO_CHAR(fact_new.surname),'<<NULL>>')
      OR COALESCE(TO_CHAR(fact_old.city),'<<NULL>>')       <> COALESCE(TO_CHAR(fact_new.city),'<<NULL>>')
      OR COALESCE(TO_CHAR(fact_old.status),'<<NULL>>')     <> COALESCE(TO_CHAR(fact_new.status),'<<NULL>>')
      OR COALESCE(TO_CHAR(fact_old.amount),'<<NULL>>')     <> COALESCE(TO_CHAR(fact_new.amount),'<<NULL>>')
      OR COALESCE(TO_CHAR(fact_old.score),'<<NULL>>')      <> COALESCE(TO_CHAR(fact_new.score),'<<NULL>>')
      OR COALESCE(TO_CHAR(fact_old.level_num),'<<NULL>>')  <> COALESCE(TO_CHAR(fact_new.level_num),'<<NULL>>')
      OR COALESCE(TO_CHAR(fact_old.start_date,'YYYYMMDD'),'<<NULL>>') <> COALESCE(TO_CHAR(fact_new.start_date,'YYYYMMDD'),'<<NULL>>')
      OR COALESCE(TO_CHAR(fact_old.end_date,'YYYYMMDD'),'<<NULL>>')   <> COALESCE(TO_CHAR(fact_new.end_date,'YYYYMMDD'),'<<NULL>>')
      OR COALESCE(TO_CHAR(fact_old.update_date,'YYYYMMDD'),'<<NULL>>')<> COALESCE(TO_CHAR(fact_new.update_date,'YYYYMMDD'),'<<NULL>>')
  )
  WHERE rn = 1 -- oznacz 1 wierszw grupie id_fact wg priorytetu w orderby case nawet jesli powstały by dupliakty po zlaczeniu full outer;
  -- do tabeli tymczaswej wstawiamy jeden reprezentatywny wiersz dal akzdego id_fact
      
      -- Jeśli build_diff = TRUE, wstawiam szczegóły różnic do tmp_fact_history_compare_dif
      -- 1.  Dla każdej kolumny FACT_HISTORY buduje dynamiczne INSERT
      -- 2. Wstawim do tmp_fact_history_compare_diff różnice między paczką starą i nową
      -- 3. Pobieram id_fact tylko dla rekrdów ze stausem = 1
      -- 4. Porówujem wartości w fact_old vs fact_new 

      IF build_diff THEN
              FOR rec_col IN (
                  SELECT column_name, data_type
                  FROM user_tab_columns
                  WHERE UPPER(table_name) = 'FACT_HISTORY'
                    AND column_name NOT IN ('ID_PACK','ID_FACT')
              ) LOOP
              
						  v_sql := 'INSERT INTO tmp_fact_history_compare_diff (' ||
						 'id_fact, col_name, col_type, col_old_value, col_new_value) ' ||
						 'SELECT s.id_fact, ' ||
						 '''' || rec_col.column_name || ''', ' ||
						 '''' || rec_col.data_type || ''', ' ||
						 'COALESCE(TO_CHAR(fact_old.' || rec_col.column_name || '), ''NULL''), ' ||
						 'COALESCE(TO_CHAR(fact_new.' || rec_col.column_name || '), ''NULL'') ' ||
						 'FROM fact_history fact_old ' ||
            'JOIN fact_history fact_new ' ||
            '  ON fact_old.id_fact = fact_new.id_fact ' ||
            'JOIN tmp_fact_history_compare_status s ' ||
            '  ON s.id_fact = fact_old.id_fact ' ||
            'WHERE fact_old.id_pack = :1 ' ||
            '  AND fact_new.id_pack = :2 ' ||
            '  AND s.status = 1 ' ||
            '  AND COALESCE(TO_CHAR(fact_old.' || rec_col.column_name || '), ''NULL'') <> COALESCE(TO_CHAR(fact_new.' || rec_col.column_name || '), ''NULL'')';
                  EXECUTE IMMEDIATE v_sql USING  id_pack_old, id_pack_new;
              END LOOP; -- rec_col
      END IF; -- build_diff
  EXCEPTION
      WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Błąd w procedurze COMPARE_FACT: ' || SQLERRM);
  END;
END fact_history_compare_pkg;
/
