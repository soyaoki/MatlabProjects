pyversion

py.print(py.str("----------- Python list command -----------"))
list = py.list

py.print(py.str("----------- Python append command -----------"))
list.append(1)
list

py.print(py.str("----------- Python dir command -----------"))
py.dir(list)

py.print(py.str("----------- Python range command -----------"))
py.range(py.int(10))

py.print(py.str("----------- Python for command -----------"))
for i = py.range(py.int(10))
   py.print(i)
end

py.print(py.str("----------- Python copyright command -----------"))
py.copyright

py.print(py.str("----------- Python len command -----------"))
py.len(list)
