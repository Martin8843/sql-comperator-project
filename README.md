# sql-comperator-project
Pakiet PL/SQL do porównywania wersji tabeli FACT (wykrywanie zmian, nowych i usuniętych rekordów oraz różnic w kolumnach).


## 🇵🇱 Opis projektu

**Cel projektu:**  
Celem zadania jest stworzenie pakietu PL/SQL, który pozwala porównywać różne wersje danych tabeli FACT w bazie Oracle. Pakiet wykrywa wiersze zmodyfikowane, nowe oraz usunięte, a także może generować szczegółowe różnice na poziomie kolumn.  

**Czego się nauczyłem:**  
- projektowania i implementacji **zaawansowanych pakietów PL/SQL**,  
- pracy z **danymi historycznymi** i wersjonowaniem w bazie danych,  
- używania **tabel tymczasowych** do przechowywania wyników analizy,  
- formatowania wyników w sposób czytelny dla analityków i użytkowników nietechnicznych,  
- logicznego myślenia przy porównywaniu danych i generowaniu raportów zmian.  

**Dlaczego jest przydatne:**  
- Automatyzuje porównywanie wersji danych, co jest kluczowe przy migracjach, audytach lub analizach historycznych.  
- Pokazuje, że potrafisz tworzyć **praktyczne narzędzia analityczne**, a nie tylko pisać zapytania SQL.  
- Rozwija umiejętność **rozwiązywania problemów w środowisku Oracle**.  

---

## EN Project Description

**Project goal:**  
The goal of this task is to create a PL/SQL package that compares different versions of the FACT table in an Oracle database. The package identifies modified, new, and deleted rows, and optionally generates detailed column-level differences.  

**Skills gained:**  
- Designing and implementing **advanced PL/SQL packages**,  
- Working with **historical/versioned data**,  
- Using **temporary tables** to store analysis results,  
- Formatting results clearly for analysts and non-technical users,  
- Logical problem-solving for data comparison and reporting.  

**Why it is useful:**  
- Automates version comparison, essential for migrations, audits, or historical data analysis.  
- Demonstrates the ability to create **practical analytical tools**, not just SQL queries.  
- Strengthens skills in **Oracle problem-solving**.  

---

## 🔹 Usage

1. Call the procedure `COMPARE_FACT(ID_PACK_OLD, ID_PACK_NEW)` to compare two versions of the FACT table.  
2. Optionally, use `BUILD_DIFF => TRUE` to generate detailed column-level differences.  
3. Results are stored in temporary tables:  
   - `TMP_FACT_HISTORY_COMPARE_STATUS` (status of each row)  
   - `TMP_FACT_HISTORY_COMPARE_DIFF` (detailed column differences for modified rows)  

