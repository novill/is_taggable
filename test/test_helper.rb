require 'rubygems'
require 'active_record'
require File.expand_path('../../lib/is_taggable', __FILE__)
require 'expectations'
require 'logger'

ActiveRecord::Base.configurations = {'sqlite3' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('sqlite3')

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::WARN

ActiveRecord::Schema.define(:version => 0) do
  create_table :comments do |t|
  end
  
  create_table :posts do |t|
    t.string  :title, :default => ''
  end

  create_table :tags do |t|
    t.string :name, :default => ''
    t.string :kind, :default => '' 
  end

  create_table :taggings do |t|
    t.integer :tag_id

    t.string  :taggable_type, :default => ''
    t.integer :taggable_id
  end
end

class Post < ActiveRecord::Base
  is_taggable :tags, :languages
end

class Comment < ActiveRecord::Base
  is_taggable
end
