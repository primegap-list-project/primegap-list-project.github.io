set -eux

cd _data

# Arg 1 or default path
# Assumes prime-gap-list checked out at same height as primegap-list-project.github.io
PRIME_GAP_LIST_DIR="${1:-../../prime-gap-list}"

cd "$PRIME_GAP_LIST_DIR"
echo -e "\ngit pull $PRIME_GAP_LIST_DIR\n"
git pull
ls -1h "allgaps.sql"

# Change back to _data directory
cd -

rm -f "$PRIME_GAP_LIST_DIR/gaps.db"
sqlite3 "$PRIME_GAP_LIST_DIR/gaps.db" < "$PRIME_GAP_LIST_DIR/allgaps.sql"

ls -lh "$PRIME_GAP_LIST_DIR/gaps.db"

sqlite3 "$PRIME_GAP_LIST_DIR/gaps.db" -csv -noheader "select * from gaps" > allgaps.csv
sqlite3 "$PRIME_GAP_LIST_DIR/gaps.db" -csv -noheader "select * from credits" > credits.csv

git diff --stat

git add allgaps.csv credits.csv
git commit -m "$(date +"%Y %B %d") Update" | true

git push
