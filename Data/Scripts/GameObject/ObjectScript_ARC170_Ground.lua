require("PGStateMachine")


function Definitions()
	Define_State("State_Init", State_Init)

end

function State_Init(message)

	if Get_Game_Mode() ~= "Land" then
		ScriptExit()
	end

    if message == OnEnter then
        Object.Play_Animation("Undeploy", false)
        ScriptExit()
    end

end