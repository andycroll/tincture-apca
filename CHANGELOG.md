# Changelog

## Unreleased

- Performance: `apca_contrast` is about 30% faster and `Apca.luminance` about 2.5 times faster. Luminance looks up each channel's linear value in a table and no longer computes a power. Results are unchanged.
- Performance: `Apca.contrast` is about 25% faster. It no longer builds an array to soft-clamp its two luminances.

## 1.0.0 (2026-10-21)

- `apca_contrast` and `contrast_color(method: :apca)` for `Tincture::Color`, ported from apca-w3 0.1.9.
