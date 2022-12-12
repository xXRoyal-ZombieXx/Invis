local CENV = {}
local Tfind, sort, concat, pack, unpack;
do
    local table = table
    Tfind, sort, concat, pack, unpack = 
        table.find, 
        table.sort,
        table.concat,
        table.pack,
        table.unpack
end
local GetService = game.GetService

--IMPORT [var]
local Services = {
    Workspace = GetService(game, "Workspace");
    UserInputService = GetService(game, "UserInputService");
    ReplicatedStorage = GetService(game, "ReplicatedStorage");
    StarterPlayer = GetService(game, "StarterPlayer");
    StarterPack = GetService(game, "StarterPack");
    StarterGui = GetService(game, "StarterGui");
    TeleportService = GetService(game, "TeleportService");
    CoreGui = GetService(game, "CoreGui");
    TweenService = GetService(game, "TweenService");
    HttpService = GetService(game, "HttpService");
    TextService = GetService(game, "TextService");
    MarketplaceService = GetService(game, "MarketplaceService");
    Chat = GetService(game, "Chat");
    Teams = GetService(game, "Teams");
    SoundService = GetService(game, "SoundService");
    Lighting = GetService(game, "Lighting");
    ScriptContext = GetService(game, "ScriptContext");
    Stats = GetService(game, "Stats");
}
local lower, upper, Sfind, split, sub, format, len, match, gmatch, gsub, byte;
do
    local string = string
    lower, upper, Sfind, split, sub, format, len, match, gmatch, gsub, byte = 
        string.lower,
        string.upper,
        string.find,
        string.split, 
        string.sub,
        string.format,
        string.len,
        string.match,
        string.gmatch,
        string.gsub,
        string.byte
end

local random, floor, round, abs, atan, cos, sin, rad;
do
    local math = math
    random, floor, round, abs, atan, cos, sin, rad = 
        math.random,
        math.floor,
        math.round,
        math.abs,
        math.atan,
        math.cos,
        math.sin,
        math.rad
end
local GetChildren = function(inst)
	return inst:GetChildren()
end
local FindFirstChildWhichIsA = function(inst,query)
	return inst:FindFirstChildWhichIsA(query)
end
setmetatable(Services, {
    __index = function(Table, Property)
        local Ret, Service = pcall(GetService, game, Property);
        if (Ret) then
            Services[Property] = Service
            return Service
        end
        return nil
    end,
    __mode = "v"
});
local JSONEncode, JSONDecode, GenerateGUID = 
    Services.HttpService.JSONEncode, 
    Services.HttpService.JSONDecode,
    Services.HttpService.GenerateGUID
local IsA = function(inst,query)
	return inst:IsA(query)
end
local Hooks = {
    AntiKick = false,
    AntiTeleport = false,
    NoJumpCooldown = false,
}
local ProtectInstance, SpoofInstance, SpoofProperty;
local pInstanceCount = {0, 0}; -- instancecount, primitivescount
local ProtectedInstances = setmetatable({}, {
    __mode = "v"
});
local SpoofedInstances = setmetatable({}, {
        __mode = "v"
    });
    local SpoofedProperties = {}
    Hooks.SpoofedProperties = SpoofedProperties

    local otherCheck = function(instance, n)
        if (IsA(instance, "ImageLabel") or IsA(instance, "ImageButton")) then
            ProtectedInstances[#ProtectedInstances + 1] = instance
            return;
        end

        if (IsA(instance, "BasePart")) then
            pInstanceCount[2] = math.max(pInstanceCount[2] + (n or 1), 0);
        end
    end
    
ProtectInstance = function(Instance_)
        if (not Tfind(ProtectedInstances, Instance_)) then
            ProtectedInstances[#ProtectedInstances + 1] = Instance_
            local descendants = Instance_:GetDescendants();
            pInstanceCount[1] += 1 + #descendants;
            for i = 1, #descendants do
                otherCheck(descendants[i]);
            end
            local dAdded = Instance_.DescendantAdded:Connect(function(descendant)
                pInstanceCount[1] += 1
                otherCheck(descendant);
            end);
            local dRemoving = Instance_.DescendantRemoving:Connect(function(descendant)
                pInstanceCount[1] = math.max(pInstanceCount[1] - 1, 0);
                otherCheck(descendant, -1);
            end);
            otherCheck(Instance_);

            Instance_.Name = sub(gsub(GenerateGUID(Services.HttpService, false), '-', ''), 1, random(25, 30));
            Instance_.Archivable = false
        end
    end
function invis()
		local Root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
		local OldPos = Root.CFrame
		local Seat = Instance.new("Seat");
		local Weld = Instance.new("Weld");
		Root.CFrame = CFrame.new(9e9, 9e9, 9e9);
		wait(.2);
		Root.Anchored = true
		ProtectInstance(Seat);
		Seat.Transparency = 1
		Seat.Parent = Services.Workspace
		Seat.CFrame = Root.CFrame
		Seat.Anchored = false
		Weld.Parent = Seat
		Weld.Part0 = Seat
		Weld.Part1 = Root
		Root.Anchored = false
		Seat.CFrame = OldPos
		CENV.Seat = Seat
		CENV.Weld = Weld
		for i, v in next, GetChildren(Root.Parent) do
			if (IsA(v, "BasePart") or IsA(v, "MeshPart") or IsA(v, "Part")) then
				CENV[v] = v.Transparency
				v.Transparency = v.Transparency <= 0.3 and 0.4 or v.Transparency
			elseif (IsA(v, "Accessory")) then
				local Handle = FindFirstChildWhichIsA(v, "MeshPart") or FindFirstChildWhichIsA(v, "Part");
				if (Handle) then
					CENV[Handle] = Handle.Transparency
					Handle.Transparency = Handle.Transparency <= 0.3 and 0.4 or Handle.Transparency    
				end
			end
		end
end
local Destroy = function(inst)
	inst:Destroy()
end
function unInvis()
	local CmdEnv = CENV
    local Seat = CmdEnv.Seat
    local Weld = CmdEnv.Weld
    if (Seat and Weld) then
        Weld.Part0 = nil
        Weld.Part1 = nil
        Destroy(Seat);
        Destroy(Weld);
        CmdEnv.Seat = nil
        CmdEnv.Weld = nil
        for i, v in next, CmdEnv do
            if (type(v) == 'number') then
                i.Transparency = v
            end
        end
    end
end
local Invisible = false
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()local Window = Rayfield:CreateWindow({
   Name = "Invis",
   LoadingTitle = "Invis",
   LoadingSubtitle = "by RoyalX",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "sirius", -- The Discord invite code, do not include discord.gg/
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Sirius Hub",
      Subtitle = "Key System",
      Note = "Join the discord (discord.gg/sirius)",
      FileName = "SiriusKey",
      SaveKey = true,
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = "Hello"
   }
})
local Tab = Window:CreateTab("Invis", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Keybinds")
local Keybind = Tab:CreateKeybind({
   Name = "Invis",
   CurrentKeybind = "E",
   HoldToInteract = false,
   Flag = "Keybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Keybind)
		invis()
   end,
})
local Keybind = Tab:CreateKeybind({
   Name = "UnInvis",
   CurrentKeybind = "B",
   HoldToInteract = false,
   Flag = "Keybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Keybind)
		unInvis()
   end,
})

