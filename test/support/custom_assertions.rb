module MiniTest::Assertions
  # Behaves a bit like `hash_including`.
  # Given a slice of the original hash, it verifies that the original hash
  # includes the sub-hash given. Useful when testing partial arguments/params to
  # methods.
  def assert_includes_subhash(expected_sub_hash, hash)
    expected_sub_hash.each do |key, value|
      assert_equal(
        value,
        hash[key],
        "Expected #{hash} to include #{key}=#{value}"
      )
    end
  end
end
