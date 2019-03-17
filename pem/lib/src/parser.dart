// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:petitparser/petitparser.dart';
import 'helpers.dart';

// https://tools.ietf.org/html/rfc5234#appendix-B.1
final _ht = char('\x09'); // horizontal tab
final _cr = char('\x0d'); // carrige return
final _lf = char('\x0a'); // line feed
final _sp = char('\x20'); // whitespace
final _wsp = (_sp | _ht).cast<String>();

// https://tools.ietf.org/html/rfc7468#section-3
// preeb      = "-----BEGIN " label "-----" ; unlike [RFC1421] (A)BNF,
//                                          ; eol is not required (but
// posteb     = "-----END " label "-----"   ; see [RFC1421], Section 4.4)
// label      = [ labelchar *( ["-" / SP] labelchar ) ]       ; empty ok
// labelchar  = %x21-2C / %x2E-7E    ; any printable character,
//                                   ; except hyphen-minus
// base64char = ALPHA / DIGIT / "+" / "/"
// base64pad  = "="
// eol        = CRLF / CR / LF
final _preeb = (string('-----BEGIN ') & _label & string('-----')).pick(1);
final _posteb = (string('-----END ') & _label & string('-----')).pick(1);
final _label = (_labelchar & ((char('-') | _sp).optional() & _labelchar).star())
    .flatten()
    .optional();
final _labelchar = pattern('\x21-\x2c\x2e-\x7e');
final _base64char = pattern('a-zA-Z0-9+/');
final _base64pad = char('=');
final _eol = ignore((_cr & _lf) | _cr | _lf);

// https://tools.ietf.org/html/rfc7468#section-3
// W                = WSP / CR / LF / %x0B / %x0C           ; whitespace
final _vt = char('\x0b'); // vertical tab
final _ff = char('\x0c'); // form feed (new page)
final _w = ignore(_wsp | _cr | _lf | _vt | _ff);

// https://tools.ietf.org/html/rfc7468#section-3
// laxbase64text    = *(W / base64char) [base64pad *W [base64pad *W]]
// laxtextualmsg    = *W preeb
//                    laxbase64text
//                    posteb *W
final _laxbase64text = flatten(((_w | _base64char).plus() &
    (_base64pad & _w.star() & (_base64pad & _w.star()).optional()).optional()));
final laxtextualmsg =
    (_w.star() & _preeb & _laxbase64text & _posteb & _w.star())
        .permute([1, 2, 3]);

// https://tools.ietf.org/html/rfc7468#section-3
// base64fullline   = 64base64char eol
// strictbase64finl = *15(4base64char) (4base64char / 3base64char
//                      base64pad / 2base64char 2base64pad) eol
// strictbase64text = *base64fullline strictbase64finl
// stricttextualmsg = preeb eol
//                    strictbase64text
//                    posteb eol
final _base64fullline = _base64char.repeat(4).repeat(16) & _eol;
final _strictbase64finl = (_base64fullline |
    _base64char.repeat(4).repeat(1, 15) &
        ((_base64char.repeat(3) & _base64pad & _eol) |
            (_base64char.repeat(2) & _base64pad.repeat(2) & _eol) |
            _eol) |
    (_base64char.repeat(3) & _base64pad & _eol) |
    (_base64char.repeat(2) & _base64pad.repeat(2) & _eol));
final _strictbase64text =
    flatten((_base64fullline.plus() & _strictbase64finl) | _strictbase64finl);
final stricttextualmsg =
    (_preeb & _eol & _strictbase64text & _posteb & _eol).permute([0, 2, 3]);
