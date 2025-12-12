# Secure HTML Sanitization Engine

## 1. Motivation and Goals
Rendering HTML from untrusted sources (emails, rich text editors, integrations, external systems, etc.) is inherently dangerous. Raw HTML can be weaponized to:
- Execute arbitrary JavaScript (XSS)
- Exfiltrate sensitive data
- Spoof UI to steal user credentials (phishing)
- Inject invisible overlays and hijack input
- Break the layout of the application

The legacy sanitizer from `dart-neats` bundled validation logic into a single monolithic class and was harder to extend, test, and reason about.

This PR introduces a **modular, secure, email-optimized HTML sanitization pipeline** with:
- Strong XSS protection  
- Email-specific URL and image rules  
- Safe CSS filtering  
- Clear three-tier tag classification  
- Configurable but security-validated overrides  
- Better structure for maintainability and testing  

---

## 2. High-Level Architecture

The sanitizer is split into independent modules:

### **SaneHtmlValidator**
Public façade that receives HTML and returns sanitized output. Performs:
- Input parsing  
- Override validation  
- Delegation to NodeSanitizer  

### **NodeSanitizer**
Core DOM walker implementing:
- Tag classification (allowed, forbidden, disallowed/unwrap)
- Attribute sanitization
- Inline and block CSS sanitization
- Per-tag validation logic
- Safe ID/class rules

### **HtmlSanitizeConfig**
Centralized policy storage:
- Allowed tags
- Forbidden tags
- Always-allowed attributes
- Forbidden attributes
- Allowed CSS properties
- Forbidden CSS tokens
- Safe ID/class patterns
- URL/image validation patterns

### **AttributePolicy**
Maps element types to attribute validation:
- `<a href>` URL validation  
- `<img src>` base64 / CID / http rules  
- Microdata attributes  
- Link rel augmentation hooks  

### **CssSanitizer**
Responsible for:
- Sanitizing inline style declarations  
- Sanitizing `<style>` blocks  
- Removing unsupported or dangerous rules  
- Rejecting `expression`, unsafe `url()` (javascript:, protocol-relative), and dangerous CSS tokens

### **UrlValidators**
Provides XSS-safe URL and image validation:
- `validLink()` for `<a>`  
- `validUrl()` for general attributes  
- `validImageSource()` for images  
- Strict base64 image regex  
- CID email inline-image support  

---

## 3. Before / After Comparison

| Category | Old Sanitizer | New Sanitizer |
|---------|----------------|----------------|
| Architecture | Monolithic, coupled | Modular, extensible |
| CSS Handling | Removed style entirely | Fine-grained CSS filtering (inline + `<style>`) |
| URL Validation | Basic | Strict scheme validation + base64 + CID |
| Tag Handling | Minimal allowlist | Full allowlist + forbidlist + unwrap logic |
| Attribute Filtering | Basic | Comprehensive forbidden attributes |
| Overrides | Unsafe, permissive | Strict validation, fail-fast |
| Testing | Limited | Full coverage for tags, attributes, CSS, overrides |
| Security Level | Medium | Inspired by DOMPurify's email-safe approach |

---

## 4. Three-Tier Tag Classification

### **Tier 1 — Allowed Tags**
Known-safe and widely used in email HTML.

Examples:  
`<p>`, `<div>`, `<span>`, `<strong>`, `<table>`, `<tr>`, `<td>`, `<ul>`, `<li>`, `<img>`, `<a>`

**Behavior:**  
- Keep tag  
- Sanitize attributes  
- Recursively sanitize children  

### **Tier 2 — Forbidden Tags**
Inherently unsafe.

Examples:  
`<script>`, `<iframe>`, `<object>`, `<embed>`, `<applet>`,  
Form controls: `<input>`, `<button>`, `<textarea>`, `<select>`, `<option>`

**Behavior:**  
- Remove tag + contents  

### **Tier 3 — Disallowed / Unknown Tags**
Not explicitly safe or forbidden.

Examples:  
`<form>`, `<custom-widget>`, `<unknown>`

**Behavior:**  
- Unwrap tag, keep sanitized children  

---

## 5. Threats Addressed

- JavaScript execution  
- Inline-event XSS  
- Script injection via URLs  
- CSS-based clickjacking  
- Overlay phishing attacks  
- Invisible or auto-submitting forms  
- Remote asset tracking  
- Malicious `<style>` blocks  
- DOM injection via unknown tags  

### Defense in Depth
This sanitizer provides robust HTML sanitization but should be deployed as part of a defense-in-depth strategy:
- When rendering in iframes/webviews, use platform sandboxing attributes
- Apply Content Security Policy (CSP) headers where applicable
- Use platform-specific security primitives available in your rendering context
- Disable JavaScript execution in rendering contexts when possible

---

## 6. Attribute Sanitization

### **6.1 Forbidden Attributes**
Always removed:
- All event handlers (`onclick`, `onload`, …)  
- Form submission attributes (`action`, `method`, …)  
- Dangerous iframe attributes (`srcdoc`)  
- Clipboard/keyboard/drag events  

### **6.2 Always Allowed Attributes**
Structural or semantic:
- `title`, `lang`, `dir`  
- `width`, `height`  
- `common ARIA attributes (aria-describedby, aria-hidden, …`  
- `data-filename`, `public-asset-id`  

### **6.3 Per-Tag Validators**

#### **Links (`<a href>`)**
Allowed schemes:
- `http`, `https`, `mailto`, or no scheme  

Reject:
- `javascript:`, `data:`, `vbscript:`  

#### **Images (`<img src>`)**
Allowed:
- Valid http/https  
- Strict base64 (Only allow `data:image/(png|jpeg|jpg|gif|bmp);base64,...` and rejected `data:image/svg+xml;base64,...` )
- CID images (email standard)  

### **6.4 Safe ID & Class Names**
Pattern:
```regex
^[A-Za-z][A-Za-z0-9\-_:.]{0,63}$
```

Rationale:
- Avoid CSS collisions  
- Predictable styling  
- UI safety  

---

## 7. CSS Sanitization

### **Inline Styles**
Process:
1. Split declarations  
2. Allow only safe CSS properties  
3. Reject unsafe values  
4. Rebuild sanitized style  

If no valid styles remain → drop attribute.

### **Why `position` Is Removed**
`position` enables:
- Full-screen overlays  
- Fake login screens  
- Clickjacking overlays  
- Spoofed system dialogs  

Gmail, Outlook, and ProtonMail disallow `position`.  
Email layouts do not rely on it (they rely on `<table>`).

---

### **Stylesheets (`<style>`)**
- Strip comments  
- Remove at-rules  
- Sanitize declarations  
- Drop empty `<style>` blocks  

---

## 8. NodeSanitizer Algorithm

1. Remove comments  
2. For each node:  
   - Forbidden → remove  
   - `<style>` → sanitize block  
   - Allowed → sanitize attributes  
   - Unknown → unwrap  
3. Attribute sanitization  
4. CSS sanitization  
5. Merge rel rules on `<a>`  
6. Recursively sanitize children  

---

## 9. URL and Image Validation

### **validLink()**
Allows: http, https, mailto  
Rejects: javascript, data, vbscript

### **validImageSource()**
Allows: http/https, base64, cid  
Protects from:
- JS payload images  
- Tracking via custom schemes  

---

## 10. Security Summary

### **XSS Protection**
- No scripts  
- No inline JS  
- No dangerous URLs  
- No unsafe CSS  

### **Phishing Protection**
- Blocks fake overlays  
- Prevents auto-submission  
- Neutralizes UI spoofing  

### **Layout Stability**
- Unknown tags unwrapped  
- Predictable styling  

### **Override Safety**
- Cannot re-enable forbidden tags  
- Cannot whitelist dangerous attributes  
- Fail-fast invalid configs  

---

## 11. Testing Strategy

### **Unit Tests Cover:**
- Tag allowlist / forbidlist  
- Attribute removal logic  
- CSS inline & block sanitization  
- URL and image rules  
- Unknown tag unwrapping  
- Override validation (success + failure)  
- End-to-end HTML sanitization  

### **Security Regression Tests**
- Forbidden tags always removed  
- Dangerous attributes always stripped  
- `javascript:` URLs always rejected  
- `position` and unsafe CSS removed  
- Empty `<style>` removed  

---

## 12. Class Name Restrictions

Although CSS allows `_class`, `-class`, etc., sanitizer restricts class names to:

```regex
^[A-Za-z][A-Za-z0-9\-_:.]{0,63}$
```

Reasons:
- Prevent CSS collisions  
- Keep layout deterministic  
- Avoid framework-specific class injection  

---

## 13. Performance Considerations

- Single traversal → O(N) complexity  
- Lightweight CSS parsing  
- No external dependencies  
- Safe for large email bodies (up to hundreds of KB)  
- Deterministic execution  

---

## 14. Recommended Usage

```dart
final validator = SaneHtmlValidator(
  allowElementId: null,
  allowClassName: null,
  addLinkRel: (href) => ['noopener', 'noreferrer', 'nofollow'],
  allowAttributes: null,
  allowTags: null,
);

final safeHtml = validator.sanitize(untrustedHtml);
```

---

## 15. Conclusion

The updated sanitizer provides:
- Modern modular architecture  
- Industrial-grade XSS & phishing defense  
- DOMPurify-level safety tailored for email  
- Predictable, stable rendering  
- Comprehensive test coverage  
- Strict override validation  

This results in a **robust, secure, and maintainable HTML sanitization pipeline** suitable for any application rendering untrusted HTML.

