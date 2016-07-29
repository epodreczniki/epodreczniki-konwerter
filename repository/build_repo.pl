#!/usr/bin/perl -w
# autor: Tomasz Kuczyñski <tomasz.kuczynski@man.poznan.pl>

use strict;
use Cwd;
use Data::Dumper;
use Crypt::CBC;
use Crypt::Blowfish;
use Digest::MD5 qw(md5_hex);

use constant STATUS_FATAL=>'EPK_STATUS_FATAL';

my $cwd=getcwd();
$cwd=~/^(.*)\/repository$/;
my $zip="$1/executable/7za.exe";
my %CONFIG;
eval(load_file('build_repo.cfg'));

my $cipher = Crypt::CBC->new(
    -key    => $CONFIG{RCIPHER_VALUE},
    -cipher => 'Blowfish'
);

chdir('modules/FOP_UPDATE');
print `$zip a -p$CONFIG{ZIP_PASSWORD} -r ../../dist/FOP_UPDATE.zip docbook-xsl-1.77.1 fop-fonts logo.png`;
chdir($cwd);
chdir('modules/XSLT_PACKAGE');
print `$zip a -p$CONFIG{ZIP_PASSWORD} -r ../../dist/xsltpackage.zip *.xml *.xslt`;
chdir($cwd);
save_file("dist/$_.bin", $cipher->encrypt(load_file("modules/$_"))) for qw(ooxml2docbook.xslt MAIN_MODULE.pl corecurriculummap.xml);

my %REPOSITORY=(digest_file('../executable/konwerter_OOXML.exe')=>{
    'FOP' => {
        'URL' => $CONFIG{REPOSITORY_BASE}.'fop-1.1-bin.zip',
        'ORDER' => 2,
        'DIGEST' => digest_file('dist/fop-1.1-bin.zip'),
        'VERSION' => 'fop-1.1-bin'
        },
    'OOXML2DOCBOOK' => {
        'URL' => $CONFIG{REPOSITORY_BASE}.'ooxml2docbook.xslt.bin',
        'ORDER' => 5,
        'DIGEST' => digest_file('dist/ooxml2docbook.xslt.bin'),
        'VERSION' => '1.1.3'
        },
    'FOP_UPDATE' => {
        'URL' => $CONFIG{REPOSITORY_BASE}.'FOP_UPDATE.zip',
        'ORDER' => 5,
        'DIGEST' => digest_file('dist/FOP_UPDATE.zip'),
        'VERSION' => '0.6'
        },
    'JEUCLID' => {
        'URL' => $CONFIG{REPOSITORY_BASE}.'jeuclid-3.1.9-distribution.zip',
        'ORDER' => 4,
        'DIGEST' => digest_file('dist/jeuclid-3.1.9-distribution.zip'),
        'VERSION' => 'jeuclid-3.1.9-distribution'
        },
    'MAIN_MODULE' => {
        'URL' => $CONFIG{REPOSITORY_BASE}.'MAIN_MODULE.pl.bin',
        'ORDER' => 0,
        'DIGEST' => digest_file('dist/MAIN_MODULE.pl.bin'),
        'VERSION' => '1.0.3'
        },
    'SAXON' => {
        'URL' => $CONFIG{REPOSITORY_BASE}.'saxonb9-1-0-8j.zip',
        'ORDER' => 1,
        'DIGEST' => digest_file('dist/saxonb9-1-0-8j.zip'),
        'VERSION' => 'saxonb9-1-0-8j'
        },
    'XSLT_PACKAGE' => {
        'URL' => $CONFIG{REPOSITORY_BASE}.'xsltpackage.zip',
        'ORDER' => 5,
        'DIGEST' => digest_file('dist/xsltpackage.zip'),
        'VERSION' => '0.7.3'
        },
    'CORE_CURRICULUM_MAP' => {
        'URL' => $CONFIG{REPOSITORY_BASE}.'corecurriculummap.xml.bin',
        'ORDER' => 5,
        'DIGEST' => digest_file('dist/corecurriculummap.xml.bin'),
        'VERSION' => '0.4'
        },
    'DOCBOOK_XSL' => {
        'URL' => $CONFIG{REPOSITORY_BASE}.'docbook-xsl-1.77.1.zip',
        'ORDER' => 3,
        'DIGEST' => digest_file('dist/docbook-xsl-1.77.1.zip'),
        'VERSION' => 'docbook-xsl-1.77.1'
        }
    });

save_config('REPOSITORY.list','REPOSITORY',\%REPOSITORY);
save_file("dist/REPOSITORY.list.bin", $cipher->encrypt(load_file('REPOSITORY.list')));
unlink 'REPOSITORY.list';

print "READY!\n";

sub digest_file{
    my($filename)=shift;
    md5_hex(load_file($filename));
}

sub save_config{
    my ($filename, $hashname, $hashref)=(shift,shift,shift);

    my $data = Data::Dumper->Dump([$hashref]);
    $data=~s/\$VAR1 = {/%$hashname = (/;
    $data=~s/};$/);/;

    save_file($filename,$data);
}

sub load_file{
    my($filename,$data)=shift;

    open(FH, "<$filename") or log_status("Nie mo¿na otworzyæ pliku ($filename) do odczytu ($!).",STATUS_FATAL);
    local $/;
    $data=<FH>;
    close FH;

    $data;
}

sub save_file{
    my($filename,$data)=(shift,shift);

    open(FH, ">$filename") or log_status("Nie mo¿na otworzyæ pliku ($filename) do zapisu ($!).",STATUS_FATAL);
    print FH $data;
    close FH;
}

sub log_status{
    my($message,$type)=(shift,shift);
    print "$type:$message";
    if($type eq STATUS_FATAL){
        print " Wyjœcie z programu.\n";
        exit 1;
    }
    print "\n";
}