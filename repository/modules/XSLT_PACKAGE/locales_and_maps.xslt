<?xml version="1.0" encoding="UTF-8"?>
<!-- autor: Tomasz Kuczyński tomasz.kuczynski@man.poznan.pl -->
<!-- wersja: 1.3.4 -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ep="http://epodreczniki.pl/" xmlns:epconvert="http://epodreczniki.pl/convert">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="EDUCATION_LEVELS_MAP" as="element()">
		<education_levels>
			<level key="I">POCZ</level>
			<level key="II">PODST</level>
			<level key="III">GIM</level>
			<level key="IV">SRE</level>
		</education_levels>
	</xsl:variable>
	<xsl:variable name="LANGUAGES" as="element()">
		<languages>
			<language key="pl-PL" default="true">Polski</language>
			<language key="en-US">Angielski</language>
			<language key="fr-FR">Francuski</language>
		</languages>
	</xsl:variable>
	<xsl:variable name="LICENSES" as="element()">
		<licenses>
			<license key="CC BY 1.0" lang="en">
				<name>Uznanie autorstwa (CC BY 1.0)</name>
				<url>https://creativecommons.org/licenses/by/1.0/legalcode</url>
			</license>
			<license key="CC BY 2.0">
				<name>Uznanie autorstwa (CC BY 2.0)</name>
				<url>https://creativecommons.org/licenses/by/2.0/pl/legalcode</url>
			</license>
			<license key="CC BY 2.5">
				<name>Uznanie autorstwa (CC BY 2.5)</name>
				<url>https://creativecommons.org/licenses/by/2.5/pl/legalcode</url>
			</license>
			<license key="CC BY 3.0" default="true">
				<name>Uznanie autorstwa (CC BY 3.0)</name>
				<url>http://creativecommons.org/licenses/by/3.0/pl/legalcode</url>
			</license>
			<license key="CC BY 4.0" lang="en">
				<name>Uznanie autorstwa (CC BY 4.0)</name>
				<url>https://creativecommons.org/licenses/by/4.0/legalcode</url>
			</license>
		</licenses>
	</xsl:variable>
	<xsl:variable name="EP_RULE_TYPES" as="element()">
		<rule_types>
			<rule_type key="REGUŁA">rule</rule_type>
			<rule_type key="TWIERDZENIE">theorem</rule_type>
			<rule_type key="LEMAT">lemma</rule_type>
			<rule_type key="PRAWO">law</rule_type>
			<rule_type key="WŁASNOŚĆ">property</rule_type>
		</rule_types>
	</xsl:variable>
	<xsl:variable name="MS_WORD_STYLES" as="element()">
		<styles>
			<style key="list">
				<name lang="pl">Akapitzlist</name>
				<name lang="en">ListParagraph</name>
			</style>
			<style key="substitute_text">
				<name lang="pl">Tekstzastpczy</name>
				<name lang="en">PlaceholderText</name>
				<name>msoplaceholdertextinner</name>
				<name>MsoPlaceHolderTextInner</name>
				<name>MSOPLACEHOLDERTEXTINNER</name>
			</style>
		</styles>
	</xsl:variable>
	<xsl:variable name="EP_STYLES" as="element()">
		<styles>
			<style key="normal">
				<hr-name>Normalny</hr-name>
			</style>
			<style key="EPAutor">
				<hr-name>EP Autor</hr-name>
			</style>
			<style key="EPAutorwtreci">
				<hr-name>EP Autor w treści</hr-name>
			</style>
			<style key="EPCytat">
				<hr-name>EP Cytat</hr-name>
			</style>
			<style key="EPCytatakapit">
				<hr-name>EP Cytat akapit</hr-name>
			</style>
			<style key="EPCytatakapit-komentarz">
				<hr-name>EP Cytat akapit - komentarz</hr-name>
			</style>
			<style key="EPDefinicja-znaczenie">
				<hr-name>EP Definicja - znaczenie</hr-name>
			</style>
			<style key="EPDowiadczenie-cel">
				<hr-name>EP Doświadczenie - cel</hr-name>
			</style>
			<style key="EPDowiadczenie-hipoteza">
				<hr-name>EP Doświadczenie - hipoteza</hr-name>
			</style>
			<style key="EPDowiadczenie-instrukcja">
				<hr-name>EP Doświadczenie - instrukcja</hr-name>
			</style>
			<style key="EPDowiadczenie-materiayiprzyrzdy">
				<hr-name>EP Doświadczenie - materiały i przyrządy</hr-name>
			</style>
			<style key="EPDowiadczenie-podsumowanie">
				<hr-name>EP Doświadczenie - podsumowanie</hr-name>
			</style>
			<style key="EPDowiadczenie-problembadawczy">
				<hr-name>EP Doświadczenie - problem badawczy</hr-name>
			</style>
			<style key="EPDymek">
				<hr-name>EP Dymek</hr-name>
			</style>
			<style key="EPEmfaza">
				<hr-name>EP Emfaza</hr-name>
			</style>
			<style key="EPEmfaza-kursywapogrubienie">
				<hr-name>EP Emfaza - kursywa + pogrubienie</hr-name>
			</style>
			<style key="EPEmfaza-pogrubienie">
				<hr-name>EP Emfaza - pogrubienie</hr-name>
			</style>
			<style key="EPIntro">
				<hr-name>EP Intro</hr-name>
			</style>
			<style key="EPJzykobcy">
				<hr-name>EP Język obcy</hr-name>
			</style>
			<style key="EPKod">
				<hr-name>EP Kod</hr-name>
			</style>
			<style key="EPKodakapit">
				<hr-name>EP Kod akapit</hr-name>
			</style>
			<style key="EPKomentarzedycyjny">
				<hr-name>EP Komentarz edycyjny</hr-name>
			</style>
			<style key="EPKomentarztechniczny">
				<hr-name>EP Komentarz techniczny</hr-name>
			</style>
			<style key="EPKomentarzedycyjny-douzupenienia">
				<hr-name>EP Komentarz edycyjny - do uzupełnienia</hr-name>
			</style>
			<style key="EPKrok">
				<hr-name>EP Krok</hr-name>
			</style>
			<style key="EPLead">
				<hr-name>EP Lead</hr-name>
			</style>
			<style key="EPNagwek1">
				<hr-name>EP Nagłówek 1</hr-name>
			</style>
			<style key="EPNagwek2">
				<hr-name>EP Nagłówek 2</hr-name>
			</style>
			<style key="EPNagwek3">
				<hr-name>EP Nagłówek 3</hr-name>
			</style>
			<style key="EPNauczyszsi">
				<hr-name>EP Nauczysz się</hr-name>
			</style>
			<style key="EPNazwa">
				<hr-name>EP Nazwa</hr-name>
			</style>
			<style key="EPNotatka-ostrzeenie">
				<hr-name>EP Notka - ostrzeżenie</hr-name>
			</style>
			<style key="EPNotatka-wane">
				<hr-name>EP Notka - ważne</hr-name>
			</style>
			<style key="EPNotatka-wskazwka">
				<hr-name>EP Notka - wskazówka</hr-name>
			</style>
			<style key="EPNotka-ciekawostka">
				<hr-name>EP Notka - ciekawostka</hr-name>
			</style>
			<style key="EPNotka-ostrzeenie">
				<hr-name>EP Notka - ostrzeżenie</hr-name>
			</style>
			<style key="EPNotka-wane">
				<hr-name>EP Notka - ważne</hr-name>
			</style>
			<style key="EPNotka-wskazwka">
				<hr-name>EP Notka - wskazówka</hr-name>
			</style>
			<style key="EPNotka-zapamitaj">
				<hr-name>EP Notka - zapamiętaj</hr-name>
			</style>
			<style key="EPOdziele">
				<hr-name>EP O dziele</hr-name>
			</style>
			<style key="EPOkrelenie">
				<hr-name>EP Określenie</hr-name>
			</style>
			<style key="EPOpis">
				<hr-name>EP Opis</hr-name>
			</style>
			<style key="EPPolecenie">
				<hr-name>EP Polecenie</hr-name>
			</style>
			<style key="EPPrzygotujprzedlekcj">
				<hr-name>EP Przygotuj przed lekcją</hr-name>
			</style>
			<style key="EPPrzykad">
				<hr-name>EP Przykład</hr-name>
			</style>
			<style key="EPPrzypomnijsobie">
				<hr-name>EP Przypomnij sobie</hr-name>
			</style>
			<style key="EPRegua-dowd">
				<hr-name>EP Reguła - dowód</hr-name>
			</style>
			<style key="EPRegua-twierdzenie">
				<hr-name>EP Reguła - twierdzenie</hr-name>
			</style>
			<style key="EPStreszczenie">
				<hr-name>EP Streszczenie</hr-name>
			</style>
			<style key="EPTytumoduu">
				<hr-name>EP Tytuł modułu</hr-name>
			</style>
			<style key="EPTytuutworuliterackiego">
				<hr-name>EP Tytuł utworu literackiego</hr-name>
			</style>
			<style key="EPWydarzeniewtreci">
				<hr-name>EP Wydarzenie w treści</hr-name>
			</style>
			<style key="EPwiczenie-problem">
				<hr-name>EP Ćwiczenie - problem</hr-name>
			</style>
			<style key="EPwiczenie-rozwizanie">
				<hr-name>EP Ćwiczenie - rozwiązanie</hr-name>
			</style>
			<style key="EPwiczenie-wyjanienie">
				<hr-name>EP Ćwiczenie - wyjaśnienie</hr-name>
			</style>
			<style key="EPKAdresatnauczyciel">
				<hr-name>EPK Adresat – nauczyciel</hr-name>
			</style>
			<style key="EPKAutor">
				<hr-name>EPK Autor</hr-name>
			</style>
			<style key="EPKBiogram">
				<hr-name>EPK Biogram</hr-name>
			</style>
			<style key="EPKBiogram-odwoanie">
				<hr-name>EPK Biogram - odwołanie</hr-name>
			</style>
			<style key="EPKCytat">
				<hr-name>EPK Cytat</hr-name>
			</style>
			<style key="EPKDefinicja">
				<hr-name>EPK Definicja</hr-name>
			</style>
			<style key="EPKDowiadczenie">
				<hr-name>EPK Doświadczenie</hr-name>
			</style>
			<style key="EPKDymek">
				<hr-name>EPK Dymek</hr-name>
			</style>
			<style key="EPKDymek-odwoanie">
				<hr-name>EPK Dymek - odwołanie</hr-name>
			</style>
			<style key="EPKInstrukcjapostpowania">
				<hr-name>EPK Instrukcja postępowania</hr-name>
			</style>
			<style key="EPKKod">
				<hr-name>EPK Kod</hr-name>
			</style>
			<style key="EPKLista">
				<hr-name>EPK Lista</hr-name>
			</style>
			<style key="EPKObserwacja">
				<hr-name>EPK Obserwacja</hr-name>
			</style>
			<style key="EPKPolecenie">
				<hr-name>EPK Polecenie</hr-name>
			</style>
			<style key="EPKPojcie">
				<hr-name>EPK Pojęcie</hr-name>
			</style>
			<style key="EPKPojcie-odwoanie">
				<hr-name>EPK Pojęcie - odwołanie</hr-name>
			</style>
			<style key="EPKPracadomowa">
				<hr-name>EPK Praca domowa</hr-name>
			</style>
			<style key="EPKRegua">
				<hr-name>EPK Reguła</hr-name>
			</style>
			<style key="EPKStatustrerozszerzajca">
				<hr-name>EPK Status – treść rozszerzająca</hr-name>
			</style>
			<style key="EPKStatustreuzupeniajca">
				<hr-name>EPK Status – treść uzupełniająca</hr-name>
			</style>
			<style key="EPKSowniczek-deklaracja">
				<hr-name>EPK Słowniczek - deklaracja</hr-name>
			</style>
			<style key="EPKSowniczek-odwoanie">
				<hr-name>EPK Słowniczek - odwołanie</hr-name>
			</style>
			<style key="EPKTytuutworuliterackiego">
				<hr-name>EPK Tytuł utworu literackiego</hr-name>
			</style>
			<style key="EPKWydarzenie">
				<hr-name>EPK Wydarzenie</hr-name>
			</style>
			<style key="EPKWydarzenie-odwoanie">
				<hr-name>EPK Wydarzenie - odwołanie</hr-name>
			</style>
			<style key="EPKWydarzeniewtreci">
				<hr-name>EPK Wydarzenie w treści</hr-name>
			</style>
			<style key="EPKZadanie">
				<hr-name>EPK Zadanie</hr-name>
			</style>
			<style key="EPKZadaniesilnikowe">
				<hr-name>EPK Zadanie silnikowe</hr-name>
			</style>
			<style key="EPKZapisbibliograficzny-odwoanie">
				<hr-name>EPK Zapis bibliograficzny - odwołanie</hr-name>
			</style>
			<style key="EPKZbirzada">
				<hr-name>EPK Zbiór zadań</hr-name>
			</style>
			<style key="EPKwiczenie">
				<hr-name>EPK Ćwiczenie</hr-name>
			</style>
			<style key="EPQKomunikat-odpowiedbdna">
				<hr-name>EPQ Komunikat - odpowiedź błędna</hr-name>
			</style>
			<style key="EPQKomunkat-odpowiedpoprawna">
				<hr-name>EPQ Komunkat - odpowiedź poprawna</hr-name>
			</style>
			<style key="EPQOdpowied-bdna">
				<hr-name>EPQ Odpowiedź - błędna</hr-name>
			</style>
			<style key="EPQOdpowied-poprawna">
				<hr-name>EPQ Odpowiedź - poprawna</hr-name>
			</style>
			<style key="EPQPodpowiedz">
				<hr-name>EPQ Podpowiedz</hr-name>
			</style>
			<style key="EPQPytanie">
				<hr-name>EPQ Pytanie</hr-name>
			</style>
			<style key="EPQWskazwka">
				<hr-name>EPQ Wskazówka</hr-name>
			</style>
			<style key="EPQWyjanienie">
				<hr-name>EPQ Wyjaśnienie</hr-name>
			</style>
		</styles>
	</xsl:variable>
	<xsl:variable name="EP_BLOCKS" as="element()">
		<blocks>
			<block key="definition">
				<hr-name>Definicja</hr-name>
			</block>
			<block key="concept">
				<hr-name>Pojęcie</hr-name>
			</block>
			<block key="exercise">
				<hr-name>Ćwiczenie</hr-name>
			</block>
			<block key="command">
				<hr-name>Polecenie</hr-name>
			</block>
			<block key="homework">
				<hr-name>Praca domowa</hr-name>
			</block>
			<block key="list">
				<hr-name>Lista</hr-name>
			</block>
			<block key="cite">
				<hr-name>Cytat</hr-name>
			</block>
			<block key="quiz">
				<hr-name>Pytanie quizowe</hr-name>
			</block>
			<block key="experiment">
				<hr-name>Doświadczenie</hr-name>
			</block>
			<block key="observation">
				<hr-name>Obserwacja</hr-name>
			</block>
			<block key="biography">
				<hr-name>Biogram</hr-name>
			</block>
			<block key="event">
				<hr-name>Wydarzenie</hr-name>
			</block>
			<block key="tooltip">
				<hr-name>Dymek</hr-name>
			</block>
			<block key="procedure-instructions">
				<hr-name>Instrukcja postępowania</hr-name>
			</block>
			<block key="code">
				<hr-name>Kod</hr-name>
			</block>
			<block key="rule">
				<hr-name>Reguła</hr-name>
			</block>
			<block key="WOMI">
				<hr-name>WOMI nie będące zadaniem</hr-name>
			</block>
		</blocks>
	</xsl:variable>
	<xsl:variable name="IER">bold</xsl:variable>
	<xsl:variable name="TER">bold</xsl:variable>
	<xsl:variable name="L" as="element()">
		<locales>
			<MONTH_1>stycznia</MONTH_1>
			<MONTH_2>lutego</MONTH_2>
			<MONTH_3>marca</MONTH_3>
			<MONTH_4>kwietnia</MONTH_4>
			<MONTH_5>maja</MONTH_5>
			<MONTH_6>czerwca</MONTH_6>
			<MONTH_7>lipca</MONTH_7>
			<MONTH_8>sierpnia</MONTH_8>
			<MONTH_9>września</MONTH_9>
			<MONTH_10>października</MONTH_10>
			<MONTH_11>listopada</MONTH_11>
			<MONTH_12>grudnia</MONTH_12>
			<TABLE>Tabela</TABLE>
			<TABLE_TITLE>
				<emphasis role="{$TER}">Tytuł: </emphasis>
			</TABLE_TITLE>
			<TABLE_ALT_TEXT>
				<emphasis role="{$TER}">Tekst alternatywny: </emphasis>
			</TABLE_ALT_TEXT>
			<WOMI_TYPE_IMAGE>ilustracja</WOMI_TYPE_IMAGE>
			<WOMI_TYPE_ICON>ikona</WOMI_TYPE_ICON>
			<WOMI_TYPE_VIDEO>film</WOMI_TYPE_VIDEO>
			<WOMI_TYPE_AUDIO>klip audio</WOMI_TYPE_AUDIO>
			<WOMI_TYPE_OINT>obiekt interaktywny</WOMI_TYPE_OINT>
			<WARN_AUTHOR>INFORMACJA DLA AUTORA MODUŁU: Ostrzeżenie</WARN_AUTHOR>
			<ERROR_AUTHOR>INFORMACJA DLA AUTORA MODUŁU: Błąd przetwarzania</ERROR_AUTHOR>
			<WOMI_REFERENCE>Referencja WOMI</WOMI_REFERENCE>
			<WOMI_ID>
				<emphasis role="{$TER}">ID: </emphasis>
			</WOMI_ID>
			<WOMI_TYPE>
				<emphasis role="{$TER}">Typ: </emphasis>
			</WOMI_TYPE>
			<WOMI_STYLE>
				<emphasis role="{$TER}">Styl: </emphasis>
			</WOMI_STYLE>
			<WOMI_WIDTH>
				<emphasis role="{$TER}">Szerokość: </emphasis>
			</WOMI_WIDTH>
			<WOMI_CONTEXT>
				<emphasis role="{$TER}">WOMI kontekstu: </emphasis>
			</WOMI_CONTEXT>
			<WOMI_CONTEXT_STATIC> (Kopia WOMI pojawi się również w treści.)</WOMI_CONTEXT_STATIC>
			<WOMI_GALLERY>
				<emphasis role="{$TER}">WOMI do czytelni/galerii: </emphasis>
			</WOMI_GALLERY>
			<WOMI_GALLERY_WITH_CONTENTS>Tak, razem z tekstem skojarzonym</WOMI_GALLERY_WITH_CONTENTS>
			<WOMI_ZOOMABLE>
				<emphasis role="{$TER}">Funkcja lupy / Powiększenie WOMI: </emphasis>
			</WOMI_ZOOMABLE>
			<WOMI_ZOOMABLE_NO>brak</WOMI_ZOOMABLE_NO>
			<WOMI_ZOOMABLE_ZOOM>lupa</WOMI_ZOOMABLE_ZOOM>
			<WOMI_ZOOMABLE_MAGNIFIER>zwykłe</WOMI_ZOOMABLE_MAGNIFIER>
			<WOMI_AVATAR>
				<emphasis role="{$TER}">WOMI awatar: </emphasis>
			</WOMI_AVATAR>
			<WOMI_CAPTION>
				<emphasis role="{$TER}">Numerowanie, tytułu, etykiety WOMI: </emphasis>
			</WOMI_CAPTION>
			<WOMI_CAPTION_ALL>ukryj wszystkie</WOMI_CAPTION_ALL>
			<WOMI_CAPTION_NONE>wyświetlaj wszystkie</WOMI_CAPTION_NONE>
			<WOMI_CAPTION_TITLE>ukryj tylko tytuł</WOMI_CAPTION_TITLE>
			<WOMI_CAPTION_NUMBER>ukryj tylko numerowanie</WOMI_CAPTION_NUMBER>
			<WOMI_TEXT>
				<emphasis role="{$TER}">Tekst skojarzony</emphasis>
			</WOMI_TEXT>
			<WOMI_TEXT_CLASSIC>
				<emphasis role="{$TER}">Wersja klasyczna: </emphasis>
			</WOMI_TEXT_CLASSIC>
			<WOMI_TEXT_MOBILE>
				<emphasis role="{$TER}">Wersja mobilna: </emphasis>
			</WOMI_TEXT_MOBILE>
			<WOMI_TEXT_STATIC>
				<emphasis role="{$TER}">Wersja statyczna: </emphasis>
			</WOMI_TEXT_STATIC>
			<WOMI_TEXT_STATIC_MONO>
				<emphasis role="{$TER}">Wersja statyczna monochromatyczna: </emphasis>
			</WOMI_TEXT_STATIC_MONO>
			<WOMI_TEXT_STATIC_OF>wersji statycznej</WOMI_TEXT_STATIC_OF>
			<WOMI_TEXT_STATIC_MONO_OF>wersji statycznej monochromatycznej</WOMI_TEXT_STATIC_MONO_OF>
			<WOMI_GALLERY_2>Galeria WOMI</WOMI_GALLERY_2>
			<WOMI_GALLERY_TITLE>
				<emphasis role="{$TER}">Tytuł: </emphasis>
			</WOMI_GALLERY_TITLE>
			<WOMI_GALLERY_NO_TITLE>
				<emphasis role="{$TER}">Galeria bez tytułu</emphasis>
			</WOMI_GALLERY_NO_TITLE>
			<WOMI_GALLERY_NO_OF_WOMIES>
				<emphasis role="{$TER}">Liczba WOMI w galerii: </emphasis>
			</WOMI_GALLERY_NO_OF_WOMIES>
			<WOMI_GALLERY_TYPE>
				<emphasis role="{$TER}">Typ: </emphasis>
			</WOMI_GALLERY_TYPE>
			<WOMI_GALLERY_TYPE_SLIDESHOW>pokaz slajdów</WOMI_GALLERY_TYPE_SLIDESHOW>
			<WOMI_GALLERY_TYPE_GRID>siatka</WOMI_GALLERY_TYPE_GRID>
			<WOMI_GALLERY_TYPE_MINIATURES>pozioma</WOMI_GALLERY_TYPE_MINIATURES>
			<WOMI_GALLERY_TYPE_PLAYLIST>playlista wideo</WOMI_GALLERY_TYPE_PLAYLIST>
			<WOMI_GALLERY_STYLE>
				<emphasis role="{$TER}">Styl: </emphasis>
			</WOMI_GALLERY_STYLE>
			<WOMIES_IN_GALLERY>
				<emphasis role="{$TER}">WOMI w galerii</emphasis>
			</WOMIES_IN_GALLERY>
			<WOMI_GALLERY_TEXT>
				<emphasis role="{$TER}">Tekst skojarzony</emphasis>
			</WOMI_GALLERY_TEXT>
			<WOMI_GALLERY_TEXT_CLASSIC>
				<emphasis role="{$TER}">Wersja klasyczna: </emphasis>
			</WOMI_GALLERY_TEXT_CLASSIC>
			<WOMI_GALLERY_TEXT_MOBILE>
				<emphasis role="{$TER}">Wersja mobilna: </emphasis>
			</WOMI_GALLERY_TEXT_MOBILE>
			<WOMI_GALLERY_TEXT_STATIC>
				<emphasis role="{$TER}">Wersja statyczna: </emphasis>
			</WOMI_GALLERY_TEXT_STATIC>
			<WOMI_GALLERY_TEXT_STATIC_MONO>
				<emphasis role="{$TER}">Wersja statyczna monochromatyczna: </emphasis>
			</WOMI_GALLERY_TEXT_STATIC_MONO>
			<WOMI_GALLERY_START_ON>
				<emphasis role="{$TER}">Początkowy element galerii: </emphasis>
			</WOMI_GALLERY_START_ON>
			<WOMI_GALLERY_THUMBNAILS>
				<emphasis role="{$TER}">Miniaturki: </emphasis>
			</WOMI_GALLERY_THUMBNAILS>
			<WOMI_GALLERY_THUMBNAILS_ALL>wyświetlaj zawsze</WOMI_GALLERY_THUMBNAILS_ALL>
			<WOMI_GALLERY_THUMBNAILS_HIDE-FULLSCREEN>wyświetlaj tylko w widoku normalnym</WOMI_GALLERY_THUMBNAILS_HIDE-FULLSCREEN>
			<WOMI_GALLERY_THUMBNAILS_HIDE-NORMAL>wyświetlaj tylko w widoku pełnoekranowym</WOMI_GALLERY_THUMBNAILS_HIDE-NORMAL>
			<WOMI_GALLERY_THUMBNAILS_HIDE>nie wyświetlaj</WOMI_GALLERY_THUMBNAILS_HIDE>
			<WOMI_GALLERY_TITLES>
				<emphasis role="{$TER}">Tytuł galerii / tytuł WOMI: </emphasis>
			</WOMI_GALLERY_TITLES>
			<WOMI_GALLERY_TITLES_ALL>wyświetlaj zawsze</WOMI_GALLERY_TITLES_ALL>
			<WOMI_GALLERY_TITLES_HIDE-FULLSCREEN>wyświetlaj tylko w widoku normalnym</WOMI_GALLERY_TITLES_HIDE-FULLSCREEN>
			<WOMI_GALLERY_TITLES_HIDE-NORMAL>wyświetlaj tylko w widoku pełnoekranowym</WOMI_GALLERY_TITLES_HIDE-NORMAL>
			<WOMI_GALLERY_TITLES_HIDE>nie wyświetlaj</WOMI_GALLERY_TITLES_HIDE>
			<WOMI_GALLERY_FORMAT_CONTENTS>
				<emphasis role="{$TER}">Teksty skojarzone: </emphasis>
			</WOMI_GALLERY_FORMAT_CONTENTS>
			<WOMI_GALLERY_FORMAT_CONTENTS_ALL>wyświetlaj zawsze</WOMI_GALLERY_FORMAT_CONTENTS_ALL>
			<WOMI_GALLERY_FORMAT_CONTENTS_HIDE-FULLSCREEN>wyświetlaj tylko w widoku normalnym</WOMI_GALLERY_FORMAT_CONTENTS_HIDE-FULLSCREEN>
			<WOMI_GALLERY_FORMAT_CONTENTS_HIDE-NORMAL>wyświetlaj tylko w widoku pełnoekranowym</WOMI_GALLERY_FORMAT_CONTENTS_HIDE-NORMAL>
			<WOMI_GALLERY_FORMAT_CONTENTS_HIDE>nie wyświetlaj</WOMI_GALLERY_FORMAT_CONTENTS_HIDE>
			<WOMI_GALLERY_PLAYLIST>
				<emphasis role="{$TER}">Sposób odtwarzania: </emphasis>
			</WOMI_GALLERY_PLAYLIST>
			<WOMI_GALLERY_PLAYLIST_AUTOPLAY>odtwórz materiały wideo bez pauzowania</WOMI_GALLERY_PLAYLIST_AUTOPLAY>
			<WOMI_GALLERY_PLAYLIST_PAUSE>pauzuj po każdym materiale wideo</WOMI_GALLERY_PLAYLIST_PAUSE>
			<WOMI_GALLERY_VIEW_WIDTH>
				<emphasis role="{$TER}">Liczba kolumn: </emphasis>
			</WOMI_GALLERY_VIEW_WIDTH>
			<WOMI_GALLERY_VIEW_HEIGHT>
				<emphasis role="{$TER}">Liczba wierszy: </emphasis>
			</WOMI_GALLERY_VIEW_HEIGHT>
			<METADATA_MODULE_SCOPE_TITLE>Metadane dotyczące widoczności treści</METADATA_MODULE_SCOPE_TITLE>
			<METADATA_MODULE_SCOPE_RECIPIENT>
				<emphasis role="{$TER}">Adresat: </emphasis>
			</METADATA_MODULE_SCOPE_RECIPIENT>
			<METADATA_MODULE_SCOPE_RECIPIENT_STUDENT>Uczeń</METADATA_MODULE_SCOPE_RECIPIENT_STUDENT>
			<METADATA_MODULE_SCOPE_RECIPIENT_TEACHER>Nauczyciel</METADATA_MODULE_SCOPE_RECIPIENT_TEACHER>
			<METADATA_MODULE_SCOPE_STATUS>
				<emphasis role="{$TER}">Status: </emphasis>
			</METADATA_MODULE_SCOPE_STATUS>
			<METADATA_MODULE_SCOPE_STATUS_CANON>Kanon</METADATA_MODULE_SCOPE_STATUS_CANON>
			<METADATA_MODULE_SCOPE_STATUS_EXPANDING>Treść rozszerzająca</METADATA_MODULE_SCOPE_STATUS_EXPANDING>
			<METADATA_MODULE_SCOPE_STATUS_SUPPLEMENTAL>Treść uzupełniająca</METADATA_MODULE_SCOPE_STATUS_SUPPLEMENTAL>
			<METADATA_MODULE_OTHER_TITLE>Inne metadane dotyczące treści</METADATA_MODULE_OTHER_TITLE>
			<METADATA_MODULE_TYPE>
				<emphasis role="{$TER}">Typ modułu: </emphasis>
			</METADATA_MODULE_TYPE>
			<METADATA_MODULE_TYPE_NONE>nie określono</METADATA_MODULE_TYPE_NONE>
			<METADATA_MODULE_TEMPLATE>
				<emphasis role="{$TER}">Szablon modułu: </emphasis>
			</METADATA_MODULE_TEMPLATE>
			<METADATA_MODULE_TEMPLATE_NONE>nie określono</METADATA_MODULE_TEMPLATE_NONE>
			<METADATA_MODULE_TEMPLATE_COLUMNS>liniowy</METADATA_MODULE_TEMPLATE_COLUMNS>
			<METADATA_MODULE_TEMPLATE_FREEFORM>własny układ kaflowy</METADATA_MODULE_TEMPLATE_FREEFORM>
			<METADATA_MODULE_TEMPLATE_FREEFORM_GRID-WIDTH>
				<emphasis role="{$TER}">Szerokość siatki: </emphasis>
			</METADATA_MODULE_TEMPLATE_FREEFORM_GRID-WIDTH>
			<METADATA_MODULE_TEMPLATE_FREEFORM_GRID-HEIGHT>
				<emphasis role="{$TER}">Wysokość siatki: </emphasis>
			</METADATA_MODULE_TEMPLATE_FREEFORM_GRID-HEIGHT>
			<MODULE_PROPERTIES_TITLE>Właściwości modułu treści e-podręcznika</MODULE_PROPERTIES_TITLE>
			<BASE_MODULE_INFORMATION_TITLE>Informacje podstawowe</BASE_MODULE_INFORMATION_TITLE>
			<MODULE_TITLE>
				<emphasis role="{$TER}">Tytuł modułu: </emphasis>
			</MODULE_TITLE>
			<MODULE_ABSTRACT>
				<emphasis role="{$TER}">Abstrakt: </emphasis>
			</MODULE_ABSTRACT>
			<MODULE_KEYWORDS>
				<emphasis role="{$TER}">Słowa kluczowe</emphasis>
			</MODULE_KEYWORDS>
			<MODULE_KEYWORD>
				<emphasis role="{$TER}">Słowo kluczowe: </emphasis>
			</MODULE_KEYWORD>
			<MODULE_LICENSE>
				<emphasis role="{$TER}">Licencja: </emphasis>
			</MODULE_LICENSE>
			<MODULE_LANGUAGE>
				<emphasis role="{$TER}">Język: </emphasis>
			</MODULE_LANGUAGE>
			<MODULE_CHAPTER>
				<emphasis role="{$TER}">Tytuł rozdziału: </emphasis>
			</MODULE_CHAPTER>
			<MODULE_SUBCHAPTER_1>
				<emphasis role="{$TER}">Tytuł podrozdziału 1: </emphasis>
			</MODULE_SUBCHAPTER_1>
			<MODULE_SUBCHAPTER_2>
				<emphasis role="{$TER}">Tytuł podrozdziału 2: </emphasis>
			</MODULE_SUBCHAPTER_2>
			<MODULE_PROCESSED_TIME>
				<emphasis role="{$TER}">Data oraz czas przetworzenia: </emphasis>
			</MODULE_PROCESSED_TIME>
			<BIBLIOGRAPHY_TITLE>Bibliografia modułu</BIBLIOGRAPHY_TITLE>
			<BIBLIOGRAPHY_CONTENT>Wszystkie zapisy bibliograficzne zostaną zagregowane w bibliografii zbiorczej znajdującej się na końcu e-podręcznika. Dodatkowo zapisy z opcją "w bibliografii zbiorczej oraz w tym module" wybraną dla atrybuty "Wyświetlaj" zostaną wyemitowane w specjalnej sekcji znajdującej się na końcu modułu w którym zostały zdefiniowane.</BIBLIOGRAPHY_CONTENT>
			<BIBLIOGRAPHY_ENTRY>Zapis bibliograficzny </BIBLIOGRAPHY_ENTRY>
			<BIBLIOGRAPHY_ENTRY_DISPLAY_FALSE>(TYLKO BIBLIOGRAFIA ZBIORCZA)</BIBLIOGRAPHY_ENTRY_DISPLAY_FALSE>
			<BIBLIOGRAPHY_ENTRY_DISPLAY_TRUE>(BIBLIOGRAFIA ZBIORCZA ORAZ MODUŁ)</BIBLIOGRAPHY_ENTRY_DISPLAY_TRUE>
			<BIBLIOGRAPHY_ENTRY_TYPE>
				<emphasis role="{$TER}">Typ zapisu: </emphasis>
			</BIBLIOGRAPHY_ENTRY_TYPE>
			<BIBLIOGRAPHY_ENTRY_TYPE_ARTICLE>Artykuł</BIBLIOGRAPHY_ENTRY_TYPE_ARTICLE>
			<BIBLIOGRAPHY_ENTRY_TYPE_BOOK>Książka</BIBLIOGRAPHY_ENTRY_TYPE_BOOK>
			<BIBLIOGRAPHY_ENTRY_TYPE_BOOKPART>Fragment książki</BIBLIOGRAPHY_ENTRY_TYPE_BOOKPART>
			<BIBLIOGRAPHY_ENTRY_TYPE_REPORT>Sprawozdanie</BIBLIOGRAPHY_ENTRY_TYPE_REPORT>
			<BIBLIOGRAPHY_ENTRY_TYPE_ACT>Ustawa</BIBLIOGRAPHY_ENTRY_TYPE_ACT>
			<BIBLIOGRAPHY_ENTRY_TYPE_WEB>Źródło internetowe</BIBLIOGRAPHY_ENTRY_TYPE_WEB>
			<BIBLIOGRAPHY_ENTRY_ID>
				<emphasis role="{$TER}">Unikalny identyfikator: </emphasis>
			</BIBLIOGRAPHY_ENTRY_ID>
			<BIBLIOGRAPHY_ENTRY_BOOKTITLE>
				<emphasis role="{$TER}">Tytuł książki: </emphasis>
			</BIBLIOGRAPHY_ENTRY_BOOKTITLE>
			<BIBLIOGRAPHY_ENTRY_TITLE_ARTICLE>
				<emphasis role="{$TER}">Tytuł artykułu: </emphasis>
			</BIBLIOGRAPHY_ENTRY_TITLE_ARTICLE>
			<BIBLIOGRAPHY_ENTRY_TITLE_BOOKPART>
				<emphasis role="{$TER}">Tytuł fragmentu: </emphasis>
			</BIBLIOGRAPHY_ENTRY_TITLE_BOOKPART>
			<BIBLIOGRAPHY_ENTRY_TITLE_REPORT>
				<emphasis role="{$TER}">Tytuł sprawozdania: </emphasis>
			</BIBLIOGRAPHY_ENTRY_TITLE_REPORT>
			<BIBLIOGRAPHY_ENTRY_TITLE_ACT>
				<emphasis role="{$TER}">Tytuł ustawy: </emphasis>
			</BIBLIOGRAPHY_ENTRY_TITLE_ACT>
			<BIBLIOGRAPHY_ENTRY_TITLE_WEB>
				<emphasis role="{$TER}">Tytuł źródła: </emphasis>
			</BIBLIOGRAPHY_ENTRY_TITLE_WEB>
			<BIBLIOGRAPHY_ENTRY_JOURNAL>
				<emphasis role="{$TER}">Tytuł czasopisma: </emphasis>
			</BIBLIOGRAPHY_ENTRY_JOURNAL>
			<BIBLIOGRAPHY_ENTRY_SERIES>
				<emphasis role="{$TER}">Seria wydawnicza: </emphasis>
			</BIBLIOGRAPHY_ENTRY_SERIES>
			<BIBLIOGRAPHY_ENTRY_ADDRESS>
				<emphasis role="{$TER}">Miejsce publikacji: </emphasis>
			</BIBLIOGRAPHY_ENTRY_ADDRESS>
			<BIBLIOGRAPHY_ENTRY_NUMBER>
				<emphasis role="{$TER}">Numer: </emphasis>
			</BIBLIOGRAPHY_ENTRY_NUMBER>
			<BIBLIOGRAPHY_ENTRY_YEAR>
				<emphasis role="{$TER}">Rok publikacji: </emphasis>
			</BIBLIOGRAPHY_ENTRY_YEAR>
			<BIBLIOGRAPHY_ENTRY_PAGES>
				<emphasis role="{$TER}">Strony: </emphasis>
			</BIBLIOGRAPHY_ENTRY_PAGES>
			<BIBLIOGRAPHY_ENTRY_ORGANIZATION>
				<emphasis role="{$TER}">Typ aktu prawnego: </emphasis>
			</BIBLIOGRAPHY_ENTRY_ORGANIZATION>
			<BIBLIOGRAPHY_ENTRY_EDITION>
				<emphasis role="{$TER}">Data publikacji: </emphasis>
			</BIBLIOGRAPHY_ENTRY_EDITION>
			<BIBLIOGRAPHY_ENTRY_KEY>
				<emphasis role="{$TER}">Dane publikacji: </emphasis>
			</BIBLIOGRAPHY_ENTRY_KEY>
			<BIBLIOGRAPHY_ENTRY_HOWPUBLISHED>
				<emphasis role="{$TER}">Adres strony: </emphasis>
			</BIBLIOGRAPHY_ENTRY_HOWPUBLISHED>
			<BIBLIOGRAPHY_ENTRY_NOTE>
				<emphasis role="{$TER}">Data dostępu: </emphasis>
			</BIBLIOGRAPHY_ENTRY_NOTE>
			<BIBLIOGRAPHY_AUTHOR>
				<emphasis role="{$TER}">Autor: </emphasis>
			</BIBLIOGRAPHY_AUTHOR>
			<BIBLIOGRAPHY_AUTHORS>
				<emphasis role="{$TER}">Autorzy: </emphasis>
			</BIBLIOGRAPHY_AUTHORS>
			<BIBLIOGRAPHY_EDITOR>
				<emphasis role="{$TER}">Tłumacz: </emphasis>
			</BIBLIOGRAPHY_EDITOR>
			<BIBLIOGRAPHY_EDITORS>
				<emphasis role="{$TER}">Tłumacze: </emphasis>
			</BIBLIOGRAPHY_EDITORS>
			<SECTION_INFORMATION_TITLE_TILE_TYPE>Atrybuty sekcji - układ kaflowy predefiniowany</SECTION_INFORMATION_TITLE_TILE_TYPE>
			<SECTION_INFORMATION_TITLE_FREEFORM_TYPE>Atrybuty sekcji - układ kaflowy własny</SECTION_INFORMATION_TITLE_FREEFORM_TYPE>
			<SECTION_INFORMATION_TITLE_COLUMNS_TYPE>Atrybuty sekcji - układ kolumnowy poziom 1</SECTION_INFORMATION_TITLE_COLUMNS_TYPE>
			<SECTION_INFORMATION_TITLE_COLUMNS_TYPE_L2>Atrybuty sekcji - układ kolumnowy poziom 2</SECTION_INFORMATION_TITLE_COLUMNS_TYPE_L2>
			<METADATA_SECTION_ROLE>
				<emphasis role="{$TER}">Rola: </emphasis>
			</METADATA_SECTION_ROLE>
			<METADATA_SECTION_ROLE_NONE>nie określono</METADATA_SECTION_ROLE_NONE>
			<METADATA_SECTION_TILE>
				<emphasis role="{$TER}">Kafel: </emphasis>
			</METADATA_SECTION_TILE>
			<METADATA_SECTION_COLUMNS>
				<emphasis role="{$TER}">Liczba kolumn: </emphasis>
			</METADATA_SECTION_COLUMNS>
			<METADATA_SECTION_COLUMN_WIDTH>
				<emphasis role="{$TER}">Szerokość kolumny: </emphasis>
			</METADATA_SECTION_COLUMN_WIDTH>
			<METADATA_SECTION_HIDE_SECTION_TITLE>
				<emphasis role="{$TER}">Ukryj tytuł sekcji: </emphasis>
			</METADATA_SECTION_HIDE_SECTION_TITLE>
			<METADATA_SECTION_START_NEW_PAGE>
				<emphasis role="{$TER}">Rozpocznij nową stronę: </emphasis>
			</METADATA_SECTION_START_NEW_PAGE>
			<METADATA_SECTION_FOLDABLE>
				<emphasis role="{$TER}">Zwijalna: </emphasis>
			</METADATA_SECTION_FOLDABLE>
			<METADATA_SECTION_SCOPE_RECIPIENT>
				<emphasis role="{$TER}">Adresat: </emphasis>
			</METADATA_SECTION_SCOPE_RECIPIENT>
			<METADATA_SECTION_SCOPE_RECIPIENT_TEACHER>Nauczyciel</METADATA_SECTION_SCOPE_RECIPIENT_TEACHER>
			<METADATA_SECTION_SCOPE_STATUS>
				<emphasis role="{$TER}">Status: </emphasis>
			</METADATA_SECTION_SCOPE_STATUS>
			<METADATA_SECTION_SCOPE_STATUS_EXPANDING>Treść rozszerzająca</METADATA_SECTION_SCOPE_STATUS_EXPANDING>
			<METADATA_SECTION_SCOPE_STATUS_SUPPLEMENTAL>Treść uzupełniająca</METADATA_SECTION_SCOPE_STATUS_SUPPLEMENTAL>
			<METADATA_SECTION_FREEFORM_TOP>
				<emphasis role="{$TER}">Góra: </emphasis>
			</METADATA_SECTION_FREEFORM_TOP>
			<METADATA_SECTION_FREEFORM_LEFT>
				<emphasis role="{$TER}">Lewo: </emphasis>
			</METADATA_SECTION_FREEFORM_LEFT>
			<METADATA_SECTION_FREEFORM_WIDTH>
				<emphasis role="{$TER}">Szerokość: </emphasis>
			</METADATA_SECTION_FREEFORM_WIDTH>
			<METADATA_SECTION_FREEFORM_HEIGHT>
				<emphasis role="{$TER}">Wysokość: </emphasis>
			</METADATA_SECTION_FREEFORM_HEIGHT>
			<METADATA_MODULE_AUTHOR>Autor modułu</METADATA_MODULE_AUTHOR>
			<METADATA_MODULE_AUTHOR_FIRST_NAME>
				<emphasis role="{$TER}">Imię: </emphasis>
			</METADATA_MODULE_AUTHOR_FIRST_NAME>
			<METADATA_MODULE_AUTHOR_SECOND_NAME>
				<emphasis role="{$TER}">Nazwisko: </emphasis>
			</METADATA_MODULE_AUTHOR_SECOND_NAME>
			<METADATA_MODULE_AUTHOR_EMAIL>
				<emphasis role="{$TER}">Email: </emphasis>
			</METADATA_MODULE_AUTHOR_EMAIL>
			<METADATA_MODULE_CORE_CURRICULUM_ERRORS>Ogólne błędy w hasłach podstawy programowej</METADATA_MODULE_CORE_CURRICULUM_ERRORS>
			<METADATA_MODULE_CORE_CURRICULUM_GROUP>Hasła podstawy programowej</METADATA_MODULE_CORE_CURRICULUM_GROUP>
			<METADATA_MODULE_CORE_CURRICULUM_EDUCATION_LEVEL>
				<emphasis role="{$TER}">Etap edukacyjny: </emphasis>
			</METADATA_MODULE_CORE_CURRICULUM_EDUCATION_LEVEL>
			<METADATA_MODULE_CORE_CURRICULUM_SCHOOL>
				<emphasis role="{$TER}">Szkoła: </emphasis>
			</METADATA_MODULE_CORE_CURRICULUM_SCHOOL>
			<METADATA_MODULE_CORE_CURRICULUM_SUBJECT>
				<emphasis role="{$TER}">Przedmiot: </emphasis>
			</METADATA_MODULE_CORE_CURRICULUM_SUBJECT>
			<METADATA_MODULE_CORE_CURRICULUM_VERSION>
				<emphasis role="{$TER}">Wersja podstawy: </emphasis>
			</METADATA_MODULE_CORE_CURRICULUM_VERSION>
			<METADATA_MODULE_CORE_CURRICULUM_CODE>
				<emphasis role="{$TER}">Kod: </emphasis>
			</METADATA_MODULE_CORE_CURRICULUM_CODE>
			<METADATA_MODULE_CORE_CURRICULUM_MAIN>
				<emphasis role="{$TER}">(punkt ogólny)</emphasis>
			</METADATA_MODULE_CORE_CURRICULUM_MAIN>
			<METADATA_MODULE_CORE_CURRICULUM_KEYWORD>
				<emphasis role="{$TER}">Hasło: </emphasis>
			</METADATA_MODULE_CORE_CURRICULUM_KEYWORD>
			<METADATA_MODULE_CORE_CURRICULUM_OTHER>
				<emphasis role="{$TER}">Treści niepowiązane z konkretnym punktem podstawy programowej</emphasis>
			</METADATA_MODULE_CORE_CURRICULUM_OTHER>
			<SPECIAL_BLOCK>Treść specjalna</SPECIAL_BLOCK>
			<SPECIAL_TYPE>Typ: </SPECIAL_TYPE>
			<TIP_TYPE>Wskazówka</TIP_TYPE>
			<WARNING_TYPE>Ostrzeżenie</WARNING_TYPE>
			<IMPORTANT_TYPE>Ważne</IMPORTANT_TYPE>
			<CURIOSITY_TYPE>Ciekawostka</CURIOSITY_TYPE>
			<REMEMBER_TYPE>Zapamiętaj</REMEMBER_TYPE>
			<CODE_TYPE>Kod</CODE_TYPE>
			<EXAMPLE_TYPE>Przykład</EXAMPLE_TYPE>
			<LEAD_TYPE>Lead</LEAD_TYPE>
			<INTRO_TYPE>Intro</INTRO_TYPE>
			<PREREQUISITE_TYPE>Przygotuj przed lekcją</PREREQUISITE_TYPE>
			<EFFECT_TYPE>Nauczysz się</EFFECT_TYPE>
			<REVISAL_TYPE>Przypomnij sobie</REVISAL_TYPE>
			<LITERARY-WORK-DESCRIPTION_TYPE>O Dziele literackim</LITERARY-WORK-DESCRIPTION_TYPE>
			<LITERARY-WORK-SUMMARY_TYPE>Streszczenie dzieła literackiego</LITERARY-WORK-SUMMARY_TYPE>
			<TECHNICAL-REMARKS_TYPE>EP Komentarz techniczny *</TECHNICAL-REMARKS_TYPE>
			<TECHNICAL-REMARKS_DESCRIPTION>* - treść, która wyświetla się tylko na etapie prac redakcyjnych (ukrycie/pokazanie tej treści jest możliwe poprzez zmianę wartości atrybutu <emphasis role="{$TER}">Pokazuj uwagi techniczne</emphasis> w Aplikacji Redaktora)</TECHNICAL-REMARKS_DESCRIPTION>
			<GOES_TO_GLOSSARY>SŁOWNICZEK</GOES_TO_GLOSSARY>
			<DEFINITION_TYPE>Definicja</DEFINITION_TYPE>
			<DEFINITION_NAME>
				<emphasis role="{$TER}">Nazwa: </emphasis>
			</DEFINITION_NAME>
			<DEFINITION_MEANING>
				<emphasis role="{$TER}">Znaczenie: </emphasis>
			</DEFINITION_MEANING>
			<DEFINITION_EXAMPLE>
				<emphasis role="{$TER}">Przykład: </emphasis>
			</DEFINITION_EXAMPLE>
			<CONCEPT_TYPE>Pojęcie</CONCEPT_TYPE>
			<CONCEPT_NAME>
				<emphasis role="{$TER}">Nazwa: </emphasis>
			</CONCEPT_NAME>
			<CONCEPT_MEANING>
				<emphasis role="{$TER}">Znaczenie: </emphasis>
			</CONCEPT_MEANING>
			<CONCEPT_EXAMPLE>
				<emphasis role="{$TER}">Przykład: </emphasis>
			</CONCEPT_EXAMPLE>
			<CITE_TYPE>Cytat</CITE_TYPE>
			<CITE_LONG> (długi)</CITE_LONG>
			<CITE_TYPE_TYPE>
				<emphasis role="{$TER}">Typ: </emphasis>
			</CITE_TYPE_TYPE>
			<CITE_TYPE_JPOL_COMMON>Zwykły</CITE_TYPE_JPOL_COMMON>
			<CITE_TYPE_JPOL_POETRY>Literatura piękna - poezja</CITE_TYPE_JPOL_POETRY>
			<CITE_TYPE_JPOL_PROSE>Literatura piękna - proza</CITE_TYPE_JPOL_PROSE>
			<CITE_TYPE_JPOL_DRAMA>Literatura piękna - dramat</CITE_TYPE_JPOL_DRAMA>
			<CITE_TYPE_JPOL_HANDWRITING>Symulacja - pismo odręczne</CITE_TYPE_JPOL_HANDWRITING>
			<CITE_TYPE_JPOL_COMPUTER>Symulacja - pismo komputerowe</CITE_TYPE_JPOL_COMPUTER>
			<CITE_TYPE_JPOL_OFFICIAL>Symulacja - pismo urzędowe</CITE_TYPE_JPOL_OFFICIAL>
			<CITE_TYPE_JPOL_GREMLIN>Tekst chochlika</CITE_TYPE_JPOL_GREMLIN>
			<CITE_TYPE_JPOL_MOTTO-AUTHOR>Motto - autor</CITE_TYPE_JPOL_MOTTO-AUTHOR>
			<CITE_TYPE_JPOL_MOTTO-SAYING>Motto - powiedzenie</CITE_TYPE_JPOL_MOTTO-SAYING>
			<CITE_TYPE_HIST_HISTORIOGRAPHY>Historiograficzny</CITE_TYPE_HIST_HISTORIOGRAPHY>
			<CITE_TYPE_HIST_LITERATURE>Z literatury pięknej</CITE_TYPE_HIST_LITERATURE>
			<CITE_TYPE_HIST_HISTORICAL-PROSE>Ze źródła historycznego - proza</CITE_TYPE_HIST_HISTORICAL-PROSE>
			<CITE_TYPE_HIST_HISTORICAL-POETRY>Ze źródła historycznego - poezja</CITE_TYPE_HIST_HISTORICAL-POETRY>
			<CITE_READABILITY>
				<emphasis role="{$TER}">Poziom przystępności języka: </emphasis>
			</CITE_READABILITY>
			<CITE_READABILITY_EASY>Łatwy</CITE_READABILITY_EASY>
			<CITE_READABILITY_MEDIUM>Średni</CITE_READABILITY_MEDIUM>
			<CITE_READABILITY_HARD>Trudny</CITE_READABILITY_HARD>
			<CITE_START_NUMBERING>
				<emphasis role="{$TER}">Indeks początkowy numerowania wersów: </emphasis>
			</CITE_START_NUMBERING>
			<CITE_NAME>
				<emphasis role="{$TER}">Nazwa: </emphasis>
			</CITE_NAME>
			<CITE_AUTHOR>
				<emphasis role="{$TER}">Autor: </emphasis>
			</CITE_AUTHOR>
			<CITE_QUOTE>
				<emphasis role="{$TER}">Cytat: </emphasis>
			</CITE_QUOTE>
			<CITE_COMMENT>
				<emphasis role="{$TER}">Komentarz: </emphasis>
			</CITE_COMMENT>
			<RULE_TYPE>Reguła </RULE_TYPE>
			<RULE_NAME>
				<emphasis role="{$TER}">Nazwa: </emphasis>
			</RULE_NAME>
			<RULE_STATEMENT>
				<emphasis role="{$TER}">Twierdzenie: </emphasis>
			</RULE_STATEMENT>
			<RULE_PROOF>
				<emphasis role="{$TER}">Dowód: </emphasis>
			</RULE_PROOF>
			<RULE_EXAMPLE>
				<emphasis role="{$TER}">Przykład: </emphasis>
			</RULE_EXAMPLE>
			<EXERCISE_TYPE>Ćwiczenie</EXERCISE_TYPE>
			<EXERCISE_NAME>
				<emphasis role="{$TER}">Nazwa: </emphasis>
			</EXERCISE_NAME>
			<EXERCISE_CONTEXT_INDEPENDEND>
				<emphasis role="{$TER}">Jest niezależne od kontekstu: </emphasis>
			</EXERCISE_CONTEXT_INDEPENDEND>
			<CONTEXT_DEPENDEND_TRUE>Nie (może być wykorzystane <emphasis role="{$TER}">tylko</emphasis> w miejscu zdefiniowania)</CONTEXT_DEPENDEND_TRUE>
			<CONTEXT_DEPENDEND_FALSE>Tak (może być wykorzystane <emphasis role="{$TER}">poza</emphasis> miejscem zdefiniowania)</CONTEXT_DEPENDEND_FALSE>
			<EXERCISE_INTERACTIVITY_LEVEL>
				<emphasis role="{$TER}">Interaktywność ćwiczenia: </emphasis>
			</EXERCISE_INTERACTIVITY_LEVEL>
			<EXERCISE_INTERACTIVITY_LEVEL_STATIC>Statyczne, możliwa jest jednak alternatywa dla formatu klasycznego oraz mobilnego - WOMI z HTML</EXERCISE_INTERACTIVITY_LEVEL_STATIC>
			<EXERCISE_INTERACTIVITY_LEVEL_RANDOM>Definicja problemu zawiera elementy losowości - zarówno rozwiązanie, jak i wynik nie pojawią się w wersji klasycznej oraz mobilnej</EXERCISE_INTERACTIVITY_LEVEL_RANDOM>
			<EXERCISE_INTERACTIVITY_LEVEL_INTERACTIVE>W pełni interaktywne - przeznaczone jedynie do wersji klasycznej oraz mobilnej</EXERCISE_INTERACTIVITY_LEVEL_INTERACTIVE>
			<EXERCISE_ALTERNATIVE_WOMI>
				<emphasis role="{$TER}">Alternatywa dla wersji klasycznej oraz mobilnej: </emphasis>
			</EXERCISE_ALTERNATIVE_WOMI>
			<EXERCISE_EFFECT_OF_EDUCATION>
				<emphasis role="{$TER}">Efekt kształcenia: </emphasis>
			</EXERCISE_EFFECT_OF_EDUCATION>
			<EXERCISE_ON_PAPER>
				<emphasis role="{$TER}">Do rozwiązania w zeszycie: </emphasis>
			</EXERCISE_ON_PAPER>
			<EXERCISE_DIFFICULTY_LEVEL>
				<emphasis role="{$TER}">Poziom trudności: </emphasis>
			</EXERCISE_DIFFICULTY_LEVEL>
			<EXERCISE_DIFFICULTY_LEVEL_JPOL3_POZIOM1>zadanie zwykłe (poziom 1)</EXERCISE_DIFFICULTY_LEVEL_JPOL3_POZIOM1>
			<EXERCISE_DIFFICULTY_LEVEL_JPOL3_POZIOM2>zadanie z gwiazdką (poziom 2)</EXERCISE_DIFFICULTY_LEVEL_JPOL3_POZIOM2>
			<EXERCISE_TYPE_TYPE>
				<emphasis role="{$TER}">Typ ćwiczenia: </emphasis>
			</EXERCISE_TYPE_TYPE>
			<EXERCISE_TYPE_JPOL3_SIMPLE>Zwykłe</EXERCISE_TYPE_JPOL3_SIMPLE>
			<EXERCISE_TYPE_JPOL3_PAIRS>Praca w parach</EXERCISE_TYPE_JPOL3_PAIRS>
			<EXERCISE_TYPE_JPOL3_PLAY>Zabawa / gra</EXERCISE_TYPE_JPOL3_PLAY>
			<EXERCISE_TYPE_JPOL3_SORCERESS>Czarownica</EXERCISE_TYPE_JPOL3_SORCERESS>
			<EXERCISE_TYPE_JPOL3_IMP>Chochlik</EXERCISE_TYPE_JPOL3_IMP>
			<EXERCISE_TYPE_JPOL3_READING>Czytanie ze zrozumieniem</EXERCISE_TYPE_JPOL3_READING>
			<EXERCISE_TYPE_JPOL3_CHALLENGE>Wyzwanie</EXERCISE_TYPE_JPOL3_CHALLENGE>
			<EXERCISE_TYPE_JPOL3_INTERACTIVE>Ćwiczenie interaktywne</EXERCISE_TYPE_JPOL3_INTERACTIVE>
			<EXERCISE_PROBLEM>
				<emphasis role="{$TER}">Problem: </emphasis>
			</EXERCISE_PROBLEM>
			<EXERCISE_TIP>
				<emphasis role="{$TER}">Wskazówka: </emphasis>
			</EXERCISE_TIP>
			<EXERCISE_SOLUTION>
				<emphasis role="{$TER}">Rozwiązanie: </emphasis>
			</EXERCISE_SOLUTION>
			<EXERCISE_COMMENTARY>
				<emphasis role="{$TER}">Wyjaśnienie: </emphasis>
			</EXERCISE_COMMENTARY>
			<EXERCISE_EXAMPLE>
				<emphasis role="{$TER}">Przykład rozwiązania: </emphasis>
			</EXERCISE_EXAMPLE>
			<EXERCISE_WOMI_TYPE>Zadanie - WOMI</EXERCISE_WOMI_TYPE>
			<EXERCISE_SET_TYPE>Zestaw zadań</EXERCISE_SET_TYPE>
			<EXERCISE_SET_COMMAND>
				<emphasis role="{$TER}">Polecenie: </emphasis>
			</EXERCISE_SET_COMMAND>
			<EXERCISE_SET_WOMI_EXERCISE>
				<emphasis role="{$TER}">Podzadanie: </emphasis>
			</EXERCISE_SET_WOMI_EXERCISE>
			<COMMAND_TYPE>Polecenie</COMMAND_TYPE>
			<COMMAND_PROBLEM>
				<emphasis role="{$TER}">Polecenie: </emphasis>
			</COMMAND_PROBLEM>
			<COMMAND_NOTE_TIP>
				<emphasis role="{$TER}">Wskazówka: </emphasis>
			</COMMAND_NOTE_TIP>
			<COMMAND_NOTE_IMPORTANT>
				<emphasis role="{$TER}">Ważne: </emphasis>
			</COMMAND_NOTE_IMPORTANT>
			<COMMAND_NOTE_WARNING>
				<emphasis role="{$TER}">Ostrzeżenie: </emphasis>
			</COMMAND_NOTE_WARNING>
			<HOMEWORK_TYPE>Praca domowa</HOMEWORK_TYPE>
			<QUIZ_TYPE>Zadanie</QUIZ_TYPE>
			<QUIZ_TYPE_SINGLE-RESPONSE>JEDNOKROTNY WYBÓR</QUIZ_TYPE_SINGLE-RESPONSE>
			<QUIZ_TYPE_MULTIPLE-RESPONSE>WIELOKROTNY WYBÓR</QUIZ_TYPE_MULTIPLE-RESPONSE>
			<QUIZ_TYPE_ORDERED-RESPONSE>POPRAWNA KOLEJNOŚĆ</QUIZ_TYPE_ORDERED-RESPONSE>
			<QUIZ_TYPE_RANDOM>- Z LOSOWANIEM ODPOWIEDZI</QUIZ_TYPE_RANDOM>
			<QUIZ_NAME>
				<emphasis role="{$TER}">Nazwa: </emphasis>
			</QUIZ_NAME>
			<QUIZ_CONTEXT_INDEPENDEND>
				<emphasis role="{$TER}">Jest niezależne od kontekstu: </emphasis>
			</QUIZ_CONTEXT_INDEPENDEND>
			<QUIZ_ALTERNATIVE_WOMI>
				<emphasis role="{$TER}">Alternatywa dla wersji klasycznej oraz mobilnej: </emphasis>
			</QUIZ_ALTERNATIVE_WOMI>
			<QUIZ_EFFECT_OF_EDUCATION>
				<emphasis role="{$TER}">Efekt kształcenia: </emphasis>
			</QUIZ_EFFECT_OF_EDUCATION>
			<QUIZ_DIFFICULTY_LEVEL>
				<emphasis role="{$TER}">Poziom trudności: </emphasis>
			</QUIZ_DIFFICULTY_LEVEL>
			<QUIZ_DIFFICULTY_LEVEL_JPOL3_POZIOM1>zadanie zwykłe (poziom 1)</QUIZ_DIFFICULTY_LEVEL_JPOL3_POZIOM1>
			<QUIZ_DIFFICULTY_LEVEL_JPOL3_POZIOM2>zadanie z gwiazdką (poziom 2)</QUIZ_DIFFICULTY_LEVEL_JPOL3_POZIOM2>
			<QUIZ_TYPE_TYPE>
				<emphasis role="{$TER}">Typ zadania: </emphasis>
			</QUIZ_TYPE_TYPE>
			<QUIZ_TYPE_JPOL3_SIMPLE>Zwykłe</QUIZ_TYPE_JPOL3_SIMPLE>
			<QUIZ_TYPE_JPOL3_PAIRS>Praca w parach</QUIZ_TYPE_JPOL3_PAIRS>
			<QUIZ_TYPE_JPOL3_PLAY>Zabawa / gra</QUIZ_TYPE_JPOL3_PLAY>
			<QUIZ_TYPE_JPOL3_SORCERESS>Czarownica</QUIZ_TYPE_JPOL3_SORCERESS>
			<QUIZ_TYPE_JPOL3_IMP>Chochlik</QUIZ_TYPE_JPOL3_IMP>
			<QUIZ_TYPE_JPOL3_READING>Czytanie ze zrozumieniem</QUIZ_TYPE_JPOL3_READING>
			<QUIZ_TYPE_JPOL3_CHALLENGE>Wyzwanie</QUIZ_TYPE_JPOL3_CHALLENGE>
			<QUIZ_TYPE_JPOL3_INTERACTIVE>Ćwiczenie interaktywne</QUIZ_TYPE_JPOL3_INTERACTIVE>
			<QUIZ_VARIANT>
				<emphasis role="{$TER}">Rodzaj pytania: </emphasis>
			</QUIZ_VARIANT>
			<QUIZ_VARIANT_ZJ-1>Jednokrotny wybór</QUIZ_VARIANT_ZJ-1>
			<QUIZ_VARIANT_ZW-1>Wielokrotny wybór</QUIZ_VARIANT_ZW-1>
			<QUIZ_VARIANT_ZW-2>Wielokrotny wybór (prawda / fałsz)</QUIZ_VARIANT_ZW-2>
			<QUIZ_BEHAVIOUR>
				<emphasis role="{$TER}">Opcja prezentacji: </emphasis>
			</QUIZ_BEHAVIOUR>
			<QUIZ_BEHAVIOUR_RANDOMIZE>wygeneruj jeden zestaw losowo</QUIZ_BEHAVIOUR_RANDOMIZE>
			<QUIZ_BEHAVIOUR_RANDOMIZE-SETS>podziel na zestawy i wylosuj jeden</QUIZ_BEHAVIOUR_RANDOMIZE-SETS>
			<QUIZ_BEHAVIOUR_ALL-SETS>podziel na zestawy i pokaz wszystkie razem</QUIZ_BEHAVIOUR_ALL-SETS>
			<PRESENTED_ANSERS>
				<emphasis role="{$TER}">Liczba prezentowanych odpowiedzi: </emphasis>
			</PRESENTED_ANSERS>
			<CORRECT_ANSERS>
				<emphasis role="{$TER}">Zakres poprawnych odpowiedzi: </emphasis>
			</CORRECT_ANSERS>
			<QUIZ_QUESTION>
				<emphasis role="{$TER}">Pytanie: </emphasis>
			</QUIZ_QUESTION>
			<QUIZ_ANSWER>
				<emphasis role="{$TER}">Odpowiedź</emphasis>
			</QUIZ_ANSWER>
			<QUIZ_ANSWER_CORRECT>
				<emphasis role="{$TER}">(POPRAWNA): </emphasis>
			</QUIZ_ANSWER_CORRECT>
			<QUIZ_ANSWER_INCORRECT>
				<emphasis role="{$TER}">(NIEPOPRAWNA): </emphasis>
			</QUIZ_ANSWER_INCORRECT>
			<QUIZ_ANSWER_HINT>
				<emphasis role="{$TER}">Wskazówka: </emphasis>
			</QUIZ_ANSWER_HINT>
			<QUIZ_ANSWERS>
				<emphasis role="{$TER}">Odpowiedzi: </emphasis>
			</QUIZ_ANSWERS>
			<QUIZ_ANSWERS_SET_STATIC>
				<emphasis role="{$TER}">Zestaw dla formatów statycznych</emphasis>
			</QUIZ_ANSWERS_SET_STATIC>
			<QUIZ_ANSWERS_SET_DYNAMIC>
				<emphasis role="{$TER}">Zestaw dla formatów dynamicznych. Numer zestawu: </emphasis>
			</QUIZ_ANSWERS_SET_DYNAMIC>
			<QUIZ_ANSWERS_SET_ALL>
				<emphasis role="{$TER}">Zestaw zarówno dla formatów statycznych, jak i dynamicznych. Numer zestawu: </emphasis>
			</QUIZ_ANSWERS_SET_ALL>
			<QUIZ_ANSWERS_POLL>
				<emphasis role="{$TER}">Pula odpowiedzi (formaty dynamiczne)</emphasis>
			</QUIZ_ANSWERS_POLL>
			<QUIZ_HINT>
				<emphasis role="{$TER}">Wskazówka: </emphasis>
			</QUIZ_HINT>
			<QUIZ_FEEDBACK>
				<emphasis role="{$TER}">Wyjaśnienie: </emphasis>
			</QUIZ_FEEDBACK>
			<QUIZ_FEEDBACK_CORRECT>
				<emphasis role="{$TER}">Komunikat (odpowidź poprawna): </emphasis>
			</QUIZ_FEEDBACK_CORRECT>
			<QUIZ_FEEDBACK_INCORRECT>
				<emphasis role="{$TER}">Komunikat (odpowidź niepoprawna): </emphasis>
			</QUIZ_FEEDBACK_INCORRECT>
			<EXPERIMENT_TYPE>Doświadczenie</EXPERIMENT_TYPE>
			<EXPERIMENT_SUPERVISED>
				<emphasis role="{$TER}">Wymaga nadzoru osoby dorosłej: </emphasis>
			</EXPERIMENT_SUPERVISED>
			<EXPERIMENT_CONTEXT_INDEPENDEND>
				<emphasis role="{$TER}">Jest niezależne od kontekstu: </emphasis>
			</EXPERIMENT_CONTEXT_INDEPENDEND>
			<EXPERIMENT_NAME>
				<emphasis role="{$TER}">Nazwa: </emphasis>
			</EXPERIMENT_NAME>
			<EXPERIMENT_PROBLEM>
				<emphasis role="{$TER}">Problem badawczy: </emphasis>
			</EXPERIMENT_PROBLEM>
			<EXPERIMENT_HYPOTHESIS>
				<emphasis role="{$TER}">Hipoteza: </emphasis>
			</EXPERIMENT_HYPOTHESIS>
			<EXPERIMENT_OBJECTIVE>
				<emphasis role="{$TER}">Cel: </emphasis>
			</EXPERIMENT_OBJECTIVE>
			<EXPERIMENT_INSTRUMENTS>
				<emphasis role="{$TER}">Materiały i przyrządy: </emphasis>
			</EXPERIMENT_INSTRUMENTS>
			<EXPERIMENT_INSTRUCTIONS>
				<emphasis role="{$TER}">Instrukcja: </emphasis>
			</EXPERIMENT_INSTRUCTIONS>
			<EXPERIMENT_CONCLUSIONS>
				<emphasis role="{$TER}">Podsumowanie: </emphasis>
			</EXPERIMENT_CONCLUSIONS>
			<EXPERIMENT_NOTE_TIP>
				<emphasis role="{$TER}">Wskazówka: </emphasis>
			</EXPERIMENT_NOTE_TIP>
			<EXPERIMENT_NOTE_IMPORTANT>
				<emphasis role="{$TER}">Ważne: </emphasis>
			</EXPERIMENT_NOTE_IMPORTANT>
			<EXPERIMENT_NOTE_WARNING>
				<emphasis role="{$TER}">Ostrzeżenie: </emphasis>
			</EXPERIMENT_NOTE_WARNING>
			<OBSERVATION_TYPE>Obserwacja</OBSERVATION_TYPE>
			<OBSERVATION_SUPERVISED>
				<emphasis role="{$TER}">Wymaga nadzoru osoby dorosłej: </emphasis>
			</OBSERVATION_SUPERVISED>
			<OBSERVATION_CONTEXT_INDEPENDEND>
				<emphasis role="{$TER}">Jest niezależna od kontekstu: </emphasis>
			</OBSERVATION_CONTEXT_INDEPENDEND>
			<OBSERVATION_NAME>
				<emphasis role="{$TER}">Nazwa: </emphasis>
			</OBSERVATION_NAME>
			<OBSERVATION_OBJECTIVE>
				<emphasis role="{$TER}">Cel: </emphasis>
			</OBSERVATION_OBJECTIVE>
			<OBSERVATION_INSTRUMENTS>
				<emphasis role="{$TER}">Materiały i przyrządy: </emphasis>
			</OBSERVATION_INSTRUMENTS>
			<OBSERVATION_INSTRUCTIONS>
				<emphasis role="{$TER}">Instrukcja: </emphasis>
			</OBSERVATION_INSTRUCTIONS>
			<OBSERVATION_CONCLUSIONS>
				<emphasis role="{$TER}">Podsumowanie: </emphasis>
			</OBSERVATION_CONCLUSIONS>
			<OBSERVATION_NOTE_TIP>
				<emphasis role="{$TER}">Wskazówka: </emphasis>
			</OBSERVATION_NOTE_TIP>
			<OBSERVATION_NOTE_IMPORTANT>
				<emphasis role="{$TER}">Ważne: </emphasis>
			</OBSERVATION_NOTE_IMPORTANT>
			<OBSERVATION_NOTE_WARNING>
				<emphasis role="{$TER}">Ostrzeżenie: </emphasis>
			</OBSERVATION_NOTE_WARNING>
			<BIOGRAPHY_TYPE>Biogram</BIOGRAPHY_TYPE>
			<BIOGRAPHY_NAME>
				<emphasis role="{$TER}">Nazwa: </emphasis>
			</BIOGRAPHY_NAME>
			<BIOGRAPHY_SORTING_KEY>
				<emphasis role="{$TER}">Klucz sortowania: </emphasis>
			</BIOGRAPHY_SORTING_KEY>
			<BIOGRAPHY_BIRTH>
				<emphasis role="{$TER}">Urodzenie</emphasis>
			</BIOGRAPHY_BIRTH>
			<BIOGRAPHY_BIRTH_DATE_FORMAT>
				<emphasis role="{$TER}">Format daty: </emphasis>
			</BIOGRAPHY_BIRTH_DATE_FORMAT>
			<BIOGRAPHY_BIRTH_DATE_FORMAT_EXACT>Dokładna data</BIOGRAPHY_BIRTH_DATE_FORMAT_EXACT>
			<BIOGRAPHY_BIRTH_DATE_FORMAT_YEAR>Tylko rok</BIOGRAPHY_BIRTH_DATE_FORMAT_YEAR>
			<BIOGRAPHY_BIRTH_DATE_FORMAT_CENTURY>Tylko wiek</BIOGRAPHY_BIRTH_DATE_FORMAT_CENTURY>
			<BIOGRAPHY_BIRTH_DATE_FORMAT_AROUND-YEAR>Około ... roku</BIOGRAPHY_BIRTH_DATE_FORMAT_AROUND-YEAR>
			<BIOGRAPHY_BIRTH_DATE_FORMAT_BEGINNING-OF-CENTURY>Na początku ... wieku</BIOGRAPHY_BIRTH_DATE_FORMAT_BEGINNING-OF-CENTURY>
			<BIOGRAPHY_BIRTH_DATE_FORMAT_END-OF-CENTURY>Na końcu ... wieku</BIOGRAPHY_BIRTH_DATE_FORMAT_END-OF-CENTURY>
			<BIOGRAPHY_BIRTH_DATE_FORMAT_MIDDLE-OF-CENTURY>Na przełomie ... (i następnego) wieku</BIOGRAPHY_BIRTH_DATE_FORMAT_MIDDLE-OF-CENTURY>
			<BIOGRAPHY_BIRTH_DATE_FORMAT_TURN-OF-CENTURY>W połowie ... wieku</BIOGRAPHY_BIRTH_DATE_FORMAT_TURN-OF-CENTURY>
			<BIOGRAPHY_BIRTH_DATE>
				<emphasis role="{$TER}">Data: </emphasis>
			</BIOGRAPHY_BIRTH_DATE>
			<BIOGRAPHY_BIRTH_DATE_CENTURY>
				<emphasis role="{$TER}">Data (zakres): </emphasis>
			</BIOGRAPHY_BIRTH_DATE_CENTURY>
			<BIOGRAPHY_BIRTH_PLACE>
				<emphasis role="{$TER}">Miejsce: </emphasis>
			</BIOGRAPHY_BIRTH_PLACE>
			<BIOGRAPHY_DEATH>
				<emphasis role="{$TER}">Śmierć</emphasis>
			</BIOGRAPHY_DEATH>
			<BIOGRAPHY_DEATH_DATE_FORMAT>
				<emphasis role="{$TER}">Format daty: </emphasis>
			</BIOGRAPHY_DEATH_DATE_FORMAT>
			<BIOGRAPHY_DEATH_DATE_FORMAT_EXACT>Dokładna data</BIOGRAPHY_DEATH_DATE_FORMAT_EXACT>
			<BIOGRAPHY_DEATH_DATE_FORMAT_YEAR>Tylko rok</BIOGRAPHY_DEATH_DATE_FORMAT_YEAR>
			<BIOGRAPHY_DEATH_DATE_FORMAT_CENTURY>Tylko wiek</BIOGRAPHY_DEATH_DATE_FORMAT_CENTURY>
			<BIOGRAPHY_DEATH_DATE_FORMAT_AROUND-YEAR>Około ... roku</BIOGRAPHY_DEATH_DATE_FORMAT_AROUND-YEAR>
			<BIOGRAPHY_DEATH_DATE_FORMAT_BEGINNING-OF-CENTURY>Na początku ... wieku</BIOGRAPHY_DEATH_DATE_FORMAT_BEGINNING-OF-CENTURY>
			<BIOGRAPHY_DEATH_DATE_FORMAT_END-OF-CENTURY>Na końcu ... wieku</BIOGRAPHY_DEATH_DATE_FORMAT_END-OF-CENTURY>
			<BIOGRAPHY_DEATH_DATE_FORMAT_MIDDLE-OF-CENTURY>Na przełomie ... (i następnego) wieku</BIOGRAPHY_DEATH_DATE_FORMAT_MIDDLE-OF-CENTURY>
			<BIOGRAPHY_DEATH_DATE_FORMAT_TURN-OF-CENTURY>W połowie ... wieku</BIOGRAPHY_DEATH_DATE_FORMAT_TURN-OF-CENTURY>
			<BIOGRAPHY_DEATH_DATE>
				<emphasis role="{$TER}">Data: </emphasis>
			</BIOGRAPHY_DEATH_DATE>
			<BIOGRAPHY_DEATH_DATE_CENTURY>
				<emphasis role="{$TER}">Data (zakres): </emphasis>
			</BIOGRAPHY_DEATH_DATE_CENTURY>
			<BIOGRAPHY_DEATH_PLACE>
				<emphasis role="{$TER}">Miejsce: </emphasis>
			</BIOGRAPHY_DEATH_PLACE>
			<BIOGRAPHY_MAIN_WOMI>
				<emphasis role="{$TER}">Główne WOMI biogramu: </emphasis>
			</BIOGRAPHY_MAIN_WOMI>
			<BIOGRAPHY_WOMI>
				<emphasis role="{$TER}">WOMI biogramu: </emphasis>
			</BIOGRAPHY_WOMI>
			<BIOGRAPHY_DESCRIPTION>
				<emphasis role="{$TER}">Opis</emphasis>
			</BIOGRAPHY_DESCRIPTION>
			<EVENT_TYPE>Wydarzenie</EVENT_TYPE>
			<EVENT_NAME>
				<emphasis role="{$TER}">Nazwa: </emphasis>
			</EVENT_NAME>
			<EVENT_START>
				<emphasis role="{$TER}">Wystąpienie/rozpoczęcie</emphasis>
			</EVENT_START>
			<EVENT_START_DATE_FORMAT>
				<emphasis role="{$TER}">Format daty: </emphasis>
			</EVENT_START_DATE_FORMAT>
			<EVENT_START_DATE_FORMAT_EXACT>Dokładna data</EVENT_START_DATE_FORMAT_EXACT>
			<EVENT_START_DATE_FORMAT_YEAR>Tylko rok</EVENT_START_DATE_FORMAT_YEAR>
			<EVENT_START_DATE_FORMAT_CENTURY>Tylko wiek</EVENT_START_DATE_FORMAT_CENTURY>
			<EVENT_START_DATE_FORMAT_AROUND-YEAR>Około ... roku</EVENT_START_DATE_FORMAT_AROUND-YEAR>
			<EVENT_START_DATE_FORMAT_BEGINNING-OF-CENTURY>Na początku ... wieku</EVENT_START_DATE_FORMAT_BEGINNING-OF-CENTURY>
			<EVENT_START_DATE_FORMAT_END-OF-CENTURY>Na końcu ... wieku</EVENT_START_DATE_FORMAT_END-OF-CENTURY>
			<EVENT_START_DATE_FORMAT_MIDDLE-OF-CENTURY>Na przełomie ... (i następnego) wieku</EVENT_START_DATE_FORMAT_MIDDLE-OF-CENTURY>
			<EVENT_START_DATE_FORMAT_TURN-OF-CENTURY>W połowie ... wieku</EVENT_START_DATE_FORMAT_TURN-OF-CENTURY>
			<EVENT_START_DATE>
				<emphasis role="{$TER}">Data: </emphasis>
			</EVENT_START_DATE>
			<EVENT_START_DATE_CENTURY>
				<emphasis role="{$TER}">Data (zakres): </emphasis>
			</EVENT_START_DATE_CENTURY>
			<EVENT_START_PLACE>
				<emphasis role="{$TER}">Miejsce: </emphasis>
			</EVENT_START_PLACE>
			<EVENT_END>
				<emphasis role="{$TER}">Zakończenie</emphasis>
			</EVENT_END>
			<EVENT_END_DATE_FORMAT>
				<emphasis role="{$TER}">Format daty: </emphasis>
			</EVENT_END_DATE_FORMAT>
			<EVENT_END_DATE_FORMAT_EXACT>Dokładna data</EVENT_END_DATE_FORMAT_EXACT>
			<EVENT_END_DATE_FORMAT_YEAR>Tylko rok</EVENT_END_DATE_FORMAT_YEAR>
			<EVENT_END_DATE_FORMAT_CENTURY>Tylko wiek</EVENT_END_DATE_FORMAT_CENTURY>
			<EVENT_END_DATE_FORMAT_AROUND-YEAR>Około ... roku</EVENT_END_DATE_FORMAT_AROUND-YEAR>
			<EVENT_END_DATE_FORMAT_BEGINNING-OF-CENTURY>Na początku ... wieku</EVENT_END_DATE_FORMAT_BEGINNING-OF-CENTURY>
			<EVENT_END_DATE_FORMAT_END-OF-CENTURY>Na końcu ... wieku</EVENT_END_DATE_FORMAT_END-OF-CENTURY>
			<EVENT_END_DATE_FORMAT_MIDDLE-OF-CENTURY>Na przełomie ... (i następnego) wieku</EVENT_END_DATE_FORMAT_MIDDLE-OF-CENTURY>
			<EVENT_END_DATE_FORMAT_TURN-OF-CENTURY>W połowie ... wieku</EVENT_END_DATE_FORMAT_TURN-OF-CENTURY>
			<EVENT_END_DATE>
				<emphasis role="{$TER}">Data: </emphasis>
			</EVENT_END_DATE>
			<EVENT_END_DATE_CENTURY>
				<emphasis role="{$TER}">Data (zakres): </emphasis>
			</EVENT_END_DATE_CENTURY>
			<EVENT_END_PLACE>
				<emphasis role="{$TER}">Miejsce: </emphasis>
			</EVENT_END_PLACE>
			<EVENT_MAIN_WOMI>
				<emphasis role="{$TER}">Główne WOMI wydarzenia: </emphasis>
			</EVENT_MAIN_WOMI>
			<EVENT_WOMI>
				<emphasis role="{$TER}">WOMI wydarzenia: </emphasis>
			</EVENT_WOMI>
			<EVENT_DESCRIPTION>
				<emphasis role="{$TER}">Opis</emphasis>
			</EVENT_DESCRIPTION>
			<TOOLTIP_TYPE>Dymek</TOOLTIP_TYPE>
			<TOOLTIP_NAME>
				<emphasis role="{$TER}">Nazwa: </emphasis>
			</TOOLTIP_NAME>
			<TOOLTIP_TYPE_TYPE>
				<emphasis role="{$TER}">Typ dymka: </emphasis>
			</TOOLTIP_TYPE_TYPE>
			<TOOLTIP_TYPE_JPOL3_WALKING_ENCYCLOPEDY>Chodząca Encyklopedia</TOOLTIP_TYPE_JPOL3_WALKING_ENCYCLOPEDY>
			<TOOLTIP_TYPE_JPOL3_MISS_RECIPE>Panna Recepta</TOOLTIP_TYPE_JPOL3_MISS_RECIPE>
			<TOOLTIP_TYPE_JPOL3_CURIOSITY>Ciekawostka</TOOLTIP_TYPE_JPOL3_CURIOSITY>
			<TOOLTIP_TYPE_JPOL3_LAUGHTER>Śmiech to zdrowie</TOOLTIP_TYPE_JPOL3_LAUGHTER>
			<TOOLTIP_TYPE_JPOL3_DONT_FORGET>Niezapominajka</TOOLTIP_TYPE_JPOL3_DONT_FORGET>
			<TOOLTIP_TYPE_JPOL4_5_CURIOSITY>Ciekawostka</TOOLTIP_TYPE_JPOL4_5_CURIOSITY>
			<TOOLTIP_TYPE_JPOL4_5_APPOSITION>Dopowiedzenie</TOOLTIP_TYPE_JPOL4_5_APPOSITION>
			<TOOLTIP_TYPE_JPOL4_5_GLOSSARY>Glosariusz</TOOLTIP_TYPE_JPOL4_5_GLOSSARY>
			<TOOLTIP_CONTENT>
				<emphasis role="{$TER}">Treść: </emphasis>
			</TOOLTIP_CONTENT>
			<CODEBLOCK_TYPE>Kod</CODEBLOCK_TYPE>
			<CODEBLOCK_LANGUAGE>
				<emphasis role="{$TER}">Język: </emphasis>
			</CODEBLOCK_LANGUAGE>
			<CODEBLOCK_NAME>
				<emphasis role="{$TER}">Nazwa: </emphasis>
			</CODEBLOCK_NAME>
			<CODEBLOCK_CODE>
				<emphasis role="{$TER}">Kod: </emphasis>
			</CODEBLOCK_CODE>
			<PROCEDURE-INSTRUCTIONS_TYPE>Instrukcja postępowania</PROCEDURE-INSTRUCTIONS_TYPE>
			<PROCEDURE-INSTRUCTIONS_NAME>
				<emphasis role="{$TER}">Nazwa: </emphasis>
			</PROCEDURE-INSTRUCTIONS_NAME>
			<PROCEDURE-INSTRUCTIONS_STEP>
				<emphasis role="{$TER}">Krok: </emphasis>
			</PROCEDURE-INSTRUCTIONS_STEP>
			<LIST_TYPE>Nazwana lista</LIST_TYPE>
			<LIST_NAME>
				<emphasis role="{$TER}">Nazwa: </emphasis>
			</LIST_NAME>
			<LIST_LIST>
				<emphasis role="{$TER}">Lista: </emphasis>
			</LIST_LIST>
			<INLINE_COMMENT_STYLE_GLOSSARY-REFERENCE>
				<xsl:value-of select="$EP_STYLES/style[@key='EPKSowniczek-odwoanie']/hr-name/text()"/>
			</INLINE_COMMENT_STYLE_GLOSSARY-REFERENCE>
			<INLINE_COMMENT_STYLE_TOOLTIP-REFERENCE>
				<xsl:value-of select="$EP_STYLES/style[@key='EPKDymek-odwoanie']/hr-name/text()"/>
			</INLINE_COMMENT_STYLE_TOOLTIP-REFERENCE>
			<INLINE_COMMENT_STYLE_EVENT-REFERENCE>
				<xsl:value-of select="$EP_STYLES/style[@key='EPKWydarzenie-odwoanie']/hr-name/text()"/>
			</INLINE_COMMENT_STYLE_EVENT-REFERENCE>
			<INLINE_COMMENT_STYLE_BIOGRAPHY-REFERENCE>
				<xsl:value-of select="$EP_STYLES/style[@key='EPKBiogram-odwoanie']/hr-name/text()"/>
			</INLINE_COMMENT_STYLE_BIOGRAPHY-REFERENCE>
			<INLINE_COMMENT_STYLE_BIBLIOGRAPHY-REFERENCE>
				<xsl:value-of select="$EP_STYLES/style[@key='EPKZapisbibliograficzny-odwoanie']/hr-name/text()"/>
			</INLINE_COMMENT_STYLE_BIBLIOGRAPHY-REFERENCE>
			<xsl:if test="$INLINE_MARKS">
				<TERM_START>&lt;<emphasis role="{$IER}">O</emphasis>&gt;</TERM_START>
				<TERM_END>&lt;<emphasis role="{$IER}">/O</emphasis>&gt;</TERM_END>
				<EMPHASIS_START>&lt;<emphasis role="{$IER}">E</emphasis>&gt;</EMPHASIS_START>
				<EMPHASIS_END>&lt;<emphasis role="{$IER}">/E</emphasis>&gt;</EMPHASIS_END>
				<EMPHASIS_BOLD_START>&lt;<emphasis role="{$IER}">E-B</emphasis>&gt;</EMPHASIS_BOLD_START>
				<EMPHASIS_BOLD_END>&lt;<emphasis role="{$IER}">/E-B</emphasis>&gt;</EMPHASIS_BOLD_END>
				<EMPHASIS_BOLDITALICS_START>&lt;<emphasis role="{$IER}">E-BI</emphasis>&gt;</EMPHASIS_BOLDITALICS_START>
				<EMPHASIS_BOLDITALICS_END>&lt;<emphasis role="{$IER}">/E-BI</emphasis>&gt;</EMPHASIS_BOLDITALICS_END>
				<AUTHOR_INLINE_START>&lt;<emphasis role="{$IER}">A</emphasis>&gt;</AUTHOR_INLINE_START>
				<AUTHOR_INLINE_END>&lt;<emphasis role="{$IER}">/A</emphasis>&gt;</AUTHOR_INLINE_END>
				<WRITING_START>&lt;<emphasis role="{$IER}">TUL</emphasis>&gt;</WRITING_START>
				<WRITING_END>&lt;<emphasis role="{$IER}">/TUL</emphasis>&gt;</WRITING_END>
				<EVENT-NAME_START>&lt;<emphasis role="{$IER}">WWT</emphasis>&gt;</EVENT-NAME_START>
				<EVENT-NAME_END>&lt;<emphasis role="{$IER}">/WWT</emphasis>&gt;</EVENT-NAME_END>
				<CITE_START>&lt;<emphasis role="{$IER}">C</emphasis>&gt;</CITE_START>
				<CITE_END>&lt;<emphasis role="{$IER}">/C</emphasis>&gt;</CITE_END>
				<CODE_START_A>&lt;<emphasis role="{$IER}">K</emphasis>
				</CODE_START_A>
				<CODE_START_B>&gt;</CODE_START_B>
				<CODE_END>&lt;<emphasis role="{$IER}">/K</emphasis>&gt;</CODE_END>
				<FOREIGNPHRASE_START>&lt;<emphasis role="{$IER}">JO</emphasis>&gt;</FOREIGNPHRASE_START>
				<FOREIGNPHRASE_END>&lt;<emphasis role="{$IER}">/JO</emphasis>&gt;</FOREIGNPHRASE_END>
				<TOOLTIP_REFERENCE_START_A>&lt;<emphasis role="{$IER}">DYMEK-REF</emphasis>
				</TOOLTIP_REFERENCE_START_A>
				<TOOLTIP_REFERENCE_START_B>&gt;</TOOLTIP_REFERENCE_START_B>
				<TOOLTIP_REFERENCE_END>&lt;<emphasis role="{$IER}">/DYMEK-REF</emphasis>&gt;</TOOLTIP_REFERENCE_END>
				<GLOSSARY_REFERENCE_START_A>&lt;<emphasis role="{$IER}">SŁOWNIK-REF</emphasis>
				</GLOSSARY_REFERENCE_START_A>
				<GLOSSARY_REFERENCE_START_B>&gt;</GLOSSARY_REFERENCE_START_B>
				<GLOSSARY_REFERENCE_END>&lt;<emphasis role="{$IER}">/SŁOWNIK-REF</emphasis>&gt;</GLOSSARY_REFERENCE_END>
				<CONCEPT_REFERENCE_START_A>&lt;<emphasis role="{$IER}">POJĘCIE-REF</emphasis>
				</CONCEPT_REFERENCE_START_A>
				<CONCEPT_REFERENCE_START_B>&gt;</CONCEPT_REFERENCE_START_B>
				<CONCEPT_REFERENCE_END>&lt;<emphasis role="{$IER}">/POJĘCIE-REF</emphasis>&gt;</CONCEPT_REFERENCE_END>
				<EVENT_REFERENCE_START_A>&lt;<emphasis role="{$IER}">WYDARZENIE-REF</emphasis>
				</EVENT_REFERENCE_START_A>
				<EVENT_REFERENCE_START_B>&gt;</EVENT_REFERENCE_START_B>
				<EVENT_REFERENCE_END>&lt;<emphasis role="{$IER}">/WYDARZENIE-REF</emphasis>&gt;</EVENT_REFERENCE_END>
				<BIOGRAPHY_REFERENCE_START_A>&lt;<emphasis role="{$IER}">BIOGRAM-REF</emphasis>
				</BIOGRAPHY_REFERENCE_START_A>
				<BIOGRAPHY_REFERENCE_START_B>&gt;</BIOGRAPHY_REFERENCE_START_B>
				<BIOGRAPHY_REFERENCE_END>&lt;<emphasis role="{$IER}">/BIOGRAM-REF</emphasis>&gt;</BIOGRAPHY_REFERENCE_END>
				<BIBLIOGRAPHY_REFERENCE_START_A>&lt;<emphasis role="{$IER}">BIBLIOGRAFIA-REF</emphasis>
				</BIBLIOGRAPHY_REFERENCE_START_A>
				<BIBLIOGRAPHY_REFERENCE_START_B>&gt;</BIBLIOGRAPHY_REFERENCE_START_B>
				<BIBLIOGRAPHY_REFERENCE_END>&lt;<emphasis role="{$IER}">/BIBLIOGRAFIA-REF</emphasis>&gt;</BIBLIOGRAPHY_REFERENCE_END>
			</xsl:if>
			<CODE_LANGUAGE>
				<emphasis role="{$IER}"> język:</emphasis>
			</CODE_LANGUAGE>
			<TOOLTIP_REFERENCE>
				<emphasis role="{$IER}"> dymek:</emphasis>
			</TOOLTIP_REFERENCE>
			<ATTRIBUTE_OPTION_TRUE>Tak</ATTRIBUTE_OPTION_TRUE>
			<ATTRIBUTE_OPTION_FALSE>Nie</ATTRIBUTE_OPTION_FALSE>
			<ET0000_TITLE>Tabela</ET0000_TITLE>
			<ET0001>Brak tytułu tabeli (ET0001).</ET0001>
			<ET0002>Brak tekstu alternatywnego dla tabeli (ET0002).</ET0002>
			<EL0004_TITLE>Łącze do zasobu zewnętrznego</EL0004_TITLE>
			<EL0004>Nie można przetworzyć łącza zdefiniowanego w tym dokumencie. Łącze wykorzystuje niedozwolony protokoł (EL0004).</EL0004>
		</locales>
	</xsl:variable>
	<xsl:variable name="DI" as="element()">
		<dyna_issues>
			<entry key="DEFAULT">
				<TITLE>Błąd konwertera</TITLE>
				<PATTERN>Wystąpił problem, którego opis nie jest dostępny w konwerterze. Identyfikator problemu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>, typ problemu: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (EC0001).</PATTERN>
			</entry>
			<entry key="EW0001">
				<TITLE>WOMI</TITLE>
				<PATTERN>Szerokość WOMI nie mogła być prawidłowo przetworzona. Zdefiniowana wartość to <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>, podczas gdy wartość dozwolona jest liczbą całkowitą z zakresy 1-100 włącznie. Błąd dotyczy WOMI o identyfikatorze <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (EW0001).</PATTERN>
			</entry>
			<entry key="EW0002">
				<TITLE>WOMI</TITLE>
				<PATTERN>Referencja do WOMI nie mogła być prawidłowo przetworzona, tekst alternatywny wykorzystywany do rozpoznania tabeli WOMI ma wartość <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EW0002).</PATTERN>
			</entry>
			<entry key="WOMI_attribute_pattern_mismatch">
				<TITLE>WOMI</TITLE>
				<PATTERN>Nieprawidłowa wartość dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość dozwolona to: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>, podczas gdy w dokumencie znajduje się wartość: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis>. Błąd dotyczy WOMI o identyfikatorze <emphasis role="{$TER}">
						<epconvert:token number="4"/>
					</emphasis> (EW0003).</PATTERN>
			</entry>
			<entry key="WOMI_attribute_unknown_option">
				<TITLE>WOMI</TITLE>
				<PATTERN>Nieznana opcja dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> nie została rozpoznana. Błąd dotyczy WOMI o identyfikatorze <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (EW0004).</PATTERN>
			</entry>
			<entry key="WOMI_attribute_duplicate">
				<TITLE>WOMI</TITLE>
				<PATTERN>Duplikat atrybutu WOMI. Dotyczy atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> w WOMI o identyfikatorze <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (EW0005).</PATTERN>
			</entry>
			<entry key="WOMI_attribute_missing">
				<TITLE>WOMI</TITLE>
				<PATTERN>Brakuje atrybutu WOMI. Dotyczy atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> w WOMI o identyfikatorze <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (EW0006).</PATTERN>
			</entry>
			<entry key="WOMI_reference_unable_to_parse">
				<TITLE>WOMI</TITLE>
				<PATTERN>Referencja do WOMI nie mogła być prawidłowo przetworzona (EW0007).</PATTERN>
			</entry>
			<entry key="WOMI_zoomable_while_not_image">
				<TITLE>WOMI</TITLE>
				<PATTERN>Womi typu innego niż obraz lub ikona nie może mieć ustawionego atrybutu <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> na wartość inną niż <emphasis role="{$TER}">Brak</emphasis> lub <emphasis role="{$TER}">Nie</emphasis>. Dotyczy WOMI o identyfikatorze <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (EW0008).</PATTERN>
			</entry>
			<entry key="WOMI_avatar_while_not_oint">
				<TITLE>WOMI</TITLE>
				<PATTERN>Womi typu innego niż aplikacja interaktywna nie może mieć ustawionego atrybutu <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> na wartość <emphasis role="{$TER}">Tak</emphasis>. Dotyczy WOMI o identyfikatorze <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (EW0009).</PATTERN>
			</entry>
			<entry key="WW0001">
				<TITLE>WOMI</TITLE>
				<PATTERN>Kilka tabel z WOMI zostało ze sobą sklejonych. Być może zamysłem było stworzenie galerii, niemniej jednak brakuje częsci tabeli opisującej jej atrybuty. Identyfikatory sklejonych WOMI:<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (WW0001).</PATTERN>
			</entry>
			<entry key="WOMI_reference_no_context_but_static_text">
				<TITLE>WOMI</TITLE>
				<PATTERN>Tekst skojarzony z WOMI źle zdefiniowany. WOMI <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> zostało zadeklarowane jako WOMI kontekstu, które nie pojawi się w wersjach statycznych, podczas, gdy zdefiniowano tekst dla <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (WW0002).</PATTERN>
			</entry>
			<entry key="WOMI_text_copy_but_no_classic_text">
				<TITLE>WOMI</TITLE>
				<PATTERN>Zaznaczono opcję kopiowania tekstu skojarzonego z WOMI z pola dla wersji klasycznej, ale pole to jest puste. Dotyczy WOMI o id: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (WW0003).</PATTERN>
			</entry>
			<entry key="WOMI_gallery_attribute_pattern_mismatch">
				<TITLE>Galeria WOMI</TITLE>
				<PATTERN>Problem z tabelką z atrybutami galerii WOMI. Nieprawidłowa wartość dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość dozwolona to: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>, podczas gdy w dokumencie znajduje się wartość: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (EG0001).</PATTERN>
			</entry>
			<entry key="WOMI_gallery_attribute_unknown_option">
				<TITLE>Galeria WOMI</TITLE>
				<PATTERN>Problem z tabelką z atrybutami galerii WOMI. Nieznana opcja dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> nie została rozpoznana (EG0002).</PATTERN>
			</entry>
			<entry key="WOMI_gallery_attribute_duplicate">
				<TITLE>Galeria WOMI</TITLE>
				<PATTERN>Problem z tabelką z atrybutami galerii WOMI. Duplikat atrybutu galerii WOMI. Dotyczy atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EG0003).</PATTERN>
			</entry>
			<entry key="WOMI_gallery_attribute_missing">
				<TITLE>Galeria WOMI</TITLE>
				<PATTERN>Problem z tabelką z atrybutami galerii WOMI. Brakuje atrybutu galerii WOMI. Dotyczy atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EG0004).</PATTERN>
			</entry>
			<entry key="WOMI_gallery_less_then_2_WOMIes">
				<TITLE>Galeria WOMI</TITLE>
				<PATTERN>Liczba WOMI w galerii jest mniejsza niż 2 (EG0005).</PATTERN>
			</entry>
			<entry key="WOMI_gallery_attribute_undefined">
				<TITLE>Galeria WOMI</TITLE>
				<PATTERN>Problem z tabelką z atrybutami galerii WOMI. Nie zdefiniowano atrybutu <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>, jego wykorzystanie jest jednak  niezbędne w przypadku galerii typu <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (EG0006).</PATTERN>
			</entry>
			<entry key="WOMI_gallery_start_on_greater_than_no_of_WOMIs">
				<TITLE>Galeria WOMI</TITLE>
				<PATTERN>Problem z tabelką z atrybutami galerii WOMI. Wartość atrybutu <emphasis role="{$TER}">Początkowy element galerii</emphasis> (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>) jest wyższa niż liczba wszystkich WOMI w galerii (<emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>) (EG0007).</PATTERN>
			</entry>
			<entry key="WOMI_gallery_playlist_but_not_playlist_option_chosen">
				<TITLE>Galeria WOMI</TITLE>
				<PATTERN>Problem z tabelką z atrybutami galerii WOMI. Wybrano galerię typu <emphasis role="{$TER}">Playlista wideo</emphasis> lecz nie wyspecyfikowano <emphasis role="{$TER}">Sposobu odtwarzania</emphasis>) (EG0008).</PATTERN>
			</entry>
			<entry key="WOMI_gallery_playlist_but_WOMI_not_VIDEO_or_IMAGE">
				<TITLE>Galeria WOMI</TITLE>
				<PATTERN>W tabelce galerii WOMI typu <emphasis role="{$TER}">Playlista wideo</emphasis> znajduje się WOMI <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>, które nie jest typu wideo, ilustracja lub ikona (EG0009).</PATTERN>
			</entry>
			<entry key="WOMI_gallery_text_copy_but_no_classic_text">
				<TITLE>Galeria WOMI</TITLE>
				<PATTERN>Problem z tabelką z atrybutami galerii WOMI. Zaznaczono opcję kopiowania tekstu skojarzonego z galerią WOMI z pola dla wersji klasycznej, ale pole to jest puste (WG0001).</PATTERN>
			</entry>
			<entry key="WOMI_gallery_type_disallowed_attribute">
				<TITLE>Galeria WOMI</TITLE>
				<PATTERN>Problem z tabelką z atrybutami galerii WOMI. Wykorzystano atrybut <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>, atrybut ten nie powinien być zastosowany w połączeniu z galerią typu <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (WG0002).</PATTERN>
			</entry>
			<entry key="EM0001">
				<TITLE>Tytuł modułu</TITLE>
				<PATTERN>Brak akapitu oznaczonego stylem <emphasis role="{$TER}">EP Tytuł modułu</emphasis> (EM0001).</PATTERN>
			</entry>
			<entry key="global_metadata_field_unknown_option">
				<TITLE>Atrybut modułu</TITLE>
				<PATTERN>Problem z tabelką z atrybutami modułu. Nieprawidłowa opcja w polu wyboru dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EM0002).</PATTERN>
			</entry>
			<entry key="global_metadata_field_missing">
				<TITLE>Atrybut modułu</TITLE>
				<PATTERN>Problem z tabelką z atrybutami modułu. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EM0003).</PATTERN>
			</entry>
			<entry key="global_metadata_field_duplicate">
				<TITLE>Atrybut modułu</TITLE>
				<PATTERN>Problem z tabelką z atrybutami modułu. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EM0004).</PATTERN>
			</entry>
			<entry key="global_metadata_field_pattern_mismatch">
				<TITLE>Atrybut modułu</TITLE>
				<PATTERN>Problem z tabelką z atrybutami modułu. Nieprawidłowa wartość dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość dozwolona to: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>, podczas gdy w dokumencie znajduje się wartość: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (EM0005).</PATTERN>
			</entry>
			<entry key="EM0006">
				<TITLE>Autor modułu</TITLE>
				<PATTERN>Moduł musi mieć zdefiniowanego co najmniej jednego autora (EM0006).</PATTERN>
			</entry>
			<entry key="EM0007">
				<TITLE>Hasło podstawy programowej</TITLE>
				<PATTERN>Moduł musi mieć zdefiniowane co najmniej jedno hasło podstawy programowej (EM0007).</PATTERN>
			</entry>
			<entry key="author_metadata_field_missing">
				<TITLE>Autor modułu</TITLE>
				<PATTERN>Problem z tabelką z autorem modułu. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EM0008).</PATTERN>
			</entry>
			<entry key="author_metadata_field_duplicate">
				<TITLE>Autor modułu</TITLE>
				<PATTERN>Problem z tabelką z autorem modułu. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EM0009).</PATTERN>
			</entry>
			<entry key="author_metadata_field_pattern_mismatch">
				<TITLE>Autor modułu</TITLE>
				<PATTERN>Problem z tabelką z autorem modułu. Nieprawidłowa wartość dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość dozwolona to: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>, podczas gdy w dokumencie znajduje się wartość: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (EM0010).</PATTERN>
			</entry>
			<entry key="core_curriculum_metadata_field_missing">
				<TITLE>Hasło podstawy programowej</TITLE>
				<PATTERN>Problem z tabelką z hasłem podstawy programowej. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EM0011).</PATTERN>
			</entry>
			<entry key="core_curriculum_metadata_field_pattern_mismatch">
				<TITLE>Hasło podstawy programowej</TITLE>
				<PATTERN>Problem z tabelką z hasłem podstawy programowej. Nieprawidłowa wartość dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość dozwolona to: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>, podczas gdy w dokumencie znajduje się wartość: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (EM0012).</PATTERN>
			</entry>
			<entry key="author_duplicate">
				<TITLE>Autor modułu</TITLE>
				<PATTERN>Autor modułu zduplikowany. Autor o identycznym imieniu, nazwisku oraz adresie email został już zdefiniowany w module (EM0013).</PATTERN>
			</entry>
			<entry key="global_metadata_table_duplicate">
				<TITLE>Metadane modułu</TITLE>
				<PATTERN>Tabelka z metadanymi modułu została wstawiona do dokumentu więcej niż 1 raz (EM0014).</PATTERN>
			</entry>
			<entry key="global_metadata_table_missing">
				<TITLE>Metadane modułu</TITLE>
				<PATTERN>W dokumencie brakuje tabelki z metadanymi modułu (EM0015).</PATTERN>
			</entry>
			<entry key="global_metadata_template_freeform_but_no_grid_width">
				<TITLE>Szablon modułu</TITLE>
				<PATTERN>Wybrano szablon typu <emphasis role="{$TER}">KAFLOWY - własny</emphasis>, lecz nie zdefiniowano szerokości siatki (EM0016).</PATTERN>
			</entry>
			<entry key="global_metadata_template_freeform_but_no_grid_height">
				<TITLE>Szablon modułu</TITLE>
				<PATTERN>Wybrano szablon typu <emphasis role="{$TER}">KAFLOWY - własny</emphasis>, lecz nie zdefiniowano wysokości siatki (EM0017).</PATTERN>
			</entry>
			<entry key="global_metadata_template_is_set_but_no_section_metadata">
				<TITLE>Atrybuty sekcji</TITLE>
				<PATTERN>W metadanych modułu wybrano szablon <emphasis role="{$TER}">KAFLOWY - ...</emphasis>, lecz w sekcji nie znajduje się tabelka z metadanymi (EM0018).</PATTERN>
			</entry>
			<entry key="global_metadata_template_tiles_no_mismatch_sections_no">
				<TITLE>Metadane/struktura modułu</TITLE>
				<PATTERN>Liczba sekcji pierwszego stopnia w module (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>) jest większa niż liczba kafli w wybranym szablonie (<emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>) (EM0019).</PATTERN>
			</entry>
			<entry key="keyword_metadata_field_unknown_option">
				<TITLE>Słowo kluczowe</TITLE>
				<PATTERN>Problem z tabelką ze słowem kluczowym dla modułu. Nieprawidłowa opcja w polu wyboru dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EM0020).</PATTERN>
			</entry>
			<entry key="keyword_metadata_field_missing">
				<TITLE>Słowo kluczowe</TITLE>
				<PATTERN>Problem z tabelką ze słowem kluczowym dla modułu. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EM0021).</PATTERN>
			</entry>
			<entry key="keyword_metadata_field_duplicate">
				<TITLE>Słowo kluczowe</TITLE>
				<PATTERN>Problem z tabelką ze słowem kluczowym dla modułu. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EM0022).</PATTERN>
			</entry>
			<entry key="keyword_metadata_subtype_different_then_module_metadata_subtype">
				<TITLE>Zastosowane narzędzia</TITLE>
				<PATTERN>Tabelka ze słowem kluczowym nie pochodzi z tej samej grupy narzędzi, co tabelka z metadanymi modułu. Metadane modułu pochodzą z profilu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>, w profilu tym można stosować słowa kluczowe pochodzące wyłącznie z predefiniowanej listy (EM0023).</PATTERN>
			</entry>
			<entry key="core_curriculum_metadata_duplicate_value">
				<TITLE>Hasło podstawy programowej</TITLE>
				<PATTERN>Problem z tabelką z hasłem podstawy programowej. Kilka tabelek zostało "sklejonych", a w powstałej tabeli wystąpił duplikat hasła (EM0024).</PATTERN>
			</entry>
			<entry key="core_curriculum_unable_to_map">
				<TITLE>Hasło podstawy programowej</TITLE>
				<PATTERN>Problem z tabelką z hasłem podstawy programowej. Nie można przetworzyć wartości (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>) odczytanej ze starego narzędzia do definiowania hasła podstawy programowej (EM0025).</PATTERN>
			</entry>
			<entry key="core_curriculum_unable_to_map_no_such_key">
				<TITLE>Hasło podstawy programowej</TITLE>
				<PATTERN>Problem z tabelką z hasłem podstawy programowej. Nie można znaleźć mapowania dla wartości (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>) odczytanej ze starego narzędzia do definiowania hasła podstawy programowej (EM0026).</PATTERN>
			</entry>
			<entry key="core_curriculum_metadata_duplicate_value_2">
				<TITLE>Hasło podstawy programowej</TITLE>
				<PATTERN>Duplikat definicji hasła podstawy programowej. Hasło o kodzie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> zostało zdefiniowane w dokumencie <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> razy (WM0001). </PATTERN>
			</entry>
			<entry key="global_metadata_template_not_freeform_but_grid_width">
				<TITLE>Szablon modułu</TITLE>
				<PATTERN>Wybrano szablon typu innego niż <emphasis role="{$TER}">KAFLOWY - własny</emphasis>, mimo to zdefiniowano szerokości siatki (WM0002).</PATTERN>
			</entry>
			<entry key="global_metadata_template_not_freeform_but_grid_height">
				<TITLE>Szablon modułu</TITLE>
				<PATTERN>Wybrano szablon typu innego niż <emphasis role="{$TER}">KAFLOWY - własny</emphasis>, mimo to zdefiniowano wysokość siatki (WM0003).</PATTERN>
			</entry>
			<entry key="keyword_already_defined_in_this_module">
				<TITLE>Słowo kluczowe</TITLE>
				<PATTERN>Słowo kluczowe: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> zostało już wcześniej zadeklarowane w tym module (WM0005).</PATTERN>
			</entry>
			<entry key="EL0001">
				<TITLE>Łącze do zakładki</TITLE>
				<PATTERN>Nie można przetworzyć łącza do zakładki zdefiniowanej w tym dokumencie jako <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Brak identyfikatora w mapie (EL0001).</PATTERN>
			</entry>
			<entry key="EL0002">
				<TITLE>Łącze do modułu</TITLE>
				<PATTERN>Nie można przetworzyć łącza do modułu. Moduł zdefiniowany w pliku <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> znajduje się prawdopodobnie poza przetwarzanym drzewem katalogów (EL0002).</PATTERN>
			</entry>
			<entry key="EL0003">
				<TITLE>Łącze do zasobu</TITLE>
				<PATTERN>Nie można przetworzyć łącza zdefiniowanego w tym dokumencie. Łącze <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> wskazuje najprawdopodobniej na lokalny zasób, który nie jest modułem treści (EL0003).</PATTERN>
			</entry>
			<entry key="EL0005">
				<TITLE>Łącze do zasobu zewnętrznego</TITLE>
				<PATTERN>Nie można przetworzyć łącza do zewnętrznego zasobu <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> zdefiniowanego w tym dokumencie. Łącza zewnętrzne nie są dozwolone (EL0005).</PATTERN>
			</entry>
			<entry key="WL0001">
				<TITLE>Łącze do zewnętrznej zakładki</TITLE>
				<PATTERN>Nie można przetworzyć łącza do zakładki zdefiniowanej w innym dokumencie. Brak identyfikatora zakładki <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> w mapie dla dokumentu <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (WL0001).</PATTERN>
			</entry>
			<entry key="processing_meaning_error">
				<TITLE>Błąd konwertera</TITLE>
				<PATTERN>W trakcie konwersji wystąpił błąd przetwarzania znaczenia związany z wykorzystaniem stylów komentarzowych EPK. Prosimy o kontakt z autorem konwertera (EC0002).</PATTERN>
			</entry>
			<entry key="content_before_module">
				<TITLE>Struktura modułu</TITLE>
				<PATTERN>Przed akapitem oznaczonym stylem <emphasis role="{$TER}">EP Tytuł modułu</emphasis> występuje treść (ES0001).</PATTERN>
			</entry>
			<entry key="header2_not_under_header1">
				<TITLE>Struktura modułu</TITLE>
				<PATTERN>Zastosowano styl <emphasis role="{$TER}">EP Nagłówek 2</emphasis> bez wcześniejszego wykorzystania stylu <emphasis role="{$TER}">EP Nagłówek 1</emphasis> (ES0002).</PATTERN>
			</entry>
			<entry key="header3_not_under_header1">
				<TITLE>Struktura modułu</TITLE>
				<PATTERN>Zastosowanie styl <emphasis role="{$TER}">EP Nagłówek 3</emphasis> bez wcześniejszego wykorzystania stylu <emphasis role="{$TER}">EP Nagłówek 1</emphasis> (ES0003).</PATTERN>
			</entry>
			<entry key="header3_not_under_header2">
				<TITLE>Struktura modułu</TITLE>
				<PATTERN>Zastosowanie styl <emphasis role="{$TER}">EP Nagłówek 3</emphasis> bez wcześniejszego wykorzystania stylu <emphasis role="{$TER}">EP Nagłówek 2</emphasis> (ES0004).</PATTERN>
			</entry>
			<entry key="multiple_modules">
				<TITLE>Struktura modułu</TITLE>
				<PATTERN>Więcej niż jeden osobny paragraf jest oznaczony stylem <emphasis role="{$TER}">EP Tytuł modułu</emphasis>. Obsługa wielu modółów zdefiniowanych w jednym pliku nie jest obecnie możliwa (ES0005).</PATTERN>
			</entry>
			<entry key="empty_section">
				<TITLE>Struktura modułu</TITLE>
				<PATTERN>Pusta sekcja: poniżej akapitu oznaczonego jako jeden ze stylów nagłówków nie występuje żadna treść (ES0006).</PATTERN>
			</entry>
			<entry key="incorrect_comment_nesting">
				<TITLE>Zagnieżdżenie komentarza</TITLE>
				<PATTERN>Początek oraz koniec komentarza znajdują się w różnych miejscach struktury dokumentu, co uniemożliwia prawidłowe jego przetworzenie (ES0007).</PATTERN>
			</entry>
			<entry key="expanding_or_supplemental_status_not_in_canon_module">
				<TITLE>Status Treści</TITLE>
				<PATTERN>Lokalne zdefiniowanie statusu nie jest możliwe w modułach nieoznaczonych globalnie jako <emphasis role="{$TER}">kanon</emphasis> (ES0008).</PATTERN>
			</entry>
			<entry key="expanding_and_supplemental_status">
				<TITLE>Status Treści</TITLE>
				<PATTERN>Jednoczesne oznaczenie treści dwoma wykluczającymi się statusami: <emphasis role="{$TER}">treść rozszerzająca</emphasis>, <emphasis role="{$TER}">treść uzupełniająca</emphasis> (ES0009).</PATTERN>
			</entry>
			<entry key="comment_to_much_meanings">
				<TITLE>Styl komentarza</TITLE>
				<PATTERN>Zbyt dużo znaczeń (zastosowanie stylów komentarzowych EPK) nadanych jednemu blokowi treści (ES0010).</PATTERN>
			</entry>
			<entry key="section_metadata_field_unknown_option">
				<TITLE>Atrybut sekcji</TITLE>
				<PATTERN>Problem z tabelką z atrybutami sekcji. Nieprawidłowa opcja w polu wyboru dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (ES0011).</PATTERN>
			</entry>
			<entry key="section_metadata_field_missing">
				<TITLE>Atrybut sekcji</TITLE>
				<PATTERN>Problem z tabelką z atrybutami sekcji. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (ES0012).</PATTERN>
			</entry>
			<entry key="section_metadata_field_duplicate">
				<TITLE>Atrybut sekcji</TITLE>
				<PATTERN>Problem z tabelką z atrybutami sekcji. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (ES0013).</PATTERN>
			</entry>
			<entry key="section_metadata_field_pattern_mismatch">
				<TITLE>Atrybut sekcji</TITLE>
				<PATTERN>Problem z tabelką z atrybutami sekcji. Nieprawidłowa wartość dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość dozwolona to: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>, podczas gdy w dokumencie znajduje się wartość: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (ES0014).</PATTERN>
			</entry>
			<entry key="section_metadata_not_linear_but_l2_section_metadata">
				<TITLE>Atrybuty sekcji</TITLE>
				<PATTERN>Wybrano szablon modułu inny niż <emphasis role="{$TER}">KOLUMNOWY</emphasis>, mimo to w dokumencie znajduje się tabelka z atrybutami dla sekcji 2-giego stopnia (ES0015).</PATTERN>
			</entry>
			<entry key="section_metadata_l2_not_supported_in_this_context">
				<TITLE>Atrybuty sekcji</TITLE>
				<PATTERN>Tabelka z atrybutami dla sekcji 2-giego stopnia, nie może występować w tym miejscu (ES0016).</PATTERN>
			</entry>
			<entry key="noname_section_metadata_linear_with_columns_more_than_1">
				<TITLE>Szablon modułu</TITLE>
				<PATTERN>Sekcja znajdująca się przed pierwszym nagłówkiem nie posiada podziału na podsekcje, dlatego nie wolno zastosować w niej podziału na kolumny. Wartość atrybutu liczba kolumn musi być równa <emphasis role="{$TER}">1</emphasis>, obecnie jest ustawiona na <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (ES0017).</PATTERN>
			</entry>
			<entry key="section_metadata_l2_duplicate">
				<TITLE>Atrybuty sekcji</TITLE>
				<PATTERN>Tabelka z atrybutami sekcji 2-giego stopnia została wstawiona do tej sekcji więcej niż 1 raz (ES0018).</PATTERN>
			</entry>
			<entry key="section_metadata_l2_not_supported_in_this_context_parent_no_columns_1">
				<TITLE>Atrybuty sekcji</TITLE>
				<PATTERN>Tabelka z atrybutami sekcji 2-giego stopnia może być stosowana tylko, gdy liczba kolumn w nadrzędnej sekcji jest na wartość większą niż 1 (ES0019).</PATTERN>
			</entry>
			<entry key="section_metadata_linear_missing_while_section_metadata_l2">
				<TITLE>Atrybuty sekcji</TITLE>
				<PATTERN>W sekcji brakuje tabelki z atrybutami. Tabelka ta jest konieczna do poprawnego zinterpretowania atrybutów zdefiniowanych w podsekcjach 2-giego stopnia (ES0021).</PATTERN>
			</entry>
			<entry key="section_metadata_l1_not_supported_in_this_context">
				<TITLE>Atrybuty sekcji</TITLE>
				<PATTERN>Tabelka z atrybutami dla sekcji 1-szego stopnia, nie może występować w tym miejscu (ES0022).</PATTERN>
			</entry>
			<entry key="section_metadata_l1_duplicate">
				<TITLE>Atrybuty sekcji</TITLE>
				<PATTERN>Tabelka z atrybutami sekcji 1-szego stopnia została wstawiona do tej sekcji więcej niż 1 raz (ES0023).</PATTERN>
			</entry>
			<entry key="section_metadata_no_module_type_but_role">
				<TITLE>Rola sekcji</TITLE>
				<PATTERN>Rola sekcji może być wybrana tylko w momencie, kiedy określony jest typ modułu (ES0024).</PATTERN>
			</entry>
			<entry key="section_metadata_l1_subtype_different_then_module_metadata_subtype">
				<TITLE>Zastosowane narzędzia</TITLE>
				<PATTERN>Tabelka z atrybutami sekcji nie pochodzi z tej samej grupy narzędzi, co tabelka z metadanymi modułu. Metadane modułu pochodzą z profilu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>, atrybuty sekcji pochodzą z profilu: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (ES0025).</PATTERN>
			</entry>
			<entry key="section_metadata_l1_role_not_from_that_module_type">
				<TITLE>Rola sekcji</TITLE>
				<PATTERN>Wybrana rola sekcji nie jest zgodna z typem modułu (ES0026).</PATTERN>
			</entry>
			<entry key="section_metadata_linear_but_not_linear_module">
				<TITLE>Szablon modułu</TITLE>
				<PATTERN>Atrybuty sekcji dla układu kolumnowego mogą być stosowane tylko w połączeniu z szablonem <emphasis role="{$TER}">KOLUMNOWY</emphasis> (ES0027).</PATTERN>
			</entry>
			<entry key="section_metadata_freeform_but_not_freeform_module">
				<TITLE>Szablon modułu</TITLE>
				<PATTERN>Atrybuty sekcji dla układu kaflowego własnego mogą być stosowane tylko w połączeniu z szablonem <emphasis role="{$TER}">KAFLOWY - własny</emphasis> (ES0028).</PATTERN>
			</entry>
			<entry key="section_metadata_tile_but_not_tile_module">
				<TITLE>Szablon modułu</TITLE>
				<PATTERN>Atrybuty sekcji dla układu kaflowego predefiniowanego nie mogą być stosowane w połączeniu z szablonem <emphasis role="{$TER}">LINIOWY</emphasis>, <emphasis role="{$TER}">KOLUMNOWY</emphasis> lub <emphasis role="{$TER}">KAFLOWY - własny</emphasis> (ES0029).</PATTERN>
			</entry>
			<entry key="section_metadata_l1_tile_not_from_that_template">
				<TITLE>Szablon modułu</TITLE>
				<PATTERN>Wybrany kafel nie jest zgodny z szablonem modułu (ES0030).</PATTERN>
			</entry>
			<entry key="section_metadata_linear_old_but_columns_more_then_1">
				<TITLE>Szablon modułu</TITLE>
				<PATTERN>W module z szablonem liniowym nie można określić liczby kolumn innej niż 1 (ES0031).</PATTERN>
			</entry>
			<entry key="section_metadata_tile_duplicate">
				<TITLE>Szablon modułu</TITLE>
				<PATTERN>Sekcja nie może być mapowana na kafel <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>, gdyż został już "wykorzystany" (inna wcześniejsza sekcja jest na niego mapowana) (ES0032).</PATTERN>
			</entry>
			<entry key="empty_noname_section">
				<TITLE>Struktura modułu</TITLE>
				<PATTERN>Zdefiniowano atrybuty sekcji znajdującej się przed pierwszym nagłówkiem, lecz nie zawiera ona żadnej treści (ES0033).</PATTERN>
			</entry>
			<entry key="section_metadata_linear_columns_mismatch_no_of_subsections">
				<TITLE>Struktura modułu</TITLE>
				<PATTERN>Liczba kolumn zdefiniowanych w atrybutach sekcji nie zgadza się z liczbą podsekcji. Liczba kolumn: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>, liczba podsekcji: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (ES0034).</PATTERN>
			</entry>
			<entry key="section_metadata_linear_but_content_in_section1">
				<TITLE>Struktura modułu</TITLE>
				<PATTERN>W momencie, gdy liczba kolumn jest różna od 1, sekcja nie może zawierać treści, lecz tylko podsekcje (ES0035).</PATTERN>
			</entry>
			<entry key="section_metadata_linear_but_no_l2_section_metadata">
				<TITLE>Atrybuty sekcji</TITLE>
				<PATTERN>Brak tabelki z definicją atrybutów sekcji 2-giego stopnia. Atrybuty muszą być zdefiniowane, gdyż w sekcji nadrzędnej wybrano liczbę kolumn większą niż 1 (ES0036).</PATTERN>
			</entry>
			<entry key="bibliography_local_metadata_field_pattern_mismatch">
				<TITLE>Zapis bibliograficzny</TITLE>
				<PATTERN>Problem z tabelką z zapisem bibliograficznym. Nieprawidłowa wartość dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość dozwolona to: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>, podczas gdy w dokumencie znajduje się wartość: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (EZB0001).</PATTERN>
			</entry>
			<entry key="bibliography_local_metadata_field_unknown_option">
				<TITLE>Zapis bibliograficzny</TITLE>
				<PATTERN>Problem z tabelką z zapisem bibliograficznym. Nieznana opcja dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> nie została rozpoznana (EZB0002).</PATTERN>
			</entry>
			<entry key="bibliography_local_metadata_field_missing">
				<TITLE>Zapis bibliograficzny</TITLE>
				<PATTERN>Problem z tabelką z zapisem bibliograficznym. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EZB0003).</PATTERN>
			</entry>
			<entry key="bibliography_local_metadata_field_duplicate">
				<TITLE>Zapis bibliograficzny</TITLE>
				<PATTERN>Problem z tabelką z zapisem bibliograficznym. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EZB0004).</PATTERN>
			</entry>
			<entry key="bibliography_author_at_least_one_name_missing">
				<TITLE>Zapis bibliograficzny</TITLE>
				<PATTERN>Problem z tabelką z zapisem bibliograficznym. Brakuje imienia co najmniej jednego autora (EZB0005).</PATTERN>
			</entry>
			<entry key="bibliography_author_at_least_one_surname_missing">
				<TITLE>Zapis bibliograficzny</TITLE>
				<PATTERN>Problem z tabelką z zapisem bibliograficznym. Brakuje nazwiska co najmniej jednego autora (EZB0006).</PATTERN>
			</entry>
			<entry key="bibliography_editor_at_least_one_name_missing">
				<TITLE>Zapis bibliograficzny</TITLE>
				<PATTERN>Problem z tabelką z zapisem bibliograficznym. Brakuje imienia co najmniej jednego tłumacza (EZB0007).</PATTERN>
			</entry>
			<entry key="bibliography_editor_at_least_one_surname_missing">
				<TITLE>Zapis bibliograficzny</TITLE>
				<PATTERN>Problem z tabelką z zapisem bibliograficznym. Brakuje nazwiska co najmniej jednego tłumacza (EZB0008).</PATTERN>
			</entry>
			<entry key="bibliography_minimum_1_author_required">
				<TITLE>Zapis bibliograficzny</TITLE>
				<PATTERN>W tym typie zapisu bibliograficznego należy zdefiniować co najmniej jednego autora (EZB0009).</PATTERN>
			</entry>
			<entry key="bibliography_under_that_id_already_exists">
				<TITLE>Zapis bibliograficzny - duplikat</TITLE>
				<PATTERN>Zapis bibliograficzny o unikalnym identyfikatorze <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> został zdefiniowany w tym e-podręczniku więcej niż 1 raz. Identyfikator jest wykorzystywany do połączenia zapisu z odwołaniem, dlatego identyfikatory zapisów w obrębie e-podręcznika muszą być unikalne. Pozostałe wystąpienia w tym module: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>. Wystąpienia w innych modułach: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (EZB0010).</PATTERN>
			</entry>
			<entry key="bibliography_pages_start_greather_than_pages_end">
				<TITLE>Zapis bibliograficzny</TITLE>
				<PATTERN>Numer strony początkowej jest wyższy niż numer strony końcowej (EZB0011).</PATTERN>
			</entry>
			<entry key="bibliography_reference_to_non_existing_bibliography">
				<TITLE>Zapis bibliograficzny - odwołanie</TITLE>
				<PATTERN>Zapis bibliograficzny o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> nie został zdefiniowany w tym module. Nie istnieje też zapis bibliograficzny o tej nazwie (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>) zdefiniowany w innym module tego e-podręcznika (EZB0012).</PATTERN>
			</entry>
			<entry key="bibliography_author_duplicate">
				<TITLE>Zapis bibliograficzny</TITLE>
				<PATTERN>Duplikat autora: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> w zapisie bibliograficznym (WZB0001).</PATTERN>
			</entry>
			<entry key="bibliography_editor_duplicate">
				<TITLE>Zapis bibliograficzny</TITLE>
				<PATTERN>Duplikat tłumacza: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> w zapisie bibliograficznym (WZB0002).</PATTERN>
			</entry>
			<entry key="inline_comment_nesting_error">
				<TITLE>Odwołanie</TITLE>
				<PATTERN>Komentarz zawierający styl odwołania <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> zagnieżdża się z innym komentarzem lub rozciąga się na więcej niż jeden paragraf. Dotyczy odwołania do elementu o nazwie <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (ERE0001).</PATTERN>
			</entry>
			<entry key="glossary_declaration_orphan">
				<TITLE>Styl komentarza</TITLE>
				<PATTERN>Wykorzystanie stylu komentarza <emphasis role="{$TER}">EPK Słowniczek - deklaracja</emphasis> bez połączenia ze stylem <emphasis role="{$TER}">EPK Reguła</emphasis> lub <emphasis role="{$TER}">EPK Definicja</emphasis> (EY0001).</PATTERN>
			</entry>
			<entry key="tooltip_name_duplicate">
				<TITLE>Dymek</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Dymek</emphasis> wystąpił duplikat nazwy (EDY0001).</PATTERN>
			</entry>
			<entry key="tooltip_name_missing">
				<TITLE>Dymek</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Dymek</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Nazwa</emphasis> (EDY0002).</PATTERN>
			</entry>
			<entry key="tooltip_content_missing">
				<TITLE>Dymek</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Dymek</emphasis> nie zawiera elementów oznaczonych stylem <emphasis role="{$TER}">EP Dymek</emphasis> (EDY0003).</PATTERN>
			</entry>
			<entry key="tooltip_content_duplicate">
				<TITLE>Dymek</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Dymek</emphasis> zawiera więcej niż jeden elementów oznaczonych stylem <emphasis role="{$TER}">EP Dymek</emphasis> (EDY0004).</PATTERN>
			</entry>
			<entry key="tooltip_disallowed_elements">
				<TITLE>Dymek</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Dymek</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EDY0005).</PATTERN>
			</entry>
			<entry key="tooltip_local_metadata_field_unknown_option">
				<TITLE>Dymek</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Dymek</emphasis>. Nieznana opcja dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> nie została rozpoznana (EDY0006).</PATTERN>
			</entry>
			<entry key="tooltip_local_metadata_field_missing">
				<TITLE>Dymek</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Dymek</emphasis>. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EDY0007).</PATTERN>
			</entry>
			<entry key="tooltip_local_metadata_field_duplicate">
				<TITLE>Dymek</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Dymek</emphasis>. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EDY0008).</PATTERN>
			</entry>
			<entry key="tooltip_local_metadata_duplicate">
				<TITLE>Dymek</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Dymek</emphasis> występuje duplikat tabelki z atrybutami (EDY0009).</PATTERN>
			</entry>
			<entry key="tooltip_under_that_name_already_exists">
				<TITLE>Dymek - duplikat</TITLE>
				<PATTERN>Dymek o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> został zdefiniowany w tym module więcej niż 1 raz. Nazwa jest wykorzystywana do połączenia dymka z odwołaniem, dlatego nazwy dymków w obrębie modułu muszą być unikalne. Pozostałe wystąpienia: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (EDY0010).</PATTERN>
			</entry>
			<entry key="tooltip_reference_to_non_existing_tooltip">
				<TITLE>Dymek - odwołanie</TITLE>
				<PATTERN>Dymek o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> nie został zdefiniowany w tym module (EDY0011).</PATTERN>
			</entry>
			<entry key="procedure-instructions_name_duplicate">
				<TITLE>Instrukcja postępowania</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Instrukcja postępowania</emphasis> wystąpił duplikat nazwy (EIP0001).</PATTERN>
			</entry>
			<entry key="procedure-instructions_name_missing">
				<TITLE>Instrukcja postępowania</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Instrukcja postępowania</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Nazwa</emphasis> (EIP0002).</PATTERN>
			</entry>
			<entry key="procedure-instructions_step_missing">
				<TITLE>Instrukcja postępowania</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Instrukcja postępowania</emphasis> nie zawiera elementów oznaczonych stylem <emphasis role="{$TER}">EP Krok</emphasis> (EIP0003).</PATTERN>
			</entry>
			<entry key="procedure-instructions_disallowed_elements">
				<TITLE>Instrukcja postępowania</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Instrukcja postępowania</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EIP0004).</PATTERN>
			</entry>
			<entry key="code_name_duplicate">
				<TITLE>Kod</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Kod</emphasis> wystąpił duplikat nazwy (EO0001).</PATTERN>
			</entry>
			<entry key="code_disallowed_elements">
				<TITLE>Kod</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Kod</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EO0002).</PATTERN>
			</entry>
			<entry key="code_local_metadata_field_unknown_option">
				<TITLE>Kod</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Kod</emphasis>. Nieznana opcja dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> nie została rozpoznana (EO0003).</PATTERN>
			</entry>
			<entry key="code_local_metadata_field_missing">
				<TITLE>Kod</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Kod</emphasis>. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EO0004).</PATTERN>
			</entry>
			<entry key="code_local_metadata_field_duplicate">
				<TITLE>Kod</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Kod</emphasis>. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EO0005).</PATTERN>
			</entry>
			<entry key="code_local_metadata_missing">
				<TITLE>Kod</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Kod</emphasis> brakuje tabelki z atrybutami lub atrybuty nie mogły zostać przetworzone (EO0006).</PATTERN>
			</entry>
			<entry key="code_local_metadata_duplicate">
				<TITLE>Kod</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Kod</emphasis> występuje duplikat tabelki z atrybutami (EO0007).</PATTERN>
			</entry>
			<entry key="code_language_not_from_list_option_selected_but_language2_empty">
				<TITLE>Kod</TITLE>
				<PATTERN>Problem z atrybutami bloku kodu. Jako język programowania wybrano opcję <emphasis role="{$TER}">Inny spoza listy</emphasis>, lecz pole pozwalające zdefiniować język spoza listy nie zostało wypełnione (EO0008).</PATTERN>
			</entry>
			<entry key="code_language_from_list_option_selected_but_language2_not_empty">
				<TITLE>Kod</TITLE>
				<PATTERN>Problem z atrybutami bloku kodu. Jako język programowania wybrano jedną ze zdefiniowanych opcji jednocześnie wypełniając pole <emphasis role="{$TER}">Inny spoza listy</emphasis> (EO0009).</PATTERN>
			</entry>
			<entry key="code_inline_comment_nesting_error">
				<TITLE>Kod</TITLE>
				<PATTERN>Problem z komentarzem wiążącym język programowania z kodem w treści. Komentarz zagnieżdża się z innym komentarzem lub rozciąga się na więcej niż jeden paragraf (EO0010).</PATTERN>
			</entry>
			<entry key="list_name_duplicate">
				<TITLE>Lista</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Lista</emphasis> wystąpił duplikat nazwy (EI0001).</PATTERN>
			</entry>
			<entry key="list_missing">
				<TITLE>Lista</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Lista</emphasis> nie zawiera żadnej listy (EI0002).</PATTERN>
			</entry>
			<entry key="list_duplicate">
				<TITLE>Lista</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Lista</emphasis> może zawierać tylko jedną listę, a zawiera <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EI0003).</PATTERN>
			</entry>
			<entry key="list_disallowed_elements">
				<TITLE>Lista</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Lista</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EI0004).</PATTERN>
			</entry>
			<entry key="list_starting_with_ilvl_gt_0">
				<TITLE>Lista</TITLE>
				<PATTERN>Pierwszy element listy zaczyna się od niedozwolonego poziomu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EI0005).</PATTERN>
			</entry>
			<entry key="list_with_level_gap">
				<TITLE>Lista</TITLE>
				<PATTERN>Między kolejnymi elementami listy występuje przeskok kilku poziomów. Elementu o treści zaczynającej się od <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> powinien znajdować się conajwyżej na poziomie <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (EI0006).</PATTERN>
			</entry>
			<entry key="list_cannot_parse_pattern"> - gdy nie można przetworzyć pattern z numberring
			<TITLE>Lista</TITLE>
				<PATTERN>Format numerowania listy zawiera niewspierane elementy (EI0007).</PATTERN>
			</entry>
			<entry key="cite_name_duplicate">
				<TITLE>Cytat</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Cytat</emphasis> wystąpił duplikat nazwy (EQ0001).</PATTERN>
			</entry>
			<entry key="cite_missing">
				<TITLE>Cytat</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Cytat</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Cytat</emphasis> (EQ0002).</PATTERN>
			</entry>
			<entry key="cite_duplicate">
				<TITLE>Cytat</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Cytat</emphasis> może zawierać tylko jeden cytat (EQ0003).</PATTERN>
			</entry>
			<entry key="cite_disallowed_elements">
				<TITLE>Cytat</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Cytat</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EQ0004).</PATTERN>
			</entry>
			<entry key="cite_local_metadata_field_pattern_mismatch">
				<TITLE>Cytat</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Cytat</emphasis>. Nieprawidłowa wartość dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość dozwolona to: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>, podczas gdy w dokumencie znajduje się wartość: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (EQ0005).</PATTERN>
			</entry>
			<entry key="cite_local_metadata_field_unknown_option">
				<TITLE>Cytat</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Cytat</emphasis>. Nieznana opcja dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> nie została rozpoznana (EQ0006).</PATTERN>
			</entry>
			<entry key="cite_local_metadata_field_missing">
				<TITLE>Cytat</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Cytat</emphasis>. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EQ0007).</PATTERN>
			</entry>
			<entry key="cite_local_metadata_field_duplicate">
				<TITLE>Cytat</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Cytat</emphasis>. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EQ0008).</PATTERN>
			</entry>
			<entry key="cite_local_metadata_missing">
				<TITLE>Cytat</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Cytat</emphasis> brakuje tabelki z atrybutami lub atrybuty nie mogły zostać przetworzone (EQ0009).</PATTERN>
			</entry>
			<entry key="cite_local_metadata_duplicate">
				<TITLE>Cytat</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Cytat</emphasis> występuje duplikat tabelki z atrybutami (EQ0010).</PATTERN>
			</entry>
			<entry key="cite_comment_duplicate">
				<TITLE>Cytat</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Cytat</emphasis> może zawierać tylko jeden komentarz do cytatu (EQ0011).</PATTERN>
			</entry>
			<entry key="cite_readability_set_while_length_less_than_700">
				<TITLE>Cytat</TITLE>
				<PATTERN>Poziom przystępności języka może być określany dla cytatów dłuższych niż 700 znaków, ten cytat ma <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> znaków (EQ0012).</PATTERN>
			</entry>
			<entry key="cite_readability_set_while_poetry_type">
				<TITLE>Cytat</TITLE>
				<PATTERN>Poziom przystępności języka nie może być określany dla cytatów będących poezją (EQ0013).</PATTERN>
			</entry>
			<entry key="rule_name_missing">
				<TITLE>Reguła</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Reguła</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Nazwa</emphasis> (ER0001).</PATTERN>
			</entry>
			<entry key="rule_name_duplicate">
				<TITLE>Reguła</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Reguła</emphasis> wystąpił duplikat nazwy (ER0002).</PATTERN>
			</entry>
			<entry key="rule_missing">
				<TITLE>Reguła</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Reguła</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Reguła - twierdzenie</emphasis> (ER0003).</PATTERN>
			</entry>
			<entry key="rule_disallowed_elements">
				<TITLE>Reguła</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Reguła</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (ER0004).</PATTERN>
			</entry>
			<entry key="rule_local_metadata_duplicate">
				<TITLE>Reguła</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Reguła</emphasis> występuje duplikat tabelki z atrybutami (ER0005).</PATTERN>
			</entry>
			<entry key="rule_local_metadata_field_unknown_option">
				<TITLE>Reguła</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Reguła</emphasis>. Nieznana opcja dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> nie została rozpoznana (ER0006).</PATTERN>
			</entry>
			<entry key="rule_local_metadata_field_missing">
				<TITLE>Reguła</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Reguła</emphasis>. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (ER0007).</PATTERN>
			</entry>
			<entry key="rule_local_metadata_field_duplicate">
				<TITLE>Reguła</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Reguła</emphasis>. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (ER0008).</PATTERN>
			</entry>
			<entry key="exercise_name_duplicate">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis> wystąpił duplikat nazwy (EX0001).</PATTERN>
			</entry>
			<entry key="exercise_problem_missing">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Ćwiczenie - problem</emphasis> (EX0002).</PATTERN>
			</entry>
			<entry key="exercise_problem_duplicate">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis> wystąpił duplikat opisu problemu (EX0003).</PATTERN>
			</entry>
			<entry key="exercise_commentary_duplicate">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis> wystąpił duplikat wyjaśnienia (EX0004).</PATTERN>
			</entry>
			<entry key="exercise_disallowed_elements">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EX0005).</PATTERN>
			</entry>
			<entry key="exercise_local_metadata_missing">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis> brakuje tabelki z atrybutami lub atrybuty nie mogły zostać przetworzone (EX0006).</PATTERN>
			</entry>
			<entry key="exercise_local_metadata_duplicate">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis> występuje duplikat tabelki z atrybutami (EX0007).</PATTERN>
			</entry>
			<entry key="exercise_local_metadata_field_unknown_option">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis>. Nieznana opcja dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> nie została rozpoznana (EX0008).</PATTERN>
			</entry>
			<entry key="exercise_local_metadata_field_missing">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis>. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EX0009).</PATTERN>
			</entry>
			<entry key="exercise_local_metadata_field_duplicate">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis>. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EX0010).</PATTERN>
			</entry>
			<entry key="exercise_alternative_WOMI_duplicate">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis>. Ćwiczenie zawiera więcej niż jedno WOMI definiujące wersję dla formatów dynamicznych (EX0011).</PATTERN>
			</entry>
			<entry key="exercise_with_alternative_WOMI_but_type_is_not_static">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis>. Ćwiczenie zawiera WOMI definiujące wersję dla formatów dynamicznych, ale atrybut interaktywność nie jest ustawiony na wartość <emphasis role="{$TER}">Statyczne</emphasis> (EX0012).</PATTERN>
			</entry>
			<entry key="exercise_with_alternative_WOMI_but_not_OINT">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis>. Ćwiczenie zawiera WOMI definiujące wersję dla formatów dynamicznych, ale nie jest to WOMI typu obiekt interaktywny (EX0013).</PATTERN>
			</entry>
			<entry key="exercise_WOMI_not_OINT">
				<TITLE>Zadanie - WOMI</TITLE>
				<PATTERN>WOMI <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> zostało oznaczone jako zadanie WOMI, ale nie jest to WOMI typu obiekt interaktywny (EX0014).</PATTERN>
			</entry>
			<entry key="exercise_WOMI_local_metadata_missing">
				<TITLE>Zadanie - WOMI</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie silnikowe</emphasis> brakuje tabelki z atrybutami lub atrybuty nie mogły zostać przetworzone (EX0015).</PATTERN>
			</entry>
			<entry key="exercise_WOMI_local_metadata_duplicate">
				<TITLE>Zadanie - WOMI</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie silnikowe</emphasis> występuje duplikat tabelki z atrybutami (EX0016).</PATTERN>
			</entry>
			<entry key="exercise_WOMI_WOMI_missing">
				<TITLE>Zadanie - WOMI</TITLE>
				<PATTERN>W tabelce bloku opisanego stylem <emphasis role="{$TER}">EPK Zadanie silnikowe</emphasis> brakuje WOMI (EX0017).</PATTERN>
			</entry>
			<entry key="exercise_WOMI_WOMI_duplicate">
				<TITLE>Zadanie - WOMI</TITLE>
				<PATTERN>W tabelce bloku opisanego stylem <emphasis role="{$TER}">EPK Zadanie silnikowe</emphasis> znajduje się więcej niż jedno WOMI (EX0018).</PATTERN>
			</entry>
			<entry key="exercise_WOMI_WOMI_not_OINT">
				<TITLE>Zadanie - WOMI</TITLE>
				<PATTERN>W tabelce bloku opisanego stylem <emphasis role="{$TER}">EPK Zadanie silnikowe</emphasis> znajduje się WOMI <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>, które nie jest typu obiekt interaktywny (EX0019).</PATTERN>
			</entry>
			<entry key="exercise_WOMI_disallowed_elements">
				<TITLE>Zadanie - WOMI</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie silnikowe</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EX0020).</PATTERN>
			</entry>
			<entry key="exercise_WOMI_set_command_missing">
				<TITLE>Zbiór zadań</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Zbiór zadań</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Polecenie</emphasis> (EX0021).</PATTERN>
			</entry>
			<entry key="exercise_WOMI_set_metadata_missing">
				<TITLE>Zbiór zadań</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Zbiór zadań</emphasis> brakuje tabelki z atrybutami lub atrybuty nie mogły zostać przetworzone (EX0022).</PATTERN>
			</entry>
			<entry key="exercise_WOMI_set_metadata_duplicate">
				<TITLE>Zbiór zadań</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Zbiór zadań</emphasis> występuje duplikat tabelki z atrybutami  (EX0023).</PATTERN>
			</entry>
			<entry key="exercise_WOMI_set_WOMI_missing">
				<TITLE>Zbiór zadań</TITLE>
				<PATTERN>W tabelce bloku opisanego stylem <emphasis role="{$TER}">EPK Zbiór zadań</emphasis> brakuje WOMI (EX0024).</PATTERN>
			</entry>
			<entry key="exercise_WOMI_set_WOMI_not_OINT">
				<TITLE>Zbiór zadań</TITLE>
				<PATTERN>W tabelce bloku opisanego stylem <emphasis role="{$TER}">EPK Zbiór zadań</emphasis> znajduje się WOMI <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>, które nie jest typu obiekt interaktywny (EX0025).</PATTERN>
			</entry>
			<entry key="exercise_WOMI_set_disallowed_elements">
				<TITLE>Zbiór zadań</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Zbiór zadań</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EX0026).</PATTERN>
			</entry>
			<entry key="exercise_tip_duplicate">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis> wystąpił duplikat wskazówki (EX0027).</PATTERN>
			</entry>
			<entry key="command_problem_missing">
				<TITLE>Polecenie</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Polecenie</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Polecenie</emphasis> (EP0001).</PATTERN>
			</entry>
			<entry key="command_disallowed_elements">
				<TITLE>Polecenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Polecenie</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EP0002).</PATTERN>
			</entry>
			<entry key="homework_disallowed_elements">
				<TITLE>Praca domowa</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Praca domowa</emphasis> wystąpiły elementy które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EH0001).</PATTERN>
			</entry>
			<entry key="homework_exercise_WOMI_not_OINT">
				<TITLE>Praca domowa</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Praca domowa</emphasis> zawiera WOMI <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>, które zostało oznaczone jako zadanie WOMI, ale nie jest to WOMI typu obiekt interaktywny (EH0002).</PATTERN>
			</entry>
			<entry key="definition_name_missing">
				<TITLE>Definicja/Pojęcie</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Definicja / EPK Pojęcie</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Nazwa</emphasis> (ED0001).</PATTERN>
			</entry>
			<entry key="definition_name_duplicate">
				<TITLE>Definicja/Pojęcie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Definicja / EPK Pojęcie</emphasis> wystąpił duplikat nazwy (ED0002).</PATTERN>
			</entry>
			<entry key="definition_meaning_missing">
				<TITLE>Definicja/Pojęcie</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Definicja / EPK Pojęcie</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Definicja - znaczenie</emphasis> (ED0003).</PATTERN>
			</entry>
			<entry key="definition_disallowed_elements">
				<TITLE>Definicja/Pojęcie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Definicja / EPK Pojęcie</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (ED0004).</PATTERN>
			</entry>
			<entry key="definition_local_metadata_duplicate">
				<TITLE>Definicja/Pojęcie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Definicja / EPK Pojęcie</emphasis> występuje duplikat tabelki z atrybutami (ED0005).</PATTERN>
			</entry>
			<entry key="definition_local_metadata_field_unknown_option">
				<TITLE>Definicja/Pojęcie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Definicja / EPK Pojęcie</emphasis>. Nieznana opcja dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> nie została rozpoznana (ED0006).</PATTERN>
			</entry>
			<entry key="definition_local_metadata_field_missing">
				<TITLE>Definicja/Pojęcie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Definicja / EPK Pojęcie</emphasis>. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (ED0007).</PATTERN>
			</entry>
			<entry key="definition_local_metadata_field_duplicate">
				<TITLE>Definicja/Pojęcie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Definicja / EPK Pojęcie</emphasis>. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (ED0008).</PATTERN>
			</entry>
			<entry key="glossary_reference_to_non_existing_element">
				<TITLE>Definicja/Reguła - odwołanie</TITLE>
				<PATTERN>Definicja/Reguła o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> nie została zdefiniowana w tym module. Nie istnieje też definicja/reguła o tej nazwie (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>) zdefiniowana w innym module tego e-podręcznika i przeznaczona do wykorzystania w słowniczku (ED0009).</PATTERN>
			</entry>
			<entry key="glossary_under_that_name_already_exists">
				<TITLE>Definicja/Reguła - duplikat</TITLE>
				<PATTERN>Definicja/Reguła o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> została zdefiniowana w tym module więcej niż 1 raz. Nazwa jest wykorzystywana do połączenia definicji/reguły z odwołaniem, dlatego nazwy definicji/reguł w obrębie modułu (całego e-podręcznika w przypadku definicji/reguł zadeklarowanych jako słownikowe) muszą być unikalne. Pozostałe wystąpienia: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (ED0010).</PATTERN>
			</entry>
			<entry key="glossary_under_that_name_already_exists_global">
				<TITLE>Definicja/Reguła - duplikat</TITLE>
				<PATTERN>Definicja/Reguła o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> została zdefiniowana w tym e-podręczniku więcej niż 1 raz. Nazwa jest wykorzystywana do połączenia definicji/reguły z odwołaniem, dlatego nazwy definicji/reguł zadeklarowanych jako słownikowe, muszą być unikalne w obrębie całego e-podręcznika. Wystąpienia w innych modułach: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (ED0011).</PATTERN>
			</entry>
			<entry key="concept_reference_to_non_existing_concept">
				<TITLE>Pojęcie - odwołanie</TITLE>
				<PATTERN>Pojęcie o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> nie zostało zdefiniowane w tym module. Nie istnieje też pojęcie o tej nazwie (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>) zdefiniowane w innym module tego e-podręcznika i przeznaczona do wykorzystania w słowniczku (ED0012).</PATTERN>
			</entry>
			<entry key="concept_under_that_name_already_exists">
				<TITLE>Pojęcie - duplikat</TITLE>
				<PATTERN>Pojęcie o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> zostało zdefiniowane w tym module więcej niż 1 raz. Nazwa jest wykorzystywana do połączenia pojęcia z odwołaniem, dlatego nazwy pojęć w obrębie modułu (całego e-podręcznika w przypadku pojęć zadeklarowanych jako słownikowe) muszą być unikalne. Pozostałe wystąpienia: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (ED0013).</PATTERN>
			</entry>
			<entry key="concept_under_that_name_already_exists_global">
				<TITLE>Pojęcie - duplikat</TITLE>
				<PATTERN>Pojęcie o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> zostało zdefiniowane w tym e-podręczniku więcej niż 1 raz. Nazwa jest wykorzystywana do połączenia pojęcia z odwołaniem, dlatego nazwy pojęć zadeklarowanych jako słownikowe, muszą być unikalne w obrębie całego e-podręcznika. Wystąpienia w innych modułach: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (ED0014).</PATTERN>
			</entry>
			<entry key="quiz_question_missing">
				<TITLE>Zadanie</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Zadanie</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EPQ Pytanie</emphasis> (EU0001).</PATTERN>
			</entry>
			<entry key="quiz_question_duplicate">
				<TITLE>Zadanie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis> wystąpił duplikat pytania (EU0002).</PATTERN>
			</entry>
			<entry key="quiz_insufficient_answers_count">
				<TITLE>Zadanie</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Zadanie</emphasis> nie zawiera definicji wystarczającej liczby odpowiedzi (EU0003).</PATTERN>
			</entry>
			<entry key="quiz_feedback_duplicate">
				<TITLE>Zadanie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis> wystąpił duplikat wyjaśnienia (EU0004).</PATTERN>
			</entry>
			<entry key="quiz_correct_answer_missing">
				<TITLE>Zadanie</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Zadanie</emphasis> nie zawiera definicji poprawnej odpowiedzi (EU0005).</PATTERN>
			</entry>
			<entry key="quiz_disallowed_elements">
				<TITLE>Zadanie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EU0006).</PATTERN>
			</entry>
			<entry key="quiz_local_metadata_missing">
				<TITLE>Zadanie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis> brakuje tabelki z atrybutami lub atrybuty nie mogły zostać przetworzone (EU0007).</PATTERN>
			</entry>
			<entry key="quiz_local_metadata_duplicate">
				<TITLE>Zadanie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis> występuje duplikat tabelki z atrybutami (EU0008).</PATTERN>
			</entry>
			<entry key="quiz_local_metadata_field_unknown_option">
				<TITLE>Zadanie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Nieznana opcja dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> nie została rozpoznana (EU0009).</PATTERN>
			</entry>
			<entry key="quiz_local_metadata_field_missing">
				<TITLE>Zadanie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EU0010).</PATTERN>
			</entry>
			<entry key="quiz_local_metadata_field_duplicate">
				<TITLE>Zadanie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EU0011).</PATTERN>
			</entry>
			<entry key="quiz_alternative_WOMI_duplicate">
				<TITLE>Zadanie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Zadanie zawiera więcej niż jedno WOMI definiujące wersję dla formatów dynamicznych (EU0012).</PATTERN>
			</entry>
			<entry key="quiz_with_alternative_WOMI_but_not_OINT">
				<TITLE>Zadanie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Zadanie zawiera WOMI definiujące wersję dla formatów dynamicznych, ale nie jest to WOMI typu obiekt interaktywny (EU0013).</PATTERN>
			</entry>
			<entry key="quiz_name_duplicate">
				<TITLE>Zadanie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis> wystąpił duplikat nazwy (EU0014).</PATTERN>
			</entry>
			<entry key="quiz_single_response_with_more_than_one_answer">
				<TITLE>Zadanie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Zadanie zawiera więcej niż jedną poprawną odpowiedź, podczas gdy atrybut <emphasis role="{$TER}">Rodzaj pytania testowego</emphasis> jest ustawiony na wartość <emphasis role="{$TER}">Jednokrotny wybór</emphasis> (EU0015).</PATTERN>
			</entry>
			<entry key="quiz_ordered_response_with_incorrect_answer">
				<TITLE>Zadanie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Zadanie zawiera conajmniej jedną niepoprawną odpowiedź, podczas gdy atrybut <emphasis role="{$TER}">Rodzaj pytania testowego</emphasis> jest ustawiony na wartość <emphasis role="{$TER}">Poprawna kolejność</emphasis> (EU0016).</PATTERN>
			</entry>
			<entry key="quiz_wrong_order_hint_not_after_wrong_answer">
				<TITLE>Zadanie z losowaniem odpowiedzi</TITLE>
				<PATTERN>Problem ze wskazówką do odpowiedzi w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Wskazówki można umieszczać jedynie pod niepoprawnymi odpowiedziami. Dotyczy wskazówki umieszczonej pod odpowiedzią nr <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EU0017).</PATTERN>
			</entry>
			<entry key="quiz_wrong_order_hint_after_hint">
				<TITLE>Zadanie z losowaniem odpowiedzi</TITLE>
				<PATTERN>Problem ze wskazówką do odpowiedzi w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Pod odpowiedzią nr <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> znajduje się więcej niż jeden blok będący wskazówką (EU0018).</PATTERN>
			</entry>
			<entry key="quiz_number_of_correct_answers_min_greater_than_max">
				<TITLE>Zadanie z losowaniem odpowiedzi</TITLE>
				<PATTERN>Problem w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Wartość atrybutu <emphasis role="{$TER}">Maksymalna liczba poprawnych odpowiedzi</emphasis> (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>) jest niższa niż <emphasis role="{$TER}">Minimalna liczba poprawnych odpowiedzi</emphasis> (<emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>) (EU0019).</PATTERN>
			</entry>
			<entry key="quiz_number_of_correct_answers_max_greater_than_presented_answers">
				<TITLE>Zadanie z losowaniem odpowiedzi</TITLE>
				<PATTERN>Problem w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Wartość atrybutu <emphasis role="{$TER}">Maksymalna liczba poprawnych odpowiedzi</emphasis> (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>) jest wyższa niż <emphasis role="{$TER}">Liczba prezentowanych odpowiedzi</emphasis> (<emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>) (EU0020).</PATTERN>
			</entry>
			<entry key="quiz_non_zero_number_of_answers_mod_number_of_presented_answers_while_sets">
				<TITLE>Zadanie z losowaniem odpowiedzi</TITLE>
				<PATTERN>Problem w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Liczba wszystkich odpowiedzi w zadanich z podziałem na zestawy powinna być wielokrotnością <emphasis role="{$TER}">Liczby prezentowanych odpowiedzi</emphasis>. W tym zadaniu zdefiniowano <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> odpowiedzi, a <emphasis role="{$TER}">Liczba prezentowanych odpowiedzi</emphasis> to <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (EU0021).</PATTERN>
			</entry>
			<entry key="quiz_number_of_correct_answers_in_single_response_not_1_while_sets">
				<TITLE>Zadanie z losowaniem odpowiedzi</TITLE>
				<PATTERN>Problem w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Wybrano opcję prezentacji z podziałem na zestawy, zestawy są tworzone z kolejno zdefiniowanych odpowiedzi. Liczba odpowiedzi poprawnych w zestawie nr <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (odpowiedzi od <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> do <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis>) to <emphasis role="{$TER}">
						<epconvert:token number="4"/>
					</emphasis>, co jest sprzeczne z wybranym rodzajem pytania testowego <emphasis role="{$TER}">Jednokrotny wybór</emphasis> (EU0022).</PATTERN>
			</entry>
			<entry key="quiz_number_answers_less_than_number_of_presented_answers">
				<TITLE>Zadanie z losowaniem odpowiedzi</TITLE>
				<PATTERN>Problem w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Wartość atrybutu <emphasis role="{$TER}">Liczba prezentowanych odpowiedzi</emphasis> (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>) jest wyższa niż liczba wszystkich zdefiniowanych odpowiedzi (<emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>) (EU0023).</PATTERN>
			</entry>
			<entry key="quiz_answer_hint_allowed_only_for_single_response">
				<TITLE>Zadanie z losowaniem odpowiedzi</TITLE>
				<PATTERN>Problem w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Stosowanie wskazówek do odpowiedzi dozwolone jest tylko i wyłącznie w pytaniach testowych typu <emphasis role="{$TER}">Jednokrotny wybór</emphasis> (EU0024).</PATTERN>
			</entry>
			<entry key="quiz_number_of_correct_answers_in_single_response_set_1_not_1_while_randomize">
				<TITLE>Zadanie z losowaniem odpowiedzi</TITLE>
				<PATTERN>Problem w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Wersja statyczna zadania powstaje na podstawie pierwszych X odpowiedzi, gdzie X to wartość atrybutu <emphasis role="{$TER}">Liczba prezentowanych odpowiedzi</emphasis> (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>). Liczba odpowiedzi poprawnych pośród pierwszych <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> odpowiedzi to <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>, co jest sprzeczne z wybranym rodzajem pytania testowego <emphasis role="{$TER}">Jednokrotny wybór</emphasis> (EU0025).</PATTERN>
			</entry>
			<entry key="quiz_number_of_correct_answers_max_less_than_number_of_all_correct_answers">
				<TITLE>Zadanie z losowaniem odpowiedzi</TITLE>
				<PATTERN>Problem w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. <emphasis role="{$TER}">Maksymalna liczba poprawnych odpowiedzi</emphasis> (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>) jest wyższa, niż liczba zdefiniowanych poprawnych odpowiedzi w całym zadaniu (<emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>) (EU0026).</PATTERN>
			</entry>
			<entry key="quiz_number_of_incorrect_answers_is_to_low">
				<TITLE>Zadanie z losowaniem odpowiedzi</TITLE>
				<PATTERN>Problem w bloku opisanym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. <emphasis role="{$TER}">Liczba prezentowanych odpowiedzi</emphasis> minus <emphasis role="{$TER}">Minimalna liczba poprawnych odpowiedzi</emphasis> (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>) jest niższa, niż liczba zdefiniowanych niepoprawnych odpowiedzi w całym zadaniu (<emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>) (EU0027).</PATTERN>
			</entry>
			<entry key="experiment_name_duplicate">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> wystąpił duplikat nazwy (EE0001).</PATTERN>
			</entry>
			<entry key="experiment_disallowed_elements">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EE0002).</PATTERN>
			</entry>
			<entry key="experiment_local_metadata_missing">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> brakuje tabelki z atrybutami lub atrybuty nie mogły zostać przetworzone (EE0003).</PATTERN>
			</entry>
			<entry key="experiment_local_metadata_duplicate">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> występuje duplikat tabelki z atrybutami (EE0004).</PATTERN>
			</entry>
			<entry key="experiment_objective_and_problem_hypotesis_exclusion">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> występuje zarówno element oznaczony stylem <emphasis role="{$TER}">EP Doświadczenie - problem badawczy</emphasis> i/lub <emphasis role="{$TER}">EP Doświadczenie - hipoteza</emphasis>, jak i element opisany stylem <emphasis role="{$TER}">EP Doświadczenie - cel</emphasis> (EE0005).</PATTERN>
			</entry>
			<entry key="experiment_objective_or_problem_and_hypotesis_missing">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> nie zawiera elementów oznaczonych stylem <emphasis role="{$TER}">EP Doświadczenie - problem badawczy</emphasis> oraz <emphasis role="{$TER}">EP Doświadczenie - hipoteza</emphasis>, lub elementu opisanego stylem <emphasis role="{$TER}">EP Doświadczenie - cel</emphasis> (EE0006).</PATTERN>
			</entry>
			<entry key="experiment_problem_without_hypotesis">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> zawiera element opisany stylem <emphasis role="{$TER}">EP Doświadczenie - problem badawczy</emphasis>, ale brakuje w nim elementu opisanego stylem <emphasis role="{$TER}">EP Doświadczenie - hipoteza</emphasis> (EE0007).</PATTERN>
			</entry>
			<entry key="experiment_hypotesis_without_problem">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> zawiera element opisany stylem <emphasis role="{$TER}">EP Doświadczenie - hipoteza</emphasis>, ale brakuje w nim elementu opisanego stylem <emphasis role="{$TER}">EP Doświadczenie - problem badawczy</emphasis> (EE0008).</PATTERN>
			</entry>
			<entry key="experiment_problem_duplicate">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> występuje duplikat elementu opisanego stylem <emphasis role="{$TER}">EP Doświadczenie - problem badawczy</emphasis> (EE0009).</PATTERN>
			</entry>
			<entry key="experiment_hypotesis_duplicate">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> występuje duplikat elementu opisanego stylem <emphasis role="{$TER}">EP Doświadczenie - hipoteza</emphasis> (EE0010).</PATTERN>
			</entry>
			<entry key="experiment_objective_duplicate">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> występuje duplikat elementu opisanego stylem <emphasis role="{$TER}">EP Doświadczenie - cel</emphasis> (EE0011).</PATTERN>
			</entry>
			<entry key="experiment_instruments_duplicate">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> występuje duplikat elementu opisanego stylem <emphasis role="{$TER}">EP Doświadczenie - materiały i przyrządy</emphasis> (EE0012).</PATTERN>
			</entry>
			<entry key="experiment_instructions_duplicate">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> występuje duplikat elementu opisanego stylem <emphasis role="{$TER}">EP Doświadczenie - instrukcja</emphasis> (EE0013).</PATTERN>
			</entry>
			<entry key="experiment_instructions_missing">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Doświadczenie - instrukcja</emphasis> (EE0014).</PATTERN>
			</entry>
			<entry key="experiment_conclusions_duplicate">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis> występuje duplikat elementu opisanego stylem <emphasis role="{$TER}">EP Doświadczenie - podsumowanie</emphasis> (EE0015).</PATTERN>
			</entry>
			<entry key="experiment_local_metadata_field_unknown_option">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis>. Nieprawidłowa opcja w polu wyboru dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EE0016).</PATTERN>
			</entry>
			<entry key="experiment_local_metadata_field_missing">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis>. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EE0017).</PATTERN>
			</entry>
			<entry key="experiment_local_metadata_field_duplicate">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis>. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EE0018).</PATTERN>
			</entry>
			<entry key="observation_name_duplicate">
				<TITLE>Obserwacja</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Obserwacja</emphasis> wystąpił duplikat nazwy (EEO0001).</PATTERN>
			</entry>
			<entry key="observation_disallowed_elements">
				<TITLE>Obserwacja</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Obserwacja</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EEO0002).</PATTERN>
			</entry>
			<entry key="observation_local_metadata_missing">
				<TITLE>Obserwacja</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Obserwacja</emphasis> brakuje tabelki z atrybutami lub atrybuty nie mogły zostać przetworzone (EEO0003).</PATTERN>
			</entry>
			<entry key="observation_local_metadata_duplicate">
				<TITLE>Obserwacja</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Obserwacja</emphasis> występuje duplikat tabelki z atrybutami (EEO0004).</PATTERN>
			</entry>
			<entry key="observation_objective_missing">
				<TITLE>Obserwacja</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Obserwacja</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Doświadczenie - cel</emphasis> (EEO0005).</PATTERN>
			</entry>
			<entry key="observation_objective_duplicate">
				<TITLE>Obserwacja</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Obserwacja</emphasis> występuje duplikat elementu opisanego stylem <emphasis role="{$TER}">EP Doświadczenie - cel</emphasis> (EEO0006).</PATTERN>
			</entry>
			<entry key="observation_instruments_duplicate">
				<TITLE>Obserwacja</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Obserwacja</emphasis> występuje duplikat elementu opisanego stylem <emphasis role="{$TER}">EP Doświadczenie - materiały i przyrządy</emphasis> (EEO0007).</PATTERN>
			</entry>
			<entry key="observation_instructions_duplicate">
				<TITLE>Obserwacja</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Obserwacja</emphasis> występuje duplikat elementu opisanego stylem <emphasis role="{$TER}">EP Doświadczenie - instrukcja</emphasis> (EEO0008).</PATTERN>
			</entry>
			<entry key="observation_instructions_missing">
				<TITLE>Obserwacja</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Obserwacja</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Doświadczenie - instrukcja</emphasis> (EEO0009).</PATTERN>
			</entry>
			<entry key="observation_conclusions_duplicate">
				<TITLE>Obserwacja</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Obserwacja</emphasis> występuje duplikat elementu opisanego stylem <emphasis role="{$TER}">EP Doświadczenie - podsumowanie</emphasis> (EEO0010).</PATTERN>
			</entry>
			<entry key="observation_local_metadata_field_unknown_option">
				<TITLE>Obserwacja</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Obserwacja</emphasis>. Nieprawidłowa opcja w polu wyboru dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EEO0011).</PATTERN>
			</entry>
			<entry key="observation_local_metadata_field_missing">
				<TITLE>Obserwacja</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Obserwacja</emphasis>. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EEO0012).</PATTERN>
			</entry>
			<entry key="observation_local_metadata_field_duplicate">
				<TITLE>Obserwacja</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Obserwacja</emphasis>. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EEO0013).</PATTERN>
			</entry>
			<entry key="biography_name_duplicate">
				<TITLE>Biogram</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis> wystąpił duplikat nazwy (EB0001).</PATTERN>
			</entry>
			<entry key="biography_disallowed_elements">
				<TITLE>Biogram</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EB0002).</PATTERN>
			</entry>
			<entry key="biography_local_metadata_missing">
				<TITLE>Biogram</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis> brakuje tabelki z atrybutami lub atrybuty nie mogły zostać przetworzone (EB0003).</PATTERN>
			</entry>
			<entry key="biography_local_metadata_duplicate">
				<TITLE>Biogram</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis> występuje duplikat tabelki z atrybutami (EB0004).</PATTERN>
			</entry>
			<entry key="biography_content_missing">
				<TITLE>Biogram</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Biogram</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Opis</emphasis> (EB0005).</PATTERN>
			</entry>
			<entry key="biography_content_duplicate">
				<TITLE>Biogram</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis> występuje duplikat elementu opisanego stylem <emphasis role="{$TER}">EP Opis</emphasis> (EB0006).</PATTERN>
			</entry>
			<entry key="biography_local_metadata_field_pattern_mismatch">
				<TITLE>Biogram</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis>. Nieprawidłowa wartość dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość dozwolona to: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>, podczas gdy w dokumencie znajduje się wartość: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (EB0007).</PATTERN>
			</entry>
			<entry key="biography_local_metadata_field_unknown_option">
				<TITLE>Biogram</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis>. Nieznana opcja dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> nie została rozpoznana (EB0008).</PATTERN>
			</entry>
			<entry key="biography_local_metadata_field_missing">
				<TITLE>Biogram</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis>. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EB0009).</PATTERN>
			</entry>
			<entry key="biography_local_metadata_field_duplicate">
				<TITLE>Biogram</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis>. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EB0010).</PATTERN>
			</entry>
			<entry key="biography_birth_date_exact_pattern_mismatch">
				<TITLE>Biogram</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis>. Jako format daty urodzenia wybrano opcję <emphasis role="{$TER}">Dokładna data</emphasis>, ale wartość wprowadzona w polu <emphasis role="{$TER}">Data urodzenia</emphasis> nie pasuje do formatu (EB0011).</PATTERN>
			</entry>
			<entry key="biography_birth_date_year_pattern_mismatch">
				<TITLE>Biogram</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis>. Jako format daty urodzenia wybrano opcję <emphasis role="{$TER}">Tylko rok / Około ... roku</emphasis>, ale wartość wprowadzona w polu <emphasis role="{$TER}">Data urodzenia</emphasis> nie pasuje do formatu (EB0012).</PATTERN>
			</entry>
			<entry key="biography_birth_date_century_invalid_value">
				<TITLE>Biogram</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis>. Jako format daty urodzenia wybrano opcję <emphasis role="{$TER}">Tylko wiek / Na początku ... wieku / Na końcu ... wieku / Na przełomie ... (i następnego) wieku / W połowie ... wieku</emphasis>, ale wartość wprowadzona w polu <emphasis role="{$TER}">Data urodzenia</emphasis> nie jest poprawną liczbą zapisaną w formacie rzymskim (EB0013).</PATTERN>
			</entry>
			<entry key="biography_birth_date_lack_with_value">
				<TITLE>Biogram</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis>. Jako format daty urodzenia wybrano opcję <emphasis role="{$TER}">Brak daty</emphasis>, lecz wprowadzono wartość w polu <emphasis role="{$TER}">Data urodzenia</emphasis> (EB0014).</PATTERN>
			</entry>
			<entry key="biography_death_date_exact_pattern_mismatch">
				<TITLE>Biogram</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis>. Jako format daty śmierci wybrano opcję <emphasis role="{$TER}">Dokładna data</emphasis>, ale wartość wprowadzona w polu <emphasis role="{$TER}">Data śmierci</emphasis> nie pasuje do formatu (EB0015).</PATTERN>
			</entry>
			<entry key="biography_death_date_year_pattern_mismatch">
				<TITLE>Biogram</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis>. Jako format daty śmierci wybrano opcję <emphasis role="{$TER}">Tylko rok / Około ... roku</emphasis>, ale wartość wprowadzona w polu <emphasis role="{$TER}">Data śmierci</emphasis> nie pasuje do formatu (EB0016).</PATTERN>
			</entry>
			<entry key="biography_death_date_century_invalid_value">
				<TITLE>Biogram</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis>. Jako format daty śmierci wybrano opcję <emphasis role="{$TER}">Tylko wiek / Na początku ... wieku / Na końcu ... wieku / Na przełomie ... (i następnego) wieku / W połowie ... wieku</emphasis>, ale wartość wprowadzona w polu <emphasis role="{$TER}">Data śmierci</emphasis> nie jest poprawną liczbą zapisaną w formacie rzymskim (EB0017).</PATTERN>
			</entry>
			<entry key="biography_death_date_lack_with_value">
				<TITLE>Biogram</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Biogram</emphasis>. Jako format daty śmierci wybrano opcję <emphasis role="{$TER}">Brak daty</emphasis>, lecz wprowadzono wartość w polu <emphasis role="{$TER}">Data śmierci</emphasis> (EB0018).</PATTERN>
			</entry>
			<entry key="biography_name_missing">
				<TITLE>Biogram</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Biogram</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Nazwa</emphasis> (EB0019).</PATTERN>
			</entry>
			<entry key="biography_reference_to_non_existing_biography">
				<TITLE>Biogram - odwołanie</TITLE>
				<PATTERN>Biogram o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> nie został zdefiniowany w tym module. Nie istnieje też biogram o tej nazwie (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>) zdefiniowany w innym module tego e-podręcznika i przeznaczony do wykorzystania w słowniczku (EB0020).</PATTERN>
			</entry>
			<entry key="biography_under_that_name_already_exists">
				<TITLE>Biogram - duplikat</TITLE>
				<PATTERN>Biogram o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> został zdefiniowany w tym module więcej niż 1 raz. Nazwa jest wykorzystywana do połączenia biogramu z odwołaniem, dlatego nazwy biogramów w obrębie modułu (całego e-podręcznika w przypadku biogramów zadeklarowanych jako słownikowe) muszą być unikalne. Pozostałe wystąpienia: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (EB0021).</PATTERN>
			</entry>
			<entry key="biography_under_that_name_already_exists_global">
				<TITLE>Biogram - duplikat</TITLE>
				<PATTERN>Biogram o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> został zdefiniowany w tym e-podręczniku więcej niż 1 raz. Nazwa jest wykorzystywana do połączenia biogramu z odwołaniem, dlatego nazwy biogramów zadeklarowanych jako słownikowe, muszą być unikalne w obrębie całego e-podręcznika. Wystąpienia w innych modułach: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (EB0021).</PATTERN>
			</entry>
			<entry key="event_name_duplicate">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis> wystąpił duplikat nazwy (EWY0001).</PATTERN>
			</entry>
			<entry key="event_disallowed_elements">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis> wystąpiły elementy korzystające ze stylów, które nie są dozwolone w tym kontekście: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EWY0002).</PATTERN>
			</entry>
			<entry key="event_local_metadata_missing">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis> brakuje tabelki z atrybutami lub atrybuty nie mogły zostać przetworzone (EWY0003).</PATTERN>
			</entry>
			<entry key="event_local_metadata_duplicate">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis> występuje duplikat tabelki z atrybutami (EWY0004).</PATTERN>
			</entry>
			<entry key="event_content_missing">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Opis</emphasis> (EWY0005).</PATTERN>
			</entry>
			<entry key="event_content_duplicate">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>W bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis> występuje duplikat elementu opisanego stylem <emphasis role="{$TER}">EP Opis</emphasis> (EWY0006).</PATTERN>
			</entry>
			<entry key="event_local_metadata_field_pattern_mismatch">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis>. Nieprawidłowa wartość dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość dozwolona to: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis>, podczas gdy w dokumencie znajduje się wartość: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (EWY0007).</PATTERN>
			</entry>
			<entry key="event_local_metadata_field_unknown_option">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis>. Nieznana opcja dla atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>. Wartość <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> nie została rozpoznana (EWY0008).</PATTERN>
			</entry>
			<entry key="event_local_metadata_field_missing">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis>. Nie można przetworzyć atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EWY0009).</PATTERN>
			</entry>
			<entry key="event_local_metadata_field_duplicate">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis>. Duplikat atrybutu: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (EWY0010).</PATTERN>
			</entry>
			<entry key="event_start_date_exact_pattern_mismatch">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis>. Jako format daty rozpoczęcia wydarzenia wybrano opcję <emphasis role="{$TER}">Dokładna data</emphasis>, ale wartość wprowadzona w polu <emphasis role="{$TER}">Data rozpoczęcia wydarzenie</emphasis> nie pasuje do formatu (EWY0011).</PATTERN>
			</entry>
			<entry key="event_start_date_year_pattern_mismatch">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis>. Jako format daty rozpoczęcia wydarzenia wybrano opcję <emphasis role="{$TER}">Tylko rok / Około ... roku</emphasis>, ale wartość wprowadzona w polu <emphasis role="{$TER}">Data rozpoczęcia wydarzenie</emphasis> nie pasuje do formatu (EWY0012).</PATTERN>
			</entry>
			<entry key="event_start_date_century_invalid_value">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis>. Jako format daty rozpoczęcia wydarzenia wybrano opcję <emphasis role="{$TER}">Tylko wiek / Na początku ... wieku / Na końcu ... wieku / Na przełomie ... (i następnego) wieku / W połowie ... wieku</emphasis>, ale wartość wprowadzona w polu <emphasis role="{$TER}">Data rozpoczęcia wydarzenie</emphasis> nie jest poprawną liczbą zapisaną w formacie rzymskim (EWY0013).</PATTERN>
			</entry>
			<entry key="event_start_date_lack_with_value">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis>. Jako format daty rozpoczęcia wydarzenia wybrano opcję <emphasis role="{$TER}">Brak daty</emphasis>, lecz wprowadzono wartość w polu <emphasis role="{$TER}">Data rozpoczęcia wydarzenie</emphasis> (EWY0014).</PATTERN>
			</entry>
			<entry key="event_end_date_exact_pattern_mismatch">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis>. Jako format daty zakończenia wydarzenia wybrano opcję <emphasis role="{$TER}">Dokładna data</emphasis>, ale wartość wprowadzona w polu <emphasis role="{$TER}">Data zakończenia wydarzenia</emphasis> nie pasuje do formatu (EWY0015).</PATTERN>
			</entry>
			<entry key="event_end_date_year_pattern_mismatch">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis>. Jako format daty zakończenia wydarzenia wybrano opcję <emphasis role="{$TER}">Tylko rok / Około ... roku</emphasis>, ale wartość wprowadzona w polu <emphasis role="{$TER}">Data zakończenia wydarzenia</emphasis> nie pasuje do formatu (EWY0016).</PATTERN>
			</entry>
			<entry key="event_end_date_century_invalid_value">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis>. Jako format daty zakończenia wydarzenia wybrano opcję <emphasis role="{$TER}">Tylko wiek / Na początku ... wieku / Na końcu ... wieku / Na przełomie ... (i następnego) wieku / W połowie ... wieku</emphasis>, ale wartość wprowadzona w polu <emphasis role="{$TER}">Data zakończenia wydarzenia</emphasis> nie jest poprawną liczbą zapisaną w formacie rzymskim (EWY0017).</PATTERN>
			</entry>
			<entry key="event_end_date_lack_with_value">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Problem z tabelką z atrybutami w bloku opisanym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis>. Jako format daty zakończenia wydarzenia wybrano opcję <emphasis role="{$TER}">Brak daty</emphasis>, lecz wprowadzono wartość w polu <emphasis role="{$TER}">Data zakończenia wydarzenia</emphasis> (EWY0018).</PATTERN>
			</entry>
			<entry key="event_name_missing">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Nazwa</emphasis> (EWY0019).</PATTERN>
			</entry>
			<entry key="event_reference_to_non_existing_event">
				<TITLE>Wydarzenie - odwołanie</TITLE>
				<PATTERN>Wydarzenie o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> nie zostało zdefiniowane w tym module. Nie istnieje też wydarzenie o tej nazwie (<emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis>) zdefiniowane w innym module tego e-podręcznika i przeznaczone do wykorzystania w słowniczku (EWY0020).</PATTERN>
			</entry>
			<entry key="event_under_that_name_already_exists">
				<TITLE>Wydarzenie - duplikat</TITLE>
				<PATTERN>Wydarzenie o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> zostało zdefiniowane w tym module więcej niż 1 raz. Nazwa jest wykorzystywana do połączenia wydarzenia z odwołaniem, dlatego nazwy wydarzeń w obrębie modułu (całego e-podręcznika w przypadku wydarzeń zadeklarowanych jako słownikowe) muszą być unikalne. Pozostałe wystąpienia: <emphasis role="{$TER}">
						<epconvert:token number="2"/>
					</emphasis> (EWY0021).</PATTERN>
			</entry>
			<entry key="event_under_that_name_already_exists_global">
				<TITLE>Wydarzenie - duplikat</TITLE>
				<PATTERN>Wydarzenie o nazwie <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> zostało zdefiniowane w tym e-podręczniku więcej niż 1 raz. Nazwa jest wykorzystywana do połączenia wydarzenia z odwołaniem, dlatego nazwy wydarzeń zadeklarowanych jako słownikowe, muszą być unikalne w obrębie całego e-podręcznika. Wystąpienia w innych modułach: <emphasis role="{$TER}">
						<epconvert:token number="3"/>
					</emphasis> (EWY0021).</PATTERN>
			</entry>
			<entry key="teacher_recipient_in_teacher_module">
				<TITLE>Adresat treści</TITLE>
				<PATTERN>Lokalne zdefiniowanie adresata treści identyczne z ustawieniem globalnym (WS0001).</PATTERN>
			</entry>
			<entry key="local_status_matching_global_status">
				<TITLE>Status treści</TITLE>
				<PATTERN>Lokalne zdefiniowanie statusu treści identyczne z ustawieniem globalnym (WS0002).</PATTERN>
			</entry>
			<entry key="special_table_not_supported_in_this_context">
				<TITLE>Tabela z atrybutami</TITLE>
				<PATTERN>Zastosowanie tabeli z atrybutami w złym kontekście. Tabela nie może pojawić się poza zakresem odpowiedniego komentarza EPK lub innej tabeli. Dotyczy: <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> (WS0003).</PATTERN>
			</entry>
			<entry key="style_not_supported_in_this_context">
				<TITLE>Zastosowanie stylu</TITLE>
				<PATTERN>Styl <emphasis role="{$TER}">
						<epconvert:token number="1"/>
					</emphasis> nie może być zastosowany w tym kontekście (WY0001).</PATTERN>
			</entry>
			<entry key="tooltip_wrong_order">
				<TITLE>Dymek</TITLE>
				<PATTERN>Nieprawidłowa kolejność elementów w bloku oznaczonym stylem <emphasis role="{$TER}">EPK Dymek</emphasis>. Poprawna kolejność to <emphasis role="{$TER}">EP Nazwa[1], EP Dymek[1]</emphasis> (WDY0001).</PATTERN>
			</entry>
			<entry key="procedure-instructions_wrong_order">
				<TITLE>Instrukcja postępowania</TITLE>
				<PATTERN>Nieprawidłowa kolejność elementów w bloku oznaczonym stylem <emphasis role="{$TER}">EPK Instrukcja postępowania</emphasis>. Poprawna kolejność to <emphasis role="{$TER}">EP Nazwa[1], EP Krok[1+]</emphasis> (WIP0001).</PATTERN>
			</entry>
			<entry key="code_wrong_order">
				<TITLE>Kod</TITLE>
				<PATTERN>Nieprawidłowa kolejność elementów w bloku oznaczonym stylem <emphasis role="{$TER}">EPK Kod</emphasis>. Poprawna kolejność to <emphasis role="{$TER}">EP Nazwa[0-1], EP Kod akapit[1]</emphasis> (WO0001).</PATTERN>
			</entry>
			<entry key="list_name_missing">
				<TITLE>Lista</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Lista</emphasis> nie zawiera elementu oznaczonego stylem <emphasis role="{$TER}">EP Nazwa</emphasis> (WI0001).</PATTERN>
			</entry>
			<entry key="list_wrong_order">
				<TITLE>Lista</TITLE>
				<PATTERN>Nieprawidłowa kolejność elementów w bloku oznaczonym stylem <emphasis role="{$TER}">EPK Lista</emphasis>. Poprawna kolejność to <emphasis role="{$TER}">EP Nazwa[1], lista punktowana lub numerowana[1]</emphasis> (WI0002).</PATTERN>
			</entry>
			<entry key="cite_name_or_author_missing">
				<TITLE>Cytat</TITLE>
				<PATTERN>Blok opisany stylem <emphasis role="{$TER}">EPK Cytat</emphasis> nie zawiera ani elementu oznaczonego stylem <emphasis role="{$TER}">EP Nazwa</emphasis>, ani elementu oznaczonego stylem <emphasis role="{$TER}">EP Autor</emphasis> (WQ0001).</PATTERN>
			</entry>
			<entry key="cite_wrong_order">
				<TITLE>Cytat</TITLE>
				<PATTERN>Nieprawidłowa kolejność elementów w bloku oznaczonym stylem <emphasis role="{$TER}">EPK Cytat</emphasis>. Poprawna kolejność to <emphasis role="{$TER}">EP Nazwa[0-1], EP Autor[0+], EP Cytat akapit[1], EP Cytat akapit - komentarz[0-1]</emphasis> (WQ0002).</PATTERN>
			</entry>
			<entry key="rule_wrong_order">
				<TITLE>Reguła</TITLE>
				<PATTERN>Nieprawidłowa kolejność elementów w bloku oznaczonym stylem <emphasis role="{$TER}">EPK Reguła</emphasis>. Poprawna kolejność to <emphasis role="{$TER}">EP Nazwa[1], EP Reguła - twierdzenie[1+], EP Reguła - dowód[0+], EP Przykład[0+]</emphasis> (WR0001).</PATTERN>
			</entry>
			<entry key="exercise_wrong_order">
				<TITLE>Ćwiczenie</TITLE>
				<PATTERN>Nieprawidłowa kolejność elementów w bloku oznaczonym stylem <emphasis role="{$TER}">EPK Ćwiczenie</emphasis>. Poprawna kolejność to <emphasis role="{$TER}">EP Nazwa[0-1], EP Ćwiczenie - problem[1], EP Notka - wskazówka[0-1], EP Ćwiczenie - rozwiązanie[0+], EP Ćwiczenie – wyjaśnienie[0-1], EP Przykład[0-1]</emphasis> (WX0001).</PATTERN>
			</entry>
			<entry key="definition_wrong_order">
				<TITLE>Definicja/Pojęcie</TITLE>
				<PATTERN>Nieprawidłowa kolejność elementów w bloku oznaczonym stylem <emphasis role="{$TER}">EPK Definicja / EPK Pojęcie</emphasis>. Poprawna kolejność to <emphasis role="{$TER}">EP Nazwa[1], (EP Definicja - znaczenie[1], EP Przykład[0+])[1+]</emphasis> (WD0001).</PATTERN>
			</entry>
			<entry key="quiz_wrong_order">
				<TITLE>Zadanie</TITLE>
				<PATTERN>Nieprawidłowa kolejność elementów w bloku oznaczonym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Poprawna kolejność to <emphasis role="{$TER}">EP Nazwa[0-1], EPQ Pytanie[1], (EPQ Odpowiedź - poprawna[1] lub EPQ Odpowiedź - błędna[1])[1+], EPQ Wskazówka[0+], EPQ Wyjaśnienie[0-1]</emphasis> (WU0001).</PATTERN>
			</entry>
			<entry key="quiz_wrong_order_random">
				<TITLE>Zadanie z losowaniem odpowiedzi</TITLE>
				<PATTERN>Nieprawidłowa kolejność elementów w bloku oznaczonym stylem <emphasis role="{$TER}">EPK Zadanie</emphasis>. Poprawna kolejność to <emphasis role="{$TER}">EP Nazwa[0-1], EPQ Pytanie[1], (EPQ Odpowiedź - poprawna[1] lub (EPQ Odpowiedź - błędna[1], EPQ Podpowiedź[0-1]))[1+], EPQ Wskazówka[0+], EPQ Wyjaśnienie[0-1], EPQ Komunikat - odpowiedź poprawna[0-1], EPQ Komunikat - odpowiedź błędna[0-1]</emphasis> (WU0002).</PATTERN>
			</entry>
			<entry key="experiment_wrong_order">
				<TITLE>Doświadczenie</TITLE>
				<PATTERN>Nieprawidłowa kolejność elementów w bloku oznaczonym stylem <emphasis role="{$TER}">EPK Doświadczenie</emphasis>. Poprawna kolejność to <emphasis role="{$TER}">EP Nazwa[0-1], ((EP Doświadczenie – problem badawczy[1], EP Doświadczenie – hipoteza[1]) lub EP Doświadczenie - cel[1])[1], EP Doświadczenie – materiały i przyrządy[0-1], EP Doświadczenie - instrukcja[1], EP Doświadczenie – podsumowanie[0-1]</emphasis> (WE0001).</PATTERN>
			</entry>
			<entry key="observation_wrong_order">
				<TITLE>Obserwacja</TITLE>
				<PATTERN>Nieprawidłowa kolejność elementów w bloku oznaczonym stylem <emphasis role="{$TER}">EPK Obserwacja</emphasis>. Poprawna kolejność to <emphasis role="{$TER}">EP Nazwa[0-1], EP Doświadczenie - cel[1], EP Doświadczenie – materiały i przyrządy[0-1], EP Doświadczenie - instrukcja[1], EP Doświadczenie – podsumowanie[0-1]</emphasis> (WEO0001).</PATTERN>
			</entry>
			<entry key="biography_wrong_order">
				<TITLE>Biogram</TITLE>
				<PATTERN>Nieprawidłowa kolejność elementów w bloku oznaczonym stylem <emphasis role="{$TER}">EPK Biogram</emphasis>. Poprawna kolejność to <emphasis role="{$TER}">EP Nazwa[1], EP Opis[1]</emphasis> (WB0001).</PATTERN>
			</entry>
			<entry key="biography_sorted_but_doesnt_go_to_glossary">
				<TITLE>Biogram</TITLE>
				<PATTERN>Zdefiniowano klucz sortowania, ale nie oznaczono biogramu jako przeznaczonego do słowniczka (WB0002).</PATTERN>
			</entry>
			<entry key="event_wrong_order">
				<TITLE>Wydarzenie</TITLE>
				<PATTERN>Nieprawidłowa kolejność elementów w bloku oznaczonym stylem <emphasis role="{$TER}">EPK Wydarzenie</emphasis>. Poprawna kolejność to <emphasis role="{$TER}">EP Nazwa[1], EP Opis[1]</emphasis> (WWY0001).</PATTERN>
			</entry>
		</dyna_issues>
	</xsl:variable>
	<xsl:template name="get_issue_tokens">
		<xsl:param name="type"/>
		<xsl:choose>
			<xsl:when test="$type='DEFAULT'">
				<token>
					<xsl:value-of select="@type"/>
				</token>
				<token>
					<xsl:choose>
						<xsl:when test="local-name()='error'">błąd</xsl:when>
						<xsl:otherwise>ostrzeżenie</xsl:otherwise>
					</xsl:choose>
				</token>
			</xsl:when>
			<xsl:when test="$type='style_not_supported_in_this_context'">
				<xsl:variable name="style" select="text()"/>
				<token>
					<xsl:value-of select="$EP_STYLES/style[@key=$style]/hr-name"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='special_table_not_supported_in_this_context'">
				<token>
					<xsl:value-of select="text()"/>
				</token>
			</xsl:when>
			<xsl:when test="some $x in ('code_disallowed_elements','list_disallowed_elements','cite_disallowed_elements','rule_disallowed_elements','exercise_disallowed_elements','exercise_WOMI_disallowed_elements','exercise_WOMI_set_disallowed_elements','command_disallowed_elements','definition_disallowed_elements','quiz_disallowed_elements','experiment_disallowed_elements','observation_disallowed_elements','biography_disallowed_elements','event_disallowed_elements','procedure-instructions_disallowed_elements','tooltip_disallowed_elements') satisfies $type=$x">
				<token>
					<xsl:for-each select="element()">
						<xsl:if test="@style or @tag">
							<xsl:choose>
								<xsl:when test="@style">
									<xsl:variable name="key" select="@style"/>
									<xsl:value-of select="$EP_STYLES/style[@key=$key]/hr-name"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="key" select="@type"/>
									<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type=$key]/name"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</token>
			</xsl:when>
			<xsl:when test="'homework_disallowed_elements'=$type">
				<token>
					<xsl:for-each select="element()">
						<xsl:if test="@style or @tag or 'block'=local-name()">
							<xsl:choose>
								<xsl:when test="@style">
									<xsl:variable name="key" select="@style"/>
									styl: <xsl:value-of select="$EP_STYLES/style[@key=$key]/hr-name"/>
								</xsl:when>
								<xsl:when test="@tag">
									<xsl:variable name="key" select="@type"/>
									<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type=$key]/name"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="key" select="@name"/>
									blok: <xsl:value-of select="$EP_BLOCKS/block[@key=$key]/hr-name"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</token>
			</xsl:when>
			<xsl:when test="some $x in ('experiment_local_metadata_field_missing','experiment_local_metadata_field_duplicate','observation_local_metadata_field_missing','observation_local_metadata_field_duplicate','biography_local_metadata_field_missing','biography_local_metadata_field_duplicate','event_local_metadata_field_missing','event_local_metadata_field_duplicate','definition_local_metadata_field_missing','definition_local_metadata_field_duplicate','rule_local_metadata_field_missing','rule_local_metadata_field_duplicate','exercise_local_metadata_field_missing','exercise_local_metadata_field_duplicate','quiz_local_metadata_field_missing','quiz_local_metadata_field_duplicate','cite_local_metadata_field_missing','cite_local_metadata_field_duplicate','tooltip_local_metadata_field_duplicate','tooltip_local_metadata_field_missing','code_local_metadata_field_missing','code_local_metadata_field_duplicate','global_metadata_field_missing','global_metadata_field_duplicate','section_metadata_field_missing','section_metadata_field_duplicate','author_metadata_field_missing','author_metadata_field_duplicate','core_curriculum_metadata_field_missing','keyword_metadata_field_duplicate','keyword_metadata_field_missing','bibliography_local_metadata_field_missing','bibliography_local_metadata_field_duplicate','WOMI_gallery_attribute_missing','WOMI_gallery_attribute_duplicate') satisfies $type=$x">
				<token>
					<xsl:value-of select="field_name/text()"/>
				</token>
			</xsl:when>
			<xsl:when test="some $x in ('biography_local_metadata_field_unknown_option','event_local_metadata_field_unknown_option','definition_local_metadata_field_unknown_option','rule_local_metadata_field_unknown_option','exercise_local_metadata_field_unknown_option','quiz_local_metadata_field_unknown_option','experiment_local_metadata_field_unknown_option','observation_local_metadata_field_unknown_option','cite_local_metadata_field_unknown_option','tooltip_local_metadata_field_unknown_option','code_local_metadata_field_unknown_option','global_metadata_field_unknown_option','section_metadata_field_unknown_option','keyword_metadata_field_unknown_option','bibliography_local_metadata_field_unknown_option','WOMI_gallery_attribute_unknown_option') satisfies $x=$type">
				<token>
					<xsl:value-of select="field_name/text()"/>
				</token>
				<token>
					<xsl:value-of select="value/text()"/>
				</token>
			</xsl:when>
			<xsl:when test="some $x in ('biography_local_metadata_field_pattern_mismatch','event_local_metadata_field_pattern_mismatch','cite_local_metadata_field_pattern_mismatch','global_metadata_field_pattern_mismatch','section_metadata_field_pattern_mismatch','core_curriculum_metadata_field_pattern_mismatch','author_metadata_field_pattern_mismatch','bibliography_local_metadata_field_pattern_mismatch','WOMI_gallery_attribute_pattern_mismatch') satisfies $x=$type">
				<token>
					<xsl:value-of select="field_name/text()"/>
				</token>
				<token>
					<xsl:value-of select="allowed/text()"/>
				</token>
				<token>
					<xsl:value-of select="value/text()"/>
				</token>
			</xsl:when>
			<xsl:when test="some $x in ('exercise_WOMI_not_OINT','exercise_WOMI_WOMI_not_OINT','exercise_WOMI_set_WOMI_not_OINT','WOMI_gallery_playlist_but_WOMI_not_VIDEO_or_IMAGE','homework_exercise_WOMI_not_OINT') satisfies $x=$type">
				<token>
					<xsl:value-of select="@WOMI_id"/>
				</token>
			</xsl:when>
			<xsl:when test="some $x in ('quiz_wrong_order_hint_not_after_wrong_answer','quiz_wrong_order_hint_after_hint') satisfies $type=$x">
				<token>
					<xsl:value-of select="@answer"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='quiz_number_of_correct_answers_min_greater_than_max'">
				<token>
					<xsl:value-of select="@correct_answers_max"/>
				</token>
				<token>
					<xsl:value-of select="@correct_answers_min"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='quiz_number_of_correct_answers_max_greater_than_presented_answers'">
				<token>
					<xsl:value-of select="@correct_answers_max"/>
				</token>
				<token>
					<xsl:value-of select="@presented_answers"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='quiz_non_zero_number_of_answers_mod_number_of_presented_answers_while_sets'">
				<token>
					<xsl:value-of select="@answers"/>
				</token>
				<token>
					<xsl:value-of select="@presented_answers"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='quiz_number_of_correct_answers_in_single_response_not_1_while_sets'">
				<token>
					<xsl:value-of select="@set"/>
				</token>
				<token>
					<xsl:value-of select="@start"/>
				</token>
				<token>
					<xsl:value-of select="@stop"/>
				</token>
				<token>
					<xsl:value-of select="@count"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='quiz_number_answers_less_than_number_of_presented_answers'">
				<token>
					<xsl:value-of select="@presented_answers"/>
				</token>
				<token>
					<xsl:value-of select="@answers"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='quiz_number_of_correct_answers_in_single_response_set_1_not_1_while_randomize'">
				<token>
					<xsl:value-of select="@presented_answers"/>
				</token>
				<token>
					<xsl:value-of select="@count"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='quiz_number_of_correct_answers_max_less_than_number_of_all_correct_answers'">
				<token>
					<xsl:value-of select="@correct_answers_max"/>
				</token>
				<token>
					<xsl:value-of select="@correct_answers"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='quiz_number_of_incorrect_answers_is_to_low'">
				<token>
					<xsl:value-of select="@needed_incorrect_answers"/>
				</token>
				<token>
					<xsl:value-of select="@incorrect_answers"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='cite_readability_set_while_length_less_than_700'">
				<token>
					<xsl:value-of select="text()"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='global_metadata_template_tiles_no_mismatch_sections_no'">
				<token>
					<xsl:value-of select="@subsections"/>
				</token>
				<token>
					<xsl:value-of select="@tiles"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='noname_section_metadata_linear_with_columns_more_than_1'">
				<token>
					<xsl:value-of select="@columns"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='section_metadata_l1_subtype_different_then_module_metadata_subtype'">
				<token>
					<xsl:value-of select="@global"/>
				</token>
				<token>
					<xsl:value-of select="@local"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='keyword_metadata_subtype_different_then_module_metadata_subtype'">
				<token>
					<xsl:value-of select="@global"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='section_metadata_tile_duplicate'">
				<token>
					<xsl:value-of select="@tile"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='section_metadata_linear_columns_mismatch_no_of_subsections'">
				<token>
					<xsl:value-of select="@columns"/>
				</token>
				<token>
					<xsl:value-of select="@subsections"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='list_duplicate'">
				<token>
					<xsl:value-of select="text()"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='list_starting_with_ilvl_gt_0'">
				<token>
					<xsl:value-of select="@ilvl"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='list_with_level_gap'">
				<xsl:variable name="full_text">
					<xsl:value-of select="epconvert:select_text_for_element(list_item)"/>
				</xsl:variable>
				<token>
					<xsl:value-of select="substring($full_text,1,10)"/>
				</token>
				<token>
					<xsl:value-of select="@ilvl+1"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='EW0001'">
				<token>
					<xsl:value-of select="@womi_width"/>
				</token>
				<token>
					<xsl:value-of select="@womi_id"/>
				</token>
			</xsl:when>
			<xsl:when test="some $x in ('WOMI_attribute_duplicate','WOMI_attribute_missing','WOMI_zoomable_while_not_image','WOMI_avatar_while_not_oint') satisfies $type=$x">
				<token>
					<xsl:value-of select="field_name/text()"/>
				</token>
				<token>
					<xsl:value-of select="@id"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='WOMI_attribute_unknown_option'">
				<token>
					<xsl:value-of select="field_name/text()"/>
				</token>
				<token>
					<xsl:value-of select="value/text()"/>
				</token>
				<token>
					<xsl:value-of select="@id"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='WOMI_attribute_pattern_mismatch'">
				<token>
					<xsl:value-of select="field_name/text()"/>
				</token>
				<token>
					<xsl:value-of select="allowed/text()"/>
				</token>
				<token>
					<xsl:value-of select="value/text()"/>
				</token>
				<token>
					<xsl:value-of select="@id"/>
				</token>
			</xsl:when>
			<xsl:when test="some $x in ('WOMI_gallery_type_disallowed_attribute','WOMI_gallery_attribute_undefined','core_curriculum_unable_to_map','core_curriculum_unable_to_map_no_such_key') satisfies $type=$x">
				<token>
					<xsl:value-of select="text()"/>
				</token>
				<token>
					<xsl:value-of select="@gallery_type"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='WOMI_gallery_start_on_greater_than_no_of_WOMIs'">
				<token>
					<xsl:value-of select="@start_on"/>
				</token>
				<token>
					<xsl:value-of select="@no_of_WOMIs"/>
				</token>
			</xsl:when>
			<xsl:when test="some $x in ('keyword_already_defined_in_this_module','bibliography_author_duplicate','bibliography_editor_duplicate') satisfies $type=$x">
				<token>
					<xsl:value-of select="name/text()"/>
				</token>
			</xsl:when>
			<xsl:when test="some $x in ('tooltip_under_that_name_already_exists','glossary_under_that_name_already_exists','concept_under_that_name_already_exists','biography_under_that_name_already_exists','event_under_that_name_already_exists','glossary_under_that_name_already_exists_global','concept_under_that_name_already_exists_global','biography_under_that_name_already_exists_global','event_under_that_name_already_exists_global','bibliography_under_that_id_already_exists') satisfies $type=$x">
				<token>
					<emphasis role="{$TER}">
						<xsl:value-of select="name/text()"/>
					</emphasis>
				</token>
				<token>
					<xsl:choose>
						<xsl:when test="duplicate[not(@module)]">
							<xsl:for-each select="duplicate[not(@module)]">
								<link linkend="{@local-id}">
									duplikat <xsl:value-of select="1 + count(preceding-sibling::duplicate[not(@module)])"/>
								</link>
								<xsl:if test="following-sibling::duplicate[not(@module)]">, </xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							brak
						</xsl:otherwise>
					</xsl:choose>
				</token>
				<token>
					<xsl:choose>
						<xsl:when test="duplicate[@module]">
							<xsl:for-each select="duplicate[@module]">
								<xsl:variable name="ra_prefix" select="$DOCXM_MAP_MY_ENTRY/ra_prefix/text()"/>
								<xsl:variable name="url" select="concat($ra_prefix,'/',@module,'.pdf','#',@local-id)"/>
								<ulink url="{$url}">
									duplikat <xsl:value-of select="1 + count(preceding-sibling::duplicate[@module])"/>
								</ulink>
								<xsl:if test="following-sibling::duplicate[@module]">, </xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							brak
						</xsl:otherwise>
					</xsl:choose>
				</token>
			</xsl:when>
			<xsl:when test="some $x in ('glossary_reference_to_non_existing_element','concept_reference_to_non_existing_concept','tooltip_reference_to_non_existing_tooltip','event_reference_to_non_existing_event','biography_reference_to_non_existing_biography','bibliography_reference_to_non_existing_bibliography') satisfies $type=$x">
				<token>
					<xsl:value-of select="text()"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='inline_comment_nesting_error'">
				<token>
					<xsl:value-of select="@style"/>
				</token>
				<token>
					<xsl:value-of select="text()"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='EW0002'">
				<token>
					<xsl:value-of select="text()"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='WOMI_text_copy_but_no_classic_text'">
				<token>
					<xsl:value-of select="@id"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='WOMI_reference_no_context_but_static_text'">
				<token>
					<xsl:value-of select="@id"/>
				</token>
				<token>
					<xsl:choose>
						<xsl:when test="'static'=@for">
							<xsl:value-of select="$L/WOMI_TEXT_STATIC_OF"/>
						</xsl:when>
						<xsl:when test="'static_mono'=@for">
							<xsl:value-of select="$L/WOMI_TEXT_STATIC_MONO_OF"/>
						</xsl:when>
					</xsl:choose>
				</token>
			</xsl:when>
			<xsl:when test="$type='WW0001'">
				<token>
					<xsl:for-each select="id">
						<xsl:value-of select="text()"/>
						<xsl:if test="position()!=last()">, </xsl:if>
					</xsl:for-each>
				</token>
			</xsl:when>
			<xsl:when test="$type='core_curriculum_metadata_duplicate_value_2'">
				<token>
					<xsl:value-of select="@code"/>
				</token>
				<token>
					<xsl:value-of select="@count"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='EL0001'">
				<token>
					<xsl:value-of select="@link_anchor"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='EL0002'">
				<token>
					<xsl:value-of select="text()"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='EL0003'">
				<token>
					<xsl:value-of select="text()"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='EL0005'">
				<token>
					<xsl:value-of select="text()"/>
				</token>
			</xsl:when>
			<xsl:when test="$type='WL0001'">
				<token>
					<xsl:value-of select="link_anchor/text()"/>
				</token>
				<token>
					<xsl:value-of select="file_name/text()"/>
				</token>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
