#!/usr/bin/perl
# ftp uploader script for ipcop
# Copyright Paul Zwierzynski 11-30-2015

# this script will look for .csv files not marked as executable
# upload them to an ftp server
# and mark them executable when finished to keep track 
# it assumes all files found are text files


### below are the parameters you need to set ###

# your login username and password
# use a backslash before any @ signs like: user\@powermon.org
my $username = "#USERNAME#\@powermon.org";
my $password = "#PASSWORD#";

# These shouldn't need to be changed
# the ftp server name
my $ftpsite = "ftp.powermon.org";

# folder on the ftp server to put files in
my $folder = "/";

# look for and upload files from this directory on ipcop
my $directory = "~/power";

### end of variable definition  ###



use Net::FTP;
my $errormsg = '';



my $ftp = Net::FTP->new("$ftpsite", Debug => 1);
my $success = $ftp->login("$username", "$password");
if ($success != 1)
    {
    $errormsg = "FTP login failed";
    print $errormsg . "\n";

    exit;
    }
  


my $success = $ftp->cwd("$folder");
if ($success != 1)
    {
    print "Attempting to create $folder folder on ftp server.\n";

    my $create =  $ftp->CreateRemoteDir("$folder");
    if ($create != 1)
        {
        $errormsg = "Failed to create folder $folder on FTP server";
        print $errormsg . "\n";

        exit;
        }
    } else {
    my $success = $ftp->cwd("$folder");
    if ($success != 1)
        {
        $errormsg = "Could not CD into $folder on FTP server";
        print $errormsg . "\n";

        exit;
        }
    }

# set ascii mode for text files
$ftp->ascii();

my $count = 0;
opendir(DIR, "$directory");
my @files = readdir(DIR);
chdir("$directory");

foreach my $file (@files)
    {
    print "found $file\n";
    # only upload regular files with .csv in the name
    if (-f $file && ($file =~ /\.csv/))
        {
        # only upload files NOT marked as executable
        if (not -x $file)
            {
            # if file has changed since midnight today, it is in use, don't upload it 
            if ((localtime((stat _)[9]))[3] != (localtime)[3] )
                {
                # upload the file
                $count++;
                print "attempting upload of $file";
                $ftp->put("$file")
                   or die "Could not put the file on the server ", $ftp->message;

                #Mark file as executable so it won't be uploaded again next time
                chmod(0755, "$directory\/$file");
                } else {
                print "skipping upload of $file  It looks like it was modified today.\n";
                }
            }
        }
    }
$ftp->quit();

if ($count)
    {
    print "$count files uploaded to ftp server.\n";

    } else {
    print "No files waiting to be uploaded to ftp server.\n";

    }


