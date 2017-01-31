# autor: Tomasz KuczyÒski <tomasz.kuczynski@man.poznan.pl>
# wersja: 1.0.3

my $UPDATER = 'UPDATER';
my $SAXON = 'SAXON';
my $DOCBOOK_XSL = 'DOCBOOK_XSL';
my $FOP = 'FOP';
my $JEUCLID = 'JEUCLID';
my $FOP_UPDATE = 'FOP_UPDATE';
my $OOXML2DOCBOOK = 'OOXML2DOCBOOK';
my $XSLT_PACKAGE = 'XSLT_PACKAGE';
my $CORE_CURRICULUM_MAP = 'CORE_CURRICULUM_MAP';

my $NOPDF=0;
my $MODULES=0;
my $PDFS=0;
my $UPDATER_EXE = 'konwerter_OOXML.exe';
my $OMML2MML_XSLT = 'OMML2MML.XSL';
my $OOXML2DOCBOOK_XSLT = 'OOXML2DOCBOOK.XSL';
my $LOGO = 'LOGO';
my $LOGO_FILENAME = 'logo.png';
my $FOP_XCONF = 'fop.xconf';
my $FOP_FONTS_DIRNAME = 'fop-fonts';
my $DOCBOOK_XSL_DIRNAME = 'docbook-xsl-1.77.1';
my $XSLT_PACKAGE_DIRNAME = 'xslt';
my $CHECK_REFERENCABLE_XSLT = 'check_referencable.xslt';
my $GENERATE_GLOSSARIES_XSLT = 'generate_glossaries.xslt';

my $PATH_UPDATER='PATH_UPDATER';
my $PATH_OMML2MML_XSLT='PATH_OMML2MML_XSLT';
my $PATH_OOXML2DOCBOOK_XSLT='PATH_OOXML2DOCBOOK_XSLT';
my $PATH_CHECK_REFERENCABLE_XSLT='PATH_CHECK_REFERENCABLE_XSLT';
my $PATH_GENERATE_GLOSSARIES_XSLT='PATH_GENERATE_GLOSSARIES_XSLT';

my $PATH_FOP_XCONF='PATH_FOP_XCONF';
my $TOKENS = 'TOKENS';
my $DIRS = 'DIRS';
my $FOP_FONTS_DIR = 'FOP_FONTS_DIR';

my $fop_parameters='';
my $PATH_DOCXM_MAP_CFG='PATH_DOCXM_MAP_CGG';
my $DOCXM_MAP_CFG='DOCXM_MAP.cfg';
my $PATH_DOCXM_MAP_XML='PATH_DOCXM_MAP_XML';
my $DOCXM_MAP_XML='DOCXM_MAP.xml';
my $PATH_AGGREGATED_REFERENCABLE_ELEMENTS_XML='PATH_AGGREGATED_REFERENCABLE_ELEMENTS_XML';
my $PATH_AGGREGATED_REFERENCABLE_ELEMENTS_TMP_XML='PATH_AGGREGATED_REFERENCABLE_ELEMENTS_TMP_XML';
my $AGGREGATED_REFERENCABLE_ELEMENTS_XML='AGGREGATED_REFERENCABLE_ELEMENTS.xml';
my $AGGREGATED_REFERENCABLE_ELEMENTS_TMP_XML='AGGREGATED_REFERENCABLE_ELEMENTS_TMP.xml';
my $PATH_CORE_CURRICULUM_MAP_XML='PATH_CORE_CURRICULUM_MAP_XML';
my $CORE_CURRICULUM_MAP_XML='CORE_CURRICULUM_MAP.xml';
my $REFERENCABLE_ELEMENTS_XML='REFERENCABLE_ELEMENTS.xml';
#miejsce na has≥o ZIP
my $zip_password='';
#lista czcionek do sprawdzenia na systemie uøytkownika
my @FOP_FONTS=(); #np. qw(arial.TTF ARIALBD.TTF ARIALI.TTF ARIALBI.TTF times.ttf timesbd.ttf timesi.ttf timesbi.ttf);
my %FOP_PARAMS=(
#nazwy wykorzystanych czcionek
    'body.font.family'=>'', #np. 'Times',
    'title.font.family'=>'', #np. 'Arial',
    'page.orientation'=>'landscape',
    'toc.section.depth'=>'3',
    'body.margin.inner'=>'-0.2in',
    'body.margin.outer'=>'0.2in',
);
$fop_parameters.="-param $_ $FOP_PARAMS{$_} " for keys %FOP_PARAMS;
use vars '%DOCXM_MAP';
use Digest::MD5 qw(md5_base64);

my $DOCXM_WORKING_PATH='DOCXM_WORKING_PATH';
my $DOCXM_FILE_ID='DOCXM_FILE_ID';
my $DOCXM_FILE_DEPTH='DOCXM_FILE_DEPTH';
my $DOCXM_BOOKMARKS='DOCXM_BOOKMARKS';
my $DOCXM_PDF_IN_TREE_RUNAWAY_PREFIX='DOCXM_PDF_IN_TREE_RUNAWAY_PREFIX';
my $DOCXM_CHAPTERS='DOCXM_CHAPTERS';
my $PATH_PREVIEW_PDF='PATH_PREVIEW_PDF';
my $PREVIEW_PDF_DIRNAME='_ep_pdf';
my $PATH_IMPORT='PATH_IMPORT';
my $PATH_PUBLICATION='PATH_PUBLICATION';
my $IMPORT_DIRNAME='_ep_import';

my %KNOWN_MODULES=(
                   $UPDATER => 1,
                   $SAXON => 1,
                   $DOCBOOK_XSL => 1,
                   $FOP => 1,
                   $JEUCLID => 1,
                   $FOP_UPDATE => 1,
                   $OOXML2DOCBOOK => 1,
                   $XSLT_PACKAGE => 1,
                   $CORE_CURRICULUM_MAP => 1,
);

my %UNZIP_MODULES=(
                   $SAXON => 1,
                   $DOCBOOK_XSL => 1,
                   $FOP => 1,
                   $JEUCLID => 1,
);

my %REDUCE_DIRECTORY_LEVEL_MODULES=(
                   $DOCBOOK_XSL => 1,
                   $FOP => 1,
                   $JEUCLID => 1,
);

my %LEXREF_MODULES=(
                    $UPDATER => 1,
                    $FOP => 1,
                    $JEUCLID => 1,
                    $FOP_UPDATE => 1,
                    $OOXML2DOCBOOK => 1,
                    $XSLT_PACKAGE => 1,
                    $CORE_CURRICULUM_MAP => 1,
);

sub hook_identify{
    my_print("Lista modu≥Ûw:\n");
    my_print("\tModu≥ G≥Ûwny: ${${$INIT{INIT_INSTALLED}}{MAIN_MODULE}}{VERSION} / ${${$INIT{INIT_INSTALLED}}{MAIN_MODULE}}{DIGEST}\n");
    my_print("\tG≥Ûwna transformacja XSLT: ${${$INIT{INIT_INSTALLED}}{OOXML2DOCBOOK}}{VERSION} / ${${$INIT{INIT_INSTALLED}}{OOXML2DOCBOOK}}{DIGEST}\n") if ref ${$INIT{INIT_INSTALLED}}{OOXML2DOCBOOK} eq ref {};
    my_print("\tPakiet XSLT: ${${$INIT{INIT_INSTALLED}}{XSLT_PACKAGE}}{VERSION} / ${${$INIT{INIT_INSTALLED}}{XSLT_PACKAGE}}{DIGEST}\n") if ref ${$INIT{INIT_INSTALLED}}{XSLT_PACKAGE} eq ref {};
    my_print("\tDostosowania FOP: ${${$INIT{INIT_INSTALLED}}{FOP_UPDATE}}{VERSION} / ${${$INIT{INIT_INSTALLED}}{FOP_UPDATE}}{DIGEST}\n") if ref ${$INIT{INIT_INSTALLED}}{FOP_UPDATE} eq ref {};
    my_print("\tMapa hase≥ podstawy programowej: ${${$INIT{INIT_INSTALLED}}{CORE_CURRICULUM_MAP}}{VERSION} / ${${$INIT{INIT_INSTALLED}}{CORE_CURRICULUM_MAP}}{DIGEST}\n") if ref ${$INIT{INIT_INSTALLED}}{CORE_CURRICULUM_MAP} eq ref {};
}

sub hook_help{
    my_print("SposÛb uøycia:\n");
    my_print("\t$0 {{-identyfikuj|-i}|{-help|-h}|{-aktualizuj|-a}|{-katalog|-k} úcieøka_do_katalogu [-publikacja w≥aúciwoúÊ_publikacji=wartoúÊ_w≥aúciwoúci_publikacji] ...}\n\n");
    my_print("Parametry:\n");
    my_print("\t-identyfikuj|-i - wyúwietl informacje o programie\n");
    my_print("\t-aktualizuj|-a - dokonaj aktualizacji\n");
    my_print("\t-help|-h - wyúwietl pomoc programu\n");
    my_print("\t-katalog|-k úcieøka_do_katalogu - dokonaj konwersji modu≥Ûw zawartych w katalogu úcieøka_do_katalogu\n");
    my_print("\t-publikacja w≥aúciwoúÊ_publikacji=wartoúÊ_w≥aúciwoúci_publikacji - dodaj do pliku w≥aúciwoúci publikacji masowej w≥aúciwoúÊ o nazwie w≥aúciwoúÊ_publikacji i wartoúci wartoúÊ_w≥aúciwoúci_publikacji\n\n");
    my_print("Przyk≥ady:\n");
    my_print("\t$0 -i\n\t\twyúwietli informacje o sk≥adnikach konwertera\n\n");
    my_print("\t$0 -a\n\t\tdokona aktualizacji sk≥adnikÛw konwertera\n\n");
    my_print("\t$0 -h\n\t\twyúwietli pomoc dla programu\n\n");
    my_print("\t$0 -k c:\\podrÍczniki\\matematyka -publikacja publication.collections=20 -publikacja publication.destination.directoryId=3 -publikacja publication.published=true\n");
    my_print("\t\tdokonaj konwersji modu≥Ûw zawartych w katalogu c:\\podrÍczniki\\matematyka a nastÍpnie wygeneruj strukturÍ do masowego importu do Repozytorium Treúci dodajπc do pliku z w≥aúciwoúciami 3 w≥aúciwoúci:\n");
    my_print("\t\tpublication.collections=20, publication.destination.directoryId=3 oraz publication.published=true\n");
}

sub hook_before_full_update{
    if(exists ${$INIT{INIT_INSTALLED}}{$UPDATER}){
      my $INIT_REF = delete ${$INIT{INIT_INSTALLED}}{$UPDATER};
      unlink ${$INIT_REF}{PATH_INSTALLED};
      save_init_state();
    }
}

sub hook_process_config{
    $ENV{'PATH'}=~s#^([^;]+);#$1/bin;$1;#;
    check_cwd();
}

sub hook_init{
    for my $MODULE_KEY (keys %KNOWN_MODULES){
        my $INIT_REF = get_INIT_ref($MODULE_KEY);
        next unless ref $INIT_REF eq ref {};
        if ($JEUCLID eq $MODULE_KEY) {
        }elsif($FOP eq $MODULE_KEY){
            $ENV{'PATH'}="${\($CONFIG{\"${MODULE_KEY}_DIR\"}=${$INIT_REF}{PATH_INSTALLED})};$ENV{'PATH'}";
        }elsif($FOP_UPDATE eq $MODULE_KEY){
            $CONFIG{$PATH_FOP_XCONF}=${${$INIT_REF}{PATH_INSTALLED}}{$FOP_XCONF};
        }elsif($OOXML2DOCBOOK eq $MODULE_KEY){
            $CONFIG{$PATH_OOXML2DOCBOOK_XSLT} = ${$INIT_REF}{PATH_INSTALLED};
        }elsif($CORE_CURRICULUM_MAP eq $MODULE_KEY){
            $CONFIG{$PATH_CORE_CURRICULUM_MAP_XML} = ${$INIT_REF}{PATH_INSTALLED};
        }elsif($UPDATER eq $MODULE_KEY){
            $CONFIG{$PATH_UPDATER} = ${$INIT_REF}{PATH_INSTALLED};
        }elsif($XSLT_PACKAGE eq $MODULE_KEY){
	    $CONFIG{$PATH_CHECK_REFERENCABLE_XSLT} = "${$INIT_REF}{PATH_INSTALLED}/$CHECK_REFERENCABLE_XSLT";
	    $CONFIG{$PATH_GENERATE_GLOSSARIES_XSLT} = "${$INIT_REF}{PATH_INSTALLED}/$GENERATE_GLOSSARIES_XSLT";
	    $CONFIG{"${MODULE_KEY}_DIR"}=${$INIT_REF}{PATH_INSTALLED};
	}else{
            $CONFIG{"${MODULE_KEY}_DIR"}=${$INIT_REF}{PATH_INSTALLED};
        }
    }
  $CONFIG{$PATH_DOCXM_MAP_CFG}="$CONFIG{PATH_BASE}/$DOCXM_MAP_CFG";
  $CONFIG{$PATH_DOCXM_MAP_XML}="$CONFIG{PATH_BASE}/$DOCXM_MAP_XML";
  $CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_XML}="$CONFIG{PATH_BASE}/$AGGREGATED_REFERENCABLE_ELEMENTS_XML";
  $CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_TMP_XML}="$CONFIG{PATH_BASE}/$AGGREGATED_REFERENCABLE_ELEMENTS_TMP_XML";
}

sub hook_update_module{
    my($MODULE_KEY, $MODULE_DATA)=(shift,shift);
    my $MODULE_PATH = "$CONFIG{PATH_INSTALACJA}/$MODULE_KEY";
    my $INIT_REF = get_INIT_ref($MODULE_KEY);

    unless (exists $KNOWN_MODULES{$MODULE_KEY}){
        unlink(${$INIT_REF}{PATH_SOURCE});
        log_status("Modu≥ g≥Ûwny programu nie moøe przetworzyÊ modu≥u $MODULE_KEY. Modu≥ nieznany.",STATUS_FATAL);
    }

    if (exists $UNZIP_MODULES{$MODULE_KEY}) {
        if(-e $MODULE_PATH){
            log_status("Usuwanie starej wersji modu≥u $MODULE_KEY.",STATUS_INFO);
            remove_tree($MODULE_PATH);
        }
        install_package(${$MODULE_DATA}{PATH_SOURCE},$MODULE_PATH);

        reduce_directory_level($MODULE_PATH) if exists $REDUCE_DIRECTORY_LEVEL_MODULES{$MODULE_KEY};
        unless(exists $LEXREF_MODULES{$MODULE_KEY}){
            move(${$MODULE_DATA}{PATH_SOURCE},"$CONFIG{PATH_SRC}/$MODULE_KEY");

            ${$MODULE_DATA}{PATH_SOURCE}="$CONFIG{PATH_SRC}/$MODULE_KEY";
            ${$MODULE_DATA}{PATH_INSTALLED}=$CONFIG{"${MODULE_KEY}_DIR"}=$MODULE_PATH;
        }
    }

    if (exists $LEXREF_MODULES{$MODULE_KEY}) {
        no strict 'refs';
        &${\("${MODULE_KEY}_update_module")}($MODULE_KEY, $MODULE_DATA, $MODULE_PATH);
        use strict 'refs';

        move(${$MODULE_DATA}{PATH_SOURCE},"$CONFIG{PATH_SRC}/$MODULE_KEY");

        ${$MODULE_DATA}{PATH_SOURCE}="$CONFIG{PATH_SRC}/$MODULE_KEY";
    }

    log_status("Instalacja modu≥u $MODULE_KEY przebieg≥a pomyúlnie.",STATUS_INFO);
}

sub hook_update{
    my($updated)=shift;

    for my $MODULE_KEY (@$updated){
        (($CONFIG{$PATH_DOCXM_MAP_CFG}, $CONFIG{$PATH_DOCXM_MAP_XML}, $CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_XML}, $CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_TMP_XML})=("$CONFIG{PATH_BASE}/$DOCXM_MAP_CFG","$CONFIG{PATH_BASE}/$DOCXM_MAP_XML","$CONFIG{PATH_BASE}/$AGGREGATED_REFERENCABLE_ELEMENTS_XML","$CONFIG{PATH_BASE}/$AGGREGATED_REFERENCABLE_ELEMENTS_TMP_XML")) if $MODULE_KEY eq MAIN_MODULE;
    }
}

sub hook_process{
    my($source_directory)=shift;
    my %stats=();
    $stats{'START'}=time;
    unless(exists $publication_property{'publication.destination.directoryId'}){
    	$publication_property{'publication.destination.directoryId'}=3;
    }
    unless(exists $publication_property{'publication.collections'}){
    	$publication_property{'publication.collections'}=20;
    }
    unless(exists $publication_property{'publication.published'}){
       $publication_property{'publication.published'}='true';
    }
    if($publication_property{'nopdf'}) {
	$NOPDF=1;
	delete $publication_property{'nopdf'};
    }

    $source_directory=~s#\\#/#g;
    $source_directory=~s#/$##;

    unless($source_directory=~/^[a-z]:/i){
        my $cwd=getcwd();

        $cwd=~s#\\#/#g;
        $cwd=~s#/$##;

        $source_directory=$cwd.'/'.$source_directory;
    }

    $source_directory=~m#^(.*)/[^/]+$#;

    my($base_directory)=$1;
    my($errors)=0;

    $CONFIG{$PATH_IMPORT}="$source_directory/$IMPORT_DIRNAME";
    my($remove_errors,@locked_files)=[];
    remove_tree($CONFIG{$PATH_IMPORT},{error => \$remove_errors}) if -e $CONFIG{$PATH_IMPORT};
    push @locked_files, map{(split /#/)[0]} grep {my($k,$v)=split /#/;$v=~/cannot unlink file: Permission denied/} join '#',each %$_ for @$remove_errors;
    $remove_errors=[];
    $CONFIG{$PATH_PREVIEW_PDF}="$source_directory/$PREVIEW_PDF_DIRNAME";
    remove_tree($CONFIG{$PATH_PREVIEW_PDF},{error => \$remove_errors}) if -e $CONFIG{$PATH_PREVIEW_PDF};
    push @locked_files, map{(split /#/)[0]} grep {my($k,$v)=split /#/;$v=~/cannot unlink file: Permission denied/} join '#',each %$_ for @$remove_errors;
    if(@locked_files){
      local $"='", "';
      log_status("Nie moøna usunπÊ nastÍpujπc${\(@locked_files > 1?'ych plikÛw':'ego pliku')}: \"@locked_files\" . ProszÍ zamknπÊ wszystkie programy, korzystajπce z ${\(@locked_files > 1?'wymienionych plikÛw':'tego pliku')}, a nastÍpnie ponownie uruchomiÊ konwersjÍ.",STATUS_ERROR);
      return;
    }
    for(glob ($source_directory=~/\s/ ? "'$source_directory/_ep_glossary_*.xml'" : "$source_directory/_ep_glossary_*.xml")){
	unless(unlink $_){
	    log_status("Nie moøna usunπÊ nastÍpujπcego pliku: $_ . ProszÍ zamknπÊ wszystkie programy, korzystajπce z pliku, a nastÍpnie ponownie uruchomiÊ konwersjÍ.",STATUS_ERROR);
	    return;    
	}
    }
    for(glob ($source_directory=~/\s/ ? "'$source_directory/_ep_glossary_*.pdf'" : "$source_directory/_ep_glossary_*.pdf")){
	unless(unlink $_){
	    log_status("Nie moøna usunπÊ nastÍpujπcego pliku: $_. Konwersja bÍdzie kontynuowana, lecz plik podglπdu pdf nie zostanie wygenerowany.",STATUS_WARN);
	}
    }
    my $local_start=time;
    log_status("Generowanie mapy identyfikatorÛw dla modu≥Ûw treúci.",STATUS_INFO);
    $errors=recursive_generate_docxm_map($base_directory,$source_directory);
    load_docxm_map();
    generate_docxm_map_xml();
    if($errors){
      log_status("Modu≥y mogπ znajdowaÊ siÍ najwyøej 3 katalogi (podrozdzia≥ 2 stopnia) poniøej przetwarzanego katalogu. Przerywam przetwarzanie.",STATUS_ERROR);
      return;
    }
    $stats{'GENEROWANIE_MAPY_IDENTYFIKATOR”W'}=time-$local_start;
    log_status("Mapa identyfikatorÛw dla modu≥Ûw treúci wygenerowana. Czas operacji [s]: ${\($stats{'GENEROWANIE_MAPY_IDENTYFIKATOR”W'}?$stats{'GENEROWANIE_MAPY_IDENTYFIKATOR”W'}:\"poniøej sekundy.\")}",STATUS_INFO) if $debug;
    $local_start=time;
    log_status("Zamiana referencji na klucze identyfikatorÛw w modu≥ach treúci.",STATUS_INFO);
    recursive_correct_rels_in_docxm($base_directory,$source_directory);
    $stats{'ZAMIANA_REFERENCJI_NA_KLUCZE'}=time-$local_start;
    log_status("Referencje zamienione na klucze identyfikatorÛw w modu≥ach treúci. Czas operacji [s]: ${\($stats{'ZAMIANA_REFERENCJI_NA_KLUCZE'}?$stats{'ZAMIANA_REFERENCJI_NA_KLUCZE'}:\"poniøej sekundy.\")}",STATUS_INFO) if $debug;
    mkdir $CONFIG{$PATH_PREVIEW_PDF};
    $local_start=time;
    log_status("Analiza modu≥Ûw treúci.",STATUS_INFO);
    $errors=recursive_process_docxm($base_directory,$source_directory);
    $stats{'ANALIZA_MODU£”W'}=time-$local_start;
    log_status("Modu≥y treúci przeanalizowane. Czas operacji [s]: ${\($stats{'ANALIZA_MODU£”W'}?$stats{'ANALIZA_MODU£”W'}:\"poniøej sekundy.\")}",STATUS_INFO) if $debug;
    $local_start=time;
    log_status("Generowanie indeksu elementÛw s≥ownikowych.",STATUS_INFO);
    $errors+=aggregate_and_check_referencable_elements($base_directory,$source_directory);
    $stats{'GENEROWANIE_INDEKS”W_ELEMENT”W_S£OWNIKOWYCH'}=time-$local_start;
    log_status("Indeks elementÛw s≥ownikowych wygenerowany. Czas operacji [s]: ${\($stats{'GENEROWANIE_INDEKS”W_ELEMENT”W_S£OWNIKOWYCH'}?$stats{'GENEROWANIE_INDEKS”W_ELEMENT”W_S£OWNIKOWYCH'}:\"poniøej sekundy.\")}",STATUS_INFO) if $debug;
    
    $local_start=time;
    log_status("Przetwarzanie modu≥Ûw treúci.",STATUS_INFO);
    $errors+=recursive_process_docxm_DOCBOOK($base_directory,$source_directory);
    $stats{'PRZETWARZANIE_MODU£”W'}=time-$local_start;
    log_status("Modu≥y treúci przetworzone. Czas operacji [s]: ${\($stats{'PRZETWARZANIE_MODU£”W'}?$stats{'PRZETWARZANIE_MODU£”W'}:\"poniøej sekundy.\")}",STATUS_INFO) if $debug;

    $local_start=time;
    log_status("Przetwarzanie s≥ownikÛw.",STATUS_INFO);
    $errors+=generate_glossaries_DOCBOOK($base_directory,$source_directory);
    $stats{'PRZETWARZANIE_S£OWNIK”W'}=time-$local_start;
    log_status("S≥owniki przetworzone. Czas operacji [s]: ${\($stats{'PRZETWARZANIE_S£OWNIK”W'}?$stats{'PRZETWARZANIE_S£OWNIK”W'}:\"poniøej sekundy.\")}",STATUS_INFO) if $debug;
    
    unless($errors){
      $local_start=time;
      log_status("Generowanie formatu XML dla modu≥Ûw treúci.",STATUS_INFO);
      $errors=recursive_process_docxm_EPXML($base_directory,$source_directory);
      $stats{'GENEROWANIE_XML_DLA_MODU£”W'}=time-$local_start;
      log_status("Format XML wygenerowany. Czas operacji [s]: ${\($stats{'GENEROWANIE_XML_DLA_MODU£”W'}?$stats{'GENEROWANIE_XML_DLA_MODU£”W'}:\"poniøej sekundy.\")}",STATUS_INFO) if $debug;
      unless($errors){
	$local_start=time;
	log_status("Generowanie formatu XML dla s≥ownikÛw.",STATUS_INFO);
	$errors+=generate_glossaries_EPXML($base_directory,$source_directory);
	$stats{'GENEROWANIE_XML_DLA_S£OWNIK”W'}=time-$local_start;
	log_status("Format XML dla s≥ownikÛw wygenerowany. Czas operacji [s]: ${\($stats{'GENEROWANIE_XML_DLA_S£OWNIK”W'}?$stats{'GENEROWANIE_XML_DLA_S£OWNIK”W'}:\"poniøej sekundy.\")}",STATUS_INFO) if $debug;	
      	unless($errors){
	    $local_start=time;
	    log_status("Generowanie katalogu dla masowego ≥adowania.",STATUS_INFO);
	    mkdir $CONFIG{$PATH_IMPORT};
	    recursive_prepare_import_tree_entry($base_directory,$source_directory);
	    $stats{'GENEROWANIE_KATALOGU_MASOWEGO_£ADOWANIA'}=time-$local_start;
	    log_status("Katalog dla masowego ≥adowania wygenerowany. Czas operacji [s]: ${\($stats{'GENEROWANIE_KATALOGU_MASOWEGO_£ADOWANIA'}?$stats{'GENEROWANIE_KATALOGU_MASOWEGO_£ADOWANIA'}:\"poniøej sekundy.\")}",STATUS_INFO) if $debug;
	}
      }
    }

    my $end=time;
    log_status("Konwersja zakoÒczona. ".($errors?"Liczba b≥ÍdÛw: $errors. Generacja formatu XML zosta≥a wstrzymana.":"Wygenerowano strukturÍ dla importu w katalogu $CONFIG{$PATH_IMPORT}."),STATUS_INFO);
    if ($debug) {
	log_status("Mapa identyfikatorÛw dla modu≥Ûw treúci wygenerowana. Czas operacji [s]: ${\($stats{'GENEROWANIE_MAPY_IDENTYFIKATOR”W'}?$stats{'GENEROWANIE_MAPY_IDENTYFIKATOR”W'}:\"poniøej sekundy.\")}",STATUS_INFO);
	log_status("Referencje zamienione na klucze identyfikatorÛw w modu≥ach treúci. Czas operacji [s]: ${\($stats{'ZAMIANA_REFERENCJI_NA_KLUCZE'}?$stats{'ZAMIANA_REFERENCJI_NA_KLUCZE'}:\"poniøej sekundy.\")}",STATUS_INFO);
	log_status("Modu≥y treúci przeanalizowane. Czas operacji [s]: ${\($stats{'ANALIZA_MODU£”W'}?$stats{'ANALIZA_MODU£”W'}:\"poniøej sekundy.\")}",STATUS_INFO);
	log_status("Indeks elementÛw s≥ownikowych wygenerowany. Czas operacji [s]: ${\($stats{'GENEROWANIE_INDEKS”W_ELEMENT”W_S£OWNIKOWYCH'}?$stats{'GENEROWANIE_INDEKS”W_ELEMENT”W_S£OWNIKOWYCH'}:\"poniøej sekundy.\")}",STATUS_INFO);
	log_status("Modu≥y treúci przetworzone. Czas operacji [s]: ${\($stats{'PRZETWARZANIE_MODU£”W'}?$stats{'PRZETWARZANIE_MODU£”W'}:\"poniøej sekundy.\")}",STATUS_INFO);
	log_status("S≥owniki przetworzone. Czas operacji [s]: ${\($stats{'PRZETWARZANIE_S£OWNIK”W'}?$stats{'PRZETWARZANIE_S£OWNIK”W'}:\"poniøej sekundy.\")}",STATUS_INFO);
	log_status("Format XML wygenerowany. Czas operacji [s]: ${\($stats{'GENEROWANIE_XML_DLA_MODU£”W'}?$stats{'GENEROWANIE_XML_DLA_MODU£”W'}:\"poniøej sekundy.\")}",STATUS_INFO) if exists $stats{'GENEROWANIE_XML_DLA_MODU£”W'};
	log_status("Format XML dla s≥ownikÛw wygenerowany. Czas operacji [s]: ${\($stats{'GENEROWANIE_XML_DLA_S£OWNIK”W'}?$stats{'GENEROWANIE_XML_DLA_S£OWNIK”W'}:\"poniøej sekundy.\")}",STATUS_INFO) if exists $stats{'GENEROWANIE_XML_DLA_S£OWNIK”W'};
	log_status("Katalog dla masowego ≥adowania wygenerowany. Czas operacji [s]: ${\($stats{'GENEROWANIE_KATALOGU_MASOWEGO_£ADOWANIA'}?$stats{'GENEROWANIE_KATALOGU_MASOWEGO_£ADOWANIA'}:\"poniøej sekundy.\")}",STATUS_INFO) if exists $stats{'GENEROWANIE_KATALOGU_MASOWEGO_£ADOWANIA'};
    }
    log_status("Czas przetwarzania: ".($end - $stats{'START'})." sekund, liczba przetworzonych modu≥Ûw (≥πcznie ze s≥ownikami): $MODULES, liczba wygenerowanych plikÛw podglπdu pdf: $PDFS.",STATUS_INFO);
}

sub UPDATER_update_module{
    my($MODULE_KEY, $MODULE_DATA, $MODULE_PATH)=(shift,shift,shift);

    move(${$MODULE_DATA}{PATH_SOURCE}, $CONFIG{$PATH_UPDATER} = ${$MODULE_DATA}{PATH_INSTALLED} = "$CONFIG{PATH_BASE}/$UPDATER_EXE");
}

sub FOP_update_module{
    my($MODULE_KEY, $MODULE_DATA, $MODULE_PATH)=(shift,shift,shift);

    ${$MODULE_DATA}{PATH_INSTALLED}=$CONFIG{"${MODULE_KEY}_DIR"}=$MODULE_PATH;
    $ENV{'PATH'}="${\(${$MODULE_DATA}{PATH_INSTALLED}=$CONFIG{\"${MODULE_KEY}_DIR\"}=$MODULE_PATH)};$ENV{'PATH'}";
}

sub JEUCLID_update_module{
    my($MODULE_KEY, $MODULE_DATA, $MODULE_PATH)=(shift,shift,shift);

    log_status("Katalog instalacji FOP nie jest zdefiniowany.",STATUS_FATAL) unless exists $CONFIG{"${FOP}_DIR"};

    ${$MODULE_DATA}{PATH_INSTALLED}=install_jeuclid_in_fop($MODULE_PATH,$CONFIG{"${FOP}_DIR"});
    remove_tree($MODULE_PATH);
}

sub FOP_UPDATE_update_module{
    my($MODULE_KEY, $MODULE_DATA, $MODULE_PATH)=(shift,shift,shift);

    mkdir($MODULE_PATH);
    extract_zip(${$MODULE_DATA}{PATH_SOURCE},$MODULE_PATH,"-p$zip_password");
    log_status("Dostosowanie pakietu DOCBOOK_XSL.",STATUS_INFO);

    my($LOGO_SRC_PATH, $LOGO_TARGET_PATH)=("$MODULE_PATH/$LOGO_FILENAME","$CONFIG{PATH_BASE}/$LOGO_FILENAME");

    ${$CONFIG{$TOKENS}}{$LOGO}=$LOGO_TARGET_PATH;

    my($DOCBOOK_XSL_DIR_SRC_PATH)=("$MODULE_PATH/$DOCBOOK_XSL_DIRNAME");

    replace_tokens_in_dir($DOCBOOK_XSL_DIR_SRC_PATH);

    log_status("Dostosowanie konfiguracji FOP.",STATUS_INFO);
    check_fonts($CONFIG{PATH_WINDOWS_FONTS});

    ${$CONFIG{$TOKENS}}{PATH_WINDOWS_FONTS}="file:///$CONFIG{PATH_WINDOWS_FONTS}";

    my($FOP_DIR_SRC_PATH, $FOP_DIR_TARGET_PATH)=("$MODULE_PATH/$FOP_FONTS_DIRNAME","$CONFIG{PATH_BASE}/$FOP_FONTS_DIRNAME");

    ${$CONFIG{$TOKENS}}{$FOP_FONTS_DIR}="file:///$FOP_DIR_TARGET_PATH";

    replace_tokens_in_dir("$MODULE_PATH/$FOP_FONTS_DIRNAME");

    log_status("Instalacja modu≥u.",STATUS_INFO);

    move($LOGO_SRC_PATH, $LOGO_TARGET_PATH);
    dircopy("$DOCBOOK_XSL_DIR_SRC_PATH",$CONFIG{"${DOCBOOK_XSL}_DIR"});
    dircopy($FOP_DIR_SRC_PATH, $FOP_DIR_TARGET_PATH);

    ${$MODULE_DATA}{PATH_INSTALLED}={
        $FOP_XCONF=>$CONFIG{$PATH_FOP_XCONF}="$FOP_DIR_TARGET_PATH/$FOP_XCONF",
        $DIRS=>{
            $FOP_DIR_TARGET_PATH=>dir_index($FOP_DIR_SRC_PATH),
            $CONFIG{"${DOCBOOK_XSL}_DIR"}=>dir_index($DOCBOOK_XSL_DIR_SRC_PATH),
        },
    };

    remove_tree($MODULE_PATH);
}

sub OOXML2DOCBOOK_update_module{
    my($MODULE_KEY, $MODULE_DATA, $MODULE_PATH)=(shift,shift,shift);

    my($tmp_file)="${$MODULE_DATA}{PATH_SOURCE}.tmp";

    save_file($tmp_file,decrypt($CONFIG{RCIPHER},load_file(${$MODULE_DATA}{PATH_SOURCE})));

    ${$CONFIG{$TOKENS}}{$OMML2MML_XSLT}=resolve_OMML2MML_XSLT($CONFIG{PATH_MS_WORD});

    replace_tokens_in_file($tmp_file);

    move($tmp_file, $CONFIG{$PATH_OOXML2DOCBOOK_XSLT} = ${$MODULE_DATA}{PATH_INSTALLED} = "$CONFIG{PATH_BASE}/$OOXML2DOCBOOK_XSLT");
}

sub CORE_CURRICULUM_MAP_update_module{
    my($MODULE_KEY, $MODULE_DATA, $MODULE_PATH)=(shift,shift,shift);

    save_file($CONFIG{$PATH_CORE_CURRICULUM_MAP_XML} = ${$MODULE_DATA}{PATH_INSTALLED} = "$CONFIG{PATH_BASE}/$CORE_CURRICULUM_MAP_XML", decrypt($CONFIG{RCIPHER},load_file(${$MODULE_DATA}{PATH_SOURCE})));
}

sub XSLT_PACKAGE_update_module{
    my($MODULE_KEY, $MODULE_DATA, $MODULE_PATH)=(shift,shift,shift);

    ${$MODULE_DATA}{PATH_INSTALLED} = "$CONFIG{PATH_BASE}/$XSLT_PACKAGE_DIRNAME";
    mkdir(${$MODULE_DATA}{PATH_INSTALLED});
    $CONFIG{$PATH_CHECK_REFERENCABLE_XSLT} = "${$MODULE_DATA}{PATH_INSTALLED}/$CHECK_REFERENCABLE_XSLT";
    $CONFIG{$PATH_GENERATE_GLOSSARIES_XSLT} = "${$MODULE_DATA}{PATH_INSTALLED}/$GENERATE_GLOSSARIES_XSLT";
    extract_zip(${$MODULE_DATA}{PATH_SOURCE}, ${$MODULE_DATA}{PATH_INSTALLED},"-p$zip_password");
}

sub check_cwd{
    my $cwd=getcwd();
    log_status("åcieøka do katalogu z ktÛrego uruchomiono konwerter zawiera litery diakrytyzowane, co moøe powodowaÊ problemy w trakcie dzia≥ania! ProszÍ o przeniesienie konwertera do innej lokalizacji i ponowne uruchomienie.",STATUS_FATAL) if $cwd=~/[πÊÍ≥ÒÛúüø•∆ £—”åèØ]/i;
}

sub get_INIT_ref{
    my($MODULE_KEY)=shift;
    ${$INIT{INIT_INSTALLED}}{$MODULE_KEY};
}

sub reduce_directory_level{
    my($directory)=shift;
    opendir DH, $directory or log_status("Nie moøna uzyskaÊ dostÍpu do katalogu $directory ($!).",STATUS_FATAL);
    my @files = readdir DH;
    closedir DH;
    for my $file (@files){
        next if $file=~/^\.$/;
        next if $file=~/^\.\.$/;
        next unless -d "$directory/$file";
        opendir DH, "$directory/$file" or log_status("Nie moøna uzyskaÊ dostÍpu do katalogu $directory/$file ($!).",STATUS_FATAL);
        my @subfiles = readdir DH;
        closedir DH;
        for my $subfile (@subfiles){
            next if $subfile=~m/^\.$/;
            next if $subfile=~m/^\..$/;
            move("$directory/$file/$subfile","$directory/$subfile");
        }
        remove_tree("$directory/$file");
    }
}

sub dir_index{
    my($directory,$tore)=(shift,[]);
    opendir DH, $directory or log_status("Nie moøna uzyskaÊ dostÍpu do katalogu $directory ($!).",STATUS_FATAL);
    my @files = readdir DH;
    closedir DH;
    for my $file (@files){
        next if $file=~/^\.$/;
        next if $file=~/^\.\.$/;
        push @$tore, (-d "$directory/$file"?{$file=>dir_index("$directory/$file")}:$file);
    }
    $tore;
}

sub install_jeuclid_in_fop{
  my ($jeuclid_dir, $fop_dir)=(shift,shift);

  return 0 if(-e "$fop_dir/lib/jeuclid-core-3.1.9.jar" && -e "$fop_dir/lib/jeuclid-fop-3.1.9.jar");

  log_status("Instalacja JEUCLID w FOP.",STATUS_INFO);

  copy("$jeuclid_dir/repo/jeuclid-core-3.1.9.jar","$fop_dir/lib/jeuclid-core-3.1.9.jar");
  copy("$jeuclid_dir/repo/jeuclid-fop-3.1.9.jar","$fop_dir/lib/jeuclid-fop-3.1.9.jar");

  ["$fop_dir/lib/jeuclid-core-3.1.9.jar","$fop_dir/lib/jeuclid-fop-3.1.9.jar"];
}

sub resolve_OMML2MML_XSLT{
  my($MSWORD_DIR)=(shift);

  -e "$MSWORD_DIR/$OMML2MML_XSLT" ? "file:///$MSWORD_DIR/$OMML2MML_XSLT" : log_status("Nie moøna znaleüÊ pliku $OMML2MML_XSLT w katalogu $MSWORD_DIR. ProszÍ sprawdziÊ konfiguracjÍ.",STATUS_FATAL);
}

sub check_fonts{
  my($WINDOWS_FONT_DIR)=(shift);

  for(@FOP_FONTS){
    -e "$WINDOWS_FONT_DIR/$_" || log_status("Nie moøna odnaleüÊ pliku z czcionkπ $_ w katalogu $WINDOWS_FONT_DIR${\(-d $WINDOWS_FONT_DIR ? '':'. '.$WINDOWS_FONT_DIR.' nie istnieje lub nie jest katalogiem')}. ProszÍ sprawdziÊ konfiguracjÍ.",STATUS_FATAL);
  }
}

sub replace_tokens_in_dir{
  my($dir)=(shift);

  (-d $_ ? replace_tokens_in_dir($_) : replace_tokens_in_file($_)) for glob ($dir=~/\s/ ? "'$dir/*'" : "$dir/*");
}

sub replace_tokens_in_file{
  my($file)=(shift);

  my $data=load_file($file);

  $data=~s/{{([^}]+)}}/${$CONFIG{$TOKENS}}{$1}/g;

  save_file($file, $data);
}

sub recursive_generate_docxm_map{
  my($base_directory, $input_directory)=(shift,shift);

  my($relative_directory)=$input_directory;
  $relative_directory=~s#^$base_directory/##;
  my($unprocessed_relative_directory)=$relative_directory;
  $relative_directory=~s#[^a-zA-Z0-9/]#_#g;

  save_docxm_map();
  load_docxm_map();

  my $errors=0;

  for my $filename (glob ($input_directory=~/\s/ ? "'$input_directory/*.doc[xm]'" : "$input_directory/*.doc[xm]")){
    next if $filename=~m#/~\$#;
    my $key="file:///$filename";
    $key=~s/ /%20/g;
    $key=tr_key($key);
    $errors+=generate_module_ids($filename,"$CONFIG{PATH_DATA}/$relative_directory",$key,calculate_directory_depth($relative_directory),$unprocessed_relative_directory);
  }

  save_docxm_map();
  for(glob ($input_directory=~/\s/ ? "'$input_directory/*'" : "$input_directory/*")){
    next if /\/$PREVIEW_PDF_DIRNAME$/;
    next if /\/$IMPORT_DIRNAME$/;
    $errors+=recursive_generate_docxm_map($base_directory,$_) if -d $_;
  }
  $errors;
}

sub generate_module_ids{
    my($input_file,$directory,$key,$directory_depth,$unprocessed_relative_directory)=(shift,shift,shift,shift,shift);

    $input_file=~/^(.*\/)(.*)$/;
    my($input_file_path,$input_file_name)=($1,$2);

    log_details("Generowanie mapy identyfikatorÛw dla modu≥u treúci.",STATUS_INFO,$input_file_name,$input_file_path);

    my($dirname)=$input_file_name;
    $dirname=~s/[^a-zA-Z0-9]/_/g;

    my $working_path="$directory/$dirname";
    $dirname=~/_([^_]+)$/;
    my $docxm_working_path="$working_path/$1";

    extract_docxm($input_file, $docxm_working_path);

    my $data=load_file_utf_8("$docxm_working_path/word/document.xml");

    my %ENTRY=();
    $DOCXM_MAP{$key}=\%ENTRY;
    $ENTRY{$DOCXM_FILE_ID}=generate_id("$input_file");
    $ENTRY{$DOCXM_FILE_DEPTH}=$directory_depth;
    $ENTRY{$DOCXM_PDF_IN_TREE_RUNAWAY_PREFIX}=('../' x $directory_depth).$PREVIEW_PDF_DIRNAME;
    $ENTRY{$DOCXM_BOOKMARKS}=();
    $ENTRY{$DOCXM_WORKING_PATH}=$working_path;
    my @chapters=map {s/^\d+_//;decode('cp1250',$_)} split /\//, $unprocessed_relative_directory, -1;
    shift @chapters;
    $ENTRY{$DOCXM_CHAPTERS}=\@chapters;
    while($data=~m#<w:bookmarkStart w:id="\d+" w:name="([^"]+)"/>#){
        my $anchor=$1;
        $data=$';
        ${$ENTRY{$DOCXM_BOOKMARKS}}{$anchor}=generate_id("$input_file#".encode('CP1250', $anchor)) unless $anchor=~/^_GoBack$/;
    }
    (3 < $directory_depth ? 1 : 0);
}

sub generate_id{
    my ($path)=shift;
    my ($id) = md5_base64($path.time);
    $id=~s#[+/=]##g;
    $id=~s/^(.{9}).*$/i$1/;
    $id;
}

sub calculate_directory_depth{
    my($relative_directory)=(shift);

    scalar(()=split /\//, $relative_directory, -1)-1;
}

sub recursive_correct_rels_in_docxm{
  my($base_directory, $input_directory)=(shift,shift);

  my($relative_directory)=$input_directory;
  $relative_directory=~s#^$base_directory/##;
  $relative_directory=~s#[^a-zA-Z0-9/]#_#g;

  for my $filename (glob ($input_directory=~/\s/ ? "'$input_directory/*.doc[xm]'" : "$input_directory/*.doc[xm]")){
    next if $filename=~m#/~\$#;
    my $key="file:///$filename";
    $key=~s/ /%20/g;
    $key=tr_key($key);
    correct_rels_in_docxm($filename,"$CONFIG{PATH_DATA}/$relative_directory",$key,$base_directory);
  }

  for(glob ($input_directory=~/\s/ ? "'$input_directory/*'" : "$input_directory/*")){
    next if /\/$PREVIEW_PDF_DIRNAME$/;
    next if /\/$IMPORT_DIRNAME$/;
    recursive_correct_rels_in_docxm($base_directory,$_) if -d $_;
  }
}

sub correct_rels_in_docxm{
    my($input_file,$directory,$key)=(shift,shift,shift);

    $input_file=~/^(.*\/)(.*)$/;
    my($input_file_path,$input_file_name)=($1,$2);

    log_details("Zamiana referencji na klucze identyfikatorÛw dla modu≥u treúci.",STATUS_INFO,$input_file_name,$input_file_path);

    my($dirname)=$input_file_name;
    $dirname=~s/[^a-zA-Z0-9]/_/g;

    my $working_path="$directory/$dirname";
    $dirname=~/_([^_]+)$/;
    my $docxm_working_path="$working_path/$1";

    my $data=load_file_utf_8("$docxm_working_path/word/_rels/document.xml.rels");

    my %ID_MAP=();
    while($data=~m#<Relationship Id="([^"]+)" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink" Target="([^"]+.doc[xm])" TargetMode="External"/>#){
        $ID_MAP{$1}=tr_key(make_path_absolute(encode('cp1250',$2),$input_file_path));
        $data=$';
    }
    $data=load_file("$docxm_working_path/word/_rels/document.xml.rels");
    $data=~s#<Relationship Id="([^"]+)" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink" Target="[^"]+.doc[xm]" TargetMode="External"/>#<Relationship Id="$1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink" Target="$ID_MAP{$1}" TargetMode="External"/>#g;
    save_file("$docxm_working_path/word/_rels/document.xml.rels",$data);
}

sub make_path_absolute{
  my($file, $context_path)=(shift,shift);
  return $file if ($file=~m#^((https?|ftp)://|mailto:)#);

  if($file=~/^\.\./){
    my @link_parts=split /\//, $file, -1;
    my @context_parts=split /\//, $context_path, -1;
    pop @context_parts;
    shift @link_parts and pop @context_parts while $link_parts[0] eq '..';
    $file=join '\\', 'file://', @context_parts, @link_parts;
  }elsif($file!~m#^file:///#){
    $file="file:///$context_path$file";
  }elsif($file=~m#^file:///#){
    $file=~s#^file:///(.)#file:///${\(lc($1))}#;
  }

  $file=~s#\\#/#g;
  $file=~s#\s#%20#g;
  tr_pc($file);
}

sub save_docxm_map{
    save_config($CONFIG{$PATH_DOCXM_MAP_CFG},'DOCXM_MAP',\%DOCXM_MAP);
}

sub load_docxm_map{
    load_config($CONFIG{$PATH_DOCXM_MAP_CFG},"Nie moøna przetworzyÊ mapy modu≥Ûw treúci.");
}

sub generate_docxm_map_xml{
  my $data="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<docxm_map>";

  for my $filename (sort {${$DOCXM_MAP{$a}}{$DOCXM_FILE_ID} cmp ${$DOCXM_MAP{$b}}{$DOCXM_FILE_ID}} keys %DOCXM_MAP){
    $data.="\n\t<entry>\n\t\t<filename>$filename</filename>\n\t\t<working_path>${$DOCXM_MAP{$filename}}{$DOCXM_WORKING_PATH}</working_path>\n\t\t<id>${$DOCXM_MAP{$filename}}{$DOCXM_FILE_ID}</id>\n\t\t<depth>${$DOCXM_MAP{$filename}}{$DOCXM_FILE_DEPTH}</depth>\n\t\t<ra_prefix>${$DOCXM_MAP{$filename}}{$DOCXM_PDF_IN_TREE_RUNAWAY_PREFIX}</ra_prefix>";
    if(@{${$DOCXM_MAP{$filename}}{$DOCXM_CHAPTERS}}){
      $data.="\n\t\t<chapters>";
      $data.="\n\t\t\t<chapter>$_</chapter>" for @{${$DOCXM_MAP{$filename}}{$DOCXM_CHAPTERS}};
      $data.="\n\t\t</chapters>";
    }
    $data.="\n\t\t<bookmark>\n\t\t\t<name>$_</name>\n\t\t\t<id>${${$DOCXM_MAP{$filename}}{$DOCXM_BOOKMARKS}}{$_}</id>\n\t\t</bookmark>" for(sort {${${$DOCXM_MAP{$filename}}{$DOCXM_BOOKMARKS}}{$a} cmp ${${$DOCXM_MAP{$filename}}{$DOCXM_BOOKMARKS}}{$b}} keys %{${$DOCXM_MAP{$filename}}{$DOCXM_BOOKMARKS}});
    $data.="\n\t</entry>";
  }

  $data.="\n</docxm_map>";
  save_file_utf_8($CONFIG{$PATH_DOCXM_MAP_XML},$data);
}

sub aggregate_and_check_referencable_elements{
  my $data="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<referencable>";

  for my $filename (sort {${$DOCXM_MAP{$a}}{$DOCXM_FILE_ID} cmp ${$DOCXM_MAP{$b}}{$DOCXM_FILE_ID}} keys %DOCXM_MAP){
    $data.="\n\t<module>\n\t\t<id>${$DOCXM_MAP{$filename}}{$DOCXM_FILE_ID}</id>\n\t\t<working_path>${$DOCXM_MAP{$filename}}{$DOCXM_WORKING_PATH}</working_path>";
    $data.=load_referencable_elements(${$DOCXM_MAP{$filename}}{$DOCXM_WORKING_PATH});
    $data.="\t</module>";
  }

  $data.="\n</referencable>";
  save_file_utf_8($CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_XML},$data);
  
  log_status("Analiza indeksu elementÛw s≥ownikowych pod kπtem duplikatÛw.",STATUS_INFO);

  my $xslt_log_path="$CONFIG{PATH_BASE}/check_referencable.log";

  my $xslt_output = apply_xslt($CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_XML},$CONFIG{$PATH_CHECK_REFERENCABLE_XSLT},$CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_TMP_XML},"");
  save_file($xslt_log_path, $xslt_output);
  
  if (-e $CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_TMP_XML} and not(-z $CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_TMP_XML})) {
    copy($CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_TMP_XML},"$CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_TMP_XML}.bak");
    move($CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_TMP_XML},$CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_XML});
    0;
  }else{
    log_status("Analiza indeksu elementÛw s≥ownikowych pod kπtem duplikatÛw nie powiod≥a siÍ.",STATUS_ERROR);
    1;
  }
}

sub generate_glossaries_DOCBOOK{
    my($base_directory, $input_directory)=(shift,shift);
    my($errors, $number)=(0,1);  
    foreach('glossary','concept','biography','event','bibliography'){
	$errors+=generate_glossary_DOCBOOK($base_directory,$input_directory,$_,$number);
	++$number;
    }
    $errors;
}

sub generate_glossary_DOCBOOK{
    my($base_directory, $input_directory, $type, $number)=(shift,shift,shift,shift);
    
    my($filename_prefix,$input_directory_path)=("_ep_glossary_${number}_${type}","$input_directory/");
 
    log_details("Przetwarzam s≥ownik.",STATUS_INFO,"$filename_prefix.docx",$input_directory_path);
    
    my $xslt_log_path="$CONFIG{PATH_BASE}/${filename_prefix}_docbook.log";
    my $fop_log_path="$CONFIG{PATH_BASE}/${filename_prefix}_fop.log";
    my $xslt_output_file="${filename_prefix}_docbook.xml";
    my $xslt_output_path="$CONFIG{PATH_BASE}/$xslt_output_file";
    my $output_pdf_file="$type.pdf";
    my $output_pdf_file_2="${filename_prefix}_x.pdf";
    my $glossary_target_path="$CONFIG{$PATH_PREVIEW_PDF}/$output_pdf_file";
    unlink $glossary_target_path if -e $glossary_target_path;

    my $xslt_output = apply_xslt($CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_XML},$CONFIG{$PATH_GENERATE_GLOSSARIES_XSLT},$xslt_output_path,"mode=DOCBOOK type=$type");
    save_file($xslt_log_path, $xslt_output);
    
    if (-e $xslt_output_path and not(-z $xslt_output_path) and $xslt_output!~m/Transformation failed:/) {
	my ($no_of_entries, $entries)=(0,'');
	while($xslt_output=~/^EPK_ENTRY;;;(.*)$/m){
	    ++$no_of_entries;
	    $entries.=$1;
	    $xslt_output=$';
	}
	++$MODULES if($no_of_entries);
	if($NOPDF){
	    log_details("Generacja podglπdu pdf dla s≥ownikÛw wstrzymana.",STATUS_DONE,"$filename_prefix.docx",$input_directory_path);
	}elsif(0==$no_of_entries){
	    log_details("Brak hase≥ w s≥owniku - generacja podglπdu pdf wstrzymana.",STATUS_DONE,"$filename_prefix.docx",$input_directory_path);
	}else{
	    log_details("Generowanie plik podglπdu pdf dla s≥ownika.",STATUS_INFO,"$filename_prefix.docx",$input_directory_path);
	    my $fop_output = apply_fo("$xslt_output_path",$glossary_target_path);

	    move($xslt_output_path,"${xslt_output_path}.bak") if -e $xslt_output_path;

	    my $pdf_error=0;
	    if ($fop_output=~/java.io.FileNotFoundException:\s*(.*)$/m) {
	      $pdf_error=1;
	      log_details("Wygenerowanie pliku pdf nie by≥o moøliwe. B≥πd: $1.",STATUS_ERROR,"$filename_prefix.docx",$input_directory_path);
	    }elsif($fop_output=~/SEVERE: Exception.(.*?)\s+at\s+/s){
	      $pdf_error=1;
	      log_details("Wygenerowanie pliku pdf nie by≥o moøliwe. B≥πd: $1.",STATUS_ERROR,"$filename_prefix.docx",$input_directory_path);
	    }
	    unless($pdf_error){
	      copy($glossary_target_path,"$input_directory/$output_pdf_file_2");
	      log_details("Plik podglπdu pdf dla s≥ownika wygenerowany.",STATUS_INFO,"$filename_prefix.docx",$input_directory_path);
	    }else{
	      log_details("Wygenerowanie pliku podglπdu nie powiod≥o siÍ.",STATUS_INFO,"$filename_prefix.docx",$input_directory_path);
	    }
	    save_file($fop_log_path, $fop_output);
	}
	0;
    }else{
	log_details("Transformacja XSLT nie powiod≥a siÍ.",STATUS_ERROR,"$filename_prefix.docx",$input_directory_path);
	1;
    }    
}

sub generate_glossaries_EPXML{
    my($base_directory, $input_directory)=(shift,shift);
    my($errors, $number)=(0,1);
    foreach('glossary','concept','biography','event','bibliography'){
	$errors+=generate_glossary_EPXML($base_directory,$input_directory,$_,$number);
	++$number;
    }
    $errors;
}

sub generate_glossary_EPXML{
    my($base_directory, $input_directory, $type, $number)=(shift,shift,shift,shift);
 
    my($filename_prefix,$input_directory_path)=("_ep_glossary_${number}_${type}","$input_directory/");
    
    log_details("GenerujÍ s≥ownik.",STATUS_INFO,"$filename_prefix.docx",$input_directory_path);
    
    my $xslt_log_path="$CONFIG{PATH_BASE}/${filename_prefix}_epxml.log";
    my $xslt_output_file="${filename_prefix}.xml";
    my $xslt_output_path="$CONFIG{PATH_BASE}/$xslt_output_file";
    my $glossary_target_path="$input_directory/$xslt_output_file";
    my $id=generate_id("$glossary_target_path");

    my $xslt_output = apply_xslt($CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_XML},$CONFIG{$PATH_GENERATE_GLOSSARIES_XSLT},$xslt_output_path,"mode=EPXML type=$type id=$id");
    save_file($xslt_log_path, $xslt_output);
    
    if (-e $xslt_output_path and not(-z $xslt_output_path) and $xslt_output!~m/Transformation failed:/) {
	my ($no_of_entries, $entries)=(0,'');
	while($xslt_output=~/^EPK_ENTRY;;;(.*)$/m){
	    ++$no_of_entries;
	    $entries.=$1;
	    $xslt_output=$';
	}
	unless($no_of_entries){
	    log_details("Generacja s≥ownika zakoÒczona, lecz w s≥owniku nie znalaz≥o siÍ øadne has≥o - pomijam.",STATUS_DONE,"$filename_prefix.docx",$input_directory_path);
	}else{
	    log_details("S≥ownik wygenerowany.",STATUS_DONE,"$filename_prefix.docx",$input_directory_path);
	    copy($xslt_output_path, $glossary_target_path);
	}
	0;
    }else{
	log_details("Wygenerowanie s≥ownika nie powiod≥o siÍ.",STATUS_ERROR,"$filename_prefix.docx",$input_directory_path);
	1;
    }    
}

sub load_referencable_elements{
  my($docxm_working_dir)=(shift);
  
  my $referencable_elements_file="$docxm_working_dir/$REFERENCABLE_ELEMENTS_XML";
  
  if (-e $referencable_elements_file) {
    my $data=load_file_utf_8($referencable_elements_file);
    $data=~m#<referencable>(.*)</referencable>#gs;
    $1;
  }else{
    return "\n\t\t<error>Can't load: $referencable_elements_file</error>";
  }
}

sub recursive_process_docxm{
  my($base_directory, $input_directory)=(shift,shift);

  my($relative_directory)=$input_directory;
  $relative_directory=~s#^$base_directory/##;
  $relative_directory=~s#[^a-zA-Z0-9/]#_#g;

  my($errors)=0;
  $errors+=process_docxm($_,"$CONFIG{PATH_DATA}/$relative_directory") for glob ($input_directory=~/\s/ ? "'$input_directory/*.doc[xm]'" : "$input_directory/*.doc[xm]");
  for(glob ($input_directory=~/\s/ ? "'$input_directory/*'" : "$input_directory/*")){
    next if /\/$PREVIEW_PDF_DIRNAME$/;
    next if /\/$IMPORT_DIRNAME$/;
    $errors+=recursive_process_docxm($base_directory, $_) if -d $_;
  }
  $errors;
}

sub process_docxm{
  my($input_file,$directory)=(shift,shift);

  $input_file=~/^(.*\/)(.*)$/;
  my($input_file_path,$input_file_name)=($1,$2);

  return 0 if $input_file_name=~m#^~\$#;
  ++$MODULES;
  log_details("AnalizujÍ modu≥ treúci.",STATUS_INFO,$input_file_name,$input_file_path);

  my($dirname)=$input_file_name;
  $dirname=~s/[^a-zA-Z0-9]/_/g;

  my $working_path="$directory/$dirname";
  $dirname=~/_([^_]+)$/;
  my $docxm_working_path="$working_path/$1";
  my $xslt_output_path="$working_path/ooxml2model.xml";
  my $xslt_log_path="$working_path/ooxml2model.log";

  my $docxm_name="file:///$input_file";
  $docxm_name=~s/ /%20/g;
  $docxm_name=tr_key($docxm_name);

  my $xslt_output = apply_xslt("$docxm_working_path/word/document.xml",$CONFIG{$PATH_OOXML2DOCBOOK_XSLT},"$xslt_output_path",
  "docxm_name=$docxm_name core_curriculum_map_path=file:///$CONFIG{$PATH_CORE_CURRICULUM_MAP_XML} docxm_map_path=file:///$CONFIG{$PATH_DOCXM_MAP_XML} docxm_working_dir_path=file:///$docxm_working_path docxm_processing_mode=MODEL"
  );
  save_file($xslt_log_path, $xslt_output);

  my ($errors, $messages)=(0, '');
  while($xslt_output=~/^EPK_STATUS_(ERROR|WARN);;;(.*)$/m){
    ++$errors;
    $messages.=$2;
    $xslt_output=$';
  }
  unless(-e $xslt_output_path){
    log_details("Analiza pliku nie powiod≥a siÍ.",STATUS_ERROR,$input_file_name,$input_file_path);
    return 1;
  }
  unlink $xslt_output_path;
  $errors && log_details("W trakcie analizy wykryto problemy. WiÍcej informacji znajdzie siÍ w pliku podglπdu.",STATUS_ERROR,$input_file_name,$input_file_path);
  $errors || log_details("Analiza przebieg≥a pomyúlnie.",STATUS_INFO,$input_file_name,$input_file_path);
  $errors;
}

sub recursive_process_docxm_DOCBOOK{
  my($base_directory, $input_directory)=(shift,shift);

  my($relative_directory)=$input_directory;
  $relative_directory=~s#^$base_directory/##;
  $relative_directory=~s#[^a-zA-Z0-9/]#_#g;

  my($errors)=0;
  $errors+=process_docxm_DOCBOOK($_,"$CONFIG{PATH_DATA}/$relative_directory") for glob ($input_directory=~/\s/ ? "'$input_directory/*.doc[xm]'" : "$input_directory/*.doc[xm]");
  for(glob ($input_directory=~/\s/ ? "'$input_directory/*'" : "$input_directory/*")){
    next if /\/$PREVIEW_PDF_DIRNAME$/;
    next if /\/$IMPORT_DIRNAME$/;
    $errors+=recursive_process_docxm_DOCBOOK($base_directory, $_) if -d $_;
  }
  $errors;
}

sub process_docxm_DOCBOOK{
  my($input_file,$directory)=(shift,shift);

  $input_file=~/^(.*\/)(.*)$/;
  my($input_file_path,$input_file_name)=($1,$2);

  return 0 if $input_file_name=~m#^~\$#;
  log_details("Przetwarzanie modu≥ treúci.",STATUS_INFO,$input_file_name,$input_file_path);

  my($dirname)=$input_file_name;
  $dirname=~s/[^a-zA-Z0-9]/_/g;

  my $working_path="$directory/$dirname";
  $dirname=~/_([^_]+)$/;
  my $docxm_working_path="$working_path/$1";
  my $xslt_output_path="$working_path/ooxml2docbook.xml";
  my $xslt_log_path="$working_path/ooxml2docbook.log";
  my $fop_log_path="$working_path/fop.log";

  my $docxm_name="file:///$input_file";
  $docxm_name=~s/ /%20/g;
  $docxm_name=tr_key($docxm_name);

  log_details("Transformacja XSLT.",STATUS_INFO,$input_file_name,$input_file_path);
  my $xslt_output = apply_xslt("$docxm_working_path/word/document.xml",$CONFIG{$PATH_OOXML2DOCBOOK_XSLT},"$xslt_output_path",
  "docxm_name=$docxm_name core_curriculum_map_path=file:///$CONFIG{$PATH_CORE_CURRICULUM_MAP_XML} docxm_map_path=file:///$CONFIG{$PATH_DOCXM_MAP_XML} aggregated_referencable_elements_path=file:///$CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_XML} docxm_working_dir_path=file:///$docxm_working_path docxm_processing_mode=DOCBOOK"
  );
  save_file($xslt_log_path, $xslt_output);

  my ($errors, $messages)=(0, '');
  while($xslt_output=~/^EPK_STATUS_(ERROR|WARN);;;(.*)$/m){
    ++$errors;
    $messages.=$2;
    $xslt_output=$';
  }
  unless(-e $xslt_output_path){
    log_details("Transformacja XSLT nie powiod≥a siÍ.",STATUS_ERROR,$input_file_name,$input_file_path);
    return 1;
  }
  my $pdf_file=$input_file;
  $pdf_file=~s/\.doc([xm])$/_$1.pdf/;
  unlink $pdf_file if -e $pdf_file;

  if ($errors || !$NOPDF) {  
      my $correct_data=load_file($xslt_output_path);
      $correct_data=~s#</(citation|emphasis|foreignphrase|su(perscript|bscript))>\s*<\1>##sg;
      $correct_data=~s#<(citation|emphasis|foreignphrase|su(perscript|bscript))>(\s*)</\1>#$1#sg;
      save_file($xslt_output_path, $correct_data);
      log_details("Generowanie plik podglπdu pdf.",STATUS_INFO,$input_file_name,$input_file_path);
    
      my $fop_output = apply_fo("$xslt_output_path",$pdf_file);
      if (!$NOPDF) {
        my $pdf_file_2="$CONFIG{$PATH_PREVIEW_PDF}/${$DOCXM_MAP{$docxm_name}}{$DOCXM_FILE_ID}.pdf";
        $correct_data=load_file($xslt_output_path);
        $correct_data=~s#"(\.\./)*_ep_pdf/#"#sg;
        save_file($xslt_output_path, $correct_data);
        my $fop_output_2 = apply_fo("$xslt_output_path",$pdf_file_2);
      }
      move($xslt_output_path,"${xslt_output_path}.bak") if -e $xslt_output_path;
      my $pdf_error=0;
      if ($fop_output=~/java.io.FileNotFoundException:\s*(.*)$/m) {
        $pdf_error=1;
        log_details("Wygenerowanie pliku pdf nie by≥o moøliwe. B≥πd: $1.",STATUS_ERROR,$input_file_name,$input_file_path);
      }elsif($fop_output=~/SEVERE: Exception.(.*?)\s+at\s+/s){
        $pdf_error=1;
        log_details("Wygenerowanie pliku pdf nie by≥o moøliwe. B≥πd: $1.",STATUS_ERROR,$input_file_name,$input_file_path);
      }
      unless($pdf_error){
        $errors && log_details("W trakcie konwersji wystπpi≥y problemy. WiÍcej informacji znajduje siÍ w pliku podglπdu.",STATUS_ERROR,$input_file_name,$input_file_path);
        $errors || log_details("Konwersja przebieg≥a pomyúlnie.",STATUS_INFO,$input_file_name,$input_file_path);
      }else{
        $errors && log_details("W trakcie konwersji wystπpi≥y problemy. Wygenerowanie pliku podglπdu nie powiod≥o siÍ.",STATUS_ERROR,$input_file_name,$input_file_path);
        $errors || log_details("Konwersja przebieg≥a pomyúlnie, lecz wygenerowanie pliku podglπdu nie powiod≥o siÍ.",STATUS_INFO,$input_file_name,$input_file_path);
      }
      save_file($fop_log_path, $fop_output);
  }else{
    log_details("Konwersja przebieg≥a pomyúlnie, wygenerowanie pliku podglπdu pdf wstrzymane.",STATUS_INFO,$input_file_name,$input_file_path);
  }
  $errors;
}

sub recursive_process_docxm_EPXML{
  my($base_directory, $input_directory)=(shift,shift);

  my($relative_directory)=$input_directory;
  $relative_directory=~s#^$base_directory/##;
  $relative_directory=~s#[^a-zA-Z0-9/]#_#g;

  my($errors)=0;
  $errors+=process_docxm_EPXML($_,"$CONFIG{PATH_DATA}/$relative_directory") for glob ($input_directory=~/\s/ ? "'$input_directory/*.doc[xm]'" : "$input_directory/*.doc[xm]");
  for(glob ($input_directory=~/\s/ ? "'$input_directory/*'" : "$input_directory/*")){
    next if /\/$PREVIEW_PDF_DIRNAME$/;
    next if /\/$IMPORT_DIRNAME$/;
    $errors+=recursive_process_docxm_EPXML($base_directory, $_) if -d $_;
  }
  $errors;
}

sub process_docxm_EPXML{
  my($input_file,$directory)=(shift,shift);

  $input_file=~/^(.*\/)(.*)$/;
  my($input_file_path,$input_file_name)=($1,$2);

  return 0 if $input_file_name=~m#^~\$#;

  my($dirname)=$input_file_name;
  $dirname=~s/[^a-zA-Z0-9]/_/g;

  my $working_path="$directory/$dirname";
  $dirname=~/_([^_]+)$/;
  my $docxm_working_path="$working_path/$1";
  my $xslt_output_path="$working_path/ooxml2epxml.xml";
  my $xslt_log_path="$working_path/ooxml2epxml.log";

  my $docxm_name="file:///$input_file";
  $docxm_name=~s/ /%20/g;
  $docxm_name=tr_key($docxm_name);
  log_details("Generowanie formatu XML.",STATUS_INFO,$input_file_name,$input_file_path);
  my $xslt_output = apply_xslt("$docxm_working_path/word/document.xml",$CONFIG{$PATH_OOXML2DOCBOOK_XSLT},"$xslt_output_path",
  "docxm_name=$docxm_name core_curriculum_map_path=file:///$CONFIG{$PATH_CORE_CURRICULUM_MAP_XML} docxm_map_path=file:///$CONFIG{$PATH_DOCXM_MAP_XML} aggregated_referencable_elements_path=file:///$CONFIG{$PATH_AGGREGATED_REFERENCABLE_ELEMENTS_XML} docxm_working_dir_path=file:///$docxm_working_path docxm_processing_mode=EPXML"
  );
  save_file($xslt_log_path, $xslt_output);
  my $correct_data=load_file($xslt_output_path);
  $correct_data=~s#xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"##sg;
  $correct_data=~s#<section id="[a-zA-Z0-9_]+"/>\s*<#<#sg;
  $correct_data=~s!<title>[^<]*#REMOVE#[^<]*</title>!!sg;
  $correct_data=~s!\s(</(ep:tooltip-reference|ep:bibliography-reference|ep:glossary-reference|ep:concept-reference|ep:biography-reference|ep:event-reference|link|emphasis|quote|term|foreign)>)!$1 !sg;
  $correct_data=~s!(<(ep:tooltip-reference|ep:bibliography-reference|ep:glossary-reference|ep:concept-reference|ep:biography-reference|ep:event-reference|link|emphasis|quote|term|foreign)[^>]+>)\s! $1!sg;
  $correct_data=~s#(<para.*?</para>)#split_para($1)#sge;

  save_file($xslt_output_path, $correct_data);
  my $epxml_file=$input_file;
  $epxml_file=~s/\.doc([xm])$/_$1.xml/;
  copy("$xslt_output_path",$epxml_file);
  if(-e $epxml_file){
    log_details("Format XML wygenerowany pomyúlnie.",STATUS_DONE,$input_file_name,$input_file_path);
    0;
  }else{
    log_details("Wygenerowanie formatu XML nie powiod≥o siÍ.",STATUS_ERROR,$input_file_name,$input_file_path);
    1;
  }
}

sub recursive_prepare_import_tree_entry{
  my($base_directory, $input_directory)=(shift,shift);

  my($unprocessed_relative_directory)=$input_directory;
  $unprocessed_relative_directory=~s#^$base_directory/##;
  my($publication_name)=split /\//, $unprocessed_relative_directory, -1;
  $CONFIG{$PATH_PUBLICATION}="$CONFIG{$PATH_IMPORT}/$publication_name";
  mkdir($CONFIG{$PATH_PUBLICATION});

  $publication_property{'publication.name'}=$publication_name unless exists $publication_property{'publication.name'};
  $publication_property{$_}=decode('cp1250',$publication_property{$_}) for keys %publication_property;
  save_properties_file_utf_8("$CONFIG{$PATH_PUBLICATION}/publication.properties",\%publication_property);

  my ($no_of_glossaries)=scalar grep {defined $_} glob ($input_directory=~/\s/ ? "'$input_directory/_ep_glossary_*.xml'" : "$input_directory/_ep_glossary_*.xml");
  my ($counter)=recursive_prepare_import_tree($base_directory, $input_directory, {}, $no_of_glossaries);

  my($leading_zeros)=length ($counter+$no_of_glossaries);
  
  for my $file_path (glob ($input_directory=~/\s/ ? "'$input_directory/_ep_glossary_*.xml'" : "$input_directory/_ep_glossary_*.xml")){
    $file_path=~m#.*/(_ep_glossary_.*\.xml)$#;
    my($filename)=$1;
    ++$counter;
    my($dirname)=$CONFIG{$PATH_PUBLICATION}.'/'.sprintf("%0${\($leading_zeros)}d", $counter);
    mkdir($dirname);
    copy($file_path,"$dirname/$filename");
    save_properties_file_utf_8("$dirname/publication.properties",{
	'publication.name'=>get_title_from_epxml($file_path),
	'publication.mainFile'=>$filename,
	'edition.externalId'=>get_id_from_epxml($file_path),
    });
  }
}

sub recursive_prepare_import_tree{
  my($base_directory, $input_directory, $directory_map_ref, $more_elements)=(shift,shift,shift,shift);

  my($unprocessed_relative_directory)=$input_directory;
  $unprocessed_relative_directory=~s#^$base_directory/##;

  my($counter)=$more_elements;
  for(sort glob ($input_directory=~/\s/ ? "'$input_directory/*'" : "$input_directory/*")){
    next if /\/$PREVIEW_PDF_DIRNAME$/;
    next if /\/$IMPORT_DIRNAME$/;
    next unless (-d $_ or /\.doc[xm]$/);
    next if /\/~\$/;
    ++$counter;
  }
  my($leading_zeros)=length $counter;
  $counter=0;
  for(sort glob ($input_directory=~/\s/ ? "'$input_directory/*'" : "$input_directory/*")){
    next if /\/$PREVIEW_PDF_DIRNAME$/;
    next if /\/$IMPORT_DIRNAME$/;
    next unless (-d $_ or /\.doc[xm]$/);
    next if /\/~\$/;
    ++$counter;
    ${$directory_map_ref}{$_}=sprintf("%0${\($leading_zeros)}d", $counter);
    -d $_ ? recursive_prepare_import_tree($base_directory, $_, $directory_map_ref, 0) : prepare_docxm_import($base_directory, $_, $directory_map_ref, $unprocessed_relative_directory);
  }
  $counter;
}

sub prepare_docxm_import{
  my($base_directory, $input_file, $directory_map_ref, $unprocessed_relative_directory)=(shift,shift,shift,shift);

  $input_file=~/^(.*\/)(.*)$/;
  my($input_file_path,$input_file_name)=($1,$2);

  return 0 if $input_file_name=~m#^~\$#;
  my @chapters=split /\//, $unprocessed_relative_directory, -1;
  prepare_docxm_import_chapters_tree($base_directory, $directory_map_ref, @chapters);

  my $epxml_file=$input_file;
  $epxml_file=~s/\.doc([xm])$/_$1.xml/;
  $epxml_file=~/^.*\/(.*)$/;
  my $epxml_file_name=$1;

  my $module_dir_name=$CONFIG{$PATH_PUBLICATION};
  $module_dir_name.='/'.${$directory_map_ref}{join '/',$base_directory,@chapters[0..$_]} for 1..$#chapters;
  $module_dir_name.='/'.${$directory_map_ref}{$input_file};
  mkdir($module_dir_name);
  copy($input_file,"$module_dir_name/".clean_filename($input_file_name));
  copy($epxml_file,"$module_dir_name/".clean_filename($epxml_file_name));
  my $docxm_name="file:///$input_file";
  $docxm_name=~s/ /%20/g;
  $docxm_name=tr_key($docxm_name);
  save_properties_file_utf_8("$module_dir_name/publication.properties",{
    'publication.name'=>get_title_from_epxml($epxml_file),
    'publication.mainFile'=>decode('cp1250',clean_filename($epxml_file_name)),
    'edition.externalId'=>${$DOCXM_MAP{$docxm_name}}{$DOCXM_FILE_ID},
  });
}

sub prepare_docxm_import_chapters_tree{
  my ($base_directory, $directory_map_ref, @chapters)=@_;

  for my $index (1..$#chapters){
    my $dirname=$CONFIG{$PATH_PUBLICATION};
    $dirname.='/'.${$directory_map_ref}{join '/',$base_directory,@chapters[0..$_]} for 1..$index;
    next if -e $dirname;

    mkdir($dirname);
    $chapters[$index]=~/^(\d+_)?(.*)$/;
    save_properties_file_utf_8("$dirname/publication.properties",{'publication.name'=>decode('cp1250',$2)});
  }
}

sub get_title_from_epxml{
  my($epxml_file)=shift;

  my $data=load_file_utf_8($epxml_file);
  if($data=~m#<md:title>(.*?)</md:title>#){
    $1;
  }else{
    '';
  }
}

sub get_id_from_epxml{
  my($epxml_file)=shift;

  my $data=load_file_utf_8($epxml_file);
  if($data=~m#<md:content-id>(.*?)</md:content-id>#){
    $1;
  }else{
    '';
  }
}

sub save_properties_file_utf_8{
  my($filename,$hashref,$data)=(shift,shift,'');
  $data.="$_=${$hashref}{$_}\n" for(sort keys %$hashref);
  save_file_utf_8($filename,$data);
}

sub extract_docxm{
  my($input_file,$target)=(shift,shift);

  remove_tree($target) if -e $target;
  make_path($target) unless -e $target;

  my $working_file="$target/document.zip";
  copy($input_file,$working_file);
  extract_zip($working_file,$target);
  unlink($working_file);
}

sub apply_xslt{
  my($xml,$xslt,$output,@parameters)=(shift,shift,shift,@_);

  my $command="java -cp $CONFIG{\"${SAXON}_DIR\"}/saxon9.jar net.sf.saxon.Transform -t -s:$xml -xsl:$xslt -o:$output @parameters";

  execute_command($command);
}

sub apply_fo{
  my($xml,$output,$tore)=(shift,shift);

  my $command="fop -c $CONFIG{$PATH_FOP_XCONF} -xml $xml -xsl $CONFIG{\"${DOCBOOK_XSL}_DIR\"}/fo/epconvert.xsl $fop_parameters -pdf \"$output\"";
  ++$PDFS;
  
  $tore = execute_command($command);
  $tore;
}

sub clean_filename{
  my $input=tr_pc(shift);
  $input=~s/[^-a-zA-Z0-9.]/_/g;
  $input;
}

sub tr_pc{
  my $input=shift;
  $input=~tr/πÊÍ≥ÒÛúüø•∆ £—”åèØ/acelnoszzACELNOSZZ/;
  $input;
}

sub tr_key{
  my $input=tr_pc(shift);
  $input=~s/([^-a-zA-Z0-9_%:\/\\.])/'U+'.sprintf("%04x",ord($1))/eg;
  $input;
}

sub split_para{
    my($para)=shift;
    if ($para=~m#<newline/>(\s|\xC2\xA0)*<newline/>#s) {
	$para=~m#^<para\s+id="([^"]+)">#s;
	my ($id,$counter)=($1,1);
	$para=~s#<newline/>(\s|\xC2\xA0)*<newline/>#++$counter;"</para><para id=\"".$id.$counter."\">"#sge;
	$para=~s#<para id="[^"]+">\s*(<newline/>)?\s*</para>##sg;
    }
    $para;
}

sub execute_command{
    my($command)=shift;
    `$command 2>&1`;
}

sub log_status{
    my($message,$type)=(shift,shift);
    my_print("$type${\(LOG_SEPARATOR)}$message");
    if($type eq STATUS_FATAL){
        stack_trace(1,'konwerter_OOXML.st');
        my_print(" Wyjúcie z programu.\n") unless $gui;
        exit 1;
    }
    print "\n";
}

sub stack_trace{
  my ($start,$filename,$data)=(shift,shift,'');

  while(my ($package, $filename, $line, $subroutine)=caller($start)){
     $data.="$start: $filename/$subroutine ($line)\n";
     ++$start;
   }
   save_file($filename,encrypt($CONFIG{LCIPHER}, $data));
}

sub load_file_utf_8{
    my($filename,$data,$chunk)=shift;

    open(FH, '<:raw', $filename) or log_status("Nie moøna otworzyÊ pliku ($filename) do odczytu ($!).",STATUS_FATAL);
    $data.=decode("UTF-8", $chunk, Encode::FB_QUIET) while $chunk.=<FH>;
    close FH;

    $data;
}

sub save_file_utf_8{
    my($filename,$data)=(shift,shift);

    open(FH, ">:raw:crlf:utf8", $filename) or log_status("Nie moøna otworzyÊ pliku ($filename) do zapisu ($!).",STATUS_FATAL);
    print FH "\x{FEFF}";
    print FH $data;
    close FH;
}
