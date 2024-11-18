#!/bin/bash
# (cd PRO1D/src/app; javac *.java;) 
# (cd PRO1D/src/; java -classpath ../lib/postgresql-42.7.4.jar:. App.java;)
(cd PRO1D/src/; python3 ml.py;)
echo Press any key to exit
read -n 1 -s
exit 0