#!/usr/bin/perl
#
############################################################################
#
#          Name: gmailpop.pl
#        Author: Pete Prodoehl
#       
#        Script Tailored to Interface with Gnokii by 
#                                   Boris aka Sathya Prakash.K     
#  Author-Email: admin@ilankadhir.com
#
#
############################################################################

# required modules

use Mail::POP3Client;
use IO::Socket::SSL;


# fill in your details here

$username  = 'youremail@gmail.com'; # edit this
$password  = 'yourpassword';        # edit this

$mailhost  = 'pop.gmail.com';
$port      = '995';


$pop = new Mail::POP3Client(	USER     => $username,
                               	PASSWORD => $password,
				HOST     => $mailhost,
				PORT	 => $port,
				USESSL   => 'true',
				DEBUG	 => 0,
                             );

$ncnt = $pop->Count;

$file = '/home/USERNAME/scripts/count';
open(oldcnt, $file);
$ocount = <oldcnt>;
close(oldcnt);

if($ocount == $pop->Count)
{
   exit;
}
else
{

open(oldcnt, ">/home/USERNAME/scripts/count");
print oldcnt "$ncnt";
close(oldcnt);

# if no msgs just exit

if (($pop->Count()) < 1) {
	print "No messages...\n";
	exit;
}



# if msgs, tell how many

print $pop->Count() . " messages found!\n";



# loop over msgs

for($i = $ocount; $i <= $pop->Count(); $i++) {
	
	#print $pop->Head($i) . "\n";
	#print $pop->Body($i) . "\n";
         foreach ($pop->Head($i)) {
  			$from = qq("$_\n") if /^(From):/i;
                        $subj = qq("$_\n") if /^(Subject):/i;  
                  
                    }
 if (($from =~ /searchstring_2_goeshere/i) || ($subj =~ /searchstring_1_goeshere/i))
        {
         $cmd = "echo Mail from $from regarding $subj  | gnokii --sendsms phonenumbergoeshere";
         system $cmd;


        print "\n";
 }      
   else
     {
          print  "No message from specified person :-( \n";
}
}


# close connection

$pop->Close();
}
exit;


