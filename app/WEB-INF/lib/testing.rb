class Testing
@@test_var = 0
def self.test_var
  @@test_var
end

def self.test_var=(value)
  @@test_var = value
end
end