@echo off

java -jar JFlex-1.6.0.jar nanolexer.jflex

byacc -J -Jclass=NP NanoMorpho.byaccj

javac NP.java NPVal.java NanoLexer.java