%%

%unicode 6.2
%public
%class UnicodeDerivedCoreProperties_Changes_When_Casemapped_6_2

%type int
%standalone

%include ../../resources/common-unicode-all-binary-property-java

%%

\p{Changes_When_Casemapped} { setCurCharPropertyValue(); }
[^] { }

<<EOF>> { printOutput(); return 1; }
