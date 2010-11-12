
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name  'salessimplicity'
  authors  'Timmy Crawford'
  email    'timmydcrawford@gmail.com'
  url      'http://github.com/timmyc/salessimplicity'
}

