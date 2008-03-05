require "rake/clean"


DEPEND_FILE = '.depend'
the_file = ""
File.open(DEPEND_FILE).each do |line|
  md = /^(\S+): (.*)$/.match line.strip
  vars = if md.nil?
           [the_file, line.split]
         else
           [md[1], md[2].split]
         end
  the_file, the_deps = *vars
  file the_file => the_deps.select {|dep| dep != '\\'}
end if File.exist? DEPEND_FILE

FileList['**/*.ml', '**/*.mll', '**/*.mly'].each do |f|
  case f
  when /\.mll?$/
    file f.ext('cmx') => f.ext('ml')
  when /\.mly$/
    file f.ext('cmx') => f.ext('cmi')
    file f.ext('cmi') => f.ext('mli')
    file f.ext('mli') => f.ext('ml')
  end
end

INCLUDES = "-I src"
OCAMLCFLAGS = INCLUDES
OCAMLOPTFLAGS = INCLUDES

OBJS = ['src/expr.cmx', 'src/syntax.cmx', 'src/grammar.cmx', 'src/parser.cmx',
        'src/lambda.cmx']

TESTS = FileList['tests/testCase.ml', 'tests/test_*.ml'].collect {|f| f.ext('cmx')}

CLEAN.include("bin/*", '**/*.o', '**/*.cmi', '**/*.cmo', '**/*.cmx')

desc "Build Lambda"
task :default => "bin/lambda"

desc "Build the dependency file"
task :depend do
  includes = INCLUDES + " -I tests"
  files = FileList["**/*.ml", "**/*.mli"].join(' ')
  system "ocamlfind ocamldep -native #{includes} #{files} > #{DEPEND_FILE}"
end

desc "Build and run the unit tests"
task :tests => "bin/tests" do
  system "./bin/tests"
end
task :test => :tests

directory "bin"

lambda_deps = OBJS + ["src/main.cmx"]
file "bin/lambda" => ["bin", *lambda_deps] do |t|
  sh "ocamlfind ocamlopt -o #{t.name} #{OCAMLOPTFLAGS} #{lambda_deps.join(' ')}"
end

test_deps = OBJS + TESTS + ["tests/suite.cmx"]
file "bin/tests" => ["bin", *test_deps] do |t|
  sh "ocamlfind ocamlopt -o #{t.name} #{flags(OCAMLOPTFLAGS)} #{test_deps.join(' ')}"
end

def flags(other_flags, file='tests/')
  result = other_flags
  result += ' -package oUnit -linkpkg -I tests' if /^tests\// === file
  result
end

rule '.cmo' => ['.ml'] do |t|
  sh "ocamlfind ocamlc #{flags(OCAMLCFLAGS, t.source)} -c #{t.source}"
end

rule '.cmi' => ['.mli'] do |t|
  sh "ocamlfind ocamlc #{flags(OCAMLCFLAGS, t.source)} -c #{t.source}"
end

rule '.cmx' => ['.ml'] do |t|
  sh "ocamlfind ocamlopt #{flags(OCAMLOPTFLAGS, t.source)} -c #{t.source}"
end

rule '.ml' => ['.mll'] do |t|
  sh "ocamllex #{t.source}"
end

rule '.ml' => ['.mly'] do |t|
  sh "ocamlyacc #{t.source}"
end
