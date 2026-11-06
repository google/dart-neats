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

/// The `rel` link types `AttributeRule.rel` and the default rule sets keep.
library;

/// The [link types][1] defined for `<a>` and `<area>`, plus `ugc` and
/// `sponsored` (registered extensions search engines act on), without
/// `opener`, which re-enables `window.opener` for `target="_blank"` links.
///
/// [1]: https://html.spec.whatwg.org/multipage/links.html#linkTypes
const anchorLinkTypes = <String>{
  'alternate',
  'author',
  'bookmark',
  'external',
  'help',
  'license',
  'me',
  'next',
  'nofollow',
  'noopener',
  'noreferrer',
  'prev',
  'privacy-policy',
  'search',
  'sponsored',
  'tag',
  'terms-of-service',
  'ugc',
};

/// The link types that describe the link itself.
///
/// The rest of [anchorLinkTypes] make a statement about the document the
/// link is in — `me` verifies the host's URL as the author's identity on
/// Mastodon and IndieAuth, `license`, `privacy-policy`, `terms-of-service`,
/// `alternate`, `author`, `tag` and `bookmark` describe it, `next`, `prev`
/// and `search` navigate it — which embedded Markdown has no business doing.
const linkDescribingTypes = <String>{
  'external',
  'help',
  'nofollow',
  'noopener',
  'noreferrer',
  'sponsored',
  'ugc',
};
