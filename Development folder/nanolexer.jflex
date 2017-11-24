import java.io.*;

%%

%public
%class NanoLexer
%unicode
%byaccj
%line
%column

%{

public NP yyparser;

public NanoLexer( java.io.Reader r, NP yyparser )
{
	this(r);
	this.yyparser = yyparser;
}


public static String lexeme;

public static void main( String[] args ) throws Exception
{
	NanoLexer lexer = new NanoLexer(new FileReader(args[0]));
	int token = lexer.yylex();
	while( token!=0 )
	{
		System.out.println(""+token+": \'"+lexeme+"\'");
		token = lexer.yylex();
	}
}

public int getLine(){
	return yyline+1;
}

public int getColumn(){
	return yycolumn+1;
}

%}



_DIGIT=[0-9]
_FLOAT={_DIGIT}+\.{_DIGIT}+([eE][+-]?{_DIGIT}+)?
_INT={_DIGIT}+
_STRING=\"([^\"\\]|\\b|\\t|\\n|\\f|\\r|\\\"|\\\'|\\\\|(\\[0-3][0-7][0-7])|\\[0-7][0-7]|\\[0-7])*\"
_CHAR=\'([^\'\\]|\\b|\\t|\\n|\\f|\\r|\\\"|\\\'|\\\\|(\\[0-3][0-7][0-7])|(\\[0-7][0-7])|(\\[0-7]))\'
_DELIM=[(){},;]
_NAME=([:letter:]|{_DIGIT})+
_OPNAME=([\+\-*/!%&=><\:\^\~&|?])+
_COMMENT=((;{3}(.)*)|(\{;{3}(\s|.)*;{3}\}))

%%

{_COMMENT} {

}

{_DELIM} {
	yyparser.yylval = new NPVal(yytext());
	return yycharat(0);
}

{_STRING} | {_FLOAT} | {_CHAR} | {_INT} | null | true | false {
	yyparser.yylval = new NPVal(yytext());
	return NP.LITERAL;
}

"return" {
	yyparser.yylval = new NPVal(yytext());
	return NP.RETURN;
}

"while" {
	yyparser.yylval = new NPVal(yytext());
	return NP.WHILE;
}

{_OPNAME} {
	yyparser.yylval = new NPVal(yytext());
	switch(yytext().charAt(0)){
		case '^':
		case '?':
		case '~':
			return NP.OP1;
		case ':':
			return NP.OP2;
		case '|':
			return NP.OP3;
		case '&':
			return NP.OP4;
		case '!':
		case '=':
			if(yytext().length()==1&&yytext().charAt(0)=='='){return yycharat(0);};
		case '<':
		case '>':
			return NP.OP5;
		case '+':
		case '-':
			return NP.OP6;
		case '*':
		case '/':
		case '%':
			return NP.OP7;
		default:
			throw new Error();
	}
}

"else" {
	yyparser.yylval = new NPVal(yytext());
	return NP.ELSE;
}

"elsif" {
	yyparser.yylval = new NPVal(yytext());
	return NP.ELSIF;
}

"if" {
	yyparser.yylval = new NPVal(yytext());
	return NP.IF;
}

"var" {
	yyparser.yylval = new NPVal(yytext());
	return NP.VAR;
}

{_NAME} {
	yyparser.yylval = new NPVal(yytext());
	return NP.NAME;
}

[ \t\r\n\f] {
}

. {
	yyparser.yylval = new NPVal(yytext());
	return NP.ERROR;
}
