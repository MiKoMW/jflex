%%

%unicode 8.0
%public
%class UnicodeAge_8_0_age_6_2

%type int
%standalone

%include ../../resources/common-unicode-all-enumerated-property-defined-values-only-java

%%

<<EOF>> { printOutput(); return 1; }
\p{Age:6.2} { setCurCharPropertyValue("Age:6.2"); }
[^] { }
