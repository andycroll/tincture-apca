# frozen_string_literal: true

require 'tincture'
require_relative 'apca/version'

module Tincture # :nodoc:
  # [APCA](https://git.apcacontrast.com/) lightness contrast (Lc), the
  # perceptual contrast method drafted for WCAG 3. Requiring
  # `tincture/apca` adds ColorMethods#apca_contrast to Tincture::Color and
  # `method: :apca` to Tincture::Color#contrast_color.
  #
  # A port of [apca-w3](https://github.com/Myndex/apca-w3) 0.1.9: base
  # algorithm 0.0.98G-4g with its approved constants.
  #
  # **Licence restriction.** APCA is copyright © 2019–2023 Andrew Somers and
  # Myndex Research, patent pending. Its licence allows use only for web
  # content, in support of the WCAG accessibility guidelines. Other uses,
  # such as print or PDF, fall under AGPL v3. A commercial product that uses
  # it must give Myndex free access to audit the code on request. The
  # algorithm and constants must not change, except to port them, and must
  # be kept current. See the
  # [licence](https://github.com/Myndex/apca-w3/blob/master/LICENSE.md).
  module Apca
    # Names match apca-w3's SA98G, so each value can be checked against it.
    SA98G = {
      mainTRC: 2.4,
      sRco: 0.2126729,
      sGco: 0.7151522,
      sBco: 0.0721750,
      normBG: 0.56,
      normTXT: 0.57,
      revTXT: 0.62,
      revBG: 0.65,
      blkThrs: 0.022,
      blkClmp: 1.414,
      scaleBoW: 1.14,
      scaleWoB: 1.14,
      loBoWoffset: 0.027,
      loWoBoffset: 0.027,
      deltaYmin: 0.0005,
      loClip: 0.1
    }.freeze

    module_function

    # Lc for text on a background, from their #luminance values. Positive for
    # dark text on light, negative for light text on dark, up to about ±108.
    # For body text, Lc 75 is the minimum and Lc 90 preferred.
    #
    #: (Float text_y, Float background_y) -> Float
    def contrast(text_y, background_y)
      text_y, background_y = [text_y, background_y].map { soft_clamped(it) }

      lc =
        if (background_y - text_y).abs < SA98G[:deltaYmin] then 0.0
        elsif background_y > text_y then dark_on_light(text_y, background_y)
        else light_on_dark(text_y, background_y)
        end

      lc * 100
    end

    # APCA's screen luminance (Y) for 0–255 sRGB channels. Not the same as
    # WCAG 2 relative luminance.
    #
    #: ([Integer, Integer, Integer] rgb) -> Float
    def luminance((red, green, blue))
      (SA98G[:sRco] * linear(red)) + (SA98G[:sGco] * linear(green)) + (SA98G[:sBco] * linear(blue))
    end

    def linear(channel) = (channel / 255.0)**SA98G[:mainTRC] # :nodoc:

    def soft_clamped(luminance) # :nodoc:
      luminance > SA98G[:blkThrs] ? luminance : luminance + ((SA98G[:blkThrs] - luminance)**SA98G[:blkClmp])
    end

    def dark_on_light(text_y, background_y) # :nodoc:
      sapc = ((background_y**SA98G[:normBG]) - (text_y**SA98G[:normTXT])) * SA98G[:scaleBoW]
      sapc < SA98G[:loClip] ? 0.0 : sapc - SA98G[:loBoWoffset]
    end

    def light_on_dark(text_y, background_y) # :nodoc:
      sapc = ((background_y**SA98G[:revBG]) - (text_y**SA98G[:revTXT])) * SA98G[:scaleWoB]
      sapc > -SA98G[:loClip] ? 0.0 : sapc + SA98G[:loWoBoffset]
    end

    private_class_method :linear, :soft_clamped, :dark_on_light, :light_on_dark

    # Added to Tincture::Color.
    module ColorMethods
      # APCA lightness contrast (Lc) of this colour as text on `background`.
      # Positive for dark text on light, negative for light on dark.
      # Translucent text is blended onto the background first.
      #
      # **Licence restriction:** web content only, in support of WCAG. See
      # Apca.
      #
      #     Tincture::Color.parse("#888").apca_contrast("#fff") # => 63.06…
      #
      #: (String | Color background) -> Float
      def apca_contrast(background)
        background = Color.parse(background)
        text = opaque? ? self : blended_over(background)

        Apca.contrast(Apca.luminance(text.rgb), Apca.luminance(background.rgb))
      end

      private

      def blended_over(background)
        Color.rgb(*rgb.zip(background.rgb).map { |mine, theirs| (theirs * (1 - alpha)) + (mine * alpha) })
      end
    end
  end

  Color.include(Apca::ColorMethods)
  Color.contrast_scorers[:apca] = ->(text, background) { text.apca_contrast(background).abs }
end
