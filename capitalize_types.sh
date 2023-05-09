# capitalize types
# warning : will capitalize these words also in comments, some manual fixing may be required
# note: \b means "word border" i.e. `\bbyte\b will find only full word "byte" (case-sensitive) and not bytesequence
# \([a-zA-Z0-9]\) means any symbol of the proposed - it'll be available in "replacement" as \1, \2, \3 etc
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
#sed -i 's/\^:=\([a-zA-Z0-9]\)/\^:= \1/g' $1 ---- doesn't work for some reason
sed -i 's/+\([a-zA-Z0-9]\)/+ \1/g' $1
sed -i 's/\([a-zA-Z0-9]\)+/\1 +/g' $1
#sed -i "s/\'+/\' +/g" $1 # ---- for string operations, unfortuantely doesn't work
#sed -i "s/+\'/+ \'/g" $1
sed -i 's/)+/) +/g' $1
sed -i 's/+(/+ (/g' $1
#sed -i 's/-\([a-zA-Z0-9]\)/- \1/g' $1 --- too often used in other than math context
#sed -i 's/\([a-zA-Z0-9]\)-/\1 -/g' $1
sed -i 's/\([a-zA-Z]\)-\([1-9]\)/\1 - \2/g' $1 #so, some potentially often occurring case like Count-1
sed -i 's/)-\([a-zA-Z0-9]\)/) -\1/g' $1
sed -i 's/\([a-zA-Z0-9]\)-(/\1- (/g' $1
sed -i 's/)-/) -/g' $1
sed -i 's/-(/- (/g' $1
#sed -i 's/\/\([a-zA-Z0-9]\)/\/ \1/g' $1 --- too often used in other than math context
#sed -i 's/\([a-zA-Z0-9]\)\//\1 \//g' $1
sed -i 's/\*\([a-zA-Z0-9]\)/\* \1/g' $1
sed -i 's/\([a-zA-Z0-9]\)\*/\1 \*/g' $1
sed -i 's/)\*/) \*/g' $1
sed -i 's/\*(/\* (/g' $1
sed -i 's/=\([a-zA-Z0-9]\)/= \1/g' $1
sed -i 's/\([a-zA-Z0-9]\)=/\1 =/g' $1
sed -i 's/)=/) =/g' $1
sed -i 's/=(/= (/g' $1
sed -i 's/>\([a-zA-Z0-9]\)/> \1/g' $1 # WARNING: These mess up generics specialization, but it's an easy revert
sed -i 's/\([a-zA-Z0-9]\)>/\1 >/g' $1
sed -i 's/)>/) >/g' $1
sed -i 's/>(/> (/g' $1
sed -i 's/<\([a-zA-Z0-9]\)/< \1/g' $1
sed -i 's/\([a-zA-Z0-9]\)</\1 </g' $1
sed -i 's/)</) </g' $1
sed -i 's/<(/< (/g' $1
#sed -i 's/<>\([a-zA-Z0-9]\)/<> \1/g' $1 ---- should already be fixed in previous two
#sed -i 's/\([a-zA-Z0-9]\)<>/\1 <>/g' $1
#sed -i 's/)<>/) <>/g' $1
#sed -i 's/<>(/<> (/g' $1
sed -i 's/>=\([a-zA-Z0-9]\)/>= \1/g' $1
sed -i 's/\([a-zA-Z0-9]\)>=/\1 >=/g' $1
sed -i 's/)>=/) >=/g' $1
sed -i 's/>=(/>= (/g' $1
sed -i 's/<=\([a-zA-Z0-9]\)/<= \1/g' $1
sed -i 's/\([a-zA-Z0-9]\)<=/\1 <=/g' $1
sed -i 's/)<=/) <=/g' $1
sed -i 's/<=(/<= (/g' $1

sed -i 's/\bif(/if (/g' $1
sed -i 's/)then\b/) then/g' $1
sed -i 's/\band(/and (/g' $1
sed -i 's/)and\b/) and/g' $1
sed -i 's/\bor(/or (/g' $1
sed -i 's/)or\b/) or/g' $1
sed -i 's/\bnot(/not (/g' $1
sed -i 's/\bto(/to (/g' $1
sed -i 's/)to\b/) to/g' $1
sed -i 's/\bdownto(/downto (/g' $1
sed -i 's/)downto\b/) downto/g' $1



# some other common keywords that need to be capitalized
sed -i 's/\bexit\b/Exit/g' $1
sed -i 's/\bresult\b/Result/g' $1
sed -i 's/\blength\b/Length/g' $1
sed -i 's/\bvalue\b/Value/g' $1
sed -i 's/\bpos\b/Pos/g' $1
sed -i 's/\bfreeandnil\b/FreeAndNil/g' $1
sed -i 's/\bFreeandnil\b/FreeAndNil/g' $1
#sed -i 's/\binc\b/Inc/g' $1 ---- unfortunately messes up include files
sed -i 's/\bin(c\b/Inc(/g' $1
sed -i 's/\bdec\b/Dec/g' $1
sed -i 's/\brandom\b/Random/g' $1
sed -i 's/\bmaxint\b/MaxInt/g' $1
sed -i 's/\bMaxint\b/MaxInt/g' $1
sed -i 's/\bdestroy\b/Destroy/g' $1
sed -i 's/\bcreate\b/Create/g' $1

sed -i 's/\bi\b/I/g' $1
sed -i 's/\bj\b/J/g' $1
sed -i 's/\bk\b/K/g' $1
sed -i 's/\bn\b/N/g' $1
sed -i 's/\bs\b/S/g' $1 # WARNING: unfortunately messes with text like it's but it's an easy revert and "S" as avariable name is used too often to miss this opportunity
sed -i 's/\bb\b/B/g' $1
sed -i 's/\bc\b/C/g' $1
sed -i 's/\bp\b/P/g' $1
sed -i 's/\bw\b/W/g' $1
sed -i 's/\bh\b/H/g' $1
sed -i 's/\blen\b/Len/g' $1
sed -i 's/\bargs\b/Args/g' $1
sed -i 's/\bindex\b/Index/g' $1

sed -i 's/\bwriteln\b/WriteLn/g' $1
sed -i 's/\bWriteln\b/WriteLn/g' $1
sed -i 's/\bwritelnlog\b/WriteLnLog/g' $1
sed -i 's/\bWritelnlog\b/WriteLnLog/g' $1
sed -i 's/\bWritelnLog\b/WriteLnLog/g' $1
sed -i 's/\bwritelnwarning\b/WritelnWarning/g' $1
sed -i 's/\bWritelnwarning\b/WritelnWarning/g' $1
sed -i 's/\bWritelnWarning\b/WritelnWarning/g' $1
sed -i 's/\bWritelnLogMultiline\b/WriteLnLogMultiline/g' $1



# things that maybe rare, but still might be useful + as names are unique enough, should not cause any harm
sed -i 's/\bminLength\b/MinLength/g' $1
sed -i 's/\brpart\b/RightPart/g' $1
sed -i 's/\bpatterns\b/Patterns/g' $1
sed -i 's/\bvalues\b/Values/g' $1
sed -i 's/\bchars\b/Chars/g' $1
sed -i 's/\bnowcol\b/NowCol/g' $1
sed -i 's/\bbrk\b/Brk/g' $1
sed -i 's/\blnow\b/LNow/g' $1
sed -i 's/\breali\b/RealI/g' $1
sed -i 's/\brealI\b/RealI/g' $1
sed -i 's/\bwordBorders\b/WordBorders/g' $1
sed -i 's/\bdataposstart\b/DataPosStart/g' $1
sed -i 's/\bdatapos\b/DataPos/g' $1
sed -i 's/\bformpos\b/FormPos/g' $1
sed -i 's/\bformposstart\b/FormPosStart/g' $1
sed -i 's/\bfilemask\b/FileMask/g' $1
sed -i 's/\bcyfra\b/Number/g' $1
sed -i 's/\bdigit\b/Digit/g' $1
sed -i 's/\bbuf\b/Buf/g' $1
sed -i 's/\bgzfile\b/GzFile/g' $1
sed -i 's/\bcheck_header\b/CheckHeader/g' $1
sed -i 's/\bstream\b/Stream/g' $1
sed -i 's/\bstrategy\b/Strategy/g' $1
sed -i 's/\blevel\b/Level/g' $1
sed -i 's/\bn1\b/N1/g' $1
sed -i 's/\bn2\b/N2/g' $1
sed -i 's/\bget_byte\b/GetByte/g' $1
sed -i 's/\bdeflateEnd\b/DeflateEnd/g' $1
sed -i 's/\binflateEnd\b/InflateEnd/g' $1
sed -i 's/\bwritten\b/Written/g' $1
sed -i 's/\bputLong\b/PutLong/g' $1
sed -i 's/\bkey\b/Key/g' $1
sed -i 's/\bminWidth\b/MinWidth/g' $1
sed -i 's/\bminHeight\b/MinHeight/g' $1
sed -i 's/\bmaxWidth\b/MaxWidth/g' $1
sed -i 's/\bmaxHeight\b/MaxHeight/g' $1
sed -i 's/\bright\b/Right/g' $1
sed -i 's/\bleft\b/Left/g' $1
sed -i 's/\bbottom\b/Bottom/g' $1
sed -i 's/\btop\b/Top/g' $1

# some other common keywords that need to be decapitalized
sed -i 's/\bTrue\b/true/g' $1
sed -i 's/\bFalse\b/false/g' $1



# insert linebreaks in common situations, keeping indentation
# note ^\([[:blank:]]*\) means "all whitespace or tabs from the beginning of the line" - available in replacement as \1
sed -i 's/^\([[:blank:]]*\)end else begin/\1end else\n\1begin/g' $1
sed -i 's/^\([[:blank:]]*\)else begin/\1else\n\1begin/g' $1
sed -i 's/^\([[:blank:]]*\)else Exit/\1else\n\1  Exit/g' $1
sed -i 's/^\([[:blank:]]*\)else raise/\1else\n\1  raise/g' $1
# and I've failed to make regexes for the ones below in case **** <> '' - either they don't work at all, or can't keep indentation
#sed 's/^\([[:blank:]]*\)\([a-zA-Z0-9[:space:]]*\)then begin/\1then\n\1begin/g' $1 ----- unfortuantely doesn't work
#sed 's/\([[:blank:]]*\)then begin/\1then\n\1begin/g' $1 ----- works, but doesn't keep indentation, obviously
#**** do try
#**** do begin
#**** then ****
#finally FreeAndNil(****) end;
#finally ****.Free end;
#**** else
#*** raise end;
#*** end
