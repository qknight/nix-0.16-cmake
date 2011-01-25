/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison GLR parsers in C

   Copyright (C) 2002, 2003, 2004, 2005, 2006 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ID = 258,
     ATTRPATH = 259,
     STR = 260,
     IND_STR = 261,
     INT = 262,
     PATH = 263,
     URI = 264,
     IF = 265,
     THEN = 266,
     ELSE = 267,
     ASSERT = 268,
     WITH = 269,
     LET = 270,
     IN = 271,
     REC = 272,
     INHERIT = 273,
     EQ = 274,
     NEQ = 275,
     AND = 276,
     OR = 277,
     IMPL = 278,
     DOLLAR_CURLY = 279,
     IND_STRING_OPEN = 280,
     IND_STRING_CLOSE = 281,
     ELLIPSIS = 282,
     UPDATE = 283,
     NEG = 284,
     CONCAT = 285
   };
#endif


/* Copy the first part of user declarations.  */
#line 12 "./parser.y"

/* Newer versions of Bison copy the declarations below to
   parser-tab.hh, which sucks bigtime since lexer.l doesn't want that
   stuff.  So allow it to be excluded. */
#ifndef BISON_HEADER_HACK
#define BISON_HEADER_HACK
    
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "util.hh"
    
#include "nixexpr.hh"

#include "parser-tab.hh"
#include "lexer-tab.hh"
#define YYSTYPE YYSTYPE // workaround a bug in Bison 2.4


using namespace nix;


namespace nix {

    
struct ParseData 
{
    SymbolTable & symbols;
    Expr * result;
    Path basePath;
    Path path;
    string error;
    Symbol sLetBody;
    ParseData(SymbolTable & symbols)
        : symbols(symbols)
        , sLetBody(symbols.create("<let-body>"))
    { };
};


static string showAttrPath(const vector<Symbol> & attrPath)
{
    string s;
    foreach (vector<Symbol>::const_iterator, i, attrPath) {
        if (!s.empty()) s += '.';
        s += *i;
    }
    return s;
}


static void dupAttr(const vector<Symbol> & attrPath, const Pos & pos, const Pos & prevPos)
{
    throw ParseError(format("attribute `%1%' at %2% already defined at %3%")
        % showAttrPath(attrPath) % pos % prevPos);
}
 

static void dupAttr(Symbol attr, const Pos & pos, const Pos & prevPos)
{
    vector<Symbol> attrPath; attrPath.push_back(attr);
    throw ParseError(format("attribute `%1%' at %2% already defined at %3%")
        % showAttrPath(attrPath) % pos % prevPos);
}
 

static void addAttr(ExprAttrs * attrs, const vector<Symbol> & attrPath,
    Expr * e, const Pos & pos)
{
    unsigned int n = 0;
    foreach (vector<Symbol>::const_iterator, i, attrPath) {
        n++;
        ExprAttrs::Attrs::iterator j = attrs->attrs.find(*i);
        if (j != attrs->attrs.end()) {
            ExprAttrs * attrs2 = dynamic_cast<ExprAttrs *>(j->second.first);
            if (!attrs2 || n == attrPath.size()) dupAttr(attrPath, pos, j->second.second);
            attrs = attrs2;
        } else {
            if (attrs->attrNames.find(*i) != attrs->attrNames.end())
                dupAttr(attrPath, pos, attrs->attrNames[*i]);
            attrs->attrNames[*i] = pos;
            if (n == attrPath.size())
                attrs->attrs[*i] = ExprAttrs::Attr(e, pos);
            else {
                ExprAttrs * nested = new ExprAttrs;
                attrs->attrs[*i] = ExprAttrs::Attr(nested, pos);
                attrs = nested;
            }
        }
    }
}


static void addFormal(const Pos & pos, Formals * formals, const Formal & formal)
{
    if (formals->argNames.find(formal.name) != formals->argNames.end())
        throw ParseError(format("duplicate formal function argument `%1%' at %2%")
            % formal.name % pos);
    formals->formals.push_front(formal);
    formals->argNames.insert(formal.name);
}


static Expr * stripIndentation(vector<Expr *> & es)
{
    if (es.empty()) return new ExprString("");
    
    /* Figure out the minimum indentation.  Note that by design
       whitespace-only final lines are not taken into account.  (So
       the " " in "\n ''" is ignored, but the " " in "\n foo''" is.) */
    bool atStartOfLine = true; /* = seen only whitespace in the current line */
    unsigned int minIndent = 1000000;
    unsigned int curIndent = 0;
    foreach (vector<Expr *>::iterator, i, es) {
        ExprIndStr * e = dynamic_cast<ExprIndStr *>(*i);
        if (!e) {
            /* Anti-quotations end the current start-of-line whitespace. */
            if (atStartOfLine) {
                atStartOfLine = false;
                if (curIndent < minIndent) minIndent = curIndent;
            }
            continue;
        }
        for (unsigned int j = 0; j < e->s.size(); ++j) {
            if (atStartOfLine) {
                if (e->s[j] == ' ')
                    curIndent++;
                else if (e->s[j] == '\n') {
                    /* Empty line, doesn't influence minimum
                       indentation. */
                    curIndent = 0;
                } else {
                    atStartOfLine = false;
                    if (curIndent < minIndent) minIndent = curIndent;
                }
            } else if (e->s[j] == '\n') {
                atStartOfLine = true;
                curIndent = 0;
            }
        }
    }

    /* Strip spaces from each line. */
    vector<Expr *> * es2 = new vector<Expr *>;
    atStartOfLine = true;
    unsigned int curDropped = 0;
    unsigned int n = es.size();
    for (vector<Expr *>::iterator i = es.begin(); i != es.end(); ++i, --n) {
        ExprIndStr * e = dynamic_cast<ExprIndStr *>(*i);
        if (!e) {
            atStartOfLine = false;
            curDropped = 0;
            es2->push_back(*i);
            continue;
        }
        
        string s2;
        for (unsigned int j = 0; j < e->s.size(); ++j) {
            if (atStartOfLine) {
                if (e->s[j] == ' ') {
                    if (curDropped++ >= minIndent)
                        s2 += e->s[j];
                }
                else if (e->s[j] == '\n') {
                    curDropped = 0;
                    s2 += e->s[j];
                } else {
                    atStartOfLine = false;
                    curDropped = 0;
                    s2 += e->s[j];
                }
            } else {
                s2 += e->s[j];
                if (e->s[j] == '\n') atStartOfLine = true;
            }
        }

        /* Remove the last line if it is empty and consists only of
           spaces. */
        if (n == 1) {
            string::size_type p = s2.find_last_of('\n');
            if (p != string::npos && s2.find_first_not_of(' ', p + 1) == string::npos)
                s2 = string(s2, 0, p + 1);
        }

        es2->push_back(new ExprString(s2));
    }

    return new ExprConcatStrings(es2);
}


void backToString(yyscan_t scanner);
void backToIndString(yyscan_t scanner);


static Pos makeCurPos(const YYLTYPE & loc, ParseData * data)
{
    return Pos(data->path, loc.first_line, loc.first_column);
}

#define CUR_POS makeCurPos(*yylocp, data)


}


void yyerror(YYLTYPE * loc, yyscan_t scanner, ParseData * data, const char * error)
{
    data->error = (format("%1%, at %2%")
        % error % makeCurPos(*loc, data)).str();
}


#endif




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE 
#line 232 "./parser.y"
{
  nix::Expr * e;
  nix::ExprList * list;
  nix::ExprAttrs * attrs;
  nix::Formals * formals;
  nix::Formal * formal;
  int n;
  char * id; // !!! -> Symbol
  char * path;
  char * uri;
  std::vector<nix::Symbol> * ids;
  std::vector<nix::Expr *> * string_parts;
}
/* Line 2604 of glr.c.  */
#line 313 "parser-tab.hh"
	YYSTYPE;
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE
{

  int first_line;
  int first_column;
  int last_line;
  int last_column;

} YYLTYPE;
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;




