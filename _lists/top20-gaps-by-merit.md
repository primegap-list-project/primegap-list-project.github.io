---
layout: list
title: "Top 20 gaps by merit"
description: "Top 20 record prime gaps ordered by merit"
author: Graham Higgins
category: list
tags: list
excerpt: "Top 20 record prime gaps ordered by merit"
columns: [Rank, Gap Size, Gap start, Merit, Discoverer, Year]
dbquery: "SELECT gapsize, CASE primecert WHEN 'P' then 'PRP' ELSE 'P' END || primedigits ||' = ' || CASE  WHEN LENGTH(startprime) > 80 then SUBSTR(startprime, 0, 28) || '...' ELSE startprime END gapstart, merit, (select display from credits where abbreviation = discoverer) as name, year FROM gaps ORDER BY merit desc LIMIT 20;"
htmltemplate: "<tr><td class='right aligned'>${cnt}</td>
<td class='right aligned'>${row['gapsize'].toString().padStart(6, ' ')}</td> <td>${row['gapstart'].toString().padEnd(8, ' ')}</td><td class='center aligned'>${row['merit'].toFixed(2).toString().padStart(5, ' ')}</td> <td>${row['name']}</td><td>${row['year']}</td></tr>"
---