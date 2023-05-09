# capitalize types
# warning : will capitalize these words also in comments, some manual fixing may be required
sed -i 's/\bbyte\b/Byte/g' $1
sed -i 's/\bshortint\b/ShortInt/g' $1
sed -i 's/\bsmallint\b/SmallInt/g' $1
sed -i 's/\binteger\b/Integer/g' $1
sed -i 's/\bword\b/Word/g' $1
sed -i 's/\bcardinal\b/Cardinal/g' $1
sed -i 's/\blongint\b/LongInt/g' $1
sed -i 's/\blongword\b/LongWord/g' $1
sed -i 's/\bLongword\b/LongWord/g' $1
sed -i 's/\bqword\b/QWord/g' $1
sed -i 's/\bQword\b/QWord/g' $1
sed -i 's/\bint32\b/Int32/g' $1
sed -i 's/\bint64\b/Int64/g' $1

sed -i 's/\bboolean\b/Boolean/g' $1
sed -i 's/\bboolean16\b/Boolean16/g' $1
sed -i 's/\bboolean32\b/Boolean32/g' $1
sed -i 's/\bboolean64\b/Boolean64/g' $1
sed -i 's/\bbytebool\b/ByteBool/g' $1
sed -i 's/\bBytebool\b/ByteBool/g' $1
sed -i 's/\bwordbool\b/WordBool/g' $1
sed -i 's/\bWordbool\b/WordBool/g' $1
sed -i 's/\blongbool\b/LongBool/g' $1
sed -i 's/\bLongbool\b/LongBool/g' $1
sed -i 's/\bqwordbool\b/QWordBool/g' $1
sed -i 's/\bQwordbool\b/QWordBool/g' $1
sed -i 's/\bQwordBool\b/QWordBool/g' $1
sed -i 's/\bQWordbool\b/QWordBool/g' $1

sed -i 's/\bstring\b/String/g' $1
sed -i 's/\bansistring\b/AnsiString/g' $1
sed -i 's/\bAnsistring\b/AnsiString/g' $1
sed -i 's/\bchar\b/Char/g' $1
sed -i 's/\bansichar\b/AnsiChar/g' $1
sed -i 's/\bAnsichar\b/AnsiChar/g' $1
sed -i 's/\bwidechar\b/WideChar/g' $1
sed -i 's/\bWidechar\b/WideChar/g' $1

#sed -i 's/\breal\b/Real/g' $1 --- too generic word
sed -i 's/\bsingle\b/Single/g' $1
sed -i 's/\bdouble\b/Double/g' $1
sed -i 's/\bcomp\b/Comp/g' $1
sed -i 's/\bcurrency\b/Currency/g' $1

sed -i 's/\bpointer\b/Pointer/g' $1
sed -i 's/\bpbyte\b/PByte/g' $1
sed -i 's/\bPbyte\b/PByte/g' $1
sed -i 's/\bpchar\b/PChar/g' $1
sed -i 's/\bPchar\b/PChar/g' $1

# add a space for some symbols
sed -i 's/:\([a-zA-Z]\)/: \1/g' $1
sed -i 's/:=\([a-zA-Z0-9]\)/:= \1/g' $1
sed -i 's/\([a-zA-Z0-9]\):=/\1 :=/g' $1
sed -i 's/+\([a-zA-Z0-9]\)/+ \1/g' $1
sed -i 's/\([a-zA-Z0-9]\)+/\1 +/g' $1
#sed -i 's/-\([a-zA-Z0-9]\)/- \1/g' $1 --- too often used in other than math context
#sed -i 's/\([a-zA-Z0-9]\)-/\1 -/g' $1
sed -i 's/=\([a-zA-Z0-9]\)/= \1/g' $1
sed -i 's/\([a-zA-Z0-9]\)=/\1 =/g' $1
sed -i 's/>\([a-zA-Z0-9]\)/> \1/g' $1
sed -i 's/\([a-zA-Z0-9]\)>/\1 >/g' $1
sed -i 's/<\([a-zA-Z0-9]\)/< \1/g' $1
sed -i 's/\([a-zA-Z0-9]\)</\1 </g' $1
sed -i 's/<>\([a-zA-Z0-9]\)/<> \1/g' $1
sed -i 's/\([a-zA-Z0-9]\)<>/\1 <>/g' $1
sed -i 's/>=\([a-zA-Z0-9]\)/>= \1/g' $1
sed -i 's/\([a-zA-Z0-9]\)>=/\1 >=/g' $1
sed -i 's/<=\([a-zA-Z0-9]\)/<= \1/g' $1
sed -i 's/\([a-zA-Z0-9]\)<=/\1 <=/g' $1
sed -i 's/if(/if (/g' $1
sed -i 's/)then/) then/g' $1
sed -i 's/and(/and (/g' $1
sed -i 's/)and/) and/g' $1
sed -i 's/or(/or (/g' $1
sed -i 's/)or/) or/g' $1
sed -i 's/not(/not (/g' $1

# some other common keywords that need to be capitalized
sed -i 's/\bexit\b/Exit/g' $1
sed -i 's/\bresult\b/Result/g' $1
sed -i 's/\blength\b/Length/g' $1
sed -i 's/\bvalue\b/Value/g' $1
sed -i 's/\bpos\b/Pos/g' $1
sed -i 's/\bfreeandnil\b/FreeAndNil/g' $1
sed -i 's/\bFreeandnil\b/FreeAndNil/g' $1

sed -i 's/\bi\b/I/g' $1
sed -i 's/\bj\b/J/g' $1
sed -i 's/\bk\b/K/g' $1
sed -i 's/\bn\b/N/g' $1
sed -i 's/\bs\b/S/g' $1
sed -i 's/\bc\b/C/g' $1
sed -i 's/\bp\b/P/g' $1
sed -i 's/\blen\b/Len/g' $1
sed -i 's/\bargs\b/Args/g' $1
sed -i 's/\bindex\b/Index/g' $1

sed -i 's/\bwriteln\b/WriteLn/g' $1
sed -i 's/\bWriteln\b/WriteLn/g' $1
sed -i 's/\bwritelnlog\b/WriteLnLog/g' $1
sed -i 's/\bWritelnlog\b/WriteLnLog/g' $1
sed -i 's/\bWritelnLog\b/WriteLnLog/g' $1

# some other common keywords that need to be decapitalized
sed -i 's/\bTrue\b/true/g' $1
sed -i 's/\bFalse\b/false/g' $1

# insert linebreaks in common situations, keeping indentation
sed -i 's/^\([[:blank:]]*\)end else begin/\1end else\n\1begin/g' $1
sed -i 's/^\([[:blank:]]*\)else begin/\1else\n\1begin/g' $1
# and I've failed to make regexes for the ones below in case **** <> '' - either they don't work at all, or can't keep indentation
#sed 's/^\([[:blank:]]*\)\([a-zA-Z0-9[:space:]]*\)then begin/\1then\n\1begin/g' $1 ----- unfortuantely doesn't work
#sed 's/\([[:blank:]]*\)then begin/\1then\n\1begin/g' $1 ----- works, but doesn't keep indentation, obviously
#****do try
#****do begin
#****then Exit
#finally FreeAndNil(****) end;
#finally ****.Free end;
#****else
