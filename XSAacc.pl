#!/usr/bin/perl
# input: csv,  map of files to xsa
# output: csv count of file changes and xsa ids
my %freq,%xsa;
while(<>){
	chomp;
	my ($file,$xsa) = split(/,/);
	$freq{$file} += 1;
	if($freq{$file} > 1){$xsa{$file} .= ',';}
	$xsa{$file} .= $xsa;
}
my @output;
map{push @output,"$freq{$_},$_,$xsa{$_}\n"}keys %freq;
print sort {$b <=> $a} (@output);
exit 0;
