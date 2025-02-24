# frozen_string_literal: false
require 'test/unit'
require 'tmpdir'

class TestBugReporter < Test::Unit::TestCase
  def test_bug_reporter_add
    skip if ENV['RUBY_ON_BUG']

    description = RUBY_DESCRIPTION
    description = description.sub(/\+JIT /, '') if defined?(RubyVM::MJIT) && RubyVM::MJIT.enabled?
    expected_stderr = [
      :*,
      /\[BUG\]\sSegmentation\sfault.*\n/,
      /#{ Regexp.quote(description) }\n\n/,
      :*,
      /Sample bug reporter: 12345/,
      :*
    ]
    tmpdir = Dir.mktmpdir

    args = ["--disable-gems", "-rc/bug_reporter",
            "-C", tmpdir]
    stdin = "register_sample_bug_reporter(12345); Process.kill :SEGV, $$"
    assert_in_out_err(args, stdin, [], expected_stderr, encoding: "ASCII-8BIT")
  ensure
    FileUtils.rm_rf(tmpdir) if tmpdir
  end
end
