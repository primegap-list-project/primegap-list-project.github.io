set -eux

cd _data

# Arg 1 or default path
PRIME_GAP_LIST_DIR="${1:-../../prime-gap-list}"

echo -e "\nDon't forget to git pull in $PRIME_GAP_LIST_DIR\n"
ls -1h "$PRIME_GAP_LIST_DIR/allgaps.sql"

# Assumes prime-gap-list checked out at same height as primegap-list-project.github.io
rm -f "$PRIME_GAP_LIST_DIR/gaps.db"
sqlite3 "$PRIME_GAP_LIST_DIR/gaps.db" < "$PRIME_GAP_LIST_DIR/allgaps.sql"

ls -lh "$PRIME_GAP_LIST_DIR/gaps.db"

sqlite3 "$PRIME_GAP_LIST_DIR/gaps.db" -csv -noheader "select * from gaps" > allgaps.csv
sqlite3 "$PRIME_GAP_LIST_DIR/gaps.db" -csv -noheader "select * from credits" > credits.csv

git diff --stat


