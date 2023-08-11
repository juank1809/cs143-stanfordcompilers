/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

%%

%{

/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();

    private int curr_lineno = 1;
    int get_curr_lineno() {
	return curr_lineno;
    }

    private AbstractSymbol filename;

    void set_filename(String fname) {
	filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
	return filename;
    }
%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  */

    switch(yy_lexical_state) {
    case YYINITIAL:
        
    case STRING:
	/* transition to the initial state and add the error */
       yybegin(YINITIAL)

       return new Symbol(TokenConstants.ERROR, "EOF in string constant");
      
       
        
	/* nothing special to do in the initial state */
	break;
	/* If necessary, add code for other states here, e.g:
	   case COMMENT:
	   ...
	   break;
	*/
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup

%STRING

%%

<YYINITIAL>"=>"			{ /* Sample lexical rule for "=>" arrow.
                                     Further lexical rules should be defined
                                     here, after the last %% separator */
                                  return new Symbol(TokenConstants.DARROW); }

 /* Beginning of a string, yybegin the STRING state */
<YYINITIAL> \"		       	{ /* Sample lexical rule for "=>" arrow.
                                     Further lexical rules should be defined
                                     here, after the last %% separator */
                                  yybegin(STRING)
			  
                                 }

/* When it encounters a character with a backlash, check if is a whitespace, if it is not cut the backslash and leave the character! >).
UPDATE> All checking and logic will be implemented at the end of the string, leave it in blank.
 */
<STRING>\\.	          	{
                                                           
                                }

/* According to the COOL Manual, when one encounters a null character it must be an error!.
 */
<STRING>\0	          	{
  return new Symbol(TokenConstants.ERROR,  "Null character in string!")  
                                }





/* 
 (e.g "This is a valid \
       string")
 */

<STRING>\\\n	          	{
                                                           
                                }

/* 
 (e.g "This is NOT a valid 
       string")
 */
<STRING>\n	          	{
                                  yybegin(YYInitial)
                                  return new Symbol(TokenConstants.ERROR, "Unterminated string constant");
                         
                                }
/*  
  End of the string woohoo!This is a loooong rule, as we skipped all logic implementation in the other STRING states.
This rule must do what we skipped before.
1. Append string to the string table
2. Format strings with backslashes 
3. See if the string is too long and return and error.

 */
<STRING>/"		      	{
                                  yybegin(YYInitial)
				                  String currentString = yytext();

                                  if (input.length() <= 2) {
                                      return "";
                                  } else {
                                       input = input.substring(1, input.length() - 1);
                                  }

                                  while ((position = input.indexOf('\\', position + 1)) != -1) {
                                    if (position < input.length() - 1) {
                                   char character = input.charAt(position + 1);

                                switch (character) {
                                 case 'b':
                                   output =+ "\b"
                                 break;
                                 case 't':
                                   output =+ "\t"
                                break;
                                  case 'n':
                                    output =+ "\n"

                                  break;
                                  case 'f':
                                  output =+ '\f' 
                                
                                   break;
                                   default:
                                   output += character
                                   break;

                                
                }
            }
            if(output.length => 1024){ 
               return new Symbol(TokenConstants.ERROR, "String larger than  1024");
            }

            return new Symbol(TokenConstants.STRING, AbstractTable.idtable.addString(output));
        }

    }
                         
<YYINITIAL> [t][rR][uU][eE]                  { return new Symbol(TokenConstants.BOOL_CONST, new Boolean(true)); }
<YYINITIAL> [f][aA][lL][sS][eE]              { return new Symbol(TokenConstants.BOOL_CONST, new Boolean(false)); }
<YYINITIAL> [cC][aA][sS][eE]                 { return new Symbol(TokenConstants.CASE); }
<YYINITIAL> [cC][lL][aA][sS][sS]             { return new Symbol(TokenConstants.CLASS); }
<YYINITIAL> [eE][lL][sS][eE]                 { return new Symbol(TokenConstants.ELSE); }
<YYINITIAL> [fF][iI]                         { return new Symbol(TokenConstants.FI); }
<YYINITIAL> [iI][fF]                         { return new Symbol(TokenConstants.IF); }
<YYINITIAL> [iI][nN]                         { return new Symbol(TokenConstants.IN); }
<YYINITIAL> [iI][nN][hH][eE][rR][iI][tT][sS] { return new Symbol(TokenConstants.INHERITS); }
<YYINITIAL> [iI][sS][vV][oO][iI][dD]         { return new Symbol(TokenConstants.ISVOID); }
<YYINITIAL> [lL][eE][tT]                     { return new Symbol(TokenConstants.LET); }
<YYINITIAL> [lL][oO][oO][pP]                 { return new Symbol(TokenConstants.LOOP); }
<YYINITIAL> [pP][oO][oO][lL]                 { return new Symbol(TokenConstants.POOL); }
<YYINITIAL> [tT][hH][eE][nN]                 { return new Symbol(TokenConstants.THEN); }
<YYINITIAL> [wW][hH][iI][lL][eE]             { return new Symbol(TokenConstants.WHILE); }
<YYINITIAL> [eE][sS][aA][cC]                 { return new Symbol(TokenConstants.ESAC); }
<YYINITIAL> [nN][eE][wW]                     { return new Symbol(TokenConstants.NEW); }
<YYINITIAL> [oO][fF]                         { return new Symbol(TokenConstants.OF); }
<YYINITIAL> [nN][oO][tT]                     { return new Symbol(TokenConstants.NOT); }                            
   
   
<YYINITIAL>"=>"	  { return new Symbol(TokenConstants.DARROW); }
<YYINITIAL> "*"   { return new Symbol(TokenConstants.MULT);   }
<YYINITIAL> "("   { return new Symbol(TokenConstants.LPAREN); }
<YYINITIAL> ";"   { return new Symbol(TokenConstants.SEMI);   }
<YYINITIAL> "-"   { return new Symbol(TokenConstants.MINUS);  }
<YYINITIAL> ")"   { return new Symbol(TokenConstants.RPAREN); }
<YYINITIAL> "<"   { return new Symbol(TokenConstants.LT);     }
<YYINITIAL> ","   { return new Symbol(TokenConstants.COMMA);  }
<YYINITIAL> "/"   { return new Symbol(TokenConstants.DIV);    }
<YYINITIAL> "+"   { return new Symbol(TokenConstants.PLUS);   }
<YYINITIAL> "<-"  { return new Symbol(TokenConstants.ASSIGN); }
<YYINITIAL> "."   { return new Symbol(TokenConstants.DOT);    }
<YYINITIAL> "<="  { return new Symbol(TokenConstants.LE);     }
<YYINITIAL> "="   { return new Symbol(TokenConstants.EQ);     }
<YYINITIAL> ":"   { return new Symbol(TokenConstants.COLON);  }
<YYINITIAL> "{"   { return new Symbol(TokenConstants.LBRACE); }
<YYINITIAL> "}"   { return new Symbol(TokenConstants.RBRACE); }
<YYINITIAL> "@"   { return new Symbol(TokenConstants.AT);     }
<YYINITIAL> "~"   { return new Symbol(TokenConstants.NEG);    }
<YYINITIAL> "--".* { /* End of Line comment: Do nothing */ }

<YYINITIAL> [ \t\n\r\f\013]+    { /* Get rid of whitespace */ }

<YYINITIAL> [a-z][_a-zA-Z0-9]* { return new Symbol(TokenConstants.OBJECTID, AbstractTable.idtable.addString(yytext())); }
<YYINITIAL> [A-Z][_a-zA-Z0-9]* { return new Symbol(TokenConstants.TYPEID, AbstractTable.idtable.addString(yytext())); }
<YYINITIAL> [0-9]*             { return new Symbol(TokenConstants.INT_CONST, AbstractTable.inttable.addString(yytext())); }
                         
                
.                               { /* This rule should be the very last
                                     in your lexical specification and
                                     will match match everything not
                                     matched by other lexical rules. */
                                  System.err.println("LEXER BUG - UNMATCHED: " + yytext()); }
