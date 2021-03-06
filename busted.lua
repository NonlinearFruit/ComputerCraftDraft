specs = {}
function add_spec(program)
  if string.match(program, "_spec") then
    module = require(program);
    for func, _ in pairs(module) do
      table.insert(specs, {func = module[func], name = program..":"..func});
    end
  end
end

if shell == nil then
  term, colors = {}, {}
  term.write = io.write
  term.setTextColor = function() end
  programs = io.popen("ls -1 | sed -e 's/\\..*$//'"):lines();
  for program in programs do
    add_spec(program)
  end
else
  programs = shell.programs();
  for _, program in pairs(programs) do
    add_spec(program)
  end
end

totalTests = #specs;
totalPassed = 0;
totalFailed = 0;

for index, test in pairs(specs) do
  if test["func"]() then
    totalPassed = totalPassed + 1;
  else
    totalFailed = totalFailed + 1;
    term.setTextColor(colors.red);
    print("Failed -- "..test["name"]);
    term.setTextColor(colors.white);
  end
end

term.write(totalTests.." tests: ");
term.setTextColor(colors.green);
term.write(totalPassed);
term.setTextColor(colors.white);
term.write(" passed, ");
term.setTextColor(colors.red);
term.write(totalFailed);
term.setTextColor(colors.white);
print(" failed.");

if os.exit ~= nil then
  os.exit(totalFailed)
end
