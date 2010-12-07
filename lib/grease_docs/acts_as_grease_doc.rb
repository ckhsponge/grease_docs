module GreaseDocInclude
  
  def self.included(base)
    puts "GreaseDocModel"
    base.send :extend, ActiveRecordClassMethods
  end
  
  module ActiveRecordClassMethods
    def acts_as_grease_doc
      send :after_create, :init_grease_doc
      send :extend, ClassMethods
      send :include, InstanceMethods
    end
  end
  
  module ClassMethods
    def grease_doc_collection(collection, args = {})
      raise "no collection set" unless collection
      @@grease_doc_options ||= {}
      @@grease_doc_options[:collection_name] = collection
      raise "No class set. Must include :class" unless args[:class]
      @@grease_doc_options[:collection_class] = args[:class]
      @@grease_doc_options[:association_name] = args[:association_name] || self.to_s.underscore.to_sym
    end
    
    def grease_doc_columns(columns, args = {})
      @@grease_doc_options ||= {}
      raise "no columns set" unless columns
      @@grease_doc_options[:column_fields] = columns
      @@grease_doc_options[:csv_header] = args[:names] || columns.collect{|c| c.to_s}
    end
    
    def grease_doc_options
      @@grease_doc_options
    end
  end
  
  module InstanceMethods
    def init_grease_doc
      self.grease_doc.set_key
    end
    
    def grease_doc
      @grease_doc ||= GreaseDocs::Doc.new(self)
    end
  end
end

ActiveRecord::Base.send :include, GreaseDocInclude