#!/usr/bin/perl
#extract diff chunks for patches files passed as argument
#and log them in a csv format
foreach $file (@ARGV) {
	$file =~ /(xsa\d+)/;
	$xsa=$1;
	open($fd,"<",$file); 
	while(<$fd>){
		chomp;
#record filename diff
		if(/^\+\+\+ b\/(\S+)/) 
			{$filename=$1;next;}
#find chunk and print the first 80 chars
		if(/^@@.*?@@ (.*?)$/)
			{$chunk=substr $filename.':'.$1,0,80;
			print "$chunk;$xsa\n";next}
#skip all other lines
	}
	close $fd;
}
exit 0;

