require "test_helper"
require "polycon"

class ProfessionalsTest < Minitest::Test
  def test_create
    alma = Polycon::Models::Professional.create(name: "Alma Estevez")
    dennis = Polycon::Models::Professional.create(name: "Denis Perez")
    assert_equal "Alma Estevez", alma.name
    assert_equal "Denis Perez", dennis.name
  end

  # def test_create
  #   professional = Polycon::Models::Professional.create(name: "Alma Estevez")
  #   assert_equal "Alma Estevez", professional.name
  # end

  # def test_non_replacements
  #   assert_equal "nothing to replace", reemplazar("nothing to replace")
  # end

  # def test_replace_open_block
  #   assert_equal "do\n", reemplazar("{")
  # end

  # def test_replace_multiple_open_blocks
  #   assert_equal "do\ndo\ndo\n", reemplazar("{{{")
  # end

  # def test_replace_close_block
  #   assert_equal "\nend", reemplazar("}")
  # end

  # def test_replace_multiple_close_block
  #   assert_equal "\nend\nend\nend", reemplazar("}}}")
  # end

  # def test_real_ruby_block
  #   assert_equal "3.times do\n |i| puts i \nend",
  #                reemplazar("3.times { |i| puts i }")
  # end
end
