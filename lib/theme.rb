require 'date'
class Theme

  attr_reader :name
  attr_reader :title
  attr_reader :description
  attr_reader :index
  attr_reader :author_name
  attr_reader :author_email
  attr_reader :date_of_inclusion

  @@all = []

  def initialize(filename)
    @filename = filename
    @name = File.basename(filename).sub(/\.txt$/, '')
    @attributes = {}
    @author_name, @author_email = nil
    @index = nil
    @date_of_inclusion = nil
    load_info!
    yield self if block_given?
  end

  def author
    "#{author_name} <#{author_email}>"
  end

  def other_themes
    @@all[(index + 1)..-1] + @@all[0...index]
  end

private

  def load_info!
    head, @description = File.read("src/#{name}.txt").split("\n\n", 2)
    @title, head = head.split("\n", 2)
    lines = head.split("\n")
    lines.each do |line|
      case line
      when /^[=~-]+$/, /^\s*$/, /^\s*\/\/.*$/
        next
      when /^(.*)\s+<(.*)>\s*$/
        @author_name, @author_email = $1, $2
      when /^\d{4}-\d{2}-\d{2}$/
        parts = line.split('-').map { |p| p.to_i }
        @date_of_inclusion = Date.new(*parts)
      when /^:(.*):\s*(.*)$/
        @attributes[$1] = $2
      else
        raise "malformed theme info: src/#{name}.txt"
      end
    end
  end

  class << self
    include Enumerable

    def each(&block)
      load!
      @@all.each(&block)
    end

    def load!
      return unless @@all.empty?
      @@all = FileList['src/*.txt'].
        map { |filename| new(filename) }.
        sort { |a,b| a.date_of_inclusion <=> b.date_of_inclusion }.
        reverse
      @@all.each_with_index do |theme,index|
        theme.instance_variable_set(:@index, index)
      end
    end

  end

end
