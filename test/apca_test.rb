# frozen_string_literal: true

require 'test_helper'

class ColorApcaTest < Minitest::Test
  # apca-w3 0.1.9's own test vectors: text, background, Lc.
  VECTORS = [
    ['#888', '#fff', 63.056469930209424],
    ['#fff', '#888', -68.54146436644962],
    ['#000', '#aaa', 58.146262578561334],
    ['#aaa', '#000', -56.24113336839742],
    ['#123', '#def', 91.66830811481631],
    ['#def', '#123', -93.06770049484275],
    ['#123', '#444', 8.32326136957393],
    ['#444', '#123', -7.526878460278154],
    ['#0006', '#fff', 54.62184067441377]
  ].freeze

  def test_matches_the_apca_w3_reference_values_sign_included
    VECTORS.each do |text, background, expected|
      assert_in_delta expected, Tincture::Color.parse(text).apca_contrast(background), 1e-9, "#{text} on #{background}"
    end
  end

  def test_returns_0_for_colours_too_close_to_tell_apart
    assert_equal 0.0, Tincture::Color.parse('#777777').apca_contrast('#787878')
  end
end

class ApcaContrastColorTest < Minitest::Test
  BRIGHT_BLUE = Tincture::Color.parse('#0a7cff')

  def test_picks_by_apca
    assert_equal Tincture::Color::WHITE, BRIGHT_BLUE.contrast_color(method: :apca)
    assert_equal Tincture::Color::BLACK, Tincture::Color.parse('yellow').contrast_color(method: :apca)
    assert_equal Tincture::Color::WHITE, Tincture::Color.parse('navy').contrast_color(method: :apca)
  end

  def test_picks_the_best_of_the_given_candidates_by_apca
    assert_equal Tincture::Color::WHITE, BRIGHT_BLUE.contrast_color(among: ['#1f2937', 'white'], method: :apca)
  end

  def test_agrees_with_the_core_oklab_method_on_greys
    (0..255).step(5).each do |level|
      grey = Tincture::Color.rgb(level, level, level)

      assert_equal grey.contrast_color(method: :apca), grey.contrast_color(method: :oklab),
                   "rgb(#{level} #{level} #{level})"
    end
  end
end
