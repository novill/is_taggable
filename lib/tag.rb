class Tag < ActiveRecord::Base
  class << self
    def find_or_initialize_with_name_like_and_kind(name, kind)
      name = collapse_whitespace(name)
      with_name_like_and_kind(name, kind).first || new(:name => name, :kind => kind)
    end
  end

  has_many :taggings, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :kind

  scope :with_name_like_and_kind, lambda { |name, kind| { :conditions => ["name like ? AND kind = ?", name, kind] } }
  scope :of_kind,                 lambda { |kind| { :conditions => {:kind => kind} } }
  
  def name=(name)
    super self.class.collapse_whitespace(name)
  end

  def qname
    name.match(/\s|,/) ? '"'+name+'"' : name
  end
  
protected
  
  def self.collapse_whitespace(name)
    name.gsub(/\s+/, ' ').strip
  end
end
