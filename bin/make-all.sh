export SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

clear
pause 3

echo "======================================="
echo "===== Building third-party images ====="
echo "======================================="
${SCRIPTPATH}/make-all-third-party.sh

clear
pause 3

echo "======================================="
echo "===== Building  EpicMorg   images ====="
echo "======================================="
${SCRIPTPATH}/make-all-epicmorg-based.sh

exit 0
