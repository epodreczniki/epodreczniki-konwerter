#!/usr/bin/perl -w
# autor: Tomasz Kuczyñski <tomasz.kuczynski@man.poznan.pl>
# wersja: 0.7

use strict;
use Crypt::CBC;
use Crypt::Blowfish;
use Cwd;
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use File::Copy;
use File::Copy::Recursive qw(dircopy);
use File::Path qw(make_path remove_tree);
use Getopt::Long;
use LWP::UserAgent;
use Encode qw/decode encode/;
use Win32::TieRegistry(TiedHash => '%Registry');

$|=1;

use constant CONFIG=>'konwerter_OOXML.cfg';
# has³o lokalne
use constant LCIPHER_VALUE=>'';
# has³o zdalne
use constant RCIPHER_VALUE=>'';

# adresy repozytoriów modu³ów konwertera, wstaw adres bazowy przed REPOSITORY.list.bin
my @REPOSITORY_ROOTS=(
                      'REPOSITORY.list.bin',    
);

use constant DOWNLOADS_DIR => 'DOWNLOADS';
use constant BASE_DIR => 'BASE';
use constant SRC_DIR => 'SRC';
use constant DATA_DIR => 'DATA';
use constant LOG=>'EPK_LOG';
use constant STATUS_INFO=>'EPK_STATUS_INFO';
use constant STATUS_DONE=>'EPK_STATUS_DONE';
use constant STATUS_WARN=>'EPK_STATUS_WARN';
use constant STATUS_ERROR=>'EPK_STATUS_ERROR';
use constant STATUS_FATAL=>'EPK_STATUS_FATAL';
use constant LOG_SEPARATOR=>';;;';
use constant LCIPHER=>'LCIPHER';
use constant RCIPHER=>'RCIPHER';
use constant BASE_DIGEST=>'BASE_DIGEST';
use constant MAIN_MODULE=>'MAIN_MODULE';
use constant URL=>'URL';
use constant DIGEST=>'DIGEST';
use constant ORDER=>'ORDER';
use constant VERSION=>'VERSION';
use constant PATH_SOURCE=>'PATH_SOURCE';
use constant PATH_INSTALLED=>'PATH_INSTALLED';
use constant PATH_MS_WORD=>'PATH_MS_WORD';
use constant PATH_WINDOWS_FONTS=>'PATH_WINDOWS_FONTS';
use constant PATH_INSTALACJA=>'PATH_INSTALACJA';
use constant PATH_JAVA_HOME=>'PATH_JAVA_HOME';
use constant PATH_INIT_CFG=>'PATH_INIT_CFG';
use constant PATH_DOWNLOADS=>'PATH_DOWNLOADS';
use constant PATH_BASE=>'PATH_BASE';
use constant PATH_SRC=>'PATH_SRC';
use constant PATH_DATA=>'PATH_DATA';
use constant PATH_REPO_BIN=>'PATH_REPO_BIN';
use constant INIT_INSTALLED=>'INIT_INSTALLED';

my ($identify,$help,$update,$gui,$debug,$directory,%publication_property) = (0,0,0,0,0);
GetOptions ("identyfikuj|i" => \$identify,
	    "help|h" => \$help,
            "aktualizuj|a" => \$update,
            "debug" => \$debug,
            "katalog|k=s" => \$directory,
            "publikacja=s%" => \%publication_property,
            "gui|g" => \$gui);
my($inplace_progress)=!$gui;

my (%CONFIG,%INIT);
process_config(clear_config(load_file(CONFIG)));

init();

$CONFIG{BASE_DIGEST} = digest_me();

help() if $help;

identify() if $identify;

my (%REPOSITORY,%GD);

update(@REPOSITORY_ROOTS);
if($update){
    log_status("Aktualizacja zakoñczona.",STATUS_INFO);
    exit 0;
}

process($directory);

sub process{
    my($source_directory)=shift;
    log_status("Nie podano nazwy katalogu do przetwarzania.",STATUS_FATAL) unless $source_directory;
    log_status("$source_directory nie istnieje lub nie jest katalogiem.",STATUS_FATAL) unless -d $source_directory;
    hook_process($source_directory);
}

sub clear_config{
  my($config_data)=shift;
  $config_data=~s#\\#/#g;
  $config_data=~s/^#.*$//m while($config_data=~/^#.*$/m);
  $config_data;
}

sub process_config{
  my ($config_data)=shift;
  eval $config_data;
  log_status("Problem z przetworzeniem pliku z konfiguracj¹ ($@)!",STATUS_FATAL) if $@;
  log_status("Œcie¿ka do katalogu roboczego okreœlonego w konfiguracji zawiera niedozwolone znaki !",STATUS_FATAL) unless $CONFIG{PATH_INSTALACJA}=~/^[-qwertyuiopasdfghjklzxcvbnm0-9_:\\\/]+$/i;
  unless($CONFIG{PATH_JAVA_HOME}){
    $CONFIG{PATH_JAVA_HOME}=$ENV{'JAVA_HOME'};
    $CONFIG{PATH_JAVA_HOME}=$Registry{"LMachine\\SOFTWARE\\JavaSoft\\Java Runtime Environment\\$Registry{\"LMachine\\SOFTWARE\\JavaSoft\\Java Runtime Environment\\\\CurrentVersion\"}\\\\JavaHome"} if exists $Registry{'LMachine\\SOFTWARE\\JavaSoft\\Java Runtime Environment\\\\CurrentVersion'};
    $CONFIG{PATH_JAVA_HOME}=`where java` unless $CONFIG{PATH_JAVA_HOME};
    if($CONFIG{PATH_JAVA_HOME}=~m#^[a-z]:((\\|/)[^\\/?:*"><|]+)+(\\|/)?$#i){
        $CONFIG{PATH_JAVA_HOME}=~s#\\#/#g;
        $CONFIG{PATH_JAVA_HOME}=~s#/$##;
        $CONFIG{PATH_JAVA_HOME}=~s#^"(.*)"$#$1#;
    }else{
        log_status("Nie mo¿na odnaleŸæ Javy. Okreœl œcie¿kê do Javy poprzez dodania katalogu domowego Javy do zmiennej œrodowiskowej PATH, modyfikacjê konfiguracji, lub ustawienie zmiennej œrodowiskowej JAVA_HOME.",STATUS_FATAL);
    }
  }
  $CONFIG{$_}=~s#/$## for(map {/^PATH/?$_:()} keys %CONFIG);
  $CONFIG{PATH_INIT_CFG}="$CONFIG{PATH_INSTALACJA}/INIT.cfg";
  $CONFIG{PATH_DOWNLOADS}="$CONFIG{PATH_INSTALACJA}/${\(DOWNLOADS_DIR)}";
  $CONFIG{PATH_BASE}="$CONFIG{PATH_INSTALACJA}/${\(BASE_DIR)}";
  $CONFIG{PATH_SRC}="$CONFIG{PATH_BASE}/${\(SRC_DIR)}";
  $CONFIG{PATH_DATA}="$CONFIG{PATH_BASE}/${\(DATA_DIR)}";
  $CONFIG{PATH_REPO_BIN}="$CONFIG{PATH_BASE}/REPO.bin";
  $ENV{'PATH'}="$CONFIG{PATH_JAVA_HOME};$ENV{'PATH'}";
  $ENV{'JAVA_HOME'}=$CONFIG{PATH_JAVA_HOME};
  $CONFIG{RCIPHER}=create_cipher(RCIPHER_VALUE);
  $CONFIG{LCIPHER}=create_cipher(LCIPHER_VALUE);
  load_main_module();
  hook_process_config();
}

sub init{
    init_extract();
    init_installs();
    init_downloads();
    init_base();
    init_src();
    init_data();
    hook_init();
}

sub init_extract{
    my $zip=PerlApp::extract_bound_file('7za.exe');
    $zip=~s/7za.exe$/;/;
    $ENV{'PATH'}="${zip}$ENV{'PATH'}";
    PerlApp::extract_bound_file('7za_readme.txt');
    PerlApp::extract_bound_file('7za_license.txt');
}

sub init_installs{
    unless(-e $CONFIG{PATH_INSTALACJA}){
        make_path($CONFIG{PATH_INSTALACJA});
        my %INIT=(
                    ${\(INIT_INSTALLED)}=>{
                     ${\(MAIN_MODULE)}=>{${\(DIGEST)}=>0},
                    },
                    ${\(BASE_DIGEST)}=>0,
                     );
        save_init_state(\%INIT);
    }
    log_status("B³¹d konfiguracji. $CONFIG{PATH_INSTALACJA} nie jest katalogiem!", STATUS_FATAL) unless -d $CONFIG{PATH_INSTALACJA};
    load_init_state();
}

sub init_downloads{
    remove_tree($CONFIG{PATH_DOWNLOADS});
    init_dir($CONFIG{PATH_DOWNLOADS});
}

sub init_base{
    init_dir($CONFIG{PATH_BASE});
}

sub init_src{
    init_dir($CONFIG{PATH_SRC});
}

sub init_data{
    init_dir($CONFIG{PATH_DATA});
}

sub init_dir{
    my($dirname)=shift;
    unless(-e $dirname){
        make_path($dirname);
    }
    log_status("B³¹d œrodowiska. $dirname nie jest katalogiem!", STATUS_FATAL) unless -d $dirname;
}

sub update{
    my(@repo_roots)=@_;
    my $status = 0;
    do{
    	$status = getstore(shift @repo_roots,$CONFIG{PATH_REPO_BIN},0,$inplace_progress,1);
    } while(@repo_roots && !$status);
    my @updated=();
    unless ($status) {
        my $installation_complete=1;
        for(keys %{$INIT{INIT_INSTALLED}}){
            unless(${${$INIT{INIT_INSTALLED}}{$_}}{DIGEST}){
                $installation_complete=0;
                last();
            }
        }
        log_status("Proszê sprawdziæ po³¹czenie z Internetem. Nie mo¿na pobraæ modu³ów niezbêdnych do dzia³ania konwertera.",STATUS_FATAL) unless $installation_complete;
    }else{
        log_status("Sprawdzam aktualizacje.",STATUS_INFO);
        eval decrypt($CONFIG{RCIPHER},load_file($CONFIG{PATH_REPO_BIN}));
        if($@ && @repo_roots){
            do{
    	        $status = getstore(shift @repo_roots,$CONFIG{PATH_REPO_BIN},0,$inplace_progress,1);
                eval decrypt($CONFIG{RCIPHER},load_file($CONFIG{PATH_REPO_BIN}));
            } while(@repo_roots && $@);
        }
        unlink($CONFIG{PATH_REPO_BIN});
        log_status("Nie mo¿na przetworzyæ listy modu³ów do aktualizacji.",STATUS_FATAL) if $@;

        my $full_update=$INIT{BASE_DIGEST} ne digest_me();
        if($full_update){
          log_status("Przeprowadzam pe³n¹ aktualizacjê.",STATUS_INFO);
          hook_before_full_update();
        }

        log_status("Brak modu³u g³ównego kompatybilnego z zainstalowan¹ wersj¹ konwertera.",STATUS_FATAL) unless exists $REPOSITORY{$CONFIG{BASE_DIGEST}};
        my $MAIN_MODULE=${$REPOSITORY{$CONFIG{BASE_DIGEST}}}{MAIN_MODULE};

        my ($MAIN_MODULE_PATH,$DOWNLOAD_PATH,$install_main)=("$CONFIG{PATH_BASE}/${\(MAIN_MODULE)}","$CONFIG{PATH_DOWNLOADS}/${\(MAIN_MODULE)}",0);
        if (!${${$INIT{INIT_INSTALLED}}{MAIN_MODULE}}{DIGEST} || $full_update){
            log_status("Pobieranie modu³u g³ównego konwertera.",STATUS_INFO);
            getstore(${$MAIN_MODULE}{URL},$DOWNLOAD_PATH,1,$inplace_progress,0,'modu³u g³ównego');
            if(${$MAIN_MODULE}{DIGEST} ne digest_file($DOWNLOAD_PATH)){
                unlink($DOWNLOAD_PATH);
                log_status("Nieprawid³owa sygnatura pobranego modu³u.",STATUS_FATAL);
            }
            no warnings;
            eval decrypt($CONFIG{RCIPHER},load_file($DOWNLOAD_PATH));
            if($@){
                unlink($DOWNLOAD_PATH);
                log_status("Nie mo¿na uruchomiæ modu³u g³ównego ($@).",STATUS_FATAL);
            }
            move($DOWNLOAD_PATH,$MAIN_MODULE_PATH);
            $INIT{BASE_DIGEST}=digest_me();
            ${${$INIT{INIT_INSTALLED}}{MAIN_MODULE}}{DIGEST}=${$MAIN_MODULE}{DIGEST};
            ${${$INIT{INIT_INSTALLED}}{MAIN_MODULE}}{URL}=${$MAIN_MODULE}{URL};
            ${${$INIT{INIT_INSTALLED}}{MAIN_MODULE}}{VERSION}=${$MAIN_MODULE}{VERSION};
            ${${$INIT{INIT_INSTALLED}}{MAIN_MODULE}}{PATH_SOURCE}=$MAIN_MODULE_PATH;
            ${${$INIT{INIT_INSTALLED}}{MAIN_MODULE}}{PATH_INSTALLED}=$MAIN_MODULE_PATH;
            push @updated, MAIN_MODULE;
            save_init_state();
        }else{
            if(${$MAIN_MODULE}{DIGEST} ne digest_file($MAIN_MODULE_PATH)){
                log_status("Aktualizacja modu³u g³ównego konwertera.",STATUS_INFO);
                if(getstore(${$MAIN_MODULE}{URL},$DOWNLOAD_PATH,digest_me() ne $INIT{BASE_DIGEST},$inplace_progress,0,'modu³u g³ównego')){
                    if(${$MAIN_MODULE}{DIGEST} ne digest_file($DOWNLOAD_PATH)){
                        unlink($DOWNLOAD_PATH);
                        log_status("Nieprawid³owa sygnatura pobranego modu³u.",STATUS_FATAL);
                    }
                    no warnings;
                    eval decrypt($CONFIG{RCIPHER},load_file($DOWNLOAD_PATH));
                    if($@){
                        unlink($DOWNLOAD_PATH);
                        print $@;
                        log_status("Nie mo¿na uruchomiæ zaktualizowanego modu³u g³ównego ($@).",STATUS_FATAL);
                    }
                    move($DOWNLOAD_PATH,$MAIN_MODULE_PATH);
                    $INIT{BASE_DIGEST}=digest_me();
                    ${${$INIT{INIT_INSTALLED}}{MAIN_MODULE}}{DIGEST}=${$MAIN_MODULE}{DIGEST};
                    ${${$INIT{INIT_INSTALLED}}{MAIN_MODULE}}{URL}=${$MAIN_MODULE}{URL};
                    ${${$INIT{INIT_INSTALLED}}{MAIN_MODULE}}{VERSION}=${$MAIN_MODULE}{VERSION};
                    ${${$INIT{INIT_INSTALLED}}{MAIN_MODULE}}{PATH_SOURCE}=$MAIN_MODULE_PATH;
                    ${${$INIT{INIT_INSTALLED}}{MAIN_MODULE}}{PATH_INSTALLED}=$MAIN_MODULE_PATH;
                    push @updated, MAIN_MODULE;
                    save_init_state();
                }else{
                    log_status("Pobranie modu³u g³ównego konwertera nie powiod³o siê. Uruchamiam star¹ wersjê.",STATUS_ERROR);
                }
            }else{
                log_status("Modu³ g³ówny konwertera aktualny.",STATUS_INFO);
            }
        }

        for my $MODULE_KEY (sort {${${$REPOSITORY{$CONFIG{BASE_DIGEST}}}{$a}}{ORDER}<=>${${$REPOSITORY{$CONFIG{BASE_DIGEST}}}{$b}}{ORDER}} keys %{$REPOSITORY{$CONFIG{BASE_DIGEST}}}){
            next if $MODULE_KEY eq MAIN_MODULE;

            my $MODULE=${$REPOSITORY{$CONFIG{BASE_DIGEST}}}{$MODULE_KEY};
            my ($DOWNLOAD_PATH,$install)=("$CONFIG{PATH_DOWNLOADS}/$MODULE_KEY",0);

            if (!${$INIT{INIT_INSTALLED}}{$MODULE_KEY} || $full_update){
                log_status("Pobieranie modu³u $MODULE_KEY.",STATUS_INFO);
                getstore(${$MODULE}{URL},$DOWNLOAD_PATH,1,$inplace_progress,0,"modu³u $MODULE_KEY");
                log_status("Weryfikacja pobranego modu³u.",STATUS_INFO);
                if(${$MODULE}{DIGEST} ne digest_file($DOWNLOAD_PATH)){
                    unlink($DOWNLOAD_PATH);
                    log_status("Nieprawid³owa sygnatura pobranego modu³u.",STATUS_FATAL);
                }
                my %module_data=(
                    DIGEST=>${$MODULE}{DIGEST},
                    URL=>${$MODULE}{URL},
                    VERSION=>${$MODULE}{VERSION},
                    PATH_SOURCE=>$DOWNLOAD_PATH,
                );
                hook_update_module($MODULE_KEY,\%module_data);
                ${$INIT{INIT_INSTALLED}}{$MODULE_KEY}=\%module_data;
                push @updated, $MODULE_KEY;
                save_init_state();
            }else{
                if(${$MODULE}{DIGEST} ne ${${$INIT{INIT_INSTALLED}}{$MODULE_KEY}}{DIGEST}){
                    log_status("Aktualizacja modu³u $MODULE_KEY.",STATUS_INFO);
                    if(getstore(${$MODULE}{URL},$DOWNLOAD_PATH,0,$inplace_progress,0,"modu³u $MODULE_KEY")){
                        log_status("Weryfikacja pobranego modu³u.",STATUS_INFO);
                        if(${$MODULE}{DIGEST} ne digest_file($DOWNLOAD_PATH)){
                            unlink($DOWNLOAD_PATH);
                            log_status("Nieprawid³owa sygnatura pobranego modu³u.",STATUS_FATAL);
                        }
                        my %module_data=(
                            DIGEST=>${$MODULE}{DIGEST},
                            URL=>${$MODULE}{URL},
                            VERSION=>${$MODULE}{VERSION},
                            PATH_SOURCE=>$DOWNLOAD_PATH,
                        );
                        hook_update_module($MODULE_KEY,\%module_data);
                        ${$INIT{INIT_INSTALLED}}{$MODULE_KEY}=\%module_data;
                        push @updated, $MODULE_KEY;
                        save_init_state();
                    }else{
                        log_status("Pobranie modu³u $MODULE_KEY nie powiod³o siê. Uruchamiam star¹ wersjê.",STATUS_ERROR);
                    }
                }else{
                    log_status("Modu³ $MODULE_KEY aktualny.",STATUS_INFO);
                }
            }
        }
        if ($full_update) {
            $INIT{BASE_DIGEST}=digest_me();
            save_init_state();
        }
    }
    hook_update(\@updated);
}

sub hook_identify{}

sub hook_help{}

sub hook_before_full_update{}

sub hook_process_config{}

sub hook_init{}

sub hook_update{
    my($ar_modules)=shift;
}

sub hook_update_module{
    my($MODULE_KEY)=shift;
}

sub hook_process{}

sub decrypt{
    my($cipher,$data)=(shift,shift);
    eval{
      $data=$cipher->decrypt($data);
    };
    log_status("B³¹d przetwarzania danych ($@).",STATUS_FATAL) if $@;
    $data;
}

sub encrypt{
    my($cipher,$data)=(shift,shift);
    $cipher->encrypt($data);
}

sub create_cipher{
    my $key=shift;
    Crypt::CBC->new(-key => $key,-cipher => 'Blowfish');
}

sub digest_me{
    digest_file($0);
}

sub digest_file{
    my($filename)=shift;
    md5_hex(load_file($filename));
}

sub log_status{
    my($message,$type)=(shift,shift);
    my_print("$type${\(LOG_SEPARATOR)}$message");
    if($type eq STATUS_FATAL){
        my_print(" Wyjœcie z programu.\n") unless $gui;
        exit 1;
    }
    print "\n";
}

sub log_details{
    my($message,$type,$name,$filepath)=(shift,shift,shift,shift);
    my_print(LOG.LOG_SEPARATOR."$name${\(LOG_SEPARATOR)}$filepath${\(LOG_SEPARATOR)}$type${\(LOG_SEPARATOR)}$message\n");
}

sub identify{
    my_print("Wersja oprogramowania: $CONFIG{BASE_DIGEST}\n");
    hook_identify();
    exit 0;
}

sub help{
    my_print("Konwerter OOXML do EPXML wersja: $CONFIG{BASE_DIGEST}\n");
    hook_help();
    exit 0;
}

sub my_print{
  my($data)=decode('cp1250',shift);
  no warnings;
  print ($gui ? $data : encode('cp852', $data));
}

sub getstore{
  my($url,$savefile)=(shift,shift);
  my($die_on_network_error,$inplace_progress,$quiet,$display_url)=((scalar(@_)?shift:1),(scalar(@_)?shift:1),(scalar(@_)?shift:0),(scalar(@_)?shift:$url));

  my($ua,$current_length,$content_length,$percent,$percent_last,$save_flush)=(LWP::UserAgent->new(),0,0,0,-1,$|);

  $ua->timeout(30);

  unlink($savefile) if -e $savefile;

  open FH,">$savefile" or log_status("Nie mo¿na otworzyæ pliku $savefile do zapisu ($!).",STATUS_FATAL);
  binmode FH;

  $|=1;

  unless($quiet){
    if ($inplace_progress) {
        my_print("Pobieranie pliku $display_url. Rozmiar: ");
    }else{
        log_status("Pobieranie pliku $display_url.",STATUS_INFO);
    }
  }

  my $response = $ua->get($url, ':content_cb' => sub{my ($data, $response, $protocol) = @_;
    print FH $data;

    unless($quiet){
        unless($content_length){
            $content_length=$response->header('Content-length');
            if ($inplace_progress) {
                my_print("$content_length bajtów. Pobrano:      ");
            }else{
                log_status("Pobieranie pliku $display_url. Rozmiar: $content_length bajtów.",STATUS_INFO);
            }
        }
        $current_length+=length($data);
        $percent=int(100*$current_length/$content_length);
        if ($inplace_progress) {
            print(("\b" x (2 + length($percent))),$percent,' %');
        }else{
            if ($percent ne $percent_last) {
                log_status("Pobieranie pliku $display_url. Rozmiar: $content_length bajtów. Pobrano: $percent %.",STATUS_INFO);
                $percent_last=$percent;
            }
        }
    }
    });
  
  print "\n" if $inplace_progress and not $quiet;
  close FH;

  unless ($quiet) {
    if($response->is_success){
        log_status("Zapisano jako $savefile.",STATUS_INFO);
    }else{
        log_status("Nie uda³o siê pobraæ pliku $url. OdpowiedŸ serwera: ".$response->status_line.".",($die_on_network_error?STATUS_FATAL:STATUS_ERROR));
    }
  }
  $|=$save_flush;
  $response->is_success;
}

sub install_package{
  my($package,$unzip_dir)=(shift,shift);

  log_status("Rozpakowywanie pakietu $package.",STATUS_INFO);
  mkdir($unzip_dir);
  extract_zip($package, $unzip_dir);
  log_status("Rozpakowano pakiet $package.",STATUS_INFO);
}

sub extract_zip{
  my($package,$unzip_dir,$additional_options)=(shift,shift,scalar(@_)?shift:'');
  my $command="7za.exe x -y -o$unzip_dir $additional_options $package";
  my $output=`$command`;
  log_status("Nie mo¿na rozpakowaæ pliku $package. Powód: $1.",STATUS_FATAL) if $output=~/Error:(.*)$/s;
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

sub save_config{
    my ($filename, $hashname, $hashref)=(shift,shift,shift);

    my $data = Data::Dumper->Dump([$hashref]);
    $data=~s/\$VAR1 = {/%$hashname = (/;
    $data=~s/};$/);/;

    $data = encrypt($CONFIG{LCIPHER}, $data);

    save_file($filename,$data);
}

sub load_config{
    my ($filename,$message)=(shift,shift);
    my $data = load_file($filename);

    $data = decrypt($CONFIG{LCIPHER},$data);

    eval $data;

    log_status($message,STATUS_FATAL) if $@;
}

sub save_init_state{
    my($ref)=(scalar(@_)?shift:\%INIT);
    save_config($CONFIG{PATH_INIT_CFG},'INIT',$ref);
}

sub load_init_state{
    load_config($CONFIG{PATH_INIT_CFG},"Nie mo¿na przetworzyæ konfiguracji stanu instalacji.");
}

sub load_main_module{
    my $path="$CONFIG{PATH_BASE}/${\(MAIN_MODULE)}";
    return unless -e $path;

    no warnings 'redefine';
    eval decrypt($CONFIG{RCIPHER},load_file($path));
    log_status("Nie mo¿na wczytaæ modu³u g³ównego konwertera ($@).",STATUS_FATAL) if $@;
}
