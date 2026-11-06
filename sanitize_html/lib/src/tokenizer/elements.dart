// Copyright 2026 Google LLC
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

/// Element names that change how the tokenizers treat content.
library;

/// Elements that switch the tokenizer into [foreign content][1], where `/>`
/// on the element itself closes it.
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#parsing-main-inforeign
const foreignContentElements = <String>{'math', 'svg'};

/// [RAWTEXT][1] and [RCDATA][2] elements, plus `template`, whose content
/// is never reported as text: the browser never renders it as markup, and
/// `template` content is an inert fragment. `script` and `plaintext` are
/// handled separately by each tokenizer.
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#rawtext-state
/// [2]: https://html.spec.whatwg.org/multipage/parsing.html#rcdata-state
const rawTextElements = <String>{
  'iframe',
  'noembed',
  'noframes',
  'noscript',
  'style',
  'template',
  'textarea',
  'title',
  'xmp',
};

/// Every element whose content is not text: [rawTextElements], `script`
/// and `plaintext`.
const contentlessElements = <String>{...rawTextElements, 'script', 'plaintext'};
