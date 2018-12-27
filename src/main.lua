require("config")
require("global")

require("func")
require("init")
require("scale")
require("page")
require("exec")
require("projectFunc")
require("task/rankSim")
screen.init(1, 0)

function main()
	exec.run("天梯", 2)
end

main()