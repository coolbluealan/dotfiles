#!/bin/bash

# Taken from: https://github.com/vEnhance/evans_django_tools/blob/main/lint.sh

# Pro-tip:
# echo "./lint.sh" > .git/hooks/pre-push
# chmod +x .git/hooks/pre-push

FAILED_HEADER="\033[1;31mFAILED:\033[0m"

readarray -t PY_FILES_ARRAY < <(git ls-files '*.py')
readarray -t SHELL_FILES_ARRAY < <(git ls-files '*.sh')
readarray -t SPELL_FILES_ARRAY < <(git ls-files)

run_header() {
  echo -e "\033[1;35mRunning $1 ...\033[0m"
  echo -e "---------------------------"
}

run_header "codespell"
if ! codespell "${SPELL_FILES_ARRAY[@]}"; then
  echo -e "$FAILED_HEADER codespell failed"
  exit 1
fi
echo ""

run_header "shfmt"
if ! shfmt --indent 2 --case-indent --simplify --diff "${SHELL_FILES_ARRAY[@]}"; then
  echo -e "$FAILED_HEADER shfmt failed"
  exit 1
fi
echo ""

run_header "ruff"
if ! ruff check --fix --exit-non-zero-on-fix "${PY_FILES_ARRAY[@]}"; then
  echo -e "$FAILED_HEADER ruff check failed, fixing now ..."
  echo -e "Please recommit and try again!"
  exit 1
fi
if ! ruff format --diff "${PY_FILES_ARRAY[@]}"; then
  echo -e "$FAILED_HEADER ruff format failed, fixing now ..."
  ruff format "${PY_FILES_ARRAY[@]}"
  echo -e "Please recommit and try again!"
  exit 1
fi
echo ""

run_header "pyright"
if ! pyright; then
  echo -e "$FAILED_HEADER pyright failed"
  exit 1
fi
echo ""
