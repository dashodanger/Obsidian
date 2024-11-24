//----------------------------------------------------------------------
//  TRANSLATION / INTERNATIONALIZATION
//----------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
//  Copyright (C) 2016-2017 Andrew Apted
//  Copyright (C) 1995-2015 Free Software Foundation, Inc.
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//----------------------------------------------------------------------
//
//  Note : we use some code from GNU Gettext (intl/localname.c)
//  which is under the LGPL 2.1 license.
//
//----------------------------------------------------------------------

#include "m_trans.h"

#ifndef _WIN32
#include <locale.h>
#else
#include <windows.h>
#endif

#include <stdint.h>
#include <string.h>

#include <algorithm>

#include "lib_util.h"
#include "main.h"
#include "sys_assert.h"
#include "sys_macro.h"

//
// NOTE :
//    We assume that any string retrieved from our 'trans_store'
//    will always be valid.  Since we never change anything in it
//    once the PO file is loaded, that assumptions should hold.
//
#include <map>

static std::map<std::string, std::string>           trans_store;
static std::map<std::string, std::string>::iterator trans_iter;

// current Options setting
std::string t_language = _("AUTO");

//----------------------------------------------------------------------

// largest string we can load
static constexpr int MAX_TRANS_STRING = 65536;

/* Mingw headers don't have latest language and sublanguage codes. */
#ifdef _WIN32
#ifndef LANG_AFRIKAANS
#define LANG_AFRIKAANS 0x36
#endif
#ifndef LANG_ALBANIAN
#define LANG_ALBANIAN 0x1c
#endif
#ifndef LANG_ALSATIAN
#define LANG_ALSATIAN 0x84
#endif
#ifndef LANG_AMHARIC
#define LANG_AMHARIC 0x5e
#endif
#ifndef LANG_ARABIC
#define LANG_ARABIC 0x01
#endif
#ifndef LANG_ARMENIAN
#define LANG_ARMENIAN 0x2b
#endif
#ifndef LANG_ASSAMESE
#define LANG_ASSAMESE 0x4d
#endif
#ifndef LANG_AZERI
#define LANG_AZERI 0x2c
#endif
#ifndef LANG_BASHKIR
#define LANG_BASHKIR 0x6d
#endif
#ifndef LANG_BASQUE
#define LANG_BASQUE 0x2d
#endif
#ifndef LANG_BELARUSIAN
#define LANG_BELARUSIAN 0x23
#endif
#ifndef LANG_BENGALI
#define LANG_BENGALI 0x45
#endif
#ifndef LANG_BRETON
#define LANG_BRETON 0x7e
#endif
#ifndef LANG_BURMESE
#define LANG_BURMESE 0x55
#endif
#ifndef LANG_CAMBODIAN
#define LANG_CAMBODIAN 0x53
#endif
#ifndef LANG_CATALAN
#define LANG_CATALAN 0x03
#endif
#ifndef LANG_CHEROKEE
#define LANG_CHEROKEE 0x5c
#endif
#ifndef LANG_CORSICAN
#define LANG_CORSICAN 0x83
#endif
#ifndef LANG_DARI
#define LANG_DARI 0x8c
#endif
#ifndef LANG_DIVEHI
#define LANG_DIVEHI 0x65
#endif
#ifndef LANG_EDO
#define LANG_EDO 0x66
#endif
#ifndef LANG_ESTONIAN
#define LANG_ESTONIAN 0x25
#endif
#ifndef LANG_FAEROESE
#define LANG_FAEROESE 0x38
#endif
#ifndef LANG_FARSI
#define LANG_FARSI 0x29
#endif
#ifndef LANG_FRISIAN
#define LANG_FRISIAN 0x62
#endif
#ifndef LANG_FULFULDE
#define LANG_FULFULDE 0x67
#endif
#ifndef LANG_GAELIC
#define LANG_GAELIC 0x3c
#endif
#ifndef LANG_GALICIAN
#define LANG_GALICIAN 0x56
#endif
#ifndef LANG_GEORGIAN
#define LANG_GEORGIAN 0x37
#endif
#ifndef LANG_GREENLANDIC
#define LANG_GREENLANDIC 0x6f
#endif
#ifndef LANG_GUARANI
#define LANG_GUARANI 0x74
#endif
#ifndef LANG_GUJARATI
#define LANG_GUJARATI 0x47
#endif
#ifndef LANG_HAUSA
#define LANG_HAUSA 0x68
#endif
#ifndef LANG_HAWAIIAN
#define LANG_HAWAIIAN 0x75
#endif
#ifndef LANG_HEBREW
#define LANG_HEBREW 0x0d
#endif
#ifndef LANG_HINDI
#define LANG_HINDI 0x39
#endif
#ifndef LANG_IBIBIO
#define LANG_IBIBIO 0x69
#endif
#ifndef LANG_IGBO
#define LANG_IGBO 0x70
#endif
#ifndef LANG_INDONESIAN
#define LANG_INDONESIAN 0x21
#endif
#ifndef LANG_INUKTITUT
#define LANG_INUKTITUT 0x5d
#endif
#ifndef LANG_KANNADA
#define LANG_KANNADA 0x4b
#endif
#ifndef LANG_KANURI
#define LANG_KANURI 0x71
#endif
#ifndef LANG_KASHMIRI
#define LANG_KASHMIRI 0x60
#endif
#ifndef LANG_KAZAK
#define LANG_KAZAK 0x3f
#endif
#ifndef LANG_KICHE
#define LANG_KICHE 0x86
#endif
#ifndef LANG_KINYARWANDA
#define LANG_KINYARWANDA 0x87
#endif
#ifndef LANG_KONKANI
#define LANG_KONKANI 0x57
#endif
#ifndef LANG_KYRGYZ
#define LANG_KYRGYZ 0x40
#endif
#ifndef LANG_LAO
#define LANG_LAO 0x54
#endif
#ifndef LANG_LATIN
#define LANG_LATIN 0x76
#endif
#ifndef LANG_LATVIAN
#define LANG_LATVIAN 0x26
#endif
#ifndef LANG_LITHUANIAN
#define LANG_LITHUANIAN 0x27
#endif
#ifndef LANG_LUXEMBOURGISH
#define LANG_LUXEMBOURGISH 0x6e
#endif
#ifndef LANG_MACEDONIAN
#define LANG_MACEDONIAN 0x2f
#endif
#ifndef LANG_MALAY
#define LANG_MALAY 0x3e
#endif
#ifndef LANG_MALAYALAM
#define LANG_MALAYALAM 0x4c
#endif
#ifndef LANG_MALTESE
#define LANG_MALTESE 0x3a
#endif
#ifndef LANG_MANIPURI
#define LANG_MANIPURI 0x58
#endif
#ifndef LANG_MAORI
#define LANG_MAORI 0x81
#endif
#ifndef LANG_MAPUDUNGUN
#define LANG_MAPUDUNGUN 0x7a
#endif
#ifndef LANG_MARATHI
#define LANG_MARATHI 0x4e
#endif
#ifndef LANG_MOHAWK
#define LANG_MOHAWK 0x7c
#endif
#ifndef LANG_MONGOLIAN
#define LANG_MONGOLIAN 0x50
#endif
#ifndef LANG_NEPALI
#define LANG_NEPALI 0x61
#endif
#ifndef LANG_OCCITAN
#define LANG_OCCITAN 0x82
#endif
#ifndef LANG_ORIYA
#define LANG_ORIYA 0x48
#endif
#ifndef LANG_OROMO
#define LANG_OROMO 0x72
#endif
#ifndef LANG_PAPIAMENTU
#define LANG_PAPIAMENTU 0x79
#endif
#ifndef LANG_PASHTO
#define LANG_PASHTO 0x63
#endif
#ifndef LANG_PUNJABI
#define LANG_PUNJABI 0x46
#endif
#ifndef LANG_QUECHUA
#define LANG_QUECHUA 0x6b
#endif
#ifndef LANG_ROMANSH
#define LANG_ROMANSH 0x17
#endif
#ifndef LANG_SAMI
#define LANG_SAMI 0x3b
#endif
#ifndef LANG_SANSKRIT
#define LANG_SANSKRIT 0x4f
#endif
#ifndef LANG_SCOTTISH_GAELIC
#define LANG_SCOTTISH_GAELIC 0x91
#endif
#ifndef LANG_SERBIAN
#define LANG_SERBIAN 0x1a
#endif
#ifndef LANG_SINDHI
#define LANG_SINDHI 0x59
#endif
#ifndef LANG_SINHALESE
#define LANG_SINHALESE 0x5b
#endif
#ifndef LANG_SLOVAK
#define LANG_SLOVAK 0x1b
#endif
#ifndef LANG_SOMALI
#define LANG_SOMALI 0x77
#endif
#ifndef LANG_SORBIAN
#define LANG_SORBIAN 0x2e
#endif
#ifndef LANG_SOTHO
#define LANG_SOTHO 0x6c
#endif
#ifndef LANG_SUTU
#define LANG_SUTU 0x30
#endif
#ifndef LANG_SWAHILI
#define LANG_SWAHILI 0x41
#endif
#ifndef LANG_SYRIAC
#define LANG_SYRIAC 0x5a
#endif
#ifndef LANG_TAGALOG
#define LANG_TAGALOG 0x64
#endif
#ifndef LANG_TAJIK
#define LANG_TAJIK 0x28
#endif
#ifndef LANG_TAMAZIGHT
#define LANG_TAMAZIGHT 0x5f
#endif
#ifndef LANG_TAMIL
#define LANG_TAMIL 0x49
#endif
#ifndef LANG_TATAR
#define LANG_TATAR 0x44
#endif
#ifndef LANG_TELUGU
#define LANG_TELUGU 0x4a
#endif
#ifndef LANG_THAI
#define LANG_THAI 0x1e
#endif
#ifndef LANG_TIBETAN
#define LANG_TIBETAN 0x51
#endif
#ifndef LANG_TIGRINYA
#define LANG_TIGRINYA 0x73
#endif
#ifndef LANG_TSONGA
#define LANG_TSONGA 0x31
#endif
#ifndef LANG_TSWANA
#define LANG_TSWANA 0x32
#endif
#ifndef LANG_TURKMEN
#define LANG_TURKMEN 0x42
#endif
#ifndef LANG_UIGHUR
#define LANG_UIGHUR 0x80
#endif
#ifndef LANG_UKRAINIAN
#define LANG_UKRAINIAN 0x22
#endif
#ifndef LANG_URDU
#define LANG_URDU 0x20
#endif
#ifndef LANG_UZBEK
#define LANG_UZBEK 0x43
#endif
#ifndef LANG_VENDA
#define LANG_VENDA 0x33
#endif
#ifndef LANG_VIETNAMESE
#define LANG_VIETNAMESE 0x2a
#endif
#ifndef LANG_WELSH
#define LANG_WELSH 0x52
#endif
#ifndef LANG_WOLOF
#define LANG_WOLOF 0x88
#endif
#ifndef LANG_XHOSA
#define LANG_XHOSA 0x34
#endif
#ifndef LANG_YAKUT
#define LANG_YAKUT 0x85
#endif
#ifndef LANG_YI
#define LANG_YI 0x78
#endif
#ifndef LANG_YIDDISH
#define LANG_YIDDISH 0x3d
#endif
#ifndef LANG_YORUBA
#define LANG_YORUBA 0x6a
#endif
#ifndef LANG_ZULU
#define LANG_ZULU 0x35
#endif
#endif

static std::string remove_codeset(std::string_view langcode)
{
    size_t pos = langcode.find('.');
    if (pos != std::string_view::npos)
        return std::string(langcode.substr(0, pos));
    else
        return std::string(langcode);
}

static std::string remove_territory(std::string_view langcode)
{
    size_t pos = langcode.find('_');
    if (pos != std::string_view::npos)
        return std::string(langcode.substr(0, pos));
    else
        return std::string(langcode);
}

/* DETERMINE CURRENT LANGUAGE */

static std::string Trans_GetUserLanguage()
{
#ifdef _WIN32
    /* Use native Windows API locale ID. */
    LCID lcid = GetThreadLocale();

    /* Strip off the sorting rules, keep only the language part. */
    LANGID langid = LANGIDFROMLCID(lcid);

    /* Dispatch on language.
       See also http://www.unicode.org/unicode/onlinedat/languages.html
       For details about languages, see http://www.ethnologue.com/ */

    /* Split into language and territory part. */
    int primary = PRIMARYLANGID(langid);
    int sub     = SUBLANGID(langid);

    // andrewj: special check for traditional Chinese characters
    if (primary == LANG_CHINESE && (sub == 0x1f || sub == SUBLANG_CHINESE_TRADITIONAL ||
                                    sub == SUBLANG_CHINESE_HONGKONG || sub == SUBLANG_CHINESE_MACAU))
    {
        return "zh_TW";
    }

    switch (primary)
    {
    case LANG_AFRIKAANS:
        return "af";
    case LANG_ALBANIAN:
        return "sq";
    case LANG_ALSATIAN:
        return "gsw";
    case LANG_AMHARIC:
        return "am";
    case LANG_ARABIC:
        return "ar";
    case LANG_ARMENIAN:
        return "hy";
    case LANG_ASSAMESE:
        return "as";
    case LANG_AZERI:
        return "az";
    case LANG_BASHKIR:
        return "ba";
    case LANG_BASQUE:
        return "eu";
    case LANG_BELARUSIAN:
        return "be";
    case LANG_BENGALI:
        return "bn";
    case LANG_BRETON:
        return "br";
    case LANG_BULGARIAN:
        return "bg";
    case LANG_BURMESE:
        return "my";
    case LANG_CAMBODIAN:
        return "km";
    case LANG_CATALAN:
        return "ca";
    case LANG_CHEROKEE:
        return "chr";
    case LANG_CHINESE:
        return "zh";
    case LANG_CORSICAN:
        return "co";
    case LANG_CROATIAN:
        return "hr";
    case LANG_CZECH:
        return "cs";
    case LANG_DANISH:
        return "da";
    case LANG_DARI:
        return "prs";
    case LANG_DIVEHI:
        return "dv";
    case LANG_DUTCH:
        return "nl";
    case LANG_EDO:
        return "bin";
    case LANG_ENGLISH:
        return "en";
    case LANG_ESTONIAN:
        return "et";
    case LANG_FAEROESE:
        return "fo";
    case LANG_FARSI:
        return "fa";
    case LANG_FINNISH:
        return "fi";
    case LANG_FRENCH:
        return "fr";
    case LANG_FRISIAN:
        return "fy";
    case LANG_FULFULDE:
        return "ff";
    case LANG_GAELIC:
        return "ga";
    case LANG_GALICIAN:
        return "gl";
    case LANG_GEORGIAN:
        return "ka";
    case LANG_GERMAN:
        return "de";
    case LANG_GREEK:
        return "el";
    case LANG_GREENLANDIC:
        return "kl";
    case LANG_GUARANI:
        return "gn";
    case LANG_GUJARATI:
        return "gu";
    case LANG_HAUSA:
        return "ha";
    case LANG_HAWAIIAN:
        return "haw";
    case LANG_HEBREW:
        return "he";
    case LANG_HINDI:
        return "hi";
    case LANG_HUNGARIAN:
        return "hu";
    case LANG_IBIBIO:
        return "nic";
    case LANG_ICELANDIC:
        return "is";
    case LANG_IGBO:
        return "ig";
    case LANG_INDONESIAN:
        return "id";
    case LANG_INUKTITUT:
        return "iu";
    case LANG_ITALIAN:
        return "it";
    case LANG_JAPANESE:
        return "ja";
    case LANG_KANNADA:
        return "kn";
    case LANG_KANURI:
        return "kr";
    case LANG_KASHMIRI:
        return "ks";
    case LANG_KAZAK:
        return "kk";
    case LANG_KICHE:
        return "qut";
    case LANG_KINYARWANDA:
        return "rw";
    case LANG_KONKANI:
        return "kok";
    case LANG_KOREAN:
        return "ko";
    case LANG_KYRGYZ:
        return "ky";
    case LANG_LAO:
        return "lo";
    case LANG_LATIN:
        return "la";
    case LANG_LATVIAN:
        return "lv";
    case LANG_LITHUANIAN:
        return "lt";
    case LANG_LUXEMBOURGISH:
        return "lb";
    case LANG_MACEDONIAN:
        return "mk";
    case LANG_MALAY:
        return "ms";
    case LANG_MALAYALAM:
        return "ml";
    case LANG_MALTESE:
        return "mt";
    case LANG_MANIPURI:
        return "mni";
    case LANG_MAORI:
        return "mi";
    case LANG_MAPUDUNGUN:
        return "arn";
    case LANG_MARATHI:
        return "mr";
    case LANG_MOHAWK:
        return "moh";
    case LANG_MONGOLIAN:
        return "mn";
    case LANG_NEPALI:
        return "ne";
    case LANG_NORWEGIAN:
        return "no";
    case LANG_OCCITAN:
        return "oc";
    case LANG_ORIYA:
        return "or";
    case LANG_OROMO:
        return "om";
    case LANG_PAPIAMENTU:
        return "pap";
    case LANG_PASHTO:
        return "ps";
    case LANG_POLISH:
        return "pl";
    case LANG_PORTUGUESE:
        return "pt";
    case LANG_PUNJABI:
        return "pa";
    case LANG_QUECHUA:
        return "qu";
    case LANG_ROMANIAN:
        return "ro";
    case LANG_ROMANSH:
        return "rm";
    case LANG_RUSSIAN:
        return "ru";
    case LANG_SAMI:
        return "se";
    case LANG_SANSKRIT:
        return "sa";
    case LANG_SCOTTISH_GAELIC:
        return "gd";
    case LANG_SINDHI:
        return "sd";
    case LANG_SINHALESE:
        return "si";
    case LANG_SLOVAK:
        return "sk";
    case LANG_SLOVENIAN:
        return "sl";
    case LANG_SOMALI:
        return "so";
    case LANG_SORBIAN:
        return "wen";
    case LANG_SOTHO:
        return "nso";
    case LANG_SPANISH:
        return "es";
    case LANG_SUTU:
        return "bnt";
    case LANG_SWAHILI:
        return "sw";
    case LANG_SWEDISH:
        return "sv";
    case LANG_SYRIAC:
        return "syr";
    case LANG_TAGALOG:
        return "tl";
    case LANG_TAJIK:
        return "tg";
    case LANG_TAMAZIGHT:
        return "ber";
    case LANG_TAMIL:
        return "ta";
    case LANG_TATAR:
        return "tt";
    case LANG_TELUGU:
        return "te";
    case LANG_THAI:
        return "th";
    case LANG_TIBETAN:
        return "bo";
    case LANG_TIGRINYA:
        return "ti";
    case LANG_TSONGA:
        return "ts";
    case LANG_TSWANA:
        return "tn";
    case LANG_TURKISH:
        return "tr";
    case LANG_TURKMEN:
        return "tk";
    case LANG_UIGHUR:
        return "ug";
    case LANG_UKRAINIAN:
        return "uk";
    case LANG_URDU:
        return "ur";
    case LANG_UZBEK:
        return "uz";
    case LANG_VENDA:
        return "ve";
    case LANG_VIETNAMESE:
        return "vi";
    case LANG_WELSH:
        return "cy";
    case LANG_WOLOF:
        return "wo";
    case LANG_XHOSA:
        return "xh";
    case LANG_YAKUT:
        return "sah";
    case LANG_YI:
        return "ii";
    case LANG_YIDDISH:
        return "yi";
    case LANG_YORUBA:
        return "yo";
    case LANG_ZULU:
        return "zu";

    default:
        return "UNKNOWN";
    }

    // #elif defined(__APPLE__)
    //
    //    return "UNKNOWN";

#else // Unix

    const char *res = NULL;

    res = setlocale(LC_ALL, NULL /* query only */);

    if (res && res[0] && res[0] != 'C')
    {
        return remove_codeset(res);
    }

    // check the LC_ALL and LANG environment variables

    res = getenv("LC_ALL");
    if (res && res[0] && res[0] != 'C')
    {
        return remove_codeset(res);
    }

    res = getenv("LANG");
    if (res && res[0] && res[0] != 'C')
    {
        return remove_codeset(res);
    }

    return "UNKNOWN";
#endif
}

//----------------------------------------------------------------------

typedef struct
{
    std::string langcode;
    std::string fullname;

} available_language_t;

static std::vector<available_language_t> available_langs;

void Trans_ParseLangLine(char *line)
{
    char *pos;

    // skip any BOM (can occur at very start of file)
    if ((uint8_t)(line[0]) == 0xEF && (uint8_t)(line[1]) == 0xBB && (uint8_t)(line[2]) == 0xBF)
    {
        line += 3;
    }

    // remove CR/LF line ending
    pos = (char *)strchr(line, '\r');
    if (pos)
    {
        pos[0] = 0;
    }

    pos = (char *)strchr(line, '\n');
    if (pos)
    {
        pos[0] = 0;
    }

    // ignore blank lines and comments
    if (line[0] == 0 || line[0] == '#')
    {
        return;
    }

    // find separator
    pos = (char *)strchr(line, '=');

    if (!pos)
    {
        return; // uh oh
    }

    *pos++ = 0;

    if (strlen(line) < 2 || strlen(pos) < 2)
    {
        return; // uh oh
    }

    // Ok, add the language

    available_language_t lang;

    lang.langcode = line;
    lang.fullname = pos;

    available_langs.push_back(lang);
}

void Trans_AddMessage(const char *before, const char *after)
{
    // an empty before string has special meaning in a PO file,
    // providing a bunch of meta-information (which we ignore).

    if (before[0] == 0)
    {
        return;
    }

    // an empty after string means the translator has not yet
    // provided a translation.  hence we ignore that too.

    if (after[0] == 0)
    {
        return;
    }

    trans_store[before] = std::string(after);
}

struct po_parse_state_t
{
    char id[MAX_TRANS_STRING];
    char str[MAX_TRANS_STRING];
    char ctx[256];

    bool has_id;
    bool has_str;
    bool has_ctx;

    int line_number;

    void Clear()
    {
        id[0]   = 0;
        has_id  = false;
        str[0]  = 0;
        has_str = false;
        ctx[0]  = 0;
        has_ctx = false;
    }

    // store the message pair if valid
    void Push()
    {
        if (has_id && has_str)
        {
            Trans_AddMessage(id, str);
            Clear();
        }
    }

    void ParseString(const char *p, char *dest, size_t dest_size)
    {
        size_t d_len = strlen(dest);

        char *dest_end = dest + (dest_size - d_len - 4 /* space for NUL */);

        dest = dest + d_len;

        while (*p && IsSpaceASCII(*p))
        {
            p++;
        }

        if (*p++ != '"')
        {
            LogPrint("WARNING: missing string on line %d\n", line_number);
            return;
        }

        while (*p != '"')
        {
            if (*p == 0)
            {
                LogPrint("WARNING: unterminated string on line %d\n", line_number);
                break;
            }

            if (dest >= dest_end)
            {
                LogPrint("WARNING: string too long on line %d\n", line_number);
                break;
            }

            if (*p != '\\')
            {
                *dest++ = *p++;
                continue;
            }

            // handle escape sequences
            p++;

            if (*p == 0)
            {
                LogPrint("WARNING: unterminated string on line %d\n", line_number);
                break;
            }

            switch (*p++)
            {
            case '\\':
                *dest++ = '\\';
                break;
            case '"':
                *dest++ = '"';
                break;

            case 'n':
                *dest++ = '\n';
                break;
            case 'r':
                *dest++ = '\r';
                break;
            case 't':
                *dest++ = '\t';
                break;

            case 'a':
                *dest++ = '\a';
                break;
            case 'b':
                *dest++ = '\b';
                break;
            case 'f':
                *dest++ = '\f';
                break;
            case 'v':
                *dest++ = '\v';
                break;

            default:
                LogPrint("WARNING: strange escape sequence on line %d\n", line_number);
                break;
            }
        }

        // terminate the string buffer
        *dest = 0;
    }

    void Append(const char *p)
    {
        if (has_str)
        {
            ParseString(p, str, sizeof(str));
        }
        else if (has_id)
        {
            ParseString(p, id, sizeof(id));
        }
    }

    void SetContext(const char *p)
    {
        ctx[0] = 0;
        ParseString(p, ctx, sizeof(ctx));
        has_ctx = true;
    }

    void SetId(const char *p)
    {
        id[0] = 0;
        ParseString(p, id, sizeof(id));
        has_id = true;
    }

    void SetString(const char *p)
    {
        str[0] = 0;
        ParseString(p, str, sizeof(str));
        has_str = true;
    }
};

void Trans_Read_PO_File(FILE *fp)
{
    // the currently read message (not yet added)
    static po_parse_state_t po_state;

    // initialize
    po_state.Clear();

    po_state.line_number = 0;

    std::string buffer;
    int         c = EOF;
    for (;;)
    {
        buffer.clear();
        while ((c = fgetc(fp)) != EOF)
        {
            if (c == '\n' || c == '\r')
                break;
            else
                buffer.push_back(c);
        }

        po_state.line_number += 1;

        char *p = buffer.data();

        // skip any BOM (can occur at very start of file)
        if ((uint8_t)(p[0]) == 0xEF && (uint8_t)(p[1]) == 0xBB && (uint8_t)(p[2]) == 0xBF)
        {
            p += 3;
        }

        // NOTE: I assume whitespace at start of line is not valid

        if (IsSpaceASCII(*p) || *p == '#')
        {
            continue;
        }

        // extension string?
        if (*p == '"')
        {
            po_state.Append(p);
            continue;
        }

        // if we have a pending translation, add it now
        po_state.Push();

        if (StringPrefixCompare(p, "msgctxt ") == 0)
        {
            po_state.SetContext(p + 8);
        }
        else if (StringPrefixCompare(p, "msgid ") == 0)
        {
            po_state.SetId(p + 6);
        }
        else if (StringPrefixCompare(p, "msgstr ") == 0)
        {
            po_state.SetString(p + 7);
        }

        if (feof(fp) || ferror(fp))
            break;
    }

    // all done, add the final pending translation

    po_state.Push();
}

void Trans_Init()
{
#ifndef _WIN32
    if (!setlocale(LC_ALL, ""))
    {
        LogPrint("WARNING : failed to initialize locale (check localdef)\n\n");
    }
#endif

    /* read the list of languages */

    std::string path = PathAppend(install_dir, "language/LANGS.txt");

    if (!FileExists(path))
    {
        LogPrint("WARNING: missing language/LANGS.txt file\n");
        return;
    }

    FILE *trans_fp = FileOpen(path, "rb");

    if (!trans_fp)
    {
        LogPrint("WARNING: Error opening LANGS.txt!\n");
        return;
    }

    LogPrint("Loading language list: %s\n", path.c_str());

    std::string buffer;
    int         c = EOF;
    for (;;)
    {
        buffer.clear();

        while ((c = fgetc(trans_fp)) != EOF)
        {
            if (c == '\n' || c == '\r')
                break;
            else
                buffer.push_back(c);
        }

        Trans_ParseLangLine((char *)buffer.c_str());

        if (feof(trans_fp) || ferror(trans_fp))
            break;
    }

    fclose(trans_fp);

    LogPrint("DONE.\n\n");
}

void Trans_SetLanguage()
{
    // this is called *once*, after user options are read

    std::string langcode = t_language;

    if (langcode.empty() || langcode == "AUTO")
    {
        langcode = Trans_GetUserLanguage();

        LogPrint("Detected user language: '%s'\n", langcode.c_str());
    }

    std::string lang_plain = remove_territory(langcode);

    // English is the default language, nothing else needed

    if (lang_plain == "UNKNOWN" || lang_plain == "en")
    {
        LogPrint("Using the default language (English)\n\n");
        selected_lang = "en";
        return;
    }

    // see if the translation file exists
    std::string path = StringFormat("%s/language/%s.po", install_dir.c_str(), langcode.c_str());

    if (!FileExists(path))
    {
        // if language has a territory field (like zh_TW or en_AU) then
        // try again with the plain language code.
        path = StringFormat("%s/language/%s.po", install_dir.c_str(), lang_plain.c_str());
    }

    FILE *fp = FileOpen(path, "rb");
    if (!fp)
    {
        LogPrint("No translation file: language/%s.po\n", lang_plain.c_str());
        LogPrint("Using the default language (English)\n\n");
        selected_lang = "en";
        return;
    }

    selected_lang = lang_plain;

    LogPrint("Loading translation: %s\n", path.c_str());

    Trans_Read_PO_File(fp);

    fclose(fp);

    LogPrint("DONE.\n\n");
}

std::string Trans_GetAvailCode(int idx)
{
    SYS_ASSERT(idx >= 0);

    // end of list?
    if (idx >= (int)available_langs.size())
    {
        return "";
    }

    return available_langs[idx].langcode;
}

std::string Trans_GetAvailLanguage(int idx)
{
    SYS_ASSERT(idx >= 0);

    // end of list?
    if (idx >= (int)available_langs.size())
    {
        return "";
    }

    return available_langs[idx].fullname;
}

void Trans_UnInit()
{
    trans_store.clear();
}

//----------------------------------------------------------------------

const char *ob_gettext(const char *s)
{
    trans_iter = trans_store.find(s);

    if (trans_iter != trans_store.end())
    {
        return trans_iter->second.c_str();
    }

    return s;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
