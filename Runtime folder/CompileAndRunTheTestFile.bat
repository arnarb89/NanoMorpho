@echo off

java NP test.txt > test.masm
java -jar morpho.jar -c test.masm
java -jar morpho.jar test

pause >nul