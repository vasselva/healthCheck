#!/usr/bin/perl

use strict;
use MIME::Entity;
use MIME::Lite;
use Net::SMTP;

# from is your email address
# to is who you are sending your email to
# subject will be the subject line of your email
my $status   = $ARGV[0];
my $from = 'yourmailid';
my $to = 'yourmailid';
my @arr = qw(yourmailid);
my $users = undef;
$users = join ', ', @arr;
print $users;
my $subject = 'HEALTH CHECK REPORT - '. $status;
my $html;
my $filename = "test-html-report.html";
open(my $fh, '<', $filename) or die "cannot open file $filename";
    {
        local $/;
        $html = <$fh>;
    }
    close($fh);

#print $html;

# Create the MIME message that will be sent. Check out MIME::Entity on CPAN for more details
my $mime = MIME::Entity->build(Type  => 'multipart/alternative',
                            Encoding => '-SUGGEST',
                            From => $from,
                            To => $users,
#                            cc => $users,
                            Subject => $subject
                            );
# Create the body of the message (a plain-text and an HTML version).
# text is your plain-text email
# html is your html version of the email
# if the reciever is able to view html emails then only the html
# email will be displayed
my $text = "Hi!\nHow are you?\n";

# attach the body of the email
$mime->attach(Type => 'text/plain',
            Encoding =>'-SUGGEST',
            Data => $text);

$mime->attach(Type => 'text/html',
            Encoding =>'-SUGGEST',
            Data => $html);

# attach a file
my $my_file_txt = 'example.txt';

# Login credentials
my $username = 'yourlogin@sendgrid.net';
my $password = "yourpassword";

# Open a connection to the SendGrid mail server
my $smtp = Net::SMTP->new('smtp address',
                        Port=> 25,
                        Timeout => 20,
                        Hello => "domain address");

# Authenticate
#$smtp->auth($username, $password);

# Send the rest of the SMTP stuff to the server
$smtp->mail($from);
$smtp->to($to);
#$smtp->to(@add);
$smtp->data($mime->stringify);
$smtp->quit();
