class HtmlSanitizeConfig {
  //
  // ALLOWED ELEMENTS
  //
  static const Set<String> allowedElements = {
    ..._allowedElementsBase,
    ..._allowedSvgElements,
  };

  // Base HTML elements
  static const Set<String> _allowedElementsBase = {
    'H1',
    'H2',
    'H3',
    'H4',
    'H5',
    'H6',
    'H7',
    'H8',
    'BR',
    'B',
    'I',
    'STRONG',
    'EM',
    'A',
    'PRE',
    'CODE',
    'IMG',
    'TT',
    'DIV',
    'INS',
    'DEL',
    'SUP',
    'SUB',
    'P',
    'OL',
    'UL',
    'TABLE',
    'THEAD',
    'TBODY',
    'TFOOT',
    'BLOCKQUOTE',
    'DL',
    'DT',
    'DD',
    'KBD',
    'Q',
    'SAMP',
    'VAR',
    'HR',
    'RUBY',
    'RT',
    'RP',
    'LI',
    'TR',
    'TD',
    'TH',
    'S',
    'STRIKE',
    'SUMMARY',
    'DETAILS',
    'CAPTION',
    'FIGURE',
    'FIGCAPTION',
    'ABBR',
    'BDO',
    'CITE',
    'DFN',
    'MARK',
    'SMALL',
    'SPAN',
    'TIME',
    'WBR',
    'FONT',
    'U',
    'CENTER',
    'SECTION',
    'COLGROUP',
    'COL',
    'NAV',
    'MAIN',
    'FOOTER',
    'STYLE',
  };

  // SVG elements
  static const Set<String> _allowedSvgElements = {
    'SVG',
    'G',
    'PATH',
    'POLYGON',
    'RECT',
    'CIRCLE',
    'ELLIPSE',
    'LINE',
    'POLYLINE',
    'TEXT',
  };

  //
  // ALWAYS ALLOWED ATTRIBUTES
  //
  static const Set<String> alwaysAllowedAttributes = {
    ..._alwaysAllowedAttributesBase,
  };

  static const Set<String> _alwaysAllowedAttributesBase = {
    'abbr',
    'accept',
    'accesskey',
    'align',
    'alt',
    'aria-describedby',
    'aria-hidden',
    'aria-label',
    'aria-labelledby',
    'axis',
    'border',
    'cellpadding',
    'cellspacing',
    'char',
    'charoff',
    'checked',
    'clear',
    'cols',
    'colspan',
    'color',
    'compact',
    'coords',
    'datetime',
    'dir',
    'disabled',
    'for',
    'frame',
    'headers',
    'height',
    'hreflang',
    'hspace',
    'ismap',
    'label',
    'lang',
    'maxlength',
    'media',
    'multiple',
    'name',
    'nohref',
    'noshade',
    'nowrap',
    'open',
    'prompt',
    'readonly',
    'rel',
    'rev',
    'rows',
    'rowspan',
    'rules',
    'scope',
    'selected',
    'shape',
    'size',
    'span',
    'start',
    'summary',
    'tabindex',
    'title',
    'type',
    'usemap',
    'valign',
    'value',
    'vspace',
    'width',
    'itemprop',
    'style',
    'bgcolor',
    'data-filename',
    'public-asset-id',
    'data-mimetype',
  };

  //
  // FORBIDDEN TAGS
  //
  static const Set<String> forbiddenTags = {
    ..._forbiddenTagsBase,
    ..._forbiddenSvgAnimationTags,
  };

  static const Set<String> _forbiddenTagsBase = {
    'SCRIPT',
    'IFRAME',
    'OBJECT',
    'EMBED',
    'APPLET',
    'INPUT',
    'BUTTON',
    'TEXTAREA',
    'SELECT',
    'OPTION',
  };

  static const Set<String> _forbiddenSvgAnimationTags = {
    'ANIMATE',
    'SET',
    'ANIMATEMOTION',
    'ANIMATETRANSFORM',
    'MPATH',
  };

  static const Set<String> forbiddenSvgAnimationAttributes = {
    'to',
    'from',
    'by',
    'values',
    'dur',
    'begin',
    'repeatcount',
    'repeatdur',
  };

  //
  // FORBIDDEN ATTRIBUTES
  //
  static const Set<String> forbiddenAttributes = {
    ..._forbiddenEventHandlers,
    ..._forbiddenFormAttributes,
  };

  static const Set<String> _forbiddenEventHandlers = {
    'onclick',
    'ondblclick',
    'onmousedown',
    'onmouseup',
    'onmouseover',
    'onmouseenter',
    'onmouseleave',
    'onmousemove',
    'onmouseout',
    'onkeydown',
    'onkeypress',
    'onkeyup',
    'onfocus',
    'onblur',
    'onfocusin',
    'onfocusout',
    'onchange',
    'oninput',
    'onsubmit',
    'onreset',
    'oninvalid',
    'oncopy',
    'oncut',
    'onpaste',
    'ondrag',
    'ondragstart',
    'ondragend',
    'ondrop',
    'ondragover',
    'ondragenter',
    'ondragleave',
    'ontouchstart',
    'ontouchmove',
    'ontouchend',
    'ontouchcancel',
    'onabort',
    'oncanplay',
    'oncanplaythrough',
    'oncuechange',
    'ondurationchange',
    'onemptied',
    'onended',
    'onerror',
    'onloadeddata',
    'onloadedmetadata',
    'onloadstart',
    'onpause',
    'onplay',
    'onplaying',
    'onprogress',
    'onratechange',
    'onseeked',
    'onseeking',
    'onstalled',
    'onsuspend',
    'ontimeupdate',
    'onvolumechange',
    'onwaiting',
    'onload',
    'onbeforeunload',
    'onafterprint',
    'onbeforeprint',
    'onresize',
    'onscroll',
    'onselect',
    'onselectstart',
  };

  static const Set<String> _forbiddenFormAttributes = {
    'action',
    'formaction',
    'method',
    'formmethod',
    'target',
    'formtarget',
    'enctype',
    'formenctype',
    'accept-charset',
    'autocomplete',
    'novalidate',
    'srcdoc',
  };

  //
  // CSS RULES
  //
  static const Set<String> allowedCssProperties = {
    'color',
    'background-color',
    'font-family',
    'font-size',
    'font-weight',
    'font-style',
    'font-variant',
    'font-stretch',
    'line-height',
    'text-align',
    'text-decoration',
    'text-transform',
    'text-indent',
    'letter-spacing',
    'white-space',
    'word-wrap',
    'word-break',
    'overflow-wrap',
    'text-overflow',
    'vertical-align',
    'direction',
    'unicode-bidi',
    'margin',
    'margin-left',
    'margin-right',
    'margin-top',
    'margin-bottom',
    'padding',
    'padding-left',
    'padding-right',
    'padding-top',
    'padding-bottom',
    'border',
    'border-style',
    'border-color',
    'border-width',
    'border-top',
    'border-right',
    'border-bottom',
    'border-left',
    'border-radius',
    'border-collapse',
    'border-spacing',
    'display',
    'width',
    'min-width',
    'max-width',
    'height',
    'min-height',
    'max-height',
    'box-sizing',
    'table-layout',
    'caption-side',
    'empty-cells',
    'list-style',
    'list-style-type',
    'list-style-position',
    'fill',
    'stroke',
    'stroke-width',
  };

  //
  // JS SIGNATURES
  //
  static const List<String> forbiddenCss = [
    'expression(',
    'javascript:',
    'vbscript:',
    'url(',
  ];

  //
  // REGEX
  //
  static final RegExp safeIdPattern =
      RegExp(r'^[A-Za-z][A-Za-z0-9\-\_\:\.]{0,63}$');

  static final RegExp safeClassPattern =
      RegExp(r'^[A-Za-z][A-Za-z0-9\-\_]{0,63}$');

  static final RegExp cssCommentPattern = RegExp(r'/\*.*?\*/', dotAll: true);

  static final RegExp unicodeEscapeReg =
      RegExp(r'\\[0-9a-f]{2}', caseSensitive: false);

  static final RegExp unitlessNumberPattern = RegExp(r'^\d+$');

  static final RegExp base64ImageRegex = RegExp(
    r'^data:image\/(png|jpeg|jpg|gif|bmp|svg\+xml);base64,[A-Za-z0-9+/]+={0,2}$',
  );

  static final RegExp whitespacePattern = RegExp(r'\s+');

  static final RegExp base64ValuePattern = RegExp(r'^[A-Za-z0-9+/=]+$');

  static final RegExp dangerousMarkupRegex = RegExp(
    r'(<script|</script|<!\[CDATA\[)',
    caseSensitive: false,
  );
}
