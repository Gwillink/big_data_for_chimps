require 'configliere' ; Settings.use :commandline
require 'gorillib'
require 'gorillib/array/wrap'
require 'gorillib/model'
require 'gorillib/factories'
require 'gorillib/model/serialization'
require 'gorillib/model/serialization/csv'
require 'gorillib/model/serialization/tsv'
require 'gorillib/type/extended'
require 'gorillib/hash/slice'
require 'gorillib/pathname'
require 'gorillib/logger/log'
require 'pry'

BOOK_ROOT = (ENV['BOOK_CONTENTS'] || File.expand_path('..', File.dirname(__FILE__)))

Settings.define :mini, type: :boolean, default: false, description: "use sample data or full data?"
Settings.resolve!
Settings[:mini_slug] = Settings.mini ? "-sample" : ""

Pathname.register_paths(
  book_root: BOOK_ROOT,
  code: [:book_root, 'code'],
  data: [:book_root, 'data'],
  work: [:book_root, 'tmp'],
  )

require 'rake/name_space'
module ::Rake
  class NameSpace
    def name
      @scope.join(':')
    end

    def direct_tasks
      tasks.find_all{|task| task.name =~ /\A#{name}:\w+\z/ }
    end
  end
end

def file_task(name, options={})
  target     = Pathname.of(name)
  target_dir = File.dirname(target.to_s)
  task(name => target)
  #
  directory(target_dir)
  deps       = [options[:after], target_dir].flatten.compact
  file target => deps do
    Array.wrap(options[:invoke]).each{|task_name| Rake::Task[task_name].invoke }
    Log.info "Creating #{name} => #{target}"
    yield target if block_given?
  end
  task(options[:part_of] => name) if options[:part_of]
  target
end

def create_file(name, options={})
  file_task(name, options) do |target|
    File.open(target, 'wb') do |target_file|
      yield target_file
    end
  end
end

# * accumulates all symbol-named tasks that are direct children
#
# @example Will make task parse depending on 'parse:bob'
#   chain('parse') do
#     task('bob'){ ... }
#     chain('nest'){ task('two_down') }
#   end
#
def chain(name, doc=nil, &block)
  desc(doc) if doc
  task(name)
  return unless block
  ns = namespace(name, &block)
  task(name => ns.direct_tasks)
  ns
end