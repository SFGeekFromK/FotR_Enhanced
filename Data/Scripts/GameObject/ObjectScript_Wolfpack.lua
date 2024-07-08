require("PGStateMachine")


function Definitions()
	Define_State("State_Init", State_Init)

end

function State_Init(message)

	if Get_Game_Mode() ~= "Land" then
		ScriptExit()
	end

		
	if message == OnEnter then
        Hide_Sub_Object(Object, 1, "jumptroop") -- unnecessary mesh
        Hide_Sub_Object(Object, 1, "body_LOD0")
		Hide_Sub_Object(Object, 1, "body_LOD1")
		Hide_Sub_Object(Object, 1, "helmet_LOD0")
		Hide_Sub_Object(Object, 1, "helmet_LOD1")
		Hide_Sub_Object(Object, 0, "body_104_LOD0")
		Hide_Sub_Object(Object, 0, "body_104_LOD1")
		Hide_Sub_Object(Object, 0, "helmet_104_LOD0")
		Hide_Sub_Object(Object, 0, "helmet_104_LOD1")
		-- for snow version
		Hide_Sub_Object(Object, 1, "Body_LOD0")
		Hide_Sub_Object(Object, 1, "Body_LOD1")
		Hide_Sub_Object(Object, 1, "Head_LOD0")
		Hide_Sub_Object(Object, 1, "Head_LOD1")
		Hide_Sub_Object(Object, 0, "Head_104_LOD0")
		Hide_Sub_Object(Object, 0, "Head_104_LOD1")

		-- lense hide
        Hide_Sub_Object(Object, 1, "lenseP1")
    	Hide_Sub_Object(Object, 1, "lenseP2")
		
        ScriptExit()
	end
end
