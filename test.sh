#!/bin/bash
try() {
  expected="$1"
  input="$2"

  ./1cc "$input" > tmp.s
  gcc -o tmp tmp.s tmp-foo.o tmp-plus.o
  ./tmp
  actual="$?"

  if [ "$actual" = "$expected" ]; then
    echo "$input => $actual"
  else
    echo "$expected expected, but got $actual"
    exit 1
  fi
}

echo 'int foo() { }' | gcc -xc -c -o tmp-foo.o -
echo 'int plus(int x, int y) { return x + y; }' | gcc -xc -c -o tmp-plus.o -

try 0 "0;"
try 42 "42;"
try 21 '5+20-4;'
try 41 ' 12 + 34 - 5;'
try 47 '5+6*7;'
try 4 "8/2;"
try 15 "5 * (9-6);"
try 2 "3 - 2 + 1;"
try 10 "-10 + 20;"
try 1 "2 == 2;"
try 0 "1 == 2;"
try 1 "1 != 2;"
try 1 "1 < 2;"
try 0 "1 < 1;"
try 1 "1 <= 2;"
try 1 "2 <= 2;"
try 0 "2 <= 1;"
try 1 "3 > 2;"
try 0 "2 > 2;"
try 1 "3 >= 2;"
try 1 "3 >= 3;"
try 0 "3 >= 4;"
try 3 "a=3; 3;"
try 14 "a = 3; b = 5*6 - 8; a + b / 2;"
try 6 "foo = 1; bar = 2+3; foo + bar;"
try 3 "foo = 1; fuga = 2; foo + fuga;"
try 3 "return 3;"
try 2 "if (1) return 2; return 3;"
try 3 "if (0) return 2; return 3;"
try 2 "if (1) return 2; else 3;"
try 3 "if (0) return 2; else 3;"
try 2 "while (1) return 2; return 3;"
try 3 "while (0) return 2; return 3;"
try 45 "j=0; for(i=0;i<10;i=i+1) j = j+i; return j;"
try 45 "j=0; for(i=0;i<10;i=i+1) {j = j+i;} return j;"
try 0 "foo(); return 0;"
try 5 "return plus(2, 3);"

echo OK
