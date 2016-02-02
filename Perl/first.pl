use strict;
use warnings;

use File::stat;
use Time::localtime;
use Time::Piece;
use DateTime;

use POSIX qw(strftime);

use YAML::XS 'LoadFile';
use Data::Dumper;
my $appConfigFile = "C:\\ESSBASE\\Gen5\\Config.yaml";
my $config = LoadFile($appConfigFile);
#print Dumper($config);


#time variables
my %month; @month{qw/jan feb mar apr may jun
                     jul aug sep oct nov dec/} = (1 .. 12);
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my $today = localtime;
my $now = localtime->strftime('%Y%d%m');
my $thisYear = localtime->strftime('%Y');
my $thisMonth = localtime->strftime('%b');
my $lastMonth = $today->mon() - 1;
my $first = DateTime->new(year => $thisYear, month => $mon, day => 1);
#print ($today->mon() - 1) . "\n";
#print $today;
my $t = Time::Piece->strptime("07", '%m');
print $t->month;
#print $mday;
print $mon;

print "\n";
#first = date(day=1, month=today.month, year=today.year)
#lastMonth = (first - timedelta(days=1)).strftime('%b')
#thisYear = today.strftime("%Y")
#thisMonth = today.strftime("%b")
#lastMonthYear = (first - timedelta(days=1)).strftime('%Y')
#thisDay =  today.strftime("%d")
#lastYear = str(today.year - 1)
#nextYear = str(today.year + 1)
#midMonth = date(day=13, month=today.month, year=today.year)
#thisFiscal = "FY{thisYear}{nextYear}".format(thisYear=thisYear[2:], nextYear=nextYear[2:])
#lastFiscal = "FY{lastYear}{thisYear}".format(lastYear=lastYear[2:], thisYear=thisYear[2:])



# Essbase login variables
my $User = $config->{credentials}->{user};
my $Password = $config->{credentials}->{password};
my $Server = $config->{credentials}->{server};

# email properties
my $sender = $config->{mail}->{from};

#my @warning_recipients = @{$config->{credentials}->{warning}};
#my @info_recipients = @{ $config->{credentials}->{info} };
#my @error_recipients = $config->{credentials}->{error};
#my $host = $config->{credentials}->{host};

#print join(', ', @warning_recipients);
#print @info_recipients[0];

#print "The IPS are ", join(', ', @{ $config->{credentials}->{warning}}), "\n";

my $FTP_HOME = 'c:\\FTP_DATA';


my $configDir = 'C:\\scripts\\Config\\Gen5';
my $dailyFTP_file = $configDir . '\\Daily_FTP_Files.lst';
my $monthlyFTP_file = $configDir . '\\Monthly_FTP_Files.lst';
my $SAPFTP_file = $configDir . '\\SAP_FTP_Files.lst';

check_files();
sub file_search
{
    #opendir(DIR, $FTP_HOME) or die "Failed to open directory";
}
sub check_files {
  open my $handle, '<', $dailyFTP_file;
  chomp(my @lines = <$handle>);
  close $handle;

  #@required_files = ();
  #@optional_files = ();
  foreach (@lines)
  {
    my @fields = split /\|/, $_;
    my $file = $FTP_HOME.'\\'.$fields[0];
    my $required = $fields[1];
    if (-e $file and uc($required) eq 'R')
    {
      #print "Daily Required File: ".$file."\n";
      my $stat = stat($file);
      my $modtime = ctime($stat->mtime);
      my $filesize = sprintf '%.2f', ($stat->size)/1024/1024;
      print "Daily required file: ".$file.", ".$modtime.", ".$filesize." MB\n";
  #    push @required_files, $file;
    }
    elsif (-e $file and uc($required) eq 'O')
    {
      my $stat = stat($file);
      my $modtime = ctime($stat->mtime);
      my $filesize = sprintf '%.2f', ($stat->size)/1024/1024;
      print "Daily optional file: ".$file.", ".$modtime.", ".$filesize." MB\n";
  #    push @optional_files, $file;
    }
  }
}
