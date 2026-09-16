#!/bin/bash
#
# Copyright 2026 Seth Troisi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eu

# Year end stats
# Percent add (of missing < 200000)
# Percent add (of missing < 500000)
# Percent add (of missing < 1000000)
#
# Largest added merit
# Largest improvement merit
# Largest removed replacement
#
# Smallest addded gap
# Largest added gap
#
# Most merit added in a single commit
# Most merit improved in a single commit

cd ../../prime-gap-list
DB=gaps.db
TARGET_YEAR=$(date +%Y) # Defaults to current year (e.g., 2026)

echo "=========================================="
echo "          YEAR END STATISTICS ($TARGET_YEAR)"
echo "=========================================="

calc_missing_stats() {
    local max_gap=$1
    sqlite3 "$DB" <<EOF
SELECT
    printf("%6d/%d %.3f%% missing",
        (($max_gap / 2) - COUNT(*)),
        ($max_gap / 2),
        (100.0 - (CAST(COUNT(*) AS REAL) / ($max_gap / 2.0)) * 100.0)
    )
FROM gaps
WHERE gapsize <= $max_gap;
EOF
}

stats_200k=$(calc_missing_stats 200000)
stats_500k=$(calc_missing_stats 500000)
stats_1m=$(calc_missing_stats 1000000)

echo "Percent missing (<= 200,000):   ${stats_200k}"
echo "Percent missing (<= 500,000):   ${stats_500k}"
echo "Percent missing (<= 1,000,000): ${stats_1m}"
echo "------------------------------------------"

echo "Top 5 Largest Added Merit ($TARGET_YEAR):"
sqlite3 "$DB" -header -column <<EOF
SELECT gapsize, merit, discoverer
FROM gaps
WHERE year = $TARGET_YEAR
ORDER BY merit DESC LIMIT 5;
EOF

echo ""
echo "Top 5 Smallest Added Gaps ($TARGET_YEAR):"
sqlite3 "$DB" -header -column <<EOF
SELECT gapsize, merit, discoverer
FROM gaps
WHERE year = $TARGET_YEAR
ORDER BY gapsize ASC LIMIT 5;
EOF

echo ""
echo "Top 5 Largest Added Gaps ($TARGET_YEAR):"
sqlite3 "$DB" -header -column <<EOF
SELECT gapsize, merit, discoverer
FROM gaps
WHERE year = $TARGET_YEAR
ORDER BY gapsize DESC LIMIT 5;
EOF
echo "------------------------------------------"

# Analyze Git logs for the current year to extract replace/improvement/commit stats
git log --since="${TARGET_YEAR}-01-01" -p "allgaps.sql" | awk '
BEGIN {
    largest_imp_merit = -1.0;
    largest_rem_merit = -1.0;
    most_added_commit_merit = 0.0;
    most_imp_commit_merit = 0.0;

    current_commit = "";
    curr_added_merit = 0.0;
    curr_imp_merit = 0.0;
}

# Track Commits
/^commit / {
    if (curr_added_merit > max_added_commit_merit) {
        max_added_commit_merit = curr_added_merit;
        best_added_commit = substr(current_commit,1,7);
    }
    if (curr_imp_merit > max_imp_commit_merit) {
        max_imp_commit_merit = curr_imp_merit;
        best_imp_commit = substr(current_commit,1,7);
    }
    current_commit = $2;
    curr_added_merit = 0.0;
    curr_imp_merit = 0.0;
}

# Process removed lines (-)
/^-INSERT INTO gaps VALUES/ {
    split($0, a, ",");
    gap = a[1]; sub(/^-INSERT INTO gaps VALUES\(/, "", gap);
    merit = a[8];

    removed_merit[gap] = merit + 0.0;
    if ((merit + 0.0) > largest_rem_merit) {
        largest_rem_merit = merit + 0.0;
        largest_rem_gap = gap;
    }
}

# Process added lines (+)
/^\+INSERT INTO gaps VALUES/ {
    split($0, a, ",");
    gap = a[1]; sub(/^\+INSERT INTO gaps VALUES\(/, "", gap);
    merit = a[8] + 0.0;

    if (gap in removed_merit) {
        old_m = removed_merit[gap];
        diff_m = merit - old_m;
        curr_imp_merit += diff_m;

        if (diff_m > largest_imp_merit) {
            largest_imp_merit = diff_m;
            largest_imp_gap = gap;
            largest_imp_details = sprintf("gap %s (%.4f -> %.4f, +%.4f)", gap, old_m, merit, diff_m);
        }
    } else {
        curr_added_merit += merit;
    }
}

END {
    # Check last commit in loop
    if (curr_added_merit > max_added_commit_merit) {
        max_added_commit_merit = curr_added_merit;
        best_added_commit = substr(current_commit,1,7);
    }
    if (curr_imp_merit > max_imp_commit_merit) {
        max_imp_commit_merit = curr_imp_merit;
        best_imp_commit = substr(current_commit,1,7);
    }

    print "Largest improvement merit:     " largest_imp_details;
    print "Largest removed replacement:   gap " largest_rem_gap " (merit " largest_rem_merit ")";
    print "------------------------------------------";
    print "Most merit added in 1 commit:   +" sprintf("%.4f", max_added_commit_merit) " (" best_added_commit ")";
    print "Most merit improved in 1 commit: +" sprintf("%.4f", max_imp_commit_merit) " (" best_imp_commit ")";
}
'
