# Cheat Sheet #

## Results by Date ##

```sql
SELECT c.visitDate, COUNT(1) as visits 
FROM c 
WHERE c.type = 'visitreport' AND c.result != '' 
GROUP BY c.visitDate
```

## Overall Stats

```sql
SELECT 
  COUNT(1) as countScore,
  AVG(c.visitResultSentimentScore) as avgScore, 
  MAX(c.visitResultSentimentScore) as maxScore, 
  MIN(c.visitResultSentimentScore) as minScore 
FROM c 
WHERE c.type = 'visitreport' and c.result != '' 
GROUP BY c.type
```

## Stats by Contact ##

```sql
SELECT 
    c.contact.id,
    COUNT(1) as countScore,
    MIN(c.visitResultSentimentScore) as minScore, 
    MAX(c.visitResultSentimentScore) as maxScore,
    AVG(c.visitResultSentimentScore) as avgScore 
FROM c 
WHERE c.type = 'visitreport' AND c.result != '' AND c.contact.id = '935c3bbc-1624-48eb-9372-a3a43562e73a'
GROUP BY c.contact.id
```