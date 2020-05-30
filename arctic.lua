-- *************************************************************************************
-- ** Copyright 2016 by Norman Tang (norman@normstorm.com).
-- ** Not for use or distribution without author's written consent
-- *************************************************************************************
-- The Matrix (Agent Smith) "Have you ever stood and stared at it, marveled at its beauty, its genius?"
-- *************************************************************************************
-- v0.01 - initial creation
-- v0.02 - 05/29/2012 - handle target parsing of "the dark knight of takhisis"
-- v0.03 - 06/01/2012 - basic automem for 3 caster classes
-- v0.04 - 04/03/2013 - added code to handle new 2 letter class descriptor in group line
-- v0.05 - 04/10/2013 - added handling of General pretitle chars
-- v0.06 - 04/12/2013 - logic for unfreeze, unblind, and unparalyze triggers for both Main and Group healers
-- v0.07 - 04/19/2013 - added sky re-targetting acquisition delay and additional target parsing logic for 2 word targets
-- v0.08 - 04/25/2013 - added sky re-targetting acquisition delay and additional target parsing logic for 2 word targets
-- v0.09 - 04/30/2013 - consider cure serious memmed count for divine mass refresh
-- v0.10 - 05/07/2013 - added Paladin autobuffs, and healbot holy armor and spiritual hammer logic
-- v0.11 - 05/14/2013 - added entangle free action logic
-- v0.12 - 05/16/2013 - added logic to word all
-- v0.13 - 12/28/2015 - no change in the lua, but the MUSH scripts handle enshrouds as obliterate logic in doCheckRescueTarget
-- v0.14 - 01/02/2016 - allow toggling of curing above fair using cureon/cureoff alias and in healGroupParse(): Step 7
-- v0.15 - 01/04/2016 - get stats from Arctic
-- v0.16 - 01/06/2016 - add BlackRobe spell buffs (think had before but lost due to versioning)
-- v0.17 - 01/06/2016 - added gtShowHeals
-- v0.18 - 01/08/2016 - toggleable random delay for skybot, asson, and autorescue in doCheckRescueTarget() function
-- v0.19 - 01/09/2016 - enhanced random delay for 0.1 increments and added functionality to rdelaymin/rdelaymax
-- v0.20 - 01/09/2016 - disabled caster auto-checking of mem if not in game. prevent login of char with name Mem
-- v0.21 - 01/16/2016 - add assist logic, so instead of auto-targetting, assist instead (less botty), also documented target exceptions in doParseTarget()
-- v0.22 - 01/22/2016 - added Warrior to autoskilling in doBotCombatSkill()
-- v0.23 - 01/23/2016 - added divine refresh for druid in mvgroupparse(), and pkLoot()
-- v0.24 - 01/23/2016 - coded shaman bot buffs and divine regenerate
-- v0.25 - 01/24/2016 - coded regen timer for regen length determination
-- v0.26 - 01/24/2016 - tested and refined assist logic to work both with rdelayon and rdelayoff and in different attacker/victim scenarios
-- v0.27 - 01/26/2016 - fixed over rescue spam in doCheckRescueTarget()
-- v0.28 - 01/27/2016 - move bash tracking from .MCL to this for bash timing tracking
-- v0.29 - 01/27/2016 - added target exceptions for head gem processor and expert ore grade determiner
-- v0.30 - 01/30/2016 - doSpell_List() - keeping track of what spells have actually been learned, NOT mem tracking, added spells check on login
-- v0.31 - 01/30/2016 - integrated shaman healbot logic into healGroupParse() and gtShowHeals()
-- v0.32 - 01/31/2016 - added some tracking shaman spirits, and greater intelligence around oask alias
-- v0.33 - 01/31/2016 - added better intelligence around druid automem for circle 4 spell slots
-- v0.34 - 02/01/2016 - added logic to blackrobe spell list (rend/nightmare) mem and redrobe (thunderbolt)
-- v0.35 - 02/02/2016 - added tenacious heart and heal boost to shaman autobuffs and logic for regen duration depending on legend or non-legend
-- v0.36 - 02/07/2016 - added logic to increment spirit when call spirit
-- v0.37 - 02/08/2016 - moved client side logic to arctic.lua for doArrivalTrigger and added shaman to class
-- v0.38 - 02/09/2016 - added logic to use regular refresh if groupsize is only 1, ie. not waste mem on mass refresh circle
-- v0.40 - 02/13/2016 - added some logic to check group health if newly grouped as druidbot or healbot
-- v0.41 - 02/14/2016 - added logic in gtShowHeals where non-caster classes would respond to triggeryy
-- v0.42 - 02/22/2016 - added shaman, Scout_skill_list and changed flap to surge (replaced flap) to specialize towards ocean scouts.
-- v0.43 - 07/01/2016 - fixed spectralsightcount, added darkenedsoulcount, ethereal armor
-- v0.44 - 07/22/2016 - improved spirit counting so can't add over 5 if legendary or 3 if non-legendary
-- v0.45 - 07/22/2016 - fixed bug where druid bot would try to stone "YOU" instead of "me" if being attacked
-- v0.46 - 07/22/2016 - added oask to default setengage when shaboton alias called
-- v0.47 - 07/24/2016 - added incrementSpellCount for shaman channel
-- v0.48 - 08/12/2016 - minor bug fix in mvgroupparse() for Shaman trying to cast fly during refgroup call, due to flycount not being zero'd out
-- v0.49 - 08/13/2016 - clears shaman regen and spellcount variables
-- v0.50 - 08/13/2016 - improved druid autostone so less spam, similar to regen timer
-- v0.51 - 08/14/2016 - fixed bugs, some scripts dependent on spellcounts
-- v0.52 - 08/16/2016 - added alias for shaman order all.spirit raise spirit count reset
-- v0.53 - 08/17/2016 - improved cgt for druidbot
-- v0.54 - 08/18/2016 - add setfriendly alias to avoid having to manually tweak alias to avoid bot genocide
-- v0.55 - 08/21/2016 - setup nmon/nmoff alias for stoneskin/regen for nomagic room fights in doArrivalTrigger
-- v0.56 - 08/23/2016 - fixed bug with cureblindnesscount in certain situations when doCheckBlind fires
-- v0.57 - 08/29/2016 - zero'd out etherealarmorcount in resetMem, fixed divine regen for darkened soul and zombify, fixed issue in doDivineHeal
-- v0.58 - 08/29/2016 - more zeroing out of cure light, critical, and healcount variables
-- v0.59 - 09/02/2016 - added autobuffs for dk
-- v0.60 - 09/06/2016 - added nightvision to DK autobuffs
-- v0.61 - 09/08/2016 - spell check for shocking blast, healing wave, and chain lightning, also added dk_skill_list for skillon/autoskill
-- v0.62 - 09/11/2016 - added white robe autofrag (arcane spear/lash and scorch) + buffs (fireshield, arcane shell, epiphany, white rune)
-- v0.63 - 09/14/2016 - add support for doch and docheckheals command so there is no clientside gt, instead healcounts pure serverside
-- v0.64 - 09/15/2016 - added cancel to doJet and also better druidbot/magebot intelligence upon group form with refgroup
-- v0.65 - 09/21/2016 - added ancestral shroud for shaman autobuffs
-- v0.66 - 09/22/2016 - added additional white robe spell buffs: mindafire, juke, preservation, watchfuleye, foldspace, boon, globe
-- v0.67 - 09/23/2016 - added lily dk autobuffs - unholy aura and soul protection
-- v0.68 - 09/23/2016 - fixed white robe spell buffs variable initialization
-- v0.69 - 09/23/2016 - fixed typo in preservation whiterobe spell buff that was causing nil compare error
-- v0.70 - 10/02/2016 - created order all golem kill (oagk) to support mage, must have asson and setengage oagk to work
-- v0.71 - 10/02/2016 - beginning to look at post-bash miss not standing in doBashMiss
-- v0.72 - 10/03/2016 - added cflee alias, and also automem power word stun (currently just red robe)
-- v0.73 - 10/03/2016 - fixed bug (code omission) in tracking of pws capability
-- v0.74 - 10/23/2016 - fix bug with not always autostanding after missed bash by doing a hardcode hack in doBashMiss
-- v0.75 - 09/28/2018 - tweak druid spell slots to match latest spell circles - added cure massive, need to add divine free action
-- v0.76 - 10/10/2018 - added automem toggle
-- v0.77 - 10/13/2018 - cure massive auto-heal logic
-- v0.78 - 10/26/2019 - made fixes to cure massive auto-heal logic, including heal delay depending on healg or healp, logic in doCheckRescueTarget and healGroupParse
-- v0.79 - 05/29/2020 - fixed for divine heal count for animate dead
--[[
function Trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end
--]]
--http://snippets.luacode.org/snippets/Check_string_ends_with_other_string_74
function endswith(s, send)
  return #s >= #send and s:find(send, #s-#send+1, true) and true or false
end

function getVersion(name,line,wildcards)
  local version = "0.78"
  Note("** Version        : v"..version)
  Execute("cgt ** Version        : v"..version)

  --           ** tryingheal     : 0
end

function doClearShamanVars(name,line,wildcards)
    local isfound = false  --note this variable isn't really used for anything currently
	local varcount = 0

	-- *** Reset shaman regen timer *****
	for k, v in pairs (GetVariableList()) do
	  if (string.match(k,"^lastregen_([A-Za-z]+)$")) then
		varcount = varcount + 1
		isfound = true
		DeleteVariable(k)
	  end
	end
	Note("** "..varcount.." shaman regen variables deleted.")

	-- *** Now reset druid stone timer *****
	varcount = 0
	isfound = false
	for k, v in pairs (GetVariableList()) do
	  if (string.match(k,"^laststone_([A-Za-z]+)$")) then
		varcount = varcount + 1
		isfound = true
		--Note("** var: "..k)
		DeleteVariable(k)
	  end
	end
	Note("** "..varcount.." druid stone variables deleted.")

	-- *** Now reset spellcounts (applies to all classes) *****
	varcount = 0
	isfound = false
	for k, v in pairs (GetVariableList()) do
	  if (string.match(k,"^([A-Za-z]+)count$")) then
		if (k ~= "resistcount" and k ~= "flycount" and k ~= "freeactioncount" and k ~= "massflycount" and k ~= "cureblindnesscount" and
			k~= "cureseriouscount" and k~= "curelightcount" and k~="curecriticalcount" and k~="healcount" and
			k~= "freeactioncount") then
			varcount = varcount + 1
			isfound = true
			--Note("** var: "..k)
			DeleteVariable(k)
		end
	  end
	end
	Note("** "..varcount.." spell count variables deleted.")

	--must have the variables otherwise non-fatal bugs in resist trigger, freeaction, and refgroup scripts
	if (GetVariable("resistcount") == nil) then
		SetVariable("resistcount",0)
	end
	if (GetVariable("flycount") == nil) then
		SetVariable("flycount",0)
	end
	if (GetVariable("massflycount") == nil) then
		SetVariable("massflycount",0)
	end
	if (GetVariable("freeactioncount") == nil) then
		SetVariable("freeactioncount",0)
	end
	if (GetVariable("cureblindnesscount") == nil) then
		SetVariable("cureblindnesscount",0) --otherwise bug in doCheckBlind
	end
	if (GetVariable("cureseriouscount") == nil) then
		SetVariable("cureseriouscount",0) --otherwise potential bug
	end
	if (GetVariable("curelightcount") == nil) then
		SetVariable("curelightcount",0) --otherwise potential bug
	end
	if (GetVariable("curecriticalcount") == nil) then
		SetVariable("curecriticalcount",0) --otherwise potential bug
	end
	if (GetVariable("healcount") == nil) then
		SetVariable("healcount",0) --otherwise potential bug
	end
	if (GetVariable("freeactioncount") == nil) then
		SetVariable("freeactioncount",0) --otherwise potential bug
	end
end
--*********************************************************
--* Char hp and other prompt line data collection for use with server data push
--* <msg><cmd>CHARDATA</cmd><payload><chardata name='Poimoiwuer' charclass='Warrior' currenthp='499' maxhp='499' currentmv='113' maxmv='113' /></payload></msg>
--*********************************************************
function doCollectCharPromptData(name,line,wildcards)
    local isChanged = false

	if (GetVariable("charRankPct") == nil) then
		SetVariable("charRankPct",0.0)
	end

	if (GetVariable("charXpTnl") == nil) then
		SetVariable("charXpTnl",0)
	end

	if (wildcards[3] ~= nil and #wildcards[3] > 0) then
		if (GetVariable("charXpTnl") ~= wildcards[3]) then
			SetVariable("charXpTnl",wildcards[3])
			isChanged = true
		end
	end

	if (wildcards[4] ~= nil and #wildcards[4] > 0) then
		if (GetVariable("charRankPct") ~= wildcards[4]) then
			SetVariable("charRankPct",wildcards[4])
			isChanged = true
		end
	end

	if (tonumber(wildcards[1]) ~= tonumber(GetVariable("charCurrentHP"))) then
	  SetVariable("charCurrentHP", wildcards[1])
	  isChanged = true
	end

	if (tonumber(wildcards[2]) ~= tonumber(GetVariable("charCurrentMV"))) then
	  SetVariable("charCurrentMV", wildcards[2])
	  isChanged = true
	end

	if (tonumber(wildcards[5]) ~= tonumber(GetVariable("coinsOnHand"))) then
	  SetVariable("coinsOnHand", wildcards[5])
	  isChanged = true
	end

	parsePromptLine(Trim(wildcards[6]))

	if (tonumber(GetTriggerOption("group_line","enabled")) == 1) then
	  Execute("healgroupparse")
	end

	EnableTrigger("group_line", false)
	--EnableTrigger("group_stopper", false)

	if (isChanged and IsSocketConnected()) then
	    --Note("isChanged: "..tostring(isChanged))
		--Note("IsSocketConnected: "..tostring(IsSocketConnected()))
		local xmlstr = CreateXMLMsg("CHARPROMPT","<chardata />")
		--Note("xmlstr: "..xmlstr)
		--assert(c:send(xmlstr.."\\n"))
	end
end

--*********************************************************
--* sets friendy_list variable
--*********************************************************
function doSetFriendly(name,line,wildcards)
    local friendly_list = ""
	local friends = {}
	friendly_list = Trim(wildcards[1])
	if (#friendly_list > 0) then
	  for i in string.gmatch(friendly_list,"([A-Za-z]+)\,?") do
		table.insert(friends, Trim(Proper(i)))
	  end
	  SetVariable("friendly_list",Trim(table.concat(friends,",")))
	elseif (GetVariable("friendly_list") == nil) then
		SetVariable("friendly_list","")
	end
	Note("** friendly_list: "..GetVariable("friendly_list"))
end

--*********************************************************
--* adds person to friendly list - can accept single name or comma separated list
--*********************************************************
function doAddFriendly(name,line,wildcards)
    local friendly_list = ""
	local friendadd = Trim(wildcards[1])
	local friends = {}

	if (GetVariable("friendly_list") ~= nil) then
		friendly_list = Trim(GetVariable("friendly_list"))
	end

	if (#friendadd > 0) then
	  for i in string.gmatch(friendadd,"([A-Za-z]+)\,?") do
		table.insert(friends, Trim(Proper(i)))
	  end

	  if (#friendly_list > 0) then
	    --determine whether to prepend command or not
		SetVariable("friendly_list", friendly_list..","..Trim(table.concat(friends,",")))
	  else
	    SetVariable("friendly_list",Trim(table.concat(friends,",")))
	  end
	end
	Note("** friendly_list: "..GetVariable("friendly_list"))
end

--*********************************************************
--* Removes person from friendly list - can accept single name
--*********************************************************
function doRemoveFriendly(name,line,wildcards)
	local friendly_list = ""
	local friendrem = Trim(Proper(wildcards[1]))
	local friends = {}
	local location = 1

  if (GetVariable("friendly_list") ~= nil) then
		friendly_list = Trim(GetVariable("friendly_list"))
	else
	  SetVariable("friendly_list","")
	end
	--friends = {"John","Sally","Jane"}
	--table.insert(friends,Trim(Proper(i)))
	for i in string.gmatch(friendly_list,"([A-Za-z]+)\,?") do
		table.insert(friends,Trim(Proper(i)))
	end

	if (#friendrem > 0 and #friendly_list > 0) then
	  for i in string.gmatch(friendly_list,"([A-Za-z]+)\,?") do
  		if (Trim(Proper(i)) == friendrem) then
  		  table.remove(friends,location)  --remove but don't advance location
  		else
  			location = location + 1   --advance location
  		end
	  end
	  SetVariable("friendly_list", Trim(table.concat(friends,",")))
	end
	Note("** friendly_list: "..GetVariable("friendly_list"))
end

--*********************************************************
--* health scan on entry of group member for healer, druid, and shaman classes
--*********************************************************
function doNewlyGrouped(name,line,wildcards)
	local ishealbot = false
	local isdruidbot = false
	local isshamanbot = false
	local ismagebot = false
	local charclass = GetVariable("charClass")

	--Note("** healtarget: "..healtarget)

	if (tonumber(GetVariable("isHealbot")) == 1) then
	  ishealbot = true
	elseif (tonumber(GetVariable("ismagebot")) == 1) then
	  ismagebot = true
	elseif (tonumber(GetVariable("isdruidbot")) == 1) then
	  isdruidbot = true
	elseif (tonumber(GetVariable("isShamanbot")) == 1) then
	  isshamanbot = true
	end

	if (isdruidbot) then         --for druid also want to check group mv
		Execute("spliton;skimon;skim 10;refgroup;gheal")
	elseif (ishealbot or isshamanbot) then
		Execute("spliton;skimon;skim 10;gheal")
	elseif (ismagebot) then
		Execute("spliton;skimon;skim 10;refgroup") --magebot wants to fly unflown group members
	else
		Execute("spliton;skimon;skim 10;group")
	end
end
--*********************************************************
--* this is called whenever people enter the room, useful for pk or for healbots
--* with nm(on|off) functionality, also setup for no magic room fights for druid/shaman bots
--*********************************************************
function doArrivalTrigger(name,line,wildcards)
	--Execute("checkpktarget "..Trim("%1"))
	--Note("** Arrival: %1 ")
	local healtarget = Trim(wildcards[1])
	local ishealbot = false
	local isdruidbot = false
	local isshamanbot = false
	local charclass = GetVariable("charClass")
	local isnomagicfight = false
	local stoneskincount = 0
	local regeneratecount = 0
	local healboostcount = 0
	local ritualvoyagecount = 0
	local ancestralspiritcount = 0
	local zombifycount = 0
	local darkenedsoulcount = 0

	--need to take tally of shaman circle 6 spells for accurate divine regenerate count
	  if (GetVariable("regeneratecount") ~= nil) then
		regeneratecount = tonumber(GetVariable("regeneratecount"))
	  end
	  if (GetVariable("healboostcount") ~= nil) then
		healboostcount = tonumber(GetVariable("healboostcount"))
	  end
	  if (GetVariable("ritualvoyagecount") ~= nil) then
		ritualvoyagecount = tonumber(GetVariable("ritualvoyagecount"))
	  end
	  if (GetVariable("ancestralspiritcount") ~= nil) then
		ancestralspiritcount   = tonumber(GetVariable("ancestralspiritcount"))
	  end
	  if (GetVariable("zombifycount") ~= nil) then
		zombifycount = tonumber(GetVariable("zombifycount"))
	  end
	  if (GetVariable("darkenedsoulcount") ~= nil) then
		darkenedsoulcount = tonumber(GetVariable("darkenedsoulcount"))
	  end

  --total since regen is divine spell
  regeneratecount = regeneratecount + healboostcount + ritualvoyagecount + ancestralspiritcount + zombifycount + darkenedsoulcount

	if (GetVariable("isnomagicfight") == nil) then
	  SetVariable("isnomagicfight",0)
	elseif (tonumber(GetVariable("isnomagicfight")) == 1) then
	  isnomagicfight = true
	end
	--Note("** healtarget: "..healtarget)

	if (tonumber(GetVariable("isHealbot")) == 1) then
	  ishealbot = true
	elseif (tonumber(GetVariable("isdruidbot")) == 1) then
	  isdruidbot = true
	elseif (tonumber(GetVariable("isShamanbot")) == 1) then
		isshamanbot = true
	end

	if (isTargetInGroup(healtarget) and isnomagicfight and isdruidbot) then
	  if (GetVariable("stoneskincount") ~= nil) then
		stoneskincount = tonumber(GetVariable("stoneskincount"))
	  else
		SetVariable("stoneskincount",0)
	  end

	  if (stoneskincount > 0) then
		Execute("doautostand;cast 'stone skin' "..healtarget)
		if (stoneskincount > 0 and IsSocketConnected()) then
			Execute("cgt "..tostring(stoneskincount - 1).." stones remaining")
		elseif (IsSocketConnected()) then
			Execute("cgt 0 stones remaining")
		end
	  end
	elseif (isTargetInGroup(healtarget) and isnomagicfight and isshamanbot) then
	  if (regeneratecount > 0) then
		Execute("doautostand;cast 'regenerate' "..healtarget)
		if (regeneratecount > 0 and IsSocketConnected()) then
			Execute("cgt "..tostring(regeneratecount - 1).." regens remaining")
		elseif (IsSocketConnected()) then
			Execute("cgt 0 regens remaining")
		end
	  end
	elseif (isTargetInGroup(healtarget) and (ishealbot or isdruidbot or isshamanbot))  then
	  if (ishealbot or isshamanbot) then
		    Execute("gheal")
	  elseif (isdruidbot) then
		    Execute("gheal;refgroup")
	  end
	else
	  Execute("checkpktarget "..healtarget)
	end
end

--*********************************************************
--*
--*********************************************************

function doWorldTest(name,line,wildcards)
	local myworld
	local worldname = "ArcticMUD"
	--myworld = GetWorld(worldname)
	--if (myworld == nil ) then
	--	Note(worldname.." is not open")
	--else
		--Send(myworld, "hi")
	--end
	--for k,v in pairs (GetOptionList()) do
	--	Note(v, " = ", GetOption(v))
	--end

	--Note("************* END OPTION LIST ******************")
	--Note("************* BEGIN GLOBAL OPTION LIST *********")
	--for k, v in pairs (GetGlobalOptionList()) do
	--	Note (v, " = ", GetGlobalOption(v))
	--end
	--Note("************* END GLOBAL OPTION LIST ******************")
	--Note("************* BEGIN ALPHA OPTION LIST *********")

	--for k, v in pairs (GetAlphaOptionList ()) do
	--	Note (v)
	--end
	Note("proxy_password: "..GetAlphaOption("proxy_password"))
	Note("proxy_server: "..GetAlphaOption("proxy_server"))
	Note("proxy_username: "..GetAlphaOption("proxy_username"))
	Note("proxy_port: "..GetOption("proxy_port"))
	Note("proxy_type: "..GetOption("proxy_type"))
	Note("connect_method: "..GetOption("connect_method"))
	Note("player: "..GetAlphaOption("player"))
	Note("password: "..GetAlphaOption("password"))
	-- proxy_type = 2
	-- proxy_port = 61336
	-- port = 2700
	--proxy_server
	--proxy_username
	--proxy_password

	--glynda - 104.128.59.209
	--blake - 199.101.97.140
	--bloat - 74.80.179.204
	--dracula - 64.31.62.208
	--fraker - 69.50.201.114
	--jaune - 216.230.229.61


	--SetAlphaOption("proxy_server","104.128.59.209")
	SetAlphaOption("proxy_username","thymorical")
	SetOption("proxy_port",61336)
	SetOption("proxy_type",2)		--Socks 5
	SetOption("connect_method",2)  --Diku
	--SetAlphaOption("proxy_password",passwd)
	--SetAlphaOption("player",charname)
	--SetAlphaOption("password",passwd)
	SetAlphaOption("port","2700")
end

--*********************************************************
--* intelligent alias for oagk <target>
--*********************************************************
function orderAllGolemKill(name,line,wildcards)
	local isfighting  = false
	local target 	  = wildcards[2]
	local hasgolem 	  = false

	if (target ~= nil) then
		target = Trim(target)
	else
		target = ""
	end

	if (GetVariable("hasgolem") == nil) then
		SetVariable("hasgolem",0)
	elseif (tonumber(GetVariable("hasgolem")) == 1) then
		hasgolem = true
	end
	--Note("hasgolem: "..tostring(hasgolem))

	if (tonumber(GetVariable("isfighting")) == 1) then
		isfighting = true
	end

	if (#target > 0 and hasgolem) then
		if (isfighting) then
			Execute("order all.golem kill "..target)
		else
			Execute("order all.golem kill "..target..";kill "..target)
		end
	elseif (#target > 0 and isfighting == false) then
	  Execute("kill "..target)
	end
end

--*********************************************************
--* intelligent alias for oask <target>
--*********************************************************
function orderAllSpiritKill(name,line,wildcards)
--Execute("order all.spirit kill %2;kill %2")
	local spiritcount = 0
	local isfighting  = false
	local target 	  = wildcards[2]

	if (target ~= nil) then
		target = Trim(target)
	else
		target = ""
	end

	spiritcount = tonumber(GetVariable("spirit_in_room_count"))
	if (tonumber(GetVariable("isfighting")) == 1) then
		isfighting = true
	end

	if (spiritcount > 0 and #target > 0) then
		if (isfighting) then
			Execute("order all.spirit kill "..target)
		else
			Execute("order all.spirit kill "..target..";kill "..target)
		end
	--elseif (isfighting == false) then
		--Execute("kill "..target)
	elseif (spiritcount < 1 and #target > 0 and isfighting == false) then
	  Execute("kill "..target)
	end
end

--*********************************************************
--* increment spirit following
--*********************************************************
function addSpiritCount(name,line,wildcards)
	local spiritcount = 0
	local islegendary = 0
	islegendary = tonumber(GetVariable("islegendary"))
	spiritcount = tonumber(GetVariable("spirit_in_room_count"))
	spiritcount = spiritcount + 1
	if (islegendary == 1) then
		spiritcount = math.min(spiritcount,5)
	else
		spiritcount = math.min(spiritcount,3)
	end
	SetVariable("spirit_in_room_count",spiritcount)
	Note("** Spirit count   : "..spiritcount)
end
--*********************************************************
--* decrement spirt following
--*********************************************************
function subtractSpiritCount(name,line,wildcards)
	local spiritcount = 0
	spiritcount = tonumber(GetVariable("spirit_in_room_count"))
	spiritcount = spiritcount - 1
	spiritcount = math.max(spiritcount,0)
	SetVariable("spirit_in_room_count",spiritcount)
	Note("** Spirit count   : "..spiritcount)
end
--*********************************************************
--* from gas_script trigger group
--*********************************************************
function doGassedCheck(name,line,wildcards)
	--Note("%1".." gassed.")
	local tmpstr = ""
	local ishealbot = false
	local isdruidbot = false
	local isshamanbot = false
	local tryingheal = tonumber(GetVariable("tryingheal"))

	tmpstr = Trim(wildcards[1])

	if (tonumber(GetVariable("isHealbot")) == 1 ) then
	  ishealbot = true
	end

	if (tonumber(GetVariable("isdruidbot")) == 1 ) then
	  isdruidbot = true
	end

	if (tonumber(GetVariable("isShamanbot")) == 1 ) then
	  isshamanbot = true
	end

	if (isTargetInGroup(tmpstr) and (isdruidbot or ishealbot or isshamanbot) and tryingheal == 0) then
	  EnableTriggerGroup("gas_script",false)
	  Execute("gheal")
	end
end

--*********************************************************
--* This will help figure out what spells caster has
--* Not to be confused with a mem tracker
--*********************************************************
function doLoginChecks(name,line,wildcards)
    local charclass = ""
	Execute("trainoff;score;group;fly;spliton;skimoff;equipment")
	Execute("doclearshaman")
	--also getmem;fullstatus
	--combatLines = {}
	SetVariable("isCheckMem",1)
	SetVariable("spirit_in_room_count",0)	--for shaman spirit tracking
	Note("** Mem check      : Enabled")
	charclass = GetVariable("charClass")
	if (charclass == "Druid" or charclass == "Shaman" or charclass == "Paladin"  or charclass == "Cleric"  or charclass == "Dark Knight" or charclass == "Red Robe" or charclass == "Black Robe" or charclass == "White Robe") then
		Execute("spells;mem")
	end
end

--*********************************************************
--* This will help figure out what spells caster has
--* Not to be confused with a mem tracker
--*********************************************************
function doSpell_List(name,line,wildcards)
--wildcards[1]
    local tmpstr = ""
	if (#(Trim(wildcards[2])) == 0) then
		tmpstr = Trim(wildcards[1])
		if (#tmpstr > 20) then
			tmpstr = string.sub(tmpstr,1,20)  --truncate spell strings that exceed certain length
		end
		tmpstr = "spell_"..string.gsub(tmpstr, " ","")
		--Note(tmpstr)
		SetVariable(tmpstr,"1")
	elseif (#(Trim(wildcards[2])) > 0 and #(Trim(wildcards[2])) > 0 and #(Trim(wildcards[3])) > 0 and #(Trim(wildcards[4])) == 0) then
		--1st spell on line
		tmpstr = Trim(wildcards[1])
		if (#tmpstr > 20) then
			tmpstr = string.sub(tmpstr,1,20)  --truncate spell strings that exceed certain length
		end
		tmpstr = "spell_"..string.gsub(tmpstr, " ","")
		SetVariable(tmpstr,"1")
		--Note(tmpstr)
		--2nd spell on line
		tmpstr = Trim(wildcards[2])
		if (#tmpstr > 20) then
			tmpstr = string.sub(tmpstr,1,20)  --truncate spell strings that exceed certain length
		end
		tmpstr = "spell_"..string.gsub(tmpstr, " ","")
		SetVariable(tmpstr,"1")
		--Note(tmpstr)
	elseif (#(Trim(wildcards[2])) > 0 and #(Trim(wildcards[2])) > 0 and #(Trim(wildcards[3])) > 0 and #(Trim(wildcards[4])) > 0) then
		--1st spell on line
		tmpstr = Trim(wildcards[1])
		if (#tmpstr > 20) then
			tmpstr = string.sub(tmpstr,1,20)  --truncate spell strings that exceed certain length
		end
		tmpstr = "spell_"..string.gsub(tmpstr, " ","")
		SetVariable(tmpstr,"1")
		--Note(tmpstr)
		--2nd spell on line
		tmpstr = Trim(wildcards[2])
		if (#tmpstr > 20) then
			tmpstr = string.sub(tmpstr,1,20)  --truncate spell strings that exceed certain length
		end
		tmpstr = "spell_"..string.gsub(tmpstr, " ","")
		SetVariable(tmpstr,"1")
		--Note(tmpstr)
		--3rd spell on line
		tmpstr = Trim(wildcards[4])
		if (#tmpstr > 20) then
			tmpstr = string.sub(tmpstr,1,20)  --truncate spell strings that exceed certain length
		end
		tmpstr = "spell_"..string.gsub(tmpstr, " ","")
		SetVariable(tmpstr,"1")
		--Note(tmpstr)
	end

end

--*********************************************************
--* Resets the spell list
--* This function IDs which spells caster has, not which are memmed or not
--*********************************************************
function resetSpell_List(name,line,wildcards)
    for k,v in pairs (GetVariableList()) do
		if (#Trim(k) > 6 and string.sub(k,1,6) == "spell_") then
			SetVariable(k,0)
		end
	end
	EnableTriggerGroup("spell_list",true)


	--cleric spells
	SetVariable("spell_harm",0)
	SetVariable("spell_heal",0)
	SetVariable("spell_steelskin",0)
	SetVariable("spell_soulleech",0)

	--blackrobe spells
	SetVariable("spell_nightmare",0)
	SetVariable("spell_rend",0)

	--redrobe spells
	SetVariable("spell_thunderbolt",0)
	SetVariable("spell_wizardeye",0)
	SetVariable("spell_shockingblast",0)
	SetVariable("spell_chainlightning",0)
	SetVariable("spell_forcemissile",0)
	SetVariable("spell_powerwordstun",0)

	--shaman spells
	SetVariable("spell_ancestralshroud",0)
	SetVariable("spell_boneshape",0)
	SetVariable("spell_clot",0)
	SetVariable("spell_detectpoison",0)
	SetVariable("spell_satiate",0)
	SetVariable("spell_slowpoison",0)
	SetVariable("spell_spectralglow",0)
	SetVariable("spell_spiritualguidance",0)
	SetVariable("spell_ancestralblessing",0)
	SetVariable("spell_blindness",0)
	SetVariable("spell_cureblindness",0)
	SetVariable("spell_curelight",0)
	SetVariable("spell_curse",0)
	SetVariable("spell_darkenedsoul",0)
	SetVariable("spell_endurance",0)
	SetVariable("spell_removecurse",0)
	SetVariable("spell_sanctifycorpse",0)
	SetVariable("spell_cureserious",0)
	SetVariable("spell_delaydeath",0)
	SetVariable("spell_etherealarmor",0)
	SetVariable("spell_removepoison",0)
	SetVariable("spell_restorestrength",0)
	SetVariable("spell_sapstrength",0)
	SetVariable("spell_spectralsight",0)
	SetVariable("spell_vilespirits",0)
	SetVariable("spell_amplifyspirits",0)
	SetVariable("spell_curedisease",0)
	SetVariable("spell_devouringspirits",0)
	SetVariable("spell_ghostberries",0)
	SetVariable("spell_monstrousmantle",0)
	SetVariable("spell_soulleech",0)
	SetVariable("spell_sublimeresistance",0)
	SetVariable("spell_boilingblood",0)
	SetVariable("spell_curecritical",0)
	SetVariable("spell_ghostmasterritual",0)
	SetVariable("spell_sanctuary",0)
	SetVariable("spell_tenaciousheart",0)
	SetVariable("spell_ancestralspirit",0)
	SetVariable("spell_healingwave",0)
	SetVariable("spell_healboost",0)
	SetVariable("spell_regenerate",0)
	SetVariable("spell_ritualvoyage",0)
	SetVariable("spell_ghostskin",0)
	SetVariable("spell_lastchance",0)

	--druid spells
	SetVariable("spell_barkskin",0)
	SetVariable("spell_granitehand",0)
	SetVariable("spell_coneofcold",0)
	SetVariable("spell_createfood",0)
	SetVariable("spell_createwater",0)
	SetVariable("spell_createwine",0)
	SetVariable("spell_faeriefog",0)
	SetVariable("spell_feast",0)
	SetVariable("spell_gustofwind",0)
	SetVariable("spell_senselife",0)
	SetVariable("spell_summonfaerie",0)
	SetVariable("spell_thornspray",0)
	SetVariable("spell_burninghands",0)
	SetVariable("spell_clearskies",0)
	SetVariable("spell_curelight",0)           --dupe
	SetVariable("spell_faeriefire",0)
	SetVariable("spell_infravision",0)
	SetVariable("spell_refresh",0)
	SetVariable("spell_silence",0)
	SetVariable("spell_stinkingcloud",0)
	SetVariable("spell_sustenance",0)
	SetVariable("spell_waterbreath",0)
	SetVariable("spell_blur",0)
	SetVariable("spell_conjureelemental",0)
	SetVariable("spell_elementalfist",0)
	SetVariable("spell_fly",0)
	SetVariable("spell_removepoison",0)
	SetVariable("spell_resist",0)
	SetVariable("spell_sleep",0)
	SetVariable("spell_stormcall",0)
	SetVariable("spell_stratification",0)
	SetVariable("spell_coneofcold",0)
	SetVariable("spell_earthquake",0)
	SetVariable("spell_enlarge",0)
	SetVariable("spell_flameshroud",0)
	SetVariable("spell_freeaction",0)
	SetVariable("spell_paralysis",0)
	SetVariable("spell_removeparalysis",0)
	SetVariable("spell_rot",0)
	SetVariable("spell_calm",0)
  SetVariable("spell_curemassive",0)  -- new 7th circle as of 3Q18
	SetVariable("spell_cureserious",0)
	SetVariable("spell_daze",0)
	SetVariable("spell_entangle",0)
	SetVariable("spell_icestorm",0)
	SetVariable("spell_iceskin",0)
	SetVariable("spell_massrefresh",0)
	SetVariable("spell_passwithouttrace",0)
	SetVariable("spell_wordofrecall",0)
	SetVariable("spell_calllightning",0)
	SetVariable("spell_charmmonster",0)
	SetVariable("spell_firestorm",0)
	SetVariable("spell_calllightning",0)
	SetVariable("spell_charmmonster",0)
	SetVariable("spell_firestorm",0)
	SetVariable("spell_plantwalk",0)
	SetVariable("spell_summon",0)
	SetVariable("spell_temporalpath",0)
	SetVariable("spell_tornado",0)
	SetVariable("spell_barrier",0)
	SetVariable("spell_cultivate",0)
	SetVariable("spell_curecritical",0)
	SetVariable("spell_granitehand",0)
	SetVariable("spell_iceshield",0)
	SetVariable("spell_insectswarm",0)
	SetVariable("spell_massfly",0)
	SetVariable("spell_primalfury",0)
	SetVariable("spell_prevailingwinds",0)
	SetVariable("spell_stoneskin",0)
	SetVariable("spell_veilofice",0)

end
--*********************************************************
--* generic rounding function
--* https://forums.coronalabs.com/topic/33592-round-a-number-to-the-first-decimal/
--*********************************************************
local function roundNumber(num, n)
  local mult = 10^(n or 0)
  return math.floor(num * mult + 0.5) / mult
end
--*********************************************************
--* this is for autostand and will reduce the over-spam on stand
--*********************************************************
function doAutostandTrack(name,line,wildcards)
	local isstanding    = 1
	local autostand     = 1
    local laststanddiff = 0
	local isdebug       = false
	--tonumber(GetVariable("laststandtime"))
	isstanding = tonumber(GetVariable("isstanding"))
	autostand =  tonumber(GetVariable("autostand"))

	if (tonumber(GetVariable("isdebug")) == 1) then
		isdebug = true
    end

	if (isstanding == 0 and autostand == 1) then
	  laststanddiff = math.abs(os.clock() - tonumber(GetVariable("laststandtime")))
	  laststanddiff = roundNumber(laststanddiff,3)
	  if (math.abs(os.clock() - tonumber(GetVariable("laststandtime"))) > 4) then
	    if (isdebug) then
			Note("** Last stand     : "..tostring(laststanddiff).." secs")
		end
	    Execute("stand")
		SetVariable("laststandtime",os.clock())
	  elseif (isdebug) then
	    Note("** Stand too soon : "..tostring(laststanddiff).." secs")
	  end
	end
end

--*********************************************************
--* setting off the (heal|druid|shaman)bot group health check
--*********************************************************
function do_gheal(name,line,wildcards)
	if (tonumber(GetVariable("tryingheal")) == 0 and (tonumber(GetVariable("isHealbot")) == 1 or tonumber(GetVariable("isdruidbot")) == 1 or tonumber(GetVariable("isShamanbot")) == 1)) then
	  SetVariable("isgheal",1)
	  Send("group")

	end
end
--*********************************************************
--* just for testing differences between os.clock() and socket.gettime()
--* Conclusion: pretty close
--*********************************************************
function doTestClocks(name,line,wildcards)
  require "socket"
  Note("** os.clock(): "..tostring(os.clock()))
  Note("** socket.gettime(): "..tostring(socket.gettime()))

end
--*********************************************************
--* need to keep track of regen time for group members
--*********************************************************
function doTrackRegenTarget(name,line,wildcards)
  local myCharClass = Trim(GetVariable("charClass"))
  local isshamanbot = false

  if (tonumber(GetVariable("isShamanbot")) == 1 ) then
    isshamanbot = true
  end

  --if ((isTargetInGroup(wildcards[1]) or isTargetInList(wildcards[1],"friendly_list")) and string.lower(myCharClass)=="scout") then
  if (isTargetInGroup(wildcards[1]) and string.lower(myCharClass)=="shaman" and isshamanbot) then
    --Execute("doautostand;flap "..wildcards[1])
	SetVariable("lastregen_"..Proper(Trim(wildcards[1])), os.clock())
  end
end

--*********************************************************
--* bash timing
--*********************************************************
function doStandUp(name,line,wildcards)
    local isdebug = false

	if (tonumber(GetVariable("isdebug")) == 1) then
		isdebug = true
    end
	SetVariable("isstanding", 1)

	if (isdebug) then
		Note("** Time between bashes: "..tostring(math.abs(socket.gettime() - tonumber(GetVariable("lastbashtime")))))
	end

	if (tonumber(GetVariable("isbottrain"))==1) then
	  Execute("look")
	end
end

--note 8.3 seconds between bashes
function doBashHit(name,line,wildcards)
	require "socket"
	local isdebug = false

	if (tonumber(GetVariable("isdebug")) == 1) then
		isdebug = true
    end

	if (isdebug) then
		Note("** Time between bashes: "..tostring(math.abs(socket.gettime() - tonumber(GetVariable("lastbashtime")))))
	end

	SetVariable("lastbashtime", tonumber(round(socket.gettime(),3)))
	SetVariable("isstanding",1)
end

--note 8.3 seconds between bashes
function doBashMiss(name,line,wildcards)
	require "socket"
    local isdebug = false

	if (tonumber(GetVariable("isdebug")) == 1) then
		isdebug = true
    end

	if (isdebug) then
		Note("** Time between bashes: "..tostring(math.abs(socket.gettime() - tonumber(GetVariable("lastbashtime")))))
		Note("** laststandtime: "..GetVariable("laststandtime"))
	end

	--manually force it to consider stand beyond 4 second window in doAutostandTrack so condition always evaluates > 4 seconds
	SetVariable("laststandtime", tonumber(GetVariable("laststandtime")) - 4.1)

	Execute("dostand")
	SetVariable("lastbashtime", tonumber(round(socket.gettime(),3)))
end

--*********************************************************
--* self regen track begin
--*********************************************************
function doStartRegenTrack(name,line,wildcards)
  --http://lua-users.org/wiki/OsLibraryTutorial
  local isdebug = false
  local varname = ""
  local charname = Trim(Proper(GetVariable("charname")))

  local currentregenclock = round(socket.gettime(),3)

  if (tonumber(GetVariable("isdebug")) == 1) then
    isdebug = true
  end
  varname = "lastregen_"..charname
  --Note("here: "..varname)

  SetVariable(varname,tostring(os.clock()))
end

--*********************************************************
--* self regen track end
--*********************************************************
function doEndRegenTrack(name,line,wildcards)
  local isdebug = false
  local charname = Trim(Proper(GetVariable("charname")))

  if (tonumber(GetVariable("isdebug")) == 1) then
    isdebug = true
  end

	if (GetVariable("lastregen_"..charname) ~= nil) then   --avoids bug on reconnect due to clearing of regen vars
	  if (isdebug) then
		Note("** Regen duration : "..math.abs(os.clock() - tonumber(GetVariable("lastregen_"..charname))))
	  else
		Note("** Regen duration : "..math.abs(os.clock() - tonumber(GetVariable("lastregen_"..charname))))
	  end
	end
end

--*********************************************************
--* toggles shaman bot
--*********************************************************
function doShamanBotOn(name,line,wildcards)
	EnableTriggerGroup("healbot",true)	--need to enable this trigger group for endheal disables
	SetVariable("isShamanbot",1)
	SetVariable("isCureOn",1)
	SetVariable("isskybot",0)
	SetVariable("isHealbot",0)
	SetVariable("isdruidbot",0)
	SetVariable("ismagebot",0)
	SetVariable("isautobrew",0)
	SetVariable("isautoscribe",0)
	SetVariable("isautotrain",1)
	SetVariable("isautorest",1)
	SetVariable("isautostand",1)
	SetVariable("isautobuff",1)
	SetVariable("isautomeditate",0)
	SetVariable("isMainHealer",1)
	SetVariable("isRandomDelay",0)
	SetVariable("fademode",0)
	Execute("sethdelay 0")
	Execute("compsoff;endheal;shabotstatus;trainoff;buffsstatus;rdelaystatus;nmoff;asson")
	Execute("setengage oask")  --order all.spirit kill logic
	if (tonumber(GetVariable("islegendary")) == 1) then
		Execute("regendur 34")
	else
		Execute("regendur 24.1")
	end
end

--toggles shaman bot off
function doShamanBotOff(name,line,wildcards)
	SetVariable("isShamanbot",0)
	SetVariable("isautotrain",0)
	SetVariable("isautobuff",0)
	SetVariable("isautobrew",0)
	SetVariable("isautoscribe",0)
	Execute("shabotstatus")
end

--shows status of shaman bot
function doShamanBotStatus(name,line,wildcards)
  if (tonumber(GetVariable("isShamanbot")) == 1) then
	Note("** Shaman bot     : Enabled")
  else
	Note("** Shaman bot     : Disabled")
  end

  if (tonumber(GetVariable("healmode")) == 1) then
	Note("** Regen mode     : regen at v.bad")
  elseif (tonumber(GetVariable("healmode")) == 2) then
	Note("** Regen mode     : regen at bad")
  elseif (tonumber(GetVariable("healmode")) == 3) then
    Note("** Regen mode     : regen at fair")
  elseif (tonumber(GetVariable("healmode")) == 4) then
	Note("** Regen mode     : regen for pk")
  end

  if (tonumber(GetVariable("isCureOn")) == 1) then
    Note("** Cure serious   : Enabled")
  else
    Note("** Cure serious   : Disabled")
  end

  Execute("autoreststatus;setmain;assstatus;showhealertype;brewstatus;scribestatus;buffsstatus;sethdelay;regendurstatus")

  Note("** tryingheal     : "..tostring(GetVariable("tryingheal")))
end
--http://www.gammon.com.au/forum/bbshowpost.php?bbsubject_id=4956
function getArcticStats(name, line, wildcards)
	local i, j
	local cmdString
	require "wait"
	local delayCounter
	delayCounter = 0
	for i = 1999,2000,1    do
		for j = 1,1,1 do
			cmdString = "help stat "
			if (j == 1) then
				cmdString = cmdString.."jan "..i
			elseif (j == 2) then
				cmdString = cmdString.."feb "..i
			elseif (j == 3) then
				cmdString = cmdString.."mar "..i
			elseif (j == 4) then
				cmdString = cmdString.."apr "..i
			elseif (j == 5) then
				cmdString = cmdString.."may "..i
			elseif (j == 6) then
				cmdString = cmdString.."jun "..i
			elseif (j == 7) then
				cmdString = cmdString.."jul "..i
			elseif (j == 8) then
				cmdString = cmdString.."aug "..i
			elseif (j == 9) then
				cmdString = cmdString.."sep "..i
			elseif (j == 10) then
				cmdString = cmdString.."oct "..i
			elseif (j == 11) then
				cmdString = cmdString.."nov "..i
			elseif (j == 12) then
				cmdString = cmdString.."dec "..i
			end
		--in 0.5 seconds
			--DoAfterSpecial(tonumber(0),"Note(\""..cmdString.."\")",sendto.script)
			wait.make (function ()
				Note(cmdString)
				wait (1)
			end)
		end --end for j
	end	--end for i
end

-- from James
function pkLoot(corpse)
	corpse = corpse or "corpse"
	local str
	local LtNotLoot = {
		"get all",

		"!waterskin",
		"!canteen",
		"!barrel",
		"!keg",
		"!jug",
		"!firebreather",
		"!food",
		"!bread",
		"!apple",
		"!potatoes",
		"!turkey",
	--	"!sandwich",
		"!ration",
		"!salted",
		"!smoked",
	--	"!lamb",

		"!tablet",
		"!scroll",	-- maybe want scroll for buffs/recalls
		"!blank",
		"!empty",
--		"!bottle",
--		"!potion",	-- maybe want potion
--		"!vial",
		"!milky",
		"!joint",
		"!paper",
		"!kit",
--		"!bandages",
--		"!paste",
--		"!herbs",
--		"!salve",
--		"!quill",
		"!lantern",
		"!light",
--		"!lamp",
		"!torch",
		"!torch",
--		"!key",		-- maybe want key for zone
		"!component",
		"!spiritual",
--		"!training",
		"!corpse",
	}

	if corpse == "room" then
		str = table.concat(LtNotLoot, ".") --.. " in room"
	else
		str = table.concat(LtNotLoot, ".") .. " " .. corpse
	end--if
	Execute(str)
end--pkLoot

function checkPant(name,line,wildcards)
  local myCharClass = Trim(GetVariable("charClass"))
  if ((isTargetInGroup(wildcards[1]) or isTargetInList(wildcards[1],"friendly_list")) and string.lower(myCharClass)=="scout") then
    Execute("doautostand;surge "..wildcards[1])
  end
end
-- This function will examine the eq on character and identify the weapon/offhand
-- For disarm/regrab after recall triggers
function parseEq(name,line,wildcards)
  if (wildcards[1] == "held in secondary hand"
      or wildcards[1] == "used as light"
      or wildcards[1] == "used in primary hand"
	  or wildcards[1] == "used in both hands"
      or wildcards[1] == "used in secondary hand") then
    if (isItemPatternMatchList(Trim(wildcards[2]),"weapons_list")) then
      SetEqWeapHeldVar(wildcards[1],Trim(wildcards[2]),"weapons_list")
    end
  end
end

function doCheckAssault(name,line,wildcards)
  local charclass = GetVariable("charClass")
  local isfighting    = false
  local isautoassault = false
  local islegendary   = false
  local lastassaulttime = 0--tonumber(GetVariable("lastassaulttime"))
  require "socket"
  local currentroundclock = round(socket.gettime(),3)

  if (tonumber(GetVariable("isfighting")) == 1) then
    isfighting = true
  end

  if (GetVariable("lastassaulttime") ~= nil) then
    lastassaulttime = tonumber(GetVariable("lastassaulttime"))
  end

  if (GetVariable("islegendary") ~= nil and tonumber(GetVariable("islegendary")) == 1) then
    islegendary = true
  end

  if (tonumber(GetVariable("isautoassault")) == 1) then
    isautoassault = true
  end

  --don't check for isfighting == true cause might've just punched someone and haven't engaged fight round prompt
  if (isfighting and isautoassault and islegendary and charclass == "Warrior"
      and math.abs(currentroundclock - lastassaulttime) > 60) then
    Execute("doautostand;assault")
  end
end

function doBotCombatSkill(name,line,wildcards)
  local isfighting    = false
  local isdrunk       = false
  local t = {}
  local randomid = 1
  math.randomseed( os.time() )
  math.random(); math.random(); math.random()


  if (tonumber(GetVariable("isfighting")) == 1) then
    isfighting = true
  end

  if (tonumber(GetVariable("isdrunk")) == 1) then
    isdrunk = true
  end

  if (GetVariable("charClass")=="Barbarian") then
    SetTimerOption("botskill_timer","minute","0")
    SetTimerOption("botskill_timer","second","5")
    t = Trim(GetVariable("barb_skill_list")):split(",")
    randomid = math.random(#t)
    --Note("t random: "..t[randomid])
    if (isfighting) then
      if (isdrunk) then
        Send(t[randomid])
      else
        Send("taste all.firebreather in inv")
        Send(t[randomid])
      end
    end
  elseif (GetVariable("charClass")=="Red Robe") then
    SetTimerOption("botskill_timer","minute","1")
    SetTimerOption("botskill_timer","second","0")
    if (isfighting) then
      Send("temporal vision")
    end
  elseif (GetVariable("charClass")=="Paladin") then
    SetTimerOption("botskill_timer","minute","0")
    SetTimerOption("botskill_timer","second","5")
    t = Trim(GetVariable("paladin_skill_list")):split(",")
    randomid = math.random(#t)
    if (isfighting) then
      Send(t[randomid])
    end
	elseif (GetVariable("charClass")=="Scout") then
    SetTimerOption("botskill_timer","minute","0")
    SetTimerOption("botskill_timer","second","7")
    t = Trim(GetVariable("Scout_skill_list")):split(",")
    randomid = math.random(#t)
    if (isfighting) then
      Send(t[randomid])
    end
  elseif (GetVariable("charClass")=="Shaman") then
    SetTimerOption("botskill_timer","minute","0")
    SetTimerOption("botskill_timer","second","12")
    t = Trim(GetVariable("shaman_skill_list")):split(",")
    randomid = math.random(#t)
    if (isfighting) then
      Send(t[randomid])
    end
  elseif (GetVariable("charClass")=="Dark Knight") then
    SetTimerOption("botskill_timer","minute","0")
    SetTimerOption("botskill_timer","second","5")
	if (GetVariable("dk_skill_list") == nil) then
		SetVariable("dk_skill_list","thrust,gaze,impair,drain")
	end
    t = Trim(GetVariable("dk_skill_list")):split(",")
    randomid = math.random(#t)
    if (isfighting) then
      Send(t[randomid])
    end
  elseif (GetVariable("charClass")=="Warrior") then
    SetTimerOption("botskill_timer","minute","0")
    SetTimerOption("botskill_timer","second","5")
    t = Trim(GetVariable("warrior_skill_list")):split(",")
    randomid = math.random(#t)
    if (isfighting) then
      Send(t[randomid])
    end
  end
end

function doSharpenTrain(name,line,wildcards)
  local isfighting = false
  if (tonumber(GetVariable("isfighting")) == 1) then
    isfighting = true
  end
  if (tonumber(GetVariable("isautosharpen"))==1 and not isfighting) then
    Execute("sharpenall")
  elseif (tonumber(GetVariable("isautosharpen"))==1 and isfighting) then
    SetVariable("issharpendelay",1)
  end
end

function doBotTrainTimer(name,line,wildcards)
  local isfighting = false
  local islegendary   = false
  local isguild = false

  if (tonumber(GetVariable("isguild")) == 1) then
    isguild = true
  end

  if (tonumber(GetVariable("isfighting")) == 1) then
    isfighting = true
  end

  if (GetVariable("islegendary") ~= nil and tonumber(GetVariable("islegendary")) == 1) then
    islegendary = true
  end

  if (tonumber(GetVariable("isbottrain")) == 1) then
	  if (GetVariable("charClass")=="Scout") then
		Execute("remove marble.ring;wear marble.ring;rest;band me;st;quell swan;instinct swallow;quell swallow;instinct swan;look;scout n")
	  elseif (GetVariable("charClass") == "Barbarian") then
		--for i = 1,12,1    do
		  --Execute("mend "..tostring(i)..".cap in inv")
		  --Execute("sharpen "..tostring(i)..".dagger in inv")
		  --Execute("lore "..tostring(i)..".cap in inv")
    --end
    --Execute("sharpen 1.dagger in inv")
    --Execute("sharpen 1.knife in inv")
		--Execute("remove troll.bone.ring;wear troll.bone.ring;rest;recup;band me;band me;band me;st;l")
	  elseif (GetVariable("charClass") == "Druid") then
		 Execute("doautostand;drop all.brewed;drop all.scribed;remove marble.ring;wear marble.ring;rest;band me;brew 'cu li';scribe 'cu li';stand;look")
	  elseif (GetVariable("charClass") == "Cleric") then
		 --Execute("doautostand;drop all.scribed;drop all.brewed;rest;brew 'cu li';scribe 'cu li';st;mem;remove compass;grab compass;rest;bandage me;st")
		 Execute("doautostand;drop all.scribed;drop all.brewed;rest;brew 'cu li';scribe 'cu li';st;mem")
	  elseif (GetVariable("charClass")=="Warrior") then
		  Execute("remove marble.ring;wear marble.ring;rest;band me;st;look")
    elseif (GetVariable("charClass")=="Red Robe") then
      SetTimerOption("bottrain_timer","minute","2")
      --Execute("stand;gift;magical;arcane;conjure lead;release lead")
      Execute("stand;arcane barrier")
      if (isguild) then
        Execute("cast 'strength' self;rest;scribe blank 'strength';brew empty 'strength';deep;remove ring;band self;band self;wear ring;stand;look")
      end
    elseif (GetVariable("charClass")=="Paladin") then
      SetTimerOption("bottrain_timer","minute","3")
      --Execute("beseech paladine;divine focus")
      Execute("divine focus")
      --[[
      if (islegendary) then
        Execute("lay "..Trim(GetVariable("maintank")))
      elseif (not islegendary and not isfighting) then
        Execute("lay "..Trim(GetVariable("maintank")))
      end
      --]]
	  end
	end
end

function doBotTrain(name,line,wildcards)
  SetVariable("isbottrain",1)
  Execute("trainstatus;mainme")

  if (GetVariable("charClass")=="Scout") then
    SetTimerOption("bottrain_timer","second","15")
    Execute("camp;wildfire")
  elseif (GetVariable("charClass")=="Barbarian") then
    SetTimerOption("bottrain_timer","second","0")
    SetTimerOption("bottrain_timer","minute","2")
    for i = 1,12,1    do
      Execute("mend "..tostring(i)..".cap in inv")
      --Execute("sharpen "..tostring(i)..".dagger in inv")
      Execute("lore "..tostring(i)..".cap in inv")
    end
    Execute("sharpen 1.dagger in inv")
    Execute("remove troll.bone.ring;wear troll.bone.ring;rest;recup;band me;band me;band me;st;l")
  elseif (GetVariable("charClass")=="Cleric" or GetVariable("charClass")=="Druid" or GetVariable("charClass")=="Black Robe"    or GetVariable("charClass")=="Red Robe" or GetVariable("charClass")=="White Robe") then
    SetTimerOption("bottrain_timer","second","0")
    SetTimerOption("bottrain_timer","minute","2")
    if (GetVariable("charClass") == "Cleric") then
      SetVariable("isHealbot",1)
      Execute("buffson;autoreston;scribeon;brewon;medoff")
    elseif (GetVariable("charClass") == "Druid") then
      SetVariable("isdruidbot",1)
      Execute("fragoff;autoreston;scribeon;brewon")
    end
  end
  EnableTimer("bottrain_timer", true)
end

function doSpiritualHammer(name,line,wildcards)
  local iscombat       = false
  require "socket"
  local currentroundclock = round(socket.gettime(),3)
  local lastroundclock  = 0
  local ishealbot = false
  local charclass = GetVariable("charClass")
  local isstanding   = false
  local spiritualhammercount = 0

  if (GetVariable("lastroundclock")) then
    lastroundclock = tonumber(GetVariable("lastroundclock"))
  end

  if (math.abs(currentroundclock - lastroundclock) < 10) then
    iscombat = true
  end

  if (tonumber(GetVariable("isHealbot")) == 1) then
    ishealbot = true
  end

  if (tonumber(GetVariable("isstanding")) == 1) then
    isstanding = true
  end

  if (GetVariable("spiritualhammercount") ~= nil) then
    spiritualhammercount = tonumber(GetVariable("spiritualhammercount"))
  end

  if (not iscombat and spiritualhammercount > 0 and ishealbot and charclass == "Cleric") then
    Execute("doautostand;cast 'spiritual hammer' ")
  end
end


function doHolyArmor(name,line,wildcards)
  local iscombat       = false
  require "socket"
  local currentroundclock = round(socket.gettime(),3)
  local lastroundclock  = 0
  local ishealbot = false
  local charclass = GetVariable("charClass")
  local isstanding   = false
  local holyarmorcount = 0

  EnableTrigger("holy_armor_trigger",false)
  if (GetVariable("lastroundclock")) then
    lastroundclock = tonumber(GetVariable("lastroundclock"))
  end

  if (math.abs(currentroundclock - lastroundclock) < 10) then
    iscombat = true
  end

  if (tonumber(GetVariable("isHealbot")) == 1) then
    ishealbot = true
  end

  if (tonumber(GetVariable("isstanding")) == 1) then
    isstanding = true
  end

  if (GetVariable("holyarmorcount") ~= nil) then
    holyarmorcount = tonumber(GetVariable("holyarmorcount"))
  end

  if (not iscombat and holyarmorcount > 0 and ishealbot and charclass == "Cleric") then
    Execute("doautostand;cast 'holy armor' ")
  end
end

function speedwalkToFadewalk(speedwalk)
  local t = {}
  local fade_table = {}
  local retvalue = ""

  t = speedwalk:split(";")
  for i,v in ipairs(t) do
    if (Trim(v) == "w" or Trim(v) == "s" or Trim(v) == "e" or Trim(v) == "n" or Trim(v) == "u" or Trim(v) == "d") then
      retvalue = retvalue.."fade "..Trim(v)
    else
      retvalue = retvalue..Trim(v)
    end
    if (i < #t)
      then retvalue = retvalue..";"
    end
  end
  return retvalue
end

--This function helps sets the weapons variables which are mainly used when you are disarmed, or after recall and regrab held item
function SetEqWeapHeldVar(where_worn, item,listname)
  local weapons_list = Trim(GetVariable(listname))
  local t = {}
  t = weapons_list:split(",")
  local word = ""
  for i,v in ipairs(t) do
    word = string.match(item, ".*"..v..".*")
    if (word ~= nil and #word > 0) then
      if (where_worn == "used in primary hand") then
        SetVariable("weap1",v)
      elseif (where_worn == "used in secondary hand" or where_worn == "held in secondary hand" ) then
        SetVariable("weap2",v)
      end
      break
    end
  end
end

--This is a function designed to determine of a list of comma separated items exists in a string, and will return true if a match is found
function isItemPatternMatchList(item,listname)
  local weapons_list = Trim(GetVariable(listname))
  local t = {}
  t = weapons_list:split(",")
  local retvalue = false
  local word = ""
  for i,v in ipairs(t) do
    word = string.match(item, ".*"..v..".*")
    if (word ~= nil and #word > 0) then
      retvalue = true
      break
    end
  end
  return retvalue
end


function isTargetInList(targ,listname)
  retvalue = false
  local listItem = ""
  local isdebug = false
  local listvar =  Trim(GetVariable(listname))
  local t = {}

  if (tonumber(GetVariable("isdebug")) == 1) then
    isdebug = true
  end

  t = listvar:split(",")
  for i, v in ipairs(t) do
    listItem = string.match(v,"([A-Z][a-z]+)")
    if (listItem ~= nil and #listItem > 0 and Trim(Proper(listItem)) == Trim(Proper(targ))) then
      if (isdebug) then Note("isTargetInList("..targ.."): yes") end
      retvalue = true
      break
    end
  end
  return retvalue
end


function Proper(str)
    local result=''
    for word in string.gmatch(str, "%S+") do
        local first = string.sub(word,1,1)
        result = (result .. string.upper(first) ..
                string.lower(string.sub(word,2)) .. ' ')
    end
    return result
end

function isCharTank(charclass)
    local retvalue = false
    if (string.lower(Trim(charclass)) == "dark knight"
            or  string.lower(Trim(charclass)) == "barbarian"
            or  string.lower(Trim(charclass)) == "paladin"
            or  string.lower(Trim(charclass)) == "warrior"
            or  string.lower(Trim(charclass)) == "scout") then
        retvalue = true
    end
    return retvalue
end

function loginMenu()
  require "socket"
  if (not IsConnected()) then
    if (socket.dns.gethostname()=="AMAZONA-HDSPRN5") then
      AddTriggerEx("login_char"
        , "^     | |  | Based on DikuMUD I by Michael Seifert, Sebastian Hammer, |$"
        , "Aemon;xxxxxx;"
        , bit.bor(trigger_flag.Enabled ,trigger_flag.RegularExpression,trigger_flag.OneShot)
        , custom_colour.NoChange, 0, "", "",sendto.execute,100)
    elseif (socket.dns.gethostname()=="NORMSTORM") then
      AddTriggerEx("login_char"
        , "^     | |  | Based on DikuMUD I by Michael Seifert, Sebastian Hammer, |$"
        , "Oligo"
        , bit.bor(trigger_flag.Enabled ,trigger_flag.RegularExpression,trigger_flag.OneShot)
        , custom_colour.NoChange, 0, "", "",sendto.execute,100)
    end
    Connect()
  elseif (IsConnected()) then
    if (GetRecentLines(1)=="What is your character's name?"
            or GetRecentLines(1)=="Type 'start' to create a new character."
            or GetRecentLines(1)=="If you wish to create a new character type 'start'."
            or GetRecentLines(1)=="A name must be at least 2 characters long, and at most 15."
            or GetRecentLines(1)=="Name:") then
      if (socket.dns.gethostname()=="EC2AMAZ-PJRX6XQ") then
        Execute("Aemon;xxxxx;")
      elseif (socket.dns.gethostname()=="NORMSTORM") then
        Execute("Oligo")
      end
    end
  end
end


function isGroupMemberTank(pCharName)
  local retvalue = false
  local groupMemberClass = ""
  local xmlTest = ""
  local t = {}
  local groupMemberName = ""
  local charname = GetVariable("charname")
  --[[
  DA - dark knight
  WA - warrior
  BA - barbarian
  PA - paladin

  CL - cleric
  DR - druid
  SC - scout
  WH - white robe
  RE - red robe
  BL - black robe
  TH - thief
  ]]--

  xmlTest = parseGroupXML()
  t = xmlTest:split("\n")

  for i, v in ipairs(t) do
    groupMemberName, groupMemberClass = string.match(v,"^<char name='([A-Z][a-z]+)' class='([A-Z][A-Z])' imt='[YN]' hits='[a-z%.]+' move='[a-z]+' wb='[YN]' invis='[YN]' here='[YN]' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='[YN]'  />")
    if (groupMemberName ~= nil and groupMemberClass ~= nil and groupMemberName ~= charname) then
      if (groupMemberClass == "DA"
              or groupMemberClass == "WA"
              or groupMemberClass == "BA"
              or groupMemberClass == "PA") then
        if (groupMemberName == pCharName) then
          retvalue = true;
          break
        end     --endif (groupMemberName == pCharName)
      end  --endif DA, WA, BA, PA
    end  --endif not <group> tag or self
  end  --endfor
  return retvalue
end

function getGroupMemberClass(pCharName)
  local retvalue = ""
  local groupMemberClass = ""
  local xmlTest = ""
  local t = {}
  local groupMemberName = ""
  local charname = GetVariable("charname")
  --[[
  DA - dark knight
  WA - warrior
  BA - barbarian
  PA - paladin

  CL - cleric
  DR - druid
  SC - scout
  WH - white robe
  RE - red robe
  BL - black robe
  TH - thief
  ]]--

  xmlTest = parseGroupXML()
  t = xmlTest:split("\n")

  for i, v in ipairs(t) do
    groupMemberName, groupMemberClass = string.match(v,"^<char name='([A-Z][a-z]+)' class='([A-Z][A-Z])' imt='[YN]' hits='[a-z%.]+' move='[a-z]+' wb='[YN]' invis='[YN]' here='[YN]' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='[YN]'  />")
    if (groupMemberName ~= nil and groupMemberClass ~= nil) then --and groupMemberName ~= charname) then
        if (groupMemberName == pCharName) then
          retvalue = groupMemberClass
          break
        end     --endif (groupMemberName == pCharName)
    end  --endif not <group> tag or self
  end  --endfor
  return retvalue
end

function string.ends(String,End)
  return End=='' or string.sub(String,-string.len(End))==End
end

function parseCombatVictim(arg)
  local retvalue = ""
  local tmpstr = arg
  tmpstr = Trim(tmpstr)
  if (string.ends(tmpstr," extremely hard")) then
    tmpstr = string.match(tmpstr, "([A-Za-z %,%.%-%']+) extremely hard")
  elseif (string.ends(tmpstr," very hard")) then
    tmpstr = string.match(tmpstr, "([A-Za-z %,%.%-%']+) very hard")
  elseif (string.ends(tmpstr," hard")) then
    tmpstr = string.match(tmpstr, "([A-Za-z %,%.%-%']+) hard")
  elseif (string.ends(tmpstr,", blasting him") or string.ends(tmpstr,", blasting her") or string.ends(tmpstr,", blasting it")) then
    tmpstr = string.match(tmpstr, "([A-Za-z %,%.%-%']+)%, blasting [heimrt]+")
  else
    --tmpstr = string.sub(tmpstr,1,#tmpstr - 1)
  end
  retvalue = Trim(tmpstr)
  return retvalue
end
------------------------------------------------------------------------------------------------
-- Mob parsing targetting
-- below are some exceptions not yet accounted for in doParseTarget()
------------------------------------------------------------------------------------------------
--[[
  ["hiat tsalm"]       = "hiat",
  ["conclave representative"]   = "guard", --<-- not conclave, or representative
  ["wretched ogre"]      = "ogre",
  ["kapak slavemaster"]     = "master",
  ["grimsoar one-eye"]     = "grimsoar",
  ["zorath blackblade"]     = "zorath",
  ["jaraag urgask"]      = "jaraag",
  ["drowsy green cap"]     = "drowsy",
  --A sweaty Solamnic cavalryman annihilates Baeron with his slash.  --make solamnic, not cavalryman

 --]]
function doParseTarget(arg)
  local retvalue = ""
  local t = {}
  local target = Trim(string.lower(arg))
  local trimmedStart = false

  if (string.sub(target,1,2) == "a ") then         --a bad mother
    trimmedStart = true
    target = Trim(string.sub(target, 2))
  elseif (string.sub(target,1,3) == "an ") then     -- an elven bachelor
    target = Trim(string.sub(target, 3))
    trimmedStart = true
  elseif (string.sub(target,1,4) == "the ") then    -- the elven high druid
    target = Trim(string.sub(target, 4))
    trimmedStart = true
  elseif ((string.sub(target,1,4) == "sir ") or (string.sub(target,1,5) == "lady ") or (string.sub(target,1,5) == "lord ")) then
    target = Trim(string.match(target,"^[sirladyor]+ ([a-z%-%']+).*"))    --Sir Pirvan the Wayward
  elseif (string.sub(target,1,8) == "general ") then
    target = Trim(string.match(target,"^general ([a-z%-%']+).*"))    --General Essovius
  end

  if (not trimmedStart and string.find(target,",")) then                   --need check for comma, etc.
    target = Trim(string.match(target,"^([a-z%-%' ]+),.+$"))                 --Haimya, Lady of the Manor
    if (string.find(target," ")) then                --Gourry Bravesword, Captain of the Lytburg Knights
      --take first word
      target = string.sub(target,1,string.find(target," ")-1)
    end
  end

  if (trimmedStart and string.find(target," of ")) then --a dark knight of takhisis
    target = string.match(target, "([a-z%'%-]+) of ")
  elseif (trimmedStart and string.find(target," ")) then
	if (target == "head gem processor") then			--The Head Gem Processor
		target = "head"
	elseif  (target == "expert ore grade determiner") then			--An expert ore grade determiner
		target = "miner"
	else
		target = string.match(target, "^.+ ([a-z%'%-]+)$") --elven high druid
	end
  elseif (string.find(target," the ")) then  --"Stonearm the blacksmith"
    if (string.match(target, "^([a-z%'%-]+) the .+$")) then
      target = string.match(target, "^([a-z%'%-]+) the .+$")
    else
      target = string.sub(target,1,string.find(target," "))            --Vaughn Hebron the mystic commander
    end
  else
    t = target:split(" ")
    if (#target:split(" ") == 2 and string.find(t[1],"'")) then  --Gargath's guard
      target = Trim(t[2])
    elseif (#target:split(" ") == 2 and string.find(t[2],"'")) then  --Xanitha D'Levinyn
      target = Trim(t[1])
    else
      target = string.gsub(target," ",".")
    end
  end

  retvalue = target
  return retvalue
end

function doGroupWordofRecall(name,line,wildcards)
  local xmlTest =  parseGroupXML()
  local t = {}
  local wordlist = {}
  local wordcharname = ""
  local wordtargetclass = ""
  local myposition = 0
  local priorWorderPos = 0
  local postWorderPos = 0


  if (GetVariable("charClass") == "Cleric" or GetVariable("charClass") == "Druid") then
    -- step 1) determine your position in group
    -- step 2) determine position of druid/healer above you in group (if 1st position skip step)
    -- step 3) determine position of druid/healer below you in group (if last position skip step)
    -- step 4) loop and word from druid/healer above to you and
    -- step 5) loop and word from you to druid/healer below
    -- step 6) word self
    t = xmlTest:split("\n")

    --step 1, find my position
    for i, v in ipairs(t) do
      wordcharname,wordtargetclass = string.match(v,"^<char name='([A-Z][a-z]+)' class='([A-Z][A-Z])' imt='[YN]' hits='[a-z%.]+' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='[YN]'  />")
      --Note(i..": "..charname.."("..charclass..")")
      if (wordcharname ~= nil and #wordcharname > 0 and (wordtargetclass == "DR" or wordtargetclass == "CL") and wordcharname ~= Trim(Proper(GetVariable("charname")))) then
        if (myposition == 0) then
          priorWorderPos = i
        elseif (myposition > 0) then
          if (i < myposition) then
            priorWorderPos = 0
          elseif (i > myposition and postWorderPos == 0) then
            postWorderPos = i
          end
        end
      elseif (wordcharname ~= nil and #wordcharname > 0 and wordcharname == Trim(Proper(GetVariable("charname")))) then
        myposition = i   --ok found my position
      end
    end  --endfor
    --Note("prior worder: "..priorWorderPos..", myposition: "..myposition..", post worder:"..postWorderPos)
    for i, v in ipairs(t) do
      wordcharname = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='[a-z%.]+' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='[YN]'  />")
      if (wordcharname ~= nil and #wordcharname > 0 and myposition > priorWorderPos and i > 1 and (priorWorderPos == 0 or i > priorWorderPos) and wordcharname ~= Trim(Proper(GetVariable("charname")))) then
        if (i < postWorderPos or postWorderPos == 0) then
          table.insert(wordlist,"cast 'word of recall' "..wordcharname..";")
        end
      elseif (wordcharname ~= nil and #wordcharname > 0 and i > myposition  and (i < postWorderPos or postWorderPos == 0) and i > 1 and wordcharname ~= Trim(Proper(GetVariable("charname")))) then
        table.insert(wordlist,"cast 'word of recall' "..wordcharname..";")
      end
    end  --endfor
    table.insert(wordlist,"cast 'word of recall' "..Trim(Proper(GetVariable("charname")))..";")
    Execute(string.sub(table.concat(wordlist),1,#table.concat(wordlist)-1))
  end   --endif "Cleric" or "Druid"
end

function parseGroupXML(name,line,wildcards)
    local tmpParse = ""
    local charName = ""
    local charHits = ""
    local charMV   = ""
    local charPosition = ""
    local charFlying = ""
    local charInvis = ""
    local charWB = ""
    local chariMT = ""
    local charHere = ""
    local charLight = ""
    local charMem = ""
    local groupXML = ""
    local charIsMain = "N"
    local charClass = ""
    local tmp = ""
    local tmpParse = ""
    local sb = {}
    local maintank = Trim(GetVariable("maintank"))
    local wasMainSet = false
    --  Member              Hits      Move      Position  Fly Inv Water iMT Here Light Mem
    --MA Oligo            perfect   rested    standing   Y   N    N    Y   Y     0    0
    table.insert(sb,"<group>")
    if (groupArr ~= nil) then
      for i,v in ipairs(groupArr)
      do
          --print(i,v)
          tmp = Trim(v)
          for j = 1,12,1    do
              if (j == 12) then
                  tmpParse = tmp
              else
                  tmpParse = Trim(string.sub(tmp,1,string.find(tmp, " ")-1))
                  tmp = string.sub(tmp,string.find(tmp, " "), string.len(tmp))
                  tmp = Trim(tmp)
              end
              if (j==1) then
                charClass = tmpParse
              elseif (j==2) then
                  charName = tmpParse
                  if (maintank ~= nil and #maintank > 0 and Trim(charName) == maintank) then
                    charIsMain = "Y"
                    wasMainSet = true
                  else
                    charIsMain = "N"
                  end
              elseif (j==3) then
                  charHits = tmpParse
              elseif (j==4) then
                  charMV = tmpParse
              elseif (j==5) then
                  charPosition = tmpParse
              elseif (j==6) then
                  charFlying = tmpParse
              elseif (j==7) then
                  charInvis = tmpParse
              elseif (j==8) then
                  charWB = tmpParse
              elseif (j==9) then
                  chariMT = tmpParse
              elseif (j==10) then
                  charHere = tmpParse
              elseif (j==11) then
                  charLight = tonumber(tmpParse)
              elseif (j==12) then
                  charMem = tonumber(tmpParse)
              end
          end  --end for

          table.insert(sb,"<char name='"..charName.."' class='"..charClass.."' imt='"..chariMT.."' hits='"..charHits.."' move='"..charMV.."' wb='"..charWB.."' invis='"..charInvis.."' here='"..charHere.."' mem='"..charMem.."' light='"..charLight.."' flying='"..charFlying.."' position='"..charPosition.."' ismain='"..charIsMain.."'  />")
      end
    else
      Note("** Need to type: group")
    end

    if (not wasMainSet) then
      Note("****** WARNING: NO MAIN TANK FOUND IN GROUP ********")
      Note("** syntax : setmain <character>                   **")
      Note("****************************************************")
    end
    table.insert(sb,"</group>")
    return (table.concat(sb,"\n"))
end

function string:split(sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

function isTargetInGroup(targ)
  retvalue = false
  local charname = ""
  local isdebug = false
  local xmlTest =  parseGroupXML()

  if (tonumber(GetVariable("isdebug")) == 1) then
    isdebug = true
  end
  local t = {}
  t = xmlTest:split("\n")
  for i, v in ipairs(t) do
    charname = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='[a-z%.]+' move='[a-z]+' wb='[YN]' invis='[YN]' here='[YN]' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='[YN]'  />")
    if (charname ~= nil and #charname > 0 and charname == Trim(Proper(targ))) then
      if (isdebug) then Note("isTargetInGroup("..targ.."): yes") end
      retvalue = true
      break
    end
  end
  return retvalue
end

function doParseGroupAction(groupAction)
  local xmlTest =  parseGroupXML()
  local charname = GetVariable("charname")
  for charName in string.gmatch(xmlTest,"<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='[a-z%.]+' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='[YN]'  />") do
    if (#charName > 0 and charName ~= Trim(Proper(charname))) then
      Execute(groupAction.." "..charName)
    end
  end
end

function doBandAll()
  local xmlTest =  parseGroupXML()
  local charname = GetVariable("charname")
  local memberHealth = ""
  for charName,memberHealth in string.gmatch(xmlTest,"<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([a-z%.]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='resting' ismain='[YN]'  />") do
    if (#charName > 0 and charName ~= Trim(Proper(charname)) and memberHealth ~= "perfect") then
      Execute("bandage "..charName)
    end
  end
end

--***********************************************************************************************
--* Function leveraged for both healbot, druid, and shaman bot
--* Don't get thrown off by variable name healcount, healcount can also represent regens if shamanbot
--***********************************************************************************************
function doHealLogic(healcount,curemassivecount,curecriticalcount,cureseriouscount,curelightcount,healtarget,hits)
  local tryingheal = 0
  local isshamanbot       = false
  --local curemassivecount = 0    -- temp variable for development - delete

  if (GetVariable("isShamanbot") ~= nil and GetVariable("charClass") ~= nil) then
	  if (tonumber(GetVariable("isShamanbot")) == 1 and GetVariable("charClass") == "Shaman") then
		  isshamanbot = true
	  end
  end

  if (healcount > 0) then
    if (isshamanbot == false) then
		Execute("doautostand;cast 'heal' "..healtarget)
		Note("** HEAL --> "..healtarget.." ("..hits..")")
	elseif (isshamanbot) then
		Execute("doautostand;cast 'regenerate' "..healtarget)
		Note("** REGEN --> "..healtarget.." ("..hits..")")
	end
	SetVariable("healtype",1)
    tryingheal = 1
    SetVariable("tryingheal",1)
  -- *** prioritize cure massive over cure critical for now ******************************
  elseif (curemassivecount > 0) then          --NOTE: DRUID, SHAMAN, CLERIC share remaining spells (except for cure massive as of 3Q18)
    Execute("doautostand;cast 'cure massive' "..healtarget)
    Note("** CURE MASSIVE --> "..healtarget.." ("..hits..")")
	  SetVariable("healtype",5)
    tryingheal = 1
    SetVariable("tryingheal",1)
  elseif (curecriticalcount > 0) then          --NOTE: DRUID, SHAMAN, CLERIC share remaining spells (except for cure massive as of 3Q18)
    Execute("doautostand;cast 'cure critical' "..healtarget)
    Note("** CURE CRITICAL --> "..healtarget.." ("..hits..")")
	  SetVariable("healtype",2)
    tryingheal = 1
    SetVariable("tryingheal",1)
  elseif (cureseriouscount > 0) then
    Execute("doautostand;cast 'cure serious' "..healtarget)
    SetVariable("healtype",3)
    Note("** CURE SERIOUS --> "..healtarget.." ("..hits..")")
    tryingheal = 1
    SetVariable("tryingheal",1)
  elseif (curelightcount > 0) then
    Execute("doautostand;cast 'cure light' "..healtarget)
    SetVariable("healtype",4)
    Note("** CURE LIGHT --> "..healtarget.." ("..hits..")")
    tryingheal = 1
    SetVariable("tryingheal",1)
  end
  return tryingheal
end


function showGroupXML()
    local xmlTest

    xmlTest = parseGroupXML()
    print(xmlTest)
end
--**********************************************************************
--* This is the heal prioritization logic for healer, druid, shaman including regen tracking
--**********************************************************************
function healGroupParse()
  local HEAL_FAIR         = 3
  local HEAL_BAD          = 2
  local HEAL_VBAD         = 1
  local HEAL_PK           = 4
  local isMainHealer      = true
  local healcount         = 0
  local curecriticalcount = 0
  local cureseriouscount  = 0
  local curelightcount    = 0
  local curemassivecount  = 0        -- for druid as of 3Q18
  local tryingheal        = 0        --for healer/druid/shaman
  local tryingregen       = 0        --for shaman
  local isstanding        = true
  local charname          = ""
  local charName          = ""
  local maintank          = ""
  local xmlTest           = ""
  local health            = ""
  local target            = ""
  local healMode          = HEAL_BAD
  local charcount         = 0
  local randomid          = 1
  local maintankhealth    = ""
  local isCureOn          = true
  local isshamanbot       = false
  local isDruidBot        = false

  --for shaman bot
  local regeneratecount	     = 0
  local healboostcount       = 0
  local ritualvoyagecount    = 0
  local ancestralspiritcount = 0
  local zombifycount 		 = 0
  local darkenedsoulcount    = 0
  --for tracking if last regen time exceeds threshhold
  local lastregen_target     = 0
  local regen_threshhold     = 0
  local isRegenExpired	     = true -- better to default to true, because lastregen_<target> may not exist as variable

  if (GetVariable("regen_threshhold") ~= nil) then
	   regen_threshhold = tonumber(GetVariable("regen_threshhold"))
  end

  if (GetVariable("regeneratecount") ~= nil) then
	   regeneratecount = tonumber(GetVariable("regeneratecount"))
  end
  if (GetVariable("healboostcount") ~= nil) then
	   healboostcount = tonumber(GetVariable("healboostcount"))
  end
  if (GetVariable("ritualvoyagecount") ~= nil) then
	   ritualvoyagecount = tonumber(GetVariable("ritualvoyagecount"))
  end
  if (GetVariable("ancestralspiritcount") ~= nil) then
	   ancestralspiritcount   = tonumber(GetVariable("ancestralspiritcount"))
  end
  if (GetVariable("zombifycount") ~= nil) then
	   zombifycount = tonumber(GetVariable("zombifycount"))
  end
  if (GetVariable("darkenedsoulcount") ~= nil) then
	   darkenedsoulcount = tonumber(GetVariable("darkenedsoulcount"))
  end

  --total since regen is divine spell
  regeneratecount = regeneratecount + healboostcount + ritualvoyagecount + ancestralspiritcount + zombifycount + darkenedsoulcount

  math.randomseed( os.time() )
  math.random(); math.random(); math.random()
  healcount         = tonumber(GetVariable("healcount"))
  curecriticalcount = tonumber(GetVariable("curecriticalcount"))
  curemassivecount  = tonumber(GetVariable("curemassivecount"))
  cureseriouscount  = tonumber(GetVariable("cureseriouscount"))
  curelightcount    = tonumber(GetVariable("curelightcount"))
  charname = Trim(GetVariable("charname"))
  xmlTest = parseGroupXML()

  healMode   = tonumber(GetVariable("healmode"))
  tryingheal = tonumber(GetVariable("tryingheal"))

  --determine if shaman bot enabled
  if (tonumber(GetVariable("isShamanbot")) == 1 and GetVariable("charClass") == "Shaman") then
    isshamanbot = true
	  healcount   = regeneratecount
  end

  --determine if druid bot enabled
  if (tonumber(GetVariable("isdruidbot")) == 1 and GetVariable("charClass") == "Druid") then
    isDruidBot = true
    isshamanbot = false
	  healcount   = 0
  end

  if (tonumber(GetVariable("isCureOn")) == 1) then
    isCureOn = true
  else
    isCureOn = false
  end

  if (tonumber(GetVariable("isMainHealer")) == 1) then
    isMainHealer = true
  elseif (tonumber(GetVariable("isMainHealer")) == 0) then
    isMainHealer = false
  end

  if (tonumber(GetVariable("isstanding")) == 1) then
    isstanding = true
  elseif (tonumber(GetVariable("isstanding")) == 0) then
    isstanding = false
  end

  if (#groupArr <= 1) then
    SetVariable("maintank",charname)
  end
  maintank = GetVariable("maintank")

  local t = {}
  t = xmlTest:split("\n")
  --Note(xmlTest)
  --##################################################
  --## note: for shaman healcount = regeneratecount
  --##################################################
  --## Step 1 : Check main tank
  --##################################################
  for i, v in ipairs(t) do
    --target,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([a-z%.]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='Y'  />")
    target,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([a-z%.]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='Y'  />")
    if (target ~= nil and health ~= nil and #target > 0 and #health > 0) then
      break
    end
  end -- end of the for loop
  maintankhealth = health

  --if (target ~= nil and health ~= nil and #target > 0 and #health > 0 and isMainHealer and tryingheal == 0) then
  --if (target ~= nil and health ~= nil and #target > 0 and #health > 0 and tryingheal == 0 and (GetVariable("charClass") == "Cleric" or (isDruidBot and isCureOn) or isshamanbot)) then
  if (target ~= nil and health ~= nil and #target > 0 and #health > 0 and tryingheal == 0 and (GetVariable("charClass") == "Cleric" or isDruidBot or isshamanbot)) then
	--need to put lastregen_<target> check in this block of code because target might be nil outside of it
	  if (isshamanbot and GetVariable("lastregen_"..target) ~= nil) then
  		lastregen_target = tonumber(GetVariable("lastregen_"..target))
  		--Note("lastregen_target: "..lastregen_target)
  		if ((os.clock() - lastregen_target) > regen_threshhold) then
  			isRegenExpired = true
  		else
  			isRegenExpired = false
  		end
	  end
	if (healMode == HEAL_VBAD) then
      if (tryingheal == 0 and (string.lower(health) == "v.bad" or string.lower(health) == "awful" or string.lower(health) == "dying")) then
    		if (isshamanbot == false or (isshamanbot and isRegenExpired)) then
    			tryingheal = doHealLogic(healcount, curemassivecount, curecriticalcount, cureseriouscount, curelightcount, target, health)
    		elseif (isRegenExpired == false and isshamanbot) then
    			tryingheal = doHealLogic(0, 0, curecriticalcount, cureseriouscount, curelightcount, target, health)
    		end
      end
    elseif (healMode == HEAL_BAD) then
      if (tryingheal == 0 and (string.lower(health) == "bad" or string.lower(health) == "v.bad" or string.lower(health) == "awful" or string.lower(health) == "dying")) then
    		if (isshamanbot == false or (isshamanbot and isRegenExpired)) then
    			tryingheal = doHealLogic(healcount, curemassivecount, curecriticalcount, cureseriouscount, curelightcount, target, health)
    		elseif (isRegenExpired == false and isshamanbot) then
    			tryingheal = doHealLogic(0, 0, curecriticalcount, cureseriouscount, curelightcount, target, health)
    		end
      end
    elseif (healMode == HEAL_FAIR) then
      if (tryingheal == 0 and (string.lower(health) == "fair" or string.lower(health) == "bad" or string.lower(health) == "v.bad" or string.lower(health) == "awful" or string.lower(health) == "dying")) then
    		if (isshamanbot == false or (isshamanbot and isRegenExpired)) then
    			tryingheal = doHealLogic(healcount,curemassivecount, curecriticalcount, cureseriouscount, curelightcount, target, health)
    		elseif (isRegenExpired == false and isshamanbot) then
    			tryingheal = doHealLogic(0, 0, curecriticalcount, cureseriouscount, curelightcount, target, health)
    		end
      end
    elseif (healMode == HEAL_PK) then
      if (tryingheal == 0 and (string.lower(health) == "bad" or string.lower(health) == "v.bad" or string.lower(health) == "awful" or string.lower(health) == "dying")) then
    		if (isshamanbot == false or (isshamanbot and isRegenExpired)) then
    			tryingheal = doHealLogic(healcount, curemassivecount, curecriticalcount, cureseriouscount, curelightcount, target, health)
    		elseif (isRegenExpired == false and isshamanbot) then
    			tryingheal = doHealLogic(0, 0, curecriticalcount, cureseriouscount, curelightcount, target, health)
    		end
      end
    end
  end
  --**************************************************
  --** Step 2 : Check 'dying' or 'awful' ([adfgilnuwy]+)
  --**************************************************
  if (tryingheal == 0) then
    charcount = 0
    for i, v in ipairs(t) do
      target,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([adfgilnuwy]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='[YN]'  />")
      if (target ~= nil and health ~= nil and #target > 0 and #health > 0) then
        charcount = charcount + 1
      end
    end
    if (charcount > 1) then
      randomid = math.random(charcount)
    else
      randomid = 1
    end
    charcount = 0
    for i, v in ipairs(t) do
      charName,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([adfgilnuwy]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='[YN]'  />")
      if (charName ~= nil and #charName > 0) then
        charcount = charcount + 1
        target = charName

		--this logic to determine when regen was last cast on target
	    if (isshamanbot and GetVariable("lastregen_"..target) ~= nil) then
		  lastregen_target = tonumber(GetVariable("lastregen_"..target))
		    --Note("lastregen_target: "..lastregen_target)
  		  if ((os.clock() - lastregen_target) > regen_threshhold) then
  			isRegenExpired = true
  		  else
  		    isRegenExpired = false
  		  end
	    end

        if (charcount == randomid) then
    			if (isshamanbot == false or (isshamanbot and isRegenExpired)) then
    				tryingheal = doHealLogic(healcount, curemassivecount, curecriticalcount, cureseriouscount, curelightcount, target, health)
    			elseif (isRegenExpired == false and isshamanbot) then
    				tryingheal = doHealLogic(0, 0, curecriticalcount, cureseriouscount, curelightcount, target, health)
    			end
			    break
        end
      end
    end
  end
  --**************************************************
  --** Step 3 : Check SELF 'bad','awful','v.bad' [abdfluvw%.]+
  --**************************************************
  if (tryingheal == 0) then
    for i, v in ipairs(t) do
      target,health = string.match(v,"^<char name='("..charname..")' class='[A-Z][A-Z]' imt='[YN]' hits='([abdfluvw%.]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='[YN]'  />")
      if (target ~= nil and health ~= nil and #target > 0 and #health > 0 and target == charname) then

		--this logic to determine when regen was last cast on target
	    if (isshamanbot and GetVariable("lastregen_"..target) ~= nil) then
		  lastregen_target = tonumber(GetVariable("lastregen_"..target))
		  --Note("lastregen_target: "..lastregen_target)
  		  if ((os.clock() - lastregen_target) > regen_threshhold) then
  			isRegenExpired = true
  		  else
  		    isRegenExpired = false
  		  end
	    end

			if (isshamanbot == false or (isshamanbot and isRegenExpired)) then
				tryingheal = doHealLogic(healcount, curemassivecount, curecriticalcount, cureseriouscount, curelightcount, target, health)
			elseif (isRegenExpired == false and isshamanbot) then
				tryingheal = doHealLogic(0, 0, curecriticalcount, cureseriouscount, curelightcount, target, health)
			end
        break
      end
    end
  end

  --**************************************************
  --** Step 4 : Check v.bad                 **********
  --**************************************************
  if (tryingheal == 0) then
    --Note("in v.bad")
    charcount = 0
    for i, v in ipairs(t) do
      charName, health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='(v%.bad)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='N'  />")
      if (charName ~= nil and health ~= nil and #charName > 0 and #health > 0) then
        charcount = charcount + 1
      end
    end
    if (charcount > 1) then
      randomid = math.random(charcount)
    else
      randomid = 1
    end
    charcount = 0
      for i, v in ipairs(t) do
        charName, health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='(v%.bad)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='N'  />")
        if (charName ~= nil and #charName > 0) then
          charcount = charcount + 1
          target = charName

			--this logic to determine when regen was last cast on target
		  if (isshamanbot and GetVariable("lastregen_"..target) ~= nil) then
  			lastregen_target = tonumber(GetVariable("lastregen_"..target))
  			if ((os.clock() - lastregen_target) > regen_threshhold) then
  			  isRegenExpired = true
  			else
  			  Note("** lastregen_"..target..": "..tostring(os.clock() - lastregen_target))
  			  isRegenExpired = false
  			end
		  end

          if (charcount == randomid) then
      			if (isshamanbot == false or (isshamanbot and isRegenExpired)) then
      				tryingheal = doHealLogic(healcount, curemassivecount, curecriticalcount, cureseriouscount, curelightcount, target, health)
      			elseif (isRegenExpired == false and isshamanbot) then
      				tryingheal = doHealLogic(0, 0, curecriticalcount, cureseriouscount, curelightcount, target, health)
      			end
            break
          end
        end
      end
   -- end
  end
  --**************************************************
  --** Step 5 : Check bad                   **********
  --**************************************************
  if (tryingheal == 0) then
    charcount = 0
    for i, v in ipairs(t) do
      charName, health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='(bad)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='N'  />")
      if (charName ~= nil and health ~= nil and #charName > 0 and #health > 0) then
        charcount = charcount + 1
      end
    end
    if (charcount > 1) then
      randomid = math.random(charcount)
    else
      randomid = 1
    end
    charcount = 0
      for i, v in ipairs(t) do
        charName,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='(bad)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='N'  />")
        if (charName ~= nil and #charName > 0) then
          charcount = charcount + 1
          target = charName

    			--this logic to determine when regen was last cast on target
    			if (isshamanbot and GetVariable("lastregen_"..target) ~= nil) then
    			  lastregen_target = tonumber(GetVariable("lastregen_"..target))
    			  --Note("lastregen_target: "..lastregen_target)
    			  if ((os.clock() - lastregen_target) > regen_threshhold) then
    				isRegenExpired = true
    			  else
    				isRegenExpired = false
    			  end
    			end

          if (charcount == randomid) then
      			if (isshamanbot == false or (isshamanbot and isRegenExpired)) then
      				tryingheal = doHealLogic(healcount, curemassivecount, curecriticalcount, cureseriouscount, curelightcount, target, health)
      			elseif (isRegenExpired == false and isshamanbot) then
      				tryingheal = doHealLogic(0, 0, curecriticalcount, cureseriouscount, curelightcount, target, health)
      			end
            break
          end
        end
      end
  end
  --**************************************************
  --** Step 6 : Check fair                  **********
  --**************************************************
  if (tryingheal == 0) then
    charcount = 0
    for i, v in ipairs(t) do
      charName, health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='(fair)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='N'  />")
      if (charName ~= nil and health ~= nil and #charName > 0 and #health > 0) then
        charcount = charcount + 1
      end
    end
    if (charcount > 1) then
      randomid = math.random(charcount)
    else
      randomid = 1
    end
    charcount = 0
    if (not isMainHealer or (isMainHealer and maintankhealth ~= "fair" and maintankhealth ~= "bad" and maintankhealth ~= "v.bad" and maintankhealth ~= "awful" and maintankhealth ~= "dying")) then
      for i, v in ipairs(t) do
        charName, health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='(fair)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='N'  />")
        if (charName ~= nil and #charName > 0) then
          charcount = charcount + 1
          target = charName
          if (charcount == randomid) then
            if (curecriticalcount > 0) then
              Execute("doautostand;cast 'cure critical' "..target)
              SetVariable("healtype",2)
              Note("** CURE CRITICAL --> "..target.." ("..health..")")
              tryingheal = 1
              SetVariable("tryingheal",1)
            elseif (cureseriouscount > 0) then
              Execute("doautostand;cast 'cure serious' "..target)
              SetVariable("healtype",3)
              Note("** CURE SERIOUS --> "..target.." ("..health..")")
              tryingheal = 1
              SetVariable("tryingheal",1)
            elseif (curelightcount > 0) then
              Execute("doautostand;cast 'cure light' "..target)
              SetVariable("healtype",4)
              Note("** CURE LIGHT --> "..target.." ("..health..")")
              tryingheal = 1
              SetVariable("tryingheal",1)
            end
            break
          end
        end
      end
    end
  end
  --**************************************************
  --** Step 7 : Check good                  **********
  --**************************************************
  if (tryingheal == 0 and isCureOn == true) then
    charcount = 0
     for i, v in ipairs(t) do
      charName,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='(good)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='N'  />")
      if (charName ~= nil and health ~= nil and #charName > 0 and #health > 0) then
        charcount = charcount + 1
      end
    end
    if (charcount > 1) then
      randomid = math.random(charcount)
    else
      randomid = 1
    end
    charcount = 0
    if (not isMainHealer or (isMainHealer and maintankhealth ~= "fair" and maintankhealth ~= "bad" and maintankhealth ~= "v.bad" and maintankhealth ~= "awful" and maintankhealth ~= "dying")) then
      for i, v in ipairs(t) do
        charName, health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='(good)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='N'  />")
        if (charName ~= nil and #charName > 0) then
          charcount = charcount + 1
          target = charName
          if (charcount == randomid) then
            if (cureseriouscount > 0) then
              Execute("doautostand;cast 'cure serious' "..target)
              SetVariable("healtype",3)
              Note("** CURE SERIOUS --> "..target.." ("..health..")")
              tryingheal = 1
              SetVariable("tryingheal",1)
            elseif (curelightcount > 0) then
              Execute("doautostand;cast 'cure light' "..target)
              SetVariable("healtype",4)
              Note("** CURE LIGHT --> "..target.." ("..health..")")
              tryingheal = 1
              SetVariable("tryingheal",1)
            end
            break
          end
        end
      end
    end
  end
  --**************************************************
  --** End Check good - toggleable with cureon/cureoff
  --**************************************************
end

function doAutoFrag(name,lines,wildcards)
  local isautofrag = false
  local charclass = GetVariable("charClass")
  local target1 = ""
  local lastcasttime = 0
  require "socket"
  --local currentroundclock = round(socket.gettime(),3)

  if (GetVariable("isautofrag") ~= nil) then
    isautofrag = tonumber(GetVariable("isautofrag"))
  end
  if (GetVariable("target1") ~= nil) then
    target1 = GetVariable("target1")
  end
  if (GetVariable("lastcasttime") ~= nil) then
    lastcasttime = tonumber(GetVariable("lastcasttime"))
  end

  -- druid frags
  local calllightningcount, granitehandcount, elementalfistcount, thornspraycount = 0, 0, 0, 0
  local flameshroudcount, coneofcoldcount , firestormcount, burninghandscount = 0, 0, 0, 0
  -- redrobe mage frags
  local acidblastcount, lightningboltcount ,shockinggraspcount ,magicmissilecount = 0,0,0,0
  local forceboltcount, magicblastcount, shockingblastcount, forcemissilecount = 0,0,0,0
  local thunderboltcount, chainlightningcount = 0,0
   -- blackrobe mage frags
  local acidburncount, paincount, magicboltcount, devastationcount = 0,0,0,0
  local fireballcount = 0
  -- whiterobe mage frags
  local arcanelashcount,scorchcount,arcanespearcount = 0,0,0

  -- initialize black robe frags
  if (GetVariable("acidburncount") ~= nil) then
  	acidburncount = tonumber(GetVariable("acidburncount"))
  end
  if (GetVariable("paincount") ~= nil) then
  	paincount = tonumber(GetVariable("paincount"))
  end
  if (GetVariable("magicboltcount") ~= nil) then
  	magicboltcount = tonumber(GetVariable("magicboltcount"))
  end
  if (GetVariable("fireballcount") ~= nil) then
  	fireballcount = tonumber(GetVariable("fireballcount"))
  end
  if (GetVariable("devastationcount") ~= nil) then
  	devastationcount = tonumber(GetVariable("devastationcount")) > 0 and 1 or 0
  end

  -- initialize red robe frags
  if (GetVariable("chainlightningcount") ~= nil) then
    chainlightningcount = tonumber(GetVariable("chainlightningcount"))
  end
  if (GetVariable("thunderboltcount") ~= nil) then
    thunderboltcount = tonumber(GetVariable("thunderboltcount"))
  end
  if (GetVariable("forceboltcount") ~= nil) then
    forceboltcount = tonumber(GetVariable("forceboltcount"))
  end
  if (GetVariable("magicblastcount") ~= nil) then
    magicblastcount = tonumber(GetVariable("magicblastcount"))
  end
  if (GetVariable("shockingblastcount") ~= nil) then
    shockingblastcount = tonumber(GetVariable("shockingblastcount"))
  end
  if (GetVariable("forcemissilecount") ~= nil) then
    forcemissilecount = tonumber(GetVariable("forcemissilecount"))
  end
  if (GetVariable("acidblastcount") ~= nil) then
    acidblastcount = tonumber(GetVariable("acidblastcount"))
  end
  if (GetVariable("lightningboltcount") ~= nil) then
    lightningboltcount = tonumber(GetVariable("lightningboltcount"))
  end
  if (GetVariable("shockinggraspcount") ~= nil) then
    shockinggraspcount = tonumber(GetVariable("shockinggraspcount"))
  end
  if (GetVariable("magicmissilecount") ~= nil) then
    magicmissilecount = tonumber(GetVariable("magicmissilecount"))
  end
  -- initialize white robe frags
  if (GetVariable("arcanelashcount") == nil) then
	SetVariable("arcanelashcount",0)
  end
  arcanelashcount = tonumber(GetVariable("arcanelashcount"))

  if (GetVariable("scorchcount") == nil) then
	SetVariable("scorchcount",0)
  end
  scorchcount = tonumber(GetVariable("scorchcount"))

  if (GetVariable("arcanespearcount") == nil) then
	SetVariable("arcanespearcount",0)
  end
  arcanespearcount = tonumber(GetVariable("arcanespearcount"))

  -- initialize druid frags
  if (GetVariable("calllightningcount") ~= nil) then
    calllightningcount = tonumber(GetVariable("calllightningcount"))
  end
  if (GetVariable("granitehandcount") ~= nil) then
    granitehandcount = tonumber(GetVariable("granitehandcount"))
  end
  if (GetVariable("elementalfistcount") ~= nil) then
    elementalfistcount = tonumber(GetVariable("elementalfistcount"))
  end
  if (GetVariable("thornspraycount") ~= nil) then
    thornspraycount = tonumber(GetVariable("thornspraycount"))
  end
  if (GetVariable("flameshroudcount") ~= nil) then
    flameshroudcount = tonumber(GetVariable("flameshroudcount"))
  end
  if (GetVariable("coneofcoldcount") ~= nil) then
    coneofcoldcount = tonumber(GetVariable("coneofcoldcount"))
  end
  if (GetVariable("firestormcount") ~= nil) then
    firestormcount = tonumber(GetVariable("firestormcount"))
  end
  if (GetVariable("burninghandscount") ~= nil) then
    burninghandscount = tonumber(GetVariable("burninghandscount"))
  end

  if (charclass == "Red Robe" and isautofrag and math.abs(socket.gettime() - lastcasttime) > 3.9) then
    if (chainlightningcount > 0) then
      Execute("doautostand;cast 'chain lightning' "..target1)
    elseif (thunderboltcount > 0 ) then
      Execute("doautostand;cast 'thunderbolt' "..target1)
    elseif (forcemissilecount > 0 ) then
      Execute("doautostand;cast 'force missile' "..target1)
    elseif (forceboltcount > 0) then
      Execute("doautostand;cast 'force bolt' "..target1)
    elseif (magicblastcount > 0) then
      Execute("doautostand;cast 'magic blast' "..target1)
    elseif (shockingblastcount > 0) then
      Execute("doautostand;cast 'shocking blast' "..target1)
    elseif (acidblastcount > 0) then
      Execute("doautostand;cast 'acid blast' "..target1)
    elseif (lightningboltcount > 0) then
      Execute("doautostand;cast 'lightning bolt' "..target1)
    elseif (shockinggraspcount > 0) then
      Execute("doautostand;cast 'shocking grasp' "..target1)
    elseif (magicmissilecount > 0) then
      Execute("doautostand;cast 'magic missile' "..target1)
    else
      Execute("fragoff")
    end
  elseif (charclass == "Druid" and isautofrag and math.abs(socket.gettime() - lastcasttime) > 3.9) then
    if (granitehandcount > 0) then
      Execute("doautostand;cast 'granite hand' "..target1)
    elseif (firestormcount > 0 ) then
      Execute("doautostand;cast 'fire storm' "..target1)
    elseif (coneofcoldcount > 0 ) then
      Execute("doautostand;cast 'cone of cold' "..target1)
    elseif (flameshroudcount > 0 ) then
      Execute("doautostand;cast 'flame shroud' "..target1)
    elseif (elementalfistcount > 0 ) then
      Execute("doautostand;cast 'elemental fist' "..target1)
    elseif (burninghandscount > 0 ) then
      Execute("doautostand;cast 'burning hands' "..target1)
    elseif (thornspraycount > 0 ) then
      Execute("doautostand;cast 'thorn spray' "..target1)
    else
      Execute("fragoff")
    end
  elseif (charclass == "White Robe" and isautofrag and math.abs(socket.gettime() - lastcasttime) > 3.9) then
    if (arcanelashcount > 0) then
      Execute("doautostand;cast 'arcane lash' "..target1)
    elseif (scorchcount > 0 ) then
      Execute("doautostand;cast 'scorch' "..target1)
    elseif (arcanespearcount > 0 ) then
      Execute("doautostand;cast 'arcane spear' "..target1)
    elseif (magicblastcount > 0) then
      Execute("doautostand;cast 'magic blast' "..target1)
    elseif (magicboltcount > 0) then
      Execute("doautostand;cast 'magic bolt' "..target1)
    elseif (lightningboltcount > 0) then
      Execute("doautostand;cast 'lightning bolt' "..target1)
    elseif (shockinggraspcount > 0) then
      Execute("doautostand;cast 'shocking grasp' "..target1)
    elseif (magicmissilecount > 0) then
      Execute("doautostand;cast 'magic missile' "..target1)
    else
      Execute("fragoff")
    end
  elseif (charclass == "Black Robe" and isautofrag and math.abs(socket.gettime() - lastcasttime) > 3.9) then
    if (devastationcount > 0) then
      Execute("doautostand;cast 'devastation' "..target1)
    elseif (paincount > 0 ) then
      Execute("doautostand;cast 'pain' "..target1)
    elseif (acidburncount > 0 ) then
      Execute("doautostand;cast 'acid burn' "..target1)
    elseif (magicboltcount > 0) then
      Execute("doautostand;cast 'magic bolt' "..target1)
    elseif (lightningboltcount > 0) then
      Execute("doautostand;cast 'lightning bolt' "..target1)
    elseif (shockinggraspcount > 0) then
      Execute("doautostand;cast 'shocking grasp' "..target1)
    elseif (magicmissilecount > 0) then
      Execute("doautostand;cast 'magic missile' "..target1)
    else
      Execute("fragoff")
    end
  end
end

function doJet(name,lines,wildcards)
	local charclass = GetVariable("charClass")
	local charname = GetVariable("charname")

	Execute("assoff;bashoff;rescueoff;pbotoff;hbotoff;dbotoff;mbotoff;shabotoff;btrainoff")
	Execute("skybotoff;lootoff;splitoff;fragoff;autorestoff;assaultoff;skilloff;trainoff;burstoff")
	Execute("cancel;get recall "..GetVariable("container"))
	Send("recite recall")

	if (charclass ~= nil and #charclass > 0 and charclass == "Scout") then
	  Send("grab bow")
	elseif (charname == "Iopiomofi") then
	  Send("grab orb")
	elseif (charname == "Royderage") then
	  Send("grab tablet.blackened.wood")
	elseif (charname == "Yhonk") then
	  Send("grab mithril.compass")
	end
end

function snoopChar(name,lines,wildcards)
  local snooplines = 25
  local snooptarget = ""
  local charname = GetVariable("charname")
  local xmlstr = ""
  if (wildcards ~= nil  and #wildcards > 0) then
    if (wildcards[1] ~= nil and #wildcards[1] > 0) then
      snooplines = tonumber(wildcards[1])
    end
    if (wildcards ~= nil and #wildcards == 2 and #Trim(wildcards[2])>0) then
      xmlstr = CreateXMLMsg("SNOOP","<target>"..Trim(Proper(wildcards[2])).."</target><requestor>"..charname.."</requestor><lines>"..tostring(snooplines).."</lines>")
      if (IsSocketConnected()) then
        assert(c:send(xmlstr.."\\n"))
      else
        Note("** Not connected to clan server.")
      end
    else
      Note("** syntax: snoop   <target>")
      Note("** syntax: snoop## <target>")
    end
  end
end

function checkAreaDmg(name,lines,wildcards)
  local ishealbot = false
  local isdruidbot = false
  local charclass = GetVariable("charClass")
  local veiloficecount = tonumber(GetVariable("veiloficecount"))
  local lastveiltime = tonumber(GetVariable("lastveiltime"))
  local isstanding   = false
  require "socket"
  local currentroundclock = round(socket.gettime(),3)

  if (tonumber(GetVariable("isHealbot")) == 1) then
    ishealbot = true
  end
  if (tonumber(GetVariable("isstanding")) == 1) then
    isstanding = true
  end
  if (tonumber(GetVariable("isdruidbot")) == 1) then
    isdruidbot = true
  end
  if (wildcards ~= nil  and #wildcards > 0 and isTargetInGroup(wildcards[1]) and (ishealbot or isdruidbot)) then
    --case where group member took area damage
    EnableTriggerGroup("area_dmg",false)
    if (ishealbot) then
      Execute("gheal")   --cleric gheal
    elseif (isdruidbot) then
      if (veiloficecount > 0 and isstanding and math.abs(lastveiltime - currentroundclock) >= 15.6) then
        SetVariable("lastveiltime",currentroundclock)
        SetVariable("isautoveil",1)
        Send("cast 'veil of ice'")
      else
        Execute("gheal") --druid gheal
      end
    end
  elseif (wildcards ~= nil  and #wildcards == 0 and (ishealbot or isdruidbot)) then
    --case where you took area damage
    EnableTriggerGroup("area_dmg",false)
    if (ishealbot) then
      Execute("gheal") --cleric gheal
    elseif (isdruidbot) then
      if (veiloficecount > 0 and isstanding and math.abs(lastveiltime - currentroundclock) >= 15.6) then
        SetVariable("lastveiltime",currentroundclock)
        SetVariable("isautoveil",1)
        Send("cast 'veil of ice'")
      else
        Execute("gheal") --druid gheal
      end
    end
  end
end

--http://lua-users.org/wiki/SimpleRound
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function genRandomNumber(attacker, victim, patternid)
  local randomEngageDelay = 0.0
  local rmin = 0.0
  local rmax = 0.0

  math.randomseed( os.time() )
  math.random();math.random();math.random();   --need this to make it to help random number generator

  if (GetVariable("randomDelayMin") ~= nil) then
    rmin = tonumber(GetVariable("randomDelayMin"))
  end

  if (GetVariable("randomDelayMax") ~= nil) then
	rmax = tonumber(GetVariable("randomDelayMax"))
  end

  randomEngageDelay = round(math.random(rmin,rmax) + math.random(),1)
  Note(tostring(randomEngageDelay))
end

function doCheckRescueTarget(attacker, victim, patternid, damage)
  require "socket"
  local currentengageclock = round(socket.gettime(),3)
  local lastengageclock = 0
  local charclass = ""
  local maintank = ""
  local isaimneeded = false
  local isshootneeded = false
  local isskybot = false
  local ishealbot = false
  local isshamanbot = false
  local isdruidbot = false
  local ispaladinbot = false
  local isfighting = false
  local isautorescue = false
  local engageaction = "kill"
  local isautoassist = false
  local retvalue = false
  local isdebug = false
  local isautofrag = false
  local isVictimInGroup = false
  local isAttackerInGroup = false
  local isautostone = false
  local isRandomDelay = false
  local randomEngageDelay = 0.0
  local rmin = 0.0
  local rmax = 0.0
  local stone_threshhold     = 0
  local laststone_time     = 0
  local isStoneExpired	     = true -- better to default to true, because laststone_<target> may not exist as variable

  --Note - stone_threshhold set in the (ungrouped) parse score trigger
  if (GetVariable("stone_threshhold") == nil) then
	if (tonumber(GetVariable("islegendary"))==1) then
		SetVariable("stone_threshhold",12)		--legend stone (3 rounds? approx)
	else
		SetVariable("stone_threshhold",8)		--regular stone
	end
  end
  stone_threshhold = tonumber(GetVariable("stone_threshhold"))


  if (GetVariable("randomDelayMin") ~= nil) then
    rmin = tonumber(GetVariable("randomDelayMin"))
  end

  if (GetVariable("randomDelayMax") ~= nil) then
	rmax = tonumber(GetVariable("randomDelayMax"))
  end

  math.randomseed( os.time() )
  math.random();math.random();math.random();   --need this to make it to help random number generator

  randomEngageDelay = round(math.random(rmin,rmax) + math.random(),1)

 -- print ("in doCheckRescueTarget: victim: "..victim..", attacker: "..attacker)
  local combatLines = tonumber(GetVariable("combatLines"))
  local charname = GetVariable("charname")

  combatLines = combatLines + 1
  SetVariable("combatLines",combatLines)

  charclass = Trim(GetVariable("charClass"))
  maintank = Trim(GetVariable("maintank"))

  if (tonumber(GetVariable("isRandomDelay")) == 1) then
    isRandomDelay = true
  end

  if (tonumber(GetVariable("isskybot")) == 1) then
    isskybot = true
  end

  if (tonumber(GetVariable("isaimneeded")) == 1) then
    isaimneeded = true
  end

  if (tonumber(GetVariable("isshootneeded")) == 1) then
    isshootneeded = true
  end

  if (tonumber(GetVariable("isfighting")) == 1) then
    isfighting = true
  end

  if (tonumber(GetVariable("isautorescue")) == 1) then
    isautorescue = true
  end

  if (tonumber(GetVariable("isHealbot")) == 1) then
    ishealbot = true
  end

  if (tonumber(GetVariable("isShamanbot")) == 1 and GetVariable("charClass") == "Shaman") then
    isshamanbot = true
  end

  if (tonumber(GetVariable("isdruidbot")) == 1) then
    isdruidbot = true
  end

  if (tonumber(GetVariable("ispaladinbot")) == 1) then
    ispaladinbot = true
  end

  if (tonumber(GetVariable("isautoassist")) == 1) then
    isautoassist = true
  end

  if (tonumber(GetVariable("isdebug")) == 1) then
    isdebug = true
  end

  if (tonumber(GetVariable("isautofrag")) == 1) then
    isautofrag = true
  end

  if (tonumber(GetVariable("isautostone")) == 1) then
    isautostone = true
  end

  engageaction = Trim(GetVariable("engageaction"))
  if (GetVariable("lastengageclock")) then
    lastengageclock = tonumber(GetVariable("lastengageclock"))
  end

  isVictimInGroup   = isTargetInGroup(victim)
  isAttackerInGroup = isTargetInGroup(attacker)

  --this is for tank auto-rescue
  if (isVictimInGroup and not isAttackerInGroup and isautorescue and isCharTank(charclass) and string.len(victim) > 0 and maintank ~= victim) then
	if (not isGroupMemberTank(victim) or maintank == charname) then
      Note("** Auto-rescue target: "..victim.."("..getGroupMemberClass(victim)..")")
	  if (isRandomDelay == false) then
		if (math.abs(os.clock() - tonumber(GetVariable("lastrescuetime"))) > 4) then
			Execute("doautostand;rescue "..victim)
			SetVariable("lastrescuetime",os.clock())
		end
	  else
	    --this code branch executes if rdelayon
		if (math.abs(os.clock() - tonumber(GetVariable("lastrescuetime"))) > 4) then
		  Note("**Random delay: "..tostring(randomEngageDelay))
		  DoAfterSpecial(randomEngageDelay,"doautostand;rescue "..victim,sendto.execute)
		  SetVariable("lastrescuetime",os.clock())
		end
	  end
      EnableTriggerGroup("rescuescript", false)
      retvalue = true
    end
    --this is for skybot auto-targetting (target: attacker)
  elseif (isVictimInGroup and not isAttackerInGroup and not isautorescue and isskybot and not isfighting and charclass == "Scout" and string.lower(Trim(attacker)) ~= "someone" and not string.find(attacker," corpse ")) then
    if (isaimneeded) then
      if (math.abs(currentengageclock - lastengageclock) > tonumber(GetVariable("engagedelay"))) then
        --Note("** Sky auto-target: "..doParseTarget(attacker))
		if (isRandomDelay == false) then
			Execute("doautostand;aim "..doParseTarget(attacker)..";shoot auto")
		else
			--this code branch executes if rdelayon
			Note("**Random delay: "..tostring(randomEngageDelay))
			DoAfterSpecial(randomEngageDelay,"doautostand;aim "..doParseTarget(attacker)..";shoot auto",sendto.execute)
		end

        if (tonumber(GetVariable("islegendary"))==1
             and tonumber(GetVariable("isautoburst"))==1
             and math.abs(round(socket.gettime(),3)-tonumber(GetVariable("last_burst_time"))) > 60
            -- and math.abs(round(socket.gettime(),3)-tonumber(GetVariable(last_burst_attempt))) > 60
        ) then
          Send("burst")
        end
        EnableTriggerGroup("rescuescript", false)
        SetVariable("lastengageclock",currentengageclock)
        retvalue = true
      end
    elseif (isshootneeded) then
      Execute("shoot auto")
      EnableTriggerGroup("rescuescript", false)
      retvalue = true
    end
    --this is for skybot auto-targetting (target: victim)
  elseif (isAttackerInGroup and not isVictimInGroup and not isautorescue and isskybot and not isfighting and charclass == "Scout" and string.lower(Trim(victim)) ~= "someone" and not string.find(victim," corpse ")) then
    if (isaimneeded) then
      if (math.abs(currentengageclock - lastengageclock) > tonumber(GetVariable("engagedelay"))) then
        --Note("** Sky auto-target: "..doParseTarget(victim))
        --Execute("doautostand;aim "..doParseTarget(victim)..";shoot auto")

		if (isRandomDelay == false) then
			Execute("doautostand;aim "..doParseTarget(victim)..";shoot auto")
		else
			--this code branch executes if rdelayon
			Note("**Random delay: "..tostring(randomEngageDelay))
			DoAfterSpecial(randomEngageDelay,"doautostand;aim "..doParseTarget(victim)..";shoot auto",sendto.execute)
		end


        if (tonumber(GetVariable("islegendary"))==1
                and tonumber(GetVariable("isautoburst"))==1
                and math.abs(round(socket.gettime(),3)-tonumber(GetVariable("last_burst_time"))) > 60
        -- and math.abs(round(socket.gettime(),3)-tonumber(GetVariable(last_burst_attempt))) > 60
        ) then
          Send("burst")
        end
        EnableTriggerGroup("rescuescript", false)
        SetVariable("lastengageclock",currentengageclock)
        retvalue = true
      end
    elseif (isshootneeded) then
      Execute("shoot auto")
      EnableTriggerGroup("rescuescript", false)
      retvalue = true
    end
  --this is for autoassist if not engaged if attacker not in group and victim is
  elseif (isVictimInGroup and not isAttackerInGroup and not isfighting and isautoassist and  string.len(engageaction) > 0 and string.lower(Trim(attacker)) ~= "someone" and not string.find(attacker," corpse ")) then
    SetVariable("target1",doParseTarget(attacker))
    if (math.abs(currentengageclock - lastengageclock) > tonumber(GetVariable("engagedelay"))) then
		if (isRandomDelay == false) then
		  if (string.lower(engageaction) == "ass" or string.lower(engageaction) == "assist") then --extra logic in case folks just want to assist instead of smart-targetting
			Execute("assist")
		  else
			Execute(engageaction.." "..doParseTarget(attacker))
		  end
		else     --now need to add random delay for where we assist VICTIM
			Note("**Random delay    : "..tostring(randomEngageDelay))
			if (string.lower(engageaction) == "ass" or string.lower(engageaction) == "assi" or string.lower(engageaction) == "assist") then
			  DoAfterSpecial(randomEngageDelay,"assist",sendto.execute)
			else
			  DoAfterSpecial(randomEngageDelay,engageaction.." "..doParseTarget(attacker),sendto.execute)
			end
	    end
      SetVariable("lastengageclock",currentengageclock)
      EnableTriggerGroup("rescuescript", false)
      retvalue = true
    end
    --this is for autoassist if not engaged if attacker in group and victim isn't
  elseif (isAttackerInGroup and not isVictimInGroup and not isfighting and isautoassist and  string.len(engageaction) > 0 and string.lower(Trim(victim)) ~= "someone" and not string.find(victim," corpse ")) then
    SetVariable("target1",doParseTarget(victim))
    if (math.abs(currentengageclock - lastengageclock) > tonumber(GetVariable("engagedelay"))) then
	  if (isRandomDelay == false) then
		if (string.lower(engageaction) == "ass" or string.lower(engageaction) == "assi" or string.lower(engageaction) == "assist") then
			Execute("assist")
		else
			Execute(engageaction.." "..doParseTarget(victim))
		end
	  else     --now need to add random delay for where we assist Attacker
		Note("**Random delay    : "..tostring(randomEngageDelay))
		if (string.lower(engageaction) == "ass" or string.lower(engageaction) == "assi" or string.lower(engageaction) == "assist") then
		  DoAfterSpecial(randomEngageDelay,"assist",sendto.execute)
		else
		  DoAfterSpecial(randomEngageDelay,engageaction.." "..doParseTarget(victim),sendto.execute)
		end
	  end
      SetVariable("lastengageclock",currentengageclock)
      EnableTriggerGroup("rescuescript", false)
      retvalue = true
    end
  elseif ( (ishealbot or isdruidbot or ispaladinbot or isshamanbot)   ---This is the logic branch for healbot code
          and (isVictimInGroup or string.upper(victim) == "YOU")
          and (combatLines >=2 or patternid == 10 or patternid == 13 or (patternid == 2 and damage == "obliterates"))) then
    SetVariable("target1",doParseTarget(attacker))
    if (isdruidbot and not isAttackerInGroup and isautofrag and not string.find(attacker," corpse ")) then  --this logic for druidbot autofrag
      SetVariable("target1",doParseTarget(attacker))
      Execute("docheckautofrag")
      EnableTriggerGroup("rescuescript", false)
      retvalue = true
    elseif (ishealbot or isdruidbot or ispaladinbot or isshamanbot) then
      if (patternid == 2 and damage ~= "misses") then -- damage ~= "bruises"
        if (ishealbot and tonumber(GetVariable("isMainHealer"))==0 and tonumber(GetVariable("healdelay")) > 0.1) then --** this logic branch for healbot in healg mode
          DoAfterSpecial(tonumber(GetVariable("healdelay")),"gheal",sendto.execute)  --for group healer mode, add a delay
          EnableTriggerGroup("rescuescript", false)
          retvalue = true
        else
		  --** this logic branch for druid bot auto-stone
          if (isdruidbot and tonumber(GetVariable("stoneskincount")) > 0 and isautostone and tonumber(GetVariable("tryingstone"))==0 and damage ~= "bruises") then
            if ((tonumber(GetVariable("stonemain"))==0 and victim ~= Trim(GetVariable("maintank"))) or tonumber(GetVariable("stonemain"))==1) then
      				--## note: USUALLY the branch below, rarely this branch reached
      				if (GetVariable("laststone_"..Proper(Trim(victim))) ~= nil) then
      					laststone_time = tonumber(GetVariable("laststone_"..Proper(Trim(victim))) )
      				end
      				if ((os.clock() - laststone_time) > stone_threshhold) then
      					Execute("doautostand;cast 'stone skin' "..victim)
      					SetVariable("laststone_"..Proper(Trim(victim)), os.clock())
      					SetVariable("tryingstone",1)
      				else
      					if (isdebug) then
      					  Note("** Under threshhold ("..stone_threshhold.."): "..(os.clock() - laststone_time))
      					end
      				end
              EnableTriggerGroup("rescuescript", false)
              retvalue = true
            end
          elseif (not isdruidbot or not isautostone) then --** this logic branch for healbot in healp mode
            Execute("gheal")
            EnableTriggerGroup("rescuescript", false)
            retvalue = true
          end
        end
      elseif (patternid ~= 2) then
	    --** this logic branch for healbot in healg mode
        if (ishealbot and tonumber(GetVariable("isMainHealer"))==0 and tonumber(GetVariable("healdelay")) > 0.1) then
          DoAfterSpecial(tonumber(GetVariable("healdelay")),"gheal",sendto.execute)   --for group healer mode, add a delay
          EnableTriggerGroup("rescuescript", false)
          retvalue = true
        else
		  --** this logic branch for druid bot auto-stone
          if (isdruidbot and tonumber(GetVariable("stoneskincount")) > 0 and isautostone and tonumber(GetVariable("tryingstone"))==0 and damage ~= "bruises") then
            if ((tonumber(GetVariable("stonemain"))==0 and victim ~= Trim(GetVariable("maintank"))) or tonumber(GetVariable("stonemain"))==1) then
      			  if (string.upper(victim) == "YOU") then
      					Execute("doautostand;cast 'stone skin' me")
      			  else
      					if (GetVariable("laststone_"..Proper(Trim(victim))) ~= nil) then
      						laststone_time = tonumber(GetVariable("laststone_"..Proper(Trim(victim))) )
      					end
      					if ((os.clock() - laststone_time) > stone_threshhold) then
      						Execute("doautostand;cast 'stone skin' "..victim)
      						SetVariable("laststone_"..Proper(Trim(victim)), os.clock())
      						SetVariable("tryingstone",1)
      					else
      						if (isdebug) then
      						  Note("** Under threshhold ("..stone_threshhold.."): "..(os.clock() - laststone_time))
      						end
      					end
      			  end
              EnableTriggerGroup("rescuescript", false)
              retvalue = true
            end
            --############################################
		        --# this following elseif() logic branch for soley for druids
            --# esp. for druids with cure massive
            --# Remember, for debuggings, timers must be enabled for DoAfterSpecial to work
            --# https://www.gammon.com.au/scripts/doc.php?function=DoAfterSpecial
            --############################################
          elseif (isdruidbot) then
            if (tonumber(GetVariable("isMainHealer"))==0 and tonumber(GetVariable("healdelay")) > 0.1) then
              DoAfterSpecial(tonumber(GetVariable("healdelay")),"gheal",sendto.execute)
            else
              Execute("gheal")
            end
            EnableTriggerGroup("rescuescript", false)
            retvalue = true
            --############################################
		        --# this logic branch for healbot in healp mode
            --# this logic is kinda faulty but prior elseif (druidbot) catches druids
            --############################################
          elseif (not isdruidbot or not isautostone) then

            Execute("gheal")
            EnableTriggerGroup("rescuescript", false)
            retvalue = true
          end
        end
      end
    end  --endif (ishealbot or isdruidbot or ispaladinbot)
  elseif (isautofrag and (charclass == "Red Robe" or charclass == "Black Robe" or charclass == "White Robe") and (isVictimInGroup or string.upper(victim) == "YOU") and not isAttackerInGroup and string.lower(Trim(attacker)) ~= "someone" and not string.find(attacker," corpse ")) then
    EnableTriggerGroup("rescuescript", false)
    SetVariable("target1",doParseTarget(attacker))
    Note("** mage autofrag: "..GetVariable("target1"))
    Execute("docheckautofrag")
    retvalue = true
  elseif (charclass == "Warrior" and isfighting) then
    if (doAutoBash() == true) then
      EnableTriggerGroup("rescuescript", false)
    end
  --[[
  else
    Note("** no conditions met")
    Note("** charclass: " ..charclass)
    Note("** isautofrag: " ..tostring(isautofrag))
    Note("** victim: " ..victim)
    Note("** attacker: " ..attacker)   --]]
  end
  return retvalue
end

function doCheckSummonCalled(name,line,wildcards)
  local ishealbot = false
  local isdruidbot = false

  if (tonumber(GetVariable("isHealbot"))==1) then
    ishealbot = true
  end

  if (tonumber(GetVariable("isdruidbot")) == 1) then
    isdruidbot = true
  end

  if (wildcards ~= nil and #wildcards > 0) then
    if (isTargetInGroup(Trim(wildcards[1]))) then
      if (ishealbot or isdruidbot) then
        Execute("doautostand;gheal")
      else
        Execute("doautostand;fly")
      end  --endif healbot or druidbot
    else --not in group or Someone
      if (isTargetInList(wildcards[1],"enemylist")) then
        Execute("jet")
      else
        Execute("wake;stand;fly")
      end
    end
  end
end

--http://www.gammon.com.au/forum/bbshowpost.php?bbsubject_id=11344
--http://www.ozone3d.net/tutorials/lua_socket_lib.php
function IsSocketConnected()
  local retvalue = false
  if (c == nil) then
    retvalue = false
  elseif (c:getpeername() == nil) then
    retvalue = false
  else
    retvalue = true
  end
  return retvalue
end

function closeSocket(name,line,wildcards)
  if (IsSocketConnected()) then
    c:close()
    Note("** Socket closed.")
  else
    Note("** Socket already closed.")
  end
end

function readSocketLine()
  retvalue = ""
  if (IsSocketConnected()) then
    c:settimeout(0)
    --content = c:receive('*l')
    l, e = c:receive()
    if (not e) then
      retvalue = l
    end
  end
  return retvalue
end

function ParseCommand()
  xmlstr = readSocketLine()       --does this var need to be global? could be local???
  local tmpLine = readSocketLine()
  local target =""
  local requestor =""
  local lineGrabCount = ""
  local is_allow_snoop = false
  local outboundMsg = ""
  local workstr = ""
  local allowOrder = true

  if (tonumber(GetVariable("allow_order")) == 0) then
    allowOrder = false
  end

  if (endswith(Trim(tmpLine),"</payload></msg>")) then
    workstr = GetVariable("msg_buffer")..tmpLine
    SetVariable("msg_buffer",workstr)
    --Note("full msg: "..GetVariable("msg_buffer"))
    SetVariable("msg_buffer","")
  else
    workstr = GetVariable("msg_buffer")..tmpLine
    SetVariable("msg_buffer",workstr)
  end


  if (tonumber(GetVariable("allow_snoop"))==1) then
    is_allow_snoop=true
  end

  if (string.len(xmlstr) > 0) then
    cmd,payload = string.match(xmlstr,"^<msg><cmd>([A-Za-z]+)</cmd><payload>(.*)</payload></msg>$")
    if (cmd == "EXECUTE") then
      if (allowOrder) then
        Execute(payload)
      else
        Note("** Allow order: Disabled ("..payload..")")
      end
    elseif (cmd == "NOTIFY") then
      Note(payload)
    elseif (cmd == "SNOOP") then
      target,requestor,lineGrabCount = string.match(xmlstr,"^<msg><cmd>SNOOP</cmd><payload><target>([A-Za-z]+)</target><requestor>([A-Za-z]+)</requestor><lines>(%d+)</lines></payload></msg>$")
      Note("** SNOOP request received from "..requestor..".")
      if (is_allow_snoop) then
        target,requestor,lineGrabCount = string.match(xmlstr,"^<msg><cmd>SNOOP</cmd><payload><target>([A-Za-z]+)</target><requestor>([A-Za-z]+)</requestor><lines>(%d+)</lines></payload></msg>$")
        if (tonumber(lineGrabCount) > 0  and IsSocketConnected()) then         --and target ~= requestor
          outboundMsg ="<msg><cmd>NOTIFY</cmd><payload><target>"..requestor.."</target><message>"..GetRecentLines(lineGrabCount).."**END SNOOP OF "..target.."</message></payload></msg>"
          assert(c:send(outboundMsg.."\\n"))
        else
            Note("here in weird state")
        end
      else
        if (IsSocketConnected()) then
          outboundMsg ="<msg><cmd>NOTIFY</cmd><payload><target>"..requestor.."</target><message>** "..target.." does not have snoop enabled.</message></payload></msg>"
          assert(c:send(outboundMsg.."\\n"))
        end
      end
    end
  end

end


function doAutoSplit(coinage)
  math.randomseed( os.time() )
  math.random();math.random();math.random();   --need this to make it to help random number generator
  doautosplit = tonumber(GetVariable("doautosplit"))
  doskim =  tonumber(GetVariable("doskim"))
  skimpct = tonumber(GetVariable("skimamount"))
  randomSkim = 0
  --[[doautosplit = 1
  doskim = 1
  skimpct = 10
  --]]

  if (doautosplit == 1) then
    if (doskim == 1) then
      splitamount = math.floor(coinage * (100 - skimpct) / 100)
      if (coinage >= 1000) then
        if (splitamount < 1000) then
          randomSkim = math.random(0, coinage - 1000)
          if ((coinage - randomSkim) < 1000) then
            Note("** Unable to skim "..skimpct.."% off of "..coinage.." coins.")
            Execute("split "..coinage)
          else
            splitamount = coinage - randomSkim
            Note("** Unable to skim "..skimpct.."% off of "..coinage.." coins.")
            Note("** You randomly skimmed "..randomSkim.." off of "..coinage.." coins.")
            Execute("split "..splitamount)
          end
        else
          skimamount = coinage - splitamount
          Note("You skimmed "..skimamount.." off of "..coinage.." coins.")
          Execute("split "..splitamount)
        end
      elseif (coinage >= 100) then
        if (splitamount < 100) then
          Note("** Unable to skim "..skimpct.."% off of "..coinage.." coins.")
          Execute("split "..coinage)
        else
          skimamount = coinage - splitamount
          Note("You skimmed "..skimamount.." off of "..coinage.." coins.")
          Execute("split "..splitamount)
        end
      elseif (coinage >= 10) then
        if (splitamount < 10) then
          Note("** Unable to skim "..skimpct.."% off of "..coinage.." coins.")
          Execute("split "..coinage)
        else
          skimamount = coinage - splitamount
          Note("You skimmed "..skimamount.." off of "..coinage.." coins.")
          Execute("split "..splitamount)
        end
      else
        Execute("split "..coinage)
      end
    else
      Execute("split "..coinage)
    end
  end
end

function CreateXMLMsg(cmd,payload)
  retvalue = ""
  retvalue = "<msg><cmd>"..cmd.."</cmd><payload>"..payload.."</payload></msg>"
  return retvalue
end

function round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end


function isBuffApplied(arr, buffname)
  retvalue = false
  if (arr ~= nil) then
    for i,v in ipairs(arr) do
      if string.match(v, buffname) then
        retvalue = true
        break
      end
    end
  else
    retvalue = false
  end
  return retvalue
end

function parseBuffs()
  local charclass = GetVariable("charClass")
  local charlevel = tonumber(GetVariable("charLevel"))
  local islegendary = false
  local isfighting = false
  local buffslist = {}
  local charCurrentHP = 0
  local charMaxHP = 0
  --buffs for red robe
  local displacementcount = 0
  local reposecount = 0
  local shieldcount = 0
  local lightningshieldcount = 0
  local mentalacuitycount = 0
  local strengthcount = 0
  local spheresofabsorptiocount = 0
  local antimagicshellcount = 0
  local mirrorimagecount = 0
  local blurcount = 0
  local detectinvisibilitycount = 0
  local improvedinvisibilitycount = 0
  local potencycount = 0
  local mnemonicenhancercount = 0
  local minorglobeofinvulcount = 0
  local detectscrycount = 0

  --buffs for black robe ( blur/shield/mentalacuity/vitriolicshield/blackrune/reposecount/tenebrous orb)
  local blackrunecount, vitriolicshieldcount, tenebrousorbcount = 0,0,0

  --buffs for white robe
  local fireshieldcount, arcaneshellcount, epiphanycount, whiterunecount = 0,0,0,0
  local mindafirecount, jukecount, preservationcount, watchfuleyecount, foldspacecount = 0,0,0,0,0
  local booncount, globeofinvulnerabicount   = 0,0

  --buffs for cleric
  local cloakofbraverycount = 0
  local detectmagiccount = 0
  local detectevilcount = 0
  local detectgoodcount = 0
  local protectionfromevilcount = 0
  local heroismcount = 0
  local fortifyselfcount = 0
  local sanctuarycount = 0   --shared with paladin
  local steelskincount = 0
  local sacredwardcount = 0
  local negativeplaneprotecount = 0
  local blesscount = 0       --shared with paladin
  local aidcount = 0
  local holyauracount = 0

  --buffs for druid
  local enlargecount = 0
  local iceshieldcount = 0
  local stormcallcount = 0
  local barkskincount = 0
  --druid shares blur with mages
  local iceskincount = 0
  local senselifecount = 0
  local iceshieldcount = 0

  --buffs for paladin
  local auraofglorycount = 0
  local holyarmscount = 0
  local holyvisioncount = 0
  local crusadecount = 0
  local highprayercount = 0
  local righteousindignatiocount = 0

  --buffs for shaman
  local boilingbloodcount, amplifyspiritscount, monstrousmantlecount, endurancecount = 0,0,0,0
  local spiritualguidancecount, detectpoisoncount, spectralglowcount, healboostcount = 0,0,0,0
  local tenaciousheartcount,  spectralsightcount, darkenedsoulcount,  etherealarmorcount = 0,0,0,0
  local ancestralshroudcount = 0

  --buffs for dk
  --local detectgoodcount = 0  --cleric already has
  local cloakofshadowscount = 0
  local protectionfromgoodcount, soulprotectioncount = 0,0
  local nightvisioncount = 0
  local unholyauracount, unholymightcount = 0,0

  if (GetVariable("charCurrentHP") ~= nil) then charCurrentHP = tonumber(GetVariable("charCurrentHP")) end
  if (GetVariable("charMaxHP") ~= nil) then charMaxHP = tonumber(GetVariable("charMaxHP")) end

  if (GetVariable("islegendary") ~= nil and tonumber(GetVariable("islegendary")) == 1) then
    islegendary = true
  end
  if (GetVariable("isfighting") ~= nil and tonumber(GetVariable("isfighting")) == 1) then
    isfighting = true
  end
  --*****************************************************
  --*** Let's get dark knight spell counts
  --*****************************************************
  if (GetVariable("unholymightcount") ~= nil) then
    unholymightcount = tonumber(GetVariable("unholymightcount"))
  else
	SetVariable("unholymightcount",0)
  end
  if (GetVariable("protectionfromgoodcount") ~= nil) then
    protectionfromgoodcount = tonumber(GetVariable("protectionfromgoodcount"))
  else
	SetVariable("protectionfromgoodcount",0)
  end
  if (GetVariable("cloakofshadowscount") ~= nil) then
    cloakofshadowscount = tonumber(GetVariable("cloakofshadowscount"))
  else
	SetVariable("cloakofshadowscount",0)
  end
  if (GetVariable("nightvisioncount") ~= nil) then
    nightvisioncount = tonumber(GetVariable("nightvisioncount"))
  else
	SetVariable("nightvisioncount",0)
  end
  if (GetVariable("unholyauracount") ~= nil) then
    unholyauracount = tonumber(GetVariable("unholyauracount"))
  else
	SetVariable("unholyauracount",0)
  end
  if (GetVariable("soulprotectioncount") ~= nil) then
    soulprotectioncount = tonumber(GetVariable("soulprotectioncount"))
  else
	SetVariable("soulprotectioncount",0)
  end

  --*****************************************************
  --*** Let's get paladin spell counts
  --*****************************************************
  if (GetVariable("auraofglorycount") ~= nil) then
    auraofglorycount = tonumber(GetVariable("auraofglorycount"))
  end
  if (GetVariable("holyarmscount") ~= nil) then
    holyarmscount = tonumber(GetVariable("holyarmscount"))
  end
  if (GetVariable("holyvisioncount") ~= nil) then
    holyvisioncount = tonumber(GetVariable("holyvisioncount"))
  end
  if (GetVariable("crusadecount") ~= nil) then
    crusadecount = tonumber(GetVariable("crusadecount"))
  end
  if (GetVariable("highprayercount") ~= nil) then
    highprayercount = tonumber(GetVariable("highprayercount"))
  end
  if (GetVariable("righteousindignatiocount") ~= nil) then
    righteousindignatiocount = tonumber(GetVariable("righteousindignatiocount"))
  end
  --*****************************************************
  --*** Let's get druid spell counts
  --*****************************************************
  if (GetVariable("enlargecount") ~= nil) then
    enlargecount = tonumber(GetVariable("enlargecount"))
  end
  if (GetVariable("iceshieldcount") ~= nil) then
    iceshieldcount = tonumber(GetVariable("iceshieldcount"))
  end
  if (GetVariable("stormcallcount") ~= nil) then
    stormcallcount = tonumber(GetVariable("stormcallcount"))
  end
  if (GetVariable("barkskincount") ~= nil) then
    barkskincount = tonumber(GetVariable("barkskincount"))
  end
  if (GetVariable("senselifecount") ~= nil) then
    senselifecount = tonumber(GetVariable("senselifecount"))
  end
  if (GetVariable("iceskincount") ~= nil) then
    iceskincount = tonumber(GetVariable("iceskincount"))
  end
  if (GetVariable("blurcount") ~= nil) then
    blurcount = tonumber(GetVariable("blurcount"))
  end
  --*****************************************************
  --*** Let's get cleric spell counts
  --*****************************************************
  if (GetVariable("cloakofbraverycount") ~= nil) then
    cloakofbraverycount = tonumber(GetVariable("cloakofbraverycount"))
  end
  if (GetVariable("detectmagiccount") ~= nil) then
    detectmagiccount = tonumber(GetVariable("detectmagiccount"))
  end
  if (GetVariable("detectevilcount") ~= nil) then
    detectevilcount = tonumber(GetVariable("detectevilcount"))
  end
  if (GetVariable("detectgoodcount") ~= nil) then
    detectgoodcount = tonumber(GetVariable("detectgoodcount"))
  end
  if (GetVariable("heroismcount") ~= nil) then
    heroismcount = tonumber(GetVariable("heroismcount"))
  end
  if (GetVariable("fortifyselfcount") ~= nil) then
    fortifyselfcount = tonumber(GetVariable("fortifyselfcount"))
  end
  if (GetVariable("sanctuarycount") ~= nil) then
    sanctuarycount = tonumber(GetVariable("sanctuarycount"))
  end
  if (GetVariable("steelskincount") ~= nil) then
    steelskincount = tonumber(GetVariable("steelskincount"))
  end
  if (GetVariable("sacredwardcount") ~= nil) then
    sacredwardcount = tonumber(GetVariable("sacredwardcount"))
  end
  if (GetVariable("blesscount") ~= nil) then
    blesscount = tonumber(GetVariable("blesscount"))
  end
  if (GetVariable("aidcount") ~= nil) then
    aidcount = tonumber(GetVariable("aidcount"))
  end
  if (GetVariable("protectionfromevilcount") ~= nil) then
    protectionfromevilcount = tonumber(GetVariable("protectionfromevilcount"))
  end
  if (GetVariable("holyauracount") ~= nil) then
    holyauracount = tonumber(GetVariable("holyauracount"))
  end
  if (GetVariable("negativeplaneprotecount") ~= nil) then
    negativeplaneprotecount = tonumber(GetVariable("negativeplaneprotecount"))
  end
  --*****************************************************
  --*** Let's get shaman spell counts
  --*****************************************************
  if (GetVariable("ancestralshroudcount") ~= nil) then
    ancestralshroudcount = tonumber(GetVariable("ancestralshroudcount"))
  end

  if (GetVariable("boilingbloodcount") ~= nil) then
    boilingbloodcount = tonumber(GetVariable("boilingbloodcount"))
  end
  if (GetVariable("amplifyspiritscount") ~= nil) then
    amplifyspiritscount = tonumber(GetVariable("amplifyspiritscount"))
  end
  if (GetVariable("monstrousmantlecount") ~= nil) then
    monstrousmantlecount = tonumber(GetVariable("monstrousmantlecount"))
  end
  if (GetVariable("darkenedsoulcount") ~= nil) then
    darkenedsoulcount = tonumber(GetVariable("darkenedsoulcount"))
  end
  if (GetVariable("endurancecount") ~= nil) then
    endurancecount = tonumber(GetVariable("endurancecount"))
  end
  if (GetVariable("etherealarmorcount") ~= nil) then
    etherealarmorcount = tonumber(GetVariable("etherealarmorcount"))
  end
  if (GetVariable("spiritualguidancecount") ~= nil) then
    spiritualguidancecount = tonumber(GetVariable("spiritualguidancecount"))
  end
  if (GetVariable("detectpoisoncount") ~= nil) then
    detectpoisoncount = tonumber(GetVariable("detectpoisoncount"))
  end
  if (GetVariable("spectralglowcount") ~= nil) then
    spectralglowcount = tonumber(GetVariable("spectralglowcount"))
  end
  if (GetVariable("healboostcount") ~= nil) then
    healboostcount = tonumber(GetVariable("healboostcount"))
  end
  if (GetVariable("tenaciousheartcount") ~= nil) then
    tenaciousheartcount = tonumber(GetVariable("tenaciousheartcount"))
  end
  if (GetVariable("spectralsightcount") ~= nil) then
    spectralsightcount = tonumber(GetVariable("spectralsightcount"))
  end
  --*****************************************************
  --*** Let's get red robe spell counts
  --*****************************************************
  if (GetVariable("shieldcount") ~= nil) then
    shieldcount = tonumber(GetVariable("shieldcount"))
  end
  if (GetVariable("reposecount") ~= nil) then
    reposecount = tonumber(GetVariable("reposecount"))
  end
  if (GetVariable("detectinvisibilitycount") ~= nil) then
    detectinvisibilitycount = tonumber(GetVariable("detectinvisibilitycount"))
  end
  if (GetVariable("lightningshieldcount") ~= nil) then
    lightningshieldcount = tonumber(GetVariable("lightningshieldcount"))
  end
  if (GetVariable("mentalacuitycount") ~= nil) then
    mentalacuitycount = tonumber(GetVariable("mentalacuitycount"))
  end
  --blurcount already handled earlier by druid
  if (GetVariable("strengthcount") ~= nil) then
    strengthcount = tonumber(GetVariable("strengthcount"))
  end
  if (GetVariable("spheresofabsorptiocount") ~= nil) then
    spheresofabsorptiocount = tonumber(GetVariable("spheresofabsorptiocount"))
  end
  if (GetVariable("antimagicshellcount") ~= nil) then
    antimagicshellcount = tonumber(GetVariable("antimagicshellcount"))
  end
  if (GetVariable("displacementcount") ~= nil) then
    displacementcount = tonumber(GetVariable("displacementcount"))
  end
  if (GetVariable("mirrorimagecount") ~= nil) then
    mirrorimagecount = tonumber(GetVariable("mirrorimagecount"))
  end
  if (GetVariable("improvedinvisibilitcount") ~= nil) then
    improvedinvisibilitycount = tonumber(GetVariable("improvedinvisibilitcount"))
  end
  if (GetVariable("potencycount") ~= nil) then
    potencycount = tonumber(GetVariable("potencycount"))
  end
  if (GetVariable("mnemonicenhancercount") ~= nil) then
    mnemonicenhancercount = tonumber(GetVariable("mnemonicenhancercount"))
  end
  if (GetVariable("minorglobeofinvulcount") ~= nil) then
    minorglobeofinvulcount = tonumber(GetVariable("minorglobeofinvulcount"))
  end
  if (GetVariable("detectscrycount") ~= nil) then
    detectscrycount = tonumber(GetVariable("detectscrycount"))
  end
  --*****************************************************
  --*** Let's get white robe spell counts
  --*****************************************************
  if (GetVariable("fireshieldcount") == nil) then
	SetVariable("fireshieldcount",0)
  end
  fireshieldcount = tonumber(GetVariable("fireshieldcount"))

  if (GetVariable("arcaneshellcount") == nil) then
	SetVariable("arcaneshellcount",0)
  end
  arcaneshellcount = tonumber(GetVariable("arcaneshellcount"))

  if (GetVariable("whiterunecount") == nil) then
	SetVariable("whiterunecount",0)
  end
  whiterunecount = tonumber(GetVariable("whiterunecount"))

  if (GetVariable("epiphanycount") == nil) then
	SetVariable("epiphanycount",0)
  end
  epiphanycount = tonumber(GetVariable("epiphanycount"))

  if (GetVariable("mindafirecount") == nil) then
	SetVariable("mindafirecount",0)
  end
  mindafirecount = tonumber(GetVariable("mindafirecount"))

  if (GetVariable("jukecount") == nil) then
	SetVariable("jukecount",0)
  end
  jukecount = tonumber(GetVariable("jukecount"))

  if (GetVariable("watchfuleyecount") == nil) then
	SetVariable("watchfuleyecount",0)
  end
  watchfuleyecount = tonumber(GetVariable("watchfuleyecount"))

  if (GetVariable("foldspacecount") == nil) then
	SetVariable("foldspacecount",0)
  end
  foldspacecount = tonumber(GetVariable("foldspacecount"))

  if (GetVariable("booncount") == nil) then
	SetVariable("booncount",0)
  end
  booncount = tonumber(GetVariable("booncount"))

  if (GetVariable("preservationcount") == nil) then
	SetVariable("preservationcount",0)
  end
  preservationcount = tonumber(GetVariable("preservationcount"))

  if (GetVariable("globeofinvulnerabicount") == nil) then
	SetVariable("globeofinvulnerabicount",0)
  end
  globeofinvulnerabicount = tonumber(GetVariable("globeofinvulnerabicount"))

  --*****************************************************
  --*** Let's get black robe spell counts
  --*****************************************************
   --local blackrunecount = 0
  --local vitriolicshieldcount = 0
  --local tenebrousorbcount = 0
  if (GetVariable("blackrunecount") ~= nil) then
    blackrunecount = tonumber(GetVariable("blackrunecount"))
  end
  if (GetVariable("vitriolicshieldcount") ~= nil) then
    vitriolicshieldcount = tonumber(GetVariable("vitriolicshieldcount"))
  end
  if (GetVariable("tenebrousorbcount") ~= nil) then
    tenebrousorbcount = tonumber(GetVariable("tenebrousorbcount"))
  end
  --*****************************************************
  --*** Druid buffs
  --*****************************************************
  if (charclass == "Druid") then
    if (not isBuffApplied(buffsArr, "barkskin") and barkskincount > 0) then
      table.insert(buffslist, "cast 'barkskin' me;")
    end
    if (not isBuffApplied(buffsArr, "sense life") and senselifecount > 0) then
      table.insert(buffslist, "cast 'sense life' me;")
    end
    if (not isBuffApplied(buffsArr, "blur") and blurcount > 0) then
      table.insert(buffslist, "cast 'blur' me;")
    end
    if (not isBuffApplied(buffsArr, "iceskin") and iceskincount > 0) then
      table.insert(buffslist, "cast 'iceskin';")
    end
    if (not isBuffApplied(buffsArr, "enlarge") and enlargecount > 0 and islegendary) then
      table.insert(buffslist, "cast 'enlarge';")
    end
    if (not isBuffApplied(buffsArr, "storm call") and stormcallcount > 0 and islegendary) then
      table.insert(buffslist, "cast 'storm call';")
    end
    if (not isBuffApplied(buffsArr, "iceshield") and iceshieldcount > 0) then
      table.insert(buffslist, "cast 'iceshield';")
    end
    --*****************************************************
    --*** Dark knight buffs
    --*****************************************************
  elseif (charclass == "Dark Knight") then
	if (not isBuffApplied(buffsArr, "unholy might") and unholymightcount > 0) then
      table.insert(buffslist, "cast 'unholy might' me;")
    end
	if (not isBuffApplied(buffsArr, "cloak of shadows") and cloakofshadowscount > 0) then
      table.insert(buffslist, "cast 'cloak of shadows' me;")
    end
	if (not isBuffApplied(buffsArr, "protection from good") and protectionfromgoodcount > 0) then
      table.insert(buffslist, "cast 'protection from good' me;")
    end
	if (not isBuffApplied(buffsArr, "bless") and blesscount > 0) then
      table.insert(buffslist, "cast 'bless' me;")
    end
	if (not isBuffApplied(buffsArr, "detect good") and detectgoodcount > 0) then
      table.insert(buffslist, "cast 'detect good' me;")
    end
	if (not isBuffApplied(buffsArr, "nightvision") and nightvisioncount > 0) then
      table.insert(buffslist, "cast 'nightvision' me;")
    end
	if (not isBuffApplied(buffsArr, "soul protection") and soulprotectioncount > 0) then
      table.insert(buffslist, "cast 'soul protection';")
    end
	if (not isBuffApplied(buffsArr, "unholy aura") and unholyauracount > 0) then
      table.insert(buffslist, "cast 'unholy aura';")
    end

    --*****************************************************
    --*** Shaman buffs
    --*****************************************************
  elseif (charclass == "Shaman") then
	if (not isBuffApplied(buffsArr, "sanctuary") and sanctuarycount > 0) then
      table.insert(buffslist, "cast 'sanctuary' me;")
    end
	if (not isBuffApplied(buffsArr, "ancestral shroud") and ancestralshroudcount > 0) then
      table.insert(buffslist, "cast 'ancestral shroud' me;") -- note: target is necessary for ancestral shroud
    end
	if (not isBuffApplied(buffsArr, "boiling blood") and boilingbloodcount > 0) then
      table.insert(buffslist, "cast 'boiling blood';")
    end
	if (not isBuffApplied(buffsArr, "amplify spirits") and amplifyspiritscount > 0) then
      table.insert(buffslist, "cast 'amplify spirits';")
    end
	if (not isBuffApplied(buffsArr, "monstrous mantle") and monstrousmantlecount > 0) then
      table.insert(buffslist, "cast 'monstrous mantle';")
    end
	if (not isBuffApplied(buffsArr, "endurance") and endurancecount > 0) then
      table.insert(buffslist, "cast 'endurance';")
    end
	if (not isBuffApplied(buffsArr, "ethereal armor") and etherealarmorcount > 0) then
      table.insert(buffslist, "cast 'ethereal armor';")
    end
	if (not isBuffApplied(buffsArr, "spiritual guidance") and spiritualguidancecount > 0) then
      table.insert(buffslist, "cast 'spiritual guidance';")
    end
	if (not isBuffApplied(buffsArr, "spectral glow") and spectralglowcount > 0) then
      table.insert(buffslist, "cast 'spectral glow';")
    end
	if (not isBuffApplied(buffsArr, "darkened soul") and darkenedsoulcount > 0) then
      table.insert(buffslist, "cast 'darkened soul';")
    end
	if (not isBuffApplied(buffsArr, "detect poison") and detectpoisoncount > 0) then
      table.insert(buffslist, "cast 'detect poison';")
    end
	if (not isBuffApplied(buffsArr, "tenacious heart") and tenaciousheartcount > 0) then
      table.insert(buffslist, "cast 'tenacious heart';")
    end
	if (not isBuffApplied(buffsArr, "heal boost") and healboostcount > 0) then
      table.insert(buffslist, "cast 'heal boost' me;")
    end
	if (not isBuffApplied(buffsArr, "spectral sight") and spectralsightcount > 0) then
      table.insert(buffslist, "cast 'spectral sight' me;")
    end
    --*****************************************************
    --*** Red Robe buffs
    --*****************************************************
  elseif (charclass == "Red Robe") then
    if (not isBuffApplied(buffsArr, "shield") and shieldcount > 0) then
      table.insert(buffslist, "cast 'shield';")
    end
    if (not isBuffApplied(buffsArr, "repose") and reposecount > 0) then
      table.insert(buffslist, "cast 'repose' me;")
    end
    if (not isBuffApplied(buffsArr, "detect invisibility") and detectinvisibilitycount > 0) then
      table.insert(buffslist, "cast 'detect invisibility';")
    end
    if (not isBuffApplied(buffsArr, "lightning shield") and lightningshieldcount > 0) then
      table.insert(buffslist, "cast 'lightning shield';")
    end
    if (not isBuffApplied(buffsArr, "mental acuity") and mentalacuitycount > 0) then
      table.insert(buffslist, "cast 'mental acuity';")
    end
    if (not isBuffApplied(buffsArr, "blur") and blurcount > 0) then
      table.insert(buffslist, "cast 'blur' me;")
    end
    if (not isBuffApplied(buffsArr, "strength") and strengthcount > 0) then
      table.insert(buffslist, "cast 'strength' me;")
    end
    if (not isBuffApplied(buffsArr, "spheres of absorption") and spheresofabsorptiocount > 0) then
      table.insert(buffslist, "cast 'spheres of absorption' me;")
    end
    if (not isBuffApplied(buffsArr, "displacement") and displacementcount > 0) then
      table.insert(buffslist, "cast 'displacement' me;")
    end
    if (not isBuffApplied(buffsArr, "antimagic shell") and antimagicshellcount > 0) then
      table.insert(buffslist, "cast 'antimagic shell' me;")
    end
    if (not isBuffApplied(buffsArr, "mirror image") and mirrorimagecount > 0) then
      table.insert(buffslist, "cast 'mirror image';")
    end
    if (not isBuffApplied(buffsArr, "improved invisibility") and improvedinvisibilitycount > 0) then
      table.insert(buffslist, "cast 'impr invis' me;")
    end
    if (not isBuffApplied(buffsArr, "potency") and potencycount > 0) then
      table.insert(buffslist, "cast 'potency' me;")
    end
    if (not isBuffApplied(buffsArr, "mnemonic enhancer") and mnemonicenhancercount > 0) then
	  if (charlevel < 27) then
		table.insert(buffslist, "cast 'mnemonic enhancer' 5;")
	  else
	    table.insert(buffslist, "cast 'mnemonic enhancer' 9;")
	  end
    end
    if (not isBuffApplied(buffsArr, "minor globe of invulnerability") and minorglobeofinvulcount > 0) then
      table.insert(buffslist, "cast 'minor globe of invulnerability';")
    end
    if (not isBuffApplied(buffsArr, "detect scry") and detectscrycount > 0) then
      table.insert(buffslist, "cast 'detect scry';")
    end

    --*****************************************************
    --*** Black Robe buffs
    --*****************************************************
  elseif (charclass == "Black Robe") then
    if (not isBuffApplied(buffsArr, "shield") and shieldcount > 0) then
      table.insert(buffslist, "cast 'shield';")
    end
    if (not isBuffApplied(buffsArr, "repose") and reposecount > 0) then
      table.insert(buffslist, "cast 'repose' me;")
    end
    if (not isBuffApplied(buffsArr, "detect invisibility") and detectinvisibilitycount > 0) then
      table.insert(buffslist, "cast 'detect invisibility';")
    end
    if (not isBuffApplied(buffsArr, "mental acuity") and mentalacuitycount > 0) then
      table.insert(buffslist, "cast 'mental acuity';")
    end
    if (not isBuffApplied(buffsArr, "blur") and blurcount > 0) then
      table.insert(buffslist, "cast 'blur' me;")
    end
    if (not isBuffApplied(buffsArr, "strength") and strengthcount > 0) then
      table.insert(buffslist, "cast 'strength' me;")
    end
    if (not isBuffApplied(buffsArr, "improved invisibility") and improvedinvisibilitycount > 0) then
      table.insert(buffslist, "cast 'impr invis' me;")
    end
	if (not isBuffApplied(buffsArr, "black rune") and blackrunecount > 0) then
      table.insert(buffslist, "cast 'black rune' me;")
    end
	if (not isBuffApplied(buffsArr, "tenebrous orb") and tenebrousorbcount > 0) then
      table.insert(buffslist, "cast 'tenebrous orb' me;")
    end
	if (not isBuffApplied(buffsArr, "vitriolic shield") and vitriolicshieldcount > 0) then
      table.insert(buffslist, "cast 'vitriolic shield' me;")
    end
    --*****************************************************
    --*** White Robe buffs
    --*****************************************************
  elseif (charclass == "White Robe") then
    if (not isBuffApplied(buffsArr, "shield") and shieldcount > 0) then
      table.insert(buffslist, "cast 'shield';")
    end
    if (not isBuffApplied(buffsArr, "repose") and reposecount > 0) then
      table.insert(buffslist, "cast 'repose' me;")
    end
    if (not isBuffApplied(buffsArr, "detect invisibility") and detectinvisibilitycount > 0) then
      table.insert(buffslist, "cast 'detect invisibility';")
    end
    if (not isBuffApplied(buffsArr, "mental acuity") and mentalacuitycount > 0) then
      table.insert(buffslist, "cast 'mental acuity';")
    end
    if (not isBuffApplied(buffsArr, "blur") and blurcount > 0) then
      table.insert(buffslist, "cast 'blur' me;")
    end
    if (not isBuffApplied(buffsArr, "strength") and strengthcount > 0) then
      table.insert(buffslist, "cast 'strength' me;")
    end
    if (not isBuffApplied(buffsArr, "improved invisibility") and improvedinvisibilitycount > 0) then
      table.insert(buffslist, "cast 'impr invis' me;")
    end
	if (not isBuffApplied(buffsArr, "fireshield") and fireshieldcount > 0) then
      table.insert(buffslist, "cast 'fireshield';")
    end
	if (not isBuffApplied(buffsArr, "arcane shell") and arcaneshellcount > 0) then
      table.insert(buffslist, "cast 'arcane shell' me;")
    end
	if (not isBuffApplied(buffsArr, "epiphany") and epiphanycount > 0) then
      table.insert(buffslist, "cast 'epiphany';")
    end
	if (not isBuffApplied(buffsArr, "white rune") and whiterunecount > 0) then
      table.insert(buffslist, "cast 'white rune';")
    end
	if (not isBuffApplied(buffsArr, "mind afire") and mindafirecount > 0) then
      table.insert(buffslist, "cast 'mind afire';")
    end
	if (not isBuffApplied(buffsArr, "juke") and jukecount > 0) then
      table.insert(buffslist, "cast 'juke' me;")
    end
	if (not isBuffApplied(buffsArr, "preservation") and preservationcount > 0) then
      table.insert(buffslist, "cast 'preservation';")
    end
	if (not isBuffApplied(buffsArr, "watchful eye") and watchfuleyecount > 0) then
      table.insert(buffslist, "cast 'watchful eye';")
    end
	if (not isBuffApplied(buffsArr, "fold space") and foldspacecount > 0) then
      table.insert(buffslist, "cast 'fold space';")
    end
	if (not isBuffApplied(buffsArr, "boon") and booncount > 0) then
      table.insert(buffslist, "cast 'boon' me;")
    end
	if (not isBuffApplied(buffsArr, "globe of invulnerability") and globeofinvulnerabicount > 0) then
      table.insert(buffslist, "cast 'globe of inv' me;")
    end

    --*****************************************************
    --*** Cleric buffs
    --*****************************************************
  elseif (charclass == "Cleric") then
    if (not isBuffApplied(buffsArr, "cloak of bravery") and cloakofbraverycount > 0) then
      table.insert(buffslist, "cast 'cloak of bravery';")
    end
    if (not isBuffApplied(buffsArr, "detect magic") and detectmagiccount > 0) then
      table.insert(buffslist, "cast 'detect magic';")
    end
    if (not isBuffApplied(buffsArr, "detect good") and detectgoodcount > 0) then
      table.insert(buffslist, "cast 'detect good' me;")
    end
    if (not isBuffApplied(buffsArr, "detect evil") and detectevilcount > 0) then
      table.insert(buffslist, "cast 'detect evil' me;")
    end
    if (not isBuffApplied(buffsArr, "fortify self") and fortifyselfcount > 0) then
      table.insert(buffslist, "cast 'fortify self';")
    end
    if (not isBuffApplied(buffsArr, "sanctuary") and sanctuarycount > 0) then
      table.insert(buffslist, "cast 'sanctuary' me;")
    end
    if (not isBuffApplied(buffsArr, "steelskin") and steelskincount > 0) then
      table.insert(buffslist, "cast 'steelskin' me;")
    end

    if (not isBuffApplied(buffsArr, "aid") and not isBuffApplied(buffsArr, "heroism") and aidcount > 0 and heroismcount < 1 and charCurrentHP == charMaxHP and not isfighting) then
      table.insert(buffslist, "cast 'aid' me;")
    end
    if (not isBuffApplied(buffsArr, "sacred ward") and sacredwardcount > 0) then
      table.insert(buffslist, "cast 'sacred ward' me;")
    end
    if (not isBuffApplied(buffsArr, "bless") and blesscount > 0) then
      table.insert(buffslist, "cast 'bless' me;")
    end
    if (not isBuffApplied(buffsArr, "heroism") and heroismcount > 0 and charCurrentHP == charMaxHP and not isfighting) then
      table.insert(buffslist, "cast 'heroism' me;")
    end
    if (not isBuffApplied(buffsArr, "protection from evil") and (protectionfromevilcount > 0 or holyauracount > 0)) then
      if (holyauracount > 0) then
        table.insert(buffslist, "cast 'holy aura' me;")
      else
        table.insert(buffslist, "cast 'protection from evil' me;")
      end
    end
    if (not isBuffApplied(buffsArr, "negative plane protection") and negativeplaneprotecount > 0) then
      if (GetVariable("charname")~=nil) then
        table.insert(buffslist, "cast 'negative plane prote' me;")
      end
    end
    --*****************************************************
    --*** Paladin buffs
    --*****************************************************
  elseif (charclass == "Paladin") then
    if (not isBuffApplied(buffsArr, "aura of glory") and auraofglorycount > 0) then
      table.insert(buffslist, "cast 'aura of glory';")
    end
    if (not isBuffApplied(buffsArr, "holy arms") and holyarmscount > 0) then
      table.insert(buffslist, "cast 'holy arms';")
    end
    if (not isBuffApplied(buffsArr, "holy vision") and holyvisioncount > 0) then
      table.insert(buffslist, "cast 'holy vision';")
    end
    if (not isBuffApplied(buffsArr, "crusade") and crusadecount > 0) then
      table.insert(buffslist, "cast 'crusade';")
    end
    if (not isBuffApplied(buffsArr, "high prayer") and highprayercount > 0) then
      table.insert(buffslist, "cast 'high prayer';")
    end
  end         --endif
  --*****************************************************
  --*** Apply the accumulated missing buffs
  --*****************************************************
  if (buffslist ~= nil and #buffslist > 0) then
    Execute(string.sub(table.concat(buffslist),1,#table.concat(buffslist)-1))
    Note("** Auto-Buffs: "..Trim(string.gsub(string.gsub(string.gsub(table.concat(buffslist),";","|"),"'",""),"cast","" )))
  end
end

function calcReturnDir()
  local northcount = tonumber(GetVariable("northcount"))
  local southcount = tonumber(GetVariable("southcount"))
  local eastcount  = tonumber(GetVariable("eastcount"))
  local westcount  = tonumber(GetVariable("westcount"))
  local downcount  = tonumber(GetVariable("downcount"))
  local upcount    = tonumber(GetVariable("upcount"))
  local t = {northcount,upcount,downcount,westcount,southcount,eastcount }
  local maxcount = 0
  local isskybot = false

  if (tonumber(GetVariable("isskybot")) == 1) then
    isskybot = true
  end
  --http://lua-users.org/wiki/TableLibraryTutorial
  table.sort(t, function(a,b) return a>b end)    --sort in descending order
  maxcount = t[1]
  Note("** group["..#groupArr.."] max["..maxcount.."] north["..northcount.."] east["..eastcount.."] south["..southcount.."] west["..westcount.."] down["..downcount.."] up["..upcount.."]")
  if (maxcount > 0) then
    if (northcount == maxcount) then
      Execute("hover;sneak;north")
    elseif (eastcount == maxcount) then
      Execute("hover;sneak;east")
    elseif (southcount == maxcount) then
      Execute("hover;sneak;south")
    elseif (westcount == maxcount) then
      Execute("hover;sneak;west")
    elseif (upcount == maxcount) then
      Execute("hover;sneak;up")
    elseif (downcount == maxcount) then
      Execute("hover;sneak;down")
    end
  else
    Note("** No group members found on scan")
  end
end

function parsePromptLine(promptline)
  local isflygroup   = false
  local isskybot     = false
  local lastdir      = ""
  local isfleesafe   = false
  local isfademode   = false
  local istryingfade = false
  local ismagebot    = false
  local isdruidbot   = false
  local ishealbot    = false
  local isstanding   = false
  local isautorescue = false
  local charclass    = ""
  local charname     = ""
  local maintank     = ""
  local lastmv       = 0
  local currentmv    = 0
  local memticks     = 0
  local isNoExit     = false
  local exitdirs     = ""
  local fightlines   = 0
  local isfighting   = false
  local isfadeinitiated = false
  local isdebug      = false
  local istryingheal = tonumber(GetVariable("tryingheal"))
  local isgheal      = tonumber(GetVariable("isgheal"))
  local isghealgood  = tonumber(GetVariable("isghealgood"))
  local lastroundclock  = tonumber(GetVariable("lastroundclock"))
  local isdobuffs    = false
  local isautoflee   = false
  local veiloficecount = tonumber(GetVariable("veiloficecount"))
  local diff = 0
  require "socket"
  local currentroundclock = round(socket.gettime(),3)


  if (tonumber(GetVariable("isdebug")) == 1) then
    isdebug = true
  end

  if (tonumber(GetVariable("isautoflee")) == 1) then
    isautoflee = true
  end

  if (tonumber(GetVariable("combatLines")) >= 2) then
    diff = round(math.abs(currentroundclock - lastroundclock),3)
    if (isdebug) then
      Note("combatLines: "..tostring(GetVariable("combatLines"))..", seconds/round: "..tostring(diff))
    end
    SetVariable("lastroundclock",currentroundclock)
  end


  SetVariable("combatLines",0)
  SetVariable("issellcomps",0)
  promptline = Trim(promptline)
  EnableTrigger("spiritRaiseTrigger",false)  --for oasr alias
  EnableTriggerGroup("spell_list",false)  --disable so doesn't interfere with buff tracking
  EnableTriggerGroup("rescuescript", true)
  EnableTrigger("call_spirit_trigger",false) 	--disables the shaman call spirit trigger
  EnableTrigger("disentangle_trigger",true)
  EnableTrigger("roomname_trigger",true)
  EnableTrigger("cureblind_trigger",true)
  EnableTrigger("unfreeze_trigger",true)
  EnableTrigger("unparalyze_trigger",true)
  EnableTrigger("unweb_trigger",true)
  EnableTrigger("holy_armor_trigger",true)
  EnableTriggerGroup("gas_script",true)
  EnableTriggerGroup("autoresists",true)
  EnableTriggerGroup("area_dmg",true)
  --want to disable these so you don't have them trigger when looking at other people's eqy

  if (GetTriggerInfo("worneq_trigger",8) == true) then
    Note("** weap1: "..GetVariable("weap1"))
    Note("** weap2: "..GetVariable("weap2"))
  end
  EnableTrigger("worneq_trigger",false)
  EnableTriggerGroup("eq_script",false)

  --for autobuffs
  if (GetTriggerInfo("buffs_pattern",8)) then
    if (tonumber(GetVariable("isdobuffs")) == 1) then
      parseBuffs()
      SetVariable("isdobuffs",0)
    end
    EnableTrigger("buffs_pattern",false)
  end

  --this logic supports whob alias
  if (GetTriggerInfo("whob_line", 8) and tonumber(GetVariable("iswhobgood")) == 1) then
    readHighlights()
    SetVariable("iswhobgood",0)
    EnableTrigger("whob_line", false)
  end

  --this logic supports gact alias
  if (tonumber(GetVariable("istryinggact")) == 1 and tonumber(GetVariable("isgactgood")) == 1) then
    SetVariable("isgactgood",0)
    SetVariable("istryinggact",0)
    doParseGroupAction(GetVariable("groupaction"))
  end

  --this logic supports bandall alias
  if (tonumber(GetVariable("istryingbandall")) == 1 and tonumber(GetVariable("isbandallgood")) == 1) then
    SetVariable("isbandallgood",0)
    SetVariable("istryingbandall",0)
    doBandAll()
  end

  --this logic supports gheal (healbot + shamanbot + druidbot)
  if (tonumber(GetVariable("isgheal")) == 1 and tonumber(GetVariable("isghealgood")) == 1) then
    SetVariable("isghealgood",0)
    SetVariable("isgheal",0)
    healGroupParse()
  end
  -- this logic supports refgroup (druid)
  if (tonumber(GetVariable("isrefgroup")) == 1 and tonumber(GetVariable("isrefgroupgood")) == 1) then
    SetVariable("isrefgroupgood",0)
    SetVariable("isrefgroup",0)
    Execute("refreshgroup")
  end

  if (wizeyeArr ~= nil and #wizeyeArr > 0 ) then
    parseWizEye()
    wizeyeArr = {}
  end

  maintank   = GetVariable("maintank")
  charname   = GetVariable("charname")
  charclass  = GetVariable("charClass")
  lastdir    = GetVariable("lastdir")
  if (tonumber(GetVariable("isflygroup")) == 1) then
    isflygroup = true
  end
  if (tonumber(GetVariable("isskybot")) == 1) then
    isskybot = true
  end
  if (tonumber(GetVariable("isfleesafe")) == 1) then
    isfleesafe = true
  end
  if (tonumber(GetVariable("fademode")) == 1) then
    isfademode = true
  end
  if (tonumber(GetVariable("istryingfade")) == 1) then
    istryingfade = true
  end
  if (tonumber(GetVariable("ismagebot")) == 1) then
    ismagebot = true
  end
  if (tonumber(GetVariable("isdruidbot")) == 1) then
    isdruidbot = true
  end
  if (tonumber(GetVariable("isstanding")) == 1) then
    isstanding = true
  end
  if (tonumber(GetVariable("isautorescue")) == 1) then
    isautorescue = true
  end
  if (tonumber(GetVariable("isfadeinitiated")) == 1) then
    isfadeinitiated = true
  end

  if (string.len(promptline) > 0 and string.find(promptline,"%[%*%*")  and string.find(promptline,"%*%*%]") ) then
    isfighting = false
    SetVariable("isfighting",0)
    EnableTimer("botskill_timer", false)
  elseif (string.len(promptline) > 0 and string.find(promptline,"%[") and string.find(promptline,"%]") ) then
    SetVariable("isfighting",1)
    isfighting = true
    if (tonumber(GetVariable("isautoskill"))==1) then
      EnableTimer("botskill_timer", true)
    end
  else
    SetVariable("isfighting",0)
    isfighting = false
    EnableTimer("botskill_timer", false)
    if (tonumber(GetVariable("issharpendelay"))==1) then
      Execute("sharpenall")
      SetVariable("issharpendelay",0)
    end
  end


  if (round(math.abs(currentroundclock - lastroundclock),3) >= 10 and not isfighting and isdruidbot) then
   -- Note("** setting isautoveil 0")
    SetVariable("isautoveil",0)
  elseif (isdruidbot
          and tonumber(GetVariable("isautoveil"))==1
          and diff < 10
          and veiloficecount > 0
          and isstanding
          and math.abs(currentroundclock - tonumber(GetVariable("lastveiltime"))) >= 15.6) then
    SetVariable("lastveiltime",currentroundclock)
    Send("cast 'veil of ice'")
    --[[
  elseif (isdruidbot) then
    Note("** Time since last veil of ice (in seconds): ".. math.abs(currentroundclock - tonumber(GetVariable("lastveiltime"))))
    --]]
  end
  --Note("** isautoveil: "..tostring(GetVariable("isautoveil")))
  currentmv = tonumber(GetVariable("charCurrentMV"))
  lastmv    = tonumber(GetVariable("lastmv"))
  --[[
  if (GetVariable("lastmovetime") ~= nil) then
    Note("** seconds since last move: "..math.abs(currentroundclock-tonumber(GetVariable("lastmovetime"))))
  end--]]

  if (charclass == "Druid" and math.abs(currentmv - lastmv) > 10 and isdruidbot and not isfighting and isstanding) then
    SetVariable("lastmv", currentmv)
    Execute("refgroup")  --do refgroup eventually
  elseif (charclass == "RedRobe" and math.abs(currentmv - lastmv) > 10 and ismagebot and not isfighting and isstanding) then
    SetVariable("lastmv", currentmv)
    Execute("refgroup") --do refgroup eventually
  end

  if (string.len(promptline) > 0 and string.len(promptline) > 0 and string.find(promptline,"Mem:%d+")) then
    memticks = string.match(promptline,"Mem:(%d+)")
    SetVariable("memticks",memticks)
  else
    SetVariable("memticks",0)
  end

  if (string.len(promptline) > 0 and string.len(promptline) > 0 and string.find(promptline,"Exits:")) then
    exitdirs = string.match(promptline,"Exits:([NESWUD%)%(]+)")
    SetVariable("exitdirs",exitdirs)
    isNoExit = false
    --print("exitdirs: "..exitdirs)
  else
    exitdirs = " "
    SetVariable("exitdirs",exitdirs)
    isNoExit = true
  end

  if (isfighting and not isNoExit and charclass == "Scout" and isstanding and isskybot and isfleesafe and isautoflee) then
    if (tonumber(GetVariable("istryingflee")) == 0) then
      Send("flee")
      SetVariable("istryingflee",1)
    end
  elseif (not isfighting and not isNoExit and charclass == "Scout" and isstanding and isskybot and isfleesafe and isautoflee) then
    if (tonumber(GetVariable("istryingflee")) == 1) then
      Execute("scanr")
    elseif (tonumber(GetVariable("isscanreturn"))==1 and tonumber(GetVariable("istryingflee")) == 0 and tonumber(GetVariable("isscan")) == 1) then
      calcReturnDir()
      SetVariable("isscanreturn",0)
    end
    SetVariable("istryingflee",0)
  elseif (not isfighting) then
    SetVariable("istryingflee",0)
  end
  if (tonumber(GetVariable("isscan")) == 1) then
    SetVariable("isscan",0)
  end
  --[[
  if (isskybot and not isNoExit and charclass == "Scout" and isstanding) then
    if (isfighting and isfleesafe) then
      Note("isfademode: "..tostring(isfademode)..", isvaliddir: "..tostring(isValidDir(lastdir, exitdirs) )..", not istryingfade:"..tostring(not istryingfade))
      if (isfademode and isValidDir(lastdir, exitdirs) and not istryingfade and not isfadeinitiated) then
        Note("** OK. met condition for sky auto-fade **")
        SetVariable("istryingfade",1)
        SetVariable("isfadeinitiated",1)
        if (lastdir == "north") then
          Execute("goSouth")
        elseif (lastdir == "east") then
          Execute("goWest")
        elseif (lastdir == "south") then
          Execute("goNorth")
        elseif (lastdir == "west") then
          Execute("goEast")
        elseif (lastdir == "up") then
          Execute("goDown")
        elseif (lastdir == "down") then
          Execute("goUp")
        end
      end
    elseif (not isfighting and not isNoExit and istryingfade and isstanding) then
      if (isValidDir(lastdir, exitdirs)) then
        SetVariable("istryingfade",0)
        SetVariable("isfadeinitiated",0)
        if (lastdir == "north") then
          Execute("goSouth")
        elseif (lastdir == "east") then
          Execute("goWest")
        elseif (lastdir == "south") then
          Execute("goNorth")
        elseif (lastdir == "west") then
          Execute("goEast")
        elseif (lastdir == "up") then
          Execute("goDown")
        elseif (lastdir == "down") then
          Execute("goUp")
        end
      end
    end
  end     --]]
end

function isValidDir(direction,exits)
  local retvalue = false
  if (direction == "north") then
    if (string.find(exits,"S")) then
      retvalue = true
    end
  elseif  (direction == "east") then
    if (string.find(exits,"W")) then
      retvalue = true
    end
  elseif  (direction == "south") then
    if (string.find(exits,"N")) then
      retvalue = true
    end
  elseif  (direction == "west") then
    if (string.find(exits,"E")) then
      retvalue = true
    end
  elseif  (direction == "up") then
    if (string.find(exits,"D")) then
      retvalue = true
    end
  elseif  (direction == "down") then
    if (string.find(exits,"U")) then
      retvalue = true
    end
  end

  return retvalue
end


function split(str, pat)
  local t = {}  -- NOTE: use {n = 0} in Lua-5.0
  local fpat = "(.-)" .. pat
  local last_end = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
      table.insert(t,cap)
    end
    last_end = e+1
    s, e, cap = str:find(fpat, last_end)
  end
  if last_end <= #str then
    cap = str:sub(last_end)
    table.insert(t, cap)
  end
  return t
end

function isBaddie(suspect)
  local retvalue = false
  local baddiesTbl = {}
  --local baddies = "Mazer,Corey,Awk,Dworkin,Blobster,Corey,Nabob,Isabella,Sinne,Bumer,Aimee,Giggles,Nyx,Malcom,Helix,Helion,Zyx,Saun,Rudolpho,Quan,Jericho,Moola,Camponie,Jana,Sakapa,Bubonic,Ugg,Dubbs,Larry,Balanar,Krogga,Tanaris,Krizt,Grombo,Mazrim,Oksonn,Gurkhor,Draoi,Balerion,Rodnik,Grind,Olav,Vodayken,Kwonyuri,Darach,Taeyeon,Stuk,Jourgo,Hau,Leloeqn,Hisda,Tera,Xain,Tink,Angrim,Iyachtu,Dimilis,Carnelia,Geleb,Wyand,Orrel,Eltanin,Dorada,Zan,Tilvien,Lycos,Gimle,Goober,Chupacabra,Vallerion,Inyt,Halrog,Zoumiz,Kaskade,Tentaculat,Kosem,Flix,Baz,Whai,Remodnar,Symn,Beccah,Aandw,Jeihra,Pavin,Scallywag,Grizz,Ammit,Sub,Mirish,Helle,Xirhsieueo,Dirth,Behati,Kagwallas,Reaks,Anzze,Pooker,Juna,Filiong,Trubridge,Peek,Sonyeoshidae,Nollaseiska,Fyomnekse,Hookashaka,Drizzt,Lor,Leo,Leland,Printz,Moto,Giloth,Marissa,Miad,Chantille,Aeta,Kubla,Nollaseiska,Ruhjoja,Eerpo,Knox,Buster,Gustof,Narsi,Lugo,Dodger,Mogjorn,Trisha,Meet,Belter,Dedel,Rythmatic,Olgica,Hodgepodge"
  local baddies = Trim(GetVariable("enemylist"))
  baddiesTbl = split(baddies,",")
  for i, v in pairs(baddiesTbl) do
    if (v == suspect) then
      retvalue = true
      break
    end
  end
  return retvalue
end

--************************************************************************
--*  alt path for Joe's ubuntu path/directory FS
--*  local filename = "Z\:\\media\\thymorical\\AE84E6B784E68167\\dev\\IRCBot\\IRCBot\\highlights.xml"
--************************************************************************
function readHighlights()
  local filename = "c:\\dev\\IRCBot\\IRCBot\\highlights.xml"
  --  local filename = "Z\:\\media\\thymorical\\AE84E6B784E68167\\dev\\IRCBot\\IRCBot\\highlights.xml"
  local nick = ""
  local charclass = ""
  local clan = ""
  local f = assert(io.open(filename,"r"))
  local t = f:read("*all")
  f:close()
  local baddiesTbl = {}
  local baddieCount = 0
  local dogt = false
  local sb = {}
  local isclanned = false

  if (tonumber(GetVariable("isclanned")) == 1) then
    isclanned = true
  end

  if (tonumber(GetVariable("dogrouptick")) == 1) then
    dogt = true
  end
  if (whonames ~= nil and #whonames >= 1) then --some error handling just in case of super weird scenario
    for i,char_online in ipairs(whonames)
    do
      if (isBaddie(char_online)) then
        nick,charclass,clan = string.match(t,' nick=%"('..string.lower(Trim(char_online))..')%" class=%"([A-Za-z]+)%" clan=%"([A-Za-z]+)%" ')
        if (nick ~= nil and charclass ~= nil and clan ~= nil) then
          Note("<"..string.upper(clan)..">"..string.rep(" ",5-#clan)..Proper(nick)..string.rep(" ",18-#nick).."("..charclass..")")
          baddieCount = baddieCount + 1
          if (dogt) then
            if (#charclass >= 2 and string.sub(charclass,1,2) == "bl") then
              table.insert(sb,Trim(Proper(nick)).."(BL) ")
            elseif (charclass == "darkknight" or charclass == "dk" or charclass == "da") then
              table.insert(sb,Trim(Proper(nick)).."(DA) ")
            elseif (#charclass >= 2 and string.sub(charclass,1,2) == "cl") then
              table.insert(sb,Trim(Proper(nick)).."(CL) ")
            elseif (#charclass >= 2 and string.sub(charclass,1,2) == "re") then
              table.insert(sb,Trim(Proper(nick)).."(RE) ")
            elseif (charclass == "mtn" or charclass == "mountain" or charclass == "sky" or charclass == "ocean" or charclass == "scout") then
              table.insert(sb,Trim(Proper(nick)).."(SC) ")
            elseif (#charclass >=2 and string.sub(charclass,1,2) == "th") then
              table.insert(sb,Trim(Proper(nick)).."(TH) ")
            elseif (#charclass >=2 and string.sub(charclass,1,2) == "wa") then
              table.insert(sb,Trim(Proper(nick)).."(WA) ")
            elseif (#charclass >= 2 and string.sub(charclass,1,2) == "pa") then
              table.insert(sb,Trim(Proper(nick)).."(PA) ")
            elseif (#charclass >= 2 and string.sub(charclass,1,2) == "sh") then
              table.insert(sb,Trim(Proper(nick)).."(SH) ")
            elseif (#charclass >= 2 and string.sub(charclass,1,2) == "ba") then
              table.insert(sb,Trim(Proper(nick)).."(BA) ")
            elseif (#charclass >=2 and string.sub(charclass,1,2) == "dr") then
              table.insert(sb,Trim(Proper(nick)).."(DR) ")
            elseif (#charclass >= 2 and string.sub(charclass,1,2) == "wh") then
              table.insert(sb,Trim(Proper(nick)).."(WH) ")
            else
              table.insert(sb,Trim(Proper(nick)).."(??) ")
            end
          end
        else
          Note("<UNKW> "..Trim(Proper(char_online))..string.rep(" ",18-#Trim(Proper(char_online))).." (unknown)")
        end
      end
    end
    if (baddieCount == 0) then
      Note("** No enemies found online.")
    else
      Note("** Total evil(s) online: "..baddieCount)
      if (dogt) then
	    if (isclanned) then
			Send("ct ".. baddieCount.." evils: "..table.concat(sb))
		else
			Send("gt ".. baddieCount.." evils: "..table.concat(sb))
		end
      end
    end
  else
    Note("** readHighlights(): whonames is nil")
  end
end

function resetMem(name,line,wildcards)
  SetVariable("acidblastcount", 0);
  SetVariable("acidburncount", 0);
  SetVariable("acidmistcount", 0);
  SetVariable("aidcount", 0);
  SetVariable("amplifyspiritscount", 0);
  SetVariable("ancestralspiritcount", 0);
  SetVariable("ancestralshroudcount", 0);  --shaman autobuffs
  SetVariable("animatedeadcount", 0);
  SetVariable("antimagicshellcount", 0);
  SetVariable("arcaneshellcount", 0);
  SetVariable("arcanespearcount", 0);
  SetVariable("arcanelashcount", 0);
  SetVariable("auraofglorycount", 0);
  SetVariable("barkskincount", 0);
  SetVariable("blackrunecount", 0);
  SetVariable("blesscount", 0);
  SetVariable("blindnesscount", 0);
  SetVariable("blurcount", 0);
  SetVariable("boilingbloodcount", 0);
  SetVariable("booncount", 0); --white.robe legend autobuff
  SetVariable("burninghandscount", 0);
  SetVariable("calmcount", 0);
  SetVariable("chainlightningcount", 0);
  SetVariable("clearskiescount", 0);  --for divine refresh
  SetVariable("cloakofbraverycount", 0);
  SetVariable("cloakofshadowscount", 0);
  SetVariable("coneofcoldcount", 0);
  SetVariable("constantwindscount", 0);
  SetVariable("createfoodcount", 0);
  SetVariable("createwatercount", 0);
  SetVariable("crusadecount", 0);
  SetVariable("cureblindnesscount", 0)
  SetVariable("curelightcount", 0);
  SetVariable("curemassivecount", 0);   -- for druid as of 3Q18
  SetVariable("cureseriouscount", 0);
  SetVariable("curecritcount", 0);
  SetVariable("curecriticalcount", 0);
  SetVariable("cursecount", 0);
  SetVariable("darknesscount", 0);
  SetVariable("darkenedsoulcount", 0); --divine regen
  SetVariable("detectinvisibilitycount", 0);
  SetVariable("detectgoodcount", 0);
  SetVariable("detectevilcount", 0);
  SetVariable("detectmagiccount", 0);
  SetVariable("detectpoisoncount", 0);
  SetVariable("detectscrycount", 0);
  SetVariable("devastationcount", 0);
  SetVariable("displacementcount", 0);
  SetVariable("elementalfistcount", 0);
  SetVariable("endurancecount", 0);
  SetVariable("enlargecount", 0);
  SetVariable("entanglecount", 0);
  SetVariable("epiphanycount", 0);
  SetVariable("etherealarmorcount",0);
  SetVariable("faeriefirecount", 0); --for divine refresh
  SetVariable("fireballcount", 0);
  SetVariable("fireshieldcount", 0);
  SetVariable("firestormcount", 0);
  SetVariable("flameshroudcount", 0);
  SetVariable("fleshshieldcount", 0);
  SetVariable("foldspacecount", 0); -- w.robe buff
  SetVariable("forceboltcount", 0);
  SetVariable("forcemissilecount", 0);
  SetVariable("fortifyselfcount", 0);
  SetVariable("freeactioncount", 0);
  SetVariable("ghostskincount", 0);
  SetVariable("globeofinvulnerabicount", 0);  --white.robe
  SetVariable("granitehandcount", 0);
  SetVariable("harmcount", 0);
  SetVariable("healingcloudcount", 0);
  SetVariable("healingwavecount", 0);
  SetVariable("healboostcount", 0);
  SetVariable("healcount", 0);
  SetVariable("heroismcount", 0);
  SetVariable("highprayercount", 0);
  SetVariable("holyauracount", 0);
  SetVariable("holyarmorcount", 0);
  SetVariable("holyarmscount", 0);
  SetVariable("holyvisioncount", 0);
  SetVariable("iceshieldcount", 0);
  SetVariable("iceskincount", 0);
  SetVariable("icestormcount", 0);
  SetVariable("improvedinvisibilitcount", 0);
  SetVariable("infravisioncount", 0); --for divine refresh
  SetVariable("jukecount", 0); -- w.robe buff
  SetVariable("lightcount", 0);
  SetVariable("lightningboltcount", 0);
  SetVariable("lightningshieldcount", 0);
  SetVariable("massflycount", 0);
  SetVariable("massrefreshcount", 0);
  SetVariable("magicblastcount", 0);
  SetVariable("magicboltcount", 0);
  SetVariable("magicmissilecount", 0);
  SetVariable("mentalacuitycount", 0);
  SetVariable("mindafirecount", 0);-- w.robe buff
  SetVariable("minorglobeofinvulcount", 0);
  SetVariable("monstrousmantlecount", 0);
  SetVariable("negativeplaneprotecount", 0);
  SetVariable("nightmarecount", 0);
  SetVariable("nightvisioncount", 0);
  SetVariable("paincount", 0);
  SetVariable("passwithouttracecount", 0);
  SetVariable("powerwordstuncount",0)
  SetVariable("preservationcount", 0);
  SetVariable("primalfurycount", 0);
  SetVariable("protectionfromevilcount", 0);
  SetVariable("protectionfromgoodcount", 0);
  SetVariable("refreshcount", 0);
  SetVariable("regeneratecount", 0);
  SetVariable("removecursecount", 0);
  SetVariable("reposecount", 0);
  SetVariable("restorationcount", 0);
  SetVariable("righteousindignatiocount", 0);
  SetVariable("ritualvoyagecount", 0);
  SetVariable("rotcount",0)
  SetVariable("sacredwardcount", 0);
  SetVariable("sanctuarycount", 0);
  SetVariable("scorchcount", 0);
  SetVariable("senselifecount", 0);
  SetVariable("shieldcount", 0);
  SetVariable("shockingblastcount", 0);
  SetVariable("shockinggraspcount", 0);
  SetVariable("silencecount", 0); --for divine refresh
  SetVariable("spectralglowcount", 0);
  SetVariable("spheresofabsorptiocount", 0);
  SetVariable("spectralsightcount", 0);
  SetVariable("spiritualguidancecount", 0);
  SetVariable("spiritualhammercount", 0);
  SetVariable("silencecount", 0);
  SetVariable("soulprotectioncount", 0);
  SetVariable("steelskincount", 0);
  SetVariable("stinkingcloudcount", 0); --for divine refresh
  SetVariable("stoneskincount", 0);
  SetVariable("stormcallcount", 0);
  SetVariable("strengthcount", 0);
  SetVariable("summoncount", 0);
  SetVariable("sustenancecount", 0);
  SetVariable("tenaciousheartcount", 0);
  SetVariable("tenebrousorbcount", 0);
  SetVariable("thornspraycount", 0);
  SetVariable("thunderboltcount", 0);
  SetVariable("unholyauracount", 0);
  SetVariable("unholymightcount", 0);
  SetVariable("veiloficecount", 0);
  SetVariable("vitriolicshieldcount", 0);
  SetVariable("watchfuleyecount", 0); -- w.robe buff
  SetVariable("waterbreathcount", 0); -- divine refresh
  SetVariable("whiterunecount", 0);
  SetVariable("wordofrecallcount", 0);
  SetVariable("zombifycount", 0);	--divine regen
end

function doDivineHeal()
  local animatedeadcount = 0;
  local darknesscount = 0;
  local harmcount = 0;
  local restorationcount = 0;
  local summoncount = 0;
  local healcount = 0;

  if (GetVariable("animatedeadcount") ~= nil) then
	animatedeadcount = tonumber(GetVariable("animatedeadcount"))
  else
	SetVariable("animatedeadcount",0)
  end

  if (GetVariable("darknesscount") ~= nil) then
	darknesscount    = tonumber(GetVariable("darknesscount"))
  else
	SetVariable("darknesscount",0)
  end

  if (GetVariable("harmcount") ~= nil) then
	harmcount        = tonumber(GetVariable("harmcount"))
  else
	SetVariable("harmcount",0)
  end

  if (GetVariable("restorationcount") ~= nil) then
	restorationcount = tonumber(GetVariable("restorationcount"))
  else
	SetVariable("restorationcount",0)
  end

  if (GetVariable("summoncount") ~= nil) then
	summoncount      = tonumber(GetVariable("summoncount"))
  else
	SetVariable("summoncount",0)
  end

  if (GetVariable("healcount") ~= nil) then
	healcount        = tonumber(GetVariable("healcount"))
  else
	SetVariable("healcount",0)
  end

  local charclass = tostring(GetVariable("charClass"));
  if (charclass == "Cleric") then
    healcount = healcount + summoncount + restorationcount + harmcount + darknesscount + animatedeadcount;
  end
  SetVariable("healcount", tonumber(healcount))
end
--*****************************************************************
--* Used by Cleric, Druid, and Shaman
--*****************************************************************
function showHeals(name,line,wildcards)
  local healcount         = 0
  local curemassivecount  = 0     -- added for druids in v0.77
  local curecriticalcount = 0
  local cureseriouscount  = 0
  local curelightcount    = 0
  local regeneratecount   = 0
  local healboostcount    = 0
  local ritualvoyagecount = 0
  local ancestralspiritcount = 0
  local charclass 		  = GetVariable("charClass")
  local spell_healingwave = false
  local healingwavecount  = 0
  local stoneskincount    = 0
  local healingcloudcount = 0
  local zombifycount	  = 0
  local darkenedsoulcount = 0

  if (GetVariable("healcount") ~= nil) then
	   healcount         = tonumber(GetVariable("healcount"))
  else
	   SetVariable("healcount",0)
  end

  if (GetVariable("curecriticalcount") ~= nil) then
	   curecriticalcount = tonumber(GetVariable("curecriticalcount"))
  else
	   SetVariable("curecriticalcount",0)
  end

  if (GetVariable("cureseriouscount") ~= nil) then
	   cureseriouscount  = tonumber(GetVariable("cureseriouscount"))
  else
	   SetVariable("cureseriouscount",0)
  end

  if (GetVariable("curelightcount") ~= nil) then
	   curelightcount    = tonumber(GetVariable("curelightcount"))
  else
	   SetVariable("curelightcount",0)
  end

  --shaman spells
  if (GetVariable("regeneratecount") ~= nil) then
	   regeneratecount        = tonumber(GetVariable("regeneratecount"))
  else
	   SetVariable("regeneratecount",0)
  end

  if (GetVariable("healboostcount") ~= nil) then
	   healboostcount         = tonumber(GetVariable("healboostcount"))
  else
	   SetVariable("healboostcount",0)
  end

  if (GetVariable("ritualvoyagecount") ~= nil) then
	   ritualvoyagecount      = tonumber(GetVariable("ritualvoyagecount"))
  else
	   SetVariable("ritualvoyagecount",0)
  end

  if (GetVariable("ancestralspiritcount") ~= nil) then
	   ancestralspiritcount   = tonumber(GetVariable("ancestralspiritcount"))
  else
	   SetVariable("ancestralspiritcount",0)
  end

  if (GetVariable("healingwavecount") ~= nil) then
	   healingwavecount       = tonumber(GetVariable("healingwavecount"))
  else
	   SetVariable("healingwavecount",0)
  end

  if (GetVariable("zombifycount") ~= nil) then
	   zombifycount = tonumber(GetVariable("zombifycount"))
  else
	   SetVariable("zombifycount",0)
  end

  if (GetVariable("darkenedsoulcount") ~= nil) then
	   darkenedsoulcount = tonumber(GetVariable("darkenedsoulcount"))
  else
	   SetVariable("darkenedsoulcount",0)
  end

  if (GetVariable("spell_healingwave") ~= nil) then
  	if (tonumber(GetVariable("spell_healingwave"))==1) then
  		spell_healingwave = true
  	end
  end

  --get druid specific spellcounts
  if (GetVariable("stoneskincount") ~= nil) then
		stoneskincount = tonumber(GetVariable("stoneskincount"))
  end

  if (GetVariable("healingcloudcount") ~= nil) then
		healingcloudcount = tonumber(GetVariable("healingcloudcount"))
  end

  if (GetVariable("curemassivecount") ~= nil) then
		curemassivecount = tonumber(GetVariable("curemassivecount"))
  else
     SetVariable("curemassivecount",0)
  end

  if (charclass == "Shaman") then
  	if (spell_healingwave) then
  		Note("** ["..tostring(regeneratecount + healboostcount + ritualvoyagecount + ancestralspiritcount + darkenedsoulcount + zombifycount).."]regenerate ["..healingwavecount.."]healing wave ["..tostring(curecriticalcount).."]cure critical ["..tostring(cureseriouscount).."]cure serious ["..tostring(curelightcount).."]cure light")
  	else
  		Note("** ["..tostring(regeneratecount + healboostcount + ritualvoyagecount + ancestralspiritcount + darkenedsoulcount + zombifycount).."]regenerate ["..tostring(curecriticalcount).."]cure critical ["..tostring(cureseriouscount).."]cure serious ["..tostring(curelightcount).."]cure light")
  	end
  elseif (charclass == "Druid") then
    Note("** ["..tostring(stoneskincount).."]stone skin ["..tostring(healingcloudcount).."]healing cloud ["..tostring(curemassivecount).."]cure massive ["..tostring(curecriticalcount).."]cure critical ["..tostring(cureseriouscount).."]cure serious ["..tostring(curelightcount).."]cure light")
  else
    --note divine heal count done in another function
    Note("** ["..tostring(healcount).."]heal ["..tostring(curecriticalcount).."]cure critical ["..tostring(cureseriouscount).."]cure serious ["..tostring(curelightcount).."]cure light")
  end
end --this is the end of showHeals() function

function gtShowHeals(name,line,wildcards)
  local healcount         = 0
  local curecriticalcount = 0
  local cureseriouscount  = 0
  local curelightcount    = 0
  local charclass = GetVariable("charClass")

  --for shaman bot
  local isshamanbot       = false
  local regeneratecount	     = 0
  local healboostcount       = 0
  local ritualvoyagecount    = 0
  local ancestralspiritcount = 0

  --for druidbot
  local stoneskincount 	  = 0
  local healingcloudcount = 0
  local isdruidbot 		  = false

  --determine if druid bot enabled
  if (tonumber(GetVariable("isdruidbot")) == 1 and GetVariable("charClass") == "Druid") then
	isdruidbot = true
	if (GetVariable("stoneskincount") ~= nil) then
		stoneskincount = tonumber(GetVariable("stoneskincount"))
	end
	if (GetVariable("healingcloudcount") ~= nil) then
		healingcloudcount = tonumber(GetVariable("healingcloudcount"))
	end
  end

  --determine if shaman bot enabled
  if (tonumber(GetVariable("isShamanbot")) == 1 and GetVariable("charClass") == "Shaman") then
    isshamanbot = true

	if (GetVariable("regeneratecount") ~= nil) then
		regeneratecount = tonumber(GetVariable("regeneratecount"))
		--regeneratecount = math.max(regeneratecount,0)  --in case negative...allow due to all the divine spells in regen circle
	end
	if (GetVariable("healboostcount") ~= nil) then
		healboostcount = tonumber(GetVariable("healboostcount"))
	end
	if (GetVariable("ritualvoyagecount") ~= nil) then
		ritualvoyagecount = tonumber(GetVariable("ritualvoyagecount"))
	end
	if (GetVariable("ancestralspiritcount") ~= nil) then
		ancestralspiritcount   = tonumber(GetVariable("ancestralspiritcount"))
	end

	--total since regen is divine spell
	regeneratecount = regeneratecount + healboostcount + ritualvoyagecount + ancestralspiritcount
  end

  healcount         = tonumber(GetVariable("healcount"))
  curecriticalcount = tonumber(GetVariable("curecriticalcount"))
  cureseriouscount  = tonumber(GetVariable("cureseriouscount"))
  curelightcount    = tonumber(GetVariable("curelightcount"))

  --need to add random delay to look less botty
  --Note("name: "..name)
  if (name ~= "docheckheals") then
	  if (charclass == "Shaman" or charclass == "Cleric") then
		  if (isshamanbot == false and charclass == "Cleric") then
			DoAfterSpecial(1,"gt "..tostring(healcount),sendto.execute)
		  elseif (charclass == "Shaman") then
			if (regeneratecount > 1) then
				DoAfterSpecial(1,"gt "..tostring(regeneratecount).." regens",sendto.execute)
			else
				DoAfterSpecial(1,"gt "..tostring(regeneratecount).." regen",sendto.execute)
			end
		  end
	  elseif (charclass == "Druid" and isdruidbot) then
		if (stoneskincount == 1 and healingcloudcount ~= 1) then     --simply for english nazi grammar for plural stone(s) or cloud(s)
			DoAfterSpecial(1,"gt "..tostring(stoneskincount).." stone, "..tostring(healingcloudcount).." healing clouds",sendto.execute)
		elseif (stoneskincount == 1 and healingcloudcount == 1) then
			DoAfterSpecial(1,"gt "..tostring(stoneskincount).." stone, "..tostring(healingcloudcount).." healing cloud",sendto.execute)
		else
			DoAfterSpecial(1,"gt "..tostring(stoneskincount).." stones, "..tostring(healingcloudcount).." healing clouds",sendto.execute)
		end
	  end
  end
  --Send()

  if (IsSocketConnected()) then
	if (isshamanbot == false and (charclass == "Cleric" or charclass == "Druid")) then
		if (isdruidbot) then
		  Execute("cgt ["..tostring(stoneskincount).."]stone skin ["..tostring(healingcloudcount).."]healing cloud ["..tostring(curecriticalcount).."]cure critical ["..tostring(cureseriouscount).."]cure serious ["..tostring(curelightcount).."]cure light")
		else
		  Execute("cgt ["..tostring(healcount).."]heal ["..tostring(curecriticalcount).."]cure critical ["..tostring(cureseriouscount).."]cure serious ["..tostring(curelightcount).."]cure light")
		end
	elseif (charclass == "Shaman") then
		Execute("cgt ["..tostring(regeneratecount).."]regenerate ["..tostring(curecriticalcount).."]cure critical ["..tostring(cureseriouscount).."]cure serious ["..tostring(curelightcount).."]cure light")
	end
  end
end

function parseMemSlots(name,line,wildcards)
  local spellslots = ""
  local isautomem = tonumber(GetVariable("isautomem"))
  local charclass = GetVariable("charClass")
  local charname = GetVariable("charname")
  local memtable = {}

  --check if druid has certain spells before auto-memming them
  local spell_curecritical = false
  local spell_stoneskin = false
  local spell_refresh = false
  local spell_massrefresh = false
  local spell_firestorm = false
  local spell_coneofcold = false
  local spell_flameshroud = false
  local spell_freeaction = false
  local spell_paralysis = false
  local spell_calllightning = false
  local spell_curemassive = false

  --check if cleric has certain spells before auto-memming them
  local spell_steelskin = false
  local spell_heal 		= false
  local spell_harm 		= false
  local spell_soulleech = false

  --check if blackrobe has certain spells before auto-memming them
  local spell_nightmare = false		--circle 9
  local spell_rend = false			--circle 9

  --check if redrobe has certain spells before auto-memming them
  local spell_thunderbolt = false	--circle 9
  local spell_shockingblast = false
  local spell_forcemissile = false
  local spell_chainlightning = false
  local spell_powerwordstun = false

  --check if shaman has certain spells before auto-memming them
  local spell_amplifyspirits = false
  local spell_ancestralshroud = false
  local spell_ancestralspirit = false
  local spell_ancestralblessing = false
  local spell_blindness = false
  local spell_boilingblood = false
  local spell_boneshape = false
  local spell_darkenedsoul = false
  local spell_endurance = false
  local spell_etherealarmor = false
  local spell_healingwave = false
  local spell_ghostberries = false
  local spell_ghostskin = false
  local spell_lastchance = false
  local spell_monstrousmantle = false
  local spell_nap = false
  local spell_removecurse = false
  local spell_removepoison = false
  local spell_restorestrength = false
  local spell_ritualvoyage = false
  local spell_sanctuary = false
  local spell_sapstrength = false
  local spell_satiate = false
  local spell_soulleech = false
  local spell_spectralglow = false
  local spell_spectralsight = false
  local spell_spiritualguidance = false
  local spell_sublimeresistance = false
  local spell_tenaciousheart = false
  local spell_transmogrify = false
  local spell_vilespirits = false

  --** druid circle 4 spells
  if (GetVariable("spell_flameshroud") ~= nil) then
  	if (tonumber(GetVariable("spell_flameshroud")) == 1) then
  		spell_flameshroud = true
  	end
  end
  if (GetVariable("spell_freeaction") ~= nil) then
  	if (tonumber(GetVariable("spell_freeaction")) == 1) then
  		spell_freeaction = true
  	end
  end
  if (GetVariable("spell_coneofcold") ~= nil) then
  	if (tonumber(GetVariable("spell_coneofcold")) == 1) then
  		spell_coneofcold = true
  	end
  end

  --** druid circle 4 spells
  if (GetVariable("spell_paralysis") ~= nil) then
  	if (tonumber(GetVariable("spell_paralysis")) == 1) then
  		spell_paralysis = true
  	end
  end

  --** druid circle 7 spells
  if (GetVariable("spell_curecritical") ~= nil) then
  	if (tonumber(GetVariable("spell_curecritical")) == 1) then
  		spell_curecritical = true
  	end
  end

  if (GetVariable("spell_stoneskin") ~= nil) then
  	if (tonumber(GetVariable("spell_stoneskin")) == 1) then
  		spell_stoneskin = true
  	end
  end

  if (GetVariable("spell_massrefresh") ~= nil) then
  	if (tonumber(GetVariable("spell_massrefresh")) == 1) then
  		spell_massrefresh = true
  	end
  end

  if (GetVariable("spell_refresh") ~= nil) then
  	if (tonumber(GetVariable("spell_refresh")) == 1) then
  		spell_refresh = true
  	end
  end

  if (GetVariable("spell_firestorm") ~= nil) then
  	if (tonumber(GetVariable("spell_firestorm")) == 1) then
  		spell_firestorm = true
  	end
  end

  if (GetVariable("spell_curemassive") ~= nil) then
  	if (tonumber(GetVariable("spell_curemassive")) == 1) then
  		spell_curemassive = true
  	end
  end

  if (GetVariable("spell_calllightning") ~= nil) then
  	if (tonumber(GetVariable("spell_calllightning")) == 1) then
  		spell_lightning = true
  	end
  end

  --cleric spell list
  if (GetVariable("spell_steelskin") ~= nil) then
  	if (tonumber(GetVariable("spell_steelskin")) == 1) then
  		spell_steelskin = true
  	end
  end

  if (GetVariable("spell_heal") ~= nil) then
  	if (tonumber(GetVariable("spell_heal")) == 1) then
  		spell_heal = true
  	end
  end

  if (GetVariable("spell_harm") ~= nil) then
  	if (tonumber(GetVariable("spell_harm")) == 1) then
  		spell_harm = true
  	end
  end

  --shaman spell list
  if (GetVariable("spell_healingwave") ~= nil) then
  	if (tonumber(GetVariable("spell_healingwave")) == 1) then
  		spell_healingwave = true
  	end
  end

  --blackrobe spell list
  if (GetVariable("spell_nightmare") ~= nil) then
  	if (tonumber(GetVariable("spell_nightmare")) == 1) then
  		spell_nightmare = true
  	end
  end

  if (GetVariable("spell_rend") ~= nil) then
  	if (tonumber(GetVariable("spell_rend")) == 1) then
  		spell_rend = true
  	end
  end

  --redrobe spell list
  if (GetVariable("spell_thunderbolt") ~= nil) then
  	if (tonumber(GetVariable("spell_thunderbolt")) == 1) then
  		spell_thunderbolt = true
  	end
  end

  if (GetVariable("spell_shockingblast") ~= nil) then
  	if (tonumber(GetVariable("spell_shockingblast")) == 1) then
  		spell_shockingblast = true
  	end
  end

  if (GetVariable("spell_powerwordstun") ~= nil) then
  	if (tonumber(GetVariable("spell_powerwordstun")) == 1) then
  		spell_powerwordstun = true
  	end
  end

  if (GetVariable("spell_chainlightning") ~= nil) then
  	if (tonumber(GetVariable("spell_chainlightning")) == 1) then
  		spell_chainlightning = true
  	end
  end

  if (GetVariable("spell_forcemissile") ~= nil) then
  	if (tonumber(GetVariable("spell_forcemissile")) == 1) then
  		spell_forcemissile = true
  	end
  end

  if (charclass == "Druid" or charclass == "Cleric" or charclass == "Shaman") then
    doDivineHeal()
    showHeals()
  end

  if (#wildcards > 0 and isautomem == 1) then
    spellslots = Trim(table.concat(wildcards))
    for circle,slot in string.gmatch(spellslots, "(%d+)%-(%d+)%s?") do
      if (tonumber(slot) > 0) then
        memtable = {}  --reset the mem for the new circle
        if (tonumber(circle) == 1) then                 --***** CIRCLE 1 SPELL AUTOMEM ****
          if (charclass == "Cleric") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'cu li' ")
            end
          elseif (charclass == "Druid") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'t s' ")
            end
          elseif (charclass == "Paladin") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'cu li' ")
            end
          elseif (charclass == "Dark Knight") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'unh mig' ")
            end
          elseif (charclass == "Shaman") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'sati' ") --satiate
            end
          elseif (charclass == "Red Robe" or charclass == "Black Robe" or charclass == "White Robe") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'m miss' ")
            end
          end
        elseif (tonumber(circle) == 2) then                 --***** CIRCLE 2 SPELL AUTOMEM ****
          if (charclass == "Cleric") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'cu bli' ")
            end
          elseif (charclass == "Paladin") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'res str' ")
            end
          elseif (charclass == "Dark Knight") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'cl of sha' ")
            end
		  elseif (charclass == "Shaman") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'cu li' ")
            end
		  elseif (charclass == "Druid") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'e fist' ")
            end
          elseif (charclass == "Red Robe" or charclass == "Black Robe" or charclass == "White Robe" ) then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'sh gr' ")
            end
          end
        elseif (tonumber(circle) == 3) then                 --***** CIRCLE 3 SPELL AUTOMEM ****
          if (charclass == "Cleric" or charclass == "Shaman") then  --Cleric & Shaman combined
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'cu ser' ")
            end
          elseif (charclass == "Paladin") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'ho vis' ")
            end
          elseif (charclass == "Druid") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'fla shr' ")
            end
          elseif (charclass == "Red Robe" or charclass == "Black Robe" or charclass == "White Robe") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'mag bolt' ")
            end
          end
        elseif (tonumber(circle) == 4) then                 --***** CIRCLE 4 SPELL AUTOMEM ****
          if (charclass == "Cleric") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'free act' ")
            end
          elseif (charclass == "Paladin") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'cu se' ")
            end
          elseif (charclass == "Druid") then
            for i = 1, tonumber(slot), 1 do
				if (spell_coneofcold) then
					table.insert(memtable, "'con o co' ")
				elseif  (spell_paralysis) then
					table.insert(memtable, "'paralysis' ")
				elseif  (spell_freeaction) then
					table.insert(memtable, "'free act' ")
				end
            end
		  elseif (charclass == "Shaman") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'sou le' ")
            end
          elseif (charclass == "Red Robe" or charclass == "Black Robe" or charclass == "White Robe") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'mag blast' ")
            end
          end
        elseif (tonumber(circle) == 5) then                 --***** CIRCLE 5 SPELL AUTOMEM ****
          if (charclass == "Cleric" or charclass == "Shaman") then   --Cleric & Shaman combined
			if (spell_curecritical) then
				for i = 1, tonumber(slot), 1 do
				  table.insert(memtable, "'cure crit' ")
				end
			end
          elseif (charclass == "Druid") then
            for i = 1, tonumber(slot), 1 do
              if (spell_curecritical) then
                table.insert(memtable, "'cure critical' ")
              elseif (spell_firestorm) then
                table.insert(memtable, "'fire storm' ")
              end
            end
          elseif (charclass == "Red Robe") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'force bolt' ")
            end
          elseif (charclass == "Black Robe") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'tenebrous orb' ")
            end
          end
        elseif (tonumber(circle) == 6) then                 --***** CIRCLE 6 SPELL AUTOMEM ****
          if (charclass == "Cleric") then
            for i = 1, tonumber(slot), 1 do
				if (spell_harm) then
					table.insert(memtable, "'harm' ")
				elseif (spell_heal) then
					table.insert(memtable, "'heal' ")
				end
            end
          elseif (charclass == "Druid") then
            for i = 1, tonumber(slot), 1 do
      				if (spell_calllightning) then
      					table.insert(memtable, "'call light' ")        --*** Druid 6th circle - call lightning
      				end
            end
          elseif (charclass == "Red Robe") then
            for i = 1, tonumber(slot), 1 do
			  if (spell_chainlightning) then
                table.insert(memtable, "'chain light' ")
			  end
            end
		  elseif (charclass == "Shaman") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'hea boo' ")
            end
          elseif (charclass == "Black Robe") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'acid burn' ")
            end
          end
        elseif (tonumber(circle) == 7) then                 --***** CIRCLE 7 SPELL AUTOMEM ****
          if (charclass == "Cleric") then
            for i = 1, tonumber(slot), 1 do
              if (charname == "Domahnugnuts") then
                table.insert(memtable, "'neg p p' ")
              elseif (charname == "Monika") then
                table.insert(memtable, "'sum circl' ")
              end
            end
          elseif (charclass == "Druid") then
      			if (spell_curemassive) then
      				for i = 1, tonumber(slot), 1 do
      				  table.insert(memtable, "'cure massive' ")
      				end
      			end
		  elseif (charclass == "Shaman") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'ghostsk' ")
            end
          elseif (charclass == "Red Robe") then
            for i = 1, tonumber(slot), 1 do
			  if (spell_forcemissile) then
                table.insert(memtable, "'force mis' ")
			  end
            end
          elseif (charclass == "Black Robe") then
            --for i = 1, tonumber(slot), 1 do
              -- table.insert(memtable, "'acid mist' ")
            --end
          end
        elseif (tonumber(circle) == 8) then                 --***** CIRCLE 8 SPELL AUTOMEM ****
          if (charclass == "Cleric") then
			if (spell_steelskin) then
				for i = 1, tonumber(slot), 1 do
				  if (spell_steelskin) then
					table.insert(memtable, "'steelsk' ")
				  end
				end
			end
          elseif (charclass == "Druid") then
			if (spell_stoneskin) then
				for i = 1, tonumber(slot), 1 do
				  table.insert(memtable, "'st sk' ")
				end
			end
          elseif (charclass == "Red Robe") then
            for i = 1, tonumber(slot), 1 do
			  if (spell_shockingblast) then
                table.insert(memtable, "'shock blast' ")
			  end
            end
          elseif (charclass == "Shaman") then
            for i = 1, tonumber(slot), 1 do
			  if (spell_healingwave) then
				table.insert(memtable, "'healing wave' ")
			  end
            end
          elseif (charclass == "Black Robe") then
            for i = 1, tonumber(slot), 1 do
              table.insert(memtable, "'devastation' ")
            end
          end
        elseif (tonumber(circle) == 9) then
          if (charclass == "Red Robe") then
            for i = 1, tonumber(slot), 1 do
				if (spell_powerwordstun) then
					table.insert(memtable, "'p w s' ")
				elseif (spell_thunderbolt) then
					table.insert(memtable, "'thunderbolt' ")
				end
            end
          elseif (charclass == "Black Robe") then
			for i = 1, tonumber(slot), 1 do
				if (spell_nightmare) then
				  table.insert(memtable, "'nightmare' ")
				elseif (spell_rend) then
				  table.insert(memtable, "'rend' ")
				end
			end
          end
        end
        --make sure to not have trailing space or "You must specify a spell name." error
        if (#memtable >= 1) then
          Send("mem "..Trim(table.concat(memtable)))
        end
      end
      --print("circle: "..circle..", slot: "..slot)
    end --end for
  end
end

function decrement(name,lines,wildcards)
  local tmpvar = ""
  local tmpcount = 0
  local isshamanbot = false

  if (GetVariable("isShamanbot") ~= nil) then
	  if (tonumber(GetVariable("isShamanbot")) == 1 ) then
		  isshamanbot = true
	  end
  end

  if (name ~= nil and lines ~= nil and wildcards ~= nil and #wildcards > 0) then
    tmpvar = Trim(wildcards[1])
    tmpcount = tonumber(GetVariable(tmpvar))
    if (tmpcount <= 1 and isshamanbot == false) then
      tmpcount = 0
    else
      tmpcount = tmpcount - 1	--for shamanbot, ancestral spirit, ritual voyage, and regen can go negative for divine
    end
    SetVariable(tostring(tmpvar),tonumber(tmpcount))
  end
end

--***********************************************************************
--* Called by incrementSpellCount via alias
--***********************************************************************
function increment(name,lines,wildcards)
  local tmpvar = ""
  local tmpcount = 0

  if (name ~= nil and lines ~= nil and wildcards ~= nil and #wildcards > 0) then
    tmpvar = Trim(wildcards[1])
    tmpcount = tonumber(GetVariable(tmpvar))
    tmpcount = tmpcount + 1
	Note(tmpvar..": "..tmpcount)
    SetVariable(tostring(tmpvar),tonumber(tmpcount))
  end
end

--***********************************************************************
--* this is used when a Shaman channels a spirit at target to improve mem
--***********************************************************************
function incrementSpellCount(name,lines,wildcards)
  local spellcountstr = ""
  local spellcount = 0
  local tmpstr            = ""

  if (#wildcards > 0) then
    tmpstr = Trim(wildcards[1])
    if (#tmpstr > 20) then
      tmpstr = string.sub(tmpstr,1,20)  --truncate spell strings that exceed certain length
    end
    spellcountstr = string.gsub(tmpstr, " ","").."count"
  end

  interpretstr = "increment "..spellcountstr

  if (GetVariable(spellcountstr) == nil) then
    SetVariable(spellcountstr,0)
  end

  Execute(interpretstr)                       --- actually execute the increment now
  --Note(interpretstr)
end

function decrementSpellCount(name,lines,wildcards)
  local spellcountstr = ""
  local spellcount = 0
  local healcount         = 0
  local curecriticalcount = 0
  local cureseriouscount  = 0
  local curelightcount    = 0
  local gtmode            = tonumber(GetVariable("gtmode"))
  local interpretstr      = ""
  local tmpstr            = ""
  require "socket"
  SetVariable("lastcasttime", tonumber(round(socket.gettime(),3)))

  if (#wildcards > 0) then
    tmpstr = Trim(wildcards[1])
    if (#tmpstr > 20) then
      tmpstr = string.sub(tmpstr,1,20)  --truncate spell strings that exceed certain length
    end
    spellcountstr = string.gsub(tmpstr, " ","").."count"
  end
  --Note(spellcountstr)
  if (spellcountstr == "regeneratecount" or spellcountstr == "healcount" or spellcountstr == "curemassivecount" or spellcountstr == "curecriticalcount" or spellcountstr == "cureseriouscount" or spellcountstr == "curelightcount") then
    interpretstr = "decrement "..spellcountstr..";showheals;endheal"
  elseif (spellcountstr == "healboostcount" or spellcountstr == "ritualvoyagecount" or spellcountstr == "ancestralspiritcount") then
    interpretstr = "decrement "..spellcountstr..";showheals" --need this for divine regenerate
  elseif (spellcountstr == "animatedeadcount" or spellcountstr == "darknesscount" or spellcountstr == "harmcount" or spellcountstr == "restorationcount" or spellcountstr == "summoncount") then
    interpretstr = "decrement "..spellcountstr..";decrement healcount;showheals"
  elseif (spellcountstr == "stoneskincount") then
    interpretstr = "decrement "..spellcountstr..";endstone"
  else
    interpretstr = "decrement "..spellcountstr
  end

  if (GetVariable(spellcountstr) == nil) then
    SetVariable(spellcountstr,0)
  end

  Execute(interpretstr)                       --- actually execute the decrement now
  if (spellcountstr == "veiloficecount") then
    SetVariable("lastveiltime", tonumber(round(socket.gettime(),3)))
  end
  if (spellcountstr == "healcount") then
    healcount         = tonumber(GetVariable("healcount"))
    curecriticalcount = tonumber(GetVariable("curecriticalcount"))
    cureseriouscount  = tonumber(GetVariable("cureseriouscount"))
    curelightcount    = tonumber(GetVariable("curelightcount"))

    if (gtmode == 0) then
    elseif (gtmode == 1) then
      Send("gt ["..healcount.."]heal ["..curecriticalcount.."]cure critical ["..cureseriouscount.."]cure serious ["..curelightcount.."]cure light")
    elseif (gtmode == 2 and healcount <= 3) then
    --elseif (gtmode == 2 ) then
      if (healcount == 1) then
        Send("gt *** "..healcount.." HEAL REMAINING ***")
      else
        Send("gt *** "..healcount.." HEALS REMAINING ***")
      end
    elseif (gtmode == 3 and healcount <= 3) then
    --elseif (gtmode == 3 ) then
      Send("gt --- "..healcount.." HEAL(S) LEFT ---")
    elseif (gtmode == 4 and healcount <= 3) then
    --elseif (gtmode == 4 ) then
      if (healcount == 1) then
        Send("gt "..healcount.." heal remaining")
      else
        Send("gt "..healcount.." heals remaining")
      end
    elseif (gtmode == 5 and healcount <= 3) then
    --elseif (gtmode == 5 ) then
      Send("gt --- ["..healcount.."]heal ---")
    end
	--if (IsSocketConnected()) then
	--	Execute("cgt ["..healcount.."]heal ["..curecriticalcount.."]cure critical ["..cureseriouscount.."]cure serious ["..curelightcount.."]cure light")
	--end
  end --endif
end
--*************************************
--* For relo help for mages with relocate
--*************************************
function reloHelp(name,lines,wildcards)
  Note("** Kalaman   : Zardonna")
  Note("** Solace    : Theobald")
  Note("** Balifor   : Petrin")
  Note("** Tarsis    : Darvinus")
  Note("** Haven     : Canstin")
  Note("** Vingaard  : Torenth")
  Note("** Caergoth  : Mirus")
  Note("** Wayreth   : Ferris (Rr)")
  Note("** Wayreth   : Lotus (Br)")
  Note("** Palanthas : Anatole")
  Note("** Neraka    : Snaggle") --per James on 10/31/16, used to be Molg
end

function randomdelaystatus(name,lines,wildcards)
  local rmin = 0.0
  local rmax = 0.0

  if (GetVariable("randomDelayMin") ~= nil) then
    rmin = tonumber(GetVariable("randomDelayMin"))
  end

  if (GetVariable("randomDelayMax") ~= nil) then
	rmax = tonumber(GetVariable("randomDelayMax"))
  end

  if (tonumber(GetVariable("isRandomDelay")) == 1) then
	Note("** Random delay   : Enabled ("..tostring(rmin).." to ("..tostring(rmax).."+1) seconds)")
  else
	Note("** Random delay   : Disabled ("..tostring(rmin).." to ("..tostring(rmax).."+1) seconds)")
  end
end --end randomdelaystatus

function healbotstatus(name,lines,wildcards)
  if (tonumber(GetVariable("isHealbot")) == 1) then
    Note("** Healbot        : Enabled")
  else
    Note("** Healbot        : Disabled")
  end

  if (tonumber(GetVariable("healmode")) == 1) then
    Note("** Heal mode      : heal at v.bad")
  elseif (tonumber(GetVariable("healmode")) == 2) then
    Note("** Heal mode      : heal at bad")
  elseif (tonumber(GetVariable("healmode")) == 3) then
    Note("** Heal mode      : heal at fair")
  elseif (tonumber(GetVariable("healmode")) == 4) then
    Note("** Heal mode      : heal for pk")
  end


  if (tonumber(GetVariable("isCureOn")) == 1) then
    Note("** Cure serious   : Enabled")
  else
    Note("** Cure serious   : Disabled")
  end

  Execute("autoreststatus;setmain;assstatus;showhealertype;brewstatus;scribestatus;medstatus;sethdelay")

  Note("** tryingheal     : "..tostring(GetVariable("tryingheal")))
end

function doAutorestBeforeTick(names,lines,wildcards)
  local isfighting = false
  local memticks = tonumber(GetVariable("memticks"))
  local isautorest = false

  if (tonumber(GetVariable("isfighting")) == 1) then
    isfighting = true
  end
  if (tonumber(GetVariable("isautorest")) == 1) then
    isautorest = true
  end

  if (isfighting and memticks > 1 and isautorest) then
    Send("rest")
    --if ()
  end
end

function doThreeBeforeTick(names,lines,wildcards)
  local isautorest     = false
  local isfighting     = false
  local isautocommune  = false
  local isautobrew     = false
  local isautoscribe   = false
  local isautomeditate = false
  local memticks       = 0
  local curelightcount = 0
  local waterbreathcount = 0
  local charclass      = GetVariable("charClass")
  local ismoving       = false
  local iscombat       = false
  require "socket"
  local currentroundclock = round(socket.gettime(),3)
  local lastroundclock  = 0

  if (GetVariable("lastroundclock")) then
    lastroundclock = tonumber(GetVariable("lastroundclock"))
  end

  if (tonumber(GetVariable("isfighting")) == 1) then
    isfighting = true
  end
  if (tonumber(GetVariable("isautorest")) == 1) then
    isautorest = true
  end
  if (tonumber(GetVariable("isautocommune")) == 1) then
    isautocommune = true
  end
  if (tonumber(GetVariable("isautobrew")) == 1) then
    isautobrew = true
  end
  if (tonumber(GetVariable("isautoscribe")) == 1) then
    isautoscribe = true
  end
  if (tonumber(GetVariable("isautomeditate")) == 1) then
    isautomeditate = true
  end
  curelightcount = tonumber(GetVariable("curelightcount"))
  waterbreathcount = tonumber(GetVariable("waterbreathcount"))
  memticks       = tonumber(GetVariable("memticks"))


  if (GetVariable("lastmovetime") ~= nil) then
    if (math.abs(os.clock() - tonumber(GetVariable("lastmovetime"))) <= 10) then
      ismoving = true
    end
    --Note("** ismoving: "..tostring(ismoving))
  end
  --Note("** combat diff: "..tostring(math.abs(currentroundclock - lastroundclock)))
  if (math.abs(currentroundclock - lastroundclock) < 10) then
    iscombat = true
  end
  --Note("** iscombat: "..tostring(iscombat))

  if (not isfighting and memticks > 1 and isautorest and (not ismoving or iscombat)) then
    Send("rest")
    if (isautomeditate and charclass == "Cleric") then
      Send("meditate")
    elseif (isautocommune and charclass == "Druid") then
      Send("commune")
    elseif (charclass == "Red Robe") then
      Send("deep focus")
    end
    if (isautobrew and curelightcount > 0) then
      Send("brew 'cure light'")
    elseif (isautobrew and waterbreathcount > 0) then
      Send("brew 'water breath'")
    end
    if (isautoscribe and curelightcount > 0) then
      Send("scribe 'cure light'")
    elseif (isautoscribe and waterbreathcount > 0) then
      Send("scribe 'water breath'")
    end
    --  #timer {wait6} {+6} {#if {$isautorest} {doautostand}}
  end
end

function doTenAfterTick(names,lines,wildcards)
  local isautorescue = false
  local isskybot     = false
  local isautobuff   = false
  local isfighting   = false
  local isstanding   = false
  local charclass    = GetVariable("charClass")
  local iscombat     = false
  local lastroundclock  = 0
  local currentroundclock  = 0
  local doCheckMem   = false

  require "socket"
  currentroundclock = round(socket.gettime(),3)
  if (GetVariable("lastroundclock")) then
    lastroundclock = tonumber(GetVariable("lastroundclock"))
  end

  --this logic is just so at login, don't spam mem when not actually in game
  if (GetVariable("isCheckMem") ~= nil) then
	if (tonumber(GetVariable("isCheckMem")) == 1) then
		doCheckMem = true
	else
		doCheckMem = false
	end
  end

  if (math.abs(currentroundclock - lastroundclock) < 10) then
    iscombat = true
  end
  if (tonumber(GetVariable("isautorescue")) == 1) then
    isautorescue = true
  end
  if (tonumber(GetVariable("isskybot")) == 1) then
    isskybot = true
  end
  if (tonumber(GetVariable("isfighting")) == 1) then
    isfighting = true
  end
  if (tonumber(GetVariable("isstanding")) == 1) then
    isstanding = true
  end
  if (tonumber(GetVariable("isautobuff")) == 1) then
    isautobuff = true
  end

  if (charclass == "Cleric" or charclass == "Druid" or string.ends(charclass," Robe") or charclass == "Paladin" or charclass == "Magic User" or charclass == "Dark Knight" or charclass == "Shaman") then
    if (doCheckMem == true) then
		Send("mem")
	end
    if (isstanding and not isfighting and isautobuff and not iscombat) then
      Execute("dobuffs")
    end
  elseif (isskybot or isautorescue) then
    Send("group")
  end
end

function CheckRoomChange(name,lines,wildcards)
  --Note("room name: ".."%1")
  --http://lua-users.org/wiki/OsLibraryTutorial
  local isdebug = false
  require "socket"
  local currentroundclock = round(socket.gettime(),3)
  local currentroomname = ""

  if (tonumber(GetVariable("isdebug")) == 1) then
    isdebug = true
  end

  if (wildcards ~= nil and #wildcards > 0 and Trim(wildcards[1]) ~= "-------") then
    currentroomname = Trim(wildcards[1])
    --Note("room name: "..currentroomname)
  end
  if (currentroomname ~= GetVariable("currentroom")) then
    SetVariable("lastroom",GetVariable("currentroom"))
    SetVariable("currentroom",currentroomname)
    if (isdebug) then Note("** Time between room changes: "..math.abs(os.clock() - tonumber(GetVariable("lastmovetime")))) end
    SetVariable("lastmovetime",os.clock())
  end
end

function parseWizEye(name,lines,wildcards)
  local arrivalname = ""
  local arrivalmethod = ""
  local arrivaldir = ""
  local sb = {}
  pattern1 = "^Through your wizard%'s eye: ([A-Z][a-z]+) has ([a-z%s]+) the ([a-z]+) exit\.$"
  pattern2 = "^Through your wizard%'s eye: ([A-Z][a-z]+) (teleports) ([a-z]+)\.$"

  if (wizeyeArr ~= nil and #wizeyeArr > 0 ) then
    for i,v in ipairs(wizeyeArr) do
      arrivalname,arrivalmethod,arrivaldir = string.match(wizeyeArr[i],pattern1)
      table.insert(sb,arrivalname)
    end

  end
  if (arrivalmethod == "left through") then arrivalmethod = "left" end
  if (arrivalmethod == "arrived from") then arrivalmethod = "arrived" end
  if (arrivalmethod ~= nil and arrivaldir~= nil) then
    Note("** EYE("..#sb..") "..arrivalmethod.." "..arrivaldir.." : "..table.concat(sb," "))
    --Send("gt ** EYE("..#sb..") "..arrivalmethod.." "..arrivaldir.." : "..table.concat(sb," "))
    Send("ct ** EYE("..#sb..") "..arrivalmethod.." "..arrivaldir.." : "..table.concat(sb," "))
  else
    Note("** Weirdness in parseWizEye: arrivalname, arrivalmethod, or arrivaldir is null")
  end
end

function doLostConcentration(name,lines,wildcards)
  local tryingheal = false
  local tryingstone = false
  local healtype = tonumber(GetVariable("healtype"))
  if (tonumber(GetVariable("tryingheal")) == 1) then
    tryingheal = true
  end

  if (tonumber(GetVariable("tryingstone")) == 1) then
    tryingstone = true
  end

  if (tryingheal and healtype == 1) then
    Execute("decrement healcount")
  elseif (tryingheal and healtype == 2) then
    Execute("decrement curecriticalcount")
  elseif (tryingheal and healtype == 3) then
    Execute("decrement cureseriouscount")
  elseif (tryingheal and healtype == 4) then
    Execute("decrement curelightcount")
  elseif (tryingheal and healtype == 5) then  -- new druid as of 3Q18
    Execute("decrement curemassivecount")
  end

  if (tryingstone) then
    Execute("decrement stoneskincount")
    Execute("endstone")
  end

  if (tryingheal) then
    Execute("endheal")
  end
end

function doCureBlind(name,lines,wildcards)
  local cureblindnesscount = 0
  local ishealbot = false
  local charclass = GetVariable("charClass")
  local currenthp = 0
  local maxhp = 0
  local tryingheal = 0
  local healcount = 0

  if (GetVariable("healcount") ~= nil) then
    healcount = tonumber(GetVariable("healcount"))
  end
  if (GetVariable("tryingheal") ~= nil) then
    tryingheal = tonumber(GetVariable("tryingheal"))
  end
  if (GetVariable("charMaxHP") ~= nil) then
    maxhp = tonumber(GetVariable("charMaxHP"))
  end
  if (GetVariable("charCurrentHP") ~= nil) then
    currenthp = tonumber(GetVariable("charCurrentHP"))
  end
  if (GetVariable("cureblindnesscount") ~= nil) then
    cureblindnesscount = tonumber(GetVariable("cureblindnesscount"))
  end
  if (tonumber(GetVariable("isHealbot"))==1) then
    ishealbot = true
  end
  if (ishealbot and charclass == "Cleric") then
    if ((currenthp / maxhp) > 0.65 and cureblindnesscount > 0) then
      Execute("doautostand;cast 'cure blindness' me")
    elseif (healcount > 0 and tryingheal == 0) then
      SetVariable("tryingheal",1)
      Execute("doautostand;cast 'heal' me")
    elseif (cureblindnesscount > 0) then
      Execute("doautostand;cast 'cure blindness' me")
    end
  end
end

--***********************************************
--* Need to check if bash fired and return a return value
--* This function is important otherwise will preempt autorescue by terminating round processing
--* retvalue = true if bash
--* retvalue = false if no bash available
--***********************************************
--function doAutoBash(name,lines,wildcards)
function doAutoBash()
  local isautoassist = false
  local charclass = GetVariable("charClass")
  local target1 = ""
  local isfighting = false
  local lastbashtime = 0
  local isautobash = false
  local isstanding = false
  local retvalue = false
  require "socket"

  if (GetVariable("isstanding") ~= nil and tonumber(GetVariable("isstanding"))== 1) then
    isstanding = true
  end
  if (GetVariable("isfighting") ~= nil and tonumber(GetVariable("isfighting"))== 1) then
    isfighting = true
  end
  if (GetVariable("isautobash") ~= nil and tonumber(GetVariable("isautobash"))== 1) then
    isautobash = true
  end
  if (GetVariable("lastbashtime") ~= nil) then
    lastbashtime = tonumber(GetVariable("lastbashtime"))
  end

  --note average time between bashes is 8.3 seconds, so set to 8.2
  if (isautobash and isfighting and charclass == "Warrior" and math.abs(round(socket.gettime(),3) - lastbashtime) > 8.2) then
    SetVariable("lastbashtime", tonumber(round(socket.gettime(),3)))
    if (GetVariable("bashtarget") ~= nil) then
       Execute("doautostand;bash "..tostring(GetVariable("bashtarget")))
    else
       Execute("doautostand;bash")
    end
    retvalue = true   --Returning true will mean a bash went off and stop further round processing
  end
  return retvalue
end

function doAutoPunch(name,lines,wildcards)
  local isautoassist = false
  local charclass = GetVariable("charClass")
  local target1 = ""
  local isfighting = false
  local isautobash = false
  local isstanding = false

  if (GetVariable("isstanding") ~= nil and tonumber(GetVariable("isstanding"))== 1) then
    isstanding = true
  end
  if (GetVariable("isfighting") ~= nil and tonumber(GetVariable("isfighting"))== 1) then
    isfighting = true
  end
  if (GetVariable("isautobash") ~= nil and tonumber(GetVariable("isautobash"))== 1) then
    isautobash = true
  end

  if (isautobash and isfighting and charclass == "Warrior") then
    Execute("doautostand;punch")
  end
end
--****************************************************************
--* for druid refresh, massrefresh, and mass fly logic
--****************************************************************
function mvgroupparse(name,lines,wildcards)
  local flycount = 0
  local massflycount = 0
  local charname = GetVariable("charname")
  local charclass = GetVariable("charClass")
  local charlevel = 1
  local refreshcount = 0
  local isflygroup = false
  local needflyArr = {}
  local xmlTest = parseGroupXML()
  local castcount = 0
  local groupsizecount = 0


  --check if druid has certain spells before using them
  local spell_refresh = false
  local spell_massrefresh = false

  if (GetVariable("spell_massrefresh") ~= nil) then
	if (tonumber(GetVariable("spell_massrefresh")) == 1) then
		spell_massrefresh = true
	end
  end

  if (GetVariable("spell_refresh") ~= nil) then
	if (tonumber(GetVariable("spell_refresh")) == 1) then
		spell_refresh = true
	end
  end

  -- Need all these spell counts for divine 'mass refresh', should also be initialized in ResetMem
  local calmcount = 0
  local entanglecount = 0
  local icestormcount = 0
  local iceskincount = 0
  local massrefreshcount = 0
  local wordofrecallcount = 0
  local passwithouttracecount = 0
  local cureseriouscount = 0

  -- Need all these spell counts for divine 'refresh', should also be initialized in ResetMem
  local burninghandscount = 0
  local clearskiescount = 0
  local curelightcount = 0
  local faeriefirecount = 0
  local infravisioncount = 0
  --note refreshcount initiated earlier
  local silencecount = 0
  local stinkingcloudcount = 0
  local sustenancecount = 0
  local waterbreathcount = 0

  if (GetVariable("charLevel") ~= nil) then
    charlevel = tonumber(GetVariable("charLevel"))
  end

  if (GetVariable("isflygroup") ~= nil and tonumber(GetVariable("isflygroup")) == 1) then
    isflygroup = true
  end

  --need spell counts for divine refresh
  if (GetVariable("burninghandscount") ~= nil ) then
    burninghandscount = tonumber(GetVariable("burninghandscount"))
  end
  if (GetVariable("clearskiescount") ~= nil ) then
    clearskiescount = tonumber(GetVariable("clearskiescount"))
  end
  if (GetVariable("curelightcount") ~= nil ) then
    curelightcount = tonumber(GetVariable("curelightcount"))
  end
  if (GetVariable("faeriefirecount") ~= nil ) then
    faeriefirecount = tonumber(GetVariable("faeriefirecount"))
  end
  if (GetVariable("infravisioncount") ~= nil ) then
    infravisioncount = tonumber(GetVariable("infravisioncount"))
  end
  if (GetVariable("silencecount") ~= nil ) then
    silencecount = tonumber(GetVariable("silencecount"))
  end
  if (GetVariable("stinkingcloudcount") ~= nil ) then
    stinkingcloudcount = tonumber(GetVariable("stinkingcloudcount"))
  end
  if (GetVariable("sustenancecount") ~= nil ) then
    sustenancecount = tonumber(GetVariable("sustenancecount"))
  end
  if (GetVariable("waterbreathcount") ~= nil ) then
    waterbreathcount = tonumber(GetVariable("waterbreathcount"))
  end

  --need spell counts for divine mass refresh
  if (GetVariable("massflycount") ~= nil ) then
    massflycount = tonumber(GetVariable("massflycount"))
  end
  if (GetVariable("flycount") ~= nil ) then
    flycount = tonumber(GetVariable("flycount"))
  end
  if (GetVariable("refreshcount") ~= nil ) then -- <--- really for just regular refresh
    refreshcount = tonumber(GetVariable("refreshcount"))
  end
  if (GetVariable("calmcount") ~= nil ) then
    calmcount = tonumber(GetVariable("calmcount"))
  end
  if (GetVariable("entanglecount") ~= nil ) then
    entanglecount = tonumber(GetVariable("entanglecount"))
  end
  if (GetVariable("icestormcount") ~= nil ) then
    icestormcount = tonumber(GetVariable("icestormcount"))
  end
  if (GetVariable("iceskincount") ~= nil ) then
    iceskincount = tonumber(GetVariable("iceskincount"))
  end
  if (GetVariable("massrefreshcount") ~= nil ) then
    massrefreshcount = tonumber(GetVariable("massrefreshcount"))
  end
  if (GetVariable("wordofrecallcount") ~= nil ) then
    wordofrecallcount = tonumber(GetVariable("wordofrecallcount"))
  end
  if (GetVariable("passwithouttracecount") ~= nil ) then
    passwithouttracecount = tonumber(GetVariable("passwithouttracecount"))
  end
  if (GetVariable("cureseriouscount") ~= nil ) then
    cureseriouscount = tonumber(GetVariable("cureseriouscount"))
  end

  for charName in string.gmatch(xmlTest,"<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='[a-z%.]+' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='N' position='[a-z]+' ismain='[YN]'  />")
  do
    if (charName ~= nil and #charName > 0) then
      table.insert(needflyArr, charName)
    end
  end
  if (needflyArr ~= nil and #needflyArr >= 1) then
    if (massflycount > 0 and isflygroup and charclass == "Druid" and #needflyArr > 3) then
      Execute("doautostand;cast 'mass fly'")
    elseif (flycount > 0 and isflygroup) then
      for i,v in ipairs(needflyArr) do
        if (castcount < flycount and charclass ~= "Shaman") then
          Execute("doautostand;cast 'fly' "..v)
          castcount = castcount + 1
        elseif (castcount == flycount) then
          break
        end
      end
    end
    --[[
  else
    if (needflyArr == nil) then
      Note("** needflyArr is nil")
    else
      Note("** needflyArr is 0 or somethin")
    end
    --]]
  end


  for charName,charmove in string.gmatch(xmlTest,"<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='[a-z%.]+' move='([a-z]+)' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='[YN]'  />")
	  do
		groupsizecount = groupsizecount + 1
	  end
  --  Note("** groupsizecount: "..tostring(groupsizecount))
  --adefghistux
  --fatigued
  --exhausted
  for charName,charmove in string.gmatch(xmlTest,"<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='[a-z%.]+' move='([adefghistux]+)' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='[YN]'  />")
  do
    if (charName ~= nil and #charName > 0 and charclass == "Druid" and charmove ~= nil and (charmove == "exhausted" or charmove=="fatigued")) then
      if (groupsizecount > 1 and spell_massrefresh and (cureseriouscount + calmcount + entanglecount + icestormcount + iceskincount + massrefreshcount + wordofrecallcount + passwithouttracecount) > 0) then
		Execute("doautostand;cast 'mass refresh'")
        break --for mass refresh, break the loop
      elseif (spell_refresh and (refreshcount + burninghandscount + clearskiescount + curelightcount + faeriefirecount + infravisioncount + silencecount + stinkingcloudcount + sustenancecount + waterbreathcount) > 0) then
        Execute("doautostand;cast 'refresh' "..charName)
        --Note("refresh "..charName)
        --for regular refresh, keep looping
      end
    end
  end
end

function scanCount(name,lines,wildcards)
  local northcount = 0
  local eastcount  = 0
  local southcount = 0
  local westcount  = 0
  local upcount    = 0
  local downcount  = 0
  --EnableTrigger("combatpattern3", false)
  SetVariable("isscan",1)

  if (wildcards ~= nil and #wildcards > 0) then
    if (wildcards[1] == "north") then
      SetVariable("northcount",0)
      SetVariable("eastcount",0)
      SetVariable("southcount",0)
      SetVariable("westcount",0)
      SetVariable("upcount",0)
      SetVariable("downcount",0)
    end
    SetVariable("scandir", wildcards[1])
  end

end

function addBuff(name,lines,wildcards)
  local isfound = false
  if (wildcards ~= nil and #wildcards > 0) then
    for i,v in ipairs(buffsArr) do
      if (v == Trim(wildcards[1])) then
        isfound = true
        break
      end
    end
  end
  if (not isfound) then
    table.insert(buffsArr,Trim(string.lower(wildcards[1])))
  end
end

function removeBuff(name,lines,wildcards)
  local isfound = false
  local foundindex = 0
  if (wildcards ~= nil and #wildcards > 0 and buffsArr ~= nil) then
    for i,v in ipairs(buffsArr) do
      if (v == Trim(wildcards[1])) then
        foundindex = i
        isfound = true
        break
      end
    end
  end
  if (isfound) then
    table.remove(buffsArr,foundindex)
  end
end

--More logic than doCheckParalyzed because it will check if you are in combat
function doCheckBlind(name,lines,wildcards)
  local charclass = GetVariable("charClass")
  local ismainhealer = false
  local cureblindnesscount = tonumber(GetVariable("cureblindnesscount"))
  require "socket"
  local currentroundclock = round(socket.gettime(),3)
  local lastroundclock  = 0
  local iscombat       = false
  local maintankhealth    = ""
  local maintank          = ""
  local health            = ""
  local target            = ""
  local xmlTest           = ""
  local t = {}

  if (#groupArr <= 1) then
    SetVariable("maintank",charname)
  end
  maintank = GetVariable("maintank")

  if (GetVariable("lastroundclock")) then
    lastroundclock = tonumber(GetVariable("lastroundclock"))
  end

  if (math.abs(currentroundclock - lastroundclock) < 10) then
    iscombat = true
  end

  if (tonumber(GetVariable("isMainHealer")) == 1) then
    ismainhealer = true
  end

  if (wildcards ~= nil and not ismainhealer   --is GROUP healer
          and #wildcards > 0 and isTargetInGroup(Trim(wildcards[1]))
          and cureblindnesscount > 0 and iscombat
          and (charclass == "Shaman" or charclass == "Cleric")) then
    EnableTrigger("cureblind_trigger",false)
    Send("cast 'cure blindness' "..Trim(wildcards[1]))
  elseif (wildcards ~= nil and ismainhealer  --is MAIN healer
          and #wildcards > 0 and isTargetInGroup(Trim(wildcards[1]))
          and cureblindnesscount > 0 and iscombat
          and (charclass == "Shaman" or charclass == "Cleric")) then
    xmlTest = parseGroupXML()
    t = xmlTest:split("\n")
    --**************************************************
    --** Check if main tank health not at risk    ******
    --**************************************************
    for i, v in ipairs(t) do
      --target,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([a-z%.]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='Y'  />")
      target,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([a-z%.]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='Y'  />")
      if (target ~= nil and health ~= nil and #target > 0 and #health > 0) then
        --Note("main found, target: "..target..", health:"..health)
        break
      end
    end
    maintankhealth = health
    if (maintankhealth == "good" or maintankhealth == "v.good" or maintankhealth == "perfect") then
      EnableTrigger("cureblind_trigger",false)
      Send("cast 'cure blindness' "..Trim(wildcards[1]))
    end  --endif maintank health > = "good"
  end
end

function doCheckEntangled(name,lines,wildcards)
  local charclass = GetVariable("charClass")
  local ismainhealer = false
  local freeactioncount = tonumber(GetVariable("freeactioncount"))
  local maintankhealth    = ""
  local maintank          = ""
  local health            = ""
  local target            = ""
  local xmlTest           = ""
  local t = {}

  if (tonumber(GetVariable("isMainHealer")) == 1) then
    ismainhealer = true
  end

  if (wildcards ~= nil
          and not ismainhealer
          and #wildcards > 0
          and isTargetInGroup(Trim(wildcards[1]))
          and freeactioncount > 0
          and (charclass == "Druid" or charclass == "Red Robe"
          or charclass == "Cleric" or charclass == "Dark Knight"
          or charclass == "Paladin" or charclass == "Black Robe"
          or charclass == "White Robe")) then
    EnableTrigger("disentangle_trigger",false)
    Send("cast 'free action' "..Trim(wildcards[1]))
  elseif (wildcards ~= nil and ismainhealer
          and #wildcards > 0 and isTargetInGroup(Trim(wildcards[1]))
          and freeactioncount > 0 and charclass == "Cleric") then
    xmlTest = parseGroupXML()
    t = xmlTest:split("\n")
    --**************************************************
    --** Check if main tank health not at risk    ******
    --**************************************************
    for i, v in ipairs(t) do
      --target,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([a-z%.]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='Y'  />")
      target,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([a-z%.]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='Y'  />")
      if (target ~= nil and health ~= nil and #target > 0 and #health > 0) then
        --Note("main found, target: "..target..", health:"..health)
        break
      end
    end
    maintankhealth = health
    if (maintankhealth == "good" or maintankhealth == "v.good" or maintankhealth == "perfect") then
      EnableTrigger("disentangle_trigger",false)
      Send("cast 'free action' "..Trim(wildcards[1]))
    end --endif maintank health > = "good"
  end
end

--like doCheckParalyzed, no combat check, but need wildscards[2]
function doCheckWebbed(name,lines,wildcards)
  local charclass = GetVariable("charClass")
  local ismainhealer = false
  local freeactioncount = tonumber(GetVariable("freeactioncount"))
  local maintankhealth    = ""
  local maintank          = ""
  local health            = ""
  local target            = ""
  local xmlTest           = ""
  local t = {}

  if (tonumber(GetVariable("isMainHealer")) == 1) then
    ismainhealer = true
  end

  if (wildcards ~= nil
          and not ismainhealer
          and #wildcards > 1
          and isTargetInGroup(Trim(wildcards[2]))
          and freeactioncount > 0
          and (charclass == "Druid" or charclass == "Red Robe"
          or charclass == "Cleric" or charclass == "Dark Knight"
          or charclass == "Paladin" or charclass == "Black Robe"
          or charclass == "White Robe")) then
    EnableTrigger("unweb_trigger",false)
    Send("cast 'free action' "..Trim(wildcards[2]))
  elseif (wildcards ~= nil and ismainhealer
          and #wildcards > 1 and isTargetInGroup(Trim(wildcards[2]))
          and freeactioncount > 0 and charclass == "Cleric") then
    xmlTest = parseGroupXML()
    t = xmlTest:split("\n")
    --**************************************************
    --** Check if main tank health not at risk    ******
    --**************************************************
    for i, v in ipairs(t) do
      --target,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([a-z%.]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='Y'  />")
      target,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([a-z%.]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='Y'  />")
      if (target ~= nil and health ~= nil and #target > 0 and #health > 0) then
        --Note("main found, target: "..target..", health:"..health)
        break
      end
    end
    maintankhealth = health
    if (maintankhealth == "good" or maintankhealth == "v.good" or maintankhealth == "perfect") then
      EnableTrigger("unweb_trigger",false)
      Send("cast 'free action' "..Trim(wildcards[2]))
    end --endif maintank health > = "good"
  end
end


--More logic than doCheckParalyzed because it will check if you are in combat
function doCheckHeld(name,lines,wildcards)
  local charclass = GetVariable("charClass")
  local ismainhealer = false
  local freeactioncount = tonumber(GetVariable("freeactioncount"))
  require "socket"
  local currentroundclock = round(socket.gettime(),3)
  local lastroundclock  = 0
  local iscombat       = false
  local maintankhealth    = ""
  local maintank          = ""
  local health            = ""
  local target            = ""
  local xmlTest           = ""
  local t = {}

  if (GetVariable("lastroundclock")) then
    lastroundclock = tonumber(GetVariable("lastroundclock"))
  end

  if (math.abs(currentroundclock - lastroundclock) < 10) then
    iscombat = true
  end

  if (tonumber(GetVariable("isMainHealer")) == 1) then
    ismainhealer = true
  end

  if (wildcards ~= nil and not ismainhealer
          and #wildcards > 0 and isTargetInGroup(Trim(wildcards[1]))
          and freeactioncount > 0 and iscombat
          and (charclass == "Druid" or charclass == "Red Robe" or charclass == "Cleric"
          or charclass == "Paladin" or charclass == "Dark Knight"
          or charclass == "Black Robe" or charclass == "White Robe")) then
    Send("cast 'free action' "..Trim(wildcards[1]))
    EnableTrigger("unfreeze_trigger",false)
  elseif (wildcards ~= nil and ismainhealer
          and #wildcards > 0 and isTargetInGroup(Trim(wildcards[1]))
          and freeactioncount > 0 and iscombat
          and charclass == "Cleric") then
    xmlTest = parseGroupXML()
    t = xmlTest:split("\n")
    --**************************************************
    --** Check if main tank health not at risk    ******
    --**************************************************
    for i, v in ipairs(t) do
      --target,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([a-z%.]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='Y'  />")
      target,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([a-z%.]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='Y'  />")
      if (target ~= nil and health ~= nil and #target > 0 and #health > 0) then
        --Note("main found, target: "..target..", health:"..health)
        break
      end
    end
    maintankhealth = health
    if (maintankhealth == "good" or maintankhealth == "v.good" or maintankhealth == "perfect") then
      Send("cast 'free action' "..Trim(wildcards[1]))
      EnableTrigger("unfreeze_trigger",false)
    end --endif maintank health > = "good"
  elseif (charclass == "Thief") then
    --still need to check if stabbot
	Note("** stabbot check")
  end
end

function doCheckParalyzed(name,lines,wildcards)
  local charclass = GetVariable("charClass")
  local ismainhealer = false
  local freeactioncount = tonumber(GetVariable("freeactioncount"))
  local maintankhealth    = ""
  local maintank          = ""
  local health            = ""
  local target            = ""
  local xmlTest           = ""
  local t = {}

  if (tonumber(GetVariable("isMainHealer")) == 1) then
    ismainhealer = true
  end

  if (wildcards ~= nil
          and not ismainhealer
          and #wildcards > 0
          and isTargetInGroup(Trim(wildcards[1]))
          and freeactioncount > 0
          and (charclass == "Druid" or charclass == "Red Robe"
              or charclass == "Cleric" or charclass == "Dark Knight"
              or charclass == "Paladin" or charclass == "Black Robe"
              or charclass == "White Robe")) then
    EnableTrigger("unparalyze_trigger",false)
    Send("cast 'free action' "..Trim(wildcards[1]))
  elseif (wildcards ~= nil and ismainhealer
            and #wildcards > 0 and isTargetInGroup(Trim(wildcards[1]))
            and freeactioncount > 0 and charclass == "Cleric") then
      xmlTest = parseGroupXML()
      t = xmlTest:split("\n")
      --**************************************************
      --** Check if main tank health not at risk    ******
      --**************************************************
      for i, v in ipairs(t) do
        --target,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([a-z%.]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='Y'  />")
        target,health = string.match(v,"^<char name='([A-Z][a-z]+)' class='[A-Z][A-Z]' imt='[YN]' hits='([a-z%.]+)' move='[a-z]+' wb='[YN]' invis='[YN]' here='Y' mem='%d+' light='%d+' flying='[YN]' position='[a-z]+' ismain='Y'  />")
        if (target ~= nil and health ~= nil and #target > 0 and #health > 0) then
          --Note("main found, target: "..target..", health:"..health)
          break
        end
      end
      maintankhealth = health
      if (maintankhealth == "good" or maintankhealth == "v.good" or maintankhealth == "perfect") then
        EnableTrigger("unparalyze_trigger",false)
        Send("cast 'free action' "..Trim(wildcards[1]))
      end --endif maintank health > = "good"
  elseif (charclass == "Thief") then
    --still need to check if stabbot
	Note("** stabbot check")
  end
end

function isPKTarget(name)
  local t = {}
  local retvalue = false
  if (GetVariable("pklist") ~= nil and #tostring(GetVariable("pklist")) > 0) then
    t = split(GetVariable("pklist"), ",")
    for i,v in ipairs(t) do
      if (string.match(v,name)) then
        retvalue = true
        break
      end
    end
  else
    retvalue = false
  end
  return retvalue
end
--Needs a little work on remove, ie. if target is John,Johnny, and pkrem John, not to have residual ,ny
function removePKTarget(name,lines,wildcards)
  local pklist = GetVariable("pklist")
  local t = {}
  local isfound = false
  if (wildcards ~= nil and #wildcards > 0 and #wildcards[1] > 0) then
    if (pklist == nil) then
      Note("** PK list is empty.")
    elseif (pklist ~= nil and #pklist == 0) then
      Note("** PK list is empty.")
    elseif (pklist ~= nil and #pklist > 0) then
      t = split(pklist,",")
      for i,v in ipairs(t) do
        if string.match(v,Trim(Proper(wildcards[1]))) then
          isfound = true
          if (string.match(pklist,","..Trim(Proper(wildcards[1])))) then
            pklist = string.gsub(pklist,","..Trim(Proper(wildcards[1])),"")  --leading comma
            SetVariable("pklist",pklist)
          elseif (string.match(pklist,Trim(Proper(wildcards[1]))..",")) then
            pklist = string.gsub(pklist,Trim(Proper(wildcards[1]))..",","")  --trailing comma
            SetVariable("pklist",pklist)
          else
            pklist = string.gsub(pklist,Trim(Proper(wildcards[1])),"")  -- no leading or trailing comma
            SetVariable("pklist",pklist)
          end
        end
      end
      if (not isfound) then
        Note("** "..Trim(Proper(wildcards[1])).." was not found in PK list.")
      end
    end
    Execute("pklist")
  else
    Note("** Syntax: pkrem <target>")
  end
end

function addPKTarget(name,lines,wildcards)
  local pklist = GetVariable("pklist")
  local t = {}
  local isfound = false

  if (wildcards ~= nil and #wildcards > 0 and #wildcards[1] > 0) then
    if (pklist == nil) then
      SetVariable("pklist",Trim(Proper(wildcards[1])))
    elseif (pklist ~= nil and #pklist == 0) then
      SetVariable("pklist",Trim(Proper(wildcards[1])))
    elseif (pklist ~= nil and #pklist > 0) then
      t = split(pklist,",")
      Note("length: "..#t)
      for i,v in ipairs(t) do
        if (string.match(v,"^"..Trim(Proper(wildcards[1])).."$")) then
          isfound = true
          break
        end
      end
      if (isfound) then
        Note("** "..Trim(Proper(wildcards[1])).." is already in the PK list.")
      else
        SetVariable("pklist",GetVariable("pklist")..","..Trim(Proper(wildcards[1])))
      end
    end
    Execute("pkstatus")
  else
    Note("** Syntax: pkadd <target>")
  end
end

function checkPKTarget(name,lines,wildcards)
  local ispk = false
  local isautodisable = false
  local charclass = GetVariable("charClass")

  if (tonumber(GetVariable("pkautodisable")) == 1) then
    isautodisable = true
  end

  if (tonumber(GetVariable("ispk")) == 1) then
    ispk = true
  end

  if (ispk and isPKTarget(Trim(wildcards[1]))) then
    Execute(GetVariable("engageaction").." "..Trim(wildcards[1]))
    if (isautodisable) then
      Execute("pkoff")
    end
  end
end
