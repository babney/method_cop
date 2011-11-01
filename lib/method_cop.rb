module MethodCop
  # Guard methods that have side effects with a callback that fires before the method is invoked.
  # If the callback returns a "falsey" value, the method is halted and will not be called.
  # The callback will return nil instead.
  # if the method does not have side effects or you depend on its return value, you should NOT
  # use this on that method! This will break the _hell_ out of design by contract.
  # currently does not work with methods that accept blocks so be aware of that. Fixes, improvements,
  # pull requests, and general "why on earth did you do this" notes are encouraged.
  
  #TODO: DRY this up
  
  @@guards = {}
  @@class_guards = {}
  def guard_method(name, options)
    @@guards[name] = options
  end
  
  def method_added(name)
    unless @@guards[name].nil?
      options = @@guards[name]
      @@guards = @@guards.delete(name)
      guard_method_internal(name, options)
    end
  end
  
  def guard_method_internal(name, options)
    method = name.to_sym
    original_method = "#{name}_orig".to_sym
    alias_method  original_method, method
    define_method(method) do |*args|
      unless options[:with].nil?
        unless !self.send(options[:with].to_sym)
          self.send(original_method, *args) 
        else
          # THIS METHOD IS UNDER ARREST
          nil
        end
      else
        # no method to guard with was given
        self.send(original_method, *args)
      end
    end
  end
  
  
  def guard_class_method(name, options)
    @@class_guards[name] = options
  end
  
  def singleton_method_added(name)
    unless @@class_guards[name].nil?
      options = @@class_guards[name]
      @@class_guards = @@class_guards.delete(name)
      guard_class_method_internal(name, options)
    end
  end
  
  def guard_class_method_internal(name, options)
    @@method_to_guard_name = name
    @@method_to_guard_options = options
    # there HAS to be a better way. need to look into it.
    class << self
      name = @@method_to_guard_name
      options = @@method_to_guard_options
      @@method_to_guard_name = nil
      @@method_to_guard_options = nil
      method = name.to_sym
      original_method = "#{name}_orig".to_sym
      alias_method  original_method, method
      define_method(method) do |*args|
        unless options[:with].nil?
          unless !self.send(options[:with].to_sym)
            self.send(original_method, *args) 
          else
            # THIS METHOD IS UNDER ARREST
            nil
          end
        else
          # no method to guard with was given
          self.send(original_method, *args)
        end
      end
    end
  end
end