awk 'NR == 1 {line = $0; min = $5}
     NR > 1 && $5 < min {line = $0; min = $5}
     END{print line}' summary2.csv
