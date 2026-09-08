source "https://rubygems.org"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
# gem "jekyll", "~> 4.0.0"
# This is the default theme for new Jekyll sites. You may change this to anything you like.
gem "minima", "~> 2.5"

gh_page_versions = begin
  require 'json'
  require 'open-uri'
  JSON.parse(URI.open('https://pages.github.com/versions.json').read)
  versions['github-pages']
rescue StandardError
  ' >= 232'
end

# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins
gem 'github-pages', gh_page_versions

gem 'bigdecimal'

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.17.0"
end

install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  # Windows and JRuby does not include zoneinfo files
  # bundle the tzinfo-data gem and associated library.
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
  # Performance-booster for watching directories on Windows
  # I can't figure out how to only include this in windows so
  # You'll have to uncomment if you are running on windows.
  # gem "wdm", "~> 0.1.1"
end
