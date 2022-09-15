#!/bin/sh
DIR=$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" && pwd)
#echo $DIR
#COLOR CODES:
#tput setaf 3 = yellow -> Info
#tput setaf 1 = red -> warning/not allowed commit
#tput setaf 2 = green -> all good!/allowed commit

echo ""
echo "$(tput setaf 3)Running hook ... (you can omit this with --no-verify, but don't)$(tput sgr 0)"

echo "$(tput setaf 3)* Compiling... $(tput sgr 0)"
(
  cd ${DIR}/
  ./gradlew --quiet compileJava
)
compile=$?

echo "$(tput setaf 3)* Compiles?$(tput sgr 0)"

if [[ ${compile} -eq 0 ]]; then
  echo "$(tput setaf 2)* Yes$(tput sgr 0)"
  echo ""
else
  echo "$(tput setaf 1)* No$(tput sgr 0)"
  echo ""
fi

echo "$(tput setaf 3)* Formatting... $(tput sgr 0)"
(
  cd ${DIR}/
  ./gradlew --quiet spotlessCheck
)
git diff --quiet
format=$?

echo "$(tput setaf 3)* Formats?$(tput sgr 0)"

if [[ ${format} -eq 0 ]]; then
  echo "$(tput setaf 2)* Yes$(tput sgr 0)"
  echo ""
else
  echo "$(tput setaf 1)* No$(tput sgr 0)"
  echo "$(tput setaf 1)The following files need formatting:$(tput sgr 0)"
  git diff --name-only
  echo ""
  echo "$(tput setaf 1)Please run 'spotlessCheck' to format the code.$(tput sgr 0)"
  echo ""
fi

echo "$(tput setaf 3)* PMDing... $(tput sgr 0)"
(
  cd ${DIR}/
  ./gradlew --quiet check
)
pmd=$?

echo "$(tput setaf 3)* PMDs?$(tput sgr 0)"

if [[ ${pmd} -eq 0 ]]; then
  echo "$(tput setaf 2)* Yes$(tput sgr 0)"
  echo ""
else
  echo "$(tput setaf 1)* No$(tput sgr 0)"
  echo "$(tput setaf 1)Please see the report at build/reports/pmd/main.html.$(tput sgr 0)"
  echo ""
fi

echo "$(tput setaf 3)* Testing... $(tput sgr 0)"
(
  cd ${DIR}/
  ./gradlew --quiet testAll
)
test=$?

echo "$(tput setaf 3)* Tests?$(tput sgr 0)"

if [[ ${test} -eq 0 ]]; then
  echo "$(tput setaf 2)* Yes$(tput sgr 0)"
  echo ""
else
  echo "$(tput setaf 1)* No$(tput sgr 0)"
  echo "$(tput setaf 1)Please fix it.$(tput sgr 0)"
  echo ""
fi

if [[ ${compile} -eq 0 ]] && [[ ${format} -eq 0 ]] && [[ ${pmd} -eq 0 ]] && [[ ${test} -eq 0 ]]; then
  echo "$(tput setaf 2)... done. Proceeding with commit.$(tput sgr 0)"
  echo ""
  echo "$(tput setaf 3)* Upgrading... $(tput sgr 0)"
  (
    cd ${DIR}/
    ./gradlew --quiet dependencyUpdates
  )
  echo "$(tput setaf 3)* Please keep upgrading libraries and plugins.$(tput sgr 0)"
  echo ""
  exit 0
elif [[ ${format} != 0 ]]; then
  echo "$(tput setaf 1)... done.$(tput sgr 0)"
  echo "$(tput setaf 1)CANCELLING commit due to FORMAT ERROR.$(tput sgr 0)"
  echo ""
  exit 1
elif [[ ${compile} != 0 ]]; then
  echo "$(tput setaf 1)... done.$(tput sgr 0)"
  echo "$(tput setaf 1)CANCELLING commit due to COMPILE ERROR.$(tput sgr 0)"
  echo ""
  exit 2
elif [[ ${pmd} != 0 ]]; then
  echo "$(tput setaf 1)... done.$(tput sgr 0)"
  echo "$(tput setaf 1)CANCELLING commit due to PMD ERROR.$(tput sgr 0)"
  echo ""
  exit 3
else
  echo "$(tput setaf 1)... done.$(tput sgr 0)"
  echo "$(tput setaf 1)CANCELLING commit due to TEST ERROR.$(tput sgr 0)"
  echo ""
  exit 4
fi
