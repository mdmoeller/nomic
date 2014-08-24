#!/usr/bin/perl
# Standard header stuff
use strict;
use CGI qw( :standard );
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

print header();
print start_html();

#open log.txt for appending new log data
open (FILE,"scores.txt") or print h1("Error");

#open immutable.txt for appending/reading
open (FIM,"immutable.txt") or print h1("Error");

#open mutable.txt for appending/reading
open (FM,"mutable.txt") or print h1("Error");

#open proposals.txt for appending/reading
open (FP,"proposals.txt") or print h1("Error");

#takes array as input, provides array size
#sub arrayLength {
#	my $size = @_;
#	return $size;
#}

my $query=new CGI;

# Get inputs
my $pssd     = param("pass");
my $playr     = param("player");

#set up variables
my $num;
my $rule;
my $rulios;
my $props;
my @rulios = ();
my @props = ();

sub makeT {
    chomp;
    if($_ eq ""){}
    else {
	($num, $rule) = split('\t', $_);
	push(@rulios, $num);
	$rule =~ s/\*\*/\n/g;
	print "\n\t<tr><td>$num)</td> <td>$rule</td> </tr>";
    }
}

#ensure user entered a user name.
if ( $playr eq "") {
    print p("Name field is empty. Please use back button and ensure your name is entered.");
}
#ensure password match.
# elsif( $pssd ne "password") {
# print $query->redirect('index.html');
# }
else {
	# Print to LOG: user name
	# print FILE "$playr" . "\n";
	
	#Print to screen: NOMIC.html
	print h3("Nomic");
	print "<div id=\"players\">\n";

	print h1("Players");
	print "<table>\n\t<tr> <th>Player</th> <th>Score</th> </tr>";
#PRINT Players and Scores
	while(<FILE>) {
	    makeT( $_ );
	}
	print "</table>\n</div>\n\n";

	print h1('Immutable Rules');
#PRINT Immutable Rules
	print "<table>";
	while (<FIM>) {
	    makeT( $_ );
		#chomp;
	        #($num, $rule) = split('\t', $_);
		#push(@rulios, $num);
		#$rule =~ s/\*\*/\n/g;
		#print "\n\t<tr><td>$num)</td> <td>$rule</td> </tr>";
	}
	print "</table>\n\n";

	print h1('Mutable Rules');
#PRINT Mutable Rules
	print "<table>";
	while (<FM>) {
	    makeT( $_ );
	}
	print "</table>\n\n";

	print h1('Proposal(s)');
#PRINT Proposals
	print "<table>";
	while (<FP>) {
	    makeT( $_ );
	}
	print "</table>\n\n<div id=\"changes\"><br><hr><br>\n";

	print h1("Propose a Rule Change");
#PRINT form tag
	print "<form  method=\"POST\" action=\"\" id=\"change\">";
	print "<input type=\"radio\" name=\"type\" value=\"add\"> Add <br>\n";
	print "<input type=\"radio\" name=\"type\" value=\"amend\"> Amend <br>\n";
	print "<input type=\"radio\" name=\"type\" value=\"repeal\"> Repeal <br>\n";
	print "<input type=\"radio\" name=\"type\" value=\"transmute\"> Transmute <br><br>\n";
#PRINT Rule Dropdown List
	print "<select name=\"rule\">";
	print "\n\t<option value=\"0\">NA</option>";
	foreach $rulios(@rulios) {
		print "\n\t<option value=\"$rulios\">$rulios</option>";
	}
	print "</select> <br><br>";
	print "Rule Change \(if applicable\): <input type=\"text\" name=\"prop\" size=\"60\">\n";
	print p("<input type=\"submit\" value=\"Submit\">");
	print "<br></form> <br><br><hr><br>";

	print h1("Vote");
#PRINT form tag
	print "<form  method=\"POST\" action=\"\" id=\"vote\">";
	print "Proposal:<br>\n";
#PRINT Proposal Dropdown List
	print "<select name=\"prop\">";
	print "\n\t<option value=\"0\">NA</option>";
	foreach $props(@props) {
		print "\n\t<option value=\"$props\">$props</option>";
	}
	print "</select> <br><br>";
	print "<input type=\"radio\" name=\"type\" value=\"yea\">Yea<br>\n";
	print "<input type=\"radio\" name=\"type\" value=\"nay\">Nay<br>\n";
	print p("<input type=\"submit\" value=\"Submit\">");
	print "<br></form><br><br><hr>\n";

	print h1("Change Score");
#PRINT form tag
	print "<form  method=\"POST\" action=\"\" id=\"newScore\">";
	print "New Score: <input type=\"text\" name=\"score\">\n";
	print p("<input type=\"submit\" value=\"Submit\">");
	print "<br></form><br><br><hr><br>\n\n";

	
	#list of all events selected for RSVP
	#print "<ul>";
	#foreach (@checks) {
		#if event select is other, provide the data from the "other" textbox
		#if( $_ eq "Other" ) {
		#	print li($otherEvent);
		#	print FILE "$otherEvent" . "\t";
		#}
		#otherwise, enjoy your southern food
		#else {
		#	print li($_);
		#	print FILE "$_" . "\t";
		#}
	#}
	#print "</ul>";
	

}

#Close files for appending.
close(FILE);
close(FIM);
close(FM);
close(FP);

# Print XHTML footer
print ( end_html() );





