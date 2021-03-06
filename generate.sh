#!/bin/sh

set -eufx

function debug() {
  printf -- "DEBUG: ${1}\n" >&2
}

TOTAL_QUESTIONS=20

while getopts 'n:' OPT
do
  case "${OPT}" in
    n) TOTAL_QUESTIONS="${OPTARG}" ;;
    \?) printf "Incorrect usage.\n" &>2 ;;
  esac
done

if [ "${TOTAL_QUESTIONS}" -gt 1000 ]
then
  printf -- "-n QUESTION_COUNT must be less than 1000.\n" >&2 
  exit 1
fi

if [ "${TOTAL_QUESTIONS}" -lt 1 ]
then
  printf -- "-n QUESTION_COUNT must be more than 0.\n" >&2 
  exit 1
fi

debug "Question count: ${TOTAL_QUESTIONS}"

# A temporary file for the user to edit
TEMP_EXAM_PS=$(mktemp)

# Clean up when we exit.
function trap_exit() {
  rm "${TEMP_EXAM_PS}"
}
trap trap_exit EXIT

EXAM_SHA=$(echo $RANDOM $RANDOM $RANDOM $RANDOM | shasum)
EXAM_ID="${EXAM_SHA:1:8}"


printf "%s\n" "/Courier findfont 16 scalefont setfont
128 570 moveto
(Canadian amateur radio mock exam) show
210 545 moveto
(Exam ID: ${EXAM_ID}) show
showpage" > "${TEMP_EXAM_PS}"

QUESTION_COUNT=1
PAGE_COUNT=1

printf "%s\n" "/Courier findfont 12 scalefont setfont" \
  >> "${TEMP_EXAM_PS}"

unzip -c amat_basic_quest.zip "amat_basic_quest_delim.txt" \
  | egrep -a '^B-[0-9]{3}-[0-9]{3}-[0-9]{3}' \
  | sort --random-sort \
  | head -n "${TOTAL_QUESTIONS}" \
  | cut -f 1,2 -d ';' \
  | while read Q_AND_ID
  do
    debug "${Q_AND_ID}"
    ID=$(printf "%s\n" "${Q_AND_ID}" | cut -f 1 -d ';')
    QUESTION=$(printf "%s\n" "${Q_AND_ID}" | cut -f 2 -d ';' | fold -s -w 60)
    printf "%d %d moveto\n" 90 700 >> "${TEMP_EXAM_PS}"
    printf "(%s) show\n" "${ID}" >> "${TEMP_EXAM_PS}"
    QUESTION_LINE_COUNT=1
    printf "%s\n" "${QUESTION}" \
        | while read QUESTION_LINE
          do 
            QUESTION_Y=$((700 - (${QUESTION_LINE_COUNT} * 14)))
            printf "%d %d moveto\n" 90 "${QUESTION_Y}"  >> "${TEMP_EXAM_PS}"
            printf "(%s) show\n" "${QUESTION_LINE}" >> "${TEMP_EXAM_PS}"
            QUESTION_LINE_COUNT=$((${QUESTION_LINE_COUNT} + 1))
          done
    printf "showpage\n" >> "${TEMP_EXAM_PS}"
    printf "%s\n%s\n\n" "${ID}" "${QUESTION}"
  done

printf "Exam written to: 'mock-exam-%s.pdf'\n" "${EXAM_ID}"
ps2pdf "${TEMP_EXAM_PS}" "mock-exam-${EXAM_ID}.pdf"
